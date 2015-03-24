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
        <namespaceImport name="DotNetNuke.Common.Utilities"/>
        <namespaceImport name="DotNetNuke.Security"/>
        <namespaceImport name="DotNetNuke.Services.Exceptions"/>
        <namespaceImport name="DotNetNuke.Services.Localization"/>
        <namespaceImport name="DotNetNuke.Entities.Modules"/>
        <namespaceImport name="DotNetNuke.Entities.Modules.Actions"/>
      </imports>
      <types>
        <!-- class Settings -->
        <typeDeclaration name="AppModuleView" isPartial="true">
          <customAttributes>
          </customAttributes>
          <baseTypes>
            <typeReference type="DotNetNuke.Entities.Modules.PortalModuleBase"/>
          </baseTypes>
          <members>
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
                <methodInvokeExpression methodName="Clear">
                  <target>
                    <propertyReferenceExpression name="Controls"/>
                  </target>
                </methodInvokeExpression>
                <tryStatement>
                  <statements>
                    <variableDeclarationStatement type="System.String" name="pageName">
                      <init>
                        <arrayIndexerExpression>
                          <target>
                            <propertyReferenceExpression name="Params">
                              <propertyReferenceExpression name="Request"/>
                            </propertyReferenceExpression>
                          </target>
                          <indices>
                            <primitiveExpression value="_vpage"/>
                          </indices>
                        </arrayIndexerExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="IsNullOrEmpty">
                          <variableReferenceExpression name="pageName"/>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="pageName"/>
                          <castExpression targetType="System.String">
                            <arrayIndexerExpression>
                              <target>
                                <propertyReferenceExpression name="Settings"/>
                              </target>
                              <indices>
                                <primitiveExpression value="pageName"/>
                              </indices>
                            </arrayIndexerExpression>
                          </castExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                    <variableDeclarationStatement type="System.Boolean" name="success">
                      <init>
                        <primitiveExpression value="false"/>
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
                          <variableReferenceExpression name="success"/>
                          <binaryOperatorExpression operator="IdentityInequality">
                            <methodInvokeExpression methodName="LoadPageControl">
                              <target>
                                <typeReferenceExpression type="{$Namespace}.Web.ControlBase"/>
                              </target>
                              <parameters>
                                <thisReferenceExpression/>
                                <variableReferenceExpression name="pageName"/>
                                <primitiveExpression value="false"/>
                              </parameters>
                            </methodInvokeExpression>
                            <primitiveExpression value="null"/>
                          </binaryOperatorExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression  operator="Not">
                          <variableReferenceExpression name="success"/>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <propertyReferenceExpression name="Controls"/>
                          </target>
                          <parameters>
                            <objectCreateExpression type="LiteralControl">
                              <parameters>
                                <primitiveExpression>
                                  <xsl:attribute name="value"><![CDATA[Logical application page is not selected. Please click <i>Manage | Settings</i> to select a logic application page.]]></xsl:attribute>
                                </primitiveExpression>
                              </parameters>
                            </objectCreateExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
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
          </members>
        </typeDeclaration>
      </types>
    </compileUnit>
  </xsl:template>
</xsl:stylesheet>
