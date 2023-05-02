<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/User.master" CodeFile="search.aspx.cs"
    Inherits="search" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/1.6.1/jquery.min.js"></script>
    <script type="text/javascript" src="../Scripts/jquery-movetoend.js"></script>
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>Patient Search</h1>
            </div>
            <div class="bodyMain">
                <h2>Use any combination of filters to search for your practice patients. Results will
                    automatically update as you type in the first or last name.</h2>
                <table width="100%">
                    <tr>
                        <td width="180">
                            <div class="lblInputR">
                                <asp:Label ID="lblLastName" runat="server" TabIndex="1">Last Name:</asp:Label>
                            </div>
                        </td>
                        <td width="200">
                            <div class="boxInputL">
                                <asp:TextBox ID="txtLastName" field="lastName" CssClass="searchTxt" runat="server" autofocus TabIndex="2"></asp:TextBox>
                            </div>
                        </td>
                        <td width="220">
                            <div class="boxInputR">
                                <telerik:radcombobox id="cmbLocations" runat="server" width="200" emptymessage="All Locations"
                                    allowcustomtext="False" markfirstmatch="True" datatextfield="Abbr" datavaluefield="LocationID" tabindex="6">
                                </telerik:radcombobox>
                            </div>
                        </td>
                        <td>
                            <asp:ImageButton ID="btnAddNewPatient" ImageUrl="../Content/Images/btn_addnew.gif"
                                runat="server" Style="float: left; margin: 0px 0px 0px 80px;" OnClick="btnAddNewPatient_Click" TabIndex="9" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="lblInputR">
                                <asp:Label ID="lblFirstName" runat="server">First Name:</asp:Label>
                            </div>
                        </td>
                        <td>
                            <div class="boxInputL">
                                <asp:TextBox ID="txtFirstName" field="firstName" CssClass="searchTxt" runat="server" TabIndex="2"></asp:TextBox>
                            </div>
                        </td>
                        <td>
                            <div class="boxInputR">
                                <telerik:radcombobox id="cmbProviders" runat="server" width="200" emptymessage="All Providers"
                                    allowcustomtext="False" markfirstmatch="True" datatextfield="ProviderAbbr" datavaluefield="ProviderID" tabindex="7">
                                </telerik:radcombobox>
                            </div>
                        </td>
                        <td>
                            <asp:ImageButton ID="btnAddPayPatient" ImageUrl="../Content/Images/btn_addandpay.gif" TabIndex="10"
                                runat="server" Style="float: left; margin: 0px 0px 0px 80px;" OnClick="btnAddPayPatient_OnClick" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <div class="lblInputR">
                                <asp:Label ID="lblDOB" runat="server">Date of Birth:</asp:Label>
                            </div>
                        </td>
                        <td>
                            <div class="boxInputL">
                                <telerik:raddatepicker id="dtDOB" mindate="1/1/1900" onkeyup="validateEnterEvent(event)"
                                    runat="server" tabindex="3">
                                </telerik:raddatepicker>
                            </div>
                        </td>
                        <td>
                            <div class="boxInputR">
                                <telerik:radcombobox id="cmbStatusTypes" runat="server" width="200" emptymessage="All Statuses"
                                    allowcustomtext="False" markfirstmatch="True" datatextfield="Abbr" datavaluefield="StatusTypeID" tabindex="8">
                                </telerik:radcombobox>
                            </div>
                        </td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>
                            <div class="lblInputR">
                                <asp:Label ID="lblSocialMRN" runat="server">Social or MRN:</asp:Label>
                            </div>
                        </td>
                        <td>
                            <div class="boxInputL">
                                <asp:TextBox ID="txtSocialMRN" field="socialMrn" CssClass="searchTxt" runat="server" TabIndex="4"></asp:TextBox>
                            </div>
                        </td>
                        <td></td>
                        <td></td>
                    </tr>
                    <tr>
                        <td>
                            <div class="lblInputR">
                                <asp:Label ID="lblPhoneNumber" runat="server">Phone Number:</asp:Label>
                            </div>
                        </td>
                        <td>
                            <div class="boxInputL">
                                <asp:TextBox ID="txtPhoneNumber" field="phoneNumber" CssClass="searchTxt" runat="server" TabIndex="5"></asp:TextBox>
                            </div>
                        </td>
                        <td>
                            <asp:HiddenField ID="hdnRequestedField" runat="server" />
                            <asp:ImageButton runat="server" ImageUrl="../Content/Images/btn_search.gif" ID="btnSearch" TabIndex="11"
                                Style="float: right; margin: 0px 0px 0px 0px;" OnClientClick="setValues()" OnClick="btnSearch_Click" />
                        </td>
                        <td>
                            <asp:ImageButton runat="server" ImageUrl="~/Content/Images/btn_clear.gif" ID="btnClear" TabIndex="12"
                                Style="float: left; margin: 0px 0px 0px 80px;" OnClick="btnClear_OnClick" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <br />
                            <hr />
                        </td>
                    </tr>
                </table>
                <div style="overflow-x: auto">
                    <telerik:radgrid id="grdPatients" runat="server" allowsorting="True" allowpaging="True"
                        onneeddatasource="grdPatients_NeedDataSource" pagesize="20" onitemcommand="grdPatients_ItemCommand"
                        enableembeddedbasestylesheet="True" enableembeddedskins="True" skin="Default">
                        <ClientSettings EnableRowHoverStyle="true" EnablePostBackOnRowClick="true">
                            <Selecting AllowRowSelect="True"></Selecting>
                        </ClientSettings>
                        <MasterTableView AutoGenerateColumns="False" DataKeyNames="PatientID,AccountID" NoMasterRecordsText="&nbsp; <br>&nbsp; &nbsp; No patients match your search. Start typing a first or last name and results will update immediately.<br>&nbsp;">
                            <Columns>
                                <telerik:GridBoundColumn HeaderText="Last Name" DataField="NameLast">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="First Name" DataField="NameFirst">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Date of Birth" DataField="DOB" DataFormatString="{0:MM/dd/yyyy}">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="MRN" DataField="MRN">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="SSN4" DataField="PatientSSN4">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Phone" DataField="PhonePri">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Address" DataField="CityState">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Location" DataField="Location">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Provider" DataField="Provider">
                                </telerik:GridBoundColumn>
                                <telerik:GridBoundColumn HeaderText="Status" DataField="Status">
                                </telerik:GridBoundColumn>
                                <telerik:GridButtonColumn CommandName="EditPatient" HeaderText="Edit" ButtonType="ImageButton"
                                    ImageUrl="~/Content/Images/edit.png">
                                </telerik:GridButtonColumn>
                            </Columns>
                        </MasterTableView>
                    </telerik:radgrid>
                </div>
            </div>
            <asp:HiddenField ID="hdnDate" runat="server" />
            <telerik:radwindowmanager id="RadWindow" showcontentduringload="True" visiblestatusbar="False"
                visibletitlebar="True" reloadonshow="True" runat="Server" width="700px" height="500px" modal="True"
                enableembeddedbasestylesheet="False" enableembeddedskins="False" restrictionzoneid="divMainContent"
                skin="CareBlue" behaviors="Pin,Close,Move,Resize,Reload" style="z-index: 3000">
                <Windows>
                    <telerik:RadWindow runat="server" ID="popupPayLite" Width="720" Height="675" NavigateUrl="~/report/pc_add_popup_lite.aspx" DestroyOnClose="True">
                    </telerik:RadWindow>
                </Windows>
            </telerik:radwindowmanager>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Scripts" runat="server" ContentPlaceHolderID="Scripts">
    <script type="text/javascript" src="../Scripts/jquery-typing.js"></script>
    <script type="text/javascript">

        $(document).ready(function () {
            registerTypingEvents();
        });

        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function () {
            $(function () {
                if ($("#<%=hdnRequestedField.ClientID%>").val() == "lastName") {
                    var lastName = $("#<%=txtLastName.ClientID%>");
                    lastName.focus();
                    lastName.caretToEnd();
                } else if ($("#<%=hdnRequestedField.ClientID%>").val() == "firstName") {
                    var firstName = $("#<%=txtFirstName.ClientID%>");
                    firstName.focus();
                    firstName.caretToEnd();
                } else if ($("#<%=hdnRequestedField.ClientID%>").val() == "socialMrn") {
                    var socialMrn = $("#<%=txtSocialMRN.ClientID%>");
                    socialMrn.focus();
                    socialMrn.caretToEnd();
                } else if ($("#<%=hdnRequestedField.ClientID%>").val() == "phoneNumber") {
                    var phoneNumber = $("#<%=txtPhoneNumber.ClientID%>");
                    phoneNumber.focus();
                    phoneNumber.caretToEnd();
                } else if ($("#<%=hdnRequestedField.ClientID%>").val() == "dateOfBirth") {
                    var dob = $find("<%= dtDOB.ClientID %>");
                    dob.get_dateInput().focus();
                }
                else {
                    var textbox = $("#<%=txtLastName.ClientID%>");
                    textbox.focus();
                }

                registerTypingEvents();
            });

        });


function registerTypingEvents() {
    $('.searchTxt').typing({
        stop: function (event, $elem) {
            var field = $elem.attr("field");
            var length = $elem.val().length;
            if (length >= 3) {
                rebindGrid(field);
            }
        },
        delay: 500
    });
}

function rebindGrid(requestedField) {
    $("#<%=hdnRequestedField.ClientID %>").val(requestedField);
    $find("<%= grdPatients.ClientID %>").get_masterTableView().rebind();
}

function redirectToStatus() {
    location.href = "<%=ClientSession.WebPathRootProvider %>" + "patient/status.aspx";
}

function validateEnterEvent(e) {
    if (e.keyCode == 13) {
        rebindGrid("dateOfBirth");
    }
}

    </script>
</asp:Content>
