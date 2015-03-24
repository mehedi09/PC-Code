<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns="http://schemas.microsoft.com/ServiceHosting/2008/10/ServiceConfiguration"
    xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    exclude-result-prefixes="msxsl a"
>
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="WindowsAzureSdkVersion"/>

  <xsl:template match="/">
    <ServiceConfiguration serviceName="{/a:project/a:namespace}CloudApp" >
      <xsl:if test="$WindowsAzureSdkVersion != '1.7'">
        <xsl:attribute name="schemaVersion">
          <xsl:choose>
            <xsl:when test="$WindowsAzureSdkVersion >= '2.4'">
              <xsl:text>2014-06.2.4</xsl:text>
            </xsl:when>
            <xsl:when test="$WindowsAzureSdkVersion >= '2.3'">
              <xsl:text>2014-01.2.3</xsl:text>
            </xsl:when>
            <xsl:when test="$WindowsAzureSdkVersion >= '2.2'">
              <xsl:text>2013-10.2.2</xsl:text>
            </xsl:when>
            <xsl:when test="$WindowsAzureSdkVersion >= '2.0'">
              <xsl:text>2013-03.2.0</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>2012-10.1.8</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="$WindowsAzureSdkVersion != '1.8'">
        <xsl:attribute name="osFamily">
          <xsl:choose>
            <xsl:when test="$WindowsAzureSdkVersion >= '2.2'">
              <xsl:text>4</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>3</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="osVersion">
          <xsl:text>*</xsl:text>
        </xsl:attribute>
      </xsl:if>
      <Role name="WebRole1">
        <Instances count="2" />
        <ConfigurationSettings>
          <Setting name="DiagnosticsConnectionString" value="" />
        </ConfigurationSettings>
      </Role>
    </ServiceConfiguration>
  </xsl:template>
</xsl:stylesheet>
