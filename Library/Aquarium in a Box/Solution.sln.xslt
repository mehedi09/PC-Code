<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.codeontime.com/2008/codedom-compiler"  xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:ontime="urn:schemas-codeontime-com:xslt"
 	  exclude-result-prefixes="msxsl a ontime"
>
	<xsl:output method="text" indent="yes"/>
	<xsl:param name="Namespace"/>
	<xsl:param name="ProjectExtension"/>
	<xsl:param name="ProjectGuid"/>
	<xsl:param name="SampleWebAppGuid"/>

	<msxsl:script language="CSharp" implements-prefix="ontime">
		<![CDATA[
				public string Guid() {
					return System.Guid.NewGuid().ToString().ToUpper();
        }
		]]>
	</msxsl:script>

	<xsl:variable name="SolutionGuid" select="ontime:Guid()"/>

	<xsl:template match="/">
		<xsl:text>
Microsoft Visual Studio Solution File, Format Version 10.00
# Visual Studio 2008
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
		<xsl:text>}") = "SampleWebApp", "SampleWebApp\SampleWebApp.</xsl:text>
		<xsl:value-of select="$ProjectExtension"/>
		<xsl:text>", "</xsl:text>
		<xsl:value-of select="$SampleWebAppGuid"/>
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
		<xsl:value-of select="$SampleWebAppGuid"/>
		<xsl:text>.Debug|Any CPU.ActiveCfg = Debug|Any CPU
		</xsl:text>
		<xsl:value-of select="$SampleWebAppGuid"/>
		<xsl:text>.Debug|Any CPU.Build.0 = Debug|Any CPU
		</xsl:text>
		<xsl:value-of select="$SampleWebAppGuid"/>
		<xsl:text>.Release|Any CPU.ActiveCfg = Release|Any CPU
	EndGlobalSection
	GlobalSection(SolutionProperties) = preSolution
		HideSolutionNode = FALSE
	EndGlobalSection
EndGlobal
</xsl:text>
	</xsl:template>

</xsl:stylesheet>
