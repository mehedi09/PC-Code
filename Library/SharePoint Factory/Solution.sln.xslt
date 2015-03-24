<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.codeontime.com/2008/codedom-compiler"  xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:ontime="urn:schemas-codeontime-com:xslt"
 	  exclude-result-prefixes="msxsl a ontime a"
>
  <xsl:output method="text" indent="yes"/>
  <xsl:param name="Namespace"/>
  <xsl:param name="ProjectExtension"/>
  <xsl:param name="ProjectGuid"/>
  <xsl:param name="WebPartsGuid"/>
  <xsl:param name="WebAppGuid"/>
  <xsl:param name="TargetFramework" select="a:project/@targetFramework"/>
  <xsl:param name="VisualStudioBuildTargets"/>
  <xsl:param name="VisualStudio2012"/>
  <xsl:param name="VisualStudio2013"/>

  <xsl:variable name="SolutionGuid">
    <xsl:choose>
      <xsl:when test="a:project/@codeDomProvider='CSharp'">
        <xsl:text>FAE04EC0-301F-11D3-BF4B-00C04F79EFBC</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>F184B08F-C81C-45F6-A57F-5ABD9991F28F</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:template match="/">
    <xsl:choose>
      <xsl:when test="$VisualStudio2013!=''">
        <xsl:text>
Microsoft Visual Studio Solution File, Format Version 12.00
# Visual Studio 2013
</xsl:text>
      </xsl:when>
      <xsl:when test="$VisualStudio2012!=''">
        <xsl:text>
Microsoft Visual Studio Solution File, Format Version 12.00
# Visual Studio 2012
</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>
Microsoft Visual Studio Solution File, Format Version 11.00
# Visual Studio 2010
</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text>
Project("{</xsl:text>
    <xsl:value-of select="$SolutionGuid"/>
    <xsl:text>}") = "WebApp", "WebApp\WebApp.</xsl:text>
    <xsl:value-of select="$ProjectExtension"/>
    <xsl:text>", "</xsl:text>
    <xsl:value-of select="$WebAppGuid"/>
    <xsl:text>"
EndProject
Project("{</xsl:text>
    <xsl:value-of select="$SolutionGuid"/>
    <xsl:text>}") = "</xsl:text>
    <xsl:value-of select="$Namespace"/>
    <xsl:text>", "</xsl:text>
    <xsl:value-of select="concat($Namespace, '\', $Namespace, '.', $ProjectExtension)"/>
    <xsl:text>", "</xsl:text>
    <xsl:value-of select="$ProjectGuid"/>
    <xsl:text>"
EndProject
Project("{</xsl:text>
    <xsl:value-of select="$SolutionGuid"/>
    <xsl:text>}") = "WebParts", "WebParts\WebParts.</xsl:text>
    <xsl:value-of select="$ProjectExtension"/>
    <xsl:text>", "</xsl:text>
    <xsl:value-of select="$WebPartsGuid"/>
    <xsl:text>"
EndProject

Global
	GlobalSection(SolutionConfigurationPlatforms) = preSolution
		Debug|Any CPU = Debug|Any CPU
		Release|Any CPU = Release|Any CPU
	EndGlobalSection
	GlobalSection(ProjectConfigurationPlatforms) = postSolution
		</xsl:text>
    <xsl:value-of select="$ProjectGuid"/>
    <xsl:text>.Debug|Any CPU.ActiveCfg = Debug|Any CPU
		</xsl:text>
    <xsl:value-of select="$ProjectGuid"/>
    <xsl:text>.Debug|Any CPU.Build.0 = Debug|Any CPU
		</xsl:text>
    <xsl:value-of select="$ProjectGuid"/>
    <xsl:text>.Release|Any CPU.ActiveCfg = Release|Any CPU
		</xsl:text>
    <xsl:value-of select="$WebPartsGuid"/>
    <xsl:text>.Debug|Any CPU.ActiveCfg = Debug|Any CPU
		</xsl:text>
    <xsl:value-of select="$WebPartsGuid"/>
    <xsl:text>.Debug|Any CPU.Build.0 = Debug|Any CPU
		</xsl:text>
    <xsl:value-of select="$WebPartsGuid"/>
    <xsl:text>.Debug|Any CPU.Deploy.0 = Debug|Any CPU
		</xsl:text>
    <xsl:value-of select="$WebPartsGuid"/>
    <xsl:text>.Release|Any CPU.ActiveCfg = Release|Any CPU
    </xsl:text>
    <xsl:value-of select="$WebPartsGuid"/>
    <xsl:text>.Release|Any CPU.Build.0 = Release|Any CPU
    </xsl:text>
    <xsl:value-of select="$WebPartsGuid"/>
    <xsl:text>.Release|Any CPU.Deploy.0 = Release|Any CPU
    </xsl:text>
    <xsl:value-of select="$WebAppGuid"/>
    <xsl:text>.Debug|Any CPU.ActiveCfg = Debug|Any CPU
		</xsl:text>
    <xsl:value-of select="$WebAppGuid"/>
    <xsl:text>.Debug|Any CPU.Build.0 = Debug|Any CPU
		</xsl:text>
    <xsl:value-of select="$WebAppGuid"/>
    <xsl:text>.Release|Any CPU.ActiveCfg = Release|Any CPU
	EndGlobalSection
	GlobalSection(SolutionProperties) = preSolution
		HideSolutionNode = FALSE
	EndGlobalSection
EndGlobal
</xsl:text>
  </xsl:template>

</xsl:stylesheet>
