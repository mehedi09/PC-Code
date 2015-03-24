<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.codeontime.com/2008/codedom-compiler"  xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    xmlns:app="urn:schemas-codeontime-com:data-aquarium-application"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl a app"
>
  <xsl:output method="xml" indent="yes" />

  <xsl:param name="Host" select="''"/>
  <xsl:param name="Namespace"/>

  <xsl:template match="/">
    <compileUnit namespace="{$Namespace}.WebParts">
      <imports>
        <namespaceImport name="System"/>
        <namespaceImport name="System.Collections.Generic"/>
        <namespaceImport name="System.Linq"/>
        <namespaceImport name="System.Text.RegularExpressions"/>
        <namespaceImport name="System.Web"/>
        <namespaceImport name="System.Web.UI"/>
        <namespaceImport name="System.Web.UI.WebControls"/>
        <namespaceImport name="System.Web.UI.WebControls.WebParts"/>
      </imports>
      <types>
        <!-- class Settings -->
        <typeDeclaration name="DefaultUserControl" isPartial="true">
          <customAttributes>
          </customAttributes>
          <baseTypes>
            <typeReference type="System.Web.UI.UserControl"/>
          </baseTypes>
          <members>
            <!-- field Page_Load -->
            <memberMethod name="Page_Load">
              <attributes family="true"/>
              <parameters>
                <parameter type="System.Object" name="sender"/>
                <parameter type="EventArgs" name="e"/>
              </parameters>
              <statements>

              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
      </types>
    </compileUnit>
  </xsl:template>
</xsl:stylesheet>
