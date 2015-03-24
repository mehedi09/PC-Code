<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
    xmlns:ontime="urn:code-on-time:package-model" xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    xmlns="http://schemas.microsoft.com/VisualStudio/2010/SharePointTools/SharePointProjectItemModel"
    exclude-result-prefixes="msxsl a ontime"
>
  <xsl:output method="xml" indent="yes"/>

  <xsl:variable name="Namespace" select="/a:project/a:namespace"/>

    <xsl:template match="/">
      <ProjectItem Type="Microsoft.VisualStudio.SharePoint.VisualWebPart" DefaultFile="DefaultUserControl.ascx" SupportedTrustLevels="FullTrust" SupportedDeploymentScopes="Site">
        <Files>
          <ProjectItemFile Source="Elements.xml" Target="AppWebPart\" Type="ElementManifest" />
          <ProjectItemFile Source="AppWebPart.webpart" Target="AppWebPart\" Type="ElementFile" />
          <ProjectItemFile Source="DefaultUserControl.ascx" Target="CONTROLTEMPLATES\{$Namespace}\AppWebPart\" Type="TemplateFile" />
        </Files>
        <SafeControls>
          <SafeControl Name="SafeControlEntry1" Assembly="$SharePoint.Project.AssemblyFullName$" Namespace="{$Namespace}.WebParts" TypeName="*" IsSafe="true" IsSafeAgainstScript="false" />
        </SafeControls>
      </ProjectItem>
    </xsl:template>
</xsl:stylesheet>
