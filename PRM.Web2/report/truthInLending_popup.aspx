<%@ Page Language="C#" AutoEventWireup="true" CodeFile="truthInLending_popup.aspx.cs"
    Inherits="truthInLending_popup" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <link href="../Styles/BlueCredit.css" rel="stylesheet" type="text/css" />
    <link href="~/Styles/CareBlue.RadWindow.css" rel="stylesheet" type="text/css" />
    <link href="../Styles/loading.min.css" rel="stylesheet" />
    <meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
    <meta name="CODE_LANGUAGE" content="C# .NET 7.1">
    <meta name="vs_defaultClientScript" content="JavaScript">
    <meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
    <script src="../Scripts/SigWebTablet.js"></script>
    <style type="text/css" > 
        div.RadGrid .rgMasterTable
        {
            line-height: normal;
        } 
        div.RadGrid td
        {
            padding-top:0px !Important;
            padding-bottom:0px !Important;
            vertical-align:middle; 
            line-height:16px;
            font-size:9px; 
            /* height:16px; */
        } 
    </style> 
</head>

<telerik:radcodeblock runat="server" id="radCodeBlock1"> 
    <script src="../Scripts/jquery.loading.min.js"></script>
        <script src="../Scripts/pp-blockUI.js" type="text/javascript"></script>
    <script type="text/javascript">
           var tmr;

           $(document).ready(onSign);
           
           function onSign() {
               var ctx = document.getElementById('cnv').getContext('2d');
               SetDisplayXSize(500);
               SetDisplayYSize(100);
               SetTabletState(0, tmr);
               SetJustifyMode(0);
               ClearTablet();
               if (tmr == null) {
                   tmr = SetTabletState(1, ctx, 50);
               }
               else {
                   SetTabletState(0, tmr);
                   tmr = null;
                   tmr = SetTabletState(1, ctx, 50);
               }
           }

           function onClear() {
               ClearTablet();
           }

           
           function onDone() {
               
               var agree = validateIfAgreedTermsAndCondition();
               if (!agree)
                   return;

               if (NumberOfTabletPoints() == 0) {
                   alert("Please sign before continuing");
               }
               else {
                   SetTabletState(0, tmr);
                   //RETURN TOPAZ-FORMAT SIGSTRING
                   SetSigCompressionMode(1);
                   var hiddenControl = '<%= hdnSigData.ClientID %>';
                document.getElementById(hiddenControl).value = GetSigString();
               
                blockUI();

                $("#<%=btnSubmit.ClientID%>").click();

            }
        }

           function GetRadWindow() {
               var oWindow = null;
               if (window.radWindow) oWindow = window.radWindow; //Will work in Moz in all cases, including clasic dialog
               else if (window.frameElement.radWindow) oWindow = window.frameElement.radWindow; //IE (and Moz as well)

               return oWindow;
           }

           function printPopup() {

               var content = $get("tblTruthInLending").innerHTML;
               var pwin = window.open('', 'print_content', "location=1,status=1,scrollbars=1, width=1200,height=10000");
               pwin.document.open();
               pwin.document.write("<html><head> <link href='../Styles/Print.css' rel='stylesheet' type='text/css' /></head><body onload='window.print()'><div class='truthInLendingPopup'><table class='CareBluePopup ExtraPad'>" + content + "</table></div></body></html>");
               pwin.document.close();
               setTimeout(function () { pwin.close(); }, 1000);
           }

           //window.onunload = function (e) {
           //    opener.refresh();
           //};

           function closePopup() {
               //window.close();
               GetRadWindow().close();
           }

           function showTILPdf() {
               <%--var location = "<%=ClientSession.WebPathRootProvider %>" + "report/pdfviewer_popup.aspx";
               window.open(location, "til", "location=0,status=0,scrollbars=1, width=1000,height=10000,titlebar=1,titlebar=0");--%>
               GetRadWindow().BrowserWindow.viewPdfViewer('til');
           }

              function validateIfAgreedTermsAndCondition() {
              var isAgree = $("#<%=chkAgreementTerms.ClientID %>").is(":checked");
              if (!isAgree) {
                  radalert('Borrower must read the entire agreement prior to signing. After reviewing, check the box indicating acceptance of the terms.', 400, 150, '', '', '../Content/Images/warning.png');
              }

              return isAgree;
          }

        </script>

    </telerik:radcodeblock>

    <body>
    <form id="form1" runat="server">
        <telerik:radscriptmanager id="RadScriptManager1" runat="server">
        </telerik:radscriptmanager>

        <div>
            <table style="margin: 0px auto;" border="0">
                <tr>
                    <td style="width: 620px;">
                        <img style="margin-top: 5px;" alt="Provider" src="../Content/Images/Providers/careblue_logo_bcagreement.gif" id="header_imgLogo" />
                    </td>
                    <td valign="bottom">
                        <span>Revision 2016-04A &nbsp;</span>
                        <%--=DateTime.Now.ToString("MM/dd/yyyy hh:mm tt")--%>
                    </td>
                </tr>
            </table>
            <table style="margin: 0px auto;">
                <tr>
                    <td colspan="6" align="center" valign="bottom">
                        <h2>TRUTH-IN-LENDING DISCLOSURE STATEMENT</h2>
                        <!--<span style="padding:0 10px 15px 0; font-size: 0.9em">(THIS IS NEITHER A CONTRACT NOR A COMMITMENT TO LEND)</span>-->
                    </td>
                </tr>
                <tr class="ExtraPadTbl">
                    <td colspan="3">
                        <h6>BORROWER INFORMATION</h6>
                    </td>
                    <td colspan="3">
                        <h6>AGREEMENT INFORMATION</h6>
                    </td>
                </tr>
                <tr>
                    <td width="35">&nbsp;</td>
                    <td width="85">Name:</td>
                    <td width="220"><%=BorrowerName%></td>
                    <td width="35">&nbsp;</td>
                    <td width="90">Account ID:</td>
                    <td width="180"><%=AccountName%></td>
                </tr>
                <tr>
                    <td></td>
                    <td>SSN:</td>
                    <td><%=BorrowerSSN%></td>
                    <td></td>
                    <td>Prepared By:</td>
                    <td><%=PracticeName%></td>
                </tr>
                <tr>
                    <td></td>
                    <td>DOB:</td>
                    <td><%=BorrowerDOB%></td>
                    <td></td>
                    <td>Prepared:</td>
                    <td><%=OpenDate%></td>
                </tr>
                <tr>
                    <td colspan="6" height="10">
                        <img alt="spacer" src="../Content/Images/spacer_transparent.gif" /></td>
                </tr>
