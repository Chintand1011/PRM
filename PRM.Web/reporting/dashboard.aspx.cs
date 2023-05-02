using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using PatientPortal.DataLayer;
using Telerik.Charting;
using Telerik.Web.UI;

public partial class dashboard : BasePage
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            DisplayGraph(null, null);
            DisplayMultipleSeries(null, null);
        }

    }

    #region For Single Series


    private void DisplayGraph(Int32? year, Int32? month)
    {

        var cmdParams = new Dictionary<string, object> { 
                                                             {"@PracticeID", ClientSession.PracticeID}, 
                                                             {"@Year", year ?? (object)DBNull.Value},
                                                             {"@Month", month ?? (object)DBNull.Value},
                                                             { "@UserID", ClientSession.UserID}
                                                            };
        var data = SqlHelper.ExecuteDataTableProcedureParams("web_pr_report_transcount_get", cmdParams);

        var chartTitle = data.Rows[0]["Title"].ToString();
        var leftTitle = data.Rows[0]["yLabel"].ToString();
        var rightLabel = data.Rows[0]["y1Label"].ToString();
        ViewState["SingleSeries"] = data.Rows[0]["Series"].ToString();

        var columnSeries = new ColumnSeries { Name = rightLabel, DataFieldY = "y1Value" };
        columnSeries.LabelsAppearance.Visible = true;

        radGraph.ChartTitle.Text = chartTitle;
        radGraph.PlotArea.Series.Add(columnSeries);
        radGraph.PlotArea.XAxis.DataLabelsField = "xLabel";
        radGraph.PlotArea.YAxis.TitleAppearance.Text = leftTitle;
        radGraph.DataSource = data;
        radGraph.DataBind();
    }


    protected void btnLoadSeries_OnClick(object sender, EventArgs e)
    {
        radGraph.PlotArea.Series.Clear();
        var seriesName = ViewState["SingleSeries"].ToString();
        var category = Int32.Parse(hdnCategory.Value);
        Int32 year;
        switch (seriesName.ToLower())
        {
            case "year":
                ViewState["Year"] = category;
                DisplayGraph(category, null);
                break;

            case "month":
                ViewState["Month"] = category;
                year = Int32.Parse(ViewState["Year"].ToString());
                DisplayGraph(year, category);
                break;
            case "day":
                year = Int32.Parse(ViewState["Year"].ToString());
                var month = Int32.Parse(ViewState["Month"].ToString());
                var date = new DateTime(year, month, category).ToShortDateString();
                Response.Redirect("~/transaction/search.aspx?date=" + date);
                break;
        }

    }

    protected void btnRefreshEligibiltyGraph_OnClick(object sender, EventArgs e)
    {
        radGraph.PlotArea.Series.Clear();
        ViewState["Year"] = null;
        ViewState["SingleSeries"] = null;
        DisplayGraph(null, null);
    }


    #endregion


    #region For Multiple Series


    private void DisplayMultipleSeries(Int32? year, Int32? month)
    {

        var cmdParams = new Dictionary<string, object> { 
                                                             {"@PracticeID", ClientSession.PracticeID}, 
                                                             {"@Year", year ?? (object)DBNull.Value},
                                                             {"@Month", month ?? (object)DBNull.Value},
                                                             { "@UserID", ClientSession.UserID}
                                                       };


        var data = SqlHelper.ExecuteDataTableProcedureParams("web_pr_report_transcount_get", cmdParams);
        for (var i = 1; i <= 5; i++)
        {
            var label = data.Rows[0][string.Format("y{0}Label", i)].ToString();

            var columnSeries = new ColumnSeries { Name = label };
            columnSeries.LabelsAppearance.Visible = true;

            foreach (var record in data.AsEnumerable())
            {
                var value = record[string.Format("y{0}Value", i)].ToString();
                columnSeries.Items.Add(new SeriesItem
                {
                    YValue = Math.Round(decimal.Parse(value), 2)
                });
            }

            radGraphMultipleSeries.PlotArea.Series.Add(columnSeries);
        }


        var chartTitle = data.Rows[0]["Title"].ToString();
        var leftTitle = data.Rows[0]["yLabel"].ToString();
        ViewState["Series"] = data.Rows[0]["Series"].ToString();
        radGraphMultipleSeries.ChartTitle.Text = chartTitle;

        radGraphMultipleSeries.PlotArea.XAxis.DataLabelsField = "xLabel";
        radGraphMultipleSeries.PlotArea.YAxis.TitleAppearance.Text = leftTitle;
        radGraphMultipleSeries.DataSource = data;
        radGraphMultipleSeries.DataBind();

    }


    protected void btnLoadMultipleSeries_OnClick(object sender, EventArgs e)
    {
        radGraphMultipleSeries.PlotArea.Series.Clear();
        var seriesName = ViewState["Series"].ToString();
        var category = Int32.Parse(hdnMultipleSeriesCategory.Value);
        Int32 year;
        switch (seriesName.ToLower())
        {
            case "year":
                ViewState["YearOfMultipleSeries"] = category;
                DisplayMultipleSeries(category, null);
                break;

            case "month":
                ViewState["MonthOfMultipleSeries"] = category;
                year = Int32.Parse(ViewState["YearOfMultipleSeries"].ToString());
                DisplayMultipleSeries(year, category);
                break;
            case "day":
                year = Int32.Parse(ViewState["YearOfMultipleSeries"].ToString());
                var month = Int32.Parse(ViewState["MonthOfMultipleSeries"].ToString());
                var date = new DateTime(year, month, category).ToShortDateString();
                Response.Redirect("~/transaction/search.aspx?date=" + date);
                break;
        }

    }
    
    protected void btnRefreshEligibiltyMultipleGraph_OnClick(object sender, EventArgs e)
    {
        radGraphMultipleSeries.PlotArea.Series.Clear();
        ViewState["YearOfMultipleSeries"] = null;
        ViewState["MonthOfMultipleSeries"] = null;
        DisplayMultipleSeries(null, null);
    }


    #endregion


}