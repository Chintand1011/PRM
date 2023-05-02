<%@ Control Language="C#" AutoEventWireup="true" CodeFile="BCCreditScore.ascx.cs" Inherits="Controls_Bluecredit_BCCreditScore" %>

<table>
    <tr>
        <td width="100">
            <pfs2>CREDIT SCORE:</pfs2>
        </td>
        <td>
            <pfs5><%=respScoreBCResult%></pfs5>
        </td>
        <td></td>
    </tr>
    <tr>
        <td>
            <pfs2>RISK PROFILE:</pfs2>
        </td>
        <td>
            <pfs6><b><%=RespScoreBCRisk%></b> [<%=RespScoreBCRiskNumber%> RISK]</pfs6>
        </td>
        <td></td>
    </tr>
    <tr>
        <td>
            <pfs2>MAXIMUM:</pfs2>
        </td>
        <td>
            <pfs6><%=BCRecAmountAdj%></pfs6>
        </td>
        <td></td>
    </tr>
    <!--
    <tr>
        <td>
            <pfs2>ACTUAL ISSUED:</pfs2>
        </td>
        <td>
            <pfs6><%=BCLimitSum%>&nbsp; (<%=BCUsedPercentage%>  Used)</pfs6>
        </td>
        <td></td>
    </tr>
    <tr>
        <td>
            <pfs2>VIEW FILE:</pfs2>
        </td>
        <td valign="middle">
            <pfs7><%=ServiceDate%> (#<%=PFSID%>)</pfs7>
        </td>
        <td></td>
    </tr>
    -->
</table>
<div style="color: #444444;">
    <% if (FlagPFSExpired)
       { %>
            <div style="margin:3px 0 0 0px;">
            <img alt="Warning" src="../Content/Images/warning.png" height="20" style="margin-bottom:-5px;"/>&nbsp;
            <span style="color:#333333; margin-top:25px;">Warning: Credit check is more than 30 days old.</span>
            </div>
    <% } %>
</div>
