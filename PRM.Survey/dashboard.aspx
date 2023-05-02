<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/User.master" CodeFile="dashboard.aspx.cs" Inherits="dashboard" %>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <div>
        <h1 class="mt-5">Patient Details</h1>

        <div class="col-md-6 mt-5">

            <% if (ClientSession.IsSurveyCompleted)
               { %>

            <div class="form-group row">
                <label class="col-sm-6 col-form-label"><strong>Survey Title End</strong></label>
                <div class="col-sm-6">
                    <p class="form-control-static"><%= ClientSession.UserData["SurveyTitleEnd"] %></p>
                </div>
            </div>
            <% }
               else
               { %>
            <div class="form-group row">
                <label class="col-sm-6 col-form-label"><strong>Survey Title Start</strong></label>
                <div class="col-sm-6">
                    <p class="form-control-static"><%= ClientSession.UserData["SurveyTitleStart"] %></p>
                </div>
            </div>
            <% }  %>

            <div class="form-group row">
                <label class="col-sm-6 col-form-label"><strong>Practice Name</strong></label>
                <div class="col-sm-6">
                    <p class="form-control-static"><%= ClientSession.UserData["PracticeName"] %></p>
                </div>
            </div>
            <div class="form-group row">
                <label class="col-sm-6 col-form-label"><strong>Provider Name</strong></label>
                <div class="col-sm-6">
                    <p class="form-control-static"><%= ClientSession.UserData["ProviderName"] %></p>
                </div>
            </div>
            <div class="form-group row">
                <label class="col-sm-6 col-form-label"><strong>Patient Name</strong></label>
                <div class="col-sm-6">
                    <p class="form-control-static"><%= ClientSession.UserData["PatientName"] %></p>
                </div>
            </div>
            <div class="form-group row">
                <label class="col-sm-6 col-form-label"><strong>Patient DOB</strong></label>
                <div class="col-sm-6">
                    <p class="form-control-static"><%= ClientSession.UserData["PatientDOB"] %></p>
                </div>
            </div>
            <div class="form-group row">
                <label class="col-sm-6 col-form-label"><strong>Patient MRN</strong></label>
                <div class="col-sm-6">
                    <p class="form-control-static"><%= ClientSession.UserData["PatientMRN"] %></p>
                </div>
            </div>
            <div class="form-group row">
                <label class="col-sm-6 col-form-label"><strong>Survey Type Name</strong></label>
                <div class="col-sm-6">
                    <p class="form-control-static"><%= ClientSession.UserData["SurveyTypeName"] %></p>
                </div>
            </div>
            <div class="form-group row">
                <label class="col-sm-6 col-form-label"><strong>Survey Instructions</strong></label>
                <div class="col-sm-6">

                    <% if (ClientSession.IsSurveyCompleted)
                       { %>
                    <p class="form-control-static"><%= ClientSession.UserData["SurveyThankYouMsg"] %></p>
                    <% }
                       else
                       { %>
                    <p class="form-control-static"><%= ClientSession.UserData["SurveyInstructions"] %></p>
                    <% }  %>

                    
                </div>
            </div>
            <div class="form-group row">
                <label class="col-sm-6 col-form-label"><strong>Survey Status Type Name</strong></label>
                <div class="col-sm-6">
                    <p class="form-control-static"><%= ClientSession.UserData["SurveyStatusTypeName"] %></p>
                </div>
            </div>
            <div class="form-group row">
                <label class="col-sm-6 col-form-label"><strong>Survey Disclaimer</strong></label>
                <div class="col-sm-6">
                    <p class="form-control-static"><%= ClientSession.UserData["SurveyDisclaimer"] %></p>
                </div>
            </div>
        </div>
        <div align="center" class="mt-5">
            <% if (ClientSession.IsSurveyCompleted)
               { %>
            <asp:Button CssClass="btn btn-success" Text="Close" PostBackUrl="/login.aspx" runat="server" />
            <% }
               else
               { %>
            <asp:Button CssClass="btn btn-success" Text="Start Survey" PostBackUrl="/survey.aspx" runat="server" />
            <% }  %>
        </div>
    </div>
</asp:Content>

