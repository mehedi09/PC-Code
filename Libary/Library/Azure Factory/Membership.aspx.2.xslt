<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:codedom="http://www.codeontime.com/2008/codedom-compiler"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		xmlns:c="urn:schemas-codeontime-com:data-aquarium"
	  xmlns:asp="urn:asp.net"
		xmlns:aquarium="urn:data-aquarium"
		xmlns:act="urn:AjaxControlToolkit"
	  >
  <xsl:output method="html" indent="yes"/>
  <xsl:param name="Namespace"/>

  <xsl:template match="/">

    <html xmlns="http://www.w3.org/1999/xhtml">
      <head runat="server">
        <title>Membership Manager</title>
      </head>
      <body style="margin:0px;">
        <form id="form1" runat="server">
          <div style="padding:8px;">
            <act:ToolkitScriptManager ID="sm1" runat="server" ScriptMode="Release" />
            <aquarium:MembershipBar id="mb" runat="server"/>
            <div style="padding: 12px 0px 12px 0px">
              <div style="margin-bottom: 12px;">
                Two standard user accounts are <b title="User Name: user">user</b> / <b title="Password: user123%">
                  user123%
                </b> and <b title="User Name: admin">admin</b> / <b title="Password: admin123%">
                  admin123%
                </b>.
              </div>
              <a href="Default.aspx">Controllers</a> | <span style="font-weight: bold;">Membership</span>
            </div>
            <aquarium:MembershipManager id="mm" runat="server"/>
          </div>
        </form>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
