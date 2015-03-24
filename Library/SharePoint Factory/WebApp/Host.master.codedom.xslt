<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.codeontime.com/2008/codedom-compiler"  xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl a"
>
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="Namespace"/>

  <xsl:template match="/">

    <compileUnit namespace="{$Namespace}.WebApp">
      <imports>
        <namespaceImport name="System"/>
        <namespaceImport name="System.Collections.Generic"/>
        <namespaceImport name="System.Linq"/>
        <namespaceImport name="System.Reflection"/>
        <namespaceImport name="System.Text.RegularExpressions"/>
        <namespaceImport name="System.Web"/>
        <namespaceImport name="System.Web.UI"/>
        <namespaceImport name="System.Web.UI.WebControls"/>
      </imports>
      <types>
        <!-- class _Default -->
        <typeDeclaration name="Host" isPartial="true">
          <baseTypes>
            <typeReference type="System.Web.UI.MasterPage"/>
          </baseTypes>
          <members>
            <!-- property SettingsMode -->
            <memberProperty type="System.Boolean" name="SettingsMode">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property CurrentPage -->
            <memberField type="System.String" name="currentPage"/>
            <memberProperty type="System.String" name="CurrentPage">
              <attributes public="true" final="true"/>
              <getStatements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <fieldReferenceExpression name="currentPage"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <fieldReferenceExpression name="currentPage"/>
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
                    </assignStatement>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="IsNullOrEmpty">
                          <fieldReferenceExpression name="currentPage"/>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="HttpCookie" name="c">
                          <init>
                            <arrayIndexerExpression>
                              <target>
                                <propertyReferenceExpression name="Cookies">
                                  <propertyReferenceExpression name="Request"/>
                                </propertyReferenceExpression>
                              </target>
                              <indices>
                                <primitiveExpression value="SharePointFactory_CurrentPage"/>
                              </indices>
                            </arrayIndexerExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="IdentityEquality">
                              <variableReferenceExpression name="c"/>
                              <primitiveExpression value="null"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <fieldReferenceExpression name="currentPage"/>
                              <propertyReferenceExpression name="Empty">
                                <typeReferenceExpression type="String"/>
                              </propertyReferenceExpression>
                            </assignStatement>
                          </trueStatements>
                          <falseStatements>
                            <assignStatement>
                              <fieldReferenceExpression name="currentPage"/>
                              <propertyReferenceExpression name="Value">
                                <variableReferenceExpression name="c"/>
                              </propertyReferenceExpression>
                            </assignStatement>
                          </falseStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <fieldReferenceExpression name="currentPage"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="currentPage"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
                <variableDeclarationStatement type="HttpCookie" name="c">
                  <init>
                    <objectCreateExpression type="HttpCookie">
                      <parameters>
                        <primitiveExpression value="SharePointFactory_CurrentPage"/>
                        <propertySetValueReferenceExpression/>
                      </parameters>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Expires">
                    <variableReferenceExpression name="c"/>
                  </propertyReferenceExpression>
                  <methodInvokeExpression methodName="AddDays">
                    <target>
                      <propertyReferenceExpression name="Now">
                        <variableReferenceExpression name="DateTime"/>
                      </propertyReferenceExpression>
                    </target>
                    <parameters>
                      <primitiveExpression value="7"/>
                    </parameters>
                  </methodInvokeExpression>
                </assignStatement>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <propertyReferenceExpression name="Cookies">
                      <propertyReferenceExpression name="Response"/>
                    </propertyReferenceExpression>
                  </target>
                  <parameters>
                    <variableReferenceExpression name="c"/>
                  </parameters>
                </methodInvokeExpression>
              </setStatements>
            </memberProperty>
            <!-- field Selector -->
            <memberField type="Web.AppSelector" name="selector"/>
            <!-- method Page_Init(object, EventArgs) -->
            <memberMethod name="Page_Init" >
              <attributes family="true" final="true"/>
              <parameters>
                <parameter type="System.Object" name="sender"/>
                <parameter type="EventArgs" name="e"/>
              </parameters>
              <statements>
                <assignStatement>
                  <fieldReferenceExpression name="selector"/>
                  <objectCreateExpression type="Web.AppSelector"/>
                </assignStatement>
                <methodInvokeExpression methodName="AddAt">
                  <target>
                    <propertyReferenceExpression name="Controls">
                      <propertyReferenceExpression name="SettingsPanel"/>
                    </propertyReferenceExpression>
                  </target>
                  <parameters>
                    <primitiveExpression value="0"/>
                    <fieldReferenceExpression name="selector"/>
                  </parameters>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- method HideSettingsPanel() -->
            <memberMethod name="HideSettingsPanel">
              <attributes private="true"/>
              <statements>
                <assignStatement>
                  <propertyReferenceExpression name="Visible">
                    <propertyReferenceExpression name="ContentPlaceHolder1"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="true"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Visible">
                    <propertyReferenceExpression name="SettingsPanel"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="false"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Visible">
                    <propertyReferenceExpression name="SettingsButton"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="true"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="InnerText">
                    <propertyReferenceExpression name="PageTitle"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="Preview"/>
                </assignStatement>
              </statements>
            </memberMethod>
            <!-- method ShowSettingsPanel() -->
            <memberMethod name="ShowSettingsPanel">
              <attributes private="true"/>
              <statements>
                <assignStatement>
                  <propertyReferenceExpression name="Visible">
                    <propertyReferenceExpression name="ContentPlaceHolder1"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="false"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Visible">
                    <propertyReferenceExpression name="SettingsPanel"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="true"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Visible">
                    <propertyReferenceExpression name="SettingsButton"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="false"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="InnerText">
                    <propertyReferenceExpression name="PageTitle"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="Settings"/>
                </assignStatement>
              </statements>
            </memberMethod>
            <!-- method Page_Load(object, EventArgs) -->
            <memberMethod name="Page_Load">
              <attributes family="true" final="true"/>
              <parameters>
                <parameter type="System.Object" name="sender"/>
                <parameter type="EventArgs" name="e"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="Not">
                      <propertyReferenceExpression name="IsPostBack"/>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <propertyReferenceExpression name="ApplicationPage">
                        <fieldReferenceExpression name="selector"/>
                      </propertyReferenceExpression>
                      <propertyReferenceExpression name="CurrentPage"/>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <propertyReferenceExpression name="SettingsMode"/>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="ShowSettingsPanel"/>
                  </trueStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method SettingsButton_Click(object, EventArgs) -->
            <memberMethod name="SettingsButton_Click">
              <attributes family="true"/>
              <parameters>
                <parameter type="System.Object" name="sender"/>
                <parameter type="EventArgs" name="e"/>
              </parameters>
              <statements>
                <methodInvokeExpression methodName="ShowSettingsPanel"/>
              </statements>
            </memberMethod>
            <!-- method CancelButton_Click(object, EventArgs)  -->
            <memberMethod name="CancelButton_Click">
              <attributes family="true"/>
              <parameters>
                <parameter type="System.Object" name="sender"/>
                <parameter type="EventArgs" name="e"/>
              </parameters>
              <statements>
                <methodInvokeExpression methodName="HideSettingsPanel"/>
              </statements>
            </memberMethod>
            <!-- method UpdateButton_Click(object, EventArgs) -->
            <memberMethod name="UpdateButton_Click">
              <attributes family="true"/>
              <parameters>
                <parameter type="System.Object" name="sender"/>
                <parameter type="EventArgs" name="e"/>
              </parameters>
              <statements>
                <assignStatement>
                  <propertyReferenceExpression name="CurrentPage"/>
                  <propertyReferenceExpression name="ApplicationPage">
                    <fieldReferenceExpression name="selector"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <methodInvokeExpression methodName="HideSettingsPanel"/>
                <methodInvokeExpression methodName="RegisterClientScriptBlock">
                  <target>
                    <propertyReferenceExpression name="ClientScript">
                      <propertyReferenceExpression name="Page"/>
                    </propertyReferenceExpression>
                  </target>
                  <parameters>
                    <methodInvokeExpression methodName="GetType"/>
                    <primitiveExpression value="ReloadPage"/>
                    <primitiveExpression value="location.replace(location.href);"/>
                    <primitiveExpression value="true"/>
                  </parameters>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
      </types>
    </compileUnit>
  </xsl:template>
</xsl:stylesheet>
