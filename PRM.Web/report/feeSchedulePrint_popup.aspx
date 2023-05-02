<%@ Page Language="C#" AutoEventWireup="true" CodeFile="feeSchedulePrint_popup.aspx.cs"
    Inherits="feeSchedulePrint_popup" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <link href="~/Styles/CareBlue.RadWindow.css" rel="stylesheet" type="text/css" />
    <link href="~/Styles/Popup.css" rel="stylesheet" type="text/css" />
</head>
<body>
    <form id="form1" runat="server">
        <telerik:RadScriptManager ID="RadScriptManager1" runat="server">
        </telerik:RadScriptManager>
        <div>
            <table class="CareBluePopup">
                <tr>
                    <td>
                        <h2p>
                        Title
                    </h2p>
                    </td>
                </tr>
                <tr>
                    <td>
                        <h4p>
                        Description
                    </h4p>
                    </td>
                </tr>
                <tr>
                    <td class="ExtraPad">
                        <div>
                            <h2>Fee Schedule Summary</h2>
                        </div>
                        <div align="right">
                            <a href="#" onclick="closePopup()">
                                <img src="../Content/Images/btn_close.gif" class="btn-close" alt="Close" /></a>
                            &nbsp; <a href="#" onclick="printPopup(this)">
                                <img src="../Content/Images/btn_print.gif" class="btn-print" alt="Print" /></a>
                        </div>
                        <table width="100%">
                            <tr>
                                <td>
                                    <table width="100%" id="tblFeeSchedulePopup">
                                        <tr>
                                            <td colspan="3"></td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <table id="tblFeeShcedule" cellspacing="10">
                                                    <tr>
                                                        <td>
                                                            <div class="form-row" id="divLoginStates" runat="server">
                                                                <div class="editor-label">
                                                                    <asp:Label ID="Label4" runat="server">Fee Schedule ID:</asp:Label>
                                                                </div>
                                                                <div class="editor-field">
                                                                    <asp:Label ID="lblFeeScheduleID" runat="server"></asp:Label>
                                                                </div>
                                                            </div>
                                                            <div class="form-row" id="div1" runat="server">
                                                                <div class="editor-label">
                                                                    <asp:Label ID="Label1" runat="server">Schedule Name:</asp:Label>
                                                                </div>
                                                                <div class="editor-field">
                                                                    <asp:Label ID="lblScheduleName" runat="server"></asp:Label>
                                                                </div>
                                                            </div>
                                                            <div class="form-row" id="div2" runat="server">
                                                                <div class="editor-label">
                                                                    <asp:Label ID="Label2" runat="server">Carrier Name:</asp:Label>
                                                                </div>
                                                                <div class="editor-field">
                                                                    <asp:Label ID="lblCarrierName" runat="server"></asp:Label>
                                                                </div>
                                                            </div>
                                                            <div class="form-row" id="div3" runat="server">
                                                                <div class="editor-label">
                                                                    <asp:Label ID="Label3" runat="server">Reference ID:</asp:Label>
                                                                </div>
                                                                <div class="editor-field">
                                                                    <asp:Label ID="lblReferenceID" runat="server"></asp:Label>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <div class="form-row" id="div4" runat="server">
                                                                <div class="editor-label">
                                                                    <asp:Label ID="Label5" runat="server">Service Class:</asp:Label>
                                                                </div>
                                                                <div class="editor-field">
                                                                    <asp:Label ID="lblServiceClass" runat="server"></asp:Label>
                                                                </div>
                                                            </div>
                                                            <div class="form-row" id="div5" runat="server">
                                                                <div class="editor-label">
                                                                    <asp:Label ID="Label7" runat="server">Provide:</asp:Label>
                                                                </div>
                                                                <div class="editor-field">
                                                                    <asp:Label ID="lblProvider" runat="server"></asp:Label>
                                                                </div>
                                                            </div>
                                                            <div class="form-row" id="div6" runat="server">
                                                                <div class="editor-label">
                                                                    <asp:Label ID="Label9" runat="server">NPI:</asp:Label>
                                                                </div>
                                                                <div class="editor-field">
                                                                    <asp:Label ID="lblNPI" runat="server"></asp:Label>
                                                                </div>
                                                            </div>
                                                            <div class="form-row" id="div7" runat="server">
                                                                <div class="editor-label">
                                                                    <asp:Label ID="Label11" runat="server">Contract Status:</asp:Label>
                                                                </div>
                                                                <div class="editor-field">
                                                                    <asp:Label ID="lblContractStatus" runat="server"></asp:Label>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td>
                                                            <div class="form-row" id="div8" runat="server">
                                                                <div class="editor-label">
                                                                    <asp:Label ID="Label6" runat="server">Schedule Status:</asp:Label>
                                                                </div>
                                                                <div class="editor-field">
                                                                    <asp:Label ID="lblScheduleStatus" runat="server"></asp:Label>
                                                                </div>
                                                            </div>
                                                            <div class="form-row" id="div9" runat="server">
                                                                <div class="editor-label">
                                                                    <asp:Label ID="lbl12" runat="server">Request Date:</asp:Label>
                                                                </div>
                                                                <div class="editor-field">
                                                                    <asp:Label ID="lblRequestDate" runat="server"></asp:Label>
                                                                </div>
                                                            </div>
                                                            <div class="form-row" id="div10" runat="server">
                                                                <div class="editor-label">
                                                                    <asp:Label ID="Label13" runat="server">Expiration:</asp:Label>
                                                                </div>
                                                                <div class="editor-field">
                                                                    <asp:Label ID="lblExpiration" runat="server"></asp:Label>
                                                                </div>
                                                            </div>
                                                            <div class="form-row" id="div11" runat="server">
                                                                <div class="editor-label">
                                                                    <asp:Label ID="Label15" runat="server">ReimBursement:</asp:Label>
                                                                </div>
                                                                <div class="editor-field">
                                                                    <asp:Label ID="lblReimBursement" runat="server"></asp:Label>
                                                                </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            <div class="form-row" id="div12" runat="server">
                                                                <div class="editor-label">
                                                                    <asp:Label ID="Label8" runat="server">Notes:</asp:Label>
                                                                </div>
                                                                <div class="editor-field">
                                                                    <asp:Label ID="lblNotes" runat="server"></asp:Label>
                                                                </div>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <hr />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div style="float: right; width: 100%" id="divSchedules">
                                        <h1>Schedule Listing
                                        </h1>
                                        <telerik:RadGrid ID="grdSchedules" runat="server" AllowSorting="True" AllowPaging="True"
                                            OnNeedDataSource="grdSchedules_NeedDataSource">
                                            <MasterTableView AutoGenerateColumns="False">
                                                <Columns>
                                                    <telerik:GridBoundColumn HeaderText="CPT Code" DataField="CPTCode">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn HeaderText="Category" DataField="CPTCategory">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn HeaderText="Service Type" DataField="ServiceTypeAbbr">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn HeaderText="CPT Name" DataField="CPTName">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn HeaderText="Provider Charge" DataField="ProviderCharge$">
                                                    </telerik:GridBoundColumn>
                                                    <telerik:GridBoundColumn HeaderText="Allowable" DataField="Allowable$">
                                                    </telerik:GridBoundColumn>
                                                </Columns>
                                            </MasterTableView>
                                        </telerik:RadGrid>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
        <script type="text/javascript" language="javascript">

            function printPopup() {

                var content = $("#tblFeeSchedulePopup").html();
                var girdContent = $("#divSchedules").html();
                var pwin = window.open('', 'print_content', 'width=1100,height=600');
                pwin.document.open();
                pwin.document.write("<html><head><style type='text/css'> h1 {font-size: 22px;  font-family: 'Helvetica Neue' , 'Lucida Grande' , 'Segoe UI' , Arial, Helvetica, Verdana, sans-serif;} .rgHeader {padding-right: 135px;} a {text-decoration: none; color: #4D6231; font-weight: bold;} .editor-label {font-weight: bold;} .form-row { float: left;  padding-bottom: 8px;margin-left: 15px; width: 100%;} .editor-label{color: #4D6231;font-weight: bold;float: left;text-align: right; margin-right: 5px;display: block; width: 180px; } .editor-field{float: left;line-height: 17px; }</style></head><body onload='window.print()'>" + "<h1> Fee Schedule Summary </h1>" + content + girdContent + "</body></html>");
                pwin.document.close();
                setTimeout(function () { pwin.close(); }, 1000);
            }


            function closePopup() {
                window.close();
            }

        </script>
    </form>
</body>
</html>
