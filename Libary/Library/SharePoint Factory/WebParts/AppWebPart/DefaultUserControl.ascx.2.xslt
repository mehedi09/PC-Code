<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:codedom="http://www.codeontime.com/2008/codedom-compiler"
    xmlns:app="urn:schemas-codeontime-com:data-aquarium-application"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"  xmlns:c="urn:schemas-codeontime-com:data-aquarium"
    xmlns:asp="urn:asp.net" xmlns:aquarium="urn:data-aquarium"
    xmlns:cot="urn:codeontime:template-script"
    xmlns:factory="urn:codeontime:app-factory" exclude-result-prefixes="app factory msxml" xmlns:msxml="urn:schemas-microsoft-com:xslt">
  <xsl:output method="html" indent="yes" encoding="utf-8"/>
  <xsl:param name="Namespace"/>

  <xsl:template match="/">
    <div style="margin-top: 8px">
      The logical application page is not specified.<br />
      <br />
      Select <i>Edit Web Part</i> option in the context menu of this web part and choose the
      logical application page.
    </div>
  </xsl:template>

</xsl:stylesheet>
