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
    <compileUnit namespace="{$Namespace}.Modules">
      <imports>
        <namespaceImport name="System"/>
        <namespaceImport name="System.Collections.Generic"/>
        <namespaceImport name="System.Linq"/>
        <namespaceImport name="System.Text.RegularExpressions"/>
        <namespaceImport name="System.Web"/>
        <namespaceImport name="System.Web.UI"/>
        <namespaceImport name="System.Web.UI.WebControls"/>
        <namespaceImport name="System.Text.RegularExpressions"/>
        <namespaceImport name="DotNetNuke"/>
        <namespaceImport name="DotNetNuke.Entities.Modules"/>
        <namespaceImport name="DotNetNuke.Services.Exceptions"/>
      </imports>
      <types>
        <!-- class Settings -->
        <typeDeclaration name="AppModuleSettings" isPartial="true">
          <customAttributes>
          </customAttributes>
          <baseTypes>
            <typeReference type="DotNetNuke.Entities.Modules.ModuleSettingsBase"/>
          </baseTypes>
          <members>
            <!-- field settings-->
            <memberField type="{$Namespace}.WebApp.Settings" name="settings"/>
            <!-- method OnInit(EventArgs) -->
            <memberMethod name="OnInit">
              <attributes family="true" override="true"/>
              <parameters>
                <parameter type="EventArgs" name="e"/>
              </parameters>
              <statements>
                <methodInvokeExpression methodName="OnInit">
                  <target>
                    <baseReferenceExpression/>
                  </target>
                  <parameters>
                    <argumentReferenceExpression name="e"/>
                  </parameters>
                </methodInvokeExpression>
                <tryStatement>
                  <statements>
                    <assignStatement>
                      <fieldReferenceExpression name="settings"/>
                      <castExpression targetType="{$Namespace}.WebApp.Settings">
                        <methodInvokeExpression methodName="LoadControl">
                          <target>
                            <propertyReferenceExpression name="Page"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="~/DesktopModules/{$Namespace}/Settings.ascx"/>
                          </parameters>
                        </methodInvokeExpression>
                      </castExpression>
                    </assignStatement>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <propertyReferenceExpression name="Controls"/>
                      </target>
                      <parameters>
                        <fieldReferenceExpression name="settings"/>
                      </parameters>
                    </methodInvokeExpression>
                  </statements>
                  <catch exceptionType="Exception" localName="ex">
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <propertyReferenceExpression name="Controls"/>
                      </target>
                      <parameters>
                        <objectCreateExpression type="LiteralControl">
                          <parameters>
                            <propertyReferenceExpression name="Message">
                              <variableReferenceExpression name="ex"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </objectCreateExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </catch>
                </tryStatement>
              </statements>
            </memberMethod>
            <!-- method LoadSettings() -->
            <memberMethod name="LoadSettings">
              <attributes public="true" override="true"/>
              <statements>
                <tryStatement>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanAnd">
                          <unaryOperatorExpression operator="Not">
                            <propertyReferenceExpression name="IsPostBack"/>
                          </unaryOperatorExpression>
                          <binaryOperatorExpression operator="IdentityInequality">
                            <fieldReferenceExpression name="settings"/>
                            <primitiveExpression value="null"/>
                          </binaryOperatorExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="System.String" name="pageName">
                          <init>
                            <castExpression targetType="System.String">
                              <arrayIndexerExpression>
                                <target>
                                  <propertyReferenceExpression name="TabModuleSettings"/>
                                </target>
                                <indices>
                                  <primitiveExpression value="pageName"/>
                                </indices>
                              </arrayIndexerExpression>
                            </castExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <unaryOperatorExpression operator="IsNotNullOrEmpty">
                              <variableReferenceExpression name="pageName"/>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="PageName">
                                <fieldReferenceExpression name="settings"/>
                              </propertyReferenceExpression>
                              <variableReferenceExpression name="pageName"/>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                  <catch exceptionType="Exception" localName="ex">
                    <methodInvokeExpression methodName="ProcessModuleLoadException">
                      <target>
                        <propertyReferenceExpression name="Exceptions"/>
                      </target>
                      <parameters>
                        <thisReferenceExpression/>
                        <variableReferenceExpression name="ex"/>
                      </parameters>
                    </methodInvokeExpression>
                  </catch>
                </tryStatement>
              </statements>
            </memberMethod>
            <!-- method UpdateSettings() -->
            <memberMethod name="UpdateSettings">
              <attributes public="true" override="true"/>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <fieldReferenceExpression name="settings"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <tryStatement>
                      <statements>
                        <variableDeclarationStatement type="ModuleController" name="mc">
                          <init>
                            <objectCreateExpression type="ModuleController"/>
                          </init>
                        </variableDeclarationStatement>
                        <methodInvokeExpression methodName="UpdateTabModuleSetting">
                          <target>
                            <variableReferenceExpression name="mc"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="TabModuleId"/>
                            <primitiveExpression value="pageName"/>
                            <propertyReferenceExpression name="PageName">
                              <fieldReferenceExpression name="settings"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </statements>
                      <catch exceptionType="Exception" localName="ex">
                        <methodInvokeExpression methodName="ProcessModuleLoadException">
                          <target>
                            <typeReferenceExpression type="Exceptions"/>
                          </target>
                          <parameters>
                            <thisReferenceExpression/>
                            <variableReferenceExpression name="ex"/>
                          </parameters>
                        </methodInvokeExpression>
                      </catch>
                    </tryStatement>
                  </trueStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
      </types>
    </compileUnit>
  </xsl:template>
</xsl:stylesheet>