<!--                <tr>
                    <td colspan="6" valign="middle" height="25">
                        <h7>LOAN IDENTIFICATION: <%=TermAbbr%></h7>
                    </td>
                </tr>
-->
                <tr>
                    <td colspan="6" valign="top" align="center"><span style="font-size: 1.2em; font-weight: 600;"><%=Message%>
                        </span></td>
                </tr>
            </table>

                    <div id="divButtons" runat="server" align="right" visible="False">
                        <a href="#" onclick="printPopup(this)">
                            <img src="../Content/Images/btn_print.gif" class="btn-print" alt="Print" /></a>
                        &nbsp; <a href="#" onclick="closePopup()">
                            <img src="../Content/Images/btn_close.gif" class="btn-close" alt="Close" /></a>
                    </div>
                    <div id="divTruthInLending">
                        <!--<div id="divBluecreditTil" runat="server"></div>-->
                            <table border="1" cellpadding="0" align="center">
                                <tr>
                                    <td width="165" valign="top" height="85">
                                        <h7>ANNUAL</h7><br />
                                        <h7>PERCENTAGE RATE</h7>
                                        <h4>The cost of your credit<br />as a yearly rate</h4>
                                        <h6 style="font-size: 1.4em; text-align: right; color: black;"><%=APR%>&nbsp;</h6>
                                    </td>
                                    <td width="165" valign="top">
                                        <h7>FINANCE</h7><br />
                                        <h7>CHARGE</h7>
                                        <h4>The dollar amount the credit<br />will cost you</h4>
                                        <h6 style="font-size: 1.4em; text-align: right; color: black;"><%=FinCharges%>&nbsp;</h6>
                                    </td>
                                    <td width="165" valign="top">
                                        <h7>AMOUNT</h7><br />
                                        <h7>FINANCED</h7>
                                        <h4>The amount of credit provided <br />to you or on your behalf</h4>
                                        <h6 style="font-size: 1.4em; text-align: right; color: black;"><%=Principal%>&nbsp;</h6>
                                    </td>
                                    <td width="165" valign="top">
                                        <h7>TOTAL OF </h7><br />
                                        <h7>PAYMENTS</h7>
                                        <h4>The amount you will have paid after<br />making all payments as scheduled</h4>
                                        <h6 style="font-size: 1.4em; text-align: right; color: black;"><%=TotPayments%>&nbsp;</h6>
                                    </td>
                                </tr>
                            </table>

                            <table width="660" border="0" align="center" style="font-size: 0.9em;">
                                <!-- START SECTION -- ONLY SHOW WHEN PRINTING THE PDF -->
                                <% if (IsShowBlueCreditAmortschedTable) { %>  
                                <tr>
                                    <td colspan="3" height="15">
                                        <img alt="spacer" src="../Content/Images/spacer_transparent.gif" /></td>
                                </tr>
                                <% } %>  
                                <!-- ENDSECTION -- ONLY SHOW WHEN PRINTING THE PDF -->
                                <tr valign="bottom">
                                    <td width="25" height="20">&nbsp;</td>
                                    <td width="120">REQUIRED DEPOSIT: </td>
                                    <td>The annual percentage rate does not take into account your required deposit.</td>
                                </tr>                 
                                <tr>
                                    <td></td>
                                    <td>PAYMENTS: </td>
                                    <td>Your payment schedule will be as listed on the next page of this form.</td>
                                </tr>                 
                                <tr>
                                    <td></td>
                                    <td>DEMAND FEATURE: </td>
                                    <td>This obligation has no demand feature unless the loan is in default.</td>
                                </tr>                 
                                <tr>
                                    <td></td>
                                    <td>VARIABLE RATE: </td>
                                    <td>This loan does not have a variable rate feature except the stated promotional rate, if applicable.</td>
                                </tr>                 
                                <tr>
                                    <td></td>
                                    <td>INSURANCE: </td>
                                    <td>No insurance is required to obtain credit, including life or disability insurance.</td>
                                </tr>                 
                                <tr>
                                    <td></td>
                                    <td>LATE CHARGE: </td>
                                    <td>If a payment is more than 5 days late, you may be charged a late fee of up to $35.00.</td>
                                </tr>                 
                                <tr>
                                    <td></td>
                                    <td>PREPAYMENT: </td>
                                    <td>If you pay off early, you will not have to pay a penalty or the full finance charge.</td>
                                </tr>
                            </table>

                            <table width="680" border="0" align="center" style="font-size:0.9em;">
                                <!-- START SECTION -- ONLY SHOW WHEN PRINTING THE PDF -->
                                <% if (IsShowBlueCreditAmortschedTable) { %>  
                                <tr>
                                    <td height="10">
                                        <img alt="spacer" src="../Content/Images/spacer_transparent.gif" /></td>
                                </tr>
                                <% } %>  
                                <!-- ENDSECTION -- ONLY SHOW WHEN PRINTING THE PDF -->
                                <tr>
                                    <td height="5">
                                        <img alt="spacer" src="../Content/Images/spacer_transparent.gif" /></td>
                                </tr>
                                <tr valign="bottom">
                                    <td><b><u>THIS IS A LOAN, IT MUST BE REPAID.</u></b> Loans are reported to credit bureaus, which may affect your credit rating. In the event of default, the entire unpaid loan, including interest, late charges and collections costs, shall, at the option of CareBlue become immediately due and payable. All late charges, collection costs and attorney fees will be paid by the borrower. See your loan agreement documents for any additional information about nonpayment, default, and term. </td>
                                </tr>
                                <tr>
                                    <td height="5">
                                        <img alt="spacer" src="../Content/Images/spacer_transparent.gif" /></td>
                                </tr>
                <% if (IsShowBlueCreditAmortschedTable)
                   { %>  <!-- START SECTION -- ONLY SHOW WHEN PRINTING THE PDF -->
                                <tr>
                                    <td align="left" valign="top">
                                        <span>Federal law allows CareBlue PracticeAdvance, LLC (CareBlue) to obtain, verify and record information that identifies you when you open an account. CareBlue will use your name, address, date of birth, and other Information for this purpose.  As part of this agreement, I authorize CareBlue to obtain information from others about me (including requesting reports from consumer reporting agencies and other sources) to evaluate my application, and to review, maintain or collect my account.</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td height="5">
                                        <img alt="spacer" src="../Content/Images/spacer_transparent.gif" /></td>
                                </tr>
                                <tr>
                                    <td align="left" valign="top">
                                        <span>I consent to CareBlue and any other owner or servicer of my account contacting me about my account, including using any contact information or cell phone numbers I provide, and I consent to the use of any automatic telephone dialing system and/or an artificial or prerecorded voice when contacting me, even if I am charged for the call under my phone plan. By providing a cell phone number and/or email address, I agree to receive special offers, updates, and account information, including text messages from Providers that accept CareBlue credit. Standard text messaging rates may apply.</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td height="5">
                                        <img alt="spacer" src="../Content/Images/spacer_transparent.gif" /></td>
                                </tr>
                <% } %>  <!-- ENDSECTION -- ONLY SHOW WHEN PRINTING THE PDF -->
                            </table>

                            <table style="margin: 0px auto;">
                                <tr>
                                    <td>&nbsp;</td>
                                    <td align="left" valign="top">
                                        <table width="400">
                                            <!-- START SECTION -- ONLY SHOW WHEN PRINTING THE PDF -->
                                            <% if (IsShowBlueCreditAmortschedTable) { %>  
                                            <tr>
                                                <td height="15">
                                                    <img alt="spacer" src="../Content/Images/spacer_transparent.gif" /></td>
                                            </tr>
                                            <% } %>  
                                            <!-- ENDSECTION -- ONLY SHOW WHEN PRINTING THE PDF -->
                                            <tr>
                                                <td>
                                                    <h1>PRIOR TO SIGNING THIS AGREEMENT</h1>
                                                    <div>Please read this entire disclosure carefully. Unless you agree to the terms of this agreement, you should not sign or accept the loan.</div>
                                                </td>
                                            </tr>
                                            <tr class="ExtraPadTbl2">
                                                <td>
                                                    <asp:CheckBox ID="chkAgreementTerms" runat="server" Checked="False" />
                                                    <div style="margin: -20px 0 -0px 25px;"><h3>I have read and understand the fees and conditions of the loan as<br/>disclosed, and agree to comply with all terms of this loan agreement.</h3></div>
                                                    <asp:HiddenField ID="hdnIsDisableCheckBox" runat="server" />
                                                </td>
                                            </tr>
                                        </table>
                                    </td>
                                    <td width="30">&nbsp;</td>
                                    <td align="left" valign="top">
                                        &nbsp;<br />
                                        <asp:Panel ID="pnlSignData" Visible="True" runat="server">
                                            <table width="100%">
                                                <tr>
                                                    <td>
                                                      <canvas id="cnv" name="cnv" style="border:1px thin solid black" width="300" height="70"></canvas>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">
                                                        <p class="buttons">
                                                            <input type="file" id="file1" style="display: none" />
                                                                <a href="javascript:;" onclick="javascript: onClear();">
                                                                <img alt="Clear" src="../Content/Images/btn_clear_small.gif" /></a>  &nbsp;&nbsp;&nbsp;&nbsp
                                                                <a href="javascript:;" onclick="javascript: onDone();">
                                                                <img alt="Done" src="../Content/Images/btn_done_small.gif" /></a> &nbsp;&nbsp;&nbsp;&nbsp
                                                            <asp:ImageButton ID="btnShowPdf" OnClick="btnShowPdf_OnClick"  runat="server" ImageUrl="../Content/Images/btn_printsign.gif" CssClass="btn-pop-submit" />
                                                <asp:ImageButton ID="btnSubmit" OnClick="btnSubmit_OnClick" runat="server" Style="display: none" ImageUrl="../Content/Images/btn_submit.gif" CssClass="btn-pop-submit" />
                                                            <asp:HiddenField ID="hdnSigData" runat="server" />
                                                        </p>
                                                    </td>
                                                </tr>
                                            </table>
                                        </asp:Panel>

                                        <asp:Panel runat="server" ID="pnlClientSignImage" Enabled="False" Visible="False" HorizontalAlign="Left">
                                            <table width="100%">
                                                <tr class="ExtraPadTbl2">
                                                    <td><span>Signature of Borrower</span><br />
                                                        <asp:Image ID="imgClientSign" Width="200" runat="server" Style="margin: 10px 0 -30px 0;" />
                                                        <p>________________________________________________________________<br />&nbsp;</p>
                                                    </td>
                                                </tr>
                                            </table>
                                            <asp:ImageButton ID="btnResign" ImageUrl="../Content/Images/btn_resign.gif" Style="margin-right: 5px;" OnClick="btnResign_OnClick" OnClientClick="return validateIfAgreedTermsAndCondition();" runat="server" />
                                            <asp:ImageButton ID="btnClose" ImageUrl="../Content/Images/btn_close_small.gif" AlternateText="Close" OnClientClick="closePopup(); return false;" runat="server"/>
                                        </asp:Panel>                        

                                        <asp:Panel ID="pnlSign" Visible="False" runat="server">
                                            <span>
                                                <br /><br /><br />
                                                X _________________________________________ 
                                                <br />Signature of Borrower</span>
                                                <br />&nbsp;
                                                <br />Date ___________________
                                                <br />&nbsp;
                                        </asp:Panel>

                                    </td>
                                </tr>
                            </table>

                <!-- START SECTION -- ONLY SHOW WHEN PRINTING THE PDF -->    
                <% if (IsShowBlueCreditAmortschedTable) { %>  

                        <br /><br />
                        <table style="margin: 0px auto;">
                            <tr>
                                <td align="center"><span style="font-weight:600;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; A COPY OF THE LOAN AGREEMENT IN FULL IS ATTACHED - PLEASE RETAIN FOR YOUR RECORDS &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span></td>
                            </tr>
                            <tr>
                                <td align="center"><span style="font-weight:600;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; FOR QUESTIONS OR ASSISTANCE WITH THIS LOAN, PLEASE CONTACT YOUR PROVIDER OR CAREBLUE &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span></td>
                            </tr>
                            <tr>
                                <td height="40">
                                    <img alt="spacer" src="../Content/Images/spacer_transparent.gif" /></td>
                            </tr>
                            <tr>
                                <td align="right">
                                   Page 1 of 1
                                </td>
                            </tr>
                        </table>
                        
                        
                        <div class="pagebreak"> </div>


                        <table style="margin: 0px auto;" border="0">
                            <tr>
                                <td style="width: 620px;">
                                    <img style="margin-top: 5px;" alt="Provider" src="../Content/Images/Providers/careblue_logo_bcagreement.gif" id="header_imgLogo" />
                                </td>
                                <td valign="bottom">
                                    <span>Revision 2016-02A &nbsp;</span>
                                </td>
                            </tr>
                        </table>
                        <table style="margin: 0px auto;">
                            <tr>
                                <td colspan="6" align="center" valign="bottom">
                                    <h2>TRANSACTION HISTORY AND ESTIMATED PAYMENT SCHEDULE</h2>
                                </td>
                            </tr>
                            <tr class="ExtraPadTbl">
                                <td colspan="3">
                                    <h6>BORROWER INFORMATION</h6>
                                </td>
                                <td colspan="3">
                                    <h6>AGREEMENT INFORMATION</h6>
                                </td>
                            </tr>
                            <tr>
                                <td width="35">&nbsp;</td>
                                <td width="85">Name:</td>
                                <td width="220"><%=BorrowerName%></td>
                                <td width="35">&nbsp;</td>
                                <td width="90">Account ID:</td>
                                <td width="180"><%=AccountName%></td>
                            </tr>
                            <tr>
                                <td></td>
                                <td>SSN:</td>
                                <td><%=BorrowerSSN%></td>
                                <td></td>
                                <td>Prepared By:</td>
                                <td><%=PracticeName%></td>
                            </tr>
                            <tr>
                                <td></td>
                                <td>DOB:</td>
                                <td><%=BorrowerDOB%></td>
                                <td></td>
                                <td>Prepared:</td>
                                <td><%=OpenDate%></td>
                            </tr>
                            <tr>
                                <td colspan="6" height="10">
                                    <img alt="spacer" src="../Content/Images/spacer_transparent.gif" /></td>
                            </tr>
                            <tr>
                                <td colspan="6" valign="top" align="center"><span style="font-size: 1.2em; font-weight: 600;"><%=Message%>
                                    </span></td>
                            </tr>
                        </table>
                        <div>
                        <table width="680" border="0" align="center" style="font-size:0.6em;">
                            <tr>
                                <td>
                                    <telerik:radgrid id="grdBlueCreditAmortsched" runat="server" onneeddatasource="grdBlueCreditAmortsched_NeedDataSource" allowpaging="True" pagesize="100" >
                                        <MasterTableView AutoGenerateColumns="False" >
                                            <Columns>
                                                <telerik:GridBoundColumn HeaderText="Cycle" DataField="Cycle">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Date" DataField="Date">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Description" DataField="Desc">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Adjustment" DataField="NewAdditions$">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Start Balance" DataField="BeginBalance$">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Payment" DataField="Payment$">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Principal" DataField="Principal$">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="Interest" DataField="Interest$">
                                                </telerik:GridBoundColumn>
                                                <telerik:GridBoundColumn HeaderText="End Balance" DataField="EndBalance$">
                                                </telerik:GridBoundColumn>
                                            </Columns>
                                        </MasterTableView>
                                    </telerik:radgrid>

                                </td>
                            </tr>
                        </table>
                        </div>
                <% } %>  
                <!-- ENDSECTION -- ONLY SHOW WHEN PRINTING THE PDF -->

                    </div>
            </div>
         <telerik:radwindowmanager id="RadWindow" showcontentduringload="True" visiblestatusbar="False"
            visibletitlebar="True" reloadonshow="True" runat="Server" width="1100px" height="850px"
            modal="True" enableshadow="False" enableembeddedbasestylesheet="False" enableembeddedskins="False"
            skin="CareBlueInf">
                    <AlertTemplate>
                        <div class="rwDialogPopup radalert">
                            <h5 style="margin-top:-20px; font-size:1.1em; line-height:1.5em; font-weight:400;">
                                <div class="rwDialogText">
                                    {1}
                                </div>
                            </h5>
                            <div style="margin-top: 10px; margin-left: 80px; margin-bottom:-5px; ">
                                <a href="#" onclick="$find('{0}').close(true);">
                                    <img src="../Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                            </div>
                        </div>
                    </AlertTemplate>
                </telerik:radwindowmanager>
    </form>
</body>
</html>

