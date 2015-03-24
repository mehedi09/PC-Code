<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns="http://schemas.microsoft.com/sharepoint/"
    xmlns:ontime="urn:code-on-time:package-model" xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    exclude-result-prefixes="msxsl a ontime"
 >
  <xsl:output method="xml" indent="yes"/>

  <xsl:variable name="Namespace" select="/a:project/a:namespace"/>

  <xsl:template match="/">
    <Elements>
      <Module Name="AppWebPart" List="113" Url="_catalogs/wp">
        <File Path="AppWebPart\AppWebPart.webpart" Url="{$Namespace}_AppWebPart.webpart" Type="GhostableInLibrary" >
          <Property Name="Group" Value="Web Apps" />
        </File>
      </Module>
    </Elements>
  </xsl:template>
</xsl:stylesheet>
