<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:codedom="http://www.codeontime.com/2008/codedom-compiler"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"  xmlns:c="urn:schemas-codeontime-com:data-aquarium" xmlns:asp="urn:asp.net" xmlns:aquarium="urn:data-aquarium">
  <xsl:output method="html" indent="yes" encoding="utf-8"/>
  <xsl:param name="Namespace"/>

  <xsl:template match="/">
    <asp:Content ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
      <div id="PagePlaceholder" runat="server">
      </div>
    </asp:Content>

  </xsl:template>

</xsl:stylesheet>
