<%@ Page Language="C#" AutoEventWireup="true" CodeFile="lendingTerms_popup.aspx.cs"
    Inherits="lendingTerms_popup" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title />
    <script src="../Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <link href="~/Styles/CareBlue.RadWindow.css" rel="stylesheet" type="text/css" />
    <link href="../Styles/Print.css" rel="stylesheet" type="text/css" />
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
                    <div align="right">
                        <a href="#" onclick="printPopup(this)">
                            <img src="../Content/Images/btn_print.gif" class="btn-print" alt="Print" /></a>
                        &nbsp; <a href="#" onclick="closePopup()">
                            <img src="../Content/Images/btn_close.gif" class="btn-close" alt="Close" /></a>
                    </div>
                    <div id="divTruthInLending">
                        <table width="100%" id="tblTruthInLending">
                            <tr>
                                <td colspan="3">
                                    &nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <div style="text-align: center;">
                                        <h1>
                                            Truth-In-Lending-Statement</h1>
                                        <div style="font-size: 12px; color: black;">
                                            <%= PatientName %>
                                            <br />
                                             <%= TermsSection1%>
                                             <%= TermsSection2%>
                                             <%= TermsSection3%>
                                             <%= TermsSection4%>
                                            <br />
                                            &nbsp;
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td width="50%" valign="top">
                                    <div class="form-row">
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="Label16" runat="server">Borrower Name:</asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <%=BorrowerName %>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="Label4" runat="server">Borrower Address1:</asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                  <%=BorrowerAddress1 %>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="Label7" runat="server">Borrower Address2:</asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                  <%=BorrowerAddress2 %>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="Label3" runat="server">Borrower Phone:</asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <%=BorrowerPhone %>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                                <td width="50%" valign="top">
                                    <div class="form-row">
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="Label1" runat="server">Borrower Email:</asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <%=BorrowerEmail%>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="Label9" runat="server">BorrowerSSN:</asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                <%=BorrowerSSN%>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="form-row">
                                        <div class="form-row">
                                            <div class="editor-label">
                                                <asp:Label ID="Label8" runat="server">Term Abbr:</asp:Label>
                                            </div>
                                            <div class="editor-field">
                                                
                                            </div>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <table border="1" cellpadding="10" width="100%">
                                        <tr>
                                            <td>
                                                PRINCIPAL amount financed:
                                            </td>
                                            <td>
                                                
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Annual Percentage RATE (APR):
                                            </td>
                                            <td>
                                                
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Finance CHARGES:
                                            </td>
                                            <td>
                                                
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Total PAYMENTS:
                                            </td>
                                            <td>
                                                
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                Minimum MONTHLY Payment:
                                            </td>
                                            <td>
                                                
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <br />
                                    <br />
                                    <p align="justify">
                                        LATE CHARGES not to exceed 20 percent of your monthly payment will be assessed if
                                        you do not make a scheduled payment when it is due or submit a valid deferment or
                                        cancellation document on or before the date on which payment is due.
                                    </p>
                                    <br />
                                    <p align="justify">
                                        LOANS are reported to CREDIT BUREAU organizations, which may affect your credit
                                        rating. Deferment or cancellation forms which are submitted late, but approved retroactively,
                                        will not alter any existing credit bureau history. In the event of default, the
                                        entire unpaid loan, including interest, late charges and collections costs, shall,
                                        at the option of the Practice become immediately due and payable. AJI late charges,
                                        collection costs and attorney fees will be paid by the borrower.
                                    </p>
                                    <br />
                                    <p align="justify">
                                        Payments, communications, and questions regarding this loan should be directed to
                                        the billing at
                                        <%= PatientName %>,
                                    </p>
                                    <p>
                                        Practice may use a billing servicer to whom you would mail payments; Practice will
                                        notify you of the name and address of this firm if applicable.
                                    </p>
                                    <p align="justify">
                                        <u>THIS IS A LOAN If MUST BE RFPAID</u>. UNLESS YOU AGREE TO COMPLY WITH THE TERMS
                                        OF THE PROMISSORY NOTE YOU SHOULD NOT SIGN THIS DOCUMENT OR ACCEPT THE LOAN.
                                    </p>
                                    <div style="border: 1px;">
                                        <p>
                                            I have read and understand my promissory note, and the TRUTH-IN-LENDING STATEMENT
                                            (above).</p>
                                        <br />
                                        <p>
                                            <u>I fully understand and agree to romolv with the terms of this loan </u>
                                        </p>
                                        <br />
                                        <br />
                                        <p>
                                            Borrower Signature: _______________________ Date _________________
                                            <br />
                                            U.S. Social Security Number _________________________________________ Birth Date
                                            _____________________
                                        </p>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </div>
                </td>
            </tr>
        </table>
    </div>
    </form>
    <script type="text/javascript">

        function GetRadWindow() {
            var oWindow = null;
            if (window.radWindow) oWindow = window.radWindow; //Will work in Moz in all cases, including clasic dialog
            else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow; //IE (and Moz as well)

            return oWindow;
        }

        function printPopup() {

            var content = $get("tblTruthInLending").innerHTML;
            var pwin = window.open('', 'print_content', 'width=1100,height=800');
            pwin.document.open();
            pwin.document.write("<html><head> <link href='../Styles/Print.css' rel='stylesheet' type='text/css' /></head><body onload='window.print()'><table class='CareBluePopup ExtraPad'>" + content + "</table></body></html>");
            pwin.document.close();
            setTimeout(function () { pwin.close(); }, 1000);
        }


        function closePopup() {
            window.close();
        }

    </script>
</body>
</html>
