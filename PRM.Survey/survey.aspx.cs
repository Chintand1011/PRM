using System;
using System.Activities.Expressions;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.UI.WebControls;
using Models;
using PatientPortal.DataLayer;

public partial class survey : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Page.IsPostBack) return;

        LoadQuestionsIntoViewState();
        LoadQuestionsAnswers();

        var questionId = ClientSession.UserData["CurrentSurveyQuestionID"].ToInteger();
        var surveyStatusTypeId = ClientSession.UserData["Surveystatustypeid"].ToInteger();

        if (questionId > 0 && surveyStatusTypeId == 2) // 2 means InProgress
        {
            var orderId = GetNextOrderId(questionId, true);
            ShowQuestionAndAnswers(orderId);
        }
        else
        {
            ShowQuestionAndAnswers();
        }
    }

    #region Show Question and answer

    private void LoadQuestionsIntoViewState()
    {
        var cmdParams = new Dictionary<string, object>
        {
            {"@SurveyTypeID", ClientSession.UserData["SurveyTypeID"]}
        };

        var questions = SqlHelper.ExecuteDataTableProcedureParams("web_pr_surveyquestion_get", cmdParams).AsEnumerable();
        var questionList = Enumerable.Select(questions, question => new SurveyQuestion
        {
            SurveyQuestionId = question["SurveyQuestionID"].ToInteger(),
            SurveyQuestionTypeId = question["SurveyQuestionTypeId"].ToInteger(),
            OrderId = question["OrderId"].ToInteger(),
            Question = question["QuestionName"].ToString(),
            QuestionTitle = question["QuestionTitle"].ToString()
        }).ToList();

        ViewState["Questions"] = questionList;
    }

    private void LoadQuestionsAnswers()
    {
        var cmdParams = new Dictionary<string, object>
        {
            {"@SurveyId", ClientSession.UserData["SurveyID"]}
        };

        var questionAnswers = SqlHelper.ExecuteDataTableProcedureParams("web_pr_surveyquestionanswer_get", cmdParams).AsEnumerable();
        var questions = GetSavedQuestions();

        foreach (var question in questions)
        {
            var questionAnswer = questionAnswers.SingleOrDefault(x => x["SurveyQuestionID"].ToInteger() == question.SurveyQuestionId);
            if (questionAnswer != null)
            {
                question.SurveyAnswerId = questionAnswer["SurveyAnswerID"].ToInteger();
            }
        }

    }

    private void ShowQuestionAndAnswers(int? orderId = null)
    {
        var savedQuestions = GetSavedQuestions();

        // Getting question and display
        var questionOrder = (orderId ?? 1);
        var question = savedQuestions.Single(x => x.OrderId == questionOrder);
        headingQuestion.InnerText = questionOrder + ". " + question.Question;

        // Displaying question title
        ltQuestionTitle.Text = !string.IsNullOrEmpty(question.QuestionTitle) ? string.Format("<h4 class='mt-5'>{0}</h4>", question.QuestionTitle) : string.Empty;


        // Saving order to further user
        ViewState["QuestionId"] = question.SurveyQuestionId;


        // Managing Panels and displaying Question based upon type
        HideAndDisableAllPanels();


        EnablePanelAndPopulateField(question);


        // Managing next and prev button
        HidePrevAndNextButton(savedQuestions, questionOrder);
    }

    #region Manage panels

    private void EnablePanelAndPopulateField(SurveyQuestion question)
    {
        // Getting question answers
        var cmdParams = new Dictionary<string, object>
        {
            {"@SurveyQuestionID", question.SurveyQuestionId}
        };

        var questionAnswers = SqlHelper.ExecuteDataTableProcedureParams("web_pr_surveyanswer_get", cmdParams).AsEnumerable();


        switch (question.SurveyQuestionTypeId)
        {
            case (int)SurveyQuestionType.Textbox:
            case (int)SurveyQuestionType.TextboxMultiple:
                ShowTextboxPanelAndPopulate(question, questionAnswers);
                break;

            case (int)SurveyQuestionType.RadioButton:
                ShowRadioButtonPanelAndPopulate(question, questionAnswers);
                break;
            case (int)SurveyQuestionType.RadioButtonWithQuestion:
                ShowRadioButtonPanelAndPopulate(question, questionAnswers);
                ShowTextboxPanelAndPopulate(question, questionAnswers);
                break;


            case (int)SurveyQuestionType.CheckboxMultipleWithQuestion:
                ShowCheckboxPanelAndPopulate(question, questionAnswers);
                ShowTextboxPanelAndPopulate(question, questionAnswers);
                break;
            case (int)SurveyQuestionType.CheckboxMultiple:
                ShowCheckboxPanelAndPopulate(question, questionAnswers);
                break;

            case (int)SurveyQuestionType.DropdownSingle:
            case (int)SurveyQuestionType.DropdownCombo:
                ShowDropdownPanelAndPopulate(question, questionAnswers);
                break;

        }
    }


    private void ShowRadioButtonPanelAndPopulate(SurveyQuestion question, IEnumerable<DataRow> questionAnswers)
    {
        // Enabling panel
        pnlRadioButton.Visible = true;
        pnlRadioButton.Enabled = true;

        // Adding new items
        PopulateListForControls(rdQuestionAnswer.Items, questionAnswers, question);
    }

    private void ShowTextboxPanelAndPopulate(SurveyQuestion question, IEnumerable<DataRow> questionAnswers)
    {

        var questionTypeId = question.SurveyQuestionTypeId;

        // Enabling panel
        pnlTextbox.Visible = true;
        pnlTextbox.Enabled = true;

        // Selecting the textmode
        txtQuestionAnswer.TextMode = questionTypeId == (int) SurveyQuestionType.TextboxMultiple
            ? TextBoxMode.MultiLine
            : TextBoxMode.SingleLine;

        // Removing existing options
        txtQuestionAnswer.Text = string.Empty;

    }


    private void ShowCheckboxPanelAndPopulate(SurveyQuestion question, IEnumerable<DataRow> questionAnswers)
    {
        // Enabling panel
        pnlCheckbox.Visible = true;
        pnlCheckbox.Enabled = true;

        // Adding new items
        PopulateListForControls(chklist.Items, questionAnswers, question);
    }

    private void ShowDropdownPanelAndPopulate(SurveyQuestion question, IEnumerable<DataRow> questionAnswers)
    {
        // Enabling panel
        pnlDropdown.Visible = true;
        pnlDropdown.Enabled = true;

        // Adding new items
        PopulateListForControls(drpList.Items, questionAnswers, question);
    }

    #endregion





    private void HidePrevAndNextButton(IEnumerable<SurveyQuestion> questions, int orderId)
    {
        var isFirstQuestion = questions.Min(x => x.OrderId) == orderId;
        btnPrev.Visible = !isFirstQuestion;

        var isLastQuestion = questions.Max(x => x.OrderId) == orderId;
        btnNext.Text = isLastQuestion ? "Save & Finish" : "Next Question";

    }

    #endregion

    #region Save answer of questions

    protected void SaveAnswer(object sender, EventArgs e)
    {

        var button = sender as Button;
        var questionId = ViewState["QuestionId"].ToInteger();
        var isNextButton = button.Attributes["IsNext"].ToBoolean();
        var surveyAnswerId = rdQuestionAnswer.SelectedValue;

        if (isNextButton && string.IsNullOrEmpty(surveyAnswerId))
        {
            ShowNotificationMessage(NotificationType.Danger, "Please choose at least one option");
            return;
        }

        // Save answerId  to populate the selected value
        var question = GetSavedQuestions().Single(x => x.SurveyQuestionId == questionId);
        question.SurveyAnswerId = surveyAnswerId.ToInteger();

        // Saving question answer
        var cmdParams = new Dictionary<string, object>
        {
            {"@SurveyID", ClientSession.UserData["SurveyID"]},
            {"@SurveyQuestionID", questionId},
            {"@SurveyAnswerID", surveyAnswerId},
        };

        SqlHelper.ExecuteScalarProcedureParams("web_pr_surveyquestionanswer_add", cmdParams);

        // Getting next order
        var orderId = GetNextOrderId(questionId, isNextButton);
        if (orderId > 0)
        {
            ShowQuestionAndAnswers(orderId);
        }
        else
        {
            ClientSession.IsSurveyCompleted = true;
            Response.Redirect("~/dashboard.aspx");
        }
    }


    private int GetNextOrderId(int questionId, bool isNextButton)
    {
        var allQuestions = GetSavedQuestions();
        var question = allQuestions.Single(x => x.SurveyQuestionId == questionId);
        var orderId = isNextButton ? question.OrderId + 1 : question.OrderId - 1;

        return orderId > allQuestions.Max(x => x.OrderId) ? 0 : orderId;

    }


    #endregion

    #region Common methods

    private List<SurveyQuestion> GetSavedQuestions()
    {
        if (ViewState["Questions"] == null)
        {
            throw new InvalidOperationException("No data available but system trying to get");
        }

        return ViewState["Questions"] as List<SurveyQuestion>;
    }

    private void HideAndDisableAllPanels()
    {
        pnlRadioButton.Visible = false;
        pnlRadioButton.Enabled = false;
        pnlTextbox.Visible = false;
        pnlTextbox.Enabled = false;
        pnlDropdown.Visible = false;
        pnlDropdown.Enabled = false;
        pnlCheckbox.Visible = false;
        pnlCheckbox.Enabled = false;
    }

    private static void PopulateListForControls(ListItemCollection list, IEnumerable<DataRow> questionAnswers, SurveyQuestion question)
    {
        list.Clear();

        foreach (var questionAnswer in questionAnswers)
        {
            list.Add(new ListItem
            {
                Text = "&nbsp;" + questionAnswer["Name"],
                Value = questionAnswer["SurveyAnswerID"].ToString(),
                Selected = questionAnswer["SurveyAnswerID"].ToInteger() == question.SurveyAnswerId
            });
        }
    }

    #endregion

}