<%@ Control Language="C#" AutoEventWireup="true" CodeFile="Footer.ascx.cs" Inherits="Controls_Footer" %>
<div class="footer">
    <div style="float: left;">
        <img src="Content/Images/Providers/careblue_poweredby_xsm.gif" style="margin-top:0px; padding-right:8px;" height="30" alt="Powered By" />
    </div>
    <div class="fleft">
        © 2010 - <%=DateTime.Now.Year%>
        <br />
        <div class="aleft">
            &nbsp;CareBlue PracticeAdvance, LLC<br />
            <br />
            &nbsp;</div>
    </div>
    <div class="fright">Policies 
        [ <a href="javascript:;" onclick="gotoPrivacyTerms()"><b>Privacy</b></a> | 
        <a  href="javascript:;" onclick="gotoLegalTerms()"><b>Legal</b></a> |
        <a  href="javascript:;" onclick="gotoBillingTerms()"><b>Billing</b></a> ]
    </div>
    <div style="clear: both;"></div>
</div>
