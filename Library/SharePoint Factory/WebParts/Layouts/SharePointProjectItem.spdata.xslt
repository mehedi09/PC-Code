<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://schemas.microsoft.com/VisualStudio/2010/SharePointTools/SharePointProjectItemModel"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl"
>
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/">
    <ProjectItem Type="Microsoft.VisualStudio.SharePoint.MappedFolder" SupportedTrustLevels="FullTrust" SupportedDeploymentScopes="Package">
      <ProjectItemFolder Target="Layouts" Type="TemplateFile" />
    </ProjectItem>
  </xsl:template>
</xsl:stylesheet>
