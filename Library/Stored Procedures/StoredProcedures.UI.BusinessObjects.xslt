<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
    xmlns:c="urn:schemas-codeontime-com:business-objects" extension-element-prefixes="c"
>
  <xsl:output method="html" indent="yes"/>

  <xsl:template match="/">
    <div>
      <xsl:for-each select="/c:businessObjectCollection/c:businessObject">
        <div>
          <xsl:value-of select="@name"/>
        </div>
      </xsl:for-each>
    </div>
  </xsl:template>
</xsl:stylesheet>
