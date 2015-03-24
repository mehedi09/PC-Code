<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:config="http://www.codeontime.com/2008/codedom-configuration"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"  exclude-result-prefixes="msxsl"
>
  <xsl:param name="Namespace"/>
  <xsl:output method="text" encoding="utf-8"/>
  <xsl:variable name="Provider" select="document('../../_Config/CodeOnTime.CodeDom.xml')//config:provider[@name=parent::config:providers/@default]"/>
  <xsl:param name="ScriptOnly" select="'false'"/>

  <xsl:template match="/">
    <xsl:text>&lt;%@ Master Language="</xsl:text>
    <xsl:value-of select="$Provider/@language"/>
    <xsl:text>" AutoEventWireup="</xsl:text>
    <xsl:value-of select="$Provider/@autoEventWireup"/>
    <xsl:text>" CodeFile="Host.master</xsl:text>
    <xsl:value-of select="$Provider/@extension"/>
    <xsl:text>" Inherits="Host&quot; %&gt;</xsl:text>
    <!--<xsl:value-of select="$Namespace"/>-->
    <xsl:if test="$ScriptOnly='false'">
      <xsl:text><![CDATA[

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="act" %>]]></xsl:text>
    </xsl:if>
    <xsl:text><![CDATA[
<%@ Register Src="Settings.ascx" TagName="Settings" TagPrefix="uc1" %>
      <!DOCTYPE html>
]]>
      </xsl:text>
  </xsl:template>
</xsl:stylesheet>
