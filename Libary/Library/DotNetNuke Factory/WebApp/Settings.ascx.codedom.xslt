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
    <compileUnit namespace="{$Namespace}.WebApp">
      <imports>
        <namespaceImport name="System"/>
        <namespaceImport name="System.Collections.Generic"/>
        <namespaceImport name="System.Linq"/>
        <namespaceImport name="System.Text.RegularExpressions"/>
        <namespaceImport name="System.Web"/>
        <namespaceImport name="System.Web.UI"/>
        <namespaceImport name="System.Web.UI.WebControls"/>
        <namespaceImport name="System.Text.RegularExpressions"/>
      </imports>
      <types>
        <!-- class Settings -->
        <typeDeclaration name="Settings" isPartial="true">
          <customAttributes>
          </customAttributes>
          <baseTypes>
            <!--<typeReference type="{$Namespace}.Web.ControlBase"/>-->
            <typeReference type="System.Web.UI.UserControl"/>
          </baseTypes>
          <members>
            <!-- property PageName -->
            <memberField type="System.String" name="pageName"/>
            <memberProperty type="System.String" name="PageName">
              <attributes public="true" final="true"/>
              <getStatements>
                <variableDeclarationStatement type="Match" name="m">
                  <init>
                    <methodInvokeExpression methodName="Match">
                      <target>
                        <typeReferenceExpression type="Regex"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="SelectedValue">
                          <propertyReferenceExpression name="PageList"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="Name=(\w+);"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <propertyReferenceExpression name="Success">
                      <variableReferenceExpression name="m"/>
                    </propertyReferenceExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <propertyReferenceExpression name="Value">
                        <arrayIndexerExpression>
                          <target>
                            <propertyReferenceExpression name="Groups">
                              <variableReferenceExpression name="m"/>
                            </propertyReferenceExpression>
                          </target>
                          <indices>
                            <primitiveExpression value="1"/>
                          </indices>
                        </arrayIndexerExpression>
                      </propertyReferenceExpression>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <propertyReferenceExpression name="Empty">
                    <typeReferenceExpression type="String"/>
                  </propertyReferenceExpression>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <methodInvokeExpression methodName="UpdateSelectedPageProperties">
                  <parameters>
                    <propertyReferenceExpression name="Empty">
                      <typeReferenceExpression type="String"/>
                    </propertyReferenceExpression>
                  </parameters>
                </methodInvokeExpression>
                <foreachStatement>
                  <variable type="ListItem" name="item"/>
                  <target>
                    <propertyReferenceExpression name="Items">
                      <propertyReferenceExpression name="PageList"/>
                    </propertyReferenceExpression>
                  </target>
                  <statements>
                    <assignStatement>
                      <propertyReferenceExpression name="Selected">
                        <variableReferenceExpression name="item"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="false"/>
                    </assignStatement>
                  </statements>
                </foreachStatement>
                <foreachStatement>
                  <variable type="ListItem" name="item"/>
                  <target>
                    <propertyReferenceExpression name="Items">
                      <propertyReferenceExpression name="PageList"/>
                    </propertyReferenceExpression>
                  </target>
                  <statements>
                    <variableDeclarationStatement type="Match" name="m">
                      <init>
                        <methodInvokeExpression methodName="Match">
                          <target>
                            <typeReferenceExpression type="Regex"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="Value">
                              <variableReferenceExpression name="item"/>
                            </propertyReferenceExpression>
                            <primitiveExpression value="Name=(\w+);"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanAnd">
                          <propertyReferenceExpression name="Success">
                            <variableReferenceExpression name="m"/>
                          </propertyReferenceExpression>
                          <binaryOperatorExpression operator="ValueEquality">
                            <propertyReferenceExpression name="Value">
                              <arrayIndexerExpression>
                                <target>
                                  <propertyReferenceExpression name="Groups">
                                    <variableReferenceExpression name="m"/>
                                  </propertyReferenceExpression>
                                </target>
                                <indices>
                                  <primitiveExpression value="1"/>
                                </indices>
                              </arrayIndexerExpression>
                            </propertyReferenceExpression>
                            <propertySetValueReferenceExpression/>
                          </binaryOperatorExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <fieldReferenceExpression name="pageName"/>
                          <propertySetValueReferenceExpression/>
                        </assignStatement>
                        <assignStatement>
                          <propertyReferenceExpression name="Selected">
                            <variableReferenceExpression name="item"/>
                          </propertyReferenceExpression>
                          <primitiveExpression value="true"/>
                        </assignStatement>
                        <methodInvokeExpression methodName="UpdateSelectedPageProperties">
                          <parameters>
                            <propertyReferenceExpression name="Value">
                              <variableReferenceExpression name="item"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                        <breakStatement/>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
              </setStatements>
            </memberProperty>
            <!-- method Page_Load(object, EventArgs) -->
            <memberMethod name="Page_Load">
              <attributes family="true" final="true"/>
              <parameters>
                <parameter type="System.Object" name="sender"/>
                <parameter type="EventArgs" name="e"/>
              </parameters>
              <statements>
              </statements>
            </memberMethod>
            <!-- method PageList_SelectedIdnexChanged(object, EventArgs) -->
            <memberMethod name="PageList_SelectedIndexChanged">
              <attributes family="true" final="true"/>
              <parameters>
                <parameter type="System.Object" name="sender"/>
                <parameter type="EventArgs" name="e"/>
              </parameters>
              <statements>
                <methodInvokeExpression methodName="UpdateSelectedPageProperties">
                  <parameters>
                    <propertyReferenceExpression name="SelectedValue">
                      <propertyReferenceExpression name="PageList"/>
                    </propertyReferenceExpression>
                  </parameters>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- method UpdateSelectedPageProperties(string) -->
            <memberMethod name="UpdateSelectedPageProperties">
              <attributes private="true"/>
              <parameters>
                <parameter type="System.String" name="pageInfo"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="Match" name="m">
                  <init>
                    <methodInvokeExpression methodName="Match">
                      <target>
                        <typeReferenceExpression type="Regex"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="pageInfo"/>
                        <primitiveExpression value="About=([\s\S]*?);"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <propertyReferenceExpression name="Success">
                      <variableReferenceExpression name="m"/>
                    </propertyReferenceExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <propertyReferenceExpression name="Text">
                        <propertyReferenceExpression name="PageAbout"/>
                      </propertyReferenceExpression>
                      <propertyReferenceExpression name="Value">
                        <arrayIndexerExpression>
                          <target>
                            <propertyReferenceExpression name="Groups">
                              <variableReferenceExpression name="m"/>
                            </propertyReferenceExpression>
                          </target>
                          <indices>
                            <primitiveExpression value="1"/>
                          </indices>
                        </arrayIndexerExpression>
                      </propertyReferenceExpression>
                    </assignStatement>
                  </trueStatements>
                  <falseStatements>
                    <assignStatement>
                      <propertyReferenceExpression name="Text">
                        <propertyReferenceExpression name="PageAbout"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="Please select a logical page of '{$Namespace}' application."/>
                    </assignStatement>
                  </falseStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
      </types>
    </compileUnit>
  </xsl:template>
</xsl:stylesheet>
