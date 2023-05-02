<%@ Page Language="C#" AutoEventWireup="true" CodeFile="bluecredit_standardprovisions1.aspx.cs"
    Inherits="bluecredit_StandardProvisions1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script src="../Scripts/jquery-1.4.1.min.js" type="text/javascript"></script>
    <style type="text/css">
        body
        {
            font-size: 11px;
            font-family: sans-serif;
        }
        h5 {
            display: inline;
        }
        p {
            margin: 0;
            padding: 0;
        }
        ul li
        {
            margin-top: 12px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div style="width: 768px;">
        <div id="divButtons" runat="server">
            <b style="padding-bottom: 5px;">Page 6 of 10</b>
            <div style="float: right">
                <a href="javascript:;" onclick="showHidePopup('bluecredit_StandardProvisions','bluecredit_StandardProvisions1')">
                    <img src="../Content/Images/btn_goback.gif" alt="Go Back" /></a>
                &nbsp; &nbsp;
                <a href="javascript:;" onclick="showHidePopup('bluecredit_Section4','bluecredit_StandardProvisions1')">
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
        <h5 style="background-color: lightcyan; font-size: 12px;">
            IMPORTAND INFORMATION ABOUT THIS AGREEMENT</h5>
        <p style="font-size: 13px;">
            <b>Assignment.</b> We may sell, assign or transfer any or all of our rights or duties
            under this Agreement or your account, including our rights to payments. We do not
            have to give you prior notice of such action. You may not sell, assign or transfer
            any of your rights or duties under this Agreement or your account.
        </p>
        <p style="font-size: 13px;">
            <b>Enforceability.</b> If any part of this Agreement is found to be void or unenforceable,
            all other parts of this Agreement will still apply
        </p>
        <p style="font-size: 13px;">
            <b>Governing Law.</b> Except as provided in the Resolving a Dispute with Arbitration
            section, this Agreement and your account are governed by federal law and, to the
            extent state law applies, the laws of Utah without regard to its conflicts of law
            principles. This Agreement has been accepted by us in Utah.
        </p>
        <p style="font-size: 13px;">
            <b>Waiver.</b> We may give up some of our rights under this Agreement. If we give
            up any of our rights in one situation, we do not give up the same right in another
            situation.
        </p>
        <h5 style="background-color: lightcyan; font-size: 12px;">
            RESOLVING A DISPUTE WITH ARBITRATION</h5>
        <h5 style="font-size: 12px; text-transform: uppercase;">
            <br />
            PLEASE READ THIS SECTION CAREFULLY. IF YOU DO NOT REJECT IT, THIS SECTION WILL APPLY
            TO YOUR ACCOUNT, AND MOST DISPUTES BETWEEN YOU AND US WILL BE SUBJECT TO INDIVIDUAL
            ARBITRATION. THIS MEANS THAT: (1) NEITHER A COURT NOR A JURY WILL RESOLVE ANY SUCH
            DISPUTE; (2) YOU WILL NOT BE ABLE TO PARTICIPATE IN A CLASS ACTION OR SIMILAR PROCEEDING;
            (3) LESS INFORMATION WILL BE AVAILABLE; AND (4) APPEAL RIGHTS WILL BE LIMITED.
        </h5>
        <ul>
            <li><b>What claims are subject to arbitration</b>
                <ol style="list-style-type: decimal">
                    <li>. If either you or we make a demand for arbitration, you and we must arbitrate any
                        d1spute or claim between you or any other user of your account, and us, our affiliates,
                        agents and/or providers that accept the card or program sponsors if it relates to
                        your account, except as noted below.</li>
                    <li>We will not require you to arbitrate: ( 1) any individual case in small claims court
                        or your slate's equivalent court, so long as it remains an individual case in that
                        court; or (2) a case we file to collect money you owe us. However, if you respond
                        to the collection lawsuit by claiming any wrongdoing, we may require you to arbitrate.</li>
                    <li>Notwithstanding any other language in this section, only a court, not an arbitrator,
                        will decide disputes about the validity, enforceability, coverage or scope of this
                        section or any part thereof (including, without limitation. the next paragraph of
                        this section and/or this sentence). However, any dispute or argument that concerns
                        the validity or enforceability of the Agreement as a whole is for the arbitrator,
                        not a court, to decide.</li>
                </ol>
            </li>
            <li><b>No Class Actions YOU AGREE NOT TO PARTICIPATE IN A CLASS, REPRESENTATIVE OR PRIVATE
                ATIORNEY GENERAL ACTION AGAINST US IN COURT OR ARBITRATION. ALSO, YOU MAY NOT BRING
                CLAIMS AGAINST US ON BEHALF OF ANY ACCOUNTHOLDER WHO IS NOT AACCOUNTHOLDER ON YOUR
                ACCOUNT, AND YOU AGREE THAT ONLY ACCOUNTHOLDERS ON YOUR ACCOUNT MAY BE JOINED IN
                A SINGLE ARBITRATION WITH ANY CLAIM YOU HAVE. </b>
                <br />
                If a court determines that this paragraph is not fully enforceable, only this sentence
                will remain in force and the remainder will be null and void, and the court's determination
                shall be subject to appeal. This paragraph does not apply to any lawsu1t or administrative
                proceeding filed against us by a state or federal government agency even when such
                agency is seeking relief on behalf of a class of borrowers, including you. This
                means that we will not have the right to compel arbitration of any claim brought
                by such an agency. </li>
            <li><b>How to start an arbitration, and the arbitration process</b>
                <ol style="list-style-type: decimal">
                    <li>The party who wants to arbitrate must notify the other party in writing. This notice
                        can be given after the beginning of a lawsuit or in papers filed in the lawsuit.
                        Otherwise, your notice must be sent to CareBlue Patient Finance, Legal Operations,
                        115 River Rd, Suite 424, Edgewater, NJ 07020, ATTN: ARBITRATION DEMAND. The party
                        seeking arbitration must select an arbitration administrator, which can be either
                        the American Arbitration Association (AAA), 1633 Broadway, 10th Floor, New York,
                        NY 10019, www.adr.org, (800) 778-7879, or JAMS, 620 Eighth Avenue, 34th Floor, New
                        York, NY 10018, www.jamsadr.com. (800) 352•5267. If neither administrator is able
                        or willing to handle the dispute, then the court will appoint an arbitrator.</li>
                    <li>. If a party files a lawsuit in court asserting claim(s) that are subject to arbitration
                        and the other party files a motion with the court to compel arbitration, which is
                        granted, it will be the responsibility of the party asserting the claim(s) to commence
                        the arbitration proceeding.</li>
                    <li>The arbitration administrator will appoint the arbitrator and will tell the parties
                        what to do next. The arbitrator must be a lawyer with at least ten years of legal
                        experience. Once appointed, the arbitrator must apply the same law and legal principles.
                        consistent with the FAA, that would apply in court, but may use different procedural
                        rules. If the administrator's rules conflicts with this Agreement, this Agreement
                        will control.</li>
                    <li>The arbitration will take place by phone or at a reasonably convenient location.
                        II you ask us to, we will pay ail the fees the administrator or arbitrator charges,
                        as long as we believe you are acting in good faith. We will always pay arbitration
                        costs, as well as your legal fees and costs, to the extent you prevail on claims
                        you assert against us in an arbitration proceeding which you have commenced.</li>
                </ol>
            </li>
            <li>
                <p>
                    <b>Governing Law for Arbitration:</b> This Arbitration section of your Agreement
                    is governed by the Federal Arbitration Act (FAA). Utah law shall apply to the extent
                    state law is relevant under the FAA. The arbitrator's decision will be final and
                    binding, except for any appeal right under the FAA. Any court with jurisdiction
                    may enter judgment upon the arbitrator's award.
                </p>
            </li>
            <li><b>How to reject this section
                <br />
                You may reject this Arbitration section of your Agreement. If you do that, only
                a court may be used to resolve any dispute or claim. To reject this section, you
                must send us a notice within 60 days after you open your account or we first provided
                you with your right to reject this section. The notice must include your name, address
                and account number, and must be mailed to CareBlue Patient Finance, 115 River Rd,
                Suite 424, Edgewater, NJ 07020. This is the only way you can reject this section.
            </b></li>
        </ul>
    </div>
    </form>
</body>
</html>
<script type="text/javascript">

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
