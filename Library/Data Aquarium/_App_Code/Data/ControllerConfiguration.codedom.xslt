<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.codeontime.com/2008/codedom-compiler"  xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"  xmlns:ontime="urn:schemas-codeontime-com:extensions"
    exclude-result-prefixes="msxsl a ontime"
>
  <xsl:output method="xml" indent="yes"/>

  <msxsl:script language="C#" implements-prefix="ontime">
    <![CDATA[
  public string NormalizeLineEndings(string s) {
    return s.Replace("\n", "\r\n");
  }
  ]]>
  </msxsl:script>

  <xsl:param name="IsPremium"/>

  <xsl:template match="/">
    <compileUnit namespace="{a:project/a:namespace}.Data">
      <imports>
        <namespaceImport name="System"/>
        <namespaceImport name="System.Collections.Generic"/>
        <namespaceImport name="System.ComponentModel"/>
        <namespaceImport name="System.Xml"/>
        <namespaceImport name="System.Xml.XPath"/>
        <namespaceImport name="System.IO"/>
        <namespaceImport name="System.Text"/>
        <namespaceImport name="System.Text.RegularExpressions"/>
        <namespaceImport name="System.Web"/>
        <namespaceImport name="System.Web.Caching"/>
      </imports>
      <types>
        <!-- class ControllerConfiguration -->
        <typeDeclaration name="ControllerConfiguration">
          <members>
            <memberField type="XPathNavigator" name="navigator"/>
            <memberField type="XmlNamespaceManager" name="namespaceManager"/>
            <memberField type="IXmlNamespaceResolver" name="resolver"/>
            <memberField type="System.String" name="actionHandlerType"/>
            <memberField type="System.String" name="dataFilterType"/>
            <memberField type="System.String" name="handlerType"/>

            <memberField type="Regex" name="VariableDetectionRegex">
              <attributes public="true" static="true"/>
              <init>
                <objectCreateExpression type="Regex">
                  <parameters>
                    <primitiveExpression>
                      <xsl:attribute name="value"><![CDATA[\$\w+\$]]></xsl:attribute>
                    </primitiveExpression>
                  </parameters>
                </objectCreateExpression>
              </init>
            </memberField>
            <memberField type="Regex" name="VariableReplacementRegex">
              <attributes public="true" static="true"/>
              <init>
                <objectCreateExpression type="Regex">
                  <parameters>
                    <primitiveExpression>
                      <xsl:attribute name="value"><![CDATA[\$(\w+)\$([\s\S]*?)\$(\w+)\$]]></xsl:attribute>
                    </primitiveExpression>
                  </parameters>
                </objectCreateExpression>
              </init>
            </memberField>
            <memberField type="Regex" name="LocalizationDetectionRegex">
              <attributes public="true" static="true"/>
              <init>
                <objectCreateExpression type="Regex">
                  <parameters>
                    <primitiveExpression>
                      <xsl:attribute name="value"><![CDATA[\^\w+\^]]></xsl:attribute>
                    </primitiveExpression>
                  </parameters>
                </objectCreateExpression>
              </init>
            </memberField>

            <memberField type="System.String" name="Namespace">
              <attributes const="true" public="true"/>
              <init>
                <primitiveExpression value="urn:schemas-codeontime-com:data-aquarium"/>
              </init>
            </memberField>

            <!-- property ConnectionStringName -->
            <memberField type="System.String" name="connectionStringName"/>
            <memberProperty type="System.String" name="ConnectionStringName">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="connectionStringName"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property ControllerName -->
            <memberField type="System.String" name="_controllerName"/>
            <memberProperty type="System.String" name="ControllerName">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="_controllerName"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property ConflictDetectionEnabled -->
            <memberField type="System.Boolean" name="ConflictDetectionEnabled"/>
            <memberProperty type="System.Boolean" name="ConflictDetectionEnabled">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="conflictDetectionEnabled"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property Resolver-->
            <memberProperty type="IXmlNamespaceResolver" name="Resolver">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="resolver"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- Navigator -->
            <memberProperty type="XPathNavigator" name="Navigator">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="navigator"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property DynamicExpression[] -->
            <memberField type="DynamicExpression[]" name="expressions"/>
            <memberProperty type="DynamicExpression[]" name="Expressions">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="expressions"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="expressions"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property PlugIn -->
            <memberField type="IPlugIn" name="plugIn"/>
            <memberProperty type="IPlugIn" name="PlugIn">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="plugIn"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property RawConfiguration -->
            <memberField type="System.String" name="rawConfiguration"/>
            <memberProperty type="System.String" name="RawConfiguration">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="rawConfiguration"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property UsesVariables -->
            <memberField type="System.Boolean" name="usesVariables"/>
            <memberProperty type="System.Boolean" name="UsesVariables">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="usesVariables"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property RequiresLocalization -->
            <memberField type="System.Boolean" name="_requiresLocalization"/>
            <memberProperty type="System.Boolean" name="RequiresLocalization">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="_requiresLocalization"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <xsl:if test="$IsPremium='true'">
              <!-- method RequiresVirtualization(string) -->
              <memberMethod returnType="System.Boolean" name="RequiresVirtualization">
                <attributes public="true" final="true"/>
                <parameters>
                  <parameter type="System.String" name="controllerName"/>
                </parameters>
                <statements>
                  <variableDeclarationStatement type="BusinessRules" name="rules">
                    <init>
                      <methodInvokeExpression methodName="CreateBusinessRules"/>
                    </init>
                  </variableDeclarationStatement>
                  <methodReturnStatement>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <binaryOperatorExpression operator="IdentityInequality">
                        <variableReferenceExpression name="rules"/>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                      <methodInvokeExpression methodName="SupportsVirtualization">
                        <target>
                          <variableReferenceExpression name="rules"/>
                        </target>
                        <parameters>
                          <argumentReferenceExpression name="controllerName"/>
                        </parameters>
                      </methodInvokeExpression>
                    </binaryOperatorExpression>
                  </methodReturnStatement>
                </statements>
              </memberMethod>
              <!-- method Virtualize(string)  -->
              <memberMethod returnType="ControllerConfiguration" name="Virtualize">
                <attributes public="true" final="true"/>
                <parameters>
                  <parameter type="System.String" name="controllerName"/>
                </parameters>
                <statements>
                  <variableDeclarationStatement type="ControllerConfiguration" name="config">
                    <init>
                      <thisReferenceExpression/>
                    </init>
                  </variableDeclarationStatement>
                  <conditionStatement>
                    <condition>
                      <unaryOperatorExpression operator="Not">
                        <propertyReferenceExpression name="CanEdit">
                          <fieldReferenceExpression name="navigator"/>
                        </propertyReferenceExpression>
                      </unaryOperatorExpression>
                    </condition>
                    <trueStatements>
                      <variableDeclarationStatement type="XmlDocument" name="doc">
                        <init>
                          <objectCreateExpression type="XmlDocument"/>
                        </init>
                      </variableDeclarationStatement>
                      <methodInvokeExpression methodName="LoadXml">
                        <target>
                          <variableReferenceExpression name="doc"/>
                        </target>
                        <parameters>
                          <propertyReferenceExpression name="OuterXml">
                            <fieldReferenceExpression name="navigator"/>
                          </propertyReferenceExpression>
                        </parameters>
                      </methodInvokeExpression>
                      <assignStatement>
                        <variableReferenceExpression name="config"/>
                        <objectCreateExpression type="ControllerConfiguration">
                          <parameters>
                            <methodInvokeExpression methodName="CreateNavigator">
                              <target>
                                <variableReferenceExpression name="doc"/>
                              </target>
                            </methodInvokeExpression>
                          </parameters>
                        </objectCreateExpression>
                      </assignStatement>
                    </trueStatements>
                  </conditionStatement>
                  <variableDeclarationStatement type="BusinessRules" name="rules">
                    <init>
                      <methodInvokeExpression methodName="CreateBusinessRules"/>
                    </init>
                  </variableDeclarationStatement>
                  <conditionStatement>
                    <condition>
                      <binaryOperatorExpression operator="IdentityInequality">
                        <variableReferenceExpression name="rules"/>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                    </condition>
                    <trueStatements>
                      <methodInvokeExpression methodName="VirtualizeController">
                        <target>
                          <variableReferenceExpression name="rules"/>
                        </target>
                        <parameters>
                          <argumentReferenceExpression name="controllerName"/>
                          <fieldReferenceExpression name="_navigator">
                            <variableReferenceExpression name="config"/>
                          </fieldReferenceExpression>
                          <fieldReferenceExpression name="namespaceManager">
                            <variableReferenceExpression name="config"/>
                          </fieldReferenceExpression>
                        </parameters>
                      </methodInvokeExpression>
                    </trueStatements>
                  </conditionStatement>
                  <methodReturnStatement>
                    <variableReferenceExpression name="config"/>
                  </methodReturnStatement>
                </statements>
              </memberMethod>
            </xsl:if>
            <!-- constructor ControllerConfiguration(string)-->
            <constructor>
              <attributes public="true"/>
              <parameters>
                <parameter type="System.String" name="path"/>
              </parameters>
              <chainedConstructorArgs>
                <methodInvokeExpression methodName="OpenRead">
                  <target>
                    <typeReferenceExpression type="File"/>
                  </target>
                  <parameters>
                    <variableReferenceExpression name="path"/>
                  </parameters>
                </methodInvokeExpression>
              </chainedConstructorArgs>
            </constructor>
            <!-- constructor ControllerConfiguration(Stream) -->
            <constructor>
              <attributes public="true"/>
              <parameters>
                <parameter type="Stream" name="stream"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="StreamReader" name="sr">
                  <init>
                    <objectCreateExpression type="StreamReader">
                      <parameters>
                        <argumentReferenceExpression name="stream"/>
                      </parameters>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <assignStatement>
                  <fieldReferenceExpression name="rawConfiguration">
                    <thisReferenceExpression/>
                  </fieldReferenceExpression>
                  <methodInvokeExpression methodName="ReadToEnd">
                    <target>
                      <variableReferenceExpression name="sr"/>
                    </target>
                  </methodInvokeExpression>
                </assignStatement>
                <methodInvokeExpression methodName="Close">
                  <target>
                    <variableReferenceExpression name="sr"/>
                  </target>
                </methodInvokeExpression>
                <assignStatement>
                  <fieldReferenceExpression name="usesVariables">
                    <thisReferenceExpression/>
                  </fieldReferenceExpression>
                  <methodInvokeExpression methodName="IsMatch">
                    <target>
                      <propertyReferenceExpression name="VariableDetectionRegex"/>
                    </target>
                    <parameters>
                      <fieldReferenceExpression name="rawConfiguration">
                        <thisReferenceExpression/>
                      </fieldReferenceExpression>
                    </parameters>
                  </methodInvokeExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="requiresLocalization">
                    <thisReferenceExpression/>
                  </fieldReferenceExpression>
                  <methodInvokeExpression methodName="IsMatch">
                    <target>
                      <propertyReferenceExpression name="LocalizationDetectionRegex"/>
                    </target>
                    <parameters>
                      <fieldReferenceExpression name="rawConfiguration">
                        <thisReferenceExpression/>
                      </fieldReferenceExpression>
                    </parameters>
                  </methodInvokeExpression>
                </assignStatement>
                <methodInvokeExpression methodName="Initialize">
                  <parameters>
                    <methodInvokeExpression methodName="CreateNavigator">
                      <target>
                        <objectCreateExpression type="XPathDocument">
                          <parameters>
                            <objectCreateExpression type="StringReader">
                              <parameters>
                                <fieldReferenceExpression name="rawConfiguration">
                                  <thisReferenceExpression/>
                                </fieldReferenceExpression>
                              </parameters>
                            </objectCreateExpression>
                          </parameters>
                        </objectCreateExpression>
                      </target>
                    </methodInvokeExpression>
                  </parameters>
                </methodInvokeExpression>
              </statements>
            </constructor>
            <!-- constructor ControllerConfiguration(XPathDocument)-->
            <constructor>
              <attributes public="true"/>
              <parameters>
                <parameter type="XPathDocument" name="document"/>
              </parameters>
              <chainedConstructorArgs>
                <methodInvokeExpression methodName="CreateNavigator">
                  <target>
                    <argumentReferenceExpression name="document"/>
                  </target>
                </methodInvokeExpression>
              </chainedConstructorArgs>
            </constructor>
            <!-- constructor ControllerConfiguration(XPathNavigator)-->
            <constructor>
              <attributes public="true"/>
              <parameters>
                <parameter type="XPathNavigator" name="navigator"/>
              </parameters>
              <statements>
                <methodInvokeExpression methodName="Initialize">
                  <parameters>
                    <argumentReferenceExpression name="navigator"/>
                  </parameters>
                </methodInvokeExpression>
              </statements>
            </constructor>
            <!-- method Initialize(XPathNavigator) -->
            <memberMethod name="Initialize">
              <attributes family="true"/>
              <parameters>
                <parameter type="XPathNavigator" name="navigator"/>
              </parameters>
              <statements>
                <assignStatement>
                  <fieldReferenceExpression name="navigator"/>
                  <argumentReferenceExpression name="navigator"/>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="namespaceManager"/>
                  <objectCreateExpression type="XmlNamespaceManager">
                    <parameters>
                      <propertyReferenceExpression name="NameTable">
                        <fieldReferenceExpression name="navigator"/>
                      </propertyReferenceExpression>
                    </parameters>
                  </objectCreateExpression>
                </assignStatement>
                <methodInvokeExpression methodName="AddNamespace">
                  <target>
                    <fieldReferenceExpression name="namespaceManager"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="c"/>
                    <propertyReferenceExpression name="Namespace">
                      <typeReferenceExpression type="ControllerConfiguration"/>
                    </propertyReferenceExpression>
                  </parameters>
                </methodInvokeExpression>
                <assignStatement>
                  <fieldReferenceExpression name="resolver"/>
                  <castExpression targetType="IXmlNamespaceResolver">
                    <fieldReferenceExpression name="namespaceManager"/>
                  </castExpression>
                </assignStatement>
                <methodInvokeExpression methodName="ResolveBaseViews"/>
                <assignStatement>
                  <fieldReferenceExpression name="controllerName"/>
                  <castExpression targetType="System.String">
                    <methodInvokeExpression methodName="Evaluate">
                      <parameters>
                        <primitiveExpression value="string(/c:dataController/@name)"/>
                      </parameters>
                    </methodInvokeExpression>
                  </castExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="handlerType"/>
                  <castExpression targetType="System.String">
                    <methodInvokeExpression methodName="Evaluate">
                      <parameters>
                        <primitiveExpression value="string(/c:dataController/@handler)"/>
                      </parameters>
                    </methodInvokeExpression>
                  </castExpression>
                </assignStatement>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="IsNullOrEmpty">
                      <target>
                        <typeReferenceExpression type="String"/>
                      </target>
                      <parameters>
                        <fieldReferenceExpression name="handlerType"/>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="Type" name="t">
                      <init>
                        <methodInvokeExpression methodName="GetType">
                          <target>
                            <typeReferenceExpression type="Type"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="{a:project/a:namespace}.Rules.SharedBusinessRules"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityInequality">
                          <variableReferenceExpression name="t"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <fieldReferenceExpression name="handlerType"/>
                          <propertyReferenceExpression name="FullName">
                            <variableReferenceExpression name="t"/>
                          </propertyReferenceExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                  </trueStatements>
                </conditionStatement>
                <assignStatement>
                  <fieldReferenceExpression name="actionHandlerType"/>
                  <fieldReferenceExpression name="handlerType"/>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="dataFilterType"/>
                  <fieldReferenceExpression name="handlerType"/>
                </assignStatement>
                <variableDeclarationStatement type="System.String" name="s">
                  <init>
                    <castExpression targetType="System.String">
                      <methodInvokeExpression methodName="Evaluate">
                        <parameters>
                          <primitiveExpression value="string(/c:dataController/@actionHandlerType)"/>
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
                          <variableReferenceExpression name="s"/>
                        </parameters>
                      </methodInvokeExpression>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <fieldReferenceExpression name="actionHandlerType"/>
                      <variableReferenceExpression name="s"/>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <assignStatement>
                  <variableReferenceExpression name="s"/>
                  <castExpression targetType="System.String">
                    <methodInvokeExpression methodName="Evaluate">
                      <parameters>
                        <primitiveExpression value="string(/c:dataController/@dataFilterType)"/>
                      </parameters>
                    </methodInvokeExpression>
                  </castExpression>
                </assignStatement>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="Not">
                      <methodInvokeExpression methodName="IsNullOrEmpty">
                        <target>
                          <typeReferenceExpression type="String"/>
                        </target>
                        <parameters>
                          <variableReferenceExpression name="s"/>
                        </parameters>
                      </methodInvokeExpression>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <fieldReferenceExpression name="dataFilterType"/>
                      <variableReferenceExpression name="s"/>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="System.String" name="plugInType">
                  <init>
                    <castExpression targetType="System.String">
                      <methodInvokeExpression methodName="Evaluate">
                        <parameters>
                          <primitiveExpression value="string(/c:dataController/@plugIn)"/>
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
                          <variableReferenceExpression name="plugInType"/>
                        </parameters>
                      </methodInvokeExpression>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="Type" name="t">
                      <init>
                        <methodInvokeExpression methodName="GetType">
                          <target>
                            <typeReferenceExpression type="Type"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="plugInType"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <assignStatement>
                      <fieldReferenceExpression name="plugIn"/>
                      <castExpression targetType="IPlugIn">
                        <methodInvokeExpression methodName="CreateInstance">
                          <target>
                            <propertyReferenceExpression name="Assembly">
                              <variableReferenceExpression name="t"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="FullName">
                              <variableReferenceExpression name="t"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </castExpression>
                    </assignStatement>
                    <assignStatement>
                      <propertyReferenceExpression name="Config">
                        <fieldReferenceExpression name="plugIn"/>
                      </propertyReferenceExpression>
                      <thisReferenceExpression/>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method Complete() -->
            <memberMethod name="Complete">
              <attributes public="true"/>
              <statements>
                <assignStatement>
                  <fieldReferenceExpression name="connectionStringName"/>
                  <castExpression targetType="System.String">
                    <methodInvokeExpression methodName="Evaluate">
                      <parameters>
                        <primitiveExpression value="string(/c:dataController/@connectionStringName)"/>
                      </parameters>
                    </methodInvokeExpression>
                  </castExpression>
                </assignStatement>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="IsNullOrEmpty">
                      <target>
                        <typeReferenceExpression type="String"/>
                      </target>
                      <parameters>
                        <fieldReferenceExpression name="connectionStringName"/>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <fieldReferenceExpression name="connectionStringName"/>
                      <!--<primitiveExpression value="{/a:project/a:namespace}"/>-->
                      <primitiveExpression>
                        <xsl:attribute name="value">
                          <xsl:choose>
                            <xsl:when test="/a:project/a:connectionString/@hostDatabaseSharing='true'">
                              <xsl:text>SiteSqlServer</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:value-of select="/a:project/a:namespace"/>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:attribute>
                      </primitiveExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <assignStatement>
                  <fieldReferenceExpression name="conflictDetectionEnabled"/>
                  <castExpression targetType="System.Boolean">
                    <methodInvokeExpression methodName="Evaluate">
                      <parameters>
                        <primitiveExpression value="/c:dataController/@conflictDetection='compareAllValues'"/>
                      </parameters>
                    </methodInvokeExpression>
                  </castExpression>
                </assignStatement>
                <variableDeclarationStatement type="List" name="expressions">
                  <typeArguments>
                    <typeReference type="DynamicExpression"/>
                  </typeArguments>
                  <init>
                    <objectCreateExpression type="List">
                      <typeArguments >
                        <typeReference type="DynamicExpression"/>
                      </typeArguments>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="XPathNodeIterator" name="expressionIterator">
                  <init>
                    <methodInvokeExpression methodName="Select">
                      <parameters>
                        <primitiveExpression value="//c:expression[@test!='' or @result!='']"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <whileStatement>
                  <test>
                    <methodInvokeExpression methodName="MoveNext">
                      <target>
                        <variableReferenceExpression name="expressionIterator"/>
                      </target>
                    </methodInvokeExpression>
                  </test>
                  <statements>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <variableReferenceExpression name="expressions"/>
                      </target>
                      <parameters>
                        <objectCreateExpression type="DynamicExpression">
                          <parameters>
                            <propertyReferenceExpression name="Current">
                              <variableReferenceExpression name="expressionIterator"/>
                            </propertyReferenceExpression>
                            <fieldReferenceExpression name="namespaceManager"/>
                          </parameters>
                        </objectCreateExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </statements>
                </whileStatement>
                <variableDeclarationStatement type="XPathNodeIterator" name="ruleIterator">
                  <init>
                    <methodInvokeExpression methodName="Select">
                      <parameters>
                        <primitiveExpression value="/c:dataController/c:businessRules/c:rule[@type='JavaScript']"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <whileStatement>
                  <test>
                    <methodInvokeExpression methodName="MoveNext">
                      <target>
                        <variableReferenceExpression name="ruleIterator"/>
                      </target>
                    </methodInvokeExpression>
                  </test>
                  <statements>
                    <variableDeclarationStatement type="DynamicExpression" name="rule">
                      <init>
                        <objectCreateExpression type="DynamicExpression"/>
                      </init>
                    </variableDeclarationStatement>
                    <assignStatement>
                      <propertyReferenceExpression name="Type">
                        <variableReferenceExpression name="rule"/>
                      </propertyReferenceExpression>
                      <propertyReferenceExpression name="ClientScript">
                        <typeReferenceExpression type="DynamicExpressionType"/>
                      </propertyReferenceExpression>
                    </assignStatement>
                    <assignStatement>
                      <propertyReferenceExpression name="Scope">
                        <variableReferenceExpression name="rule"/>
                      </propertyReferenceExpression>
                      <propertyReferenceExpression name="Rule">
                        <typeReferenceExpression type="DynamicExpressionScope"/>
                      </propertyReferenceExpression>
                    </assignStatement>
                    <variableDeclarationStatement type="XPathNavigator" name="ruleNav">
                      <init>
                        <propertyReferenceExpression name="Current">
                          <variableReferenceExpression name="ruleIterator"/>
                        </propertyReferenceExpression>
                      </init>
                    </variableDeclarationStatement>
                    <assignStatement>
                      <propertyReferenceExpression name="Result">
                        <variableReferenceExpression name="rule"/>
                      </propertyReferenceExpression>
                      <stringFormatExpression>
                        <xsl:attribute name="format"><![CDATA[<id>{0}</id><commandName>{1}</commandName><commandArgument>{2}</commandArgument><view>{3}</view><phase>{4}</phase><script>{5}</script>]]></xsl:attribute>
                        <methodInvokeExpression methodName="GetAttribute">
                          <target>
                            <variableReferenceExpression name="ruleNav"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="id"/>
                            <propertyReferenceExpression name="Empty">
                              <typeReferenceExpression type="String"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                        <methodInvokeExpression methodName="GetAttribute">
                          <target>
                            <variableReferenceExpression name="ruleNav"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="commandName"/>
                            <propertyReferenceExpression name="Empty">
                              <typeReferenceExpression type="String"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                        <methodInvokeExpression methodName="GetAttribute">
                          <target>
                            <variableReferenceExpression name="ruleNav"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="commandArgument"/>
                            <propertyReferenceExpression name="Empty">
                              <typeReferenceExpression type="String"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                        <methodInvokeExpression methodName="GetAttribute">
                          <target>
                            <variableReferenceExpression name="ruleNav"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="view"/>
                            <propertyReferenceExpression name="Empty">
                              <typeReferenceExpression type="String"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                        <methodInvokeExpression methodName="GetAttribute">
                          <target>
                            <variableReferenceExpression name="ruleNav"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="phase"/>
                            <propertyReferenceExpression name="Empty">
                              <typeReferenceExpression type="String"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                        <propertyReferenceExpression name="Value">
                          <variableReferenceExpression name="ruleNav"/>
                        </propertyReferenceExpression>
                      </stringFormatExpression>
                    </assignStatement>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <variableReferenceExpression name="expressions"/>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="rule"/>
                      </parameters>
                    </methodInvokeExpression>
                  </statements>
                </whileStatement>
                <assignStatement>
                  <fieldReferenceExpression name="expressions"/>
                  <methodInvokeExpression methodName="ToArray">
                    <target>
                      <variableReferenceExpression name="expressions"/>
                    </target>
                  </methodInvokeExpression>
                </assignStatement>
              </statements>
            </memberMethod>
            <!-- method EnsureChildNode(XPathNavigator, string) -->
            <memberMethod name="EnsureChildNode">
              <attributes private="true"/>
              <parameters>
                <parameter type="XPathNavigator" name="parent"/>
                <parameter type="System.String" name="nodeName"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="XPathNavigator" name="child">
                  <init>
                    <methodInvokeExpression methodName="SelectSingleNode">
                      <target>
                        <argumentReferenceExpression name="parent"/>
                      </target>
                      <parameters>
                        <stringFormatExpression format="c:{{0}}">
                          <argumentReferenceExpression name="nodeName"/>
                        </stringFormatExpression>
                        <fieldReferenceExpression name="resolver"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <variableReferenceExpression name="child"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="AppendChild">
                      <target>
                        <argumentReferenceExpression name="parent"/>
                      </target>
                      <parameters>
                        <stringFormatExpression format="&lt;{{0}}/>">
                          <argumentReferenceExpression name="nodeName"/>
                        </stringFormatExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method EnsureVitalElements() -->
            <memberMethod returnType="ControllerConfiguration" name="EnsureVitalElements">
              <attributes public="true"/>
              <statements>
                <comment>verify that the data controller has views and actions</comment>
                <variableDeclarationStatement type="XPathNavigator" name="root">
                  <init>
                    <methodInvokeExpression methodName="SelectSingleNode">
                      <parameters>
                        <primitiveExpression value="/c:dataController[c:views/c:view and c:actions/c:actionGroup]"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <variableReferenceExpression name="root"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <thisReferenceExpression/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <comment>add missing configuration elements</comment>
                <variableDeclarationStatement type="XmlDocument" name="doc">
                  <init>
                    <objectCreateExpression type="XmlDocument"/>
                  </init>
                </variableDeclarationStatement>
                <methodInvokeExpression methodName="LoadXml">
                  <target>
                    <variableReferenceExpression name="doc"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="OuterXml">
                      <fieldReferenceExpression name="navigator"/>
                    </propertyReferenceExpression>
                  </parameters>
                </methodInvokeExpression>
                <variableDeclarationStatement type="ControllerConfiguration" name="config">
                  <init>
                    <objectCreateExpression type="ControllerConfiguration">
                      <parameters>
                        <methodInvokeExpression methodName="CreateNavigator">
                          <target>
                            <variableReferenceExpression name="doc"/>
                          </target>
                        </methodInvokeExpression>
                      </parameters>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="XPathNavigator" name="fieldsNode">
                  <init>
                    <methodInvokeExpression methodName="SelectSingleNode">
                      <target>
                        <variableReferenceExpression name="config"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="/c:dataController/c:fields[not(c:field[@isPrimaryKey='true'])]"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <variableReferenceExpression name="fieldsNode"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="AppendChild">
                      <target>
                        <variableReferenceExpression name="fieldsNode"/>
                      </target>
                      <parameters>
                        <primitiveExpression>
                          <xsl:attribute name="value"><![CDATA[<field name="PrimaryKey" type="Int32" isPrimaryKey="true" readOnly="true"/>]]></xsl:attribute>
                        </primitiveExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <assignStatement>
                  <variableReferenceExpression name="root"/>
                  <methodInvokeExpression methodName="SelectSingleNode">
                    <target>
                      <variableReferenceExpression name="config"/>
                    </target>
                    <parameters>
                      <primitiveExpression value="/c:dataController"/>
                    </parameters>
                  </methodInvokeExpression>
                </assignStatement>
                <methodInvokeExpression methodName="EnsureChildNode">
                  <parameters>
                    <variableReferenceExpression name="root"/>
                    <primitiveExpression value="views"/>
                  </parameters>
                </methodInvokeExpression>
                <variableDeclarationStatement type="XPathNavigator" name="viewsNode">
                  <init>
                    <methodInvokeExpression methodName="SelectSingleNode">
                      <target>
                        <variableReferenceExpression name="config"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="/c:dataController/c:views[not(c:view)]"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <variableReferenceExpression name="viewsNode"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="StringBuilder" name="sb">
                      <init>
                        <objectCreateExpression type="StringBuilder">
                          <parameters>
                            <primitiveExpression>
                              <xsl:attribute name="value"><![CDATA[<view id="view1" type="Form" label="Form"><categories><category id="c1" newColumn="true"><dataFields>]]></xsl:attribute>
                            </primitiveExpression>
                          </parameters>
                        </objectCreateExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="XPathNodeIterator" name="fieldIterator">
                      <init>
                        <methodInvokeExpression methodName="Select">
                          <target>
                            <variableReferenceExpression name="config"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="/c:dataController/c:fields/c:field"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <whileStatement>
                      <test>
                        <methodInvokeExpression methodName="MoveNext">
                          <target>
                            <variableReferenceExpression name="fieldIterator"/>
                          </target>
                        </methodInvokeExpression>
                      </test>
                      <statements>
                        <variableDeclarationStatement type="System.String" name="fieldName">
                          <init>
                            <methodInvokeExpression methodName="GetAttribute">
                              <target>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="fieldIterator"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="name"/>
                                <propertyReferenceExpression name="Empty">
                                  <typeReferenceExpression type="String"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <variableDeclarationStatement type="System.Boolean" name="hidden">
                          <init>
                            <binaryOperatorExpression operator="ValueEquality">
                              <variableReferenceExpression name="fieldName"/>
                              <primitiveExpression value="PrimaryKey"/>
                            </binaryOperatorExpression>
                          </init>
                        </variableDeclarationStatement>
                        <variableDeclarationStatement type="System.String" name="length">
                          <init>
                            <methodInvokeExpression methodName="GetAttribute">
                              <target>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="fieldIterator"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="length"/>
                                <propertyReferenceExpression name="Empty">
                                  <typeReferenceExpression type="String"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="BooleanAnd">
                              <unaryOperatorExpression operator="IsNullOrEmpty">
                                <variableReferenceExpression name="length"/>
                              </unaryOperatorExpression>
                              <binaryOperatorExpression operator="ValueEquality">
                                <castExpression targetType="System.Boolean">
                                  <methodInvokeExpression methodName="Evaluate">
                                    <target>
                                      <propertyReferenceExpression name="Current">
                                        <variableReferenceExpression name="fieldIterator"/>
                                      </propertyReferenceExpression>
                                    </target>
                                    <parameters>
                                      <primitiveExpression value="not(c:items/@style!='')"/>
                                      <fieldReferenceExpression name="resolver"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                </castExpression>
                                <primitiveExpression value="true"/>
                              </binaryOperatorExpression>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="ValueEquality">
                                  <methodInvokeExpression methodName="GetAttribute">
                                    <target>
                                      <propertyReferenceExpression name="Current">
                                        <variableReferenceExpression name="fieldIterator"/>
                                      </propertyReferenceExpression>
                                    </target>
                                    <parameters>
                                      <primitiveExpression value="type"/>
                                      <propertyReferenceExpression name="Empty">
                                        <typeReferenceExpression type="String"/>
                                      </propertyReferenceExpression>
                                    </parameters>
                                  </methodInvokeExpression>
                                  <primitiveExpression value="String"/>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="length"/>
                                  <primitiveExpression value="50" convertTo="String"/>
                                </assignStatement>
                              </trueStatements>
                              <falseStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="length"/>
                                  <primitiveExpression value="20" convertTo="String"/>
                                </assignStatement>
                              </falseStatements>
                            </conditionStatement>
                          </trueStatements>
                        </conditionStatement>
                        <methodInvokeExpression methodName="AppendFormat">
                          <target>
                            <variableReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <primitiveExpression>
                              <xsl:attribute name="value"><![CDATA[<dataField fieldName="{0}" hidden="{1}"]]></xsl:attribute>
                            </primitiveExpression>
                            <variableReferenceExpression name="fieldName"/>
                            <methodInvokeExpression methodName="ToLower">
                              <target>
                                <methodInvokeExpression methodName="ToString">
                                  <target>
                                    <variableReferenceExpression name="hidden"/>
                                  </target>
                                </methodInvokeExpression>
                              </target>
                            </methodInvokeExpression>
                          </parameters>
                        </methodInvokeExpression>
                        <conditionStatement>
                          <condition>
                            <unaryOperatorExpression operator="IsNotNullOrEmpty">
                              <variableReferenceExpression name="length"/>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="AppendFormat">
                              <target>
                                <variableReferenceExpression name="sb"/>
                              </target>
                              <parameters>
                                <primitiveExpression>
                                  <xsl:attribute name="value"><![CDATA[ columns="{0}"]]></xsl:attribute>
                                </primitiveExpression>
                                <variableReferenceExpression name="length"/>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>
                        <methodInvokeExpression methodName="Append">
                          <target>
                            <variableReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <primitiveExpression value=" />"/>
                          </parameters>
                        </methodInvokeExpression>
                      </statements>
                    </whileStatement>
                    <methodInvokeExpression methodName="Append">
                      <target>
                        <variableReferenceExpression name="sb"/>
                      </target>
                      <parameters>
                        <primitiveExpression>
                          <xsl:attribute name="value"><![CDATA[</dataFields></category></categories></view>]]></xsl:attribute>
                        </primitiveExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="AppendChild">
                      <target>
                        <variableReferenceExpression name="viewsNode"/>
                      </target>
                      <parameters>
                        <methodInvokeExpression methodName="ToString">
                          <target>
                            <variableReferenceExpression name="sb"/>
                          </target>
                        </methodInvokeExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <methodInvokeExpression methodName="EnsureChildNode">
                  <parameters>
                    <variableReferenceExpression name="root"/>
                    <primitiveExpression value="actions"/>
                  </parameters>
                </methodInvokeExpression>
                <variableDeclarationStatement type="XPathNavigator" name="actionsNode">
                  <init>
                    <methodInvokeExpression methodName="SelectSingleNode">
                      <target>
                        <variableReferenceExpression name="config"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="/c:dataController/c:actions[not(c:actionGroup)]"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <variableReferenceExpression name="actionsNode"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="AppendChild">
                      <target>
                        <variableReferenceExpression name="actionsNode"/>
                      </target>
                      <parameters>
                        <xsl:variable name="Xml" xml:space="preserve">
                          <![CDATA[<actionGroup id="ag1" scope="Form">
<action id="a1" commandName="Confirm" causesValidation="true" whenLastCommandName="New" />
<action id="a2" commandName="Cancel" whenLastCommandName="New" />
<action id="a3" commandName="Confirm" causesValidation="true" whenLastCommandName="Edit" />
<action id="a4" commandName="Cancel" whenLastCommandName="Edit" />
<action id="a5" commandName="Edit" causesValidation="true" />
</actionGroup>]]></xsl:variable>
                        <primitiveExpression value="{ontime:NormalizeLineEndings($Xml)}"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="XPathNavigator" name="plugIn">
                  <init>
                    <methodInvokeExpression methodName="SelectSingleNode">
                      <target>
                        <variableReferenceExpression name="config"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="/c:dataController/@plugIn"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <variableReferenceExpression name="plugIn"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="DeleteSelf">
                      <target>
                        <variableReferenceExpression name="plugIn"/>
                      </target>
                    </methodInvokeExpression>
                    <assignStatement>
                      <fieldReferenceExpression name="plugIn">
                        <variableReferenceExpression name="config"/>
                      </fieldReferenceExpression>
                      <primitiveExpression value="null"/>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <variableReferenceExpression name="config"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method ResolveBaseViews() -->
            <memberMethod name="ResolveBaseViews">
              <attributes family="true"/>
              <statements>
                <variableDeclarationStatement type="XPathNavigator" name="firstUnresolvedView">
                  <init>
                    <methodInvokeExpression methodName="SelectSingleNode">
                      <parameters>
                        <primitiveExpression value="/c:dataController/c:views/c:view[@baseViewId!='' and not (.//c:dataField)]"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <variableReferenceExpression name="firstUnresolvedView"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="XmlDocument" name="document">
                      <init>
                        <objectCreateExpression type="XmlDocument"/>
                      </init>
                    </variableDeclarationStatement>
                    <methodInvokeExpression methodName="LoadXml">
                      <target>
                        <variableReferenceExpression name="document"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="OuterXml">
                          <fieldReferenceExpression name="navigator"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <assignStatement>
                      <fieldReferenceExpression name="navigator"/>
                      <methodInvokeExpression methodName="CreateNavigator">
                        <target>
                          <variableReferenceExpression name="document"/>
                        </target>
                      </methodInvokeExpression>
                    </assignStatement>
                    <variableDeclarationStatement type="XPathNodeIterator" name="unresolvedViewIterator">
                      <init>
                        <methodInvokeExpression methodName="Select">
                          <parameters>
                            <primitiveExpression value="/c:dataController/c:views/c:view[@baseViewId!='']"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <whileStatement>
                      <test>
                        <methodInvokeExpression methodName="MoveNext">
                          <target>
                            <variableReferenceExpression name="unresolvedViewIterator"/>
                          </target>
                        </methodInvokeExpression>
                      </test>
                      <statements>
                        <variableDeclarationStatement type="System.String" name="baseViewId">
                          <init>
                            <methodInvokeExpression methodName="GetAttribute">
                              <target>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="unresolvedViewIterator"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="baseViewId"/>
                                <propertyReferenceExpression name="Empty">
                                  <typeReferenceExpression type="String"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <methodInvokeExpression methodName="DeleteSelf">
                          <target>
                            <methodInvokeExpression methodName="SelectSingleNode">
                              <target>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="unresolvedViewIterator"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="@baseViewId"/>
                              </parameters>
                            </methodInvokeExpression>
                          </target>
                        </methodInvokeExpression>
                        <variableDeclarationStatement type="XPathNavigator" name="baseView">
                          <init>
                            <methodInvokeExpression methodName="SelectSingleNode">
                              <parameters>
                                <methodInvokeExpression methodName="Format">
                                  <target>
                                    <typeReferenceExpression type="String"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression>
                                      <xsl:attribute name="value"><![CDATA[/c:dataController/c:views/c:view[@id='{0}']]]></xsl:attribute>
                                    </primitiveExpression>
                                    <variableReferenceExpression name="baseViewId"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="IdentityInequality">
                              <variableReferenceExpression name="baseView"/>
                              <primitiveExpression value="null"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <variableDeclarationStatement type="List" name="nodesToDelete">
                              <typeArguments>
                                <typeReference type="XPathNavigator"/>
                              </typeArguments>
                              <init>
                                <objectCreateExpression type="List">
                                  <typeArguments>
                                    <typeReference type="XPathNavigator"/>
                                  </typeArguments>
                                </objectCreateExpression>
                              </init>
                            </variableDeclarationStatement>
                            <variableDeclarationStatement type="XPathNodeIterator" name="emptyNodeIterator">
                              <init>
                                <methodInvokeExpression methodName="Select">
                                  <target>
                                    <propertyReferenceExpression name="Current">
                                      <variableReferenceExpression name="unresolvedViewIterator"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="c:*[not(child::*) and .='']"/>
                                    <fieldReferenceExpression name="resolver"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </init>
                            </variableDeclarationStatement>
                            <whileStatement>
                              <test>
                                <methodInvokeExpression methodName="MoveNext">
                                  <target>
                                    <variableReferenceExpression name="emptyNodeIterator"/>
                                  </target>
                                </methodInvokeExpression>
                              </test>
                              <statements>
                                <methodInvokeExpression methodName="Add">
                                  <target>
                                    <variableReferenceExpression name="nodesToDelete"/>
                                  </target>
                                  <parameters>
                                    <methodInvokeExpression methodName="Clone">
                                      <target>
                                        <propertyReferenceExpression name="Current">
                                          <variableReferenceExpression name="emptyNodeIterator"/>
                                        </propertyReferenceExpression>
                                      </target>
                                    </methodInvokeExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </statements>
                            </whileStatement>
                            <foreachStatement>
                              <variable type="XPathNavigator" name="n"/>
                              <target>
                                <variableReferenceExpression name="nodesToDelete"/>
                              </target>
                              <statements>
                                <methodInvokeExpression methodName="DeleteSelf">
                                  <target>
                                    <variableReferenceExpression name="n"/>
                                  </target>
                                </methodInvokeExpression>
                              </statements>
                            </foreachStatement>
                            <variableDeclarationStatement type="XPathNodeIterator" name="copyNodeIterator">
                              <init>
                                <methodInvokeExpression methodName="Select">
                                  <target>
                                    <variableReferenceExpression name="baseView"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="c:*"/>
                                    <fieldReferenceExpression name="resolver"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </init>
                            </variableDeclarationStatement>
                            <whileStatement>
                              <test>
                                <methodInvokeExpression methodName="MoveNext">
                                  <target>
                                    <variableReferenceExpression name="copyNodeIterator"/>
                                  </target>
                                </methodInvokeExpression>
                              </test>
                              <statements>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="IdentityEquality">
                                      <methodInvokeExpression methodName="SelectSingleNode">
                                        <target>
                                          <propertyReferenceExpression name="Current">
                                            <variableReferenceExpression name="unresolvedViewIterator"/>
                                          </propertyReferenceExpression>
                                        </target>
                                        <parameters>
                                          <binaryOperatorExpression operator="Add">
                                            <primitiveExpression value="c:"/>
                                            <propertyReferenceExpression name="LocalName">
                                              <propertyReferenceExpression name="Current">
                                                <variableReferenceExpression name="copyNodeIterator"/>
                                              </propertyReferenceExpression>
                                            </propertyReferenceExpression>
                                          </binaryOperatorExpression>
                                          <fieldReferenceExpression name="resolver"/>
                                        </parameters>
                                      </methodInvokeExpression>
                                      <primitiveExpression value="null"/>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <methodInvokeExpression methodName="AppendChild">
                                      <target>
                                        <propertyReferenceExpression name="Current">
                                          <variableReferenceExpression name="unresolvedViewIterator"/>
                                        </propertyReferenceExpression>
                                      </target>
                                      <parameters>
                                        <propertyReferenceExpression name="OuterXml">
                                          <propertyReferenceExpression name="Current">
                                            <variableReferenceExpression name="copyNodeIterator"/>
                                          </propertyReferenceExpression>
                                        </propertyReferenceExpression>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </trueStatements>
                                </conditionStatement>
                              </statements>
                            </whileStatement>
                          </trueStatements>
                        </conditionStatement>
                      </statements>
                    </whileStatement>
                    <assignStatement>
                      <fieldReferenceExpression name="navigator"/>
                      <methodInvokeExpression methodName="CreateNavigator">
                        <target>
                          <objectCreateExpression type="XPathDocument">
                            <parameters>
                              <objectCreateExpression type="StringReader">
                                <parameters>
                                  <propertyReferenceExpression name="OuterXml">
                                    <fieldReferenceExpression name="navigator"/>
                                  </propertyReferenceExpression>
                                </parameters>
                              </objectCreateExpression>
                            </parameters>
                          </objectCreateExpression>
                        </target>
                      </methodInvokeExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method InitializeHandler(object ) -->
            <memberMethod name="InitializeHandler">
              <attributes private="true"/>
              <parameters>
                <parameter type="System.Object" name="handler"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <binaryOperatorExpression operator="IdentityInequality">
                        <argumentReferenceExpression name="handler"/>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                      <binaryOperatorExpression operator="IsTypeOf">
                        <argumentReferenceExpression name="handler"/>
                        <typeReferenceExpression type="BusinessRules"/>
                      </binaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <propertyReferenceExpression name="ControllerName">
                        <castExpression targetType="BusinessRules">
                          <argumentReferenceExpression name="handler"/>
                        </castExpression>
                      </propertyReferenceExpression>
                      <propertyReferenceExpression name="ControllerName"/>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method CreateBusinessRules() -->
            <memberMethod returnType="BusinessRules" name="CreateBusinessRules">
              <attributes public="true" final="true"/>
              <statements>
                <variableDeclarationStatement type="IActionHandler" name="handler">
                  <init>
                    <methodInvokeExpression methodName="CreateActionHandler"/>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <variableReferenceExpression name="handler"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="null"/>
                    </methodReturnStatement>
                  </trueStatements>
                  <falseStatements>
                    <variableDeclarationStatement type="BusinessRules" name="rules">
                      <init>
                        <castExpression targetType="BusinessRules">
                          <variableReferenceExpression name="handler"/>
                        </castExpression>
                      </init>
                    </variableDeclarationStatement>
                    <assignStatement>
                      <propertyReferenceExpression name="Config">
                        <variableReferenceExpression name="rules"/>
                      </propertyReferenceExpression>
                      <thisReferenceExpression/>
                    </assignStatement>
                    <methodReturnStatement>
                      <variableReferenceExpression name="rules"/>
                    </methodReturnStatement>
                  </falseStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method CreateActionHandler() -->
            <memberMethod returnType="IActionHandler" name="CreateActionHandler">
              <attributes public="true" final="true"/>
              <statements>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="IsNullOrEmpty">
                      <target>
                        <typeReferenceExpression type="String"/>
                      </target>
                      <parameters>
                        <fieldReferenceExpression name="actionHandlerType"/>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="null"/>
                    </methodReturnStatement>
                  </trueStatements>
                  <falseStatements>
                    <variableDeclarationStatement type="Type" name="t">
                      <init>
                        <methodInvokeExpression methodName="GetType">
                          <target>
                            <typeReferenceExpression type="Type"/>
                          </target>
                          <parameters>
                            <fieldReferenceExpression name="actionHandlerType"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="System.Object" name="handler">
                      <init>
                        <methodInvokeExpression methodName="CreateInstance">
                          <target>
                            <propertyReferenceExpression name="Assembly">
                              <variableReferenceExpression name="t"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="FullName">
                              <variableReferenceExpression name="t"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <methodInvokeExpression methodName="InitializeHandler">
                      <parameters>
                        <variableReferenceExpression name="handler"/>
                      </parameters>
                    </methodInvokeExpression>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IsTypeOf">
                          <variableReferenceExpression name="handler"/>
                          <typeReferenceExpression type="BusinessRules"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <propertyReferenceExpression name="Config">
                            <castExpression targetType="BusinessRules">
                              <variableReferenceExpression name="handler"/>
                            </castExpression>
                          </propertyReferenceExpression>
                          <thisReferenceExpression/>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                    <methodReturnStatement>
                      <castExpression targetType="IActionHandler">
                        <variableReferenceExpression name="handler"/>
                      </castExpression>
                    </methodReturnStatement>
                  </falseStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- CreateDataFilter -->
            <memberMethod returnType="IDataFilter" name="CreateDataFilter">
              <attributes public="true" final="true"/>
              <statements>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="IsNullOrEmpty">
                      <target>
                        <typeReferenceExpression type="String"/>
                      </target>
                      <parameters>
                        <fieldReferenceExpression name="dataFilterType"/>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="null"/>
                    </methodReturnStatement>
                  </trueStatements>
                  <falseStatements>
                    <variableDeclarationStatement type="Type" name="t">
                      <init>
                        <methodInvokeExpression methodName="GetType">
                          <target>
                            <typeReferenceExpression type="Type"/>
                          </target>
                          <parameters>
                            <fieldReferenceExpression name="dataFilterType"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="System.Object" name="dataFilter">
                      <init>
                        <methodInvokeExpression methodName="CreateInstance">
                          <target>
                            <propertyReferenceExpression name="Assembly">
                              <variableReferenceExpression name="t"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="FullName">
                              <variableReferenceExpression name="t"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <methodInvokeExpression methodName="InitializeHandler">
                      <parameters>
                        <variableReferenceExpression name="dataFilter"/>
                      </parameters>
                    </methodInvokeExpression>
                    <conditionStatement>
                      <condition>
                        <methodInvokeExpression methodName="IsInstanceOfType">
                          <target>
                            <typeofExpression type="IDataFilter"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="dataFilter"/>
                          </parameters>
                        </methodInvokeExpression>
                      </condition>
                      <trueStatements>
                        <methodReturnStatement>
                          <castExpression targetType="IDataFilter">
                            <variableReferenceExpression name="dataFilter"/>
                          </castExpression>
                        </methodReturnStatement>
                      </trueStatements>
                      <falseStatements>
                        <methodReturnStatement>
                          <primitiveExpression value="null"/>
                        </methodReturnStatement>
                      </falseStatements>
                    </conditionStatement>
                  </falseStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method CreateRowHandler() -->
            <memberMethod returnType="IRowHandler" name="CreateRowHandler">
              <attributes public="true" final="true"/>
              <statements>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="IsNullOrEmpty">
                      <target>
                        <typeReferenceExpression type="String"/>
                      </target>
                      <parameters>
                        <fieldReferenceExpression name="actionHandlerType"/>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="null"/>
                    </methodReturnStatement>
                  </trueStatements>
                  <falseStatements>
                    <variableDeclarationStatement type="Type" name="t">
                      <init>
                        <methodInvokeExpression methodName="GetType">
                          <target>
                            <typeReferenceExpression type="Type"/>
                          </target>
                          <parameters>
                            <fieldReferenceExpression name="actionHandlerType"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="System.Object" name="handler">
                      <init>
                        <methodInvokeExpression methodName="CreateInstance">
                          <target>
                            <propertyReferenceExpression name="Assembly">
                              <variableReferenceExpression name="t"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="FullName">
                              <variableReferenceExpression name="t"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <methodInvokeExpression methodName="InitializeHandler">
                      <parameters>
                        <variableReferenceExpression name="handler"/>
                      </parameters>
                    </methodInvokeExpression>
                    <conditionStatement>
                      <condition>
                        <methodInvokeExpression methodName="IsInstanceOfType">
                          <target>
                            <typeofExpression type="IRowHandler"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="handler"/>
                          </parameters>
                        </methodInvokeExpression>
                      </condition>
                      <trueStatements>
                        <methodReturnStatement>
                          <castExpression targetType="IRowHandler">
                            <variableReferenceExpression name="handler"/>
                          </castExpression>
                        </methodReturnStatement>
                      </trueStatements>
                      <falseStatements>
                        <methodReturnStatement>
                          <primitiveExpression value="null"/>
                        </methodReturnStatement>
                      </falseStatements>
                    </conditionStatement>
                  </falseStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- AssignDynamicExpressions(ViewPage) -->
            <memberMethod name="AssignDynamicExpressions">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="ViewPage" name="page"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="List" name="list">
                  <typeArguments>
                    <typeReference type="DynamicExpression"/>
                  </typeArguments>
                  <init>
                    <objectCreateExpression type="List">
                      <typeArguments>
                        <typeReference type="DynamicExpression"/>
                      </typeArguments>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <foreachStatement>
                  <variable type="DynamicExpression" name="de"/>
                  <target>
                    <fieldReferenceExpression name="expressions"/>
                  </target>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <methodInvokeExpression methodName="AllowedInView">
                          <target>
                            <variableReferenceExpression name="de"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="View">
                              <argumentReferenceExpression name="page"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <variableReferenceExpression name="list"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="de"/>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Expressions">
                    <variableReferenceExpression name="page"/>
                  </propertyReferenceExpression>
                  <methodInvokeExpression methodName="ToArray">
                    <target>
                      <variableReferenceExpression name="list"/>
                    </target>
                  </methodInvokeExpression>
                </assignStatement>
              </statements>
            </memberMethod>
            <!-- method Clone() -->
            <memberMethod returnType="ControllerConfiguration" name="Clone">
              <attributes public="true" final="true"/>
              <statements>
                <variableDeclarationStatement type="System.String" name="variablesPath">
                  <init>
                    <methodInvokeExpression methodName="Combine">
                      <target>
                        <typeReferenceExpression type="Path"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="AppDomainAppPath">
                          <typeReferenceExpression type="HttpRuntime"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="Controllers\_variables.xml"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="SortedDictionary" name="variables">
                  <typeArguments>
                    <typeReference type="System.String"/>
                    <typeReference type="System.String"/>
                  </typeArguments>
                  <init>
                    <castExpression targetType="SortedDictionary">
                      <typeArguments>
                        <typeReference type="System.String"/>
                        <typeReference type="System.String"/>
                      </typeArguments>
                      <arrayIndexerExpression>
                        <target>
                          <propertyReferenceExpression name="Cache">
                            <typeReferenceExpression type="HttpRuntime"/>
                          </propertyReferenceExpression>
                        </target>
                        <indices>
                          <variableReferenceExpression name="variablesPath"/>
                        </indices>
                      </arrayIndexerExpression>
                    </castExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <variableReferenceExpression name="variables"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="variables"/>
                      <objectCreateExpression type="SortedDictionary">
                        <typeArguments>
                          <typeReference type="System.String"/>
                          <typeReference type="System.String"/>
                        </typeArguments>
                      </objectCreateExpression>
                    </assignStatement>
                    <conditionStatement>
                      <condition>
                        <methodInvokeExpression methodName="Exists">
                          <target>
                            <typeReferenceExpression type="File"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="variablesPath"/>
                          </parameters>
                        </methodInvokeExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="XPathDocument" name="varDoc">
                          <init>
                            <objectCreateExpression type="XPathDocument">
                              <parameters>
                                <variableReferenceExpression name="variablesPath"/>
                              </parameters>
                            </objectCreateExpression>
                          </init>
                        </variableDeclarationStatement>
                        <variableDeclarationStatement type="XPathNavigator" name="varNav">
                          <init>
                            <methodInvokeExpression methodName="CreateNavigator">
                              <target>
                                <variableReferenceExpression name="varDoc"/>
                              </target>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <variableDeclarationStatement type="XPathNodeIterator" name="varIterator">
                          <init>
                            <methodInvokeExpression methodName="Select">
                              <target>
                                <variableReferenceExpression name="varNav"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="/variables/variable"/>
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <whileStatement>
                          <test>
                            <methodInvokeExpression methodName="MoveNext">
                              <target>
                                <variableReferenceExpression name="varIterator"/>
                              </target>
                            </methodInvokeExpression>
                          </test>
                          <statements>
                            <variableDeclarationStatement type="System.String" name="varName">
                              <init>
                                <methodInvokeExpression methodName="GetAttribute">
                                  <target>
                                    <propertyReferenceExpression name="Current">
                                      <variableReferenceExpression name="varIterator"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="name"/>
                                    <propertyReferenceExpression name="Empty">
                                      <typeReferenceExpression type="String"/>
                                    </propertyReferenceExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </init>
                            </variableDeclarationStatement>
                            <variableDeclarationStatement type="System.String" name="varValue">
                              <init>
                                <propertyReferenceExpression name="Value">
                                  <propertyReferenceExpression name="Current">
                                    <variableReferenceExpression name="varIterator"/>
                                  </propertyReferenceExpression>
                                </propertyReferenceExpression>
                              </init>
                            </variableDeclarationStatement>
                            <conditionStatement>
                              <condition>
                                <unaryOperatorExpression operator="Not">
                                  <methodInvokeExpression methodName="ContainsKey">
                                    <target>
                                      <variableReferenceExpression name="variables"/>
                                    </target>
                                    <parameters>
                                      <variableReferenceExpression name="varName"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                </unaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <methodInvokeExpression methodName="Add">
                                  <target>
                                    <variableReferenceExpression name="variables"/>
                                  </target>
                                  <parameters>
                                    <variableReferenceExpression name="varName"/>
                                    <variableReferenceExpression name="varValue"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </trueStatements>
                              <falseStatements>
                                <assignStatement>
                                  <arrayIndexerExpression>
                                    <target>
                                      <variableReferenceExpression name="variables"/>
                                    </target>
                                    <indices>
                                      <variableReferenceExpression name="varName"/>
                                    </indices>
                                  </arrayIndexerExpression>
                                  <variableReferenceExpression name="varValue"/>
                                </assignStatement>
                              </falseStatements>
                            </conditionStatement>
                          </statements>
                        </whileStatement>
                      </trueStatements>
                    </conditionStatement>
                    <methodInvokeExpression methodName="Insert">
                      <target>
                        <propertyReferenceExpression name="Cache">
                          <typeReferenceExpression type="HttpRuntime"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="variablesPath"/>
                        <variableReferenceExpression name="variables"/>
                        <objectCreateExpression type="CacheDependency">
                          <parameters>
                            <variableReferenceExpression name="variablesPath"/>
                          </parameters>
                        </objectCreateExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <objectCreateExpression type="ControllerConfiguration">
                    <parameters>
                      <objectCreateExpression type="XPathDocument">
                        <parameters>
                          <objectCreateExpression type="StringReader">
                            <parameters>
                              <methodInvokeExpression methodName="ReplaceVariables">
                                <target>
                                  <objectCreateExpression type="ControllerConfigurationUtility">
                                    <parameters>
                                      <fieldReferenceExpression name="rawConfiguration"/>
                                      <variableReferenceExpression name="variables"/>
                                    </parameters>
                                  </objectCreateExpression>
                                </target>
                              </methodInvokeExpression>
                            </parameters>
                          </objectCreateExpression>
                        </parameters>
                      </objectCreateExpression>
                    </parameters>
                  </objectCreateExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method Localize(string) -->
            <memberMethod returnType="ControllerConfiguration" name="Localize">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="System.String" name="controller"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.String" name="localizedContent">
                  <init>
                    <methodInvokeExpression methodName="Replace">
                      <target>
                        <typeReferenceExpression type="Localizer"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="Controllers"/>
                        <binaryOperatorExpression operator="Add">
                          <argumentReferenceExpression name="controller"/>
                          <primitiveExpression value=".xml"/>
                        </binaryOperatorExpression>
                        <propertyReferenceExpression name="OuterXml">
                          <fieldReferenceExpression name="navigator"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <propertyReferenceExpression name="PlugIn"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="XmlDocument" name="doc">
                      <init>
                        <objectCreateExpression type="XmlDocument"/>
                      </init>
                    </variableDeclarationStatement>
                    <methodInvokeExpression methodName="LoadXml">
                      <target>
                        <variableReferenceExpression name="doc"/>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="localizedContent"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodReturnStatement>
                      <objectCreateExpression type="ControllerConfiguration">
                        <parameters>
                          <methodInvokeExpression methodName="CreateNavigator">
                            <target>
                              <variableReferenceExpression name="doc"/>
                            </target>
                          </methodInvokeExpression>
                        </parameters>
                      </objectCreateExpression>
                    </methodReturnStatement>
                  </trueStatements>
                  <falseStatements>
                    <methodReturnStatement>
                      <objectCreateExpression type="ControllerConfiguration">
                        <parameters>
                          <objectCreateExpression type="XPathDocument">
                            <parameters>
                              <objectCreateExpression type="StringReader">
                                <parameters>
                                  <variableReferenceExpression name="localizedContent"/>
                                </parameters>
                              </objectCreateExpression>
                            </parameters>
                          </objectCreateExpression>
                        </parameters>
                      </objectCreateExpression>
                    </methodReturnStatement>
                  </falseStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method SelectSingleNode(string, params object[]) -->
            <memberMethod returnType="XPathNavigator" name="SelectSingleNode">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="System.String" name="selector"/>
                <parameter type="params System.Object[]" name="args"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="SelectSingleNode">
                    <target>
                      <fieldReferenceExpression name="navigator"/>
                    </target>
                    <parameters>
                      <methodInvokeExpression methodName="Format">
                        <target>
                          <typeReferenceExpression type="String"/>
                        </target>
                        <parameters>
                          <argumentReferenceExpression name="selector"/>
                          <argumentReferenceExpression name="args"/>
                        </parameters>
                      </methodInvokeExpression>
                      <fieldReferenceExpression name="resolver"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method Select(string, params object[]) -->
            <memberMethod returnType="XPathNodeIterator" name="Select">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="System.String" name="selector"/>
                <parameter type="params System.Object[]" name="args"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="Select">
                    <target>
                      <fieldReferenceExpression name="navigator"/>
                    </target>
                    <parameters>
                      <methodInvokeExpression methodName="Format">
                        <target>
                          <typeReferenceExpression type="String"/>
                        </target>
                        <parameters>
                          <argumentReferenceExpression name="selector"/>
                          <argumentReferenceExpression name="args"/>
                        </parameters>
                      </methodInvokeExpression>
                      <fieldReferenceExpression name="resolver"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method Evaluate(string, params object[]) -->
            <memberMethod returnType="System.Object" name="Evaluate">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="System.String" name="selector"/>
                <parameter type="params System.Object[]" name="args"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="Evaluate">
                    <target>
                      <fieldReferenceExpression name="navigator"/>
                    </target>
                    <parameters>
                      <methodInvokeExpression methodName="Format">
                        <target>
                          <typeReferenceExpression type="String"/>
                        </target>
                        <parameters>
                          <argumentReferenceExpression name="selector"/>
                          <argumentReferenceExpression name="args"/>
                        </parameters>
                      </methodInvokeExpression>
                      <fieldReferenceExpression name="resolver"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- property TrimmedNavigator -->
            <memberProperty type="XPathNavigator" name="TrimmedNavigator">
              <attributes public="true" final="true"/>
              <getStatements>
                <variableDeclarationStatement type="List" name="hiddenFields">
                  <typeArguments>
                    <typeReference type="System.String"/>
                  </typeArguments>
                  <init>
                    <objectCreateExpression type="List">
                      <typeArguments>
                        <typeReference type="System.String"/>
                      </typeArguments>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="XPathNodeIterator" name="fieldIterator">
                  <init>
                    <methodInvokeExpression methodName="Select">
                      <parameters>
                        <primitiveExpression value="/c:dataController/c:fields/c:field[@roles!='']"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <whileStatement>
                  <test>
                    <methodInvokeExpression methodName="MoveNext">
                      <target>
                        <variableReferenceExpression name="fieldIterator"/>
                      </target>
                    </methodInvokeExpression>
                  </test>
                  <statements>
                    <variableDeclarationStatement type="System.String" name="roles">
                      <init>
                        <methodInvokeExpression methodName="GetAttribute">
                          <target>
                            <propertyReferenceExpression name="Current">
                              <variableReferenceExpression name="fieldIterator"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <primitiveExpression value="roles"/>
                            <propertyReferenceExpression name="Empty">
                              <typeReferenceExpression type="String"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="Not">
                          <methodInvokeExpression methodName="UserIsInRole">
                            <target>
                              <typeReferenceExpression type="DataControllerBase"/>
                            </target>
                            <parameters>
                              <variableReferenceExpression name="roles"/>
                            </parameters>
                          </methodInvokeExpression>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <variableReferenceExpression name="hiddenFields"/>
                          </target>
                          <parameters>
                            <methodInvokeExpression methodName="GetAttribute">
                              <target>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="fieldIterator"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="name"/>
                                <propertyReferenceExpression name="Empty">
                                  <typeReferenceExpression type="String"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </whileStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <propertyReferenceExpression name="Count">
                        <variableReferenceExpression name="hiddenFields"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="0"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <propertyReferenceExpression name="Navigator"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="XmlDocument" name="doc">
                  <init>
                    <objectCreateExpression type="XmlDocument"/>
                  </init>
                </variableDeclarationStatement>
                <methodInvokeExpression methodName="LoadXml">
                  <target>
                    <variableReferenceExpression name="doc"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="OuterXml">
                      <propertyReferenceExpression name="Navigator"/>
                    </propertyReferenceExpression>
                  </parameters>
                </methodInvokeExpression>
                <variableDeclarationStatement type="XPathNavigator" name="nav">
                  <init>
                    <methodInvokeExpression methodName="CreateNavigator">
                      <target>
                        <variableReferenceExpression name="doc"/>
                      </target>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="XPathNodeIterator" name="dataFieldIterator">
                  <init>
                    <methodInvokeExpression methodName="Select">
                      <target>
                        <variableReferenceExpression name="nav"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="//c:dataField"/>
                        <propertyReferenceExpression name="Resolver"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <whileStatement>
                  <test>
                    <methodInvokeExpression methodName="MoveNext">
                      <target>
                        <variableReferenceExpression name="dataFieldIterator"/>
                      </target>
                    </methodInvokeExpression>
                  </test>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <methodInvokeExpression methodName="Contains">
                          <target>
                            <variableReferenceExpression name="hiddenFields"/>
                          </target>
                          <parameters>
                            <methodInvokeExpression methodName="GetAttribute">
                              <target>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="dataFieldIterator"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="fieldName"/>
                                <propertyReferenceExpression name="Empty">
                                  <typeReferenceExpression type="String"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="XPathNavigator" name="hiddenAttr">
                          <init>
                            <methodInvokeExpression methodName="SelectSingleNode">
                              <target>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="dataFieldIterator"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="@hidden"/>
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="IdentityEquality">
                              <variableReferenceExpression name="hiddenAttr"/>
                              <primitiveExpression value="null"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="CreateAttribute">
                              <target>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="dataFieldIterator"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <propertyReferenceExpression name="Empty">
                                  <typeReferenceExpression type="String"/>
                                </propertyReferenceExpression>
                                <primitiveExpression value="hidden"/>
                                <propertyReferenceExpression name="Empty">
                                  <typeReferenceExpression type="String"/>
                                </propertyReferenceExpression>
                                <primitiveExpression value="true" convertTo="String"/>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                          <falseStatements>
                            <methodInvokeExpression methodName="SetValue">
                              <target>
                                <variableReferenceExpression name="hiddenAttr"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="true" convertTo="String"/>
                              </parameters>
                            </methodInvokeExpression>
                          </falseStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </whileStatement>
                <methodReturnStatement>
                  <variableReferenceExpression name="nav"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- method ReadActionData(string) -->
            <memberMethod returnType="System.String" name="ReadActionData">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="System.String" name="path"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="IsNotNullOrEmpty">
                      <argumentReferenceExpression name="path"/>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="System.String[]" name="p">
                      <init>
                        <methodInvokeExpression methodName="Split">
                          <target>
                            <argumentReferenceExpression name="path"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="/" convertTo="Char"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="ValueEquality">
                          <propertyReferenceExpression name="Length">
                            <variableReferenceExpression name="p"/>
                          </propertyReferenceExpression>
                          <primitiveExpression value="2"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="XPathNavigator" name="dataNav">
                          <init>
                            <methodInvokeExpression methodName="SelectSingleNode">
                              <parameters>
                                <primitiveExpression>
                                  <xsl:attribute name="value"><![CDATA[/c:dataController/c:actions/c:actionGroup[@id='{0}']/c:action[@id='{1}']/c:data]]></xsl:attribute>
                                </primitiveExpression>
                                <arrayIndexerExpression>
                                  <target>
                                    <variableReferenceExpression name="p"/>
                                  </target>
                                  <indices>
                                    <primitiveExpression value="0"/>
                                  </indices>
                                </arrayIndexerExpression>
                                <arrayIndexerExpression>
                                  <target>
                                    <variableReferenceExpression name="p"/>
                                  </target>
                                  <indices>
                                    <primitiveExpression value="1"/>
                                  </indices>
                                </arrayIndexerExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="IdentityInequality">
                              <variableReferenceExpression name="dataNav"/>
                              <primitiveExpression value="null"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <methodReturnStatement>
                              <propertyReferenceExpression name="Value">
                                <variableReferenceExpression name="dataNav"/>
                              </propertyReferenceExpression>
                            </methodReturnStatement>
                          </trueStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <primitiveExpression value="null"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method ParseActionData(string, SortedDictionary<string, string) -->
            <memberMethod name="ParseActionData">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="System.String" name="path"/>
                <parameter type="SortedDictionary" name="variables">
                  <typeArguments>
                    <typeReference type="System.String"/>
                    <typeReference type="System.String"/>
                  </typeArguments>
                </parameter>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.String" name="data">
                  <init>
                    <methodInvokeExpression methodName="ReadActionData">
                      <parameters>
                        <argumentReferenceExpression name="path"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="IsNotNullOrEmpty">
                      <variableReferenceExpression name="data"/>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="Match" name="m">
                      <init>
                        <methodInvokeExpression methodName="Match">
                          <target>
                            <typeReferenceExpression type="Regex"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="data"/>
                            <primitiveExpression value="^\s*(\w+)\s*=\s*(.+?)\s*$"/>
                            <propertyReferenceExpression name="Multiline">
                              <typeReferenceExpression type="RegexOptions"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <whileStatement>
                      <test>
                        <propertyReferenceExpression name="Success">
                          <variableReferenceExpression name="m"/>
                        </propertyReferenceExpression>
                      </test>
                      <statements>
                        <assignStatement>
                          <arrayIndexerExpression>
                            <target>
                              <argumentReferenceExpression name="variables"/>
                            </target>
                            <indices>
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
                            </indices>
                          </arrayIndexerExpression>
                          <propertyReferenceExpression name="Value">
                            <arrayIndexerExpression>
                              <target>
                                <propertyReferenceExpression name="Groups">
                                  <variableReferenceExpression name="m"/>
                                </propertyReferenceExpression>
                              </target>
                              <indices>
                                <primitiveExpression value="2"/>
                              </indices>
                            </arrayIndexerExpression>
                          </propertyReferenceExpression>
                        </assignStatement>
                        <assignStatement>
                          <variableReferenceExpression name="m"/>
                          <methodInvokeExpression methodName="NextMatch">
                            <target>
                              <variableReferenceExpression name="m"/>
                            </target>
                          </methodInvokeExpression>
                        </assignStatement>
                      </statements>
                    </whileStatement>
                  </trueStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
        <!-- class ControllerConfigurationUtility -->
        <typeDeclaration name="ControllerConfigurationUtility">
          <members>
            <memberField type="System.String" name="rawConfiguration"/>
            <memberField type="SortedDictionary" name="variables">
              <typeArguments>
                <typeReference type="System.String"/>
                <typeReference type="System.String"/>
              </typeArguments>
            </memberField>
            <!-- constructor (string, SortedDictionary<string, string>) -->
            <constructor>
              <attributes public="true"/>
              <parameters>
                <parameter type="System.String" name="rawConfiguration"/>
                <parameter type="SortedDictionary" name="variables">
                  <typeArguments>
                    <typeReference type="System.String"/>
                    <typeReference type="System.String"/>
                  </typeArguments>
                </parameter>
              </parameters>
              <statements>
                <assignStatement>
                  <fieldReferenceExpression name="rawConfiguration"/>
                  <argumentReferenceExpression name="rawConfiguration"/>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="variables"/>
                  <argumentReferenceExpression name="variables"/>
                </assignStatement>
              </statements>
            </constructor>
            <!-- method ReplaceVariables() -->
            <memberMethod returnType="System.String" name="ReplaceVariables">
              <attributes public="true" final="true"/>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="Replace">
                    <target>
                      <propertyReferenceExpression name="VariableReplacementRegex">
                        <typeReferenceExpression type="ControllerConfiguration"/>
                      </propertyReferenceExpression>
                    </target>
                    <parameters>
                      <fieldReferenceExpression name="rawConfiguration"/>
                      <addressOfExpression>
                        <methodReferenceExpression methodName="DoReplace"/>
                      </addressOfExpression>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method DoReplace(Match) -->
            <memberMethod returnType="System.String" name="DoReplace">
              <attributes private="true"/>
              <parameters>
                <parameter type="Match" name="m"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
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
                      <propertyReferenceExpression name="Value">
                        <arrayIndexerExpression>
                          <target>
                            <propertyReferenceExpression name="Groups">
                              <variableReferenceExpression name="m"/>
                            </propertyReferenceExpression>
                          </target>
                          <indices>
                            <primitiveExpression value="3"/>
                          </indices>
                        </arrayIndexerExpression>
                      </propertyReferenceExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="System.String" name="s">
                      <init>
                        <primitiveExpression value="null"/>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <methodInvokeExpression methodName="TryGetValue">
                          <target>
                            <fieldReferenceExpression name="variables"/>
                          </target>
                          <parameters>
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
                            <directionExpression direction="Out">
                              <variableReferenceExpression name="s"/>
                            </directionExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </condition>
                      <trueStatements>
                        <methodReturnStatement>
                          <variableReferenceExpression name="s"/>
                        </methodReturnStatement>
                      </trueStatements>
                      <falseStatements>
                        <methodReturnStatement>
                          <propertyReferenceExpression name="Value">
                            <arrayIndexerExpression>
                              <target>
                                <propertyReferenceExpression name="Groups">
                                  <variableReferenceExpression name="m"/>
                                </propertyReferenceExpression>
                              </target>
                              <indices>
                                <primitiveExpression value="2"/>
                              </indices>
                            </arrayIndexerExpression>
                          </propertyReferenceExpression>
                        </methodReturnStatement>
                      </falseStatements>
                    </conditionStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <propertyReferenceExpression name="Value">
                    <argumentReferenceExpression name="m"/>
                  </propertyReferenceExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
      </types>
    </compileUnit>
  </xsl:template>
</xsl:stylesheet>
