<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:codedom="http://www.codeontime.com/2008/codedom-compiler"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"  xmlns:c="urn:schemas-codeontime-com:data-aquarium" xmlns:asp="urn:asp.net" xmlns:aquarium="urn:data-aquarium" xmlns:act="urn:ajax-control-toolkit"  xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    xmlns:uc1="urn:schemas-codeontime-com:custom-user-controls" exclude-result-prefixes="uc1">
  <xsl:output method="html" indent="yes" encoding="utf-8"/>
  <xsl:param name="Namespace"/>

  <xsl:template match="/">
    <html xmlns="http://www.w3.org/1999/xhtml">
      <head id="Head1" runat="server">
        <title>SharePoint Factory</title>
      </head>
      <body class="v4master">
        <form id="form1" runat="server">
          <div>
            <act:ToolkitScriptManager ID="sm1" runat="server" ScriptMode="Release" />
            <div class="SP_Ribbon">
              <asp:LoginName ID="LoginName1" runat="server" CssClass="Login" />
            </div>
            <div class="SP_Header">
              <ul>
                <li class="SP_TeamSite">Team Site</li>
                <li class="SP_Divider">
                  <xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text>
                </li>
                <li id="PageTitle" runat="server" class="SP_PageTitle">Preview </li>
              </ul>
            </div>
            <div class="SP_MenuBar">
              <ul>
                <li class="Item">Home</li>
              </ul>
            </div>
            <table class="SP_Page">
              <tr>
                <td valign="top" class="SP_SideBar">
                  <div class="SP_SidePanel">
                    <asp:LinkButton ID="SettingsButton" runat="server" Text="Click here to change the logical application page."
                        OnClick="SettingsButton_Click" />
                  </div>
                </td>
                <td valign="top" class="SP_Body">
                  <asp:ContentPlaceHolder ID="ContentPlaceHolder1" runat="server" />
                </td>
                <td id="SettingsPanel" runat="server" valign="top" class="SP_Settings" visible="false">
                  <ul class="Buttons">
                    <li>
                      <asp:Button ID="UpdateButton" runat="server" Text="OK" OnClick="UpdateButton_Click" />
                    </li>
                    <li>
                      <asp:Button ID="CancelButton" runat="server" Text="Cancel" OnClick="CancelButton_Click" />
                    </li>
                  </ul>
                </td>
              </tr>
            </table>
          </div>
        </form>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
