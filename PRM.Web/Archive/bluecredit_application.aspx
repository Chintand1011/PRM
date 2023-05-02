<%@ Page Language="C#" AutoEventWireup="true" CodeFile="bluecredit_application.aspx.cs"
    Inherits="Terms_bluecredit_application" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../Scripts/jquery-1.4.1.js" type="text/javascript"></script>
    <link href="../Styles/BlueCredit.css" rel="stylesheet" type="text/css" />
    <meta name="GENERATOR" content="Microsoft Visual Studio .NET 7.1">
    <meta name="CODE_LANGUAGE" content="C# .NET 7.1">
    <meta name="vs_defaultClientScript" content="JavaScript">
    <meta name="vs_targetSchema" content="http://schemas.microsoft.com/intellisense/ie5">
    <telerik:radcodeblock runat="server" id="radCodeBlock1">
      <script type="text/javascript">

          var Index;

          $(function () {
              onSign();
          });

          function pluginLoaded() {
              //alert("Plugin loaded!");
          }

          function onClear() {
              document.getElementById('sigplus').clearSignature();
          }

          function onSign() {
              document.getElementById('sigplus').tabletState = 1;
              document.getElementById('sigplus').captureMode = 1;
              Index = setInterval(Refresh, 50);

              document.getElementById('sigplus').antiAliasSpotSize = .85;
              document.getElementById('sigplus').antiAliasLineScale = .55;
          }


          function onDone() {
              if (document.getElementById('sigplus').totalPoints == 0) {
                  alert("Please sign before continuing");
                  return false;
              }
              else {
                  document.getElementById('sigplus').tabletState = 0;
                  clearInterval(Index);
                  //RETURN TOPAZ-FORMAT SIGSTRING
                  document.getElementById('sigplus').compressionMode = 1;
                  //alert(document.getElementById('sigplus').sigString);
                  //this returns the signature in Topaz's own format, with biometric information
                  var hiddenControl = '<%= hdnSigData.ClientID %>';
                  document.getElementById(hiddenControl).value = document.getElementById('sigplus').sigString;
                  $("#<%=btnSubmit.ClientID%>").click();
            }

        }

        function Refresh() {
            document.getElementById('sigplus').refreshEvent();
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

    </script>     
    </telerik:radcodeblock>
</head>
<body>
    <form id="form1" runat="server">
        <div class="main-div">
            <div id="divButtons" runat="server">
                <b style="padding-bottom: 5px;">Page 2 of 10</b>
                <div style="float: right">
                    <a href="javascript:;" style="text-decoration: none" onclick="showHidePopup('bluecredit_title','bluecredit_application')">
                        <img src="../Content/Images/btn_goback.gif" alt="Go Back" /></a>
                    &nbsp; &nbsp;
                <a href="javascript:;" onclick="showHidePopup('bluecreditSummary_popup','bluecredit_application')">
                    <img src="../Content/Images/btn_next.gif" alt="Next" /></a>
                </div>
                <div style="float: right; display: none;">
                    <a href="javascript:;">
                        <img src="../Content/Images/btn_save.gif" onclick="saveLendingAgreement()" alt="Save" />
                    </a>
                </div>
                <br />
                <br />
                <br />
            </div>
            <%=PatinetID %> <%=IdentificationID %> <%=IdentificationTypeAbbr %> <%=IDNumber %> <%=LocationAbbr %> <%=DOB %> <%=IssueDate %> <%=ExpirationDate %> <%=Notes %>
            <table>
                <tr>
                    <td style="width: 260px;">
                        <img style="height: 49px; width: 178px;" alt="Provider" src="../Content/Images/Providers/careblue_logo.jpg"
                            id="header_imgLogo" />
                    </td>
                    <td style="width: 240px;">
                        <p align="center">
                            <b style="font-size: 12px;">APPLICATION AND CREDIT CARD
                            <br />
                                ACCOUNT AGREEMENT </b>
                            <br />
                            <span style="font-size: 10px;">A credit Service of GE Capital Retail Bank </span>
                        </p>
                    </td>
                    <td style="width: 252px;">
                        <p style="font-size: 14px; text-align: right;">
                            For Providers: <b>(800) 859-9975</b>
                            <br />
                            For Patients/Clients: <b>(800) 365•8295</b>
                        </p>
                    </td>
                </tr>
            </table>
            <p style="margin-top: -5px;">
                <span style="float: right; font-size: 11px;">Manage by internet: <span style="font-size: 16px; font-weight: bold;">CareBlue.com/Pay</span> </span><span style="float: left; font-size: 11px;">
                    <b>Married WI Residents only</b>: If you are applying for an individual account
                    and your
                    <br />
                    spouse also is a WI Resident, combine your spiuse&#39;s financial information</span>
            </p>
            <table style="background-color: #98AFC7; height: 30px; width: 99%;">
                <tr>
                    <td style="width: 136px;">
                        <p style="font-size: 12px;">
                            PhotoID verified (initial):
                        </p>
                        <br />
                    </td>
                    <td style="width: 204px;">
                        <p style="font-size: 12px;">
                            Application 1st ID Type / Number
                        </p>
                        <br />
                    </td>
                    <td style="width: 90px;">
                        <p style="font-size: 12px;">
                            Insurance State
                        </p>
                        <br />
                    </td>
                    <td style="width: 82px;">
                        <p style="font-size: 12px;">
                            Exp.Date
                        </p>
                        <br />
                    </td>
                    <td style="width: 146px;">
                        <p style="font-size: 12px;">
                            Application 1st ID Type / Issuer
                        </p>
                        <br />
                    </td>
                    <td style="width: 85px;">
                        <p style="font-size: 12px;">
                            Exp.Date
                        </p>
                        <br />
                    </td>
                </tr>
            </table>
            <p style="font-weight: bold; text-align: center;">
                1. APPLICANT INFORMATION: Please tell us about yourself. <span style="font-size: 14">Please note that you must reside in the united states and be 18 years or older to
                apply. </span>
            </p>
            <p style="font-weight: bold;" align="justify">
                Alimony, child support or separate maintenance income need not be included unless
            relied upon for credit. You may include the monthly amount that you have available
            to spend from you assets.
            </p>
            <table class="application-information" width="100%">
                <tr>
                    <td class="style4">
                        <span style="font-size: 10px;">Name (First-Middel-Last) Please Print</span>
                    </td>
                    <td class="style5">
                        <span style="font-size: 12px;">Date of Birth</span>
                        <br />
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /&nbsp;&nbsp;
                    </td>
                    <td class="style6">
                        <span style="font-size: 12px;">Social Security Number</span><br />
                        &nbsp; &nbsp;&nbsp;&nbsp;&nbsp; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    -
                    </td>
                    <td>
                        <span style="font-size: 9px;">Home Phone Number*</span>
                        <br />
                        (&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;)
                    </td>
                </tr>
                <tr>
                    <td colspan="3">Mailing Address
                    </td>
                    <td>Cell/Other Phone Number*
                    </td>
                </tr>
                <tr>
                    <td colspan="4">
                        <span style="font-size: 12px;">Contact Person Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        Street Address(Street Name and Number)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        City&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        State&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        Zip</span>
                        <br />
                    </td>
                </tr>
                <tr>
                    <td colspan="4" style="border: 0">
                        <div style="float: left; width: 245px; height: 53px; border: 1px solid black;">
                            <p>
                                E-Mail Address(optional)*
                            </p>
                        </div>
                        <div style="float: right; width: 500px; border: 1px solid black;">
                            <p>
                                *You authorize CareBlue PracticeAdvance, LLC (CareBlue) to contact you at each phone number
                            you have provided. By providing a cell phone number and/or email address, you agree
                            to receive special offers, updates, and account information, including text messages
                            from Providers that accept CBPF credit. Standard text messaging rates may apply.
                            </p>
                        </div>
                    </td>
                </tr>
            </table>
            <p>
                <b>JOINT INFORMATION </b><span style="font-size: 11px;">An additional card will be issued
                to the person indicated below. The applicant (and joint applicant, if any) will
                be liable for all transactions made on the account including those made by any authorized
                user. JOINT APPLICANT: You agree that we may send notices to you and/or applicant
                at the applicant's address, regardless of whether you line at that address.
                </span>
            </p>
            <p style="font-weight: bold;" align="justify">
                Alimony, child support or separate maintenance income need not be included unless
            relied upon for credit. You may include the monthly amount that you have available
            to spend from you assets.
            </p>
            <table class="application-information" width="100%">
                <tr>
                    <td class="appInfo-col1">
                        <p style="font-size: 12px;">
                            Name (First-Middel-Last) Please Print
                        </p>
                        <br />
                    </td>
                    <td class="appInfo-col2">
                        <p style="font-size: 12px;">
                            Date of Birth
                        </p>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;/&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; /&nbsp;&nbsp;
                    </td>
                    <td class="appInfo-col3">
                        <p style="font-size: 12px;">
                            Social Security Number
                        </p>
                        &nbsp; &nbsp;&nbsp;&nbsp;&nbsp; -&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    -
                    </td>
                    <td class="appInfo-col4" colspan="2">
                        <p style="font-size: 12px;">
                            Home Phone Number*
                        </p>
                        (&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;)
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <p style="font-size: 12px;">
                            Mailing Address
                        </p>
                        <br />
                    </td>
                    <td colspan="2">
                        <p style="font-size: 12px;">
                            Cell/Other Phone Number*
                        </p>
                        <br />
                    </td>
                </tr>
                <tr>
                    <td colspan="5">
                        <p style="font-size: 12px;">
                            Contact Person Name&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        Street Address(Street Name and Number)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        City&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        State&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        Zip
                        </p>
                        <br />
                    </td>
                </tr>
                <tr>
                    <td colspan="5">
                        <p style="font-size: 12px;">
                        </p>
                        <br />
                    </td>
                </tr>
                <tr>
                    <td style="width: 213px;">
                        <p style="font-size: 12px;">
                            Joint Applicant ID Type / Number
                        </p>
                        <br />
                    </td>
                    <td style="width: 98px;">
                        <p style="font-size: 12px;">
                            Issuance State
                        </p>
                        <br />
                    </td>
                    <td style="width: 136px;">
                        <p style="font-size: 12px;">
                            Exp.Date
                        </p>
                        <br />
                    </td>
                    <td style="width: 186px;">
                        <p style="font-size: 12px; width: 192px;">
                            Joint Applicant 2nd ID Type / Issuer
                        </p>
                        <br />
                    </td>
                    <td>
                        <p style="font-size: 12px;">
                            Exp.Date
                        </p>
                        <br />
                    </td>
                </tr>
                <tr>
                    <td style="width: 213px;">
                        <p style="font-size: 12px;">
                            E-Mail Address(optional)*
                        </p>
                        <br />
                    </td>
                    <td colspan="4">
                        <p style="font-size: 11px;">
                            You authorize CareBlue PracticeAdvance, LLC (CareBlue) to contact you at each phone number
                        you have provided. By providing a cell phone number and/or email address, you agree
                        to receive special offers, updates, and account information, including text messages
                        from Providers that accept CBPF credit. Standard text messaging rates may apply.
                        </p>
                    </td>
                </tr>
            </table>
            <b>3. APPLICANT and JOINT APPLICANT: We need your signature(s) below.</b><p>
                By applying for this account, I am asking CareBlue Patient Finance (“CBPF”) to issue
            me a BlueCredit Credit Account and Card (the “Card”), and I agree that:
            </p>
            <ul>
                <li>I am providing the information in this application to CBPF, CareBlue, LLC, and providers
                that accept the Card and program sponsors. CBPF may provide information about me
                (even if my application is declined) to CareBlue LLC, providers that accept the
                Card and program sponsors (and their respective affiliates) so that they can create
                and update their records, and provide me with service and special offers.</li>
                <li>CBPF may obtain information from others about me (including requesting reports from
                consumer reporting agencies and other sources) to evaluate my application, and to
                review, maintain or collect my account.</li>
                <li>I consent to CBPF and any other owner or servicer of my account contacting me about
                my account, including using any contact information or cell phone numbers I provide,
                and I consent to the use of any automatic telephone dialing system and/or an artificial
                or prerecorded voice when contacting me, even if I am charged for the call under
                my phone plan. </li>
                <li>I have read and agree to the credit terms and other disclosures in this application,
                and I understand that if my application is approved, the CBPF credit account agreement
                ("Agreement”) will govern my account. Among other things, the Agreement: (1) includes
                a resolving a dispute with arbitration provision that limits my rights unless I
                reject the provision by following the provision's instructions; and (2) makes each
                applicant responsible for paying the entire amount of the credit extended. </li>
            </ul>
            <b>PLEASE SEE NEXT PAGE FOR RATES, FEES AND OTHER COST INFORMATION. </b>
            <br />
            <b>Federal law requires CBPF to obtain, verify and record information that identifies
            you when you open an account. CBPF will use your name, address, date of birth, and
            other Information for this purpose. </b>
            <p>
                If I have been pre-approved l request that you open the type of account for which
            I was pre-approved. I have read the Prescreen Disclosures, credit terms and other
            disclosures on the next pages and have been provided my credit limit applicable
            to the account. CBPF reserves the right to refuse to open an account in my name
            if CBPF determines that I no longer meet CBPF's credit criteria or if I do not have
            the ability to make the minimum payments on the account.
            </p>

            <asp:Panel ID="pnlSignData" Visible="True" runat="server">

                <object id="sigplus" type="application/sigplus" width="300" height="80">
                    <param name="onload" value="pluginLoaded" />
                </object>

                <p class="buttons">
                    <input type="file" id="file1" style="display: none" />

                    <a href="javascript:;" onclick="javascript: onClear();">
                        <img alt="Clear" src="../Content/Images/btn_clear_small.gif" /></a>  &nbsp;&nbsp;&nbsp;&nbsp
                                                        <a href="javascript:;" onclick="javascript: onDone();">
                                                            <img alt="Done" src="../Content/Images/btn_done_small.gif" /></a> &nbsp;&nbsp;&nbsp;&nbsp
                                                        
                                                            <asp:ImageButton ID="btnSubmit" OnClick="btnSubmit_Click" runat="server" Style="display: none" ImageUrl="../Content/Images/btn_submit.gif" CssClass="btn-pop-submit" />
                    <asp:HiddenField ID="hdnSigData" runat="server" />

                </p>

            </asp:Panel>
            <asp:Panel runat="server" ID="pnlClientSignImage" Enabled="False" Visible="False">

                <asp:Image ID="imgClientSign" Width="200" runat="server" Style="margin: 10px 0 -30px 0;" />
                <asp:Literal ID="lthtml" Visible="False" Text="<br /> <br /> <br />" runat="server"></asp:Literal>


                <p>_______________________________________________</p>

                <br />
                The undersigned hereby agrees to pay. 
            </asp:Panel>

            <p>
                If you apply with a Joint Applicant, each of you will be jointly and individually
            responsible for obligations under the Agreement and by signing below, you each agree
            that you intend to apply for joint credit.
            </p>
            <table width="100%" style="border: 1px solid black; border-collapse: collapse;">
                <tr>
                    <td class="style1">
                        <span style="font-size: 14px;">Signature of Applicant
                        <br />
                            <br />
                            <b>X</b>_____________________________<b>Date</b>____________
                        <br />
                            (Please Do Not Print)</span>
                    </td>
                    <td>
                        <span style="font-size: 14px;">Signature of Joint Applicant(If Applicable)
                        <br />
                            <br />
                            <b>X</b>____________________________<b>Date</b>_____________
                        <br />
                            (Please Do Not Print)</span>
                    </td>
                </tr>
            </table>
            <br />
            <span style="float: left; font-size: 13px;">182-077-00
            <br />
                Rev. 7/27/2013
            <br />
                DATE OF PRINTING 7/13 </span><span style="margin-left: 100px; font-size: 13px;">PLEASE
                READ THE CAREBLUE PATIENT FINANCE CREDIT ACCOUNT AGREEMENT
                <br />
                    <span style="margin-left: 222px;">BEFORE SIGNING IN THIS APPLICATION</span></span>
        </div>
        <%= AccountHolder%>
        <%= AccountHolderType%>
        <%= AccountName%>
        <%= Addr1%>
        <%= Addr2%>
        <%= City%>
        <%= CreditLimit%>
        <%= PlanName%>
        <%= Email%>
        <%= FlagEmailBillsAbbr%>
        <%= MinDownPay%>
        <%=MinPayAmount %>
        <%= OpenDate%>
        <%= PhonePri%>
        <%=PromoRemainAbbr %>
        <%= PtSetRecurringMin%>
        <%= State%>
        <%= StateTypeID %>
        <%=TermRemainAbbr %>
        <%=Zip %>
        <%= Zip4%>
    </form>



</body>
</html>

