<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/User.master" CodeFile="status.aspx.cs"
    Inherits="status" %>

<asp:Content ID="HeaderContent" runat="server" ContentPlaceHolderID="HeadContent">
</asp:Content>
<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="MainContent">
    <asp:UpdatePanel runat="server">
        <ContentTemplate>
            <div class="hdrTitle">
                <h1>Patient Account Status</h1>
            </div>
            <div class="bodyMain">
                <h2>Patient summary information and account notes.</h2>
            <div style="font-size: 1.1em;"> <!--Add to enlarge all text on this screen as its the main dashboard for patient data -->
                <table width="100%" border="0">
                    <tr>
                        <!-------------------------------------------------------------- COL Spacer ---------------------------------------------------------------------->
                        <td width="5%">&nbsp;</td>
                        <!----------------------------------------------------------------- COL 1 ---------------------------------------------------------------------->
                        <td width="30%" valign="top" class="ExtraPad align-popup-fields">
                            <h3 style="margin-left: 20px;">Patient Demographics</h3>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Patient:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblPatient" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Account ID:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblAccountID" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="DOB:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblDOB" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Social:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblSocial" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row" id="divGuardian" runat="server" visible="False">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Guardian:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblGuardian" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="MRN:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblMRNNumber" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Insurer:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblInsurer" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Provider:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblProvider" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Location:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblLocation" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Address:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblAddress" runat="server"></asp:Label>
                                    <asp:Literal ID="litAddress" runat="server"></asp:Literal>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Alternate:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblAlternate" runat="server"></asp:Label>
                                    <asp:Literal ID="litAlternate" runat="server"></asp:Literal>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Web PIN:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblWebPIN" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Last Web Login:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblLastWebLogin" runat="server"></asp:Label>
                                </div>
                            </div>
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Last Mobile Login:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    <asp:Label ID="lblLastMobileLogin" runat="server"></asp:Label>
                                </div>
                            </div>
                            <br />&nbsp;
                            <div class="form-row">
                                <div class="editor-label">
                                    <asp:Label runat="server" Text="Manage Patient:"></asp:Label>
                                </div>
                                <div class="editor-field">
                                    &nbsp; <asp:ImageButton PostBackUrl="../patient/manage.aspx" ImageUrl="../Content/Images/btn_edit_small.gif" style="margin-top:2px;" runat="server"/>
                                </div>
                            </div>
                        </td>
                        <!----------------------------------------------------------------- COL 2 ---------------------------------------------------------------------->
                        <td width="25%" valign="top" class="ExtraPad align-popup-fields">
                            <h3 style="margin-left:-30px;">Recent Account Activity</h3>
                            <p style="color: red; font-size: 18">
                                <%=BouncedEmailError %>
                            </p>

                            <div>
                                <p class="ReducePad"><a href="../patient/statements.aspx"><b><%=StatementCount %></b> Active Statements</a></p>
                                <p class="ReducePad"><a href="../patient/payments.aspx"><b><%=Balance %></b> Outstanding Balance</a></p>
                                <p class="ReducePad"><a href="../patient/payments.aspx"><b><%=AmountPaid %></b> Recent Payments</a></p>
                                <p class="ReducePad"><a href="../patient/payments.aspx"><b><%=AmountPastDue %></b> Past Due (>30 days)</a> </p>
                                <p class="ReducePad"><a href="../patient/bluecredit.aspx"><b><%=BlueCreditCount %></b> Active BlueCredit Plans</a> </p>
                                <p class="ReducePad"><a href="../patient/paymentplans.aspx"><b><%=PayPlanCount %></b> Active Payment Plans</a> </p>
                                <p class="ReducePad"><a href="../reporting/messagectr.aspx"><b><%=PendingRequestCount %></b> Outstanding Action Items</a> </p>
                                <p class="ReducePad">&nbsp;</p>
                            </div>

                            <div id="divAge" runat="server" visible="False" style="margin-bottom:2px;">
                                <asp:Image ID="imgAge" runat="server" />
                                &nbsp; <a href="../patient/manage.aspx"><b>Legal Guardian</b></a>
                            </div>
                            <div id="divProfile" runat="server" visible="False" style="margin-bottom:2px;">
                                <asp:Image ID="imgProfile" runat="server" />
                                &nbsp; <a href="../patient/manage.aspx"><b>Complete Profile</b></a>
                            </div>
                            <div id="divValidEmail" runat="server" visible="False" style="margin-bottom:2px;">
                                <asp:Image ID="imgValidEmail" runat="server" />
                                &nbsp; <a href="../patient/manage.aspx"><b>Valid Email On File</b></a>
                            </div>
                            <div id="divSsn" runat="server" visible="False" style="margin-bottom:2px;">
                                <asp:Image ID="imgSsn" runat="server" />
                                &nbsp; <a href="../patient/manage.aspx"><b>Social Security Number</b></a>
                            </div>
                            <div id="divTUFS" runat="server" visible="False" style="margin-bottom:2px;">
                                <asp:Image ID="imgTUFS" runat="server" />
                                &nbsp; <a href="../patient/pfsreport.aspx"><b>Valid Credit Inquiry</b></a>
                            </div>
                            <div id="divCheckCard" runat="server" visible="False" style="margin-bottom:2px;">
                                <asp:Image ID="imgCheckCard" runat="server" />
                                &nbsp; <a href="../patient/cardonfile.aspx"><b>Payment Card on File</b></a>
                            </div>
                            <div id="divIdent" runat="server" visible="False" style="margin-bottom:2px;">
                                <asp:Image ID="imgIdent" runat="server" />
                                &nbsp; <a href="../patient/identification.aspx"><b>Identification Checked</b></a>
                            </div>
                            <div id="divIns" runat="server" visible="False" style="margin-bottom:2px;">
                                <asp:Image ID="imgIns" runat="server" />
                                &nbsp; <a href="../patient/insurances.aspx"><b>Insurance Information</b></a>
                            </div>
                            <div id="divEligibilty" runat="server" visible="False" style="margin-bottom:2px;">
                                <asp:Image ID="imgEligibilty" runat="server" />
                                &nbsp; <a href="../patient/eligibility.aspx"><b>Eligibility Inquiry</b>  </a>
                            </div>
                            <div id="divTransaction" runat="server" visible="False" style="margin-bottom:2px;">
                                <asp:Image ID="imgTransaction" runat="server" />
                                &nbsp; <a href="../patient/transactions.aspx?Status=0"><b>Transaction Failures</b></a>
                            </div>
                            <div id="divEmailBounce" runat="server" visible="False" style="margin-bottom:2px;">
                                <asp:Image ID="imgEmailBounce" runat="server" />
                                &nbsp; <a href="../patient/preferences.aspx"><b>Email Failures</b></a>
                            </div>
                            <div id="divPin" runat="server" visible="False" style="margin-bottom:2px;">
                                <asp:Image ID="imgPin" runat="server" />
                                &nbsp; <a href="../patient/manage.aspx"><b>No Web Login PIN</b> </a>
                            </div>
                            <div id="divWebLogin" runat="server" visible="False" style="margin-bottom:2px;">
                                <asp:Image ID="imgWebLogin" runat="server" />
                                &nbsp;  <a href="../patient/preferences.aspx"><b>No Web/Mobile Login</b></a>
                            </div>

                        </td>
                        <!----------------------------------------------------------------- COL 3 ---------------------------------------------------------------------->
                        <td width="40%" valign="top" class="ExtraPad align-popup-fields">
                            <h3 style="margin-left: 0px;">Patient Account Notes</h3>
                            <asp:TextBox TextMode="MultiLine" Width="300px" Height="300px" ID="txtNote" CssClass="textarea"
                                runat="server" Style="margin: 0px 0px 0px 30px;" AutoPostBack="False" ForeColor="#333333" Font-Size="11pt" Font-Bold="False" BackColor="#FFFFEA" Font-Names="Tahoma; Arial"></asp:TextBox>
                            <div style="float: right; margin: 10px 125px 0 0;">
                                <br />&nbsp;
                                <asp:ImageButton ID="btnNote" ImageUrl="../Content/Images/btn_update.gif" CssClass="btn-update"
                                    OnClick="btnSavePatientNote_Click" runat="server" />
                            </div>
                        </td>
                    </tr>
                </table>
            </div>

                <telerik:radwindowmanager id="windowManager" behaviors="Move" style="z-index: 200001"
                    showcontentduringload="False" visiblestatusbar="False" visibletitlebar="True"
                    reloadonshow="True" runat="Server" modal="True" enableembeddedbasestylesheet="True"
                    enableembeddedskins="False" skin="CareBlueInf">
                    <AlertTemplate>
                        <div class="rwDialogPopup radalert">
                            <h5>
                                <div class="rwDialogText">
                                    {1}
                                </div>
                            </h5>
                            <div style="margin-top: 20px; margin-left: 51px;">
                                <a href="javascript:;" onclick="$find('{0}').close(true);">
                                    <img src="../Content/Images/btn_ok_small.gif" alt="Ok" /></a>
                            </div>
                        </div>
                    </AlertTemplate>
                </telerik:radwindowmanager>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
