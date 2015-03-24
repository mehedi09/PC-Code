<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.codeontime.com/2008/codedom-compiler"  xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl a"
>
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="IsClassLibrary" select="'false'"/>
  <xsl:param name="Theme" select="'Aquarium'"/>
  <xsl:param name="IsPremium"/>
  <xsl:param name="IsUnlimited"/>
  <xsl:param name="Mobile"/>
  <xsl:param name="Host"/>
  <xsl:param name="AppVersion"/>
  <xsl:param name="ScriptOnly" select="'false'"/>
  <xsl:param name="ProjectId"/>
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

  <xsl:variable name="AspNet35AppServicesFix" select="a:project/@targetFramework='3.5' and a:project/a:membership/@enabled='true'"/>
  <xsl:variable name="Namespace" select="/a:project/a:namespace"/>

  <xsl:template match="/">
    <compileUnit namespace="{$Namespace}.Web">
      <imports>
        <namespaceImport name="System"/>
        <namespaceImport name="System.Data"/>
        <namespaceImport name="System.Collections.Generic"/>
        <namespaceImport name="System.Configuration"/>
        <namespaceImport name="System.Globalization"/>
        <namespaceImport name="System.IO"/>
        <namespaceImport name="System.Text.RegularExpressions"/>
        <namespaceImport name="System.Threading"/>
        <namespaceImport name="System.Web"/>
        <namespaceImport name="System.Web.Security"/>
        <namespaceImport name="System.Web.UI"/>
        <namespaceImport name="System.Web.UI.HtmlControls"/>
        <namespaceImport name="System.Web.UI.WebControls"/>
        <namespaceImport name="System.Web.UI.WebControls.WebParts"/>
        <namespaceImport name="{$Namespace}.Data"/>
        <namespaceImport name="{$Namespace}.Services"/>
        <xsl:if test="$ScriptOnly='false'">
          <namespaceImport name="AjaxControlToolkit"/>
        </xsl:if>
      </imports>
      <types>
        <!-- class AquariumFieldEditorAttribute -->
        <typeDeclaration name="AquariumFieldEditorAttribute">
          <baseTypes>
            <typeReference type="Attribute"/>
          </baseTypes>
        </typeDeclaration>
        <!-- class AquariumExtenderBase -->
        <typeDeclaration name="AquariumExtenderBase">
          <attributes public="true"/>
          <customAttributes>
            <!--<xsl:if test="$IsClassLibrary='true'">
              <customAttribute name="ClientCssResource">
                <arguments>
                  <primitiveExpression value="{$Namespace}.Theme.{$Theme}.css"/>
                </arguments>
              </customAttribute>
            </xsl:if>-->
          </customAttributes>
          <baseTypes>
            <typeReference type="ExtenderControl"/>
          </baseTypes>
          <members>
            <memberField type="System.String" name="clientComponentName"/>
            <xsl:if test="$Host='DotNetNuke'">
              <memberProperty type="System.String" name="RootPath">
                <attributes private="true"/>
                <getStatements>
                  <variableDeclarationStatement type="System.String" name="path">
                    <init>
                      <propertyReferenceExpression name="Empty">
                        <typeReferenceExpression type="String"/>
                      </propertyReferenceExpression>
                    </init>
                  </variableDeclarationStatement>
                  <variableDeclarationStatement type="System.String" name="appPath">
                    <init>
                      <propertyReferenceExpression name="ApplicationPath">
                        <propertyReferenceExpression name="Request">
                          <propertyReferenceExpression name="Page"/>
                        </propertyReferenceExpression>
                      </propertyReferenceExpression>
                    </init>
                  </variableDeclarationStatement>
                  <conditionStatement>
                    <condition>
                      <binaryOperatorExpression operator="GreaterThan">
                        <propertyReferenceExpression name="Length">
                          <variableReferenceExpression name="appPath"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="1"/>
                      </binaryOperatorExpression>
                    </condition>
                    <trueStatements>
                      <assignStatement>
                        <variableReferenceExpression name="path"/>
                        <primitiveExpression value="../"/>
                      </assignStatement>
                    </trueStatements>
                  </conditionStatement>
                  <forStatement>
                    <variable type="System.Int32" name="i">
                      <init>
                        <primitiveExpression value="1"/>
                      </init>
                    </variable>
                    <test>
                      <binaryOperatorExpression operator="LessThan">
                        <variableReferenceExpression name="i"/>
                        <propertyReferenceExpression name="Length">
                          <variableReferenceExpression name="appPath"/>
                        </propertyReferenceExpression>
                      </binaryOperatorExpression>
                    </test>
                    <increment>
                      <variableReferenceExpression name="i"/>
                    </increment>
                    <statements>
                      <conditionStatement>
                        <condition>
                          <binaryOperatorExpression operator="ValueEquality">
                            <arrayIndexerExpression>
                              <target>
                                <variableReferenceExpression name="appPath"/>
                              </target>
                              <indices>
                                <variableReferenceExpression name="i"/>
                              </indices>
                            </arrayIndexerExpression>
                            <primitiveExpression value="/" convertTo="Char"/>
                          </binaryOperatorExpression>
                        </condition>
                        <trueStatements>
                          <assignStatement>
                            <variableReferenceExpression name="path"/>
                            <binaryOperatorExpression operator="Add">
                              <variableReferenceExpression name="path"/>
                              <primitiveExpression value="../"/>
                            </binaryOperatorExpression>
                          </assignStatement>
                        </trueStatements>
                      </conditionStatement>
                    </statements>
                  </forStatement>
                  <methodReturnStatement>
                    <variableReferenceExpression name="path"/>
                  </methodReturnStatement>
                </getStatements>
              </memberProperty>
            </xsl:if>
            <!-- property DefaultServicePath -->
            <memberField type="System.String" name="DefaultServicePath">
              <attributes public="true" static="true"/>
              <init>
                <xsl:choose>
                  <xsl:when test="$IsClassLibrary='true'">
                    <primitiveExpression value="~/DAF/Service.asmx"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <primitiveExpression value="~/Services/DataControllerService.asmx"/>
                  </xsl:otherwise>
                </xsl:choose>
              </init>
            </memberField>
            <!-- property ServicePath -->
            <memberField type="System.String" name="servicePath"/>
            <memberProperty type="System.String" name="ServicePath">
              <attributes public="true" />
              <customAttributes>
                <customAttribute name="System.ComponentModel.Description">
                  <arguments>
                    <primitiveExpression value="A path to a data controller web service."/>
                  </arguments>
                </customAttribute>
                <customAttribute name="System.ComponentModel.DefaultValue">
                  <arguments>
                    <xsl:choose>
                      <xsl:when test="$IsClassLibrary='true'">
                        <primitiveExpression value="~/DAF/Service.asmx"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <primitiveExpression value="~/Services/DataControllerService.asmx"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </arguments>
                </customAttribute>
              </customAttributes>
              <getStatements>
                <xsl:if test="$Host='DotNetNuke'">
                  <conditionStatement>
                    <condition>
                      <binaryOperatorExpression operator="BooleanAnd">
                        <binaryOperatorExpression operator="IdentityInequality">
                          <propertyReferenceExpression name="Request">
                            <propertyReferenceExpression name="Page"/>
                          </propertyReferenceExpression>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                        <unaryOperatorExpression operator="Not">
                          <methodInvokeExpression methodName="Equals">
                            <target>
                              <propertyReferenceExpression name="AppRelativeCurrentExecutionFilePath">
                                <propertyReferenceExpression name="Request">
                                  <propertyReferenceExpression name="Page"/>
                                </propertyReferenceExpression>
                              </propertyReferenceExpression>
                            </target>
                            <parameters>
                              <primitiveExpression value="~/Start.aspx"/>
                              <propertyReferenceExpression name="OrdinalIgnoreCase">
                                <typeReferenceExpression type="StringComparison"/>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </unaryOperatorExpression>
                      </binaryOperatorExpression>
                    </condition>
                    <trueStatements>
                      <methodReturnStatement>
                        <stringFormatExpression format="~/{{0}}{{1}}/../Service.asmx">
                          <propertyReferenceExpression name="RootPath"/>
                          <propertyReferenceExpression name="TemplateSourceDirectory"/>
                        </stringFormatExpression>
                      </methodReturnStatement>
                    </trueStatements>
                  </conditionStatement>
                </xsl:if>
                <xsl:if test="$Host='SharePoint'">
                  <conditionStatement>
                    <condition>
                      <binaryOperatorExpression operator="BooleanAnd">
                        <binaryOperatorExpression operator="IdentityInequality">
                          <propertyReferenceExpression name="Request">
                            <propertyReferenceExpression name="Page"/>
                          </propertyReferenceExpression>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                        <methodInvokeExpression methodName="StartsWith">
                          <target>
                            <propertyReferenceExpression name="TemplateSourceDirectory"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="/_CONTROLTEMPLATES/{$Namespace}/"/>
                            <propertyReferenceExpression name="OrdinalIgnoreCase">
                              <typeReferenceExpression type="StringComparison"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </binaryOperatorExpression>
                    </condition>
                    <trueStatements>
                      <methodReturnStatement>
                        <stringFormatExpression format="/_layouts/{$Namespace}/Service.asmx">
                          <propertyReferenceExpression name="TemplateSourceDirectory"/>
                        </stringFormatExpression>
                      </methodReturnStatement>
                    </trueStatements>
                  </conditionStatement>
                </xsl:if>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="IsNullOrEmpty">
                      <target>
                        <typeReferenceExpression type="String"/>
                      </target>
                      <parameters>
                        <fieldReferenceExpression name="servicePath"/>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <propertyReferenceExpression name="DefaultServicePath">
                        <typeReferenceExpression type="AquariumExtenderBase"/>
                      </propertyReferenceExpression>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <fieldReferenceExpression name="servicePath"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="servicePath"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property Properties -->
            <memberField type="SortedDictionary" name="properties">
              <typeArguments>
                <typeReference type="System.String"/>
                <typeReference type="System.Object"/>
              </typeArguments>
            </memberField>
            <memberProperty type="SortedDictionary" name="Properties">
              <typeArguments>
                <typeReference type="System.String"/>
                <typeReference type="System.Object"/>
              </typeArguments>
              <attributes public="true" final="true"/>
              <customAttributes>
                <customAttribute name="System.ComponentModel.Browsable">
                  <arguments>
                    <primitiveExpression value="false"/>
                  </arguments>
                </customAttribute>
              </customAttributes>
              <getStatements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <fieldReferenceExpression name="properties"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <fieldReferenceExpression name="properties"/>
                      <objectCreateExpression type="SortedDictionary">
                        <typeArguments>
                          <typeReference type="System.String"/>
                          <typeReference type="System.Object"/>
                        </typeArguments>
                      </objectCreateExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <fieldReferenceExpression name="properties"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- contructor AquariumExtenderBase() -->
            <constructor>
              <attributes public="true"/>
              <parameters>
                <parameter type="System.String" name="clientComponentName"/>
              </parameters>
              <statements>
                <assignStatement>
                  <fieldReferenceExpression name="clientComponentName">
                    <thisReferenceExpression/>
                  </fieldReferenceExpression>
                  <argumentReferenceExpression name="clientComponentName"/>
                </assignStatement>
              </statements>
            </constructor>
            <!-- method GetScriptDescriptors(Control) -->
            <memberMethod returnType="System.Collections.Generic.IEnumerable" name="GetScriptDescriptors">
              <typeArguments>
                <typeReference type="ScriptDescriptor"/>
              </typeArguments>
              <attributes family="true" override="true"/>
              <parameters>
                <parameter type="Control" name="targetControl"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <propertyReferenceExpression name="Site"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="null"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <propertyReferenceExpression name="IsInAsyncPostBack">
                      <methodInvokeExpression methodName="GetCurrent">
                        <target>
                          <typeReferenceExpression type="ScriptManager"/>
                        </target>
                        <parameters>
                          <propertyReferenceExpression name="Page"/>
                        </parameters>
                      </methodInvokeExpression>
                    </propertyReferenceExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="System.Boolean" name="requireRegistration">
                      <init>
                        <primitiveExpression value="false"/>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="Control" name="c">
                      <init>
                        <thisReferenceExpression/>
                      </init>
                    </variableDeclarationStatement>
                    <whileStatement>
                      <test>
                        <binaryOperatorExpression operator="BooleanAnd">
                          <unaryOperatorExpression operator="Not">
                            <variableReferenceExpression name="requireRegistration"/>
                          </unaryOperatorExpression>
                          <binaryOperatorExpression operator="BooleanAnd">
                            <binaryOperatorExpression operator="IdentityInequality">
                              <variableReferenceExpression name="c"/>
                              <primitiveExpression value="null"/>
                            </binaryOperatorExpression>
                            <unaryOperatorExpression operator="Not">
                              <binaryOperatorExpression operator="IsTypeOf">
                                <variableReferenceExpression name="c"/>
                                <typeReferenceExpression type="HtmlForm"/>
                              </binaryOperatorExpression>
                            </unaryOperatorExpression>
                          </binaryOperatorExpression>
                        </binaryOperatorExpression>
                      </test>
                      <statements>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="IsTypeOf">
                              <variableReferenceExpression name="c"/>
                              <typeReferenceExpression type="UpdatePanel"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="requireRegistration"/>
                              <primitiveExpression value="true"/>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <assignStatement>
                          <variableReferenceExpression name="c"/>
                          <propertyReferenceExpression name="Parent">
                            <variableReferenceExpression name="c"/>
                          </propertyReferenceExpression>
                        </assignStatement>
                      </statements>
                    </whileStatement>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="Not">
                          <variableReferenceExpression name="requireRegistration"/>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodReturnStatement>
                          <primitiveExpression value="null"/>
                        </methodReturnStatement>
                      </trueStatements>
                    </conditionStatement>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="ScriptBehaviorDescriptor" name="descriptor">
                  <init>
                    <objectCreateExpression type="ScriptBehaviorDescriptor">
                      <parameters>
                        <fieldReferenceExpression name="clientComponentName"/>
                        <propertyReferenceExpression name="ClientID">
                          <argumentReferenceExpression name="targetControl"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <methodInvokeExpression methodName="AddProperty">
                  <target>
                    <variableReferenceExpression name="descriptor"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="id"/>
                    <propertyReferenceExpression name="ClientID">
                      <thisReferenceExpression/>
                    </propertyReferenceExpression>
                  </parameters>
                </methodInvokeExpression>
                <variableDeclarationStatement type="System.String" name="baseUrl">
                  <init>
                    <methodInvokeExpression methodName="ResolveClientUrl">
                      <parameters>
                        <primitiveExpression value="~"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <variableReferenceExpression name="baseUrl"/>
                      <primitiveExpression value="~"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="baseUrl"/>
                      <propertyReferenceExpression name="Empty">
                        <typeReferenceExpression type="String"/>
                      </propertyReferenceExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <methodInvokeExpression methodName="AddProperty">
                  <target>
                    <variableReferenceExpression name="descriptor"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="baseUrl"/>
                    <variableReferenceExpression name="baseUrl"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="AddProperty">
                  <target>
                    <variableReferenceExpression name="descriptor"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="servicePath"/>
                    <methodInvokeExpression methodName="ResolveClientUrl">
                      <parameters>
                        <propertyReferenceExpression name="ServicePath"/>
                      </parameters>
                    </methodInvokeExpression>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="ConfigureDescriptor">
                  <parameters>
                    <variableReferenceExpression name="descriptor"/>
                  </parameters>
                </methodInvokeExpression>
                <methodReturnStatement>
                  <arrayCreateExpression>
                    <createType type="ScriptBehaviorDescriptor"/>
                    <initializers>
                      <variableReferenceExpression name="descriptor"/>
                    </initializers>
                  </arrayCreateExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method ConfigureDescriptor -->
            <memberMethod name="ConfigureDescriptor">
              <attributes family="true"/>
              <parameters>
                <parameter type="ScriptBehaviorDescriptor" name="descriptor"/>
              </parameters>
            </memberMethod>
            <!-- method CreateScriptReference(string) -->
            <memberMethod returnType="ScriptReference" name="CreateScriptReference">
              <attributes static="true" public="true"/>
              <parameters>
                <parameter type="System.String" name="p"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="CultureInfo" name="culture">
                  <init>
                    <propertyReferenceExpression name="CurrentUICulture">
                      <propertyReferenceExpression name="CurrentThread">
                        <typeReferenceExpression type="Thread"/>
                      </propertyReferenceExpression>
                    </propertyReferenceExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="List" name="scripts">
                  <typeArguments>
                    <typeReference type="System.String"/>
                  </typeArguments>
                  <init>
                    <castExpression targetType="List">
                      <typeArguments>
                        <typeReference type="System.String"/>
                      </typeArguments>
                      <arrayIndexerExpression>
                        <target>
                          <propertyReferenceExpression name="Cache">
                            <typeReferenceExpression type="HttpRuntime"/>
                          </propertyReferenceExpression>
                        </target>
                        <indices>
                          <primitiveExpression value="AllApplicationScripts"/>
                        </indices>
                      </arrayIndexerExpression>
                    </castExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <variableReferenceExpression name="scripts"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="scripts"/>
                      <objectCreateExpression type="List">
                        <typeArguments>
                          <typeReference type="System.String"/>
                        </typeArguments>
                      </objectCreateExpression>
                    </assignStatement>
                    <variableDeclarationStatement type="System.String[]" name="files">
                      <init>
                        <methodInvokeExpression methodName="GetFiles">
                          <target>
                            <typeReferenceExpression type="Directory"/>
                          </target>
                          <parameters>
                            <methodInvokeExpression methodName="MapPath">
                              <target>
                                <propertyReferenceExpression name="Server">
                                  <propertyReferenceExpression name="Current">
                                    <typeReferenceExpression type="HttpContext"/>
                                  </propertyReferenceExpression>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="~/Scripts"/>
                              </parameters>
                            </methodInvokeExpression>
                            <primitiveExpression value="*.js"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <foreachStatement>
                      <variable type="System.String" name="script"/>
                      <target>
                        <variableReferenceExpression name="files"/>
                      </target>
                      <statements>
                        <variableDeclarationStatement type="Match" name="m">
                          <init>
                            <methodInvokeExpression methodName="Match">
                              <target>
                                <typeReferenceExpression type="Regex"/>
                              </target>
                              <parameters>
                                <methodInvokeExpression methodName="GetFileName">
                                  <target>
                                    <typeReferenceExpression type="Path"/>
                                  </target>
                                  <parameters>
                                    <variableReferenceExpression name="script"/>
                                  </parameters>
                                </methodInvokeExpression>
                                <primitiveExpression value="^(.+?)\.(\w\w(\-\w+)*)\.js$"/>
                                <!--<propertyReferenceExpression name="Compiled">
																	<typeReferenceExpression type="RegexOptions"/>
																</propertyReferenceExpression>-->
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
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <variableReferenceExpression name="scripts"/>
                              </target>
                              <parameters>
                                <propertyReferenceExpression name="Value">
                                  <variableReferenceExpression name="m"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>
                      </statements>
                    </foreachStatement>
                    <assignStatement>
                      <arrayIndexerExpression>
                        <target>
                          <propertyReferenceExpression name="Cache">
                            <typeReferenceExpression type="HttpRuntime"/>
                          </propertyReferenceExpression>
                        </target>
                        <indices>
                          <primitiveExpression value="AllApplicationScripts"/>
                        </indices>
                      </arrayIndexerExpression>
                      <variableReferenceExpression name="scripts"/>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="GreaterThan">
                      <propertyReferenceExpression name="Count">
                        <variableReferenceExpression name="scripts"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="0"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="Match" name="name">
                      <init>
                        <methodInvokeExpression methodName="Match">
                          <target>
                            <typeReferenceExpression type="Regex"/>
                          </target>
                          <parameters>
                            <argumentReferenceExpression name="p"/>
                            <primitiveExpression value="^(?'Path'.+\/)(?'Name'.+?)\.js$"/>
                            <!--<propertyReferenceExpression name="Compiled">
															<typeReferenceExpression type="RegexOptions"/>
														</propertyReferenceExpression>-->
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <propertyReferenceExpression name="Success">
                          <variableReferenceExpression name="name"/>
                        </propertyReferenceExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="System.String" name="test">
                          <init>
                            <stringFormatExpression format="{{0}}.{{1}}.js">
                              <propertyReferenceExpression name="Value">
                                <arrayIndexerExpression>
                                  <target>
                                    <propertyReferenceExpression name="Groups">
                                      <variableReferenceExpression name="name"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <indices>
                                    <primitiveExpression value="Name"/>
                                  </indices>
                                </arrayIndexerExpression>
                              </propertyReferenceExpression>
                              <propertyReferenceExpression name="Name">
                                <variableReferenceExpression name="culture"/>
                              </propertyReferenceExpression>
                            </stringFormatExpression>
                            <!--<methodInvokeExpression methodName="Format">
                              <target>
                                <typeReferenceExpression type="String"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="{{0}}.{{1}}.js"/>
                                <propertyReferenceExpression name="Value">
                                  <arrayIndexerExpression>
                                    <target>
                                      <propertyReferenceExpression name="Groups">
                                        <variableReferenceExpression name="name"/>
                                      </propertyReferenceExpression>
                                    </target>
                                    <indices>
                                      <primitiveExpression value="Name"/>
                                    </indices>
                                  </arrayIndexerExpression>
                                </propertyReferenceExpression>
                                <propertyReferenceExpression name="Name">
                                  <variableReferenceExpression name="culture"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>-->
                          </init>
                        </variableDeclarationStatement>
                        <variableDeclarationStatement type="System.Boolean" name="success">
                          <init>
                            <methodInvokeExpression methodName="Contains">
                              <target>
                                <variableReferenceExpression name="scripts"/>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="test"/>
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <unaryOperatorExpression operator="Not">
                              <variableReferenceExpression name="success"/>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="test"/>
                              <stringFormatExpression format="{{0}}.{{1}}.js">
                                <propertyReferenceExpression name="Value">
                                  <arrayIndexerExpression>
                                    <target>
                                      <propertyReferenceExpression name="Groups">
                                        <variableReferenceExpression name="name"/>
                                      </propertyReferenceExpression>
                                    </target>
                                    <indices>
                                      <primitiveExpression value="Name"/>
                                    </indices>
                                  </arrayIndexerExpression>
                                </propertyReferenceExpression>
                                <methodInvokeExpression methodName="Substring">
                                  <target>
                                    <propertyReferenceExpression name="Name">
                                      <variableReferenceExpression name="culture"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="0"/>
                                    <primitiveExpression value="2"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </stringFormatExpression>
                              <!--<methodInvokeExpression methodName="Format">
                                <target>
                                  <typeReferenceExpression type="String"/>
                                </target>
                                <parameters>
                                  <primitiveExpression value="{{0}}.{{1}}.js"/>
                                  <propertyReferenceExpression name="Value">
                                    <arrayIndexerExpression>
                                      <target>
                                        <propertyReferenceExpression name="Groups">
                                          <variableReferenceExpression name="name"/>
                                        </propertyReferenceExpression>
                                      </target>
                                      <indices>
                                        <primitiveExpression value="Name"/>
                                      </indices>
                                    </arrayIndexerExpression>
                                  </propertyReferenceExpression>
                                  <methodInvokeExpression methodName="Substring">
                                    <target>
                                      <propertyReferenceExpression name="Name">
                                        <variableReferenceExpression name="culture"/>
                                      </propertyReferenceExpression>
                                    </target>
                                    <parameters>
                                      <primitiveExpression value="0"/>
                                      <primitiveExpression value="2"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                </parameters>
                              </methodInvokeExpression>-->
                            </assignStatement>
                            <assignStatement>
                              <variableReferenceExpression name="success"/>
                              <methodInvokeExpression methodName="Contains">
                                <target>
                                  <typeReferenceExpression type="scripts"/>
                                </target>
                                <parameters>
                                  <variableReferenceExpression name="test"/>
                                </parameters>
                              </methodInvokeExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <conditionStatement>
                          <condition>
                            <variableReferenceExpression name="success"/>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <argumentReferenceExpression name="p"/>
                              <binaryOperatorExpression operator="Add">
                                <propertyReferenceExpression name="Value">
                                  <arrayIndexerExpression>
                                    <target>
                                      <propertyReferenceExpression name="Groups">
                                        <variableReferenceExpression name="name"/>
                                      </propertyReferenceExpression>
                                    </target>
                                    <indices>
                                      <primitiveExpression value="Path"/>
                                    </indices>
                                  </arrayIndexerExpression>
                                </propertyReferenceExpression>
                                <variableReferenceExpression name="test"/>
                              </binaryOperatorExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
                  </trueStatements>
                </conditionStatement>
                <xsl:if test="$AppVersion!=''">
                  <assignStatement>
                    <argumentReferenceExpression name="p"/>
                    <binaryOperatorExpression operator="Add">
                      <argumentReferenceExpression name="p"/>
                      <stringFormatExpression format="?{{0}}">
                        <propertyReferenceExpression name="Version">
                          <typeReferenceExpression type="ApplicationServices"/>
                        </propertyReferenceExpression>
                      </stringFormatExpression>/>
                    </binaryOperatorExpression>
                  </assignStatement>
                </xsl:if>
                <methodReturnStatement>
                  <objectCreateExpression type="ScriptReference">
                    <parameters>
                      <argumentReferenceExpression name="p"/>
                    </parameters>
                  </objectCreateExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- property EnableCombinedScript -->
            <memberField type="System.Boolean" name="enableCombinedScript">
              <attributes static="true" private="true"/>
            </memberField>
            <memberProperty type="System.Boolean" name="EnableCombinedScript">
              <attributes public="true" static="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="enableCombinedScript"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="enableCombinedScript"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property IgnoreCombinedScript -->
            <memberProperty type="System.Boolean" name="IgnoreCombinedScript">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- method GetScriptReferences() -->
            <memberMethod returnType="System.Collections.Generic.IEnumerable" name="GetScriptReferences">
              <typeArguments>
                <typeReference type="ScriptReference"/>
              </typeArguments>
              <attributes family="true" override="true"/>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <propertyReferenceExpression name="Site"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="null"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <binaryOperatorExpression operator="IdentityInequality">
                        <propertyReferenceExpression name="Page"/>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                      <propertyReferenceExpression name="IsInAsyncPostBack">
                        <methodInvokeExpression methodName="GetCurrent">
                          <target>
                            <typeReferenceExpression type="ScriptManager"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="Page"/>
                          </parameters>
                        </methodInvokeExpression>
                      </propertyReferenceExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="null"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="List" name="scripts">
                  <typeArguments>
                    <typeReference type="ScriptReference"/>
                  </typeArguments>
                  <init>
                    <objectCreateExpression type="List">
                      <typeArguments>
                        <typeReference type="ScriptReference"/>
                      </typeArguments>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <propertyReferenceExpression name="EnableCombinedScript"/>
                      <unaryOperatorExpression operator="Not">
                        <propertyReferenceExpression name="IgnoreCombinedScript"/>
                      </unaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <variableReferenceExpression name="scripts"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <xsl:if test="$Mobile='true'">
                  <variableDeclarationStatement type="System.Boolean" name="isMobile">
                    <init>
                      <propertyReferenceExpression name="IsMobileClient">
                        <typeReferenceExpression type="ApplicationServices"/>
                      </propertyReferenceExpression>
                    </init>
                  </variableDeclarationStatement>
                </xsl:if>
                <xsl:if test="$IsClassLibrary='true'">
                  <variableDeclarationStatement type="System.String" name="assemblyFullName">
                    <init>
                      <propertyReferenceExpression name="FullName">
                        <propertyReferenceExpression name="Assembly">
                          <methodInvokeExpression methodName="GetType"/>
                        </propertyReferenceExpression>
                      </propertyReferenceExpression>
                    </init>
                  </variableDeclarationStatement>
                </xsl:if>
                <xsl:if test="$ScriptOnly='false'">
                  <methodInvokeExpression methodName="AddRange">
                    <target>
                      <variableReferenceExpression name="scripts"/>
                    </target>
                    <parameters>
                      <methodInvokeExpression methodName="GetScriptReferences">
                        <target>
                          <typeReferenceExpression type="ScriptObjectBuilder"/>
                        </target>
                        <parameters>
                          <typeofExpression type="ModalPopupExtender"/>
                        </parameters>
                      </methodInvokeExpression>
                    </parameters>
                  </methodInvokeExpression>
                  <methodInvokeExpression methodName="AddRange">
                    <target>
                      <variableReferenceExpression name="scripts"/>
                    </target>
                    <parameters>
                      <methodInvokeExpression methodName="GetScriptReferences">
                        <target>
                          <typeReferenceExpression type="ScriptObjectBuilder"/>
                        </target>
                        <parameters>
                          <typeofExpression type="AlwaysVisibleControlExtender"/>
                        </parameters>
                      </methodInvokeExpression>
                    </parameters>
                  </methodInvokeExpression>
                  <methodInvokeExpression methodName="AddRange">
                    <target>
                      <variableReferenceExpression name="scripts"/>
                    </target>
                    <parameters>
                      <methodInvokeExpression methodName="GetScriptReferences">
                        <target>
                          <typeReferenceExpression type="ScriptObjectBuilder"/>
                        </target>
                        <parameters>
                          <typeofExpression type="PopupControlExtender"/>
                        </parameters>
                      </methodInvokeExpression>
                    </parameters>
                  </methodInvokeExpression>
                  <methodInvokeExpression methodName="AddRange">
                    <target>
                      <variableReferenceExpression name="scripts"/>
                    </target>
                    <parameters>
                      <methodInvokeExpression methodName="GetScriptReferences">
                        <target>
                          <typeReferenceExpression type="ScriptObjectBuilder"/>
                        </target>
                        <parameters>
                          <typeofExpression type="CalendarExtender"/>
                        </parameters>
                      </methodInvokeExpression>
                    </parameters>
                  </methodInvokeExpression>
                  <methodInvokeExpression methodName="AddRange">
                    <target>
                      <variableReferenceExpression name="scripts"/>
                    </target>
                    <parameters>
                      <methodInvokeExpression methodName="GetScriptReferences">
                        <target>
                          <typeReferenceExpression type="ScriptObjectBuilder"/>
                        </target>
                        <parameters>
                          <typeofExpression type="MaskedEditExtender"/>
                        </parameters>
                      </methodInvokeExpression>
                    </parameters>
                  </methodInvokeExpression>
                  <methodInvokeExpression methodName="AddRange">
                    <target>
                      <variableReferenceExpression name="scripts"/>
                    </target>
                    <parameters>
                      <methodInvokeExpression methodName="GetScriptReferences">
                        <target>
                          <typeReferenceExpression type="ScriptObjectBuilder"/>
                        </target>
                        <parameters>
                          <typeofExpression type="AutoCompleteExtender"/>
                        </parameters>
                      </methodInvokeExpression>
                    </parameters>
                  </methodInvokeExpression>
                </xsl:if>
                <xsl:choose>
                  <xsl:when test="$IsClassLibrary='true'">
                    <xsl:if test="$AspNet35AppServicesFix">
                      <methodInvokeExpression methodName="Add">
                        <target>
                          <variableReferenceExpression name="scripts"/>
                        </target>
                        <parameters>
                          <objectCreateExpression type="ScriptReference">
                            <parameters>
                              <primitiveExpression value="{$Namespace}.Scripts.MicrosoftAjaxApplicationServices.js"/>
                              <variableReferenceExpression name="assemblyFullName"/>
                            </parameters>
                          </objectCreateExpression>
                        </parameters>
                      </methodInvokeExpression>
                    </xsl:if>
                    <xsl:choose>
                      <xsl:when test="$Host='DotNetNuke'">
                        <variableDeclarationStatement type="System.Boolean" name="registerSystemJs">
                          <init>
                            <primitiveExpression value="true"/>
                          </init>
                        </variableDeclarationStatement>
                        <foreachStatement>
                          <variable type="System.Reflection.Assembly" name="a"/>
                          <target>
                            <methodInvokeExpression methodName="GetAssemblies">
                              <target>
                                <propertyReferenceExpression name="CurrentDomain">
                                  <typeReferenceExpression type="AppDomain"/>
                                </propertyReferenceExpression>
                              </target>
                            </methodInvokeExpression>
                          </target>
                          <statements>
                            <conditionStatement>
                              <condition>
                                <methodInvokeExpression methodName="Contains">
                                  <target>
                                    <propertyReferenceExpression name="FullName">
                                      <variableReferenceExpression name="a"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="DotNetNuke"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="registerSystemJs"/>
                                  <primitiveExpression value="false"/>
                                </assignStatement>
                                <breakStatement/>
                              </trueStatements>
                            </conditionStatement>
                          </statements>
                        </foreachStatement>
                        <conditionStatement>
                          <condition>
                            <variableReferenceExpression name="registerSystemJs"/>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <variableReferenceExpression name="scripts"/>
                              </target>
                              <parameters>
                                <objectCreateExpression type="ScriptReference">
                                  <parameters>
                                    <primitiveExpression value="{$Namespace}.Scripts._System.js"/>
                                    <variableReferenceExpression name="assemblyFullName"/>
                                  </parameters>
                                </objectCreateExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>
                      </xsl:when>
                      <xsl:otherwise>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <variableReferenceExpression name="scripts"/>
                          </target>
                          <parameters>
                            <objectCreateExpression type="ScriptReference">
                              <parameters>
                                <primitiveExpression value="{$Namespace}.Scripts._System.js"/>
                                <variableReferenceExpression name="assemblyFullName"/>
                              </parameters>
                            </objectCreateExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="$ScriptOnly='true'">
                      <xsl:if test="$Mobile='true'">
                        <conditionStatement>
                          <condition>
                            <variableReferenceExpression name="isMobile"/>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <variableReferenceExpression name="scripts"/>
                              </target>
                              <parameters>
                                <objectCreateExpression type="ScriptReference">
                                  <parameters>
                                    <stringFormatExpression format="~/touch/jquery.mobile-{{0}}.min.js">
                                      <propertyReferenceExpression name="JqmVersion">
                                        <typeReferenceExpression type="ApplicationServices"/>
                                      </propertyReferenceExpression>
                                    </stringFormatExpression>
                                    <!--<primitiveExpression value="~/Mobile/jquery.mobile-{$jQueryMobileVersion}.min.js"/>-->
                                  </parameters>
                                </objectCreateExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>
                      </xsl:if>
                      <methodInvokeExpression methodName="Add">
                        <target>
                          <variableReferenceExpression name="scripts"/>
                        </target>
                        <parameters>
                          <objectCreateExpression type="ScriptReference">
                            <parameters>
                              <primitiveExpression value="{$Namespace}.Scripts.MicrosoftAjax.js"/>
                              <variableReferenceExpression name="assemblyFullName"/>
                            </parameters>
                          </objectCreateExpression>
                        </parameters>
                      </methodInvokeExpression>
                      <methodInvokeExpression methodName="Add">
                        <target>
                          <variableReferenceExpression name="scripts"/>
                        </target>
                        <parameters>
                          <objectCreateExpression type="ScriptReference">
                            <parameters>
                              <primitiveExpression value="{$Namespace}.Scripts.MicrosoftAjaxWebForms.js"/>
                              <variableReferenceExpression name="assemblyFullName"/>
                            </parameters>
                          </objectCreateExpression>
                        </parameters>
                      </methodInvokeExpression>
                      <xsl:if test="a:project/a:membership[@enabled='true' or @windowsAuthentication='true' or @customSecurity='true' or @activeDirectory='true']">
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <variableReferenceExpression name="scripts"/>
                          </target>
                          <parameters>
                            <objectCreateExpression type="ScriptReference">
                              <parameters>
                                <primitiveExpression value="{$Namespace}.Scripts.MicrosoftAjaxApplicationServices.js"/>
                                <variableReferenceExpression name="assemblyFullName"/>
                              </parameters>
                            </objectCreateExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </xsl:if>
                      <xsl:choose>
                        <xsl:when test="$Mobile='true'">
                          <conditionStatement>
                            <condition>
                              <unaryOperatorExpression operator="Not">
                                <variableReferenceExpression name="isMobile"/>
                              </unaryOperatorExpression>
                            </condition>
                            <trueStatements>
                              <methodInvokeExpression methodName="Add">
                                <target>
                                  <variableReferenceExpression name="scripts"/>
                                </target>
                                <parameters>
                                  <objectCreateExpression type="ScriptReference">
                                    <parameters>
                                      <primitiveExpression value="{$Namespace}.Scripts.AjaxControlToolkit.js"/>
                                      <variableReferenceExpression name="assemblyFullName"/>
                                    </parameters>
                                  </objectCreateExpression>
                                </parameters>
                              </methodInvokeExpression>
                            </trueStatements>
                          </conditionStatement>
                        </xsl:when>
                        <xsl:otherwise>
                          <methodInvokeExpression methodName="Add">
                            <target>
                              <variableReferenceExpression name="scripts"/>
                            </target>
                            <parameters>
                              <objectCreateExpression type="ScriptReference">
                                <parameters>
                                  <primitiveExpression value="{$Namespace}.Scripts.AjaxControlToolkit.js"/>
                                  <variableReferenceExpression name="assemblyFullName"/>
                                </parameters>
                              </objectCreateExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:if>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <variableReferenceExpression name="scripts"/>
                      </target>
                      <parameters>
                        <objectCreateExpression type="ScriptReference">
                          <parameters>
                            <primitiveExpression value="{$Namespace}.Scripts.Web.DataView.js"/>
                            <variableReferenceExpression name="assemblyFullName"/>
                          </parameters>
                        </objectCreateExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <variableReferenceExpression name="scripts"/>
                      </target>
                      <parameters>
                        <objectCreateExpression type="ScriptReference">
                          <parameters>
                            <methodInvokeExpression methodName="ResolveEmbeddedResourceName">
                              <target>
                                <typeReferenceExpression type="CultureManager"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="{$Namespace}.Scripts.Web.DataViewResources.js"/>
                              </parameters>
                            </methodInvokeExpression>
                            <variableReferenceExpression name="assemblyFullName"/>
                          </parameters>
                        </objectCreateExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <xsl:if test="$IsPremium='true'">
                      <xsl:choose>
                        <xsl:when test="$Mobile='true'">
                          <conditionStatement>
                            <condition>
                              <binaryOperatorExpression operator="BooleanAnd">
                                <unaryOperatorExpression operator="Not">
                                  <variableReferenceExpression name="isMobile"/>
                                </unaryOperatorExpression>
                                <propertyReferenceExpression name="SupportsScrollingInDataSheet">
                                  <objectCreateExpression type="ControllerUtilities"/>
                                </propertyReferenceExpression>
                              </binaryOperatorExpression>
                            </condition>
                            <trueStatements>
                              <methodInvokeExpression methodName="Add">
                                <target>
                                  <variableReferenceExpression name="scripts"/>
                                </target>
                                <parameters>
                                  <objectCreateExpression type="ScriptReference">
                                    <parameters>
                                      <primitiveExpression value="{$Namespace}.Scripts.Web.DataViewExtensions.js"/>
                                      <variableReferenceExpression name="assemblyFullName"/>
                                    </parameters>
                                  </objectCreateExpression>
                                </parameters>
                              </methodInvokeExpression>
                            </trueStatements>
                          </conditionStatement>
                        </xsl:when>
                        <xsl:otherwise>
                          <conditionStatement>
                            <condition>
                              <propertyReferenceExpression name="SupportsScrollingInDataSheet">
                                <objectCreateExpression type="ControllerUtilities"/>
                              </propertyReferenceExpression>
                            </condition>
                            <trueStatements>
                              <methodInvokeExpression methodName="Add">
                                <target>
                                  <variableReferenceExpression name="scripts"/>
                                </target>
                                <parameters>
                                  <objectCreateExpression type="ScriptReference">
                                    <parameters>
                                      <primitiveExpression value="{$Namespace}.Scripts.Web.DataViewExtensions.js"/>
                                      <variableReferenceExpression name="assemblyFullName"/>
                                    </parameters>
                                  </objectCreateExpression>
                                </parameters>
                              </methodInvokeExpression>
                            </trueStatements>
                          </conditionStatement>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:if>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <variableReferenceExpression name="scripts"/>
                      </target>
                      <parameters>
                        <objectCreateExpression type="ScriptReference">
                          <parameters>
                            <primitiveExpression value="{$Namespace}.Scripts.Web.Menu.js"/>
                            <variableReferenceExpression name="assemblyFullName"/>
                          </parameters>
                        </objectCreateExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:if test="$AspNet35AppServicesFix">
                      <methodInvokeExpression methodName="Add">
                        <target>
                          <variableReferenceExpression name="scripts"/>
                        </target>
                        <parameters>
                          <methodInvokeExpression methodName="CreateScriptReference">
                            <parameters>
                              <primitiveExpression value="~/Scripts/MicrosoftAjaxApplicationServices.js"/>
                            </parameters>
                          </methodInvokeExpression>
                        </parameters>
                      </methodInvokeExpression>
                    </xsl:if>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <variableReferenceExpression name="scripts"/>
                      </target>
                      <parameters>
                        <methodInvokeExpression methodName="CreateScriptReference">
                          <parameters>
                            <primitiveExpression value="~/Scripts/_System.js"/>
                          </parameters>
                        </methodInvokeExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <xsl:if test="$ScriptOnly='true'">
                      <xsl:if test="$Mobile='true'">
                        <conditionStatement>
                          <condition>
                            <variableReferenceExpression name="isMobile"/>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <variableReferenceExpression name="scripts"/>
                              </target>
                              <parameters>
                                <methodInvokeExpression methodName="CreateScriptReference">
                                  <parameters>
                                    <stringFormatExpression format="~/touch/jquery.mobile-{{0}}.min.js">
                                      <propertyReferenceExpression name="JqmVersion">
                                        <typeReferenceExpression type="ApplicationServices"/>
                                      </propertyReferenceExpression>
                                    </stringFormatExpression>
                                    <!--<primitiveExpression value="~/Mobile/jquery.mobile-{$jQueryMobileVersion}.min.js"/>-->
                                  </parameters>
                                </methodInvokeExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>
                      </xsl:if>
                      <methodInvokeExpression methodName="Add">
                        <target>
                          <variableReferenceExpression name="scripts"/>
                        </target>
                        <parameters>
                          <methodInvokeExpression methodName="CreateScriptReference">
                            <parameters>
                              <primitiveExpression value="~/Scripts/MicrosoftAjax.js"/>
                            </parameters>
                          </methodInvokeExpression>
                        </parameters>
                      </methodInvokeExpression>
                      <methodInvokeExpression methodName="Add">
                        <target>
                          <variableReferenceExpression name="scripts"/>
                        </target>
                        <parameters>
                          <methodInvokeExpression methodName="CreateScriptReference">
                            <parameters>
                              <primitiveExpression value="~/Scripts/MicrosoftAjaxWebForms.js"/>
                            </parameters>
                          </methodInvokeExpression>
                        </parameters>
                      </methodInvokeExpression>
                      <xsl:if test="a:project/a:membership[@enabled='true' or @windowsAuthentication='true' or @customSecurity='true' or @activeDirectory='true']">
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <variableReferenceExpression name="scripts"/>
                          </target>
                          <parameters>
                            <methodInvokeExpression methodName="CreateScriptReference">
                              <parameters>
                                <primitiveExpression value="~/Scripts/MicrosoftAjaxApplicationServices.js"/>
                              </parameters>
                            </methodInvokeExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </xsl:if>
                      <xsl:choose>
                        <xsl:when test="$ProjectId='Mobile Factory'"></xsl:when>
                        <xsl:when test="$Mobile='true'">
                          <conditionStatement>
                            <condition>
                              <unaryOperatorExpression operator="Not">
                                <variableReferenceExpression name="isMobile"/>
                              </unaryOperatorExpression>
                            </condition>
                            <trueStatements>
                              <methodInvokeExpression methodName="Add">
                                <target>
                                  <variableReferenceExpression name="scripts"/>
                                </target>
                                <parameters>
                                  <methodInvokeExpression methodName="CreateScriptReference">
                                    <parameters>
                                      <primitiveExpression value="~/Scripts/AjaxControlToolkit.js"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                </parameters>
                              </methodInvokeExpression>
                            </trueStatements>
                          </conditionStatement>
                        </xsl:when>
                        <xsl:otherwise>
                          <methodInvokeExpression methodName="Add">
                            <target>
                              <variableReferenceExpression name="scripts"/>
                            </target>
                            <parameters>
                              <methodInvokeExpression methodName="CreateScriptReference">
                                <parameters>
                                  <primitiveExpression value="~/Scripts/AjaxControlToolkit.js"/>
                                </parameters>
                              </methodInvokeExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:if>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <variableReferenceExpression name="scripts"/>
                      </target>
                      <parameters>
                        <methodInvokeExpression methodName="CreateScriptReference">
                          <parameters>
                            <primitiveExpression value="~/Scripts/Web.DataViewResources.js"/>
                          </parameters>
                        </methodInvokeExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <variableReferenceExpression name="scripts"/>
                      </target>
                      <parameters>
                        <methodInvokeExpression methodName="CreateScriptReference">
                          <parameters>
                            <primitiveExpression value="~/Scripts/Web.Menu.js"/>
                          </parameters>
                        </methodInvokeExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <variableReferenceExpression name="scripts"/>
                      </target>
                      <parameters>
                        <methodInvokeExpression methodName="CreateScriptReference">
                          <parameters>
                            <primitiveExpression value="~/Scripts/Web.DataView.js"/>
                          </parameters>
                        </methodInvokeExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <xsl:if test="$IsPremium='true' and $ProjectId != 'Mobile Factory'">
                      <conditionStatement>
                        <condition>
                          <xsl:choose>
                            <xsl:when test="$Mobile='true'">
                              <binaryOperatorExpression operator="BooleanAnd">
                                <unaryOperatorExpression operator="Not">
                                  <variableReferenceExpression name="isMobile"/>
                                </unaryOperatorExpression>
                                <propertyReferenceExpression name="SupportsScrollingInDataSheet">
                                  <objectCreateExpression type="ControllerUtilities"/>
                                </propertyReferenceExpression>
                              </binaryOperatorExpression>
                            </xsl:when>
                            <xsl:otherwise>
                              <propertyReferenceExpression name="SupportsScrollingInDataSheet">
                                <objectCreateExpression type="ControllerUtilities"/>
                              </propertyReferenceExpression>
                            </xsl:otherwise>
                          </xsl:choose>
                        </condition>
                        <trueStatements>
                          <methodInvokeExpression methodName="Add">
                            <target>
                              <variableReferenceExpression name="scripts"/>
                            </target>
                            <parameters>
                              <methodInvokeExpression methodName="CreateScriptReference">
                                <parameters>
                                  <primitiveExpression value="~/Scripts/Web.DataViewExtensions.js"/>
                                </parameters>
                              </methodInvokeExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </trueStatements>
                      </conditionStatement>
                    </xsl:if>
                  </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="a:project/a:membership[@enabled='true' or @windowsAuthentication='true' or @customSecurity='true' or @activeDirectory='true']">
                  <conditionStatement>
                    <condition>
                      <propertyReferenceExpression name="EnableCombinedScript"/>
                    </condition>
                    <trueStatements>
                      <xsl:choose>
                        <xsl:when test="$IsClassLibrary='true'">
                          <methodInvokeExpression methodName="Add">
                            <target>
                              <variableReferenceExpression name="scripts"/>
                            </target>
                            <parameters>
                              <objectCreateExpression type="ScriptReference">
                                <parameters>
                                  <methodInvokeExpression methodName="ResolveEmbeddedResourceName">
                                    <target>
                                      <typeReferenceExpression type="CultureManager"/>
                                    </target>
                                    <parameters>
                                      <primitiveExpression value="{$Namespace}.Scripts.Web.MembershipResources.js"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                  <variableReferenceExpression name="assemblyFullName"/>
                                </parameters>
                              </objectCreateExpression>
                            </parameters>
                          </methodInvokeExpression>
                          <methodInvokeExpression methodName="Add">
                            <target>
                              <variableReferenceExpression name="scripts"/>
                            </target>
                            <parameters>
                              <objectCreateExpression type="ScriptReference">
                                <parameters>
                                  <primitiveExpression value="{$Namespace}.Scripts.Web.Membership.js"/>
                                  <variableReferenceExpression name="assemblyFullName"/>
                                </parameters>
                              </objectCreateExpression>
                            </parameters>
                          </methodInvokeExpression>
                          <xsl:if test="a:project/a:membership[@enabled='true']">
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <variableReferenceExpression name="scripts"/>
                              </target>
                              <parameters>
                                <objectCreateExpression type="ScriptReference">
                                  <parameters>
                                    <primitiveExpression value="{$Namespace}.Scripts.Web.MembershipManager.js"/>
                                    <variableReferenceExpression name="assemblyFullName"/>
                                  </parameters>
                                </objectCreateExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                          <methodInvokeExpression methodName="Add">
                            <target>
                              <variableReferenceExpression name="scripts"/>
                            </target>
                            <parameters>
                              <methodInvokeExpression methodName="CreateScriptReference">
                                <parameters>
                                  <primitiveExpression value="~/Scripts/Web.MembershipResources.js"/>
                                </parameters>
                              </methodInvokeExpression>
                            </parameters>
                          </methodInvokeExpression>
                          <methodInvokeExpression methodName="Add">
                            <target>
                              <variableReferenceExpression name="scripts"/>
                            </target>
                            <parameters>
                              <methodInvokeExpression methodName="CreateScriptReference">
                                <parameters>
                                  <primitiveExpression value="~/Scripts/Web.Membership.js"/>
                                </parameters>
                              </methodInvokeExpression>
                            </parameters>
                          </methodInvokeExpression>
                          <xsl:if test="a:project/a:membership[@enabled='true']">
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <variableReferenceExpression name="scripts"/>
                              </target>
                              <parameters>
                                <methodInvokeExpression methodName="CreateScriptReference">
                                  <parameters>
                                    <primitiveExpression value="~/Scripts/Web.MembershipManager.js"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </xsl:if>
                        </xsl:otherwise>
                      </xsl:choose>
                    </trueStatements>
                  </conditionStatement>
                </xsl:if>
                <methodInvokeExpression methodName="ConfigureScripts">
                  <parameters>
                    <variableReferenceExpression name="scripts"/>
                  </parameters>
                </methodInvokeExpression>
                <xsl:if test="$Mobile='true'">
                  <conditionStatement>
                    <condition>
                      <variableReferenceExpression name="isMobile"/>
                    </condition>
                    <trueStatements>
                      <xsl:choose>
                        <xsl:when test="$IsClassLibrary='true'">
                          <methodInvokeExpression methodName="Add">
                            <target>
                              <variableReferenceExpression name="scripts"/>
                            </target>
                            <parameters>
                              <objectCreateExpression type="ScriptReference">
                                <parameters>
                                  <primitiveExpression value="{$Namespace}.Scripts.Web.Mobile.js"/>
                                  <variableReferenceExpression name="assemblyFullName"/>
                                </parameters>
                              </objectCreateExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </xsl:when>
                        <xsl:otherwise>
                          <methodInvokeExpression methodName="Add">
                            <target>
                              <variableReferenceExpression name="scripts"/>
                            </target>
                            <parameters>
                              <methodInvokeExpression methodName="CreateScriptReference">
                                <parameters>
                                  <primitiveExpression value="~/Scripts/Web.Mobile.js"/>
                                </parameters>
                              </methodInvokeExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </xsl:otherwise>
                      </xsl:choose>
                    </trueStatements>
                  </conditionStatement>
                </xsl:if>
                <methodReturnStatement>
                  <variableReferenceExpression name="scripts"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <xsl:if test="$Host='DotNetNuke' or $Host='SharePoint'">
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
                  <conditionStatement>
                    <condition>
                      <binaryOperatorExpression operator="IdentityInequality">
                        <propertyReferenceExpression name="Site"/>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                    </condition>
                    <trueStatements>
                      <methodReturnStatement/>
                    </trueStatements>
                  </conditionStatement>
                  <variableDeclarationStatement type="ScriptReferenceCollection" name="scripts">
                    <init>
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
                    </init>
                  </variableDeclarationStatement>
                  <foreachStatement>
                    <variable type="ScriptReference" name="r"/>
                    <target>
                      <variableReferenceExpression name="scripts"/>
                    </target>
                    <statements>
                      <conditionStatement>
                        <condition>
                          <binaryOperatorExpression operator="ValueEquality">
                            <propertyReferenceExpression name="Name">
                              <variableReferenceExpression name="r"/>
                            </propertyReferenceExpression>
                            <primitiveExpression  value="{$Namespace}.Scripts.MicrosoftAjax.js"/>
                          </binaryOperatorExpression>
                        </condition>
                        <trueStatements>
                          <methodReturnStatement/>
                        </trueStatements>
                      </conditionStatement>
                    </statements>
                  </foreachStatement>
                  <variableDeclarationStatement type="System.String" name="assemblyFullName">
                    <init>
                      <propertyReferenceExpression name="FullName">
                        <propertyReferenceExpression name="Assembly">
                          <methodInvokeExpression methodName="GetType"/>
                        </propertyReferenceExpression>
                      </propertyReferenceExpression>
                    </init>
                  </variableDeclarationStatement>
                  <methodInvokeExpression methodName="Add">
                    <target>
                      <variableReferenceExpression name="scripts"/>
                    </target>
                    <parameters>
                      <objectCreateExpression type="ScriptReference">
                        <parameters>
                          <primitiveExpression value="{$Namespace}.Scripts.MicrosoftAjax.js"/>
                          <variableReferenceExpression name="assemblyFullName"/>
                        </parameters>
                      </objectCreateExpression>
                    </parameters>
                  </methodInvokeExpression>
                  <methodInvokeExpression methodName="Add">
                    <target>
                      <variableReferenceExpression name="scripts"/>
                    </target>
                    <parameters>
                      <objectCreateExpression type="ScriptReference">
                        <parameters>
                          <primitiveExpression value="{$Namespace}.Scripts.MicrosoftAjaxWebForms.js"/>
                          <variableReferenceExpression name="assemblyFullName"/>
                        </parameters>
                      </objectCreateExpression>
                    </parameters>
                  </methodInvokeExpression>
                </statements>
              </memberMethod>
            </xsl:if>
            <!-- method ConfigureScripts(List<ScriptReference> scripts) -->
            <memberMethod name="ConfigureScripts">
              <attributes family="true"/>
              <parameters>
                <parameter type="List" name="scripts">
                  <typeArguments>
                    <typeReference type="ScriptReference"/>
                  </typeArguments>
                </parameter>
              </parameters>
            </memberMethod>
            <xsl:variable name="TargetFramework">
              <xsl:choose>
                <xsl:when test="$IsPremium='true'">
                  <xsl:text>4.0</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>4.01</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <!-- method OnLoad(EventArgs) -->
            <memberMethod name="OnLoad">
              <attributes family="true" override="true"/>
              <parameters>
                <parameter type="EventArgs" name="e"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <propertyReferenceExpression name="IsInAsyncPostBack">
                      <methodInvokeExpression methodName="GetCurrent">
                        <target>
                          <typeReferenceExpression type="ScriptManager"/>
                        </target>
                        <parameters>
                          <propertyReferenceExpression name="Page"/>
                        </parameters>
                      </methodInvokeExpression>
                    </propertyReferenceExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement/>
                  </trueStatements>
                </conditionStatement>
                <methodInvokeExpression methodName="OnLoad">
                  <target>
                    <baseReferenceExpression/>
                  </target>
                  <parameters>
                    <argumentReferenceExpression name="e"/>
                  </parameters>
                </methodInvokeExpression>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <propertyReferenceExpression name="Site"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement/>
                  </trueStatements>
                </conditionStatement>
                <!--<variableDeclarationStatement type="CalendarExtender" name="ce">
                  <init>
                    <objectCreateExpression type="CalendarExtender"/>
                  </init>
                </variableDeclarationStatement>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <typeReferenceExpression type="Controls"/>
                  </target>
                  <parameters>
                    <variableReferenceExpression name="ce"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="RegisterCssReferences">
                  <target>
                    <typeReferenceExpression type="ScriptObjectBuilder"/>
                  </target>
                  <parameters>
                    <variableReferenceExpression name="ce"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Clear">
                  <target>
                    <propertyReferenceExpression name="Controls"/>
                  </target>
                </methodInvokeExpression>
                <xsl:if test="$IsClassLibrary='true'">
                  <methodInvokeExpression methodName="RegisterCssReferences">
                    <target>
                      <typeReferenceExpression type="ScriptObjectBuilder"/>
                    </target>
                    <parameters>
                      <thisReferenceExpression/>
                    </parameters>
                  </methodInvokeExpression>
                </xsl:if>-->
                <methodInvokeExpression  methodName="RegisterFrameworkSettings">
                  <parameters>
                    <propertyReferenceExpression name="Page"/>
                  </parameters>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- method RegisterFrameworkSettings(Page) -->
            <memberMethod name="RegisterFrameworkSettings">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="Page" name="p"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="Not">
                      <methodInvokeExpression methodName="IsStartupScriptRegistered">
                        <target>
                          <propertyReferenceExpression name="ClientScript">
                            <propertyReferenceExpression name="p"/>
                          </propertyReferenceExpression>
                        </target>
                        <parameters>
                          <typeofExpression type="AquariumExtenderBase"/>
                          <primitiveExpression value="TargetFramework"/>
                        </parameters>
                      </methodInvokeExpression>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="RegisterStartupScript">
                      <target>
                        <propertyReferenceExpression name="ClientScript">
                          <propertyReferenceExpression name="p"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <typeofExpression type="AquariumExtenderBase"/>
                        <primitiveExpression value="TargetFramework"/>
                        <stringFormatExpression>
                          <xsl:attribute name="format">
                            <xsl:text>var __targetFramework='</xsl:text>
                            <xsl:value-of select="a:project/@targetFramework"/>
                            <xsl:text>',__tf=</xsl:text>
                            <xsl:value-of select="$TargetFramework" />
                            <xsl:text>;__servicePath='{0}';__baseUrl='{1}';</xsl:text>
                            <xsl:if test="$Host!=''">
                              <xsl:text>var __cothost='</xsl:text>
                              <xsl:value-of select="$Host"/>
                              <xsl:text>';</xsl:text>
                            </xsl:if>
                          </xsl:attribute>
                          <methodInvokeExpression methodName="ResolveClientUrl">
                            <target>
                              <argumentReferenceExpression name="p"/>
                            </target>
                            <parameters>
                              <propertyReferenceExpression name="DefaultServicePath">
                                <typeReferenceExpression type="AquariumExtenderBase"/>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>
                          <methodInvokeExpression methodName="ResolveClientUrl">
                            <target>
                              <argumentReferenceExpression name="p"/>
                            </target>
                            <parameters>
                              <primitiveExpression value="~"/>
                            </parameters>
                          </methodInvokeExpression>
                        </stringFormatExpression>
                        <primitiveExpression value="true"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="RegisterStartupScript">
                      <target>
                        <propertyReferenceExpression name="ClientScript">
                          <propertyReferenceExpression name="p"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <typeofExpression type="AquariumExtenderBase"/>
                        <primitiveExpression value="TouchUI"/>
                        <stringFormatExpression>
                          <xsl:attribute name="format">
                            <xsl:text>var __settings={{appInfo:'</xsl:text>
                            <xsl:value-of select="a:project/@name"/>
                            <xsl:text>|{0}',mobileDisplayDensity:'</xsl:text>
                            <xsl:value-of select="a:project/a:features/a:touch/@mobileDisplayDensity"/>
                            <xsl:text>',desktopDisplayDensity:'</xsl:text>
                            <xsl:value-of select="a:project/a:features/a:touch/@desktopDisplayDensity"/>
                            <xsl:text>',mapApiIdentifier:'</xsl:text>
                            <xsl:value-of select="a:project/a:features/a:touch/@mapApiIdentifier"/>
                            <xsl:text>',labelsInList:'</xsl:text>
                            <xsl:value-of select="a:project/a:features/a:touch/@labelsInList"/>
                            <xsl:text>',labelsInForm:'</xsl:text>
                            <xsl:value-of select="a:project/a:features/a:touch/@labelsInForm"/>
                            <xsl:text>',initialListMode:'</xsl:text>
                            <xsl:value-of select="a:project/a:features/a:touch/@initialListMode"/>
                            <xsl:text>',buttonShapes:'</xsl:text>
                            <xsl:value-of select="a:project/a:features/a:touch/@buttonShapes"/>
                            <xsl:text>',sidebar:'</xsl:text>
                            <xsl:value-of select="a:project/a:features/a:touch/@sidebar"/>
                            <xsl:text>',promoteActions:'</xsl:text>
                            <xsl:value-of select="a:project/a:features/a:touch/@promoteActions"/>
                            <xsl:text>',transitions:'</xsl:text>
                            <xsl:value-of select="a:project/a:features/a:touch/@transitions"/>
                            <xsl:text>',theme:'</xsl:text>
                            <xsl:value-of select="a:project/a:theme/@name"/>
                            <xsl:if test="$IsUnlimited='true'">
                              <xsl:text>',ui:'</xsl:text>
                              <xsl:value-of select="a:project/@userInterface"/>
                            </xsl:if>
                            <xsl:text>'}};</xsl:text>
                          </xsl:attribute>
                          <!--<propertyReferenceExpression name="UtcOffsetInMinutes">
                            <typeReferenceExpression type="ControllerUtilities"/>
                          </propertyReferenceExpression>-->
                          <propertyReferenceExpression name="Name">
                            <propertyReferenceExpression name="Identity">
                              <propertyReferenceExpression name="User">
                                <propertyReferenceExpression name="Current">
                                  <typeReferenceExpression type="HttpContext"/>
                                </propertyReferenceExpression>
                              </propertyReferenceExpression>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                        </stringFormatExpression>
                        <primitiveExpression value="true"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <xsl:if test="$AspNet35AppServicesFix">
                  <conditionStatement>
                    <condition>
                      <unaryOperatorExpression operator="Not">
                        <methodInvokeExpression methodName="IsStartupScriptRegistered">
                          <target>
                            <propertyReferenceExpression name="ClientScript">
                              <propertyReferenceExpression name="p"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <typeofExpression type="AquariumExtenderBase"/>
                            <primitiveExpression value="ApplicatonServices35"/>
                          </parameters>
                        </methodInvokeExpression>
                      </unaryOperatorExpression>
                    </condition>
                    <trueStatements>
                      <methodInvokeExpression methodName="RegisterStartupScript">
                        <target>
                          <propertyReferenceExpression name="ClientScript">
                            <propertyReferenceExpression name="p"/>
                          </propertyReferenceExpression>
                        </target>
                        <parameters>
                          <typeofExpression type="AquariumExtenderBase"/>
                          <primitiveExpression value="ApplicatonServices35"/>
                          <stringFormatExpression format="Sys.Services._AuthenticationService.DefaultWebServicePath='{{0}}';Sys.Services.AuthenticationService._setAuthenticated({{1}});">
                            <methodInvokeExpression methodName="ResolveClientUrl">
                              <target>
                                <propertyReferenceExpression name="p"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="~/Authentication_JSON_AppService.axd"/>
                              </parameters>
                            </methodInvokeExpression>
                            <methodInvokeExpression methodName="ToLower">
                              <target>
                                <methodInvokeExpression methodName="ToString">
                                  <target>
                                    <propertyReferenceExpression name="IsAuthenticated">
                                      <propertyReferenceExpression name="Identity">
                                        <propertyReferenceExpression name="User">
                                          <propertyReferenceExpression name="p"/>
                                        </propertyReferenceExpression>
                                      </propertyReferenceExpression>
                                    </propertyReferenceExpression>
                                  </target>
                                </methodInvokeExpression>
                              </target>
                            </methodInvokeExpression>
                          </stringFormatExpression>
                          <!--<methodInvokeExpression methodName="Format">
                            <target>
                              <typeReferenceExpression type="String"/>
                            </target>
                            <parameters>
                              <primitiveExpression value="Sys.Services._AuthenticationService.DefaultWebServicePath='{{0}}';Sys.Services.AuthenticationService._setAuthenticated({{1}});"/>
                              <methodInvokeExpression methodName="ResolveClientUrl">
                                <target>
                                  <propertyReferenceExpression name="Page"/>
                                </target>
                                <parameters>
                                  <primitiveExpression value="~/Authentication_JSON_AppService.axd"/>
                                </parameters>
                              </methodInvokeExpression>
                              <methodInvokeExpression methodName="ToLower">
                                <target>
                                  <methodInvokeExpression methodName="ToString">
                                    <target>
                                      <propertyReferenceExpression name="IsAuthenticated">
                                        <propertyReferenceExpression name="Identity">
                                          <propertyReferenceExpression name="User">
                                            <propertyReferenceExpression name="Page"/>
                                          </propertyReferenceExpression>
                                        </propertyReferenceExpression>
                                      </propertyReferenceExpression>
                                    </target>
                                  </methodInvokeExpression>
                                </target>
                              </methodInvokeExpression>
                            </parameters>
                          </methodInvokeExpression>-->
                          <primitiveExpression value="true"/>
                        </parameters>
                      </methodInvokeExpression>
                    </trueStatements>
                  </conditionStatement>
                </xsl:if>
              </statements>
            </memberMethod>
            <!-- method ListOfStandardScripts(bool) -->
            <memberMethod returnType="List" name="StandardScripts">
              <typeArguments>
                <typeReference type="ScriptReference"/>
              </typeArguments>
              <attributes public="true" static="true"/>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="StandardScripts">
                    <parameters>
                      <primitiveExpression value="false"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method ListOfStandardScripts(bool) -->
            <memberMethod returnType="List" name="StandardScripts">
              <typeArguments>
                <typeReference type="ScriptReference"/>
              </typeArguments>
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.Boolean" name="ignoreCombinedScriptFlag"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="AquariumExtenderBase" name="extender">
                  <init>
                    <objectCreateExpression type="AquariumExtenderBase">
                      <parameters>
                        <primitiveExpression value="null"/>
                      </parameters>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <assignStatement>
                  <propertyReferenceExpression name="IgnoreCombinedScript">
                    <variableReferenceExpression name="extender"/>
                  </propertyReferenceExpression>
                  <argumentReferenceExpression name="ignoreCombinedScriptFlag"/>
                </assignStatement>
                <variableDeclarationStatement type="List" name="list">
                  <typeArguments>
                    <typeReference type="ScriptReference"/>
                  </typeArguments>
                  <init>
                    <objectCreateExpression type="List">
                      <typeArguments>
                        <typeReference type="ScriptReference"/>
                      </typeArguments>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <methodInvokeExpression methodName="AddRange">
                  <target>
                    <variableReferenceExpression name="list"/>
                  </target>
                  <parameters>
                    <methodInvokeExpression methodName="GetScriptReferences">
                      <target>
                        <variableReferenceExpression name="extender"/>
                      </target>
                    </methodInvokeExpression>
                  </parameters>
                </methodInvokeExpression>
                <methodReturnStatement>
                  <variableReferenceExpression name="list"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method OnPreRender (EventArgs)-->
            <memberMethod name="OnPreRender">
              <attributes override="true" family="true"/>
              <parameters>
                <parameter type="EventArgs" name="e"/>
              </parameters>
              <statements>
                <methodInvokeExpression methodName="OnPreRender">
                  <target>
                    <baseReferenceExpression/>
                  </target>
                  <parameters>
                    <argumentReferenceExpression name="e"/>
                  </parameters>
                </methodInvokeExpression>
                <xsl:if test="$IsClassLibrary='true'">
                  <xsl:if test="$ScriptOnly='true' or true()">
                    <foreachStatement>
                      <variable type="Control" name="c"/>
                      <target>
                        <propertyReferenceExpression name="Controls">
                          <propertyReferenceExpression name="Header">
                            <propertyReferenceExpression name="Page"/>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                      </target>
                      <statements>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="ValueEquality">
                              <propertyReferenceExpression name="ID">
                                <variableReferenceExpression name="c"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="{a:project/a:namespace}Theme"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <methodReturnStatement/>
                          </trueStatements>
                        </conditionStatement>
                      </statements>
                    </foreachStatement>
                  </xsl:if>
                  <variableDeclarationStatement type="HtmlLink" name="link">
                    <init>
                      <objectCreateExpression type="HtmlLink"/>
                    </init>
                  </variableDeclarationStatement>
                  <assignStatement>
                    <propertyReferenceExpression name="ID">
                      <variableReferenceExpression name="link"/>
                    </propertyReferenceExpression>
                    <primitiveExpression value="{a:project/a:namespace}Theme"/>
                  </assignStatement>
                  <assignStatement>
                    <propertyReferenceExpression name="Href">
                      <variableReferenceExpression name="link"/>
                    </propertyReferenceExpression>
                    <methodInvokeExpression methodName="GetWebResourceUrl">
                      <target>
                        <propertyReferenceExpression name="ClientScript">
                          <typeReferenceExpression type="Page"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <typeofExpression type="AquariumExtenderBase"/>
                        <primitiveExpression value="{a:project/a:namespace}{$ThemeFolder}.{a:project/a:theme/@name}.css"/>
                      </parameters>
                    </methodInvokeExpression>
                  </assignStatement>
                  <assignStatement>
                    <arrayIndexerExpression>
                      <target>
                        <propertyReferenceExpression name="Attributes">
                          <variableReferenceExpression name="link"/>
                        </propertyReferenceExpression>
                      </target>
                      <indices>
                        <primitiveExpression value="type"/>
                      </indices>
                    </arrayIndexerExpression>
                    <primitiveExpression value="text/css"/>
                  </assignStatement>
                  <assignStatement>
                    <arrayIndexerExpression>
                      <target>
                        <propertyReferenceExpression name="Attributes">
                          <variableReferenceExpression name="link"/>
                        </propertyReferenceExpression>
                      </target>
                      <indices>
                        <primitiveExpression value="rel"/>
                      </indices>
                    </arrayIndexerExpression>
                    <primitiveExpression value="stylesheet"/>
                  </assignStatement>
                  <methodInvokeExpression methodName="Add">
                    <target>
                      <propertyReferenceExpression name="Controls">
                        <propertyReferenceExpression name="Header">
                          <typeReferenceExpression type="Page"/>
                        </propertyReferenceExpression>
                      </propertyReferenceExpression>
                    </target>
                    <parameters>
                      <variableReferenceExpression name="link"/>
                    </parameters>
                  </methodInvokeExpression>
                </xsl:if>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
      </types>
    </compileUnit>
  </xsl:template>
</xsl:stylesheet>
