<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.codeontime.com/2008/codedom-compiler"  xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl a"
>
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="MembershipEnabled" select="'false'"/>
  <xsl:param name="IsClassLibrary" select="'false'"/>
  <xsl:param name="AppVersion"/>
  <xsl:param name="ScriptOnly" select="'false'"/>
  <xsl:param name="CKEDITOR"/>
  <xsl:param name="IsUnlimited"/>
  <xsl:param name="Mobile"/>
  <xsl:param name="CodedomProviderName"/>
  <xsl:param name="jQueryMobileVersion"/>

  <xsl:variable name="ThemeFolder">
    <xsl:choose>
      <xsl:when test="$CodedomProviderName='VisualBasic'">
        <xsl:text></xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>.Theme</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="ScriptsFolder">
    <xsl:choose>
      <xsl:when test="$CodedomProviderName='VisualBasic'">
        <xsl:text></xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>.Scripts</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:template match="/">

    <compileUnit>
      <imports>
        <namespaceImport name="System"/>
        <namespaceImport name="System.Collections.Generic"/>
        <namespaceImport name="System.Globalization"/>
        <namespaceImport name="System.Linq"/>
        <namespaceImport name="System.Reflection"/>
        <namespaceImport name="System.Text.RegularExpressions"/>
        <namespaceImport name="System.Web"/>
        <namespaceImport name="System.Web.UI"/>
        <namespaceImport name="System.Web.UI.WebControls"/>
        <namespaceImport name="System.Web.UI.HtmlControls"/>
        <namespaceImport name="{a:project/a:namespace}.Web"/>
        <namespaceImport name="{a:project/a:namespace}.Services"/>
      </imports>
      <types>
        <!-- class _Default -->
        <typeDeclaration name="Main" isPartial="true">
          <baseTypes>
            <typeReference type="System.Web.UI.MasterPage"/>
          </baseTypes>
          <members>
            <typeConstructor>
              <statements>
                <xsl:if test="$IsUnlimited='true' and $ScriptOnly='true'">
                  <assignStatement>
                    <propertyReferenceExpression name="EnableCombinedScript">
                      <typeReferenceExpression type="AquariumExtenderBase"/>
                    </propertyReferenceExpression>
                    <primitiveExpression value="true"/>
                  </assignStatement>
                </xsl:if>
                <assignStatement>
                  <propertyReferenceExpression name="EnableMinifiedCss">
                    <typeReferenceExpression type="ApplicationServices"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="true"/>
                </assignStatement>
              </statements>
            </typeConstructor>
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
                    <propertyReferenceExpression name="EnableCombinedScript">
                      <typeReferenceExpression type="AquariumExtenderBase"/>
                    </propertyReferenceExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <propertyReferenceExpression name="EnableScriptLocalization">
                        <propertyReferenceExpression name="sm"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="false"/>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="System.String" name="pageCssClass">
                  <init>
                    <binaryOperatorExpression operator="Add">
                      <propertyReferenceExpression name="Name">
                        <methodInvokeExpression methodName="GetType">
                          <target>
                            <propertyReferenceExpression name="Page"/>
                          </target>
                        </methodInvokeExpression>
                      </propertyReferenceExpression>
                      <primitiveExpression value=" Loading"/>
                    </binaryOperatorExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="PropertyInfo" name="p">
                  <init>
                    <methodInvokeExpression methodName="GetProperty">
                      <target>
                        <methodInvokeExpression methodName="GetType">
                          <target>
                            <propertyReferenceExpression name="Page"/>
                          </target>
                        </methodInvokeExpression>
                      </target>
                      <parameters>
                        <primitiveExpression value="CssClass"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <primitiveExpression value="null"/>
                      <variableReferenceExpression name="p"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="System.String" name="cssClassName">
                      <init>
                        <castExpression targetType="System.String">
                          <methodInvokeExpression methodName="GetValue">
                            <target>
                              <variableReferenceExpression name="p"/>
                            </target>
                            <parameters>
                              <propertyReferenceExpression name="Page"/>
                              <primitiveExpression value="null"/>
                            </parameters>
                          </methodInvokeExpression>
                        </castExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="Not">
                          <methodInvokeExpression methodName="IsNullOrEmpty">
                            <target>
                              <typeReferenceExpression type="String"/>
                            </target>
                            <parameters>
                              <variableReferenceExpression name="pageCssClass"/>
                            </parameters>
                          </methodInvokeExpression>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="pageCssClass"/>
                          <binaryOperatorExpression operator="Add">
                            <variableReferenceExpression name="pageCssClass"/>
                            <primitiveExpression value=" "/>
                          </binaryOperatorExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                    <assignStatement>
                      <variableReferenceExpression name="pageCssClass"/>
                      <binaryOperatorExpression operator="Add">
                        <variableReferenceExpression name="pageCssClass"/>
                        <variableReferenceExpression name="cssClassName"/>
                      </binaryOperatorExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="Not">
                      <methodInvokeExpression methodName="Contains">
                        <target>
                          <variableReferenceExpression name="pageCssClass"/>
                        </target>
                        <parameters>
                          <primitiveExpression value="Wide"/>
                        </parameters>
                      </methodInvokeExpression>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="pageCssClass"/>
                      <binaryOperatorExpression operator="Add">
                        <variableReferenceExpression name="pageCssClass"/>
                        <primitiveExpression value=" Standard"/>
                      </binaryOperatorExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="LiteralControl" name="c">
                  <init>
                    <castExpression targetType="LiteralControl">
                      <arrayIndexerExpression>
                        <target>
                          <propertyReferenceExpression name="Controls">
                            <propertyReferenceExpression name="Form">
                              <propertyReferenceExpression name="Page"/>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                        </target>
                        <indices>
                          <primitiveExpression value="0"/>
                        </indices>
                      </arrayIndexerExpression>
                    </castExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <binaryOperatorExpression operator="IdentityInequality">
                        <primitiveExpression value="null"/>
                        <variableReferenceExpression name="c"/>
                      </binaryOperatorExpression>
                      <unaryOperatorExpression operator="Not">
                        <methodInvokeExpression methodName="IsNullOrEmpty">
                          <target>
                            <typeReferenceExpression type="String"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="pageCssClass"/>
                          </parameters>
                        </methodInvokeExpression>
                      </unaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <propertyReferenceExpression name="Text">
                        <variableReferenceExpression name="c"/>
                      </propertyReferenceExpression>
                      <methodInvokeExpression methodName="Replace">
                        <target>
                          <typeReferenceExpression type="Regex"/>
                        </target>
                        <parameters>
                          <propertyReferenceExpression name="Text">
                            <variableReferenceExpression name="c"/>
                          </propertyReferenceExpression>
                          <primitiveExpression>
                            <xsl:attribute name="value"><![CDATA[<div>]]></xsl:attribute>
                          </primitiveExpression>
                          <methodInvokeExpression methodName="Format">
                            <target>
                              <typeReferenceExpression type="String"/>
                            </target>
                            <parameters>
                              <primitiveExpression>
                                <xsl:attribute name="value"><![CDATA[<div class="{0}">]]></xsl:attribute>
                              </primitiveExpression>
                              <variableReferenceExpression name="pageCssClass"/>
                            </parameters>
                          </methodInvokeExpression>
                          <!--<propertyReferenceExpression name="Compiled">
														<typeReferenceExpression type="RegexOptions"/>
													</propertyReferenceExpression>-->
                        </parameters>
                      </methodInvokeExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <xsl:if test="$CKEDITOR='true'">
                  <methodInvokeExpression methodName="Add">
                    <target>
                      <propertyReferenceExpression name="Scripts">
                        <methodInvokeExpression methodName="GetCurrent">
                          <target>
                            <typeReferenceExpression type="ScriptManager"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="Page"/>
                          </parameters>
                        </methodInvokeExpression>
                      </propertyReferenceExpression>
                    </target>
                    <parameters>
                      <objectCreateExpression type="ScriptReference">
                        <parameters>
                          <primitiveExpression value="~/ckeditor/ckeditor.js"/>
                        </parameters>
                      </objectCreateExpression>
                    </parameters>
                  </methodInvokeExpression>
                </xsl:if>
              </statements>
            </memberMethod>
            <!-- method Page_PreRender(object, EventArgs) -->
            <memberMethod name="Page_PreRender">
              <attributes family="true" final="true"/>
              <parameters>
                <parameter type="System.Object" name="sender"/>
                <parameter type="EventArgs" name="e"/>
              </parameters>
              <statements>
                <xsl:if test="$ScriptOnly='true' ">
                  <methodInvokeExpression methodName="RegisterCssLinks">
                    <target>
                      <typeReferenceExpression type="ApplicationServices"/>
                    </target>
                    <parameters>
                      <propertyReferenceExpression name="Page"/>
                    </parameters>
                  </methodInvokeExpression>
                </xsl:if>
              </statements>
            </memberMethod>
            <!-- field MicrosoftJavaScript-->
            <memberField type="System.String[]" name="MicrosoftJavaScript">
              <attributes public="true" static="true"/>
              <init>
                <arrayCreateExpression>
                  <createType type="System.String"/>
                  <initializers>
                    <primitiveExpression value="MicrosoftAjax.js"/>
                    <primitiveExpression value="MicrosoftAjaxWebForms.js"/>
                    <primitiveExpression value="MicrosoftAjaxApplicationServices.js"/>
                  </initializers>
                </arrayCreateExpression>
              </init>
            </memberField>
            <!-- method sm_ResolveScriptReference(object, ScriptReferenceEventArgs) -->
            <memberMethod name="sm_ResolveScriptReference">
              <attributes family="true" final="true"/>
              <parameters>
                <parameter type="System.Object" name="sender"/>
                <parameter type="ScriptReferenceEventArgs" name="e"/>
              </parameters>
              <statements>
                <xsl:if test="$ScriptOnly='true' ">
                  <conditionStatement>
                    <condition>
                      <binaryOperatorExpression operator="GreaterThanOrEqual">
                        <methodInvokeExpression methodName="IndexOf">
                          <target>
                            <typeReferenceExpression type="System.Array"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="MicrosoftJavaScript"/>
                            <propertyReferenceExpression name="Name">
                              <propertyReferenceExpression name="Script">
                                <argumentReferenceExpression name="e"/>
                              </propertyReferenceExpression>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                        <primitiveExpression value="0"/>
                      </binaryOperatorExpression>
                    </condition>
                    <trueStatements>
                      <xsl:if test="$IsUnlimited='true'">
                        <conditionStatement>
                          <condition>
                            <propertyReferenceExpression name="EnableCombinedScript">
                              <typeReferenceExpression type="AquariumExtenderBase"/>
                            </propertyReferenceExpression>
                          </condition>
                          <trueStatements>
                            <variableDeclarationStatement type="System.String" name="lang">
                              <init>
                                <methodInvokeExpression methodName="ToLower">
                                  <target>
                                    <propertyReferenceExpression name="IetfLanguageTag">
                                      <propertyReferenceExpression name="CurrentUICulture">
                                        <typeReferenceExpression type="CultureInfo"/>
                                      </propertyReferenceExpression>
                                    </propertyReferenceExpression>
                                  </target>
                                </methodInvokeExpression>
                              </init>
                            </variableDeclarationStatement>
                            <variableDeclarationStatement type="System.String" name="scriptPath">
                              <init>
                                <stringFormatExpression format="~/appservices/combined-{{0}}.{{1}}.js">
                                  <propertyReferenceExpression name="Version">
                                    <typeReferenceExpression type="ApplicationServices"/>
                                  </propertyReferenceExpression>
                                  <variableReferenceExpression name="lang"/>
                                </stringFormatExpression>
                              </init>
                            </variableDeclarationStatement>
                            <conditionStatement>
                              <condition>
                                <propertyReferenceExpression name="IsMobileClient">
                                  <typeReferenceExpression type="ApplicationServices"/>
                                </propertyReferenceExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="scriptPath"/>
                                  <stringFormatExpression format="{{0}}?_mobile">
                                    <variableReferenceExpression name="scriptPath"/>
                                  </stringFormatExpression>
                                </assignStatement>
                              </trueStatements>
                            </conditionStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="Path">
                                <propertyReferenceExpression name="Script">
                                  <argumentReferenceExpression name="e"/>
                                </propertyReferenceExpression>
                              </propertyReferenceExpression>
                              <variableReferenceExpression name="scriptPath"/>
                            </assignStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="ResourceUICultures">
                                <propertyReferenceExpression name="Script">
                                  <argumentReferenceExpression name="e"/>
                                </propertyReferenceExpression>
                              </propertyReferenceExpression>
                              <primitiveExpression value="null"/>
                            </assignStatement>
                            <methodReturnStatement/>
                          </trueStatements>
                        </conditionStatement>
                      </xsl:if>
                      <xsl:choose>
                        <xsl:when test="$IsClassLibrary='true'">
                          <assignStatement>
                            <propertyReferenceExpression name="Name">
                              <propertyReferenceExpression name="Script">
                                <argumentReferenceExpression name="e"/>
                              </propertyReferenceExpression>
                            </propertyReferenceExpression>
                            <binaryOperatorExpression operator="Add">
                              <primitiveExpression value="{a:project/a:namespace}{$ScriptsFolder}."/>
                              <propertyReferenceExpression name="Name">
                                <propertyReferenceExpression name="Script">
                                  <argumentReferenceExpression name="e"/>
                                </propertyReferenceExpression>
                              </propertyReferenceExpression>
                            </binaryOperatorExpression>
                          </assignStatement>
                          <assignStatement>
                            <propertyReferenceExpression name="Assembly">
                              <propertyReferenceExpression name="Script">
                                <argumentReferenceExpression name="e"/>
                              </propertyReferenceExpression>
                            </propertyReferenceExpression>
                            <propertyReferenceExpression name="FullName">
                              <propertyReferenceExpression name="Assembly">
                                <typeofExpression type="AquariumExtenderBase"/>
                              </propertyReferenceExpression>
                            </propertyReferenceExpression>
                          </assignStatement>
                        </xsl:when>
                        <xsl:otherwise>
                          <assignStatement>
                            <propertyReferenceExpression name="Path">
                              <propertyReferenceExpression name="Script">
                                <argumentReferenceExpression name="e"/>
                              </propertyReferenceExpression>
                            </propertyReferenceExpression>
                            <stringFormatExpression format="~/Scripts/{{0}}?{{1}}">
                              <propertyReferenceExpression name="Name">
                                <propertyReferenceExpression name="Script">
                                  <argumentReferenceExpression name="e"/>
                                </propertyReferenceExpression>
                              </propertyReferenceExpression>
                              <propertyReferenceExpression name="Version">
                                <typeReferenceExpression type="ApplicationServices"/>
                              </propertyReferenceExpression>
                            </stringFormatExpression>
                          </assignStatement>
                        </xsl:otherwise>
                      </xsl:choose>
                    </trueStatements>
                  </conditionStatement>
                </xsl:if>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
      </types>
    </compileUnit>
  </xsl:template>
</xsl:stylesheet>
