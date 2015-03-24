<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns="http://schemas.microsoft.com/VisualStudio/2008/SharePointTools/FeatureModel"
    xmlns:a="urn:schemas-codeontime-com:data-aquarium-project" xmlns:ontime="urn:code-on-time:feature-model"
    exclude-result-prefixes="msxsl a ontime"
>
  <xsl:output method="xml" indent="yes"/>

  <msxsl:script language="CSharp" implements-prefix="ontime">
    <![CDATA[
        public string Guid()
        {
					return System.Guid.NewGuid().ToString().ToLower();
        }
    ]]>
  </msxsl:script>

  <xsl:variable name="FeatureId" select="ontime:Guid()"/>
  <xsl:variable name="AppWebPartId" select="ontime:Guid()"/>
  <xsl:variable name="Namespace" select="/a:project/a:namespace"/>

  <xsl:template match="/">
    <feature 
        title="{$Namespace}"
        dslVersion="1.0.0.0"
        Id="{$FeatureId}"
        featureId="{$FeatureId}"
        deploymentPath="$SharePoint.Project.FileNameWithoutExtension$_$SharePoint.Feature.FileNameWithoutExtension$"
        description="{$Namespace} Web App"
        scope="Site"
        receiverAssembly="$SharePoint.Project.AssemblyFullName$" 
        receiverClass="{$Namespace}.WebParts.AppFeatureReceiver"
      >
      <projectItems>
        <projectItemReference itemId="{$AppWebPartId}" />
      </projectItems>
    </feature>
  </xsl:template>
</xsl:stylesheet>
