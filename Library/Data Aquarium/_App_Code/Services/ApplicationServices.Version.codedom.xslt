<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.codeontime.com/2008/codedom-compiler"  xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:codeontime="urn:schemas-codeontime-com:ease"  exclude-result-prefixes="msxsl a codeontime"
>
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="TargetFramework" select="a:project/@targetFramework"/>
  <xsl:param name="IsUnlimited"/>
  <xsl:param name="Mobile"/>
  <xsl:param name="ProjectId"/>

  <xsl:param name="AppVersion"/>
  <xsl:param name="jQueryMobileVersion"/>


  <xsl:variable name="Namespace" select="a:project/a:namespace"/>

  <xsl:template match="/">
    <compileUnit namespace="{$Namespace}.Services">
      <imports>
        <namespaceImport name="System"/>
      </imports>
      <types>
        <!-- class AppicationServicesBase -->
        <typeDeclaration name="ApplicationServices" isPartial="true">
          <attributes public="true"/>
          <members>
            <memberProperty type="System.String" name="Version">
              <comment><![CDATA[The first three numbers in the version reflect the version of the app generator.
The last number is the value stored in DataAquarium.Version.xml file located in the root of the project.
The number is automatically incremented when the application is published from the app generator.]]></comment>
              <attributes public="true" static="true"/>
              <getStatements>
                <methodReturnStatement>
                  <primitiveExpression value="{$AppVersion}" convertTo="String"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <memberProperty type="System.String" name="JqmVersion">
              <comment><![CDATA[The version of jQuery Mobile integrated in the app generator.]]></comment>
              <attributes public="true" static="true"/>
              <getStatements>
                <methodReturnStatement>
                  <primitiveExpression value="{$jQueryMobileVersion}" convertTo="String"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
          </members>
        </typeDeclaration>
      </types>
    </compileUnit>
  </xsl:template>
</xsl:stylesheet>
