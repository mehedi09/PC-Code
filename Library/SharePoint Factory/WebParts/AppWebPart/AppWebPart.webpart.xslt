<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:ontime="urn:code-on-time:package-model" xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    exclude-result-prefixes="msxsl a ontime"
>
  <xsl:output method="xml" indent="yes"/>


  <msxsl:script language="CSharp" implements-prefix="ontime">
    <![CDATA[
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

  <xsl:variable name="Namespace" select="/a:project/a:namespace"/>
  <xsl:variable name="PackageProperties" select="/a:project/a:features/a:packageProperties"/>

  <xsl:template match="/">
    <webParts>
      <webPart xmlns="http://schemas.microsoft.com/WebPart/v3">
        <metaData>
          <type name="{$Namespace}.WebParts.AppWebPart, $SharePoint.Project.AssemblyFullName$" />
          <importErrorMessage>$Resources:core,ImportErrorMessage;</importErrorMessage>
        </metaData>
        <data>
          <properties>
            <xsl:variable name="DefaultTitle">
              <xsl:value-of select="$Namespace"/>
              <xsl:text> Web App</xsl:text>
            </xsl:variable>
            <property name="Title" type="string">
              <xsl:value-of select="ontime:GetVariable($PackageProperties, 'Title', $DefaultTitle)"/>
            </property>
            <xsl:variable name="DefaultDescription">
              <xsl:text>This web part implements "</xsl:text>
              <xsl:value-of select="$Namespace"/>
              <xsl:text>" line-of-business web application.</xsl:text>
            </xsl:variable>
            <property name="Description" type="string">
              <xsl:value-of select="ontime:GetVariable($PackageProperties, 'Description', $DefaultDescription)"/>
            </property>
          </properties>
        </data>
      </webPart>
    </webParts>
  </xsl:template>
</xsl:stylesheet>
