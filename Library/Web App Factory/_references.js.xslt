<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:config="http://www.codeontime.com/2008/codedom-configuration"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"  exclude-result-prefixes="msxsl"
>
  <xsl:param name="Namespace"/>
  <xsl:output method="text"/>

  <xsl:variable name="Scripts">
    <xsl:choose>
      <xsl:when test="$Namespace!=''">
        <xsl:text>..\..\</xsl:text>
        <xsl:value-of select="$Namespace"/>
        <xsl:text>\Scripts\</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="touch">
    <xsl:choose>
      <xsl:when test="$Namespace!=''">
        <xsl:text>..\..\WebApp\touch\</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>..\touch\</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:template match="/" xml:space="preserve"><![CDATA[
/// <reference path="]]><xsl:value-of select="$Scripts"/><![CDATA[jquery-1.10.2.js"/>
/// <reference name="]]><xsl:value-of select="$Scripts"/><![CDATA[MicrosoftAjax.js" />
/// <reference path="]]><xsl:value-of select="$Scripts"/><![CDATA[Web.DataViewResources.js"/>
/// <reference path="]]><xsl:value-of select="$Scripts"/><![CDATA[Web.DataView.js"/>
/// <reference path="]]><xsl:value-of select="$Scripts"/><![CDATA[Web.Menu.js"/>
/// <reference path="]]><xsl:value-of select="$Scripts"/><![CDATA[Web.Mobile.js"/>
/// <reference path="]]><xsl:value-of select="$touch"/><![CDATA[jquery.mobile-1.4.5.js"/>
]]></xsl:template>
</xsl:stylesheet>
