<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:ontime="urn:schemas-codeontime-com:xslt"
	  exclude-result-prefixes="msxsl ontime"
>
  <xsl:output method="xml" indent="yes" omit-xml-declaration="yes"/>
  <xsl:param name="Namespace" select="'MyCompany.DnnNorthwindCS'"/>
  <xsl:param name="ProjectName" select="'DnnNorthwindCS'"/>
  <xsl:param name="HostPath" />
  <xsl:param name="PackageProperties"/>

  <msxsl:script language="CSharp" implements-prefix="ontime">
    <![CDATA[
    public string Replace(string s, string pattern, string s2) {
      return Regex.Replace(s, pattern, s2);
    }
    
    public string PrettyText(string text)
    {
        text = text.Replace(".", " - ");
        bool isCamel = System.Text.RegularExpressions.Regex.IsMatch(text, @"[a-z]") && System.Text.RegularExpressions.Regex.IsMatch(text, @"[A-Z]", RegexOptions.Compiled);
        System.Text.RegularExpressions.Match m = System.Text.RegularExpressions.Regex.Match(text, @"_*((([\p{Lu}\d]+)(?![\p{Ll}]))|[\p{Ll}\d]+|([\p{Lu}][\p{Ll}\d]+))", RegexOptions.Compiled);
        System.Collections.Generic.List<string> words = new System.Collections.Generic.List<string>();
        string result = String.Empty;
        while (m.Success)
        {
            string word = m.Groups[1].Value;
            if (!isCamel && System.Text.RegularExpressions.Regex.IsMatch(word, @"^([\p{Lu}\d]+|[\p{Ll}\d]+)$$", RegexOptions.Compiled)) word = Char.ToUpper(word[0]) + word.Substring(1).ToLower();
            //if (word != lastMatch) label += (label != null ? " " : "") + word;
            //lastMatch = word;
            if (result.Length > 0)
              result += " ";
            result += word;
            m = m.NextMatch();
        }
        return result;
    }
    
    public string GetVariable(string variables, string name, string defaultValue) {
      variables = "\r\n" + variables + "\r\n";
      Match m = Regex.Match(variables, String.Format(@"\n\s*({0})\s*=(.*?)\n", Regex.Escape(name)));
      if (m.Success)
      {
        string v = m.Groups[2].Value.Trim();
        if (!String.IsNullOrEmpty(v))
          return v;
        }
      return defaultValue;       
    }
    
		]]>
  </msxsl:script>


  <xsl:template match="fileSystem">
    <xsl:variable name="FriendlyName">
      <xsl:value-of select="ontime:PrettyText(substring-before($Namespace,'.'))"/>
      <xsl:text>, </xsl:text>
      <xsl:value-of select="ontime:PrettyText(substring-after($Namespace,'.'))"/>
    </xsl:variable>
    <dotnetnuke type="Package" version="5.0">
      <packages>
        <package name="{ontime:Replace($Namespace, '\.', '_')}" type="Module" version="{ontime:GetVariable($PackageProperties, 'Version', '01.00.00')}">
          <friendlyName>
            <xsl:value-of select="ontime:GetVariable($PackageProperties, 'Friendly Name', $FriendlyName)"/>
          </friendlyName>
          <description>
            <xsl:value-of select="ontime:GetVariable($PackageProperties, 'Description', concat($FriendlyName, ' application module'))"/>
          </description>
          <owner>
            <name>
              <xsl:value-of select="ontime:GetVariable($PackageProperties, 'Owner Name', '')"/>
            </name>
            <organization>
              <xsl:value-of select="ontime:GetVariable($PackageProperties, 'Owner Organization', '')"/>
            </organization>
            <url>
              <xsl:value-of select="ontime:GetVariable($PackageProperties, 'Owner Url', '')"/>
            </url>
            <xsl:variable name="OwnerEmail" select="ontime:GetVariable($PackageProperties, 'Owner Email', '')"/>
            <email>
              <xsl:text><![CDATA[<a href="]]></xsl:text>
              <xsl:value-of select="$OwnerEmail"/>
              <xsl:text><![CDATA[" target="_blank">]]></xsl:text>
              <xsl:value-of select="$OwnerEmail"/>
              <xsl:text><![CDATA[</a>]]></xsl:text>
            </email>
          </owner>
          <license src="license.txt"/>
          <releaseNotes src="releaseNotes.txt"/>
          <components>
            <component type="Module">
              <desktopModule>
                <moduleName>
                  <xsl:value-of select="ontime:Replace($Namespace, '\.', '_')"/>
                </moduleName>
                <foldername>
                  <xsl:value-of select="$Namespace"/>
                </foldername>
                <businessControllerClass></businessControllerClass>
                <moduleDefinitions>
                  <moduleDefinition>
                    <friendlyName>
                      <xsl:value-of select="ontime:GetVariable($PackageProperties, 'Friendly Name', $FriendlyName)"/>
                    </friendlyName>
                    <defaultCacheTime>0</defaultCacheTime>
                    <moduleControls>
                      <moduleControl>
                        <controlKey></controlKey>
                        <controlSrc>
                          <xsl:text>DesktopModules/</xsl:text>
                          <xsl:value-of select="$Namespace"/>
                          <xsl:text>/AppModuleView.ascx</xsl:text>
                        </controlSrc>
                        <supportsPartialRendering>False</supportsPartialRendering>
                        <controlTitle></controlTitle>
                        <controlType>View</controlType>
                        <iconFile></iconFile>
                        <helpUrl></helpUrl>
                        <viewOrder>0</viewOrder>
                      </moduleControl>
                      <moduleControl>
                        <controlKey>Settings</controlKey>
                        <controlSrc>
                          <xsl:text>DesktopModules/</xsl:text>
                          <xsl:value-of select="$Namespace"/>
                          <xsl:text>/AppModuleSettings.ascx</xsl:text>
                        </controlSrc>
                        <supportsPartialRendering>True</supportsPartialRendering>
                        <controlTitle>
                          <xsl:text>Edit </xsl:text>
                          <xsl:value-of select="$Namespace"/>
                        </controlTitle>
                        <controlType>Edit</controlType>
                        <helpUrl></helpUrl>
                        <viewOrder>0</viewOrder>
                      </moduleControl>
                    </moduleControls>
                  </moduleDefinition>
                </moduleDefinitions>
              </desktopModule>
            </component>
            <component type="Assembly">
              <assemblies>
                <basePath>bin</basePath>
                <xsl:for-each select="//file[@extension='.dll']">
                  <assembly>
                    <path>
                      <xsl:value-of select="ancestor::folder[1]/@path"/>
                      <!--<xsl:text>bin</xsl:text>
                      <xsl:choose>
                        <xsl:when test="@name!=@path and ancestor::folder[1]/@name!='bin'">
                          <xsl:text>/</xsl:text>
                          <xsl:value-of select="ancestor::folder[1]/@name"/>
                        </xsl:when>
                        <xsl:otherwise></xsl:otherwise>
                      </xsl:choose>-->
                    </path>
                    <name>
                      <xsl:value-of select="@name"/>
                    </name>
                  </assembly>
                </xsl:for-each>
              </assemblies>
            </component>
            <component type="File">
              <files>
                <basePath>
                  <xsl:text>DesktopModules\</xsl:text>
                  <xsl:value-of select="$Namespace"/>
                </basePath>
                <xsl:for-each select="//file[@extension!='.dll']">
                  <file>
                    <name>
                      <xsl:value-of select="@name"/>
                    </name>
                    <xsl:if test="@name!=@path">
                      <path>
                        <xsl:value-of select="ancestor::folder/@path"/>
                      </path>
                    </xsl:if>
                  </file>
                </xsl:for-each>
              </files>
            </component>
          </components>
        </package>
      </packages>
    </dotnetnuke>
  </xsl:template>
</xsl:stylesheet>
