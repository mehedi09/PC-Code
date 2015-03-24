<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns="http://schemas.microsoft.com/developer/msbuild/2003"
    xmlns:a="urn:schemas-codeontime-com:data-aquarium-project" 
     exclude-result-prefixes="msxsl a"
>
    <xsl:output method="xml" indent="yes"/>

    <xsl:template match="/">
      <Project ToolsVersion="4.0" xmlns="http://schemas.microsoft.com/developer/msbuild/2003">
        <PropertyGroup>
          <SharePointSiteUrl>
            <xsl:value-of select="/a:project/a:host/@url"/>
          </SharePointSiteUrl>
          <ProjectView>ProjectFiles</ProjectView>
        </PropertyGroup>
        <ProjectExtensions>
          <VisualStudio>
            <FlavorProperties GUID="{{BB1F664B-9266-4fd6-B973-E1E44974B511}}">
              <ProjectStore>
                <SharePointStartupItem>AppWebPart</SharePointStartupItem>
              </ProjectStore>
            </FlavorProperties>
          </VisualStudio>
        </ProjectExtensions>
      </Project>
    </xsl:template>
</xsl:stylesheet>
