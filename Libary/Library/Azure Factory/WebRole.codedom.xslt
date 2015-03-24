<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.codeontime.com/2008/codedom-compiler"  xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl a"
>
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="IsClassLibrary" select="'false'"/>
  <xsl:param name="Namespace" select="a:project/a:namespace"/>
  <xsl:param name="WindowsAzureSdkVersion"/>

  <xsl:template match="/">
    <compileUnit namespace="WebRole1">
      <imports>
        <namespaceImport name="System"/>
        <namespaceImport name="System.Collections.Generic"/>
        <namespaceImport name="System.Linq"/>
        <namespaceImport name="Microsoft.WindowsAzure"/>
        <xsl:if test="$WindowsAzureSdkVersion &lt;= '2.0'">
          <namespaceImport name="Microsoft.WindowsAzure.Diagnostics"/>
        </xsl:if>
        <namespaceImport name="Microsoft.WindowsAzure.ServiceRuntime"/>
      </imports>
      <types>
        <!-- class WebRole -->
        <typeDeclaration name="WebRole" isPartial="true">
          <baseTypes>
            <typeReference type="WebRoleBase"/>
          </baseTypes>
        </typeDeclaration>
        <!-- class WebRoleBase -->
        <typeDeclaration name="WebRoleBase">
          <baseTypes>
            <typeReference type="RoleEntryPoint"/>
          </baseTypes>
          <members>
            <!-- method OnStart() -->
            <memberMethod returnType="System.Boolean" name="OnStart">
              <attributes public="true" override="true"/>
              <statements>
                <!--<methodInvokeExpression methodName="Start">
                  <target>
                    <propertyReferenceExpression name="DiagnosticMonitor"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="DiagnosticsConnectionString"/>
                  </parameters>
                </methodInvokeExpression>-->
                <comment>Override OnStart method in WebRole partial class to allow diagnostic monitor.</comment>
                <comment>Call method DiagnosticMonitor.Start("DiagnosticsConnectionString") to start monitoring.</comment>
                <comment></comment>
                <comment>For information on handling configuration changes</comment>
                <comment>see the MSDN topic at http://go.microsoft.com/fwlink/?LinkId=166357.</comment>
                <attachEventStatement>
                  <event name="Changing">
                    <propertyReferenceExpression name="RoleEnvironment"/>
                  </event>
                  <listener>
                    <addressOfExpression>
                      <methodReferenceExpression methodName="RoleEnvironmentChanging"/>
                    </addressOfExpression>
                  </listener>
                </attachEventStatement>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="OnStart">
                    <target>
                      <baseReferenceExpression/>
                    </target>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method RoleEnvironmentChanging(object, RoleEnvironmentChangingEventArgs) -->
            <memberMethod name="RoleEnvironmentChanging">
              <attributes private="true" final="true"/>
              <parameters>
                <parameter type="System.Object" name="sender"/>
                <parameter type="RoleEnvironmentChangingEventArgs" name="e"/>
              </parameters>
              <statements>
                <foreachStatement>
                  <variable type="RoleEnvironmentConfigurationSettingChange" name="change"/>
                  <target>
                    <propertyReferenceExpression name="Changes">
                      <variableReferenceExpression name="e"/>
                    </propertyReferenceExpression>
                  </target>
                  <statements>
                    <comment>If a configuration setting is changing</comment>
                    <comment>Set e.Cancel to true to restart this role instance</comment>
                    <assignStatement>
                      <propertyReferenceExpression name="Cancel">
                        <argumentReferenceExpression name="e"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="true"/>
                    </assignStatement>
                  </statements>
                </foreachStatement>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
      </types>
    </compileUnit>
  </xsl:template>
</xsl:stylesheet>
