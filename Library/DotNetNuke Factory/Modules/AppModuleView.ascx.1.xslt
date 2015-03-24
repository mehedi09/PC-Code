<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:config="http://www.codeontime.com/2008/codedom-configuration"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:app="urn:schemas-codeontime-com:data-aquarium-application"
    exclude-result-prefixes="msxsl app"
>
  <xsl:param name="Namespace"/>
  <xsl:param name="Name"/>
  <xsl:output method="text" encoding="utf-8"/>
  <xsl:variable name="Provider" select="document('../../_Config/CodeOnTime.CodeDom.xml')//config:provider[@name=parent::config:providers/@default]"/>

  <xsl:template match="/">
    <xsl:text>&lt;%@ Control Language="</xsl:text>
    <xsl:value-of select="$Provider/@language"/>
    <xsl:text>" AutoEventWireup="</xsl:text>
    <xsl:value-of select="$Provider/@autoEventWireup"/>
    <xsl:text>" CodeFile="AppModuleView.ascx</xsl:text>
    <xsl:value-of select="$Provider/@extension"/>
    <xsl:text>" Inherits="AppModuleView"  %&gt;
</xsl:text>
  </xsl:template>
</xsl:stylesheet>
