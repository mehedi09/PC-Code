<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:ontime="urn:schemas-codeontime-com:xslt"
 	  exclude-result-prefixes="msxsl a ontime"
>
  <xsl:output method="text" encoding="windows-1251"/>
  <xsl:param name="ScriptName" select="'_install.ps1'"/>
  <xsl:param name="ProjectName"/>
  <xsl:param name="Root"/>

  <xsl:template match="/">
    <xsl:text>net start "SharePoint 2010 Administration"
cd "</xsl:text>
    <xsl:value-of select="$Root"/>
    <xsl:text>\Publish\SharePoint Factory\</xsl:text>
    <xsl:value-of select="$ProjectName"/>
    <xsl:text>"
"%SYSTEMROOT%\system32\windowspowershell\v1.0\powershell.exe" ".\</xsl:text>
    <xsl:value-of select="$ScriptName"/>
    <xsl:text>" "</xsl:text>
    <xsl:value-of select="/a:project/a:host/@url"/>
    <xsl:text>"
</xsl:text>
  </xsl:template>
</xsl:stylesheet>
