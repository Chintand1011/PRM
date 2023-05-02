<%@ Page Language="C#" AutoEventWireup="true" CodeFile="promissoryNote_popup.aspx.cs"
    Inherits="promissoryNote_popup" %>

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
    <style type="text/css"> 
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
               
               SetTabletState(0, tmr);
               tmr = null;

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

           function showPNPdf() {
               <%--var location = "<%=ClientSession.WebPathRootProvider %>" + "report/pdfviewer_popup.aspx";
               window.open(location, "pn", "location=0,status=0,scrollbars=1, width=1000,height=10000,titlebar=1,titlebar=0");--%>
               GetRadWindow().BrowserWindow.viewPdfViewer('pn');
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
                        <!-- START SECTION -- ONLY SHOW WHEN PRINTING THE PDF -->
                        <% if (IsShowFullTermsTable)
                           { %>
                        <div style="margin: 20px 0px -15px 0px;"><span style="padding: 0px 10px 0px 0; font-size: 1.2em; font-weight: 600;">EXHIBIT A</span></div>
                        <% } %>
                        <!-- ENDSECTION -- ONLY SHOW WHEN PRINTING THE PDF -->
                        <h2>CAREBLUE PROMISSORY NOTE</h2>
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
                    <td width="90">Loan ID:</td>
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
            <div id="divPromissoryNote">

                <div style="height: 300px; overflow: auto;">
                    <table width="680" border="0" align="center" style="font-size: 0.9em;">
                        <!-- START SECTION -- ONLY SHOW WHEN PRINTING THE PDF -->
                        <% if (IsShowFullTermsTable)
                           { %>
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
                        <tr valign="top">
                            <td>1. Promise to Pay. In return for a loan I have received, I promise to pay CareBlue ("you") the principal sum of <%=PrincipalAbbrWords%> (<%=Principal%>), together with interest thereon commencing on the date of origination at the rate of <%=APRAbbrWords%> (<%=APR%>) per annum simple interest. I understand that references in this Promissory Note ("Note") to you shall also include any person to whom you transfer this Note.
                            </td>
                        </tr>
                        <tr valign="top">
                            <td>
                                <br />
                                2. Payments. I will pay the principal, interest, and any late charges or other fees on this Note when due. Note is payable in <%=TermMax%> monthly installments of <%=MinMonthly%> each, consisting of principal and interest, commencing on the <%=NextPayDay%> day of <%=NextPayMonth%>, <%=NextPayYear%> and continuing until the final payment date of <%=LastPayDate%>, which is the maturity date of this Note. Because of the daily accrual of interest on my loan and the effect of rounding, my final payment may be more or less than my regular payment. My final payment shall consist of the then remaining principal, unpaid accrued interest and other charges due under this Note. All payments will be applied first to any unpaid fees incurred as a result of failed payments, as provided in Paragraph 11; then to any charges for making payments other than as provided in this Note; then to any late charges then due; then to any interest then due; and then to principal. No unpaid interest or charges will be added to principal. I further acknowledge that, if I make my payments after the scheduled due date, or incur a charge/fee, this Note will not amortize as originally scheduled, which may result in a substantially higher final payment amount.
                            </td>
                        </tr>
                        <tr>
                            <td height="5">
                                <img alt="spacer" src="../Content/Images/spacer_transparent.gif" /></td>
                        </tr>
                        <tr>
                            <td align="left" valign="top">
                                <span>3. Interest. Interest will be charged on unpaid principal until the full amount of principal has been paid. Interest under this Note will accrue daily, on the basis of a 365-day year. The interest rate I will pay will be the rate I will pay both before and after any default.
4. Late Charge. If the full amount of any monthly payment is not made by the end of fifteen (15) calendar days after its due date, I will pay you a late charge of the greater of $25 if I have paid my total minimum payment due by the due date in each of the prior six billing cycles, or $35 if I have failed to pay my total minimum payment due by the due date in any one or more of the prior six billing cycles, or 5.00% of the late payment. I will pay this late charge when it is assessed but only once on each late payment.
5. Waiver of Defenses; Exception to Waiver. Except as otherwise provided in this Note, you are not responsible or liable to me for the quality, safety, legality, or any other aspect of any property or services purchased with the proceeds of my loan. If I have a dispute with any person from whom I have purchased such property or services, I agree to settle the dispute directly with that person.
I further certify that, to my knowledge, the proceeds of my loan will not be applied in whole or part to purchase property or services from any person to whom any interest in this Note may be assigned. If, notwithstanding the preceding sentence, any person from whom I have purchased such property acquires any interest in this Note, then Paragraph 5 will not apply to the extent of that person's interest, even if that person later assigns that person's interest to another person.
6. Certification. I certify that the proceeds of my loan will not be applied in whole or in part to postsecondary educational expenses (i.e., tuition, fees, required equipment or supplies, or room and board) at a college/university/vocational school, as the term "postsecondary educational expenses" is defined in Bureau of Consumer Financial Protection Regulation Z, 12 C.F.R. § 1026.46(b)(3).
7. Method of Payment. You will pay the principal, interest, and any late charges or other fees on this Note when due. Those amounts are called "payments," "monthly payments," "monthly installments," or "monthly installment payments" in this Note. To ensure that my payments are processed in a timely and efficient manner, you have given me the choice of making my monthly payments (i) by automated withdrawal from an account that I designate using an automated clearinghouse (ACH) or other electronic fund transfer (EFT) in the manner described in the debit authorization I execute, or (ii) by manually scheduled one-time withdrawals from an account that I designate using an ACH or other electronic fund transfer, made by logging onto my account on the CareBlue website (www.mycareblue.com) or by calling CareBlue at (866) 220-2500, with my first payment being scheduled during the application process; and I have chosen one of these methods.
I also understand that I have alternate, non-standard payment options. If I have chosen to pay by check or bank wire by calling CareBlue at (866) 220-2500 and arranging such method of payment, I will make the payment to CareBlue PracticeAdvance LLC and if mailing is necessary I will send the payment to CareBlue PracticeAdvance, LLC, 700 N Valley Street, Suite B, PMB 18498, Anaheim, CA 92801-3824 in a manner so as to ensure it is received with sufficient time to process prior to my scheduled payment due date. To ensure efficient processing of my payment, I will reference my loan account number on the check or wire instructions. If I choose to pay by credit card, I agree to the addition of a convenience fee of 2.75% of the payment amount, which will be added to my total. If I choose to pay by a non-standard payment method, I understand and agree that an ACH or EFT will be processed against the payment method described in the debit authorization I execute in the case that an authorization cannot be obtained for the schedule payment amount.
I recognize that if I have automated withdrawal enabled, it is my responsibility to ensure that all amounts I owe are paid when due, even if not debited from my account.
If I close my account or if my account changes or is otherwise inaccessible such that you are unable to withdraw my payments from that account or process my check, I will notify you at least three (3) business days prior to any such closure, change or inaccessibility of my account, and authorize you to withdraw my payments, or I will provide a check, from another account that I designate.
With regard to payments made by automatic withdrawals from my account, I have the right to (i) stop payment of a preauthorized automatic withdrawal, or (ii) revoke my prior authorization for automatic withdrawals with regard to all further payments under this Note, by notifying the financial institution where my account is held, orally or in writing at least three (3) business days before the scheduled date of the transfer. I agree to notify you orally or in writing, at least three (3) business days before the scheduled date of the transfer, of the exercise of my right to stop a payment or to revoke my prior authorization for further automatic withdrawals.
8. Default and Remedies. If I fail to make any payment when due in the manner required by Paragraph 7, I will be delinquent.  If I (a) am delinquent, (b) file or have instituted against me a bankruptcy or insolvency proceeding or make any assignment for the benefit of creditors, or (c) in the event of my death, you may in your sole discretion deem me in default and accelerate the maturity of this Note and declare all principal, interest and other charges due under this Note immediately due and payable. If you deem me in default due to delinquency and if you exercise the remedy of acceleration, you will give me at least thirty (30) days prior notice of acceleration.
9. Prepayments. I may prepay this Note in full or in part at any time without penalty. I acknowledge that partial prepayments will not change the due date or amount of my monthly payment.
10. Waivers. You may accept late payments or partial payments, even though marked "paid in full," without losing any rights under this Note, and you may delay enforcing any of your rights under this Note without losing them. You do not have to (a) demand payment of amounts due (known as "presentment"), (b) give notice that amounts due have not been paid (known as "notice of dishonor"), or (c) obtain an official certification of nonpayment (known as "protest"). I hereby waive presentment, notice of dishonor and protest. Even if, at a time when I am in default, you do not require me to pay immediately in full as described above, you will still have the right to do so if I am in default at a later time. Neither your failure to exercise any of your rights, nor your delay in enforcing or exercising any of your rights, will waive those rights. Furthermore, if you waive any right under this Note on one occasion, that waiver will not operate as a waiver as to any other occasion.
11. Insufficient Funds Charge. If I attempt to make a payment, whether by automated withdrawal from my designated account or by other means, and the payment cannot be made due to (i) insufficient funds in my account, (ii) the closure, change or inaccessibility of my account without my having notified you as provided in Paragraph 7, or (iii) for any other reason (other than an error by you), I will pay you an additional fee of $25 if I have had no returned payments in each of the prior six billing cycles, or $35 if I have one or more returned payment in any one or more of the prior six billing cycles, for each returned or failed automated withdrawal or other item, unless prohibited by applicable law. I will pay this fee when it is assessed.
12. Attorneys' Fees. To the extent permitted by law, I am liable to you for your legal costs if you refer collection of my loan to a lawyer who is not your salaried employee. These costs may include reasonable attorneys' fees as well as costs and expenses of any legal action.
13. Loan Charges. If a law that applies to my loan and sets maximum loan charges is finally interpreted so that the interest or other loan charges collected or to be collected in connection with my loan exceed the permitted limits, then: (a) any such loan charge shall be reduced by the amount necessary to reduce the charge to the permitted limit; and (b) any sums already collected from me that exceeded permitted limits will be refunded to me. You may choose to make this refund by reducing the principal I owe under this Note or by making a direct payment to me.
14. Assignment. I may not assign any of my obligations under this Note without your written permission. You may assign this Note at any time without my permission. Unless prohibited by applicable law, you may do so without telling me. My obligations under this Note apply to all of my heirs and permitted assigns. Your rights under this Note apply to each of your successors and assigns.
15. Notices. All notices and other communications hereunder shall be given in writing and shall be deemed to have been duly given and effective (i) upon receipt, if delivered in person or by facsimile, email or other electronic transmission, or (ii) one day after deposit prepaid for overnight delivery with a national overnight express delivery service. Except as expressly provided otherwise in this Note, notices to me may be addressed to my registered email address or to my address set forth above unless I provide you with a different address for notice by giving notice pursuant to this Paragraph, and notices to you must be addressed to CareBlue at legal@careblue.com or CareBlue PracticeAdvance, LLC, 700 N Valley Street, Suite B, PMB 18498, Anaheim, CA 92801-3824, Attention: Legal Department.
16. Governing Law. This Note is governed by federal law and, to the extent state law applies, the laws of New Jersey without regard to its conflicts of law principles. 
17. Miscellaneous. No provision of this Note shall be modified or limited except by a written agreement signed by both you and me. The unenforceability of any provision of this Note shall not affect the enforceability or validity of any other provision of this Note.
18. Arbitration. RESOLUTION OF DISPUTES: I HAVE READ THIS PROVISION CAREFULLY, AND UNDERSTAND THAT IT LIMITS MY RIGHTS IN THE EVENT OF A DISPUTE BETWEEN YOU AND ME. I UNDERSTAND THAT I HAVE THE RIGHT TO REJECT THIS PROVISION, AS PROVIDED IN PARAGRAPH (i) BELOW.
(a) In this Resolution of Disputes provision:
(i) "I," "me" and "my" mean the promisor under this Note, as well as any person claiming through such promisor;
(ii) "You" and "your" mean CareBlue, any person servicing this Note for CareBlue, any subsequent holders of this Note or any interest in this Note, any person servicing this Note for such subsequent holder of this note, and each of their respective parents, subsidiaries, affiliates, predecessors, successors, and assigns, as well as the officers, directors, and employees of each of them; and
(iii) "Claim" means any dispute, claim, or controversy (whether based on contract, tort, intentional tort, constitution, statute, ordinance, common law, or equity, whether pre-existing, present, or future, and whether seeking monetary, injunctive, declaratory, or any other relief) arising from or relating to this Note or the relationship between you and me (including claims arising prior to or after the date of the Note, and claims that are currently the subject of purported class action litigation in which I am not a member of a certified class), and includes claims that are brought as counterclaims, cross claims, third party claims or otherwise, as well as disputes about the validity or enforceability of this Note or the validity or enforceability of this Section 
(b) Any Claim shall be resolved, upon the election of either you or me, by binding arbitration administered by the American Arbitration Association or JAMS, under the applicable arbitration rules of the administrator in effect at the time a Claim is filed ("Rules"). Any arbitration under this arbitration agreement will take place on an individual basis; class arbitrations and class actions are not permitted. If I file a claim, I may choose the administrator; if you file a claim, you may choose the administrator, but you agree to change to the other permitted administrator at my request (assuming that the other administrator is available). I can obtain the Rules and other information about initiating arbitration by contacting the American Arbitration Association at 1633 Broadway, 10th Floor, New York, NY 10019, (800) 778-7879, www.adr.org; or by contacting JAMS at 1920 Main Street, Suite 300, Irvine, CA 92614, (949) 224-1810, www.jamsadr.com. Your address for serving any arbitration demand or claim is CareBlue at legal@careblue.com or CareBlue PracticeAdvance, LLC, 700 N Valley Street, Suite B, PMB 18498, Anaheim, CA 92801-3824, Attention: Legal Department.
(c) Claims will be arbitrated by a single, neutral arbitrator, who shall be a retired judge or a lawyer with at least ten years' experience. You agree not to invoke your right to elect arbitration of an individual Claim filed by me in a small claims or similar court (if any), so long as the Claim is pending on an individual basis only in such court.
(d) You will pay all filing and administration fees charged by the administrator and arbitrator fees up to $1,000, and you will consider my request to pay any additional arbitration costs. If an arbitrator issues an award in your favor, I will not be required to reimburse you for any fees you have previously paid to the administrator or for which you are responsible. If I receive an award from the arbitrator, you will reimburse me for any fees paid by me to the administrator or arbitrator. Each party shall bear its own attorney's, expert's and witness fees, which shall not be considered costs of arbitration; however, if a statute gives me the right to recover these fees, or fees paid to the administrator or arbitrator, then these statutory rights will apply in arbitration.
(e) Any in-person arbitration hearing will be held in the city with the federal district court closest to my residence, or in such other location as you and we may mutually agree. The arbitrator shall apply applicable substantive law consistent with the Federal Arbitration Act, 9 U.S.C. § 1-16, and, if requested by either party, provide written reasoned findings of fact and conclusions of law. The arbitrator shall have the power to award any relief authorized under applicable law. Any appropriate court may enter judgment upon the arbitrator's award. The arbitrator's decision will be final and binding except that: (1) any party may exercise any appeal right under the FAA; and (2) any party may appeal any award relating to a claim for more than $100,000 to a three-arbitrator panel appointed by the administrator, which will reconsider de novo any aspect of the appealed award. The panel's decision will be final and binding, except for any appeal right under the FAA. Unless applicable law provides otherwise, the appealing party will pay the appeal's cost, regardless of its outcome. However, you will consider any reasonable written request by me for you to bear the cost.
(f) YOU AND I AGREE THAT EACH MAY BRING CLAIMS AGAINST THE OTHER ONLY IN OUR INDIVIDUAL CAPACITY, AND NOT AS A PLAINTIFF OR CLASS MEMBER IN ANY PURPORTED CLASS OR REPRESENTATIVE PROCEEDING. Further, unless both you and I agree otherwise in writing, the arbitrator may not consolidate more than one person's claims. The arbitrator shall have no power to arbitrate any Claims on a class action basis or Claims brought in a purported representative capacity on behalf of the general public, other borrowers, or other persons similarly situated. The validity and effect of this paragraph (f) shall be determined exclusively by a court, and not by the administrator or any arbitrator.
(g) If any portion of this Section 18 is deemed invalid or unenforceable for any reason, it shall not invalidate the remaining portions of this section. However, if paragraph (f) of this Section 18 is deemed invalid or unenforceable in whole or in part, then this entire Section 18 shall be deemed invalid and unenforceable. The terms of this Section 18 will prevail if there is any conflict between the Rules and this section.
(h) YOU AND I AGREE THAT, BY ENTERING INTO THIS NOTE, THE PARTIES ARE EACH WAIVING THE RIGHT TO A TRIAL BY JURY OR TO PARTICIPATE IN A CLASS ACTION. YOU AND I ACKNOWLEDGE THAT ARBITRATION WILL LIMIT OUR LEGAL RIGHTS, INCLUDING THE RIGHT TO PARTICIPATE IN A CLASS ACTION, THE RIGHT TO A JURY TRIAL, THE RIGHT TO CONDUCT FULL DISCOVERY, AND THE RIGHT TO APPEAL (EXCEPT AS PERMITTED IN PARAGRAPH (e) OR UNDER THE FEDERAL ARBITRATION ACT).
(i) I understand that I may reject the provisions of this Section 18, in which case neither you nor I will have the right to elect arbitration. Rejection of this Section 18 will not affect the remaining parts of this Note. To reject this Section 18, I must send you written notice of my rejection within 30 days after the date that this Note was made. I must include my name, address, and account number. The notice of rejection must be mailed to CareBlue PracticeAdvance, LLC, 700 N Valley Street, Suite B, PMB 18498, Anaheim, CA 92801-3824, Attention: Legal Department. This is the only way that I can reject this Section 18.
(j) You and I acknowledge and agree that the arbitration agreement set forth in this Section 18 is made pursuant to a transaction involving interstate commerce, and thus the Federal Arbitration Act shall govern the interpretation and enforcement of this Section 18. This Section 18 shall survive the termination of this Note and the repayment of any or all amounts borrowed thereunder.
19. Electronic Transactions.  THIS NOTE INCLUDES YOUR EXPRESS CONSENT TO ELECTRONIC TRANSACTIONS AND DISCLOSURES, WHICH CONSENT IS SET FORTH IN THE PARAGRAPH ENTITLED "CONSENT TO DOING BUSINESS ELECTRONICALLY" AS DISCLOSED IN CAREBLUE'S TERMS OF USE ON MYCAREBLUE.COM, THE TERMS AND CONDITIONS OF WHICH ARE EXPRESSLY INCORPORATED HEREIN IN THEIR ENTIRETY.  YOU EXPRESSLY AGREE THAT THIS NOTE MAY COMPRISE A "TRANSFERABLE RECORD" FOR ALL PURPOSES UNDER THE ELECTRONIC SIGNATURES IN GLOBAL AND NATIONAL COMMERCE ACT AND THE UNIFORM ELECTRONIC TRANSACTIONS ACT.
20.  Registration of Note Owners.  I have appointed CareBlue PracticeAdvance, LLC as my authorized agent (in such capacity, the "Note Registrar") to maintain a book-entry system (the "Register") for recording the beneficial owners of interests in this Note (the "Note Owners").  The person or persons identified as the Note Owners in the Register shall be deemed to be the owner(s) of this Note for purposes of receiving payment of principal and interest on such Note and for all other purposes. With respect to any transfer by a Note Owner of its beneficial interest in this Note, the right to payment of principal and interest on this Note shall not be effective until the transfer is recorded in the Register.
21. State Notices
California Residents
Married registrants may apply for a separate account. As required by law, I am hereby notified that a negative credit report reflecting on my credit record may be submitted to a credit reporting agency if I fail to fulfill the terms of my credit obligations.
Iowa Residents
NOTICE TO CONSUMER: 1. Do not sign this paper before you read it. 2. You are entitled to a copy of this paper. 3. You may prepay the unpaid balance at any time without penalty and may be entitled to receive a refund of unearned charges in accordance with law.
IMPORTANT: READ BEFORE SIGNING. The terms of this agreement should be read carefully because only those terms in writing are enforceable. No other terms or oral promises not contained in this written contract may be legally enforced. I may change the terms of this agreement only by another written agreement.
Kansas Residents
NOTICE TO CONSUMER: 1. Do not sign this agreement before you read it. 2. You are entitled to a copy of this agreement. 3. You may prepay the unpaid balance at any time without penalty.
Missouri Residents
Oral or unexecuted agreements or commitments to loan money, extend credit or to forbear from enforcing repayment of a debt including promises to extend or renew such debt are not enforceable. To protect me (borrower(s)) and you (creditor) from misunderstanding or disappointment, any agreements we reach covering such matters are contained in this writing, which is the complete and exclusive statement of the agreement between us, except as we may later agree in writing to modify it.
Nebraska Residents
A credit agreement must be in writing to be enforceable under Nebraska law. To protect you and me from any misunderstandings or disappointments, any contract, promise, undertaking, or offer to forebear repayment of money or to make any other financial accommodation in connection with this loan of money or grant or extension of credit, or any amendment of, cancellation of, waiver of, or substitution for any or all of the terms or provisions of any instrument or document executed in connection with this loan of money or grant or extension of credit, must be in writing to be effective.
New Jersey Residents
Because certain provisions of this Note are subject to applicable laws, they may be void, unenforceable or inapplicable in some jurisdictions. None of these provisions, however, is void, unenforceable or inapplicable in New Jersey.
Ohio Residents
The Ohio laws against discrimination require that all creditors make credit equally available to all credit worthy customers, and that credit reporting agencies maintain separate credit histories on each individual upon request. The Ohio civil rights commission administers compliance with this law.
Utah Residents
As required by Utah law, I am hereby notified that a negative credit report reflecting on my credit record may be submitted to a credit reporting agency if I fail to fulfill the terms of my credit obligations. 
This Note is the final expression of the agreement between the parties and may not be contradicted by evidence of any alleged oral agreement.
Wisconsin Residents
No provision of a marital property agreement, a unilateral statement or a court decree adversely affects the interest of the creditor unless the creditor, prior to the time the credit is granted, is furnished a copy of the agreement, statement or decree or has actual knowledge of the adverse provision when the obligation to the creditor is incurred.
22. By signing this Note, I acknowledge that I (i) have read and understand all terms and conditions of this Note, (ii) agree to the terms set forth herein, and (iii) acknowledge receipt of a completely filled-in copy of this Note.
Wisconsin Residents: NOTICE TO CUSTOMER: (a) DO NOT SIGN THIS IF IT CONTAINS ANY BLANK SPACES. (b) YOU ARE ENTITLED TO AN EXACT COPY OF ANY AGREEMENT YOU SIGN. (c) YOU HAVE THE RIGHT AT ANY TIME TO PAY IN ADVANCE THE UNPAID BALANCE DUE UNDER THIS AGREEMENT AND YOU MAY BE ENTITLED TO A PARTIAL REFUND OF THE FINANCE CHARGE.
CAUTION    IT IS IMPORTANT THAT YOU THOROUGHLY READ THE CONTRACT BEFORE YOU SIGN IT.
Date: _______________
By: CareBlue PracticeAdvance, LLC
Attorney-in-Fact for:




_________________________________ [Borrower]
(Signed Electronically)


                                </span>
                            </td>
                        </tr>
                        <tr>
                            <td height="5">
                                <img alt="spacer" src="../Content/Images/spacer_transparent.gif" /></td>
                        </tr>

                    </table>
                </div>



                <% if (!IsShowFullTermsTable)
                   { %>

                <table style="margin: 0px auto;">
                    <tr>
                        <td>&nbsp;</td>
                        <td align="left" valign="top">
                            <table width="400">
                                <!-- START SECTION -- ONLY SHOW WHEN PRINTING THE PDF -->
                                <% if (IsShowFullTermsTable)
                                   { %>
                                <tr>
                                    <td height="15">
                                        <img alt="spacer" src="../Content/Images/spacer_transparent.gif" /></td>
                                </tr>
                                <% } %>
                                <!-- ENDSECTION -- ONLY SHOW WHEN PRINTING THE PDF -->
                                <tr>
                                    <td>
                                        <h1>PRIOR TO SIGNING THIS PROMISSORY NOTE</h1>
                                        <div>Please read this entire disclosure carefully. Unless you agree to the terms of this agreement, you should not sign or accept the loan.</div>
                                    </td>
                                </tr>
                                <tr class="ExtraPadTbl2">
                                    <td>
                                        <asp:CheckBox ID="chkAgreementTerms" runat="server" Checked="False" />
                                        <div style="margin: -20px 0 -0px 25px;">
                                            <h3>I have read and understand the fees and conditions of the loan as<br />
                                                disclosed, and agree to comply with all terms of this loan agreement.</h3>
                                        </div>
                                        <asp:HiddenField ID="hdnIsDisableCheckBox" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td width="30">&nbsp;</td>
                        <td align="left" valign="top">&nbsp;<br />
                            <asp:Panel ID="pnlSignData" Visible="True" runat="server">
                                <table width="100%">
                                    <tr>
                                        <td>
                                            <canvas id="cnv" name="cnv" style="border: 1px solid black" width="300" height="70"></canvas>
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
                                            <p>________________________________________________________________<br />
                                                &nbsp;</p>
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

                <% } %>

                <!-- START SECTION -- ONLY SHOW WHEN PRINTING THE PDF -->
                <% if (IsShowFullTermsTable)
                   { %>
                <table>
                    <tr>
                        <td height="40">
                            <img alt="spacer" src="../Content/Images/spacer_transparent.gif" /></td>
                    </tr>
                    <tr>
                        <td align="right">Page 1 of 1
                        </td>
                    </tr>
                </table>

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

