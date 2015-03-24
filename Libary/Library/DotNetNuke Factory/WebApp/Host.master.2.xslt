<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:codedom="http://www.codeontime.com/2008/codedom-compiler"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"  xmlns:c="urn:schemas-codeontime-com:data-aquarium" xmlns:asp="urn:asp.net" xmlns:aquarium="urn:data-aquarium" xmlns:act="urn:ajax-control-toolkit"  xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    xmlns:uc1="urn:schemas-codeontime-com:custom-user-controls" exclude-result-prefixes="uc1">
  <xsl:output method="html" indent="yes" encoding="utf-8"/>
  <xsl:param name="Namespace"/>
  <xsl:param name="ScriptOnly" select="'false'"/>

  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head id="Head1" runat="server">
        <title>DotNetNuke Factory</title>
      </head>
      <body>
        <form id="form1" runat="server">
          <div id="DNN6">
            <xsl:variable name="ScriptManagerElement">
              <xsl:choose>
                <xsl:when test="$ScriptOnly='true'">
                  <xsl:text>asp:ScriptManager</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>act:ToolkitScriptManager</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <xsl:element name="{$ScriptManagerElement}">
              <xsl:attribute name="ID">
                <xsl:text>sm</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="runat">
                <xsl:text>server</xsl:text>
              </xsl:attribute>
              <xsl:attribute name="ScriptMode">
                <xsl:text>Release</xsl:text>
              </xsl:attribute>
              <xsl:if test="/a:project/a:globalization[not(contains(@supportedCultures, 'en-US')) or contains(substring-after(@supportedCultures, ';'), ',')]">
                <xsl:attribute name="EnableScriptGlobalization">
                  <xsl:text>True</xsl:text>
                </xsl:attribute>
              </xsl:if>
            </xsl:element>
            <div id="Background">&#160;</div>
            <div id="Header">
              <span class="SmallText">Header</span>
            </div>
            <div id="Content">
              <div id="Panes">
                <div id="LogoRow">
                  <div class="Controls">
                    <div class="Buttons">
                      <asp:LinkButton ID="SettingsButton" runat="server" Text="Settings" CssClass="LinkButton Settings"
                          OnClick="SettingsButton_Click" />
                      <asp:LoginName ID="LoginName1" runat="server" />
                      |
                      <asp:LoginStatus ID="LoginStatus1" runat="server" CssClass="LinkButton" />
                    </div>
                  </div>
                </div>
                <div id="Breadcrumb">
                  <span class="SmallText">Breadcrumb</span>
                </div>
                <div id="dnn_ContentPane">
                  <span class="SmallText">Content Pane</span>
                  <div class="DnnModule">
                    <div>
                      <h1 class="Title">
                        <span id="PageTitle" runat="server" class="Head">Preview</span>
                      </h1>
                      <asp:ContentPlaceHolder ID="ContentPlaceHolder1" runat="server">
                      </asp:ContentPlaceHolder>
                      <asp:Panel ID="SettingsPanel" runat="server" Visible="false" CssClass="SettingsPanel">
                        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                          <ContentTemplate>
                            <uc1:Settings ID="Settings1" runat="server" />
                          </ContentTemplate>
                        </asp:UpdatePanel>
                        <ul class="Buttons">
                          <li class="Primary">
                            <asp:LinkButton ID="UpdateButton" runat="server" Text="Update" OnClick="UpdateButton_Click" />
                          </li>
                          <li>
                            <asp:LinkButton ID="CancelButton" runat="server" Text="Cancel" OnClick="CancelButton_Click" />
                          </li>
                        </ul>
                        <div class="Clear">
                        </div>
                      </asp:Panel>
                    </div>
                  </div>
                </div>
                <div id="dnn_LeftPane">
                  <span class="SmallText">Left Pane</span>
                </div>
                <div id="dnn_RightPane">
                  <span class="SmallText">Right Pane</span>
                </div>
                <div id="dnn_BottomPane">
                  <span class="SmallText">Bottom Pane</span>
                </div>
              </div>
            </div>
            <div id="Footer">
              <span class="SmallText">Footer</span>
            </div>
          </div>
        </form>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
