<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns="http://schemas.microsoft.com/VisualStudio/2008/SharePointTools/PackageModel"
    xmlns:ontime="urn:code-on-time:package-model" xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    exclude-result-prefixes="msxsl a ontime"
>
  <xsl:output method="xml" indent="yes"/>

  <xsl:param name="FeatureId"/>

  <msxsl:script language="CSharp" implements-prefix="ontime">
    <![CDATA[
        public string Guid()
        {
					return System.Guid.NewGuid().ToString().ToLower();
        }
    ]]>
  </msxsl:script>

  <xsl:variable name="PackageId" select="ontime:Guid()"/>
  <xsl:variable name="Namespace" select="/a:project/a:namespace"/>
  <xsl:variable name="ControlTemplatesProjectItemId" select="ontime:Guid()"/>
  <xsl:variable name="LayoutsProjectItemId" select="ontime:Guid()"/>
  <xsl:variable name="ProjectExtension">
    <xsl:choose>
      <xsl:when test="/a:project/@codeDomProvider='CSharp'">
        <xsl:text>csproj</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>vbproj</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:template match="/">
    <package xmlns:dm0="http://schemas.microsoft.com/VisualStudio/2008/DslTools/Core" dslVersion="1.0.0.0"
             Id="{$PackageId}" solutionId="{$PackageId}" resetWebServer="false" name="{$Namespace}" >
      <assemblies>
        <!--<customAssembly location="AjaxControlToolkit.dll" deploymentTarget="WebApplication" sourcePath="..\WebApp\bin\AjaxControlToolkit.dll" />
        <customAssembly location="{$Namespace}.dll" deploymentTarget="WebApplication" sourcePath="..\WebApp\bin\{$Namespace}.dll" />
        <customAssembly location="{$Namespace}.WebApp.dll" deploymentTarget="WebApplication" sourcePath="..\WebApp\bin\{$Namespace}.WebApp.dll" />-->
        <customAssembly location="AjaxControlToolkit.dll" deploymentTarget="WebApplication" sourcePath="..\AjaxControlToolkit\AjaxControlToolkit.dll"/>
        <projectOutputAssembly location="{$Namespace}.dll" deploymentTarget="WebApplication" projectPath="..\{$Namespace}\{$Namespace}.{$ProjectExtension}" />
        <!--<projectOutputAssembly location="{$Namespace}.WebApp.dll" deploymentTarget="WebApplication" projectPath="..\WebApp\WebApp.{$ProjectExtension}" />-->
      </assemblies>
      <features>
        <featureReference itemId="{$FeatureId}" />
      </features>
      <projectItems>
        <projectItemReference itemId="{$LayoutsProjectItemId}" />
        <projectItemReference itemId="{$ControlTemplatesProjectItemId}" />
      </projectItems>
    </package>
  </xsl:template>
</xsl:stylesheet>
