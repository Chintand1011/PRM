<%@ Page Language="C#" AutoEventWireup="true" CodeFile="bluecreditApplication_popup.aspx.cs"
    Inherits="bluecreditApplication_popup" %>

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

          function showHidePopup(popupToBeOpen, popupToBeClose) {
              GetRadWindow().BrowserWindow.showHideRequestedPopups(popupToBeOpen, popupToBeClose);
          }

          function saveLendingAgreement() {
              GetRadWindow().BrowserWindow.saveLendingAgreement();
          }

          function showLaPdf() {
              GetRadWindow().BrowserWindow.viewPdfViewer('la');
          }

          function closePopup() {
              GetRadWindow().close();
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
</head>
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
                    </td>
                </tr>
            </table>
            <table style="margin: 0px auto;">
                <tr>
                    <td colspan="6" align="center">
                        <h5>CAREBLUE CREDIT ACCOUNT AGREEMENT</h5>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <h6>BORROWER INFORMATION</h6>
                    </td>
                    <td colspan="3">
                        <h6>CREDIT ACCOUNT INFORMATION</h6>
                    </td>
                </tr>
                <tr class="ExtraPadTbl">
                    <td width="20">&nbsp;</td>
                    <td width="85">Name:</td>
                    <td width="200"><%=AccountHolder%></td>
                    <td width="20">&nbsp;</td>
                    <td width="110">Account ID:</td>
                    <td width="210"><%=AccountName%></td>
                </tr>
                <tr>
                    <td></td>
                    <td>SSN:</td>
                    <td><%=BlueCreditSSN%></td>
                    <td></td>
                    <td>Open Date:</td>
                    <td><%=OpenDate%></td>
                </tr>
                <tr>
                    <td></td>
                    <td>DOB:</td>
                    <td><%=DOB%></td>
                    <td></td>
                    <td>Loan Amount: </td>
                    <td><%=BalanceCurrency%></td>
                </tr>
                <tr>
                    <td></td>
                    <td>Identification:</td>
                    <td><%=IdentificationTypeAbbr%></td>
                    <td></td>
                    <td>Credit Term:</td>
                    <td><%=TermMaxAbbr%></td>
                </tr>
                <tr>
                    <td></td>
                    <td>Number:</td>
                    <td><%=IDNumber%></td>
                    <td></td>
                    <td>Interest Rate:</td>
                    <td><%=PlanName%></td>
                </tr>
                <tr>
                    <td></td>
                    <td>Issuer:</td>
                    <td><%=LocationAbbr%></td>
                    <td></td>
                    <td>Min Payment:</td>
                    <td><%=MinPayAmountCurrency%> per Month</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Expiration:</td>
                    <td><%=ExpirationDate%></td>
                    <td></td>
                    <td>Default Rate:</td>
                    <td><%=DefaultAbbr%> APR</td>
                </tr>
                <tr class="ExtraPadTbl">
                    <td></td>
                    <td>Address:</td>
                    <td><%=AddrAbbr%></td>
                    <td></td>
                    <td>Account Status:</td>
                    <td><%=CreditStatusTypeAbbr%></td>
                </tr>
                <tr>
                    <td></td>
                    <td></td>
                    <td><%=City%>, <%=State%> <%=ZipAbbr%></td>
                    <td></td>
                    <td>Due Date:</td>
                    <td><%=NextPayDate%></td>
                </tr>
                <tr>
                    <td></td>
                    <td>Phone:</td>
                    <td><%=PhonePri%></td>
                    <td></td>
                    <td>Scheduled:</td>
                    <td><%=PtSetRecurringMinCurrency%> per Month</td>
                </tr>
                <tr>
                    <td></td>
                    <td>Alternate:</td>
                    <td><%=PhoneSec%></td>
                    <td></td>
                    <td>Payment Type:</td>
                    <td><%=PaymentCardAbbr%></td>
                </tr>
                <tr>
                    <td></td>
                    <td>Email:</td>
                    <td><%=Email%></td>
                    <td></td>
                    <td>Payment Fee:</td>
                    <td><%=PaymentCardFeeAbbr%></td>
                </tr>
                <tr>
                    <td></td>
                    <td>Paperless:</td>
                    <td><%=FlagEmailBillsAbbrVerbose%></td>
                    <td></td>
                    <td>Linked Bank:</td>
                    <td><%=PaymentCardSecAbbr%></td>
                </tr>

                <!-- START SECTION -- ONLY SHOW WHEN PRINTING THE PDF -->
                <% if (IsShowLenderInformation)
                   {  %>

                <tr class="ExtraPadTbl2">
                    <td colspan="3">
                        <h6>ORIGINATING MEDICAL PROVIDER</h6>
                    </td>
                    <td colspan="3">
                        <h6>LENDER AND LOAN SERVICER</h6>
                    </td>
                </tr>
                <tr class="ExtraPadTbl">
                    <td>&nbsp;</td>
                    <td>Name:</td>
                    <td><%=PracticeName%></td>
                    <td>&nbsp;</td>
                    <td>Name:</td>
                    <td><%=CompanyName%></td>
                </tr>
                <tr>
                    <td></td>
                    <td>Address:</td>
                    <td><%=PracticeAddress1%></td>
                    <td></td>
                    <td>Address:</td>
                    <td><%=CompanyAddress1%></td>
                </tr>
                <tr>
                    <td></td>
                    <td></td>
                    <td><%=PracticeAddress2%></td>
                    <td></td>
                    <td></td>
                    <td><%=CompanyAddress2%></td>
                </tr>
                <tr>
                    <td></td>
                    <td>Phone:</td>
                    <td><%=PracticePhone%></td>
                    <td></td>
                    <td>Phone:</td>
                    <td><%=CompanyBlueCreditPhone%></td>
                </tr>
                <tr>
                    <td></td>
                    <td>Fax:</td>
                    <td><%=PracticeFax%></td>
                    <td></td>
                    <td>Fax:</td>
                    <td><%=CompanyFax%></td>
                </tr>

            </table>
            <br />
            &nbsp;
            <table style="margin: 0px auto;">
                <tr>
                    <td>&nbsp;</td>
                    <td align="left" valign="top" width="650">
                        <span style="font-size: 0.9em; font-weight: 200;">CareBlue PracticeAdvance, LLC (CareBlue) obtains, verifies and records information that identifies you when we extend you credit. CareBlue will use your name, address, date of birth, and other Information for this purpose.  As part of this agreement, I authorize CareBlue to obtain information from others about me (including requesting reports from consumer reporting agencies and other sources) to evaluate my application, and to review, maintain or collect my account.</span>
                    </td>
                    <td>&nbsp;</td>
                </tr>
                <tr>
                    <td colspan="3" height="5">
                        <img alt="spacer" src="../Content/Images/spacer_transparent.gif" /></td>
                </tr>
                <tr>
                    <td></td>
                    <td align="left" valign="top">
                        <span style="font-size: 0.9em; font-weight: 200;">I consent to CareBlue and any other owner or servicer of my account contacting me about my account, including using any contact information or cell phone numbers I provide, and I consent to the use of any automatic telephone dialing system and/or an artificial or prerecorded voice when contacting me, even if I am charged for the call under my phone plan. By providing a cell phone number and/or email address, I agree to receive special offers, updates, and account information, including text messages from Providers that accept CareBlue credit. Standard text messaging rates may apply.</span>
                    </td>
                    <td></td>
                </tr>
                <tr>
                    <td colspan="3" height="5">
                        <img alt="spacer" src="../Content/Images/spacer_transparent.gif" /></td>
                </tr>

                <!-- END SECTION -- ONLY SHOW WHEN PRINTING THE PDF -->
                <% } %>
            </table>

            <br />

            <table style="margin: 0px auto;">
                <tr>
                    <td>&nbsp;</td>
                    <td align="left" valign="top">
                        <table width="400">
                            <tr>
                                <td>
                                    <h1>PRIOR TO SIGNING AGREEMENT AND NOTE</h1>
                                    <div>
                                        Please read the entire CareBlue Credit Account Agreement and Promissory Note carefully, including all terms and disclosures.
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3" height="5">
                                    <img alt="spacer" src="../Content/Images/spacer_transparent.gif" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:CheckBox ID="chkAgreementTerms" runat="server" Checked="False" />
                                    <div style="margin: -20px 0 -0px 25px;">
                                        <h3>I certify I have been presented a full copy of these documents prior to signing and have been provided time to read and understand the terms and other disclosures which will govern my credit account.</h3>
                                    </div>
                                    <asp:HiddenField ID="hdnIsDisableCheckBox" runat="server" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="3" height="5">
                                    <img alt="spacer" src="../Content/Images/spacer_transparent.gif" /></td>
                            </tr>
                        </table>
                    </td>
                    <td width="30">&nbsp;</td>
                    <td align="left" valign="top">
                        <asp:Panel ID="pnlSignData" Visible="True" runat="server">
                            <span style="font-size: 14px;">Signature of Borrower </span>
                            <br />
                            <table width="100%">
                                <tr>
                                    <td>
                                        <canvas id="cnv" name="cnv" style="border:1px solid black" width="300" height="70"></canvas>
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
                                            <asp:ImageButton ID="btnShowPdf" OnClick="btnShowPdf_OnClick" runat="server" ImageUrl="../Content/Images/btn_printsign.gif" CssClass="btn-pop-submit" />
                                            <asp:ImageButton ID="btnSubmit" OnClick="btnSubmit_OnClick" OnClientClick="return validateIfAgreedTermsAndCondition();" runat="server" Style="display: none" ImageUrl="../Content/Images/btn_submit.gif" CssClass="btn-pop-submit" />
                                            <asp:HiddenField ID="hdnSigData" runat="server" />
                                        </p>
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>

                        <asp:Panel runat="server" ID="pnlClientSignImage" Enabled="False" Visible="False" HorizontalAlign="Left">
                            <table width="100%">
                                <tr>
                                    <td><span>Signature of Borrower</span><br />
                                        <asp:Image ID="imgClientSign" Width="200" runat="server" Style="margin: 10px 0 -30px 0;" />
                                        <p>
                                            ___________________________________________________________<br />
                                            &nbsp;
                                        </p>
                                    </td>
                                </tr>
                            </table>
                            <asp:ImageButton ID="btnResign" ImageUrl="../Content/Images/btn_resign.gif" Style="margin-right: 5px;" OnClick="btnResign_OnClick" OnClientClick="return validateIfAgreedTermsAndCondition();" runat="server" />
                            <asp:ImageButton ID="btnClose" ImageUrl="../Content/Images/btn_close_small.gif" AlternateText="Close" OnClientClick="closePopup(); return false;" runat="server" />

                        </asp:Panel>

                        <asp:Panel ID="pnlSign" Visible="False" runat="server">
                            <span>
                                <br />
                                <br />
                                <br />
                                X _________________________________________ 
                                    <br />
                                Signature of Borrower</span>
                            <br />
                            &nbsp;
                                    <br />
                            Date ___________________
                                    <br />
                            &nbsp;
                        </asp:Panel>
                    </td>
                </tr>
            </table>

            <table style="margin: 0px auto;">
                <!-- START SECTION -- ONLY SHOW WHEN PRINTING THE PDF -->
                <% if (IsShowLenderInformation)
                   {  %>
                <tr>
                    <td height="15">
                        <img alt="spacer" src="../Content/Images/spacer_transparent.gif" /></td>
                </tr>
                <% } %>
                <!-- END SECTION -- ONLY SHOW WHEN PRINTING THE PDF -->

                <tr>
                    <td colspan="3" height="5">
                        <img alt="spacer" src="../Content/Images/spacer_transparent.gif" /></td>
                </tr>
                <tr>
                    <td align="center"><span style="font-weight: 600;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; A COPY OF THE LOAN AGREEMENT IN FULL IS ATTACHED - PLEASE RETAIN FOR YOUR RECORDS &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span></td>
                </tr>
                <tr>
                    <td align="center"><span style="font-weight: 600;">&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; FOR QUESTIONS OR ASSISTANCE WITH THIS LOAN, PLEASE CONTACT YOUR PROVIDER OR CAREBLUE &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span></td>
                </tr>
                <!-- START SECTION -- ONLY SHOW WHEN PRINTING THE PDF -->
                <% if (IsShowLenderInformation)
                   {  %>
                <tr>
                    <td height="15">
                        <img alt="spacer" src="../Content/Images/spacer_transparent.gif" /></td>
                </tr>
                <tr>
                    <td align="right">Page 1 of 11
                    </td>
                </tr>

                <% } %>
                <!-- END SECTION -- ONLY SHOW WHEN PRINTING THE PDF -->
            </table>
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

