﻿<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.codeontime.com/2008/codedom-compiler"  xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl a"
>
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="IsPremium"/>
  <xsl:param name="IsUnlimited"/>
  <xsl:param name="Auditing" select="a:project/a:features/a:ease/a:auditing"/>
  <xsl:variable name="MembershipEnabled" select="a:project/a:membership/@enabled"/>
  <xsl:variable name="CustomSecurity" select="a:project/a:membership/@customSecurity"/>
  <xsl:variable name="ActiveDirectory" select="a:project/a:membership/@activeDirectory"/>
  <xsl:variable name="Namespace" select="a:project/a:namespace"/>
  <xsl:variable name="EnableTransactions" select="a:project/a:features/@enableTransactions"/>

  <xsl:template match="/">
    <compileUnit namespace="{$Namespace}.Data">
      <imports>
        <namespaceImport name="System"/>
        <namespaceImport name="System.Collections.Generic"/>
        <namespaceImport name="System.ComponentModel"/>
        <namespaceImport name="System.Configuration"/>
        <namespaceImport name="System.Data"/>
        <namespaceImport name="System.Data.Common"/>
        <namespaceImport name="System.IO"/>
        <namespaceImport name="System.Linq"/>
        <namespaceImport name="System.Text"/>
        <namespaceImport name="System.Text.RegularExpressions"/>
        <namespaceImport name="System.Transactions"/>
        <namespaceImport name="System.Xml"/>
        <namespaceImport name="System.Xml.XPath"/>
        <namespaceImport name="System.Xml.Xsl"/>
        <namespaceImport name="System.Web"/>
        <namespaceImport name="System.Web.Caching"/>
        <namespaceImport name="System.Web.Configuration"/>
        <namespaceImport name="System.Web.Security"/>
      </imports>
      <types>
        <!-- DataControllerBase -->
        <typeDeclaration name="DataControllerBase" isPartial="true">
          <!--<baseTypes>
            <typeReference type="System.Object"/>
            <typeReference type="IDataController"/>
            <typeReference type="IAutoCompleteManager"/>
            <typeReference type="IDataEngine"/>
            <typeReference type="IBusinessObject"/>
          </baseTypes>-->
          <members>
            <memberField type="XPathNavigator" name="view"/>
            <memberField type="System.String" name="viewId"/>
            <memberField type="System.String" name="parameterMarker"/>
            <memberField type="System.String" name="leftQuote"/>
            <memberField type="System.String" name="rightQuote"/>
            <memberField type="System.String" name="viewType"/>
            <!-- property Config-->
            <memberField type="ControllerConfiguration" name="config"/>
            <memberProperty type="ControllerConfiguration" name="Config">
              <attributes public="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="config"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property Resolver -->
            <memberProperty type="IXmlNamespaceResolver" name="Resolver">
              <attributes private="true"/>
              <getStatements>
                <methodReturnStatement>
                  <propertyReferenceExpression name="Resolver">
                    <fieldReferenceExpression name="config"/>
                  </propertyReferenceExpression>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- method YieldsSingleRow(DbCommand command) -->
            <memberMethod returnType="System.Boolean" name="YieldsSingleRow">
              <attributes family="true"/>
              <parameters>
                <parameter type="DbCommand" name="command"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <binaryOperatorExpression operator="BooleanOr">
                    <binaryOperatorExpression operator="IdentityEquality">
                      <argumentReferenceExpression name="command"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                    <binaryOperatorExpression operator="ValueEquality">
                      <methodInvokeExpression methodName="IndexOf">
                        <target>
                          <propertyReferenceExpression name="CommandText">
                            <argumentReferenceExpression name="command"/>
                          </propertyReferenceExpression>
                        </target>
                        <parameters>
                          <primitiveExpression value="count(*)"/>
                        </parameters>
                      </methodInvokeExpression>
                      <primitiveExpression value="-1"/>
                    </binaryOperatorExpression>
                  </binaryOperatorExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method CreateValueFromSourceFields(DataField, DbDataReader)-->
            <memberMethod returnType="System.String" name="CreateValueFromSourceFields">
              <attributes final="true" family="true"/>
              <parameters>
                <parameter type="DataField" name="field"/>
                <parameter type="DbDataReader" name="reader"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.String" name="v">
                  <init>
                    <propertyReferenceExpression name="Empty">
                      <typeReferenceExpression type="String"/>
                    </propertyReferenceExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="Equals">
                      <target>
                        <propertyReferenceExpression name="Value">
                          <typeReferenceExpression type="DBNull"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <arrayIndexerExpression>
                          <target>
                            <argumentReferenceExpression name="reader"/>
                          </target>
                          <indices>
                            <propertyReferenceExpression name="Name">
                              <argumentReferenceExpression name="field"/>
                            </propertyReferenceExpression>
                          </indices>
                        </arrayIndexerExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="v"/>
                      <primitiveExpression value="null" convertTo="String"/>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="Match" name="m">
                  <init>
                    <methodInvokeExpression methodName="Match">
                      <target>
                        <typeReferenceExpression type="Regex"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="SourceFields">
                          <argumentReferenceExpression name="field"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="(\w+)\s*(,|$)"/>
                        <!--<propertyReferenceExpression name="Compiled">
                          <typeReferenceExpression type="RegexOptions"/>
                        </propertyReferenceExpression>-->
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
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="GreaterThan">
                          <propertyReferenceExpression name="Length">
                            <variableReferenceExpression name="v"/>
                          </propertyReferenceExpression>
                          <primitiveExpression value="0"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="v"/>
                          <binaryOperatorExpression operator="Add">
                            <variableReferenceExpression name="v"/>
                            <primitiveExpression value="|"/>
                          </binaryOperatorExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                    <assignStatement>
                      <variableReferenceExpression name="v"/>
                      <binaryOperatorExpression operator="Add">
                        <variableReferenceExpression name="v"/>
                        <methodInvokeExpression methodName="ToString">
                          <target>
                            <typeReferenceExpression type="Convert"/>
                          </target>
                          <parameters>
                            <arrayIndexerExpression>
                              <target>
                                <argumentReferenceExpression name="reader"/>
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
                          </parameters>
                        </methodInvokeExpression>
                      </binaryOperatorExpression>
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
                <methodReturnStatement>
                  <variableReferenceExpression name="v"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method PopulatePageCategories(ViewPage)-->
            <memberMethod name="PopulatePageCategories">
              <attributes private="true"/>
              <parameters>
                <parameter type="ViewPage" name="page"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="XPathNodeIterator" name="categoryIterator">
                  <init>
                    <methodInvokeExpression methodName="Select">
                      <target>
                        <fieldReferenceExpression name="view"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="c:categories/c:category"/>
                        <propertyReferenceExpression name="Resolver"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <whileStatement>
                  <test>
                    <methodInvokeExpression methodName="MoveNext">
                      <target>
                        <variableReferenceExpression name="categoryIterator"/>
                      </target>
                    </methodInvokeExpression>
                  </test>
                  <statements>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <propertyReferenceExpression name="Categories">
                          <argumentReferenceExpression name="page"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <objectCreateExpression type="Category">
                          <parameters>
                            <propertyReferenceExpression name="Current">
                              <variableReferenceExpression name="categoryIterator"/>
                            </propertyReferenceExpression>
                            <propertyReferenceExpression name="Resolver"/>
                          </parameters>
                        </objectCreateExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </statements>
                </whileStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <propertyReferenceExpression name="Count">
                        <propertyReferenceExpression name="Categories">
                          <argumentReferenceExpression name="page"/>
                        </propertyReferenceExpression>
                      </propertyReferenceExpression>
                      <primitiveExpression value="0"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <propertyReferenceExpression name="Categories">
                          <argumentReferenceExpression name="page"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <objectCreateExpression type="Category"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method CreateViewPage()-->
            <memberField type="ViewPage" name="viewPage"/>
            <memberMethod returnType="ViewPage" name="CreateViewPage">
              <attributes family="true" final="true"/>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <fieldReferenceExpression name="viewPage"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <fieldReferenceExpression name="viewPage"/>
                      <objectCreateExpression type="ViewPage"/>
                    </assignStatement>
                    <methodInvokeExpression methodName="PopulatePageFields">
                      <parameters>
                        <fieldReferenceExpression name="viewPage"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="EnsurePageFields">
                      <parameters>
                        <fieldReferenceExpression name="viewPage"/>
                        <primitiveExpression value="null"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <fieldReferenceExpression name="viewPage"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method ExecuteWithPivot(string, string, ActionArgs, ActionResult) -->
            <!--<memberMethod returnType="System.Boolean" name="ExecuteWithPivot">
              <attributes private="true"/>
              <parameters>
                <parameter type="System.String" name="controller"/>
                <parameter type="System.String" name="view"/>
                <parameter type="ActionArgs" name="args"/>
                <parameter type="ActionResult" name="result"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="Not">
                      <propertyReferenceExpression name="RequiresPivot">
                        <variableReferenceExpression name="args"/>
                      </propertyReferenceExpression>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="false"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <assignStatement>
                  <fieldReferenceExpression name="config"/>
                  <methodInvokeExpression methodName="CreateConfiguration">
                    <parameters>
                      <argumentReferenceExpression name="controller"/>
                    </parameters>
                  </methodInvokeExpression>
                </assignStatement>
                <usingStatement>
                  <variable type="DbConnection" name="connection">
                    <init>
                      <methodInvokeExpression methodName="CreateConnection"/>
                    </init>
                  </variable>
                  <statements>
                    <usingStatement>
                      <variable type="SinglePhaseTransactionScope" name="scope">
                        <init>
                          <objectCreateExpression type="SinglePhaseTransactionScope"/>
                        </init>
                      </variable>
                      <statements>
                        <methodInvokeExpression methodName="Enlist">
                          <target>
                            <variableReferenceExpression name="scope"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="connection"/>
                          </parameters>
                        </methodInvokeExpression>
                        <assignStatement>
                          <propertyReferenceExpression name="ViewOverridingDisabled"/>
                          <primitiveExpression value="true"/>
                        </assignStatement>
                        <variableDeclarationStatement type="System.Int32" name="valueSetIndex">
                          <init>
                            <primitiveExpression value="0"/>
                          </init>
                        </variableDeclarationStatement>
                        <foreachStatement>
                          <variable type="FieldValue[]" name="valueSet"/>
                          <target>
                            <propertyReferenceExpression name="PivotValues">
                              <argumentReferenceExpression name="args"/>
                            </propertyReferenceExpression>
                          </target>
                          <statements>
                            <assignStatement>
                              <propertyReferenceExpression name="Values">
                                <argumentReferenceExpression name="args"/>
                              </propertyReferenceExpression>
                              <variableReferenceExpression name="valueSet"/>
                            </assignStatement>
                            <variableDeclarationStatement type="IDataController" name="c">
                              <init>
                                <castExpression targetType="IDataController">
                                  <thisReferenceExpression/>
                                </castExpression>
                              </init>
                            </variableDeclarationStatement>
                            <variableDeclarationStatement type="ActionResult" name="result2">
                              <init>
                                <methodInvokeExpression methodName="Execute">
                                  <target>
                                    <variableReferenceExpression name="c"/>
                                  </target>
                                  <parameters>
                                    <argumentReferenceExpression name="controller"/>
                                    <argumentReferenceExpression name="view"/>
                                    <argumentReferenceExpression name="args"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </init>
                            </variableDeclarationStatement>
                            <conditionStatement>
                              <condition>
                                <propertyReferenceExpression name="RowNotFound">
                                  <variableReferenceExpression name="result2"/>
                                </propertyReferenceExpression>
                              </condition>
                              <trueStatements>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="ValueEquality">
                                      <propertyReferenceExpression name="CommandName">
                                        <argumentReferenceExpression name="args"/>
                                      </propertyReferenceExpression>
                                      <primitiveExpression value="Update"/>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <methodInvokeExpression methodName="Clear">
                                      <target>
                                        <propertyReferenceExpression name="Errors">
                                          <variableReferenceExpression name="result2"/>
                                        </propertyReferenceExpression>
                                      </target>
                                    </methodInvokeExpression>
                                    <variableDeclarationStatement type="System.String" name="saveCommandName">
                                      <init>
                                        <propertyReferenceExpression name="CommandName">
                                          <argumentReferenceExpression name="args"/>
                                        </propertyReferenceExpression>
                                      </init>
                                    </variableDeclarationStatement>
                                    <variableDeclarationStatement type="System.String" name="saveLastCommandName">
                                      <init>
                                        <propertyReferenceExpression name="LastCommandName">
                                          <argumentReferenceExpression name="args"/>
                                        </propertyReferenceExpression>
                                      </init>
                                    </variableDeclarationStatement>
                                    <assignStatement>
                                      <propertyReferenceExpression name="CommandName">
                                        <argumentReferenceExpression name="args"/>
                                      </propertyReferenceExpression>
                                      <primitiveExpression value="Insert"/>
                                    </assignStatement>
                                    <assignStatement>
                                      <propertyReferenceExpression name="LastCommandName">
                                        <argumentReferenceExpression name="args"/>
                                      </propertyReferenceExpression>
                                      <primitiveExpression value="New"/>
                                    </assignStatement>
                                    <assignStatement>
                                      <variableReferenceExpression name="result2"/>
                                      <methodInvokeExpression methodName="Execute">
                                        <target>
                                          <variableReferenceExpression name="c"/>
                                        </target>
                                        <parameters>
                                          <argumentReferenceExpression name="controller"/>
                                          <argumentReferenceExpression name="view"/>
                                          <argumentReferenceExpression name="args"/>
                                        </parameters>
                                      </methodInvokeExpression>
                                    </assignStatement>
                                    <assignStatement>
                                      <propertyReferenceExpression name="CommandName">
                                        <argumentReferenceExpression name="args"/>
                                      </propertyReferenceExpression>
                                      <variableReferenceExpression name="saveCommandName"/>
                                    </assignStatement>
                                    <assignStatement>
                                      <propertyReferenceExpression name="LastCommandName">
                                        <argumentReferenceExpression name="args"/>
                                      </propertyReferenceExpression>
                                      <variableReferenceExpression name="saveCommandName"/>
                                    </assignStatement>
                                    <assignStatement>
                                      <propertyReferenceExpression name="LastCommandName">
                                        <argumentReferenceExpression name="args"/>
                                      </propertyReferenceExpression>
                                      <variableReferenceExpression name="saveLastCommandName"/>
                                    </assignStatement>
                                  </trueStatements>
                                </conditionStatement>
                              </trueStatements>
                            </conditionStatement>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="ValueEquality">
                                  <propertyReferenceExpression name="CommandName">
                                    <argumentReferenceExpression name="args"/>
                                  </propertyReferenceExpression>
                                  <primitiveExpression value="Delete"/>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <methodInvokeExpression methodName="Clear">
                                  <target>
                                    <propertyReferenceExpression name="Errors">
                                      <variableReferenceExpression name="result2"/>
                                    </propertyReferenceExpression>
                                  </target>
                                </methodInvokeExpression>
                                <assignStatement>
                                  <propertyReferenceExpression name="RowNotFound">
                                    <variableReferenceExpression name="result2"/>
                                  </propertyReferenceExpression>
                                  <primitiveExpression value="false"/>
                                </assignStatement>
                              </trueStatements>
                            </conditionStatement>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="IdentityInequality">
                                  <propertyReferenceExpression name="Values">
                                    <variableReferenceExpression name="result2"/>
                                  </propertyReferenceExpression>
                                  <primitiveExpression value="null"/>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <foreachStatement>
                                  <variable type="FieldValue" name="v"/>
                                  <target>
                                    <propertyReferenceExpression name="Values">
                                      <variableReferenceExpression name="result2"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <statements>
                                    <assignStatement>
                                      <propertyReferenceExpression name="Name">
                                        <variableReferenceExpression name="v"/>
                                      </propertyReferenceExpression>
                                      <stringFormatExpression format="PivotCol{{1}}_{{0}}">
                                        <propertyReferenceExpression name="Name">
                                          <variableReferenceExpression name="v"/>
                                        </propertyReferenceExpression>
                                        <variableReferenceExpression name="valueSetIndex"/>
                                      </stringFormatExpression>
                                      -->
            <!--<methodInvokeExpression methodName="Format">
                                        <target>
                                          <typeReferenceExpression type="String"/>
                                        </target>
                                        <parameters>
                                          <primitiveExpression value="PivotCol{{1}}_{{0}}"/>
                                          <propertyReferenceExpression name="Name">
                                            <variableReferenceExpression name="v"/>
                                          </propertyReferenceExpression>
                                          <variableReferenceExpression name="valueSetIndex"/>
                                        </parameters>
                                      </methodInvokeExpression>-->
            <!--
                                    </assignStatement>
                                  </statements>
                                </foreachStatement>
                              </trueStatements>
                            </conditionStatement>
                            <methodInvokeExpression methodName="Merge">
                              <target>
                                <argumentReferenceExpression name="result"/>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="result2"/>
                              </parameters>
                            </methodInvokeExpression>
                            <assignStatement>
                              <variableReferenceExpression name="valueSetIndex"/>
                              <binaryOperatorExpression operator="Add">
                                <variableReferenceExpression name="valueSetIndex"/>
                                <primitiveExpression value="1"/>
                              </binaryOperatorExpression>
                            </assignStatement>
                          </statements>
                        </foreachStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="ValueEquality">
                              <propertyReferenceExpression name="Count">
                                <propertyReferenceExpression name="Errors">
                                  <argumentReferenceExpression name="result"/>
                                </propertyReferenceExpression>
                              </propertyReferenceExpression>
                              <primitiveExpression value="0"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="Complete">
                              <target>
                                <variableReferenceExpression name="scope"/>
                              </target>
                            </methodInvokeExpression>
                          </trueStatements>
                          <falseStatements>
                            <methodInvokeExpression methodName="Rollback">
                              <target>
                                <variableReferenceExpression name="scope"/>
                              </target>
                            </methodInvokeExpression>
                          </falseStatements>
                        </conditionStatement>
                      </statements>
                    </usingStatement>
                  </statements>
                </usingStatement>
                <methodReturnStatement>
                  <primitiveExpression value="true"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>-->
            <!-- method PopulateDynamicLookups(ActionArgs, ActionResult) -->
            <memberMethod name="PopulateDynamicLookups">
              <attributes final="true"/>
              <parameters>
                <parameter type="ActionArgs" name="args"/>
                <parameter type="ActionResult" name="result"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="ViewPage" name="page">
                  <init>
                    <methodInvokeExpression methodName="CreateViewPage"/>
                  </init>
                </variableDeclarationStatement>
                <foreachStatement>
                  <variable type="DataField" name="field"/>
                  <target>
                    <propertyReferenceExpression name="Fields">
                      <variableReferenceExpression name="page"/>
                    </propertyReferenceExpression>
                  </target>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <methodInvokeExpression methodName="PopulateStaticItems">
                          <target>
                            <variableReferenceExpression name="page"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="field"/>
                            <propertyReferenceExpression name="Values">
                              <argumentReferenceExpression name="args"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <propertyReferenceExpression name="Values">
                              <argumentReferenceExpression name="result"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <objectCreateExpression type="FieldValue">
                              <parameters>
                                <propertyReferenceExpression name="Name">
                                  <variableReferenceExpression name="field"/>
                                </propertyReferenceExpression>
                                <methodInvokeExpression methodName="ToArray">
                                  <target>
                                    <propertyReferenceExpression name="Items">
                                      <variableReferenceExpression name="field"/>
                                    </propertyReferenceExpression>
                                  </target>
                                </methodInvokeExpression>
                              </parameters>
                            </objectCreateExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
              </statements>
            </memberMethod>
            <!-- method ValidateArguments(ActionArgs) -->
            <!--<memberMethod name="ValidateArguments">
              <attributes private="true"/>
              <parameters>
                <parameter type="ActionArgs" name="args"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanOr">
                      <binaryOperatorExpression operator="ValueEquality">
                        <propertyReferenceExpression name="CommandName">
                          <argumentReferenceExpression name="args"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="PopulateDynamicLookups"/>
                      </binaryOperatorExpression>
                      <binaryOperatorExpression operator="ValueEquality">
                        <propertyReferenceExpression name="CommandName">
                          <argumentReferenceExpression name="args"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="Calculate"/>
                      </binaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement/>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanOr">
                      <binaryOperatorExpression operator="ValueEquality">
                        <propertyReferenceExpression name="CommandName">
                          <argumentReferenceExpression name="args"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="ProcessImportFile"/>
                      </binaryOperatorExpression>
                      <binaryOperatorExpression operator="ValueEquality">
                        <propertyReferenceExpression name="CommandName">
                          <argumentReferenceExpression name="args"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="ExportTemplate"/>
                      </binaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement/>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanOr">
                      <binaryOperatorExpression operator="ValueEquality">
                        <propertyReferenceExpression name="CommandName">
                          <argumentReferenceExpression name="args"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="UploadFile"/>
                      </binaryOperatorExpression>
                      <binaryOperatorExpression operator="ValueEquality">
                        <propertyReferenceExpression name="CommandName">
                          <argumentReferenceExpression name="args"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="DownloadFile"/>
                      </binaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement/>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="XPathNodeIterator" name="action">
                  <init>
                    <primitiveExpression value="null"/>
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
                          <propertyReferenceExpression name="LastCommandName">
                            <argumentReferenceExpression name="args"/>
                          </propertyReferenceExpression>
                        </parameters>
                      </methodInvokeExpression>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="action"/>
                      <methodInvokeExpression methodName="Select">
                        <target>
                          <propertyReferenceExpression name="Navigator">
                            <fieldReferenceExpression name="config"/>
                          </propertyReferenceExpression>
                        </target>
                        <parameters>
                          <stringFormatExpression format="//c:action[@whenLastCommandName='{{0}}' and @commandName='{{1}}']">
                            <propertyReferenceExpression name="LastCommandName">
                              <argumentReferenceExpression name="args"/>
                            </propertyReferenceExpression>
                            <propertyReferenceExpression name="CommandName">
                              <argumentReferenceExpression name="args"/>
                            </propertyReferenceExpression>
                          </stringFormatExpression>
                          -->
            <!--<methodInvokeExpression methodName="Format">
                            <target>
                              <typeReferenceExpression type="String"/>
                            </target>
                            <parameters>
                              <primitiveExpression value="//c:action[@whenLastCommandName='{{0}}' and @commandName='{{1}}']"/>
                              <propertyReferenceExpression name="LastCommandName">
                                <argumentReferenceExpression name="args"/>
                              </propertyReferenceExpression>
                              <propertyReferenceExpression name="CommandName">
                                <argumentReferenceExpression name="args"/>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>-->
            <!--
                          <propertyReferenceExpression name="Resolver"/>
                        </parameters>
                      </methodInvokeExpression>
                    </assignStatement>
                  </trueStatements>
                  <falseStatements>
                    <assignStatement>
                      <variableReferenceExpression name="action"/>
                      <methodInvokeExpression methodName="Select">
                        <target>
                          <propertyReferenceExpression name="Navigator">
                            <fieldReferenceExpression name="config"/>
                          </propertyReferenceExpression>
                        </target>
                        <parameters>
                          <stringFormatExpression format="//c:action[not(@whenLastCommandName!='') and @commandName='{{0}}']">
                            <propertyReferenceExpression name="CommandName">
                              <argumentReferenceExpression name="args"/>
                            </propertyReferenceExpression>
                          </stringFormatExpression>
                          -->
            <!--<methodInvokeExpression methodName="Format">
                            <target>
                              <typeReferenceExpression type="String"/>
                            </target>
                            <parameters>
                              <primitiveExpression value="//c:action[not(@whenLastCommandName!='') and @commandName='{{0}}']"/>
                              <propertyReferenceExpression name="CommandName">
                                <argumentReferenceExpression name="args"/>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>-->
            <!--
                          <propertyReferenceExpression name="Resolver"/>
                        </parameters>
                      </methodInvokeExpression>
                    </assignStatement>
                  </falseStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="MoveNext">
                      <target>
                        <variableReferenceExpression name="action"/>
                      </target>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="Not">
                          <methodInvokeExpression methodName="UserIsInRole">
                            <target>
                              <typeReferenceExpression type="Controller"/>
                            </target>
                            <parameters>
                              <methodInvokeExpression methodName="GetAttribute">
                                <target>
                                  <propertyReferenceExpression name="Current">
                                    <variableReferenceExpression name="action"/>
                                  </propertyReferenceExpression>
                                </target>
                                <parameters>
                                  <primitiveExpression value="roles"/>
                                  <propertyReferenceExpression name="Empty">
                                    <typeReferenceExpression type="String"/>
                                  </propertyReferenceExpression>
                                </parameters>
                              </methodInvokeExpression>
                              -->
            <!--<castExpression targetType="System.String">
                                <methodInvokeExpression methodName="Evaluate">
                                  <target>
                                    <propertyReferenceExpression name="Current">
                                      <variableReferenceExpression name="action"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="string(@roles)"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </castExpression>-->
            <!--
                            </parameters>
                          </methodInvokeExpression>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <throwExceptionStatement>
                          <objectCreateExpression type="Exception">
                            <parameters>
                              <stringFormatExpression format="You are not authorized to execute command '{{0}}'.">
                                <propertyReferenceExpression name="CommandName">
                                  <argumentReferenceExpression name="args"/>
                                </propertyReferenceExpression>
                              </stringFormatExpression>
                              -->
            <!--<methodInvokeExpression methodName="Format">
                                <target>
                                  <typeReferenceExpression type="String"/>
                                </target>
                                <parameters>
                                  <primitiveExpression value="You are not authorized to execute command '{{0}}'."/>
                                  <propertyReferenceExpression name="CommandName">
                                    <argumentReferenceExpression name="args"/>
                                  </propertyReferenceExpression>
                                </parameters>
                              </methodInvokeExpression>-->
            <!--
                            </parameters>
                          </objectCreateExpression>
                        </throwExceptionStatement>
                      </trueStatements>
                    </conditionStatement>
                  </trueStatements>
                  <falseStatements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanOr">
                          <binaryOperatorExpression operator="ValueEquality">
                            <propertyReferenceExpression name="LastCommandName">
                              <argumentReferenceExpression name="args"/>
                            </propertyReferenceExpression>
                            <primitiveExpression value="Select"/>
                          </binaryOperatorExpression>
                          <binaryOperatorExpression operator="ValueEquality">
                            <propertyReferenceExpression name="LastCommandName">
                              <argumentReferenceExpression name="args"/>
                            </propertyReferenceExpression>
                            <primitiveExpression value="Cancel"/>
                          </binaryOperatorExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="action"/>
                          <methodInvokeExpression methodName="Select">
                            <target>
                              <propertyReferenceExpression name="Navigator">
                                <fieldReferenceExpression name="config"/>
                              </propertyReferenceExpression>
                            </target>
                            <parameters>
                              <stringFormatExpression format="//c:action[not(@whenLastCommandName!='') and @commandName='{{0}}']">
                                <propertyReferenceExpression name="CommandName">
                                  <argumentReferenceExpression name="args"/>
                                </propertyReferenceExpression>
                              </stringFormatExpression>
                              -->
            <!--<methodInvokeExpression methodName="Format">
                                <target>
                                  <typeReferenceExpression type="String"/>
                                </target>
                                <parameters>
                                  <primitiveExpression value="//c:action[not(@whenLastCommandName!='') and @commandName='{{0}}']"/>
                                  <propertyReferenceExpression name="CommandName">
                                    <argumentReferenceExpression name="args"/>
                                  </propertyReferenceExpression>
                                </parameters>
                              </methodInvokeExpression>-->
            <!--
                              <propertyReferenceExpression name="Resolver"/>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                        <conditionStatement>
                          <condition>
                            <methodInvokeExpression methodName="MoveNext">
                              <target>
                                <variableReferenceExpression name="action"/>
                              </target>
                            </methodInvokeExpression>
                          </condition>
                          <trueStatements>
                            <methodReturnStatement/>
                          </trueStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
                    <throwExceptionStatement>
                      <objectCreateExpression type="Exception">
                        <parameters>
                          <stringFormatExpression format="Unauthorized attempt to execute command '{{0}}' when last executed command name is '{{1}}'.">
                            <propertyReferenceExpression name="CommandName">
                              <argumentReferenceExpression name="args"/>
                            </propertyReferenceExpression>
                            <propertyReferenceExpression name="LastCommandName">
                              <argumentReferenceExpression name="args"/>
                            </propertyReferenceExpression>
                          </stringFormatExpression>
                          -->
            <!--<methodInvokeExpression methodName="Format">
                            <target>
                              <typeReferenceExpression type="String"/>
                            </target>
                            <parameters>
                              <primitiveExpression value="Unauthorized attempt to execute command '{{0}}' when last executed command name is '{{1}}'."/>
                              <propertyReferenceExpression name="CommandName">
                                <argumentReferenceExpression name="args"/>
                              </propertyReferenceExpression>
                              <propertyReferenceExpression name="LastCommandName">
                                <argumentReferenceExpression name="args"/>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>-->
            <!--
                        </parameters>
                      </objectCreateExpression>
                    </throwExceptionStatement>
                  </falseStatements>
                </conditionStatement>
              </statements>
            </memberMethod>-->
            <!-- 
        public static bool UserIsInRole(params System.String[] roles)
        {
            if (HttpContext.Current == null)
            	return true;
            int count = 0;
            foreach (string r in roles)
            	if (!(String.IsNullOrEmpty(r)))
                    foreach (string role in r.Split(','))
                    {
                        if (!(String.IsNullOrEmpty(role)) && HttpContext.Current.User.IsInRole(role.Trim()))
                            return true;
                        count++;
                    }
            return count == 0;
        }            -->
            <!-- method UserIsInRole(params string[])-->
            <memberMethod returnType="System.Boolean" name="UserIsInRole">
              <attributes static="true" public="true"/>
              <parameters>
                <parameter type="params System.String[]" name="roles"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="UserIsInRole">
                    <target>
                      <objectCreateExpression type="ControllerUtilities"/>
                    </target>
                    <parameters>
                      <argumentReferenceExpression name="roles"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method ExecutePostActionCommands(ActionArgs, ActionResult, DbConnection) -->
            <memberMethod name="ExecutePostActionCommands">
              <attributes private="true"/>
              <parameters>
                <parameter type="ActionArgs" name="args"/>
                <parameter type="ActionResult" name="result"/>
                <parameter type="DbConnection" name="connection"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="Not">
                      <methodInvokeExpression methodName="InTransaction">
                        <target>
                          <typeReferenceExpression type="TransactionManager"/>
                        </target>
                        <parameters>
                          <argumentReferenceExpression name="args"/>
                        </parameters>
                      </methodInvokeExpression>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="System.String" name="eventName">
                      <init>
                        <propertyReferenceExpression name="Empty">
                          <typeReferenceExpression type="String"/>
                        </propertyReferenceExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <methodInvokeExpression methodName="Equals">
                          <target>
                            <propertyReferenceExpression name="CommandName">
                              <argumentReferenceExpression name="args"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <primitiveExpression value="insert"/>
                            <propertyReferenceExpression name="OrdinalIgnoreCase">
                              <typeReferenceExpression type="StringComparison"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="eventName"/>
                          <primitiveExpression value="Inserted"/>
                        </assignStatement>
                      </trueStatements>
                      <falseStatements>
                        <conditionStatement>
                          <condition>
                            <methodInvokeExpression methodName="Equals">
                              <target>
                                <propertyReferenceExpression name="CommandName">
                                  <argumentReferenceExpression name="args"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="update"/>
                                <propertyReferenceExpression name="OrdinalIgnoreCase">
                                  <typeReferenceExpression type="StringComparison"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="eventName"/>
                              <primitiveExpression value="Updated"/>
                            </assignStatement>
                          </trueStatements>
                          <falseStatements>
                            <conditionStatement>
                              <condition>
                                <methodInvokeExpression methodName="Equals">
                                  <target>
                                    <propertyReferenceExpression name="CommandName">
                                      <argumentReferenceExpression name="args"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="delete"/>
                                    <propertyReferenceExpression name="OrdinalIgnoreCase">
                                      <typeReferenceExpression type="StringComparison"/>
                                    </propertyReferenceExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="eventName"/>
                                  <primitiveExpression value="Deleted"/>
                                </assignStatement>
                              </trueStatements>
                            </conditionStatement>
                          </falseStatements>
                        </conditionStatement>
                      </falseStatements>
                    </conditionStatement>
                    <variableDeclarationStatement type="XPathNodeIterator" name="eventCommandIterator">
                      <init>
                        <methodInvokeExpression methodName="Select">
                          <target>
                            <fieldReferenceExpression name="_config"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="/c:dataController/c:commands/c:command[@event='{{0}}']"/>
                            <variableReferenceExpression name="eventName"/>
                            <!--<stringFormatExpression format="/c:dataController/c:commands/c:command[@event='{{0}}']">
                              <variableReferenceExpression name="eventName"/>
                            </stringFormatExpression>-->
                            <!--<propertyReferenceExpression name="Resolver"/>-->
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <whileStatement>
                      <test>
                        <methodInvokeExpression methodName="MoveNext">
                          <target>
                            <variableReferenceExpression name="eventCommandIterator"/>
                          </target>
                        </methodInvokeExpression>
                      </test>
                      <statements>
                        <methodInvokeExpression methodName="ExecuteActionCommand">
                          <parameters>
                            <argumentReferenceExpression name="args"/>
                            <argumentReferenceExpression name="result"/>
                            <argumentReferenceExpression name="connection"/>
                            <propertyReferenceExpression name="Current">
                              <variableReferenceExpression name="eventCommandIterator"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </statements>
                    </whileStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="SupportsLastEnteredValues">
                      <target>
                        <objectCreateExpression type="ControllerUtilities"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="Controller">
                          <argumentReferenceExpression name="args"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanAnd">
                          <binaryOperatorExpression operator="BooleanAnd">
                            <propertyReferenceExpression name="SaveLEVs">
                              <argumentReferenceExpression name="args"/>
                            </propertyReferenceExpression>
                            <binaryOperatorExpression operator="IdentityInequality">
                              <propertyReferenceExpression name="Session">
                                <propertyReferenceExpression name="Current">
                                  <typeReferenceExpression type="HttpContext"/>
                                </propertyReferenceExpression>
                              </propertyReferenceExpression>
                              <primitiveExpression value="null"/>
                            </binaryOperatorExpression>
                          </binaryOperatorExpression>
                          <binaryOperatorExpression operator="BooleanOr">
                            <binaryOperatorExpression operator="ValueEquality">
                              <propertyReferenceExpression name="CommandName">
                                <argumentReferenceExpression name="args"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="Insert"/>
                            </binaryOperatorExpression>
                            <binaryOperatorExpression operator="ValueEquality">
                              <propertyReferenceExpression name="CommandName">
                                <argumentReferenceExpression name="args"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="Update"/>
                            </binaryOperatorExpression>
                          </binaryOperatorExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <arrayIndexerExpression>
                            <target>
                              <propertyReferenceExpression name="Session">
                                <propertyReferenceExpression name="Current">
                                  <typeReferenceExpression type="HttpContext"/>
                                </propertyReferenceExpression>
                              </propertyReferenceExpression>
                            </target>
                            <indices>
                              <stringFormatExpression format="{{0}}$LEVs">
                                <propertyReferenceExpression name="Controller">
                                  <argumentReferenceExpression name="args"/>
                                </propertyReferenceExpression>
                              </stringFormatExpression>
                              <!--<methodInvokeExpression methodName="Format">
                            <target>
                              <typeReferenceExpression type="String"/>
                            </target>
                            <parameters>
                              <primitiveExpression value="{{0}}$LEVs"/>
                              <propertyReferenceExpression name="Controller">
                                <argumentReferenceExpression name="args"/>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>-->
                            </indices>
                          </arrayIndexerExpression>
                          <propertyReferenceExpression name="Values">
                            <argumentReferenceExpression name="args"/>
                          </propertyReferenceExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                  </trueStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method ExecuteActionCommand(ActionArgs, ActionResult, DbConnection, XPathNavigator) -->
            <memberMethod name="ExecuteActionCommand">
              <attributes private="true"/>
              <parameters>
                <parameter type="ActionArgs" name="args"/>
                <parameter type="ActionResult" name="result"/>
                <parameter type="DbConnection" name="connection"/>
                <parameter type="XPathNavigator" name="commandNavigator"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="DbCommand" name="command">
                  <init>
                    <methodInvokeExpression methodName="CreateCommand">
                      <target>
                        <typeReferenceExpression type="SqlStatement"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="connection"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <xsl:if test="$EnableTransactions='true'">
                  <conditionStatement>
                    <condition>
                      <binaryOperatorExpression operator="IdentityInequality">
                        <propertyReferenceExpression name="Current">
                          <typeReferenceExpression type="SinglePhaseTransactionScope"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                    </condition>
                    <trueStatements>
                      <methodInvokeExpression methodName="Enlist">
                        <target>
                          <propertyReferenceExpression name="Current">
                            <typeReferenceExpression type="SinglePhaseTransactionScope"/>
                          </propertyReferenceExpression>
                        </target>
                        <parameters>
                          <variableReferenceExpression name="command"/>
                        </parameters>
                      </methodInvokeExpression>
                    </trueStatements>
                  </conditionStatement>
                </xsl:if>
                <assignStatement>
                  <propertyReferenceExpression name="CommandType">
                    <variableReferenceExpression name="command"/>
                  </propertyReferenceExpression>
                  <castExpression targetType="CommandType">
                    <methodInvokeExpression methodName="ConvertFromString">
                      <target>
                        <methodInvokeExpression methodName="GetConverter">
                          <target>
                            <typeReferenceExpression type="TypeDescriptor"/>
                          </target>
                          <parameters>
                            <typeofExpression type="CommandType"/>
                          </parameters>
                        </methodInvokeExpression>
                      </target>
                      <parameters>
                        <castExpression targetType="System.String">
                          <methodInvokeExpression methodName="Evaluate">
                            <target>
                              <argumentReferenceExpression name="commandNavigator"/>
                            </target>
                            <parameters>
                              <primitiveExpression value="string(@type)"/>
                            </parameters>
                          </methodInvokeExpression>
                        </castExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </castExpression>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="CommandText">
                    <variableReferenceExpression name="command"/>
                  </propertyReferenceExpression>
                  <castExpression targetType="System.String">
                    <methodInvokeExpression methodName="Evaluate">
                      <target>
                        <argumentReferenceExpression name="commandNavigator"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="string(c:text)"/>
                        <propertyReferenceExpression name="Resolver"/>
                      </parameters>
                    </methodInvokeExpression>
                  </castExpression>
                </assignStatement>
                <variableDeclarationStatement type="DbDataReader" name="reader">
                  <init>
                    <methodInvokeExpression methodName="ExecuteReader">
                      <target>
                        <variableReferenceExpression name="command"/>
                      </target>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="Read">
                      <target>
                        <variableReferenceExpression name="reader"/>
                      </target>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="System.Int32" name="outputIndex">
                      <init>
                        <primitiveExpression value="0"/>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="XPathNodeIterator" name="outputIterator">
                      <init>
                        <methodInvokeExpression methodName="Select">
                          <target>
                            <argumentReferenceExpression name="commandNavigator"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="c:output/c:*"/>
                            <propertyReferenceExpression name="Resolver"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <whileStatement>
                      <test>
                        <methodInvokeExpression methodName="MoveNext">
                          <target>
                            <variableReferenceExpression name="outputIterator"/>
                          </target>
                        </methodInvokeExpression>
                      </test>
                      <statements>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="ValueEquality">
                              <propertyReferenceExpression name="LocalName">
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="outputIterator"/>
                                </propertyReferenceExpression>
                              </propertyReferenceExpression>
                              <primitiveExpression value="fieldOutput"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <variableDeclarationStatement type="System.String" name="name">
                              <init>
                                <castExpression targetType="System.String">
                                  <methodInvokeExpression methodName="Evaluate">
                                    <target>
                                      <propertyReferenceExpression name="Current">
                                        <variableReferenceExpression name="outputIterator"/>
                                      </propertyReferenceExpression>
                                    </target>
                                    <parameters>
                                      <primitiveExpression value="string(@name)"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                </castExpression>
                              </init>
                            </variableDeclarationStatement>
                            <variableDeclarationStatement type="System.String" name="fieldName">
                              <init>
                                <castExpression targetType="System.String">
                                  <methodInvokeExpression methodName="Evaluate">
                                    <target>
                                      <propertyReferenceExpression name="Current">
                                        <variableReferenceExpression name="outputIterator"/>
                                      </propertyReferenceExpression>
                                    </target>
                                    <parameters>
                                      <primitiveExpression value="string(@fieldName)"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                </castExpression>
                              </init>
                            </variableDeclarationStatement>
                            <foreachStatement>
                              <variable type="FieldValue" name="v"/>
                              <target>
                                <propertyReferenceExpression name="Values">
                                  <variableReferenceExpression name="args"/>
                                </propertyReferenceExpression>
                              </target>
                              <statements>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="ValueEquality">
                                      <propertyReferenceExpression name="Name">
                                        <variableReferenceExpression name="v"/>
                                      </propertyReferenceExpression>
                                      <variableReferenceExpression name="fieldName"/>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <conditionStatement>
                                      <condition>
                                        <methodInvokeExpression methodName="IsNullOrEmpty">
                                          <target>
                                            <typeReferenceExpression type="String"/>
                                          </target>
                                          <parameters>
                                            <variableReferenceExpression name="name"/>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </condition>
                                      <trueStatements>
                                        <assignStatement>
                                          <propertyReferenceExpression name="NewValue">
                                            <variableReferenceExpression name="v"/>
                                          </propertyReferenceExpression>
                                          <arrayIndexerExpression>
                                            <target>
                                              <variableReferenceExpression name="reader"/>
                                            </target>
                                            <indices>
                                              <variableReferenceExpression name="outputIndex"/>
                                            </indices>
                                          </arrayIndexerExpression>
                                        </assignStatement>
                                      </trueStatements>
                                      <falseStatements>
                                        <assignStatement>
                                          <propertyReferenceExpression name="NewValue">
                                            <variableReferenceExpression name="v"/>
                                          </propertyReferenceExpression>
                                          <arrayIndexerExpression>
                                            <target>
                                              <variableReferenceExpression name="reader"/>
                                            </target>
                                            <indices>
                                              <variableReferenceExpression name="name"/>
                                            </indices>
                                          </arrayIndexerExpression>
                                        </assignStatement>
                                      </falseStatements>
                                    </conditionStatement>
                                    <conditionStatement>
                                      <condition>
                                        <binaryOperatorExpression operator="BooleanAnd">
                                          <binaryOperatorExpression operator="IdentityInequality">
                                            <propertyReferenceExpression name="NewValue">
                                              <variableReferenceExpression name="v"/>
                                            </propertyReferenceExpression>
                                            <primitiveExpression value="null"/>
                                          </binaryOperatorExpression>
                                          <binaryOperatorExpression operator="BooleanAnd">
                                            <binaryOperatorExpression operator="IdentityEquality">
                                              <methodInvokeExpression methodName="GetType">
                                                <target>
                                                  <propertyReferenceExpression name="NewValue">
                                                    <variableReferenceExpression name="v"/>
                                                  </propertyReferenceExpression>
                                                </target>
                                              </methodInvokeExpression>
                                              <typeofExpression type="System.Byte[]"/>
                                            </binaryOperatorExpression>
                                            <binaryOperatorExpression operator="ValueEquality">
                                              <propertyReferenceExpression name="Length">
                                                <castExpression targetType="System.Byte[]">
                                                  <propertyReferenceExpression name="NewValue">
                                                    <variableReferenceExpression name="v"/>
                                                  </propertyReferenceExpression>
                                                </castExpression>
                                              </propertyReferenceExpression>
                                              <primitiveExpression value="16"/>
                                            </binaryOperatorExpression>
                                          </binaryOperatorExpression>
                                        </binaryOperatorExpression>
                                      </condition>
                                      <trueStatements>
                                        <assignStatement>
                                          <propertyReferenceExpression name="NewValue">
                                            <variableReferenceExpression name="v"/>
                                          </propertyReferenceExpression>
                                          <objectCreateExpression type="Guid">
                                            <parameters>
                                              <castExpression targetType="System.Byte[]">
                                                <propertyReferenceExpression name="NewValue">
                                                  <variableReferenceExpression name="v"/>
                                                </propertyReferenceExpression>
                                              </castExpression>
                                            </parameters>
                                          </objectCreateExpression>
                                        </assignStatement>
                                      </trueStatements>
                                    </conditionStatement>
                                    <assignStatement>
                                      <propertyReferenceExpression name="Modified">
                                        <variableReferenceExpression name="v"/>
                                      </propertyReferenceExpression>
                                      <primitiveExpression value="true"/>
                                    </assignStatement>
                                    <conditionStatement>
                                      <condition>
                                        <binaryOperatorExpression operator="IdentityInequality">
                                          <argumentReferenceExpression name="result"/>
                                          <primitiveExpression value="null"/>
                                        </binaryOperatorExpression>
                                      </condition>
                                      <trueStatements>
                                        <methodInvokeExpression methodName="Add">
                                          <target>
                                            <propertyReferenceExpression name="Values">
                                              <argumentReferenceExpression name="result"/>
                                            </propertyReferenceExpression>
                                          </target>
                                          <parameters>
                                            <variableReferenceExpression name="v"/>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </trueStatements>
                                    </conditionStatement>
                                    <breakStatement/>
                                  </trueStatements>
                                </conditionStatement>
                              </statements>
                            </foreachStatement>
                          </trueStatements>
                        </conditionStatement>
                        <incrementStatement>
                          <variableReferenceExpression name="outputIndex"/>
                        </incrementStatement>
                      </statements>
                    </whileStatement>
                  </trueStatements>
                </conditionStatement>
                <methodInvokeExpression methodName="Close">
                  <target>
                    <variableReferenceExpression name="reader"/>
                  </target>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- method ExecutePreActionCommands(ActionArgs, ActionResult, DbConnection) -->
            <memberMethod name="ExecutePreActionCommands">
              <attributes private="true"/>
              <parameters>
                <parameter type="ActionArgs" name="args"/>
                <parameter type="ActionResult" name="result"/>
                <parameter type="DbConnection" name="connection"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="InTransaction">
                      <target>
                        <typeReferenceExpression type="TransactionManager"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="args"/>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement/>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="System.String" name="eventName">
                  <init>
                    <propertyReferenceExpression name="Empty">
                      <typeReferenceExpression type="String"/>
                    </propertyReferenceExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="Equals">
                      <target>
                        <propertyReferenceExpression name="CommandName">
                          <argumentReferenceExpression name="args"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <primitiveExpression value="insert"/>
                        <propertyReferenceExpression name="OrdinalIgnoreCase">
                          <typeReferenceExpression type="StringComparison"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="eventName"/>
                      <primitiveExpression value="Inserting"/>
                    </assignStatement>
                  </trueStatements>
                  <falseStatements>
                    <conditionStatement>
                      <condition>
                        <methodInvokeExpression methodName="Equals">
                          <target>
                            <propertyReferenceExpression name="CommandName">
                              <argumentReferenceExpression name="args"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <primitiveExpression value="update"/>
                            <propertyReferenceExpression name="OrdinalIgnoreCase">
                              <typeReferenceExpression type="StringComparison"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="eventName"/>
                          <primitiveExpression value="Updating"/>
                        </assignStatement>
                      </trueStatements>
                      <falseStatements>
                        <conditionStatement>
                          <condition>
                            <methodInvokeExpression methodName="Equals">
                              <target>
                                <propertyReferenceExpression name="CommandName">
                                  <argumentReferenceExpression name="args"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="delete"/>
                                <propertyReferenceExpression name="OrdinalIgnoreCase">
                                  <typeReferenceExpression type="StringComparison"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="eventName"/>
                              <primitiveExpression value="Deleting"/>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                      </falseStatements>
                    </conditionStatement>
                  </falseStatements>
                </conditionStatement>
                <variableDeclarationStatement type="XPathNodeIterator" name="eventCommandIterator">
                  <init>
                    <methodInvokeExpression methodName="Select">
                      <target>
                        <fieldReferenceExpression name="_config"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="/c:dataController/c:commands/c:command[@event='{{0}}']"/>
                        <variableReferenceExpression name="eventName"/>
                        <!--<stringFormatExpression format="/c:dataController/c:commands/c:command[@event='{{0}}']">
                          <variableReferenceExpression name="eventName"/>
                        </stringFormatExpression>-->
                        <!--<propertyReferenceExpression name="Resolver"/>-->
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <whileStatement>
                  <test>
                    <methodInvokeExpression methodName="MoveNext">
                      <target>
                        <variableReferenceExpression name="eventCommandIterator"/>
                      </target>
                    </methodInvokeExpression>
                  </test>
                  <statements>
                    <methodInvokeExpression methodName="ExecuteActionCommand">
                      <parameters>
                        <argumentReferenceExpression name="args"/>
                        <argumentReferenceExpression name="result"/>
                        <argumentReferenceExpression name="connection"/>
                        <propertyReferenceExpression name="Current">
                          <variableReferenceExpression name="eventCommandIterator"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </statements>
                </whileStatement>
              </statements>
            </memberMethod>
            <!-- method CreateConfiguration(string) -->
            <memberMethod returnType ="ControllerConfiguration" name="CreateConfiguration">
              <attributes family="true"/>
              <parameters>
                <parameter type="System.String" name="controllerName"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="CreateConfigurationInstance">
                    <target>
                      <typeReferenceExpression type="Controller"/>
                    </target>
                    <parameters>
                      <methodInvokeExpression methodName="GetType"/>
                      <argumentReferenceExpression name="controllerName"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method CreateConfigurationInstance(Type, string) -->
            <memberMethod returnType ="ControllerConfiguration" name="CreateConfigurationInstance">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="Type" name="t"/>
                <parameter type="System.String" name="controller"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.String" name="configKey">
                  <init>
                    <binaryOperatorExpression operator="Add">
                      <primitiveExpression value="DataController_"/>
                      <argumentReferenceExpression name="controller"/>
                    </binaryOperatorExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="ControllerConfiguration" name="config">
                  <init>
                    <castExpression targetType="ControllerConfiguration">
                      <arrayIndexerExpression>
                        <target>
                          <propertyReferenceExpression name="Items">
                            <propertyReferenceExpression name="Current">
                              <typeReferenceExpression type="HttpContext"/>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                        </target>
                        <indices>
                          <variableReferenceExpression name="configKey"/>
                        </indices>
                      </arrayIndexerExpression>
                    </castExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <variableReferenceExpression name="config"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <variableReferenceExpression name="config"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <assignStatement>
                  <variableReferenceExpression name="config"/>
                  <castExpression targetType="ControllerConfiguration">
                    <arrayIndexerExpression>
                      <target>
                        <propertyReferenceExpression name="Cache">
                          <typeReferenceExpression type="HttpRuntime"/>
                        </propertyReferenceExpression>
                      </target>
                      <indices>
                        <variableReferenceExpression name="configKey"/>
                      </indices>
                    </arrayIndexerExpression>
                  </castExpression>
                </assignStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <variableReferenceExpression name="config"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="Stream" name="res">
                      <init>
                        <methodInvokeExpression methodName="GetDataControllerStream">
                          <target>
                            <typeReferenceExpression type="ControllerFactory"/>
                          </target>
                          <parameters>
                            <argumentReferenceExpression name="controller"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="System.Boolean" name="allowCaching">
                      <init>
                        <binaryOperatorExpression operator="IdentityEquality">
                          <variableReferenceExpression name="res"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityEquality">
                          <variableReferenceExpression name="res"/>
                          <propertyReferenceExpression name="DefaultDataControllerStream"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="res"/>
                          <primitiveExpression value="null"/>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityEquality">
                          <variableReferenceExpression name="res"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="res"/>
                          <methodInvokeExpression methodName="GetManifestResourceStream">
                            <target>
                              <propertyReferenceExpression name="Assembly">
                                <argumentReferenceExpression name="t"/>
                              </propertyReferenceExpression>
                            </target>
                            <parameters>
                              <stringFormatExpression format="{$Namespace}.Controllers.{{0}}.xml">
                                <argumentReferenceExpression name="controller"/>
                              </stringFormatExpression>
                              <!--<methodInvokeExpression methodName="Format">
                              <target>
                                <typeReferenceExpression type="String"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="{$Namespace}.Controllers.{{0}}.xml"/>
                                <argumentReferenceExpression name="controller"/>
                              </parameters>
                            </methodInvokeExpression>-->
                            </parameters>
                          </methodInvokeExpression>

                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityEquality">
                          <variableReferenceExpression name="res"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="res"/>
                          <methodInvokeExpression methodName="GetManifestResourceStream">
                            <target>
                              <propertyReferenceExpression name="Assembly">
                                <argumentReferenceExpression name="t"/>
                              </propertyReferenceExpression>
                            </target>
                            <parameters>
                              <stringFormatExpression format="{$Namespace}.{{0}}.xml">
                                <argumentReferenceExpression name="controller"/>
                              </stringFormatExpression>
                              <!--<methodInvokeExpression methodName="Format">
                                <target>
                                  <typeReferenceExpression type="String"/>
                                </target>
                                <parameters>
                                  <primitiveExpression value="{$Namespace}.{{0}}.xml"/>
                                  <argumentReferenceExpression name="controller"/>
                                </parameters>
                              </methodInvokeExpression>-->
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityEquality">
                          <variableReferenceExpression name="res"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="System.String" name="controllerPath">
                          <init>
                            <methodInvokeExpression methodName="Combine">
                              <target>
                                <typeReferenceExpression type="Path"/>
                              </target>
                              <parameters>
                                <methodInvokeExpression methodName="Combine">
                                  <target>
                                    <typeReferenceExpression type="Path"/>
                                  </target>
                                  <parameters>
                                    <propertyReferenceExpression name="AppDomainAppPath">
                                      <typeReferenceExpression type="HttpRuntime"/>
                                    </propertyReferenceExpression>
                                    <primitiveExpression value="Controllers"/>
                                  </parameters>
                                </methodInvokeExpression>
                                <binaryOperatorExpression operator="Add">
                                  <argumentReferenceExpression name="controller"/>
                                  <primitiveExpression value=".xml"/>
                                </binaryOperatorExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <unaryOperatorExpression operator="Not">
                              <methodInvokeExpression methodName="Exists">
                                <target>
                                  <typeReferenceExpression type="File"/>
                                </target>
                                <parameters>
                                  <variableReferenceExpression name="controllerPath"/>
                                </parameters>
                              </methodInvokeExpression>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <throwExceptionStatement>
                              <objectCreateExpression type="Exception">
                                <parameters>
                                  <stringFormatExpression format="Controller '{{0}}' does not exist.">
                                    <argumentReferenceExpression name="controller"/>
                                  </stringFormatExpression>
                                  <!--<methodInvokeExpression methodName="Format">
                                    <target>
                                      <typeReferenceExpression type="String"/>
                                    </target>
                                    <parameters>
                                      <primitiveExpression value="Controller '{{0}}' does not exist."/>
                                      <argumentReferenceExpression name="controller"/>
                                    </parameters>
                                  </methodInvokeExpression>-->
                                </parameters>
                              </objectCreateExpression>
                            </throwExceptionStatement>
                          </trueStatements>
                        </conditionStatement>
                        <assignStatement>
                          <variableReferenceExpression name="config"/>
                          <objectCreateExpression type="ControllerConfiguration">
                            <parameters>
                              <variableReferenceExpression name="controllerPath"/>
                            </parameters>
                          </objectCreateExpression>
                        </assignStatement>
                        <conditionStatement>
                          <condition>
                            <variableReferenceExpression name="allowCaching"/>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="Insert">
                              <target>
                                <propertyReferenceExpression name="Cache">
                                  <typeReferenceExpression type="HttpRuntime"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="configKey"/>
                                <variableReferenceExpression name="config"/>
                                <objectCreateExpression type="CacheDependency">
                                  <parameters>
                                    <variableReferenceExpression name="controllerPath"/>
                                  </parameters>
                                </objectCreateExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>
                      </trueStatements>
                      <falseStatements>
                        <assignStatement>
                          <variableReferenceExpression name="config"/>
                          <objectCreateExpression type="ControllerConfiguration">
                            <parameters>
                              <variableReferenceExpression name="res"/>
                            </parameters>
                          </objectCreateExpression>
                        </assignStatement>
                        <conditionStatement>
                          <condition>
                            <variableReferenceExpression name="allowCaching"/>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="Insert">
                              <target>
                                <propertyReferenceExpression name="Cache">
                                  <typeReferenceExpression type="HttpRuntime"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="configKey"/>
                                <variableReferenceExpression name="config"/>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>
                      </falseStatements>
                    </conditionStatement>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="System.Boolean" name="requiresLocalization">
                  <init>
                    <propertyReferenceExpression name="RequiresLocalization">
                      <variableReferenceExpression name="config"/>
                    </propertyReferenceExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <propertyReferenceExpression name="UsesVariables">
                      <variableReferenceExpression name="config"/>
                    </propertyReferenceExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="config"/>
                      <methodInvokeExpression methodName="Clone">
                        <target>
                          <variableReferenceExpression name="config"/>
                        </target>
                      </methodInvokeExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <assignStatement>
                  <variableReferenceExpression name="config"/>
                  <methodInvokeExpression methodName="EnsureVitalElements">
                    <target>
                      <variableReferenceExpression name="config"/>
                    </target>
                  </methodInvokeExpression>
                </assignStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <propertyReferenceExpression name="PlugIn">
                        <variableReferenceExpression name="config"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="config"/>
                      <methodInvokeExpression methodName="Create">
                        <target>
                          <propertyReferenceExpression name="PlugIn">
                            <variableReferenceExpression name="config"/>
                          </propertyReferenceExpression>
                        </target>
                        <parameters>
                          <variableReferenceExpression name="config"/>
                        </parameters>
                      </methodInvokeExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <variableReferenceExpression name="requiresLocalization"/>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="config"/>
                      <methodInvokeExpression methodName="Localize">
                        <target>
                          <variableReferenceExpression name="config"/>
                        </target>
                        <parameters>
                          <argumentReferenceExpression name="controller"/>
                        </parameters>
                      </methodInvokeExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <xsl:if test="$IsPremium='true'">
                  <conditionStatement>
                    <condition>
                      <methodInvokeExpression methodName="RequiresVirtualization">
                        <target>
                          <variableReferenceExpression name="config"/>
                        </target>
                        <parameters>
                          <argumentReferenceExpression name="controller"/>
                        </parameters>
                      </methodInvokeExpression>
                    </condition>
                    <trueStatements>
                      <assignStatement>
                        <variableReferenceExpression name="config"/>
                        <methodInvokeExpression methodName="Virtualize">
                          <target>
                            <variableReferenceExpression name="config"/>
                          </target>
                          <parameters>
                            <argumentReferenceExpression name="controller"/>
                          </parameters>
                        </methodInvokeExpression>
                      </assignStatement>
                    </trueStatements>
                  </conditionStatement>
                </xsl:if>
                <methodInvokeExpression methodName="Complete">
                  <target>
                    <variableReferenceExpression name="config"/>
                  </target>
                </methodInvokeExpression>
                <assignStatement>
                  <arrayIndexerExpression>
                    <target>
                      <propertyReferenceExpression name="Items">
                        <propertyReferenceExpression name="Current">
                          <typeReferenceExpression type="HttpContext"/>
                        </propertyReferenceExpression>
                      </propertyReferenceExpression>
                    </target>
                    <indices>
                      <variableReferenceExpression name="configKey"/>
                    </indices>
                  </arrayIndexerExpression>
                  <variableReferenceExpression name="config"/>
                </assignStatement>
                <methodReturnStatement>
                  <variableReferenceExpression name="config"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- property ViewOverridingDisabled -->
            <memberField type="System.Boolean" name="viewOverridingDisabled"/>
            <memberProperty type="System.Boolean" name="ViewOverridingDisabled">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="viewOverridingDisabled"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="viewOverridingDisabled"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- method SelectView(string, string) -->
            <memberMethod name="SelectView">
              <attributes public="true" />
              <parameters>
                <parameter type="System.String" name="controller"/>
                <parameter type="System.String" name="view"/>
              </parameters>
              <statements>
                <assignStatement>
                  <fieldReferenceExpression name="config"/>
                  <methodInvokeExpression methodName="CreateConfiguration">
                    <parameters>
                      <argumentReferenceExpression name="controller"/>
                    </parameters>
                  </methodInvokeExpression>
                </assignStatement>
                <variableDeclarationStatement type="XPathNodeIterator" name="iterator">
                  <init>
                    <primitiveExpression value="null"/>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="IsNullOrEmpty">
                      <target>
                        <typeReferenceExpression type="String"/>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="view"/>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="iterator"/>
                      <methodInvokeExpression methodName="Select">
                        <target>
                          <fieldReferenceExpression name="config"/>
                        </target>
                        <parameters>
                          <primitiveExpression value="/c:dataController/c:views/c:view[1]"/>
                          <!--<propertyReferenceExpression name="Resolver"/>-->
                        </parameters>
                      </methodInvokeExpression>
                    </assignStatement>
                  </trueStatements>
                  <falseStatements>
                    <assignStatement>
                      <variableReferenceExpression name="iterator"/>
                      <methodInvokeExpression methodName="Select">
                        <target>
                          <fieldReferenceExpression name="config"/>
                        </target>
                        <parameters>
                          <primitiveExpression value="/c:dataController/c:views/c:view[@id='{{0}}']"/>
                          <argumentReferenceExpression name="view"/>
                        </parameters>
                      </methodInvokeExpression>
                    </assignStatement>
                  </falseStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="Not">
                      <methodInvokeExpression methodName="MoveNext">
                        <target>
                          <variableReferenceExpression name="iterator"/>
                        </target>
                      </methodInvokeExpression>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <throwExceptionStatement>
                      <objectCreateExpression type="Exception">
                        <parameters>
                          <stringFormatExpression format="The view '{{0}}' does not exist.">
                            <argumentReferenceExpression name="view"/>
                          </stringFormatExpression>
                        </parameters>
                      </objectCreateExpression>
                    </throwExceptionStatement>
                  </trueStatements>
                </conditionStatement>
                <assignStatement>
                  <fieldReferenceExpression name="view"/>
                  <propertyReferenceExpression name="Current">
                    <variableReferenceExpression name="iterator"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="viewId"/>
                  <methodInvokeExpression methodName="GetAttribute">
                    <target>
                      <propertyReferenceExpression name="Current">
                        <variableReferenceExpression name="iterator"/>
                      </propertyReferenceExpression>
                    </target>
                    <parameters>
                      <primitiveExpression value="id"/>
                      <propertyReferenceExpression name="Empty">
                        <typeReferenceExpression type="String"/>
                      </propertyReferenceExpression>
                    </parameters>
                  </methodInvokeExpression>
                </assignStatement>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="Not">
                      <propertyReferenceExpression name="ViewOverridingDisabled"/>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="XPathNodeIterator" name="overrideIterator">
                      <init>
                        <methodInvokeExpression methodName="Select">
                          <target>
                            <fieldReferenceExpression name="config"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="/c:dataController/c:views/c:view[@virtualViewId='{{0}}']"/>
                            <fieldReferenceExpression name="viewId"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <whileStatement>
                      <test>
                        <methodInvokeExpression methodName="MoveNext">
                          <target>
                            <variableReferenceExpression name="overrideIterator"/>
                          </target>
                        </methodInvokeExpression>
                      </test>
                      <statements>
                        <variableDeclarationStatement type="System.String" name="viewId">
                          <init>
                            <methodInvokeExpression methodName="GetAttribute">
                              <target>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="overrideIterator"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="id"/>
                                <propertyReferenceExpression name="Empty">
                                  <typeReferenceExpression type="String"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <variableDeclarationStatement type="BusinessRules" name="rules">
                          <init>
                            <methodInvokeExpression methodName="CreateBusinessRules">
                              <target>
                                <fieldReferenceExpression name="config"/>
                              </target>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="BooleanAnd">
                              <binaryOperatorExpression operator="IdentityInequality">
                                <variableReferenceExpression name="rules"/>
                                <primitiveExpression value="null"/>
                              </binaryOperatorExpression>
                              <methodInvokeExpression methodName="IsOverrideApplicable">
                                <target>
                                  <variableReferenceExpression name="rules"/>
                                </target>
                                <parameters>
                                  <variableReferenceExpression name="controller"/>
                                  <variableReferenceExpression name="viewId"/>
                                  <fieldReferenceExpression name="viewId"/>
                                </parameters>
                              </methodInvokeExpression>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <fieldReferenceExpression name="view"/>
                              <propertyReferenceExpression name="Current">
                                <variableReferenceExpression name="overrideIterator"/>
                              </propertyReferenceExpression>
                            </assignStatement>
                            <breakStatement/>
                          </trueStatements>
                        </conditionStatement>
                      </statements>
                    </whileStatement>
                  </trueStatements>
                </conditionStatement>
                <assignStatement>
                  <fieldReferenceExpression name="viewType"/>
                  <methodInvokeExpression methodName="GetAttribute">
                    <target>
                      <propertyReferenceExpression name="Current">
                        <variableReferenceExpression name="iterator"/>
                      </propertyReferenceExpression>
                    </target>
                    <parameters>
                      <primitiveExpression value="type"/>
                      <propertyReferenceExpression name="Empty">
                        <typeReferenceExpression type="String"/>
                      </propertyReferenceExpression>
                    </parameters>
                  </methodInvokeExpression>
                </assignStatement>
                <variableDeclarationStatement type="System.String" name="accessType">
                  <init>
                    <methodInvokeExpression methodName="GetAttribute">
                      <target>
                        <propertyReferenceExpression name="Current">
                          <variableReferenceExpression name="iterator"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <primitiveExpression value="access"/>
                        <propertyReferenceExpression name="Empty">
                          <typeReferenceExpression type="String"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="IsNullOrEmpty">
                      <variableReferenceExpression name="accessType"/>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="accessType"/>
                      <primitiveExpression value="Private"/>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="Not">
                      <methodInvokeExpression methodName="ValidateViewAccess">
                        <parameters>
                          <argumentReferenceExpression name="controller"/>
                          <fieldReferenceExpression name="viewId"/>
                          <variableReferenceExpression name="accessType"/>
                        </parameters>
                      </methodInvokeExpression>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <throwExceptionStatement>
                      <objectCreateExpression type="Exception">
                        <parameters>
                          <stringFormatExpression>
                            <xsl:attribute name="format"><![CDATA[Not authorized to access private view '{0}' in data controller '{1}'. Set 'Access' property of the view to 'Public' or enable 'Idle User Detection' to automatically logout user after a period of inactivity.]]></xsl:attribute>
                            <fieldReferenceExpression name="viewId"/>
                            <argumentReferenceExpression name="controller"/>
                          </stringFormatExpression>
                        </parameters>
                      </objectCreateExpression>
                    </throwExceptionStatement>
                  </trueStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method CreateConnection() -->
            <memberMethod returnType="DbConnection" name="CreateConnection">
              <attributes family="true"/>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="CreateConnection">
                    <parameters>
                      <primitiveExpression value="true"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method CreateConnection() -->
            <memberMethod returnType="DbConnection" name="CreateConnection">
              <attributes family="true"/>
              <parameters>
                <parameter type="System.Boolean" name="open"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="ConnectionStringSettings" name="settings">
                  <init>
                    <methodInvokeExpression methodName="Create">
                      <target>
                        <typeReferenceExpression type="ConnectionStringSettingsFactory"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="ConnectionStringName">
                          <fieldReferenceExpression name="config"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <!--<arrayIndexerExpression>
                      <target>
                        <propertyReferenceExpression name="ConnectionStrings">
                          <typeReferenceExpression type="WebConfigurationManager"/>
                        </propertyReferenceExpression>
                      </target>
                      <indices>
                        <propertyReferenceExpression name="ConnectionStringName">
                          <fieldReferenceExpression name="config"/>
                        </propertyReferenceExpression>
                      </indices>
                    </arrayIndexerExpression>-->
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <variableReferenceExpression name="settings"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <throwExceptionStatement>
                      <objectCreateExpression type="Exception">
                        <parameters>
                          <stringFormatExpression format="Connection string '{{0}}' is not defined in web.config of this application.">
                            <propertyReferenceExpression name="ConnectionStringName">
                              <fieldReferenceExpression name="config"/>
                            </propertyReferenceExpression>
                          </stringFormatExpression>
                          <!--<methodInvokeExpression methodName="Format">
                            <target>
                              <typeReferenceExpression type="String"/>
                            </target>
                            <parameters>
                              <primitiveExpression value="Connection string '{{0}}' is not defined in web.config of this application."/>
                              <propertyReferenceExpression name="ConnectionStringName">
                                <fieldReferenceExpression name="config"/>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>-->
                        </parameters>
                      </objectCreateExpression>
                    </throwExceptionStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <propertyReferenceExpression name="ProviderName">
                        <variableReferenceExpression name="settings"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="CodeOnTime.CustomDataProvider"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <argumentReferenceExpression name="open"/>
                      <primitiveExpression value="false"/>
                    </assignStatement>
                    <assignStatement>
                      <variableReferenceExpression name="settings"/>
                      <objectCreateExpression type="ConnectionStringSettings">
                        <parameters>
                          <primitiveExpression value="CustomDataProvider"/>
                          <primitiveExpression value=""/>
                          <primitiveExpression value="System.Data.SqlClient"/>
                        </parameters>
                      </objectCreateExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="DbProviderFactory" name="factory">
                  <init>
                    <methodInvokeExpression methodName="GetFactory">
                      <target>
                        <typeReferenceExpression type="DbProviderFactories"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="ProviderName">
                          <variableReferenceExpression name="settings"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="DbConnection" name="connection">
                  <init>
                    <methodInvokeExpression methodName="CreateConnection">
                      <target>
                        <variableReferenceExpression name="factory"/>
                      </target>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.String" name="connectionString">
                  <init>
                    <propertyReferenceExpression name="ConnectionString">
                      <variableReferenceExpression name="settings"/>
                    </propertyReferenceExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="SupportsLimitInSelect">
                      <parameters>
                        <variableReferenceExpression name="connection"/>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="connectionString"/>
                      <binaryOperatorExpression operator="Add">
                        <variableReferenceExpression name="connectionString"/>
                        <primitiveExpression value="Allow User Variables=True"/>
                      </binaryOperatorExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <assignStatement>
                  <propertyReferenceExpression name="ConnectionString">
                    <variableReferenceExpression name="connection"/>
                  </propertyReferenceExpression>
                  <variableReferenceExpression name="connectionString"/>
                </assignStatement>
                <conditionStatement>
                  <condition>
                    <argumentReferenceExpression name="open"/>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="Open">
                      <target>
                        <variableReferenceExpression name="connection"/>
                      </target>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <assignStatement>
                  <fieldReferenceExpression name="parameterMarker"/>
                  <methodInvokeExpression methodName="ConvertTypeToParameterMarker">
                    <target>
                      <typeReferenceExpression type="SqlStatement"/>
                    </target>
                    <parameters>
                      <propertyReferenceExpression name="ProviderName">
                        <variableReferenceExpression name="settings"/>
                      </propertyReferenceExpression>
                    </parameters>
                  </methodInvokeExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="leftQuote"/>
                  <methodInvokeExpression methodName="ConvertTypeToLeftQuote">
                    <target>
                      <typeReferenceExpression type="SqlStatement"/>
                    </target>
                    <parameters>
                      <propertyReferenceExpression name="ProviderName">
                        <variableReferenceExpression name="settings"/>
                      </propertyReferenceExpression>
                    </parameters>
                  </methodInvokeExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="rightQuote"/>
                  <methodInvokeExpression methodName="ConvertTypeToRightQuote">
                    <target>
                      <typeReferenceExpression type="SqlStatement"/>
                    </target>
                    <parameters>
                      <propertyReferenceExpression name="ProviderName">
                        <variableReferenceExpression name="settings"/>
                      </propertyReferenceExpression>
                    </parameters>
                  </methodInvokeExpression>
                </assignStatement>
                <methodReturnStatement>
                  <variableReferenceExpression name="connection"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method CreateCommand(DbConnection)-->
            <memberMethod returnType="DbCommand" name="CreateCommand">
              <attributes family="true" />
              <parameters>
                <parameter type="DbConnection" name="connection"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="CreateCommand">
                    <parameters>
                      <argumentReferenceExpression name="connection"/>
                      <primitiveExpression value="null"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method CreateCommand(DbConnection, args)-->
            <memberMethod returnType="DbCommand" name="CreateCommand">
              <attributes family="true" />
              <parameters>
                <parameter type="DbConnection" name="connection"/>
                <parameter type="ActionArgs" name="args"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.String" name="commandId">
                  <init>
                    <methodInvokeExpression methodName="GetAttribute">
                      <target>
                        <fieldReferenceExpression name="view"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="commandId"/>
                        <propertyReferenceExpression name="Empty">
                          <typeReferenceExpression type="String"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="XPathNavigator" name="commandNav">
                  <init>
                    <methodInvokeExpression methodName="SelectSingleNode">
                      <target>
                        <fieldReferenceExpression name="config"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="/c:dataController/c:commands/c:command[@id='{{0}}']"/>
                        <variableReferenceExpression name="commandId"/>
                        <!--<stringFormatExpression format="/c:dataController/c:commands/c:command[@id='{{0}}']">
                          <variableReferenceExpression name="commandId"/>
                        </stringFormatExpression>-->
                        <!--<propertyReferenceExpression name="Resolver"/>-->
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <binaryOperatorExpression operator="IdentityInequality">
                        <argumentReferenceExpression name="args"/>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                      <unaryOperatorExpression operator="Not">
                        <methodInvokeExpression methodName="IsNullOrEmpty">
                          <target>
                            <typeReferenceExpression type="String"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="CommandArgument">
                              <argumentReferenceExpression name="args"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </unaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="XPathNavigator" name="commandNav2">
                      <init>
                        <methodInvokeExpression methodName="SelectSingleNode">
                          <target>
                            <fieldReferenceExpression name="config"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="/c:dataController/c:commands/c:command[@id='{{0}}']"/>
                            <propertyReferenceExpression name="CommandArgument">
                              <argumentReferenceExpression name="args"/>
                            </propertyReferenceExpression>
                            <!--<stringFormatExpression format="/c:dataController/c:commands/c:command[@id='{{0}}']">
                              <propertyReferenceExpression name="CommandArgument">
                                <argumentReferenceExpression name="args"/>
                              </propertyReferenceExpression>
                            </stringFormatExpression>-->
                            <!--<propertyReferenceExpression name="Resolver"/>-->
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityInequality">
                          <variableReferenceExpression name="commandNav2"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="commandNav"/>
                          <variableReferenceExpression name="commandNav2"/>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <variableReferenceExpression name="commandNav"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="null"/>
                    </methodReturnStatement>
                    <!--<throwExceptionStatement>
                      <objectCreateExpression type="Exception">
                        <parameters>
                          <stringFormatExpression format="Command {{0}} does not exist.">
                            <variableReferenceExpression name="commandId"/>
                          </stringFormatExpression>
                        </parameters>
                      </objectCreateExpression>
                    </throwExceptionStatement>-->
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="DbCommand" name="command">
                  <init>
                    <methodInvokeExpression methodName="CreateCommand">
                      <target>
                        <typeReferenceExpression type="SqlStatement"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="connection"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <propertyReferenceExpression name="Current">
                        <typeReferenceExpression type="SinglePhaseTransactionScope"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="Enlist">
                      <target>
                        <propertyReferenceExpression name="Current">
                          <typeReferenceExpression type="SinglePhaseTransactionScope"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="command"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="System.String" name="theCommandType">
                  <init>
                    <methodInvokeExpression methodName="GetAttribute">
                      <target>
                        <variableReferenceExpression name="commandNav"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="type"/>
                        <propertyReferenceExpression name="Empty">
                          <typeReferenceExpression type="System.String"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="IsNotNullOrEmpty">
                      <variableReferenceExpression name="theCommandType"/>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <propertyReferenceExpression name="CommandType">
                        <variableReferenceExpression name="command"/>
                      </propertyReferenceExpression>
                      <castExpression targetType="CommandType">
                        <methodInvokeExpression methodName="ConvertFromString">
                          <target>
                            <methodInvokeExpression methodName="GetConverter">
                              <target>
                                <typeReferenceExpression type="TypeDescriptor"/>
                              </target>
                              <parameters>
                                <typeofExpression type="CommandType"/>
                              </parameters>
                            </methodInvokeExpression>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="theCommandType"/>
                          </parameters>
                        </methodInvokeExpression>
                      </castExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <assignStatement>
                  <propertyReferenceExpression name="CommandText">
                    <variableReferenceExpression name="command"/>
                  </propertyReferenceExpression>
                  <castExpression targetType="System.String">
                    <methodInvokeExpression methodName="Evaluate">
                      <target>
                        <variableReferenceExpression name="commandNav"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="string(c:text)"/>
                        <propertyReferenceExpression name="Resolver"/>
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
                        <propertyReferenceExpression name="CommandText">
                          <variableReferenceExpression name="command"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <propertyReferenceExpression name="CommandText">
                        <variableReferenceExpression name="command"/>
                      </propertyReferenceExpression>
                      <propertyReferenceExpression name="InnerXml">
                        <variableReferenceExpression name="commandNav"/>
                      </propertyReferenceExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <xsl:choose>
                  <xsl:when test="$IsPremium!='true'">
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanOr">
                          <binaryOperatorExpression operator="ValueEquality">
                            <propertyReferenceExpression name="CommandType">
                              <variableReferenceExpression name="command"/>
                            </propertyReferenceExpression>
                            <propertyReferenceExpression name="StoredProcedure">
                              <typeReferenceExpression type="CommandType"/>
                            </propertyReferenceExpression>
                          </binaryOperatorExpression>
                          <methodInvokeExpression methodName="MoveNext">
                            <target>
                              <methodInvokeExpression methodName="Select">
                                <target>
                                  <variableReferenceExpression name="commandNav"/>
                                </target>
                                <parameters>
                                  <primitiveExpression value="c:parameters/c:parameter"/>
                                  <propertyReferenceExpression name="Resolver"/>
                                </parameters>
                              </methodInvokeExpression>
                            </target>
                          </methodInvokeExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <throwExceptionStatement>
                          <objectCreateExpression type="Exception">
                            <parameters>
                              <primitiveExpression value="Commands of type Stored Procedure and command parameters are available in Premium edition only."/>
                            </parameters>
                          </objectCreateExpression>
                        </throwExceptionStatement>
                      </trueStatements>
                    </conditionStatement>
                  </xsl:when>
                  <xsl:otherwise>
                    <variableDeclarationStatement type="IActionHandler" name="handler">
                      <init>
                        <methodInvokeExpression methodName="CreateActionHandler">
                          <target>
                            <fieldReferenceExpression name="config"/>
                          </target>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="XPathNodeIterator" name="parameterIterator">
                      <init>
                        <methodInvokeExpression methodName="Select">
                          <target>
                            <variableReferenceExpression name="commandNav"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="c:parameters/c:parameter"/>
                            <propertyReferenceExpression name="Resolver"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="SortedDictionary" name="missingFields">
                      <typeArguments>
                        <typeReference type="System.String"/>
                        <typeReference type="System.String"/>
                      </typeArguments>
                      <init>
                        <primitiveExpression value="null"/>
                      </init>
                    </variableDeclarationStatement>
                    <whileStatement>
                      <test>
                        <methodInvokeExpression methodName="MoveNext">
                          <target>
                            <variableReferenceExpression name="parameterIterator"/>
                          </target>
                        </methodInvokeExpression>
                      </test>
                      <statements>
                        <variableDeclarationStatement type="DbParameter" name="parameter">
                          <init>
                            <methodInvokeExpression methodName="CreateParameter">
                              <target>
                                <variableReferenceExpression name="command"/>
                              </target>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <assignStatement>
                          <propertyReferenceExpression name="ParameterName">
                            <variableReferenceExpression name="parameter"/>
                          </propertyReferenceExpression>
                          <methodInvokeExpression methodName="GetAttribute">
                            <target>
                              <propertyReferenceExpression name="Current">
                                <variableReferenceExpression name="parameterIterator"/>
                              </propertyReferenceExpression>
                            </target>
                            <parameters>
                              <primitiveExpression value="name"/>
                              <propertyReferenceExpression name="Empty">
                                <typeReferenceExpression type="String"/>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                        <variableDeclarationStatement type="System.String" name="s">
                          <init>
                            <methodInvokeExpression methodName="GetAttribute">
                              <target>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="parameterIterator"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="type"/>
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
                              <propertyReferenceExpression name="DbType">
                                <variableReferenceExpression name="parameter"/>
                              </propertyReferenceExpression>
                              <castExpression targetType="DbType">
                                <methodInvokeExpression methodName="ConvertFromString">
                                  <target>
                                    <methodInvokeExpression methodName="GetConverter">
                                      <target>
                                        <typeReferenceExpression type="TypeDescriptor"/>
                                      </target>
                                      <parameters>
                                        <typeofExpression type="DbType"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </target>
                                  <parameters>
                                    <variableReferenceExpression name="s"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </castExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <assignStatement>
                          <variableReferenceExpression name="s"/>
                          <methodInvokeExpression methodName="GetAttribute">
                            <target>
                              <propertyReferenceExpression name="Current">
                                <variableReferenceExpression name="parameterIterator"/>
                              </propertyReferenceExpression>
                            </target>
                            <parameters>
                              <primitiveExpression value="direction"/>
                              <propertyReferenceExpression name="Empty">
                                <typeReferenceExpression type="String"/>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>
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
                              <propertyReferenceExpression name="Direction">
                                <variableReferenceExpression name="parameter"/>
                              </propertyReferenceExpression>
                              <castExpression targetType="ParameterDirection">
                                <methodInvokeExpression methodName="ConvertFromString">
                                  <target>
                                    <methodInvokeExpression methodName="GetConverter">
                                      <target>
                                        <typeReferenceExpression type="TypeDescriptor"/>
                                      </target>
                                      <parameters>
                                        <typeofExpression type="ParameterDirection"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </target>
                                  <parameters>
                                    <variableReferenceExpression name="s"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </castExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <propertyReferenceExpression name="Parameters">
                              <variableReferenceExpression name="command"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="parameter"/>
                          </parameters>
                        </methodInvokeExpression>
                        <assignStatement>
                          <variableReferenceExpression name="s"/>
                          <methodInvokeExpression methodName="GetAttribute">
                            <target>
                              <propertyReferenceExpression name="Current">
                                <variableReferenceExpression name="parameterIterator"/>
                              </propertyReferenceExpression>
                            </target>
                            <parameters>
                              <primitiveExpression value="defaultValue"/>
                              <propertyReferenceExpression name="Empty">
                                <typeReferenceExpression type="String"/>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>
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
                              <propertyReferenceExpression name="Value">
                                <variableReferenceExpression name="parameter"/>
                              </propertyReferenceExpression>
                              <variableReferenceExpression name="s"/>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <assignStatement>
                          <variableReferenceExpression name="s"/>
                          <methodInvokeExpression methodName="GetAttribute">
                            <target>
                              <propertyReferenceExpression name="Current">
                                <variableReferenceExpression name="parameterIterator"/>
                              </propertyReferenceExpression>
                            </target>
                            <parameters>
                              <primitiveExpression value="fieldName"/>
                              <propertyReferenceExpression name="Empty">
                                <typeReferenceExpression type="String"/>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="BooleanAnd">
                              <binaryOperatorExpression operator="IdentityInequality">
                                <argumentReferenceExpression name="args"/>
                                <primitiveExpression value="null"/>
                              </binaryOperatorExpression>
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
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <variableDeclarationStatement type="FieldValue" name="v">
                              <init>
                                <methodInvokeExpression methodName="SelectFieldValueObject">
                                  <target>
                                    <variableReferenceExpression name="args"/>
                                  </target>
                                  <parameters>
                                    <variableReferenceExpression name="s"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </init>
                            </variableDeclarationStatement>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="IdentityInequality">
                                  <variableReferenceExpression name="v"/>
                                  <primitiveExpression value="null"/>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="s"/>
                                  <methodInvokeExpression methodName="GetAttribute">
                                    <target>
                                      <propertyReferenceExpression name="Current">
                                        <variableReferenceExpression name="parameterIterator"/>
                                      </propertyReferenceExpression>
                                    </target>
                                    <parameters>
                                      <primitiveExpression value="fieldValue"/>
                                      <propertyReferenceExpression name="Empty">
                                        <typeReferenceExpression type="String"/>
                                      </propertyReferenceExpression>
                                    </parameters>
                                  </methodInvokeExpression>
                                </assignStatement>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="ValueEquality">
                                      <variableReferenceExpression name="s"/>
                                      <primitiveExpression value="Old"/>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <assignStatement>
                                      <propertyReferenceExpression name="Value">
                                        <variableReferenceExpression name="parameter"/>
                                      </propertyReferenceExpression>
                                      <propertyReferenceExpression name="OldValue">
                                        <variableReferenceExpression name="v"/>
                                      </propertyReferenceExpression>
                                    </assignStatement>
                                  </trueStatements>
                                  <falseStatements>
                                    <conditionStatement>
                                      <condition>
                                        <binaryOperatorExpression operator="ValueEquality">
                                          <variableReferenceExpression name="s"/>
                                          <primitiveExpression value="New"/>
                                        </binaryOperatorExpression>
                                      </condition>
                                      <trueStatements>
                                        <assignStatement>
                                          <propertyReferenceExpression name="Value">
                                            <variableReferenceExpression name="parameter"/>
                                          </propertyReferenceExpression>
                                          <propertyReferenceExpression name="NewValue">
                                            <variableReferenceExpression name="v"/>
                                          </propertyReferenceExpression>
                                        </assignStatement>
                                      </trueStatements>
                                      <falseStatements>
                                        <assignStatement>
                                          <propertyReferenceExpression name="Value">
                                            <variableReferenceExpression name="parameter"/>
                                          </propertyReferenceExpression>
                                          <propertyReferenceExpression name="Value">
                                            <variableReferenceExpression name="v"/>
                                          </propertyReferenceExpression>
                                        </assignStatement>
                                      </falseStatements>
                                    </conditionStatement>
                                  </falseStatements>
                                </conditionStatement>
                              </trueStatements>
                              <falseStatements>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="IdentityEquality">
                                      <variableReferenceExpression name="missingFields"/>
                                      <primitiveExpression value="null"/>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <assignStatement>
                                      <variableReferenceExpression name="missingFields"/>
                                      <objectCreateExpression type="SortedDictionary">
                                        <typeArguments>
                                          <typeReference type="System.String"/>
                                          <typeReference type="System.String"/>
                                        </typeArguments>
                                      </objectCreateExpression>
                                    </assignStatement>
                                  </trueStatements>
                                </conditionStatement>
                                <methodInvokeExpression methodName="Add">
                                  <target>
                                    <variableReferenceExpression name="missingFields"/>
                                  </target>
                                  <parameters>
                                    <propertyReferenceExpression name="ParameterName">
                                      <variableReferenceExpression name="parameter"/>
                                    </propertyReferenceExpression>
                                    <variableReferenceExpression name="s"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </falseStatements>
                            </conditionStatement>
                          </trueStatements>
                        </conditionStatement>
                        <assignStatement>
                          <variableReferenceExpression name="s"/>
                          <methodInvokeExpression methodName="GetAttribute">
                            <target>
                              <propertyReferenceExpression name="Current">
                                <variableReferenceExpression name="parameterIterator"/>
                              </propertyReferenceExpression>
                            </target>
                            <parameters>
                              <primitiveExpression value="propertyName"/>
                              <propertyReferenceExpression name="Empty">
                                <typeReferenceExpression type="String"/>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="BooleanAnd">
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
                              <binaryOperatorExpression operator="IdentityInequality">
                                <variableReferenceExpression name="handler"/>
                                <primitiveExpression value="null"/>
                              </binaryOperatorExpression>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <variableDeclarationStatement type="System.Object" name="result">
                              <init>
                                <methodInvokeExpression methodName="InvokeMember">
                                  <target>
                                    <methodInvokeExpression methodName="GetType">
                                      <target>
                                        <variableReferenceExpression name="handler"/>
                                      </target>
                                    </methodInvokeExpression>
                                  </target>
                                  <parameters>
                                    <variableReferenceExpression name="s"/>
                                    <binaryOperatorExpression operator="BitwiseOr">
                                      <propertyReferenceExpression name="GetProperty">
                                        <typeReferenceExpression type="System.Reflection.BindingFlags"/>
                                      </propertyReferenceExpression>
                                      <propertyReferenceExpression name="GetField">
                                        <typeReferenceExpression type="System.Reflection.BindingFlags"/>
                                      </propertyReferenceExpression>
                                    </binaryOperatorExpression>
                                    <primitiveExpression value="null"/>
                                    <variableReferenceExpression name="handler"/>
                                    <arrayCreateExpression>
                                      <createType type="System.Object"/>
                                    </arrayCreateExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </init>
                            </variableDeclarationStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="Value">
                                <variableReferenceExpression name="parameter"/>
                              </propertyReferenceExpression>
                              <variableReferenceExpression name="result"/>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="IdentityEquality">
                              <propertyReferenceExpression name="Value">
                                <variableReferenceExpression name="parameter"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="null"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="Value">
                                <variableReferenceExpression name="parameter"/>
                              </propertyReferenceExpression>
                              <propertyReferenceExpression name="Value">
                                <typeReferenceExpression type="DBNull"/>
                              </propertyReferenceExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                      </statements>
                    </whileStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityInequality">
                          <variableReferenceExpression name="missingFields"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="System.Boolean" name="retrieveMissingValues">
                          <init>
                            <primitiveExpression value="true"/>
                          </init>
                        </variableDeclarationStatement>
                        <variableDeclarationStatement type="List" name="filter">
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
                        <variableDeclarationStatement type="ViewPage" name="page">
                          <init>
                            <methodInvokeExpression methodName="CreateViewPage"/>
                          </init>
                        </variableDeclarationStatement>
                        <foreachStatement>
                          <variable type="DataField" name="field"/>
                          <target>
                            <propertyReferenceExpression name="Fields">
                              <variableReferenceExpression name="page"/>
                            </propertyReferenceExpression>
                          </target>
                          <statements>
                            <conditionStatement>
                              <condition>
                                <propertyReferenceExpression name="IsPrimaryKey">
                                  <variableReferenceExpression name="field"/>
                                </propertyReferenceExpression>
                              </condition>
                              <trueStatements>
                                <variableDeclarationStatement type="FieldValue" name="v">
                                  <init>
                                    <methodInvokeExpression methodName="SelectFieldValueObject">
                                      <target>
                                        <variableReferenceExpression name="args"/>
                                      </target>
                                      <parameters>
                                        <propertyReferenceExpression name="Name">
                                          <variableReferenceExpression name="field"/>
                                        </propertyReferenceExpression>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </init>
                                </variableDeclarationStatement>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="IdentityEquality">
                                      <variableReferenceExpression name="v"/>
                                      <primitiveExpression value="null"/>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <assignStatement>
                                      <variableReferenceExpression name="retrieveMissingValues"/>
                                      <primitiveExpression value="false"/>
                                    </assignStatement>
                                    <breakStatement/>
                                  </trueStatements>
                                  <falseStatements>
                                    <methodInvokeExpression methodName="Add">
                                      <target>
                                        <variableReferenceExpression name="filter"/>
                                      </target>
                                      <parameters>
                                        <stringFormatExpression format="{{0}}:={{1}}">
                                          <propertyReferenceExpression name="Name">
                                            <variableReferenceExpression name="v"/>
                                          </propertyReferenceExpression>
                                          <propertyReferenceExpression name="Value">
                                            <variableReferenceExpression name="v"/>
                                          </propertyReferenceExpression>
                                        </stringFormatExpression>
                                        <!--<methodInvokeExpression methodName="Format">
                                          <target>
                                            <typeReferenceExpression type="String"/>
                                          </target>
                                          <parameters>
                                            <primitiveExpression value="{{0}}:={{1}}"/>
                                            <propertyReferenceExpression name="Name">
                                              <variableReferenceExpression name="v"/>
                                            </propertyReferenceExpression>
                                            <propertyReferenceExpression name="Value">
                                              <variableReferenceExpression name="v"/>
                                            </propertyReferenceExpression>
                                          </parameters>
                                        </methodInvokeExpression>-->
                                      </parameters>
                                    </methodInvokeExpression>
                                  </falseStatements>
                                </conditionStatement>
                              </trueStatements>
                            </conditionStatement>
                          </statements>
                        </foreachStatement>
                        <conditionStatement>
                          <condition>
                            <variableReferenceExpression name="retrieveMissingValues"/>
                          </condition>
                          <trueStatements>
                            <variableDeclarationStatement type="System.String" name="editView">
                              <init>
                                <castExpression targetType="System.String">
                                  <methodInvokeExpression methodName="Evaluate">
                                    <target>
                                      <fieldReferenceExpression name="config"/>
                                    </target>
                                    <parameters>
                                      <primitiveExpression value="string(//c:view[@type='Form']/@id)"/>
                                      <!--<propertyReferenceExpression name="Resolver"/>-->
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
                                      <variableReferenceExpression name="editView"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                </unaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <variableDeclarationStatement type="PageRequest"  name="request">
                                  <init>
                                    <objectCreateExpression type="PageRequest">
                                      <parameters>
                                        <primitiveExpression value="0"/>
                                        <primitiveExpression value="1"/>
                                        <primitiveExpression value="null"/>
                                        <methodInvokeExpression methodName="ToArray">
                                          <target>
                                            <variableReferenceExpression name="filter"/>
                                          </target>
                                        </methodInvokeExpression>
                                      </parameters>
                                    </objectCreateExpression>
                                  </init>
                                </variableDeclarationStatement>
                                <assignStatement>
                                  <propertyReferenceExpression name="RequiresMetaData">
                                    <variableReferenceExpression name="request"/>
                                  </propertyReferenceExpression>
                                  <primitiveExpression value="true"/>
                                </assignStatement>
                                <assignStatement>
                                  <variableReferenceExpression name="page"/>
                                  <methodInvokeExpression methodName="GetPage">
                                    <target>
                                      <methodInvokeExpression methodName="CreateDataController">
                                        <target>
                                          <typeReferenceExpression type="ControllerFactory"/>
                                        </target>
                                      </methodInvokeExpression>
                                    </target>
                                    <parameters>
                                      <propertyReferenceExpression name="Controller">
                                        <variableReferenceExpression name="args"/>
                                      </propertyReferenceExpression>
                                      <variableReferenceExpression name="editView"/>
                                      <variableReferenceExpression name="request"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                </assignStatement>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="GreaterThan">
                                      <propertyReferenceExpression name="Count">
                                        <propertyReferenceExpression name="Rows">
                                          <variableReferenceExpression name="page"/>
                                        </propertyReferenceExpression>
                                      </propertyReferenceExpression>
                                      <primitiveExpression value="0"/>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <foreachStatement>
                                      <variable type="System.String" name="parameterName"/>
                                      <target>
                                        <propertyReferenceExpression name="Keys">
                                          <variableReferenceExpression name="missingFields"/>
                                        </propertyReferenceExpression>
                                      </target>
                                      <statements>
                                        <variableDeclarationStatement type="System.Int32" name="index">
                                          <init>
                                            <primitiveExpression value="0"/>
                                          </init>
                                        </variableDeclarationStatement>
                                        <variableDeclarationStatement type="System.String" name="fieldName">
                                          <init>
                                            <arrayIndexerExpression>
                                              <target>
                                                <variableReferenceExpression name="missingFields"/>
                                              </target>
                                              <indices>
                                                <variableReferenceExpression name="parameterName"/>
                                              </indices>
                                            </arrayIndexerExpression>
                                          </init>
                                        </variableDeclarationStatement>
                                        <foreachStatement>
                                          <variable type="DataField" name="field"/>
                                          <target>
                                            <propertyReferenceExpression name="Fields">
                                              <variableReferenceExpression name="page"/>
                                            </propertyReferenceExpression>
                                          </target>
                                          <statements>
                                            <conditionStatement>
                                              <condition>
                                                <methodInvokeExpression methodName="Equals">
                                                  <target>
                                                    <propertyReferenceExpression name="Name">
                                                      <variableReferenceExpression name="field"/>
                                                    </propertyReferenceExpression>
                                                  </target>
                                                  <parameters>
                                                    <variableReferenceExpression name="fieldName"/>
                                                  </parameters>
                                                </methodInvokeExpression>
                                              </condition>
                                              <trueStatements>
                                                <variableDeclarationStatement type="System.Object" name="v">
                                                  <init>
                                                    <arrayIndexerExpression>
                                                      <target>
                                                        <arrayIndexerExpression>
                                                          <target>
                                                            <propertyReferenceExpression name="Rows">
                                                              <variableReferenceExpression name="page"/>
                                                            </propertyReferenceExpression>
                                                          </target>
                                                          <indices>
                                                            <primitiveExpression value="0"/>
                                                          </indices>
                                                        </arrayIndexerExpression>
                                                      </target>
                                                      <indices>
                                                        <variableReferenceExpression name="index"/>
                                                      </indices>
                                                    </arrayIndexerExpression>
                                                  </init>
                                                </variableDeclarationStatement>
                                                <conditionStatement>
                                                  <condition>
                                                    <binaryOperatorExpression operator="IdentityInequality">
                                                      <variableReferenceExpression name="v"/>
                                                      <primitiveExpression value="null"/>
                                                    </binaryOperatorExpression>
                                                  </condition>
                                                  <trueStatements>
                                                    <assignStatement>
                                                      <propertyReferenceExpression name="Value">
                                                        <arrayIndexerExpression>
                                                          <target>
                                                            <propertyReferenceExpression name="Parameters">
                                                              <variableReferenceExpression name="command"/>
                                                            </propertyReferenceExpression>
                                                          </target>
                                                          <indices>
                                                            <variableReferenceExpression name="parameterName"/>
                                                          </indices>
                                                        </arrayIndexerExpression>
                                                      </propertyReferenceExpression>
                                                      <variableReferenceExpression name="v"/>
                                                    </assignStatement>
                                                  </trueStatements>
                                                </conditionStatement>
                                              </trueStatements>
                                            </conditionStatement>
                                            <assignStatement>
                                              <variableReferenceExpression name="index"/>
                                              <binaryOperatorExpression operator="Add">
                                                <variableReferenceExpression name="index"/>
                                                <primitiveExpression value="1"/>
                                              </binaryOperatorExpression>
                                            </assignStatement>
                                          </statements>
                                        </foreachStatement>
                                      </statements>
                                    </foreachStatement>
                                  </trueStatements>
                                </conditionStatement>
                              </trueStatements>
                            </conditionStatement>
                          </trueStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
                  </xsl:otherwise>
                </xsl:choose>
                <methodReturnStatement>
                  <variableReferenceExpression name="command"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- field SqlSelectRegex1 -->
            <memberField type="Regex" name="SqlSelectRegex1">
              <attributes public="true" static="true"/>
              <init>
                <objectCreateExpression type="Regex">
                  <parameters>
                    <primitiveExpression>
                      <xsl:attribute name="value"><![CDATA[/\*<select>\*/(?'Select'[\S\s]*)?/\*</select>\*[\S\s]*?/\*<from>\*/(?'From'[\S\s]*)?/\*</from>\*[\S\s]*?/\*(<order-by>\*/(?'OrderBy'[\S\s]*)?/\*</order-by>\*/)?]]></xsl:attribute>
                    </primitiveExpression>
                    <propertyReferenceExpression name="IgnoreCase">
                      <typeReferenceExpression type="RegexOptions"/>
                    </propertyReferenceExpression>
                  </parameters>
                </objectCreateExpression>
              </init>
            </memberField>
            <!-- field SqlSelectRegex2 -->
            <memberField type="Regex" name="SqlSelectRegex2">
              <attributes public="true" static="true"/>
              <init>
                <objectCreateExpression type="Regex">
                  <parameters>
                    <primitiveExpression value="\s*select\s*(?'Select'[\S\s]*)?\sfrom\s*(?'From'[\S\s]*)?\swhere\s*(?'Where'[\S\s]*)?\sorder\s+by\s*(?'OrderBy'[\S\s]*)?|\s*select\s*(?'Select'[\S\s]*)?\sfrom\s*(?'From'[\S\s]*)?\swhere\s*(?'Where'[\S\s]*)?|\s*select\s*(?'Select'[\S\s]*)?\sfrom\s*(?'From'[\S\s]*)?\sorder\s+by\s*(?'OrderBy'[\S\s]*)?|\s*select\s*(?'Select'[\S\s]*)?\sfrom\s*(?'From'[\S\s]*)?"/>
                    <propertyReferenceExpression name="IgnoreCase">
                      <typeReferenceExpression type="RegexOptions"/>
                    </propertyReferenceExpression>
                  </parameters>
                </objectCreateExpression>
              </init>
            </memberField>
            <!-- field TableNameRegex -->
            <memberField type="Regex" name="TableNameRegex">
              <comment>
                <![CDATA[ "table name" regular expression:
              ^(?'Table'((\[|"|`)([\w\s]+)?(\]|"|`)|\w+)(\s*\.\s*((\[|"|`)([\w\s]+)?(\]|"|`)|\w+))*(\s*\.\s*((\[|"|`)([\w\s]+)?(\]|"|`)|\w+))*)(\s*(as|)\s*(\[|"|`|)([\w\s]+)?(\]|"|`|))
]]>
              </comment>
              <attributes public="true" static="true"/>
              <init>
                <objectCreateExpression type="Regex">
                  <parameters>
                    <primitiveExpression value="^(?'Table'((\[|&quot;|`)([\w\s]+)?(\]|&quot;|`)|\w+)(\s*\.\s*((\[|&quot;|`)([\w\s]+)?(\]|&quot;|`)|\w+))*(\s*\.\s*((\[|&quot;|`)([\w\s]+)?(\]|&quot;|`)|\w+))*)(\s*(as|)\s*(\[|&quot;|`|)([\w\s]+)?(\]|&quot;|`|))"/>
                    <propertyReferenceExpression name="IgnoreCase">
                      <typeReferenceExpression type="RegexOptions"/>
                    </propertyReferenceExpression>
                  </parameters>
                </objectCreateExpression>
              </init>
            </memberField>
            <!-- method ConfigureCommand(DbCommand, ViewPage, CommandConfigurationType, FieldValue[]) -->
            <memberMethod returnType="System.Boolean" name="ConfigureCommand">
              <attributes family="true"/>
              <parameters>
                <parameter type="DbCommand" name="command"/>
                <parameter type="ViewPage" name="page"/>
                <parameter type="CommandConfigurationType" name="commandConfiguration"/>
                <parameter type="FieldValue[]" name="values"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <argumentReferenceExpression name="page"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <argumentReferenceExpression name="page"/>
                      <objectCreateExpression type="ViewPage"/>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <methodInvokeExpression methodName="PopulatePageFields">
                  <parameters>
                    <argumentReferenceExpression name="page"/>
                  </parameters>
                </methodInvokeExpression>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <argumentReferenceExpression name="command"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="true"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <xsl:if test="$IsUnlimited='true' and (contains($Auditing, 'Modified') or contains($Auditing, 'Created'))">
                  <conditionStatement>
                    <condition>
                      <binaryOperatorExpression operator="IdentityInequality">
                        <argumentReferenceExpression name="values"/>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                    </condition>
                    <trueStatements>
                      <methodInvokeExpression methodName="EnsureTrackingFields">
                        <target>
                          <typeReferenceExpression type="{$Namespace}.Security.EventTracker"/>
                        </target>
                        <parameters>
                          <argumentReferenceExpression name="page"/>
                          <fieldReferenceExpression name="config"/>
                        </parameters>
                      </methodInvokeExpression>
                    </trueStatements>
                  </conditionStatement>
                </xsl:if>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <propertyReferenceExpression name="CommandType">
                        <argumentReferenceExpression name="command"/>
                      </propertyReferenceExpression>
                      <propertyReferenceExpression name="Text">
                        <typeReferenceExpression type="CommandType"/>
                      </propertyReferenceExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="Match" name="statementMatch">
                      <init>
                        <methodInvokeExpression methodName="Match">
                          <target>
                            <propertyReferenceExpression name="SqlSelectRegex1"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="CommandText">
                              <variableReferenceExpression name="command"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="Not">
                          <propertyReferenceExpression name="Success">
                            <variableReferenceExpression name="statementMatch"/>
                          </propertyReferenceExpression>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="statementMatch"/>
                          <methodInvokeExpression methodName="Match">
                            <target>
                              <propertyReferenceExpression name="SqlSelectRegex2"/>
                            </target>
                            <parameters>
                              <propertyReferenceExpression name="CommandText">
                                <variableReferenceExpression name="command"/>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                    <variableDeclarationStatement type="SelectClauseDictionary" name="expressions">
                      <init>
                        <methodInvokeExpression methodName="ParseSelectExpressions">
                          <parameters>
                            <propertyReferenceExpression name="Value">
                              <arrayIndexerExpression>
                                <target>
                                  <propertyReferenceExpression name="Groups">
                                    <variableReferenceExpression name="statementMatch"/>
                                  </propertyReferenceExpression>
                                </target>
                                <indices>
                                  <primitiveExpression value="Select"/>
                                </indices>
                              </arrayIndexerExpression>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <methodInvokeExpression methodName="EnsurePageFields">
                      <parameters>
                        <argumentReferenceExpression name="page"/>
                        <variableReferenceExpression name="expressions"/>
                      </parameters>
                    </methodInvokeExpression>
                    <variableDeclarationStatement type="System.String" name="commandId">
                      <init>
                        <methodInvokeExpression methodName="GetAttribute">
                          <target>
                            <fieldReferenceExpression name="view"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="commandId"/>
                            <stringEmptyExpression/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="System.Boolean" name="commandIsCustom">
                      <init>
                        <binaryOperatorExpression operator="BooleanOr">
                          <binaryOperatorExpression operator="IdentityInequality">
                            <methodInvokeExpression methodName="SelectSingleNode">
                              <target>
                                <fieldReferenceExpression name="config"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="/c:dataController/c:commands/c:command[@id='{{0}}' and @custom='true']"/>
                                <variableReferenceExpression name="commandId"/>
                              </parameters>
                            </methodInvokeExpression>
                            <primitiveExpression value="null"/>
                          </binaryOperatorExpression>
                          <methodInvokeExpression methodName="RequiresResultSet">
                            <target>
                              <argumentReferenceExpression name="page"/>
                            </target>
                            <parameters>
                              <argumentReferenceExpression name="commandConfiguration"/>
                            </parameters>
                          </methodInvokeExpression>
                        </binaryOperatorExpression>
                      </init>
                    </variableDeclarationStatement>
                    <methodInvokeExpression methodName="AddComputedExpressions">
                      <parameters>
                        <variableReferenceExpression name="expressions"/>
                        <argumentReferenceExpression name="page"/>
                        <argumentReferenceExpression name="commandConfiguration"/>
                        <variableReferenceExpression name="commandIsCustom"/>
                      </parameters>
                    </methodInvokeExpression>
                    <!--<methodInvokeExpression methodName="AssignPivotParameterValues">
                      <parameters>
                        <argumentReferenceExpression name="command"/>
                        <argumentReferenceExpression name="page"/>
                      </parameters>
                    </methodInvokeExpression>-->
                    <conditionStatement>
                      <condition>
                        <propertyReferenceExpression name="Success">
                          <variableReferenceExpression name="statementMatch"/>
                        </propertyReferenceExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="System.String" name="fromClause">
                          <init>
                            <propertyReferenceExpression name="Value">
                              <arrayIndexerExpression>
                                <target>
                                  <propertyReferenceExpression name="Groups">
                                    <variableReferenceExpression name="statementMatch"/>
                                  </propertyReferenceExpression>
                                </target>
                                <indices>
                                  <primitiveExpression value="From"/>
                                </indices>
                              </arrayIndexerExpression>
                            </propertyReferenceExpression>
                          </init>
                        </variableDeclarationStatement>
                        <variableDeclarationStatement type="System.String" name="whereClause">
                          <init>
                            <propertyReferenceExpression name="Value">
                              <arrayIndexerExpression>
                                <target>
                                  <propertyReferenceExpression name="Groups">
                                    <variableReferenceExpression name="statementMatch"/>
                                  </propertyReferenceExpression>
                                </target>
                                <indices>
                                  <primitiveExpression value="Where"/>
                                </indices>
                              </arrayIndexerExpression>
                            </propertyReferenceExpression>
                          </init>
                        </variableDeclarationStatement>
                        <variableDeclarationStatement type="System.String" name="orderByClause">
                          <init>
                            <propertyReferenceExpression name="Value">
                              <arrayIndexerExpression>
                                <target>
                                  <propertyReferenceExpression name="Groups">
                                    <variableReferenceExpression name="statementMatch"/>
                                  </propertyReferenceExpression>
                                </target>
                                <indices>
                                  <primitiveExpression value="OrderBy"/>
                                </indices>
                              </arrayIndexerExpression>
                            </propertyReferenceExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <variableReferenceExpression name="commandIsCustom"/>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="fromClause"/>
                              <stringFormatExpression format="({{0}}) resultset__">
                                <propertyReferenceExpression name="CommandText">
                                  <argumentReferenceExpression name="command"/>
                                </propertyReferenceExpression>
                              </stringFormatExpression>
                            </assignStatement>
                            <assignStatement>
                              <variableReferenceExpression name="whereClause"/>
                              <stringEmptyExpression/>
                            </assignStatement>
                            <assignStatement>
                              <variableReferenceExpression name="orderByClause"/>
                              <stringEmptyExpression/>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <variableDeclarationStatement type="System.String" name="tableName">
                          <init>
                            <primitiveExpression value="null"/>
                          </init>
                        </variableDeclarationStatement>
                        <!-- 
                    if (!commandConfiguration.ToString().StartsWith("Select"))
                        tableName = (string)_config.Navigator.Evaluate(String.Format("string(/c:dataController/c:commands/c:command[@id='{0}']/@tableName)", _view.GetAttribute("commandId", String.Empty)), Resolver);
                    if (String.IsNullOrEmpty(tableName))
												-->
                        <conditionStatement>
                          <condition>
                            <unaryOperatorExpression operator="Not">
                              <methodInvokeExpression methodName="StartsWith">
                                <target>
                                  <methodInvokeExpression methodName="ToString">
                                    <target>
                                      <argumentReferenceExpression name="commandConfiguration"/>
                                    </target>
                                  </methodInvokeExpression>
                                </target>
                                <parameters>
                                  <primitiveExpression value="Select"/>
                                </parameters>
                              </methodInvokeExpression>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="tableName"/>
                              <castExpression targetType="System.String">
                                <methodInvokeExpression methodName="Evaluate">
                                  <target>
                                    <fieldReferenceExpression name="config"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression>
                                      <xsl:attribute name="value"><![CDATA[string(/c:dataController/c:commands/c:command[@id='{0}']/@tableName)]]></xsl:attribute>
                                    </primitiveExpression>
                                    <variableReferenceExpression name="commandId"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </castExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <conditionStatement>
                          <condition>
                            <methodInvokeExpression methodName="IsNullOrEmpty">
                              <target>
                                <typeReferenceExpression type="String"/>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="tableName"/>
                              </parameters>
                            </methodInvokeExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="tableName"/>
                              <propertyReferenceExpression name="Value">
                                <arrayIndexerExpression>
                                  <target>
                                    <propertyReferenceExpression name="Groups">
                                      <methodInvokeExpression methodName="Match">
                                        <target>
                                          <propertyReferenceExpression name="TableNameRegex"/>
                                        </target>
                                        <parameters>
                                          <variableReferenceExpression name="fromClause"/>
                                        </parameters>
                                      </methodInvokeExpression>
                                    </propertyReferenceExpression>
                                  </target>
                                  <indices>
                                    <primitiveExpression value="Table"/>
                                  </indices>
                                </arrayIndexerExpression>
                              </propertyReferenceExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="ValueEquality">
                              <variableReferenceExpression name="commandConfiguration"/>
                              <propertyReferenceExpression name="Update">
                                <typeReferenceExpression type="CommandConfigurationType"/>
                              </propertyReferenceExpression>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <methodReturnStatement>
                              <methodInvokeExpression methodName="ConfigureCommandForUpdate">
                                <parameters>
                                  <argumentReferenceExpression name="command"/>
                                  <argumentReferenceExpression name="page"/>
                                  <variableReferenceExpression name="expressions"/>
                                  <variableReferenceExpression name="tableName"/>
                                  <argumentReferenceExpression name="values"/>
                                </parameters>
                              </methodInvokeExpression>
                            </methodReturnStatement>
                          </trueStatements>
                          <falseStatements>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="ValueEquality">
                                  <variableReferenceExpression name="commandConfiguration"/>
                                  <propertyReferenceExpression name="Insert">
                                    <typeReferenceExpression type="CommandConfigurationType"/>
                                  </propertyReferenceExpression>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <methodReturnStatement>
                                  <methodInvokeExpression methodName="ConfigureCommandForInsert">
                                    <parameters>
                                      <argumentReferenceExpression name="command"/>
                                      <argumentReferenceExpression name="page"/>
                                      <variableReferenceExpression name="expressions"/>
                                      <variableReferenceExpression name="tableName"/>
                                      <argumentReferenceExpression name="values"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                </methodReturnStatement>
                              </trueStatements>
                              <falseStatements>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="ValueEquality">
                                      <variableReferenceExpression name="commandConfiguration"/>
                                      <propertyReferenceExpression name="Delete">
                                        <typeReferenceExpression type="CommandConfigurationType"/>
                                      </propertyReferenceExpression>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <methodReturnStatement>
                                      <methodInvokeExpression methodName="ConfigureCommandForDelete">
                                        <parameters>
                                          <argumentReferenceExpression name="command"/>
                                          <argumentReferenceExpression name="page"/>
                                          <variableReferenceExpression name="expressions"/>
                                          <variableReferenceExpression name="tableName"/>
                                          <argumentReferenceExpression name="values"/>
                                        </parameters>
                                      </methodInvokeExpression>
                                    </methodReturnStatement>
                                  </trueStatements>
                                  <falseStatements>
                                    <methodInvokeExpression methodName="ConfigureCommandForSelect">
                                      <parameters>
                                        <argumentReferenceExpression name="command"/>
                                        <argumentReferenceExpression name="page"/>
                                        <variableReferenceExpression name="expressions"/>
                                        <variableReferenceExpression name="fromClause"/>
                                        <variableReferenceExpression name="whereClause"/>
                                        <variableReferenceExpression name="orderByClause"/>
                                        <argumentReferenceExpression name="commandConfiguration"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                    <methodInvokeExpression methodName="ProcessExpressionParameters">
                                      <parameters>
                                        <argumentReferenceExpression name="command"/>
                                        <variableReferenceExpression name="expressions"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </falseStatements>
                                </conditionStatement>
                              </falseStatements>
                            </conditionStatement>
                          </falseStatements>
                        </conditionStatement>
                      </trueStatements>
                      <falseStatements>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="BooleanAnd">
                              <binaryOperatorExpression operator="ValueEquality">
                                <argumentReferenceExpression name="commandConfiguration"/>
                                <propertyReferenceExpression name="Select">
                                  <typeReferenceExpression type="CommandConfigurationType"/>
                                </propertyReferenceExpression>
                              </binaryOperatorExpression>
                              <methodInvokeExpression methodName="YieldsSingleRow">
                                <parameters>
                                  <argumentReferenceExpression name="command"/>
                                </parameters>
                              </methodInvokeExpression>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <variableDeclarationStatement type="StringBuilder" name="sb">
                              <init>
                                <objectCreateExpression type="StringBuilder"/>
                              </init>
                            </variableDeclarationStatement>
                            <methodInvokeExpression methodName="Append">
                              <target>
                                <variableReferenceExpression name="sb"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="select "/>
                              </parameters>
                            </methodInvokeExpression>
                            <methodInvokeExpression methodName="AppendSelectExpressions">
                              <parameters>
                                <variableReferenceExpression name="sb"/>
                                <argumentReferenceExpression name="page"/>
                                <argumentReferenceExpression name="expressions"/>
                                <primitiveExpression value="true"/>
                              </parameters>
                            </methodInvokeExpression>
                            <assignStatement>
                              <propertyReferenceExpression name="CommandText">
                                <variableReferenceExpression name="command"/>
                              </propertyReferenceExpression>
                              <methodInvokeExpression methodName="ToString">
                                <target>
                                  <variableReferenceExpression name="sb"/>
                                </target>
                              </methodInvokeExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                      </falseStatements>
                    </conditionStatement>
                    <methodReturnStatement>
                      <binaryOperatorExpression operator="ValueInequality">
                        <argumentReferenceExpression name="commandConfiguration"/>
                        <propertyReferenceExpression name="None">
                          <typeReferenceExpression type="CommandConfigurationType"/>
                        </propertyReferenceExpression>
                      </binaryOperatorExpression>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <binaryOperatorExpression operator="ValueEquality">
                    <propertyReferenceExpression name="CommandType">
                      <variableReferenceExpression name="command"/>
                    </propertyReferenceExpression>
                    <propertyReferenceExpression name="StoredProcedure">
                      <typeReferenceExpression type="CommandType"/>
                    </propertyReferenceExpression>
                  </binaryOperatorExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method ProcessExpressionsParameter(DbCommand, SelectClauseDictionary) -->
            <memberField type="Regex" name="ParamDetectionRegex">
              <attributes public="true" static="true"/>
              <init>
                <objectCreateExpression type="Regex">
                  <parameters>
                    <primitiveExpression value="(?:(\W|^))(?'Parameter'(@|:)\w+)"/>
                  </parameters>
                </objectCreateExpression>
              </init>
            </memberField>
            <memberMethod name="ProcessExpressionParameters">
              <attributes private="true" final="true"/>
              <parameters>
                <parameter type="DbCommand" name="command"/>
                <parameter type="SelectClauseDictionary" name="expressions"/>
              </parameters>
              <statements>
                <foreachStatement>
                  <variable type="System.String" name="fieldName"/>
                  <target>
                    <propertyReferenceExpression name="Keys">
                      <argumentReferenceExpression name="expressions"/>
                    </propertyReferenceExpression>
                  </target>
                  <statements>
                    <assignStatement>
                      <fieldReferenceExpression name="currentCommand">
                        <thisReferenceExpression/>
                      </fieldReferenceExpression>
                      <argumentReferenceExpression name="command"/>
                    </assignStatement>
                    <variableDeclarationStatement type="System.String" name="formula">
                      <init>
                        <arrayIndexerExpression>
                          <target>
                            <argumentReferenceExpression name="expressions"/>
                          </target>
                          <indices>
                            <variableReferenceExpression name="fieldName"/>
                          </indices>
                        </arrayIndexerExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="Match" name="m">
                      <init>
                        <methodInvokeExpression methodName="Match">
                          <target>
                            <propertyReferenceExpression name="ParamDetectionRegex"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="formula"/>
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
                        <methodInvokeExpression methodName="AssignFilterParameterValue">
                          <parameters>
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
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
              </statements>
            </memberMethod>
            <!-- method AddComputedExpressions(SelectClauseDictionary, ViewPage, CommandConfigurationType, bool)-->
            <memberMethod name="AddComputedExpressions">
              <attributes private="true" final="true"/>
              <parameters>
                <parameter type="SelectClauseDictionary" name="expressions"/>
                <parameter type="ViewPage" name="page"/>
                <parameter type="CommandConfigurationType" name="commandConfiguration"/>
                <parameter type="System.Boolean" name="generateFormula"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.Boolean" name="useFormulaAsIs">
                  <init>
                    <binaryOperatorExpression operator="BooleanOr">
                      <binaryOperatorExpression operator="ValueEquality">
                        <argumentReferenceExpression name="commandConfiguration"/>
                        <propertyReferenceExpression name="Insert">
                          <typeReferenceExpression type="CommandConfigurationType"/>
                        </propertyReferenceExpression>
                      </binaryOperatorExpression>
                      <binaryOperatorExpression operator="ValueEquality">
                        <argumentReferenceExpression name="commandConfiguration"/>
                        <propertyReferenceExpression name="Update">
                          <typeReferenceExpression type="CommandConfigurationType"/>
                        </propertyReferenceExpression>
                      </binaryOperatorExpression>
                    </binaryOperatorExpression>
                  </init>
                </variableDeclarationStatement>
                <foreachStatement>
                  <variable type="DataField" name="field"/>
                  <target>
                    <propertyReferenceExpression name="Fields">
                      <argumentReferenceExpression name="page"/>
                    </propertyReferenceExpression>
                  </target>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="Not">
                          <methodInvokeExpression methodName="IsNullOrEmpty">
                            <target>
                              <typeReferenceExpression type="String"/>
                            </target>
                            <parameters>
                              <propertyReferenceExpression name="Formula">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <conditionStatement>
                          <condition>
                            <variableReferenceExpression name="useFormulaAsIs"/>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <arrayIndexerExpression>
                                <target>
                                  <argumentReferenceExpression name="expressions"/>
                                </target>
                                <indices>
                                  <methodInvokeExpression methodName="ExpressionName">
                                    <target>
                                      <variableReferenceExpression name="field"/>
                                    </target>
                                  </methodInvokeExpression>
                                </indices>
                              </arrayIndexerExpression>
                              <propertyReferenceExpression name="Formula">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                            </assignStatement>
                          </trueStatements>
                          <falseStatements>
                            <assignStatement>
                              <arrayIndexerExpression>
                                <target>
                                  <argumentReferenceExpression name="expressions"/>
                                </target>
                                <indices>
                                  <methodInvokeExpression methodName="ExpressionName">
                                    <target>
                                      <variableReferenceExpression name="field"/>
                                    </target>
                                  </methodInvokeExpression>
                                </indices>
                              </arrayIndexerExpression>
                              <stringFormatExpression format="({{0}})">
                                <propertyReferenceExpression name="Formula">
                                  <variableReferenceExpression name="field"/>
                                </propertyReferenceExpression>
                              </stringFormatExpression>
                            </assignStatement>
                          </falseStatements>
                        </conditionStatement>
                      </trueStatements>
                      <falseStatements>
                        <conditionStatement>
                          <condition>
                            <argumentReferenceExpression name="generateFormula"/>
                          </condition>
                          <trueStatements>
                            <conditionStatement>
                              <condition>
                                <variableReferenceExpression name="useFormulaAsIs"/>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <arrayIndexerExpression>
                                    <target>
                                      <argumentReferenceExpression name="expressions"/>
                                    </target>
                                    <indices>
                                      <methodInvokeExpression methodName="ExpressionName">
                                        <target>
                                          <variableReferenceExpression name="field"/>
                                        </target>
                                      </methodInvokeExpression>
                                    </indices>
                                  </arrayIndexerExpression>
                                  <propertyReferenceExpression name="Name">
                                    <variableReferenceExpression name="field"/>
                                  </propertyReferenceExpression>
                                </assignStatement>
                              </trueStatements>
                              <falseStatements>
                                <assignStatement>
                                  <arrayIndexerExpression>
                                    <target>
                                      <argumentReferenceExpression name="expressions"/>
                                    </target>
                                    <indices>
                                      <methodInvokeExpression methodName="ExpressionName">
                                        <target>
                                          <variableReferenceExpression name="field"/>
                                        </target>
                                      </methodInvokeExpression>
                                    </indices>
                                  </arrayIndexerExpression>
                                  <stringFormatExpression format="({{0}})">
                                    <propertyReferenceExpression name="Name">
                                      <variableReferenceExpression name="field"/>
                                    </propertyReferenceExpression>
                                  </stringFormatExpression>
                                </assignStatement>
                              </falseStatements>
                            </conditionStatement>
                          </trueStatements>
                        </conditionStatement>
                      </falseStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
              </statements>
            </memberMethod>
            <!-- method AssignPivotParameterValues(DbCommand, ViewPage) -->
            <!--<memberMethod name="AssignPivotParameterValues">
              <attributes private="true"/>
              <parameters>
                <parameter type="DbCommand" name="command"/>
                <parameter type="ViewPage" name="page"/>
              </parameters>
              <statements>
                <foreachStatement>
                  <variable type="DbParameter" name="p"/>
                  <target>
                    <propertyReferenceExpression name="Parameters">
                      <argumentReferenceExpression name="command"/>
                    </propertyReferenceExpression>
                  </target>
                  <statements>
                    <variableDeclarationStatement type="Match" name="pivotMatch">
                      <init>
                        <methodInvokeExpression methodName="Match">
                          <target>
                            <typeReferenceExpression type="Regex"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="ParameterName">
                              <variableReferenceExpression name="p"/>
                            </propertyReferenceExpression>
                            <primitiveExpression value="^\WPivotCol(\d+)_(\w+)$"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <propertyReferenceExpression name="Success">
                          <variableReferenceExpression name="pivotMatch"/>
                        </propertyReferenceExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="DataTable" name="pivotColumns">
                          <init>
                            <methodInvokeExpression methodName="EnumeratePivotColumns">
                              <target>
                                <variableReferenceExpression name="page"/>
                              </target>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <variableDeclarationStatement type="System.Int32" name="rowIndex">
                          <init>
                            <methodInvokeExpression methodName="ToInt32">
                              <target>
                                <typeReferenceExpression type="Convert"/>
                              </target>
                              <parameters>
                                <propertyReferenceExpression name="Value">
                                  <arrayIndexerExpression>
                                    <target>
                                      <propertyReferenceExpression name="Groups">
                                        <variableReferenceExpression name="pivotMatch"/>
                                      </propertyReferenceExpression>
                                    </target>
                                    <indices>
                                      <primitiveExpression value="1"/>
                                    </indices>
                                  </arrayIndexerExpression>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <variableDeclarationStatement type="System.String" name="columnFieldName">
                          <init>
                            <propertyReferenceExpression name="Value">
                              <arrayIndexerExpression>
                                <target>
                                  <propertyReferenceExpression name="Groups">
                                    <variableReferenceExpression name="pivotMatch"/>
                                  </propertyReferenceExpression>
                                </target>
                                <indices>
                                  <primitiveExpression value="2"/>
                                </indices>
                              </arrayIndexerExpression>
                            </propertyReferenceExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="LessThan">
                              <variableReferenceExpression name="rowIndex"/>
                              <propertyReferenceExpression name="Count">
                                <propertyReferenceExpression name="Rows">
                                  <variableReferenceExpression name="pivotColumns"/>
                                </propertyReferenceExpression>
                              </propertyReferenceExpression>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="Value">
                                <variableReferenceExpression name="p"/>
                              </propertyReferenceExpression>
                              <arrayIndexerExpression>
                                <target>
                                  <arrayIndexerExpression>
                                    <target>
                                      <propertyReferenceExpression name="Rows">
                                        <variableReferenceExpression name="pivotColumns"/>
                                      </propertyReferenceExpression>
                                    </target>
                                    <indices>
                                      <variableReferenceExpression name="rowIndex"/>
                                    </indices>
                                  </arrayIndexerExpression>
                                </target>
                                <indices>
                                  <variableReferenceExpression name="columnFieldName"/>
                                </indices>
                              </arrayIndexerExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
              </statements>
            </memberMethod>-->
            <!-- method ConfigureCommandForDelete(DbCommand, ViewPage, SelectClauseDictionary, string, FieldValue[]) -->
            <memberMethod returnType="System.Boolean" name="ConfigureCommandForDelete">
              <attributes private="true"/>
              <parameters>
                <parameter type="DbCommand" name="command"/>
                <parameter type="ViewPage" name="page"/>
                <parameter type="SelectClauseDictionary" name="expressions"/>
                <parameter type="System.String" name="tableName"/>
                <parameter type="FieldValue[]" name="values"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="StringBuilder" name="sb">
                  <init>
                    <objectCreateExpression type="StringBuilder"/>
                  </init>
                </variableDeclarationStatement>
                <methodInvokeExpression methodName="AppendFormat">
                  <target>
                    <variableReferenceExpression name="sb"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="delete from {{0}}"/>
                    <argumentReferenceExpression name="tableName"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="AppendWhereExpressions">
                  <parameters>
                    <variableReferenceExpression name="sb"/>
                    <argumentReferenceExpression name="command"/>
                    <argumentReferenceExpression name="page"/>
                    <argumentReferenceExpression name="expressions"/>
                    <argumentReferenceExpression name="values"/>
                  </parameters>
                </methodInvokeExpression>
                <assignStatement>
                  <propertyReferenceExpression name="CommandText">
                    <argumentReferenceExpression name="command"/>
                  </propertyReferenceExpression>
                  <methodInvokeExpression methodName="ToString">
                    <target>
                      <variableReferenceExpression name="sb"/>
                    </target>
                  </methodInvokeExpression>
                </assignStatement>
                <methodReturnStatement>
                  <primitiveExpression value="true"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method ConfigureCommandForInsert(DbCommand, ViewPage, SelectClauseDictionary, string, FieldValue[]) -->
            <memberMethod returnType="System.Boolean" name="ConfigureCommandForInsert">
              <attributes private="true"/>
              <parameters>
                <parameter type="DbCommand" name="command"/>
                <parameter type="ViewPage" name="page"/>
                <parameter type="SelectClauseDictionary" name="expressions"/>
                <parameter type="System.String" name="tableName"/>
                <parameter type="FieldValue[]" name="values"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="StringBuilder" name="sb">
                  <init>
                    <objectCreateExpression type="StringBuilder"/>
                  </init>
                </variableDeclarationStatement>
                <methodInvokeExpression methodName="AppendFormat">
                  <target>
                    <variableReferenceExpression name="sb"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="insert into {{0}} ("/>
                    <variableReferenceExpression name="tableName"/>
                  </parameters>
                </methodInvokeExpression>
                <variableDeclarationStatement type="System.Boolean" name="firstField">
                  <init>
                    <primitiveExpression value="true"/>
                  </init>
                </variableDeclarationStatement>
                <!--<variableDeclarationStatement type="System.Boolean" name="hasPivotColumnKey">
                  <init>
                    <primitiveExpression value="false"/>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.Boolean" name="hasPivotRowKey">
                  <init>
                    <primitiveExpression value="false"/>
                  </init>
                </variableDeclarationStatement>-->
                <foreachStatement>
                  <variable type="FieldValue" name="v"/>
                  <target>
                    <argumentReferenceExpression name="values"/>
                  </target>
                  <statements>
                    <variableDeclarationStatement type="DataField" name="field">
                      <init>
                        <methodInvokeExpression methodName="FindField">
                          <target>
                            <variableReferenceExpression name="page"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="Name">
                              <variableReferenceExpression name="v"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <!-- 
                    if ((field != null) && (v.Modified || (field.Pivot == "ColumnKey" || field.Pivot == "RowKey")))
                    -->
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanAnd">
                          <binaryOperatorExpression operator="IdentityInequality">
                            <variableReferenceExpression name="field"/>
                            <primitiveExpression value="null"/>
                          </binaryOperatorExpression>
                          <propertyReferenceExpression name="Modified">
                            <variableReferenceExpression name="v"/>
                          </propertyReferenceExpression>
                          <!--<binaryOperatorExpression operator="BooleanOr">
                            <propertyReferenceExpression name="Modified">
                              <variableReferenceExpression name="v"/>
                            </propertyReferenceExpression>
                            <binaryOperatorExpression operator="BooleanOr">
                              <binaryOperatorExpression operator="ValueEquality">
                                <propertyReferenceExpression name="Pivot">
                                  <variableReferenceExpression name="field"/>
                                </propertyReferenceExpression>
                                <primitiveExpression value="ColumnKey"/>
                              </binaryOperatorExpression>
                              <binaryOperatorExpression operator="ValueEquality">
                                <propertyReferenceExpression name="Pivot">
                                  <variableReferenceExpression name="field"/>
                                </propertyReferenceExpression>
                                <primitiveExpression value="RowKey"/>
                              </binaryOperatorExpression>
                            </binaryOperatorExpression>
                          </binaryOperatorExpression>-->
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="AppendLine">
                          <target>
                            <variableReferenceExpression name="sb"/>
                          </target>
                        </methodInvokeExpression>
                        <conditionStatement>
                          <condition>
                            <variableReferenceExpression name="firstField"/>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="firstField"/>
                              <primitiveExpression value="false"/>
                            </assignStatement>
                          </trueStatements>
                          <falseStatements>
                            <methodInvokeExpression methodName="Append">
                              <target>
                                <variableReferenceExpression name="sb"/>
                              </target>
                              <parameters>
                                <primitiveExpression value=","/>
                              </parameters>
                            </methodInvokeExpression>
                          </falseStatements>
                        </conditionStatement>
                        <methodInvokeExpression methodName="AppendFormat">
                          <target>
                            <variableReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <methodInvokeExpression methodName="RemoveTableAliasFromExpression">
                              <parameters>
                                <arrayIndexerExpression>
                                  <target>
                                    <argumentReferenceExpression name="expressions"/>
                                  </target>
                                  <indices>
                                    <propertyReferenceExpression name="Name">
                                      <variableReferenceExpression name="v"/>
                                    </propertyReferenceExpression>
                                  </indices>
                                </arrayIndexerExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </parameters>
                        </methodInvokeExpression>
                        <!--<conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="ValueEquality">
                              <propertyReferenceExpression name="Pivot">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="ColumnKey"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="hasPivotColumnKey"/>
                              <binaryOperatorExpression operator="IdentityInequality">
                                <propertyReferenceExpression name="Value">
                                  <variableReferenceExpression name="v"/>
                                </propertyReferenceExpression>
                                <primitiveExpression value="null"/>
                              </binaryOperatorExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="ValueEquality">
                              <propertyReferenceExpression name="Pivot">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="RowKey"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="hasPivotRowKey"/>
                              <binaryOperatorExpression operator="IdentityInequality">
                                <propertyReferenceExpression name="Value">
                                  <variableReferenceExpression name="v"/>
                                </propertyReferenceExpression>
                                <primitiveExpression value="null"/>
                              </binaryOperatorExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>-->
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
                <conditionStatement>
                  <condition>
                    <variableReferenceExpression name="firstField"/>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="false"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <!--<conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueInequality">
                      <variableReferenceExpression name="hasPivotColumnKey"/>
                      <variableReferenceExpression name="hasPivotRowKey"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="false"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>-->
                <methodInvokeExpression methodName="AppendLine">
                  <target>
                    <variableReferenceExpression name="sb"/>
                  </target>
                  <parameters>
                    <primitiveExpression value=")"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="AppendLine">
                  <target>
                    <variableReferenceExpression name="sb"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="values("/>
                  </parameters>
                </methodInvokeExpression>
                <assignStatement>
                  <variableReferenceExpression name="firstField"/>
                  <primitiveExpression value="true"/>
                </assignStatement>
                <foreachStatement>
                  <variable type="FieldValue" name="v"/>
                  <target>
                    <argumentReferenceExpression name="values"/>
                  </target>
                  <statements>
                    <variableDeclarationStatement type="DataField" name="field">
                      <init>
                        <methodInvokeExpression methodName="FindField">
                          <target>
                            <argumentReferenceExpression name="page"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="Name">
                              <variableReferenceExpression name="v"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanAnd">
                          <binaryOperatorExpression operator="IdentityInequality">
                            <variableReferenceExpression name="field"/>
                            <primitiveExpression value="null"/>
                          </binaryOperatorExpression>
                          <propertyReferenceExpression name="Modified">
                            <variableReferenceExpression name="v"/>
                          </propertyReferenceExpression>
                          <!--<binaryOperatorExpression operator="BooleanOr">
                            <propertyReferenceExpression name="Modified">
                              <variableReferenceExpression name="v"/>
                            </propertyReferenceExpression>
                            <binaryOperatorExpression operator="BooleanOr">
                              <binaryOperatorExpression operator="ValueEquality">
                                <propertyReferenceExpression name="Pivot">
                                  <variableReferenceExpression name="field"/>
                                </propertyReferenceExpression>
                                <primitiveExpression value="ColumnKey"/>
                              </binaryOperatorExpression>
                              <binaryOperatorExpression operator="ValueEquality">
                                <propertyReferenceExpression name="Pivot">
                                  <variableReferenceExpression name="field"/>
                                </propertyReferenceExpression>
                                <primitiveExpression value="RowKey"/>
                              </binaryOperatorExpression>
                            </binaryOperatorExpression>
                          </binaryOperatorExpression>-->
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="AppendLine">
                          <target>
                            <variableReferenceExpression name="sb"/>
                          </target>
                        </methodInvokeExpression>
                        <conditionStatement>
                          <condition>
                            <variableReferenceExpression name="firstField"/>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="firstField"/>
                              <primitiveExpression value="false"/>
                            </assignStatement>
                          </trueStatements>
                          <falseStatements>
                            <methodInvokeExpression methodName="Append">
                              <target>
                                <variableReferenceExpression name="sb"/>
                              </target>
                              <parameters>
                                <primitiveExpression value=","/>
                              </parameters>
                            </methodInvokeExpression>
                          </falseStatements>
                        </conditionStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="BooleanAnd">
                              <binaryOperatorExpression operator="IdentityEquality">
                                <propertyReferenceExpression name="NewValue">
                                  <variableReferenceExpression name="v"/>
                                </propertyReferenceExpression>
                                <primitiveExpression value="null"/>
                              </binaryOperatorExpression>
                              <propertyReferenceExpression name="HasDefaultValue">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="Append">
                              <target>
                                <variableReferenceExpression name="sb"/>
                              </target>
                              <parameters>
                                <propertyReferenceExpression name="DefaultValue">
                                  <variableReferenceExpression name="field"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                          <falseStatements>
                            <methodInvokeExpression methodName="AppendFormat">
                              <target>
                                <variableReferenceExpression name="sb"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="{{0}}p{{1}}"/>
                                <fieldReferenceExpression name="parameterMarker"/>
                                <propertyReferenceExpression name="Count">
                                  <propertyReferenceExpression name="Parameters">
                                    <argumentReferenceExpression name="command"/>
                                  </propertyReferenceExpression>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                            <variableDeclarationStatement type="DbParameter" name="parameter">
                              <init>
                                <methodInvokeExpression methodName="CreateParameter">
                                  <target>
                                    <variableReferenceExpression name="command"/>
                                  </target>
                                </methodInvokeExpression>
                              </init>
                            </variableDeclarationStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="ParameterName">
                                <variableReferenceExpression name="parameter"/>
                              </propertyReferenceExpression>
                              <stringFormatExpression format="{{0}}p{{1}}">
                                <fieldReferenceExpression name="parameterMarker"/>
                                <propertyReferenceExpression name="Count">
                                  <propertyReferenceExpression name="Parameters">
                                    <variableReferenceExpression name="command"/>
                                  </propertyReferenceExpression>
                                </propertyReferenceExpression>
                              </stringFormatExpression>
                              <!--<methodInvokeExpression methodName="Format">
                                <target>
                                  <typeReferenceExpression type="String"/>
                                </target>
                                <parameters>
                                  <primitiveExpression value="{{0}}p{{1}}"/>
                                  <fieldReferenceExpression name="parameterMarker"/>
                                  <propertyReferenceExpression name="Count">
                                    <propertyReferenceExpression name="Parameters">
                                      <variableReferenceExpression name="command"/>
                                    </propertyReferenceExpression>
                                  </propertyReferenceExpression>
                                </parameters>
                              </methodInvokeExpression>-->
                            </assignStatement>
                            <methodInvokeExpression methodName="AssignParameterValue">
                              <parameters>
                                <variableReferenceExpression name="parameter"/>
                                <propertyReferenceExpression name="Type">
                                  <variableReferenceExpression name="field"/>
                                </propertyReferenceExpression>
                                <propertyReferenceExpression name="NewValue">
                                  <variableReferenceExpression name="v"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <propertyReferenceExpression name="Parameters">
                                  <variableReferenceExpression name="command"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="parameter"/>
                              </parameters>
                            </methodInvokeExpression>
                          </falseStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
                <methodInvokeExpression methodName="AppendLine">
                  <target>
                    <variableReferenceExpression name="sb"/>
                  </target>
                  <parameters>
                    <primitiveExpression value=")"/>
                  </parameters>
                </methodInvokeExpression>
                <assignStatement>
                  <propertyReferenceExpression name="CommandText">
                    <variableReferenceExpression name="command"/>
                  </propertyReferenceExpression>
                  <methodInvokeExpression methodName="ToString">
                    <target>
                      <variableReferenceExpression name="sb"/>
                    </target>
                  </methodInvokeExpression>
                </assignStatement>
                <methodReturnStatement>
                  <primitiveExpression value="true"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method RemoveTableAliasFromExpression(string) -->
            <memberMethod returnType="System.String" name="RemoveTableAliasFromExpression">
              <attributes private="true"/>
              <parameters>
                <parameter type="System.String" name="expression"/>
              </parameters>
              <statements>
                <comment>alias extraction regular expression:</comment>
                <comment>"[\w\s]+".("[\w\s]+")</comment>
                <variableDeclarationStatement type="Match" name="m">
                  <init>
                    <methodInvokeExpression methodName="Match">
                      <target>
                        <typeReferenceExpression type="Regex"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="expression"/>
                        <primitiveExpression value="&quot;[\w\s]+&quot;.(&quot;[\w\s]+&quot;)"/>
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
                  <argumentReferenceExpression name="expression"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method ConfigureCommandForUpdate(DbCommand, ViewPage, SelectClauseDictionary, string, FieldValue[]) -->
            <memberMethod returnType="System.Boolean" name="ConfigureCommandForUpdate">
              <attributes private="true"/>
              <parameters>
                <parameter type="DbCommand" name="command"/>
                <parameter type="ViewPage" name="page"/>
                <parameter type="SelectClauseDictionary" name="expressions"/>
                <parameter type="System.String" name="tableName"/>
                <parameter type="FieldValue[]" name="values"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="StringBuilder" name="sb">
                  <init>
                    <objectCreateExpression type="StringBuilder"/>
                  </init>
                </variableDeclarationStatement>
                <methodInvokeExpression methodName="AppendFormat">
                  <target>
                    <variableReferenceExpression name="sb"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="update {{0}} set "/>
                    <variableReferenceExpression name="tableName"/>
                  </parameters>
                </methodInvokeExpression>
                <variableDeclarationStatement type="System.Boolean" name="firstField">
                  <init>
                    <primitiveExpression value="true"/>
                  </init>
                </variableDeclarationStatement>
                <foreachStatement>
                  <variable type="FieldValue" name="v"/>
                  <target>
                    <argumentReferenceExpression name="values"/>
                  </target>
                  <statements>
                    <variableDeclarationStatement type="DataField" name="field">
                      <init>
                        <methodInvokeExpression methodName="FindField">
                          <target>
                            <argumentReferenceExpression name="page"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="Name">
                              <variableReferenceExpression name="v"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanAnd">
                          <binaryOperatorExpression operator="IdentityInequality">
                            <variableReferenceExpression name="field"/>
                            <primitiveExpression value="null"/>
                          </binaryOperatorExpression>
                          <propertyReferenceExpression name="Modified">
                            <variableReferenceExpression name="v"/>
                          </propertyReferenceExpression>
                          <!--<binaryOperatorExpression operator="BooleanAnd">
                            <unaryOperatorExpression operator="Not">
                              <propertyReferenceExpression name="ReadOnly">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                            </unaryOperatorExpression>
                            <propertyReferenceExpression name="Modified">
                              <variableReferenceExpression name="v"/>
                            </propertyReferenceExpression>
                          </binaryOperatorExpression>-->
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="AppendLine">
                          <target>
                            <variableReferenceExpression name="sb"/>
                          </target>
                        </methodInvokeExpression>
                        <conditionStatement>
                          <condition>
                            <variableReferenceExpression name="firstField"/>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="firstField"/>
                              <primitiveExpression value="false"/>
                            </assignStatement>
                          </trueStatements>
                          <falseStatements>
                            <methodInvokeExpression methodName="Append">
                              <target>
                                <variableReferenceExpression name="sb"/>
                              </target>
                              <parameters>
                                <primitiveExpression value=","/>
                              </parameters>
                            </methodInvokeExpression>
                          </falseStatements>
                        </conditionStatement>
                        <methodInvokeExpression methodName="AppendFormat">
                          <target>
                            <variableReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <methodInvokeExpression methodName="RemoveTableAliasFromExpression">
                              <parameters>
                                <arrayIndexerExpression>
                                  <target>
                                    <argumentReferenceExpression name="expressions"/>
                                  </target>
                                  <indices>
                                    <propertyReferenceExpression name="Name">
                                      <argumentReferenceExpression name="v"/>
                                    </propertyReferenceExpression>
                                  </indices>
                                </arrayIndexerExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </parameters>
                        </methodInvokeExpression>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="BooleanAnd">
                              <binaryOperatorExpression operator="IdentityEquality">
                                <propertyReferenceExpression name="NewValue">
                                  <variableReferenceExpression name="v"/>
                                </propertyReferenceExpression>
                                <primitiveExpression value="null"/>
                              </binaryOperatorExpression>
                              <propertyReferenceExpression name="HasDefaultValue">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="Append">
                              <target>
                                <variableReferenceExpression name="sb"/>
                              </target>
                              <parameters>
                                <stringFormatExpression format="={{0}}">
                                  <propertyReferenceExpression name="DefaultValue">
                                    <variableReferenceExpression name="field"/>
                                  </propertyReferenceExpression>
                                </stringFormatExpression>
                                <!--<methodInvokeExpression methodName="Format">
                                  <target>
                                    <typeReferenceExpression type="String"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="={{0}}"/>
                                    <propertyReferenceExpression name="DefaultValue">
                                      <variableReferenceExpression name="field"/>
                                    </propertyReferenceExpression>
                                  </parameters>
                                </methodInvokeExpression>-->
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                          <falseStatements>
                            <methodInvokeExpression methodName="AppendFormat">
                              <target>
                                <variableReferenceExpression name="sb"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="={{0}}p{{1}}"/>
                                <fieldReferenceExpression name="parameterMarker"/>
                                <propertyReferenceExpression name="Count">
                                  <propertyReferenceExpression name="Parameters">
                                    <argumentReferenceExpression name="command"/>
                                  </propertyReferenceExpression>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                            <variableDeclarationStatement type="DbParameter" name="parameter">
                              <init>
                                <methodInvokeExpression methodName="CreateParameter">
                                  <target>
                                    <argumentReferenceExpression name="command"/>
                                  </target>
                                </methodInvokeExpression>
                              </init>
                            </variableDeclarationStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="ParameterName">
                                <variableReferenceExpression name="parameter"/>
                              </propertyReferenceExpression>
                              <stringFormatExpression format="{{0}}p{{1}}">
                                <fieldReferenceExpression name="parameterMarker"/>
                                <propertyReferenceExpression name="Count">
                                  <propertyReferenceExpression name="Parameters">
                                    <argumentReferenceExpression name="command"/>
                                  </propertyReferenceExpression>
                                </propertyReferenceExpression>
                              </stringFormatExpression>
                              <!--<methodInvokeExpression methodName="Format">
                                <target>
                                  <typeReferenceExpression type="String"/>
                                </target>
                                <parameters>
                                  <primitiveExpression value="{{0}}p{{1}}"/>
                                  <fieldReferenceExpression name="parameterMarker"/>
                                  <propertyReferenceExpression name="Count">
                                    <propertyReferenceExpression name="Parameters">
                                      <argumentReferenceExpression name="command"/>
                                    </propertyReferenceExpression>
                                  </propertyReferenceExpression>
                                </parameters>
                              </methodInvokeExpression>-->
                            </assignStatement>
                            <methodInvokeExpression methodName="AssignParameterValue">
                              <parameters>
                                <variableReferenceExpression name="parameter"/>
                                <propertyReferenceExpression name="Type">
                                  <variableReferenceExpression name="field"/>
                                </propertyReferenceExpression>
                                <propertyReferenceExpression name="NewValue">
                                  <variableReferenceExpression name="v"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <propertyReferenceExpression name="Parameters">
                                  <argumentReferenceExpression name="command"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="parameter"/>
                              </parameters>
                            </methodInvokeExpression>
                          </falseStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
                <conditionStatement>
                  <condition>
                    <variableReferenceExpression name="firstField"/>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="false"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <methodInvokeExpression methodName="AppendWhereExpressions">
                  <parameters>
                    <variableReferenceExpression name="sb"/>
                    <argumentReferenceExpression name="command"/>
                    <argumentReferenceExpression name="page"/>
                    <argumentReferenceExpression name="expressions"/>
                    <argumentReferenceExpression name="values"/>
                  </parameters>
                </methodInvokeExpression>
                <assignStatement>
                  <propertyReferenceExpression name="CommandText">
                    <variableReferenceExpression name="command"/>
                  </propertyReferenceExpression>
                  <methodInvokeExpression methodName="ToString">
                    <target>
                      <variableReferenceExpression name="sb"/>
                    </target>
                  </methodInvokeExpression>
                </assignStatement>
                <methodReturnStatement>
                  <primitiveExpression value="true"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method ConfigureCommandForSelect(DbCommand, ViewPage, SelectClauseDictionary, string, string, string, CommandConfigurationType-->
            <memberMethod name="ConfigureCommandForSelect">
              <attributes private="true"/>
              <parameters>
                <parameter type="DbCommand" name="command"/>
                <parameter type="ViewPage" name="page"/>
                <parameter type="SelectClauseDictionary" name="expressions"/>
                <parameter type="System.String" name="fromClause"/>
                <parameter type="System.String" name="whereClause"/>
                <parameter type="System.String" name="orderByClause"/>
                <parameter type="CommandConfigurationType" name="commandConfiguration"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.Boolean" name="useServerPaging">
                  <init>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <binaryOperatorExpression operator="BooleanAnd">
                        <binaryOperatorExpression operator="ValueInequality">
                          <argumentReferenceExpression name="commandConfiguration"/>
                          <propertyReferenceExpression name="SelectDistinct">
                            <typeReferenceExpression type="CommandConfigurationType"/>
                          </propertyReferenceExpression>
                        </binaryOperatorExpression>
                        <unaryOperatorExpression operator="Not">
                          <propertyReferenceExpression name="EnableResultSet">
                            <fieldReferenceExpression name="serverRules"/>
                          </propertyReferenceExpression>
                        </unaryOperatorExpression>
                      </binaryOperatorExpression>
                      <binaryOperatorExpression operator="BooleanAnd">
                        <binaryOperatorExpression operator="ValueInequality">
                          <argumentReferenceExpression name="commandConfiguration"/>
                          <propertyReferenceExpression name="SelectAggregates">
                            <typeReferenceExpression type="CommandConfigurationType"/>
                          </propertyReferenceExpression>
                        </binaryOperatorExpression>
                        <binaryOperatorExpression operator="ValueInequality">
                          <argumentReferenceExpression name="commandConfiguration"/>
                          <propertyReferenceExpression name="SelectFirstLetters">
                            <typeReferenceExpression type="CommandConfigurationType"/>
                          </propertyReferenceExpression>
                        </binaryOperatorExpression>
                      </binaryOperatorExpression>
                    </binaryOperatorExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.Boolean" name="useLimit">
                  <init>
                    <methodInvokeExpression methodName="SupportsLimitInSelect">
                      <parameters>
                        <argumentReferenceExpression name="command"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.Boolean" name="useSkip">
                  <init>
                    <methodInvokeExpression methodName="SupportsSkipInSelect">
                      <parameters>
                        <argumentReferenceExpression name="command"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <variableReferenceExpression name="useServerPaging"/>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="AcceptAllRows">
                      <target>
                        <argumentReferenceExpression name="page"/>
                      </target>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="StringBuilder" name="sb">
                  <init>
                    <objectCreateExpression type="StringBuilder"/>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanOr">
                      <variableReferenceExpression name="useLimit"/>
                      <variableReferenceExpression name="useSkip"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="useServerPaging"/>
                      <primitiveExpression value="false"/>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="System.Boolean" name="countUsingHierarchy">
                  <init>
                    <primitiveExpression value="false"/>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <binaryOperatorExpression operator="ValueEquality">
                        <argumentReferenceExpression name="commandConfiguration"/>
                        <propertyReferenceExpression name="SelectCount">
                          <typeReferenceExpression type="CommandConfigurationType"/>
                        </propertyReferenceExpression>
                      </binaryOperatorExpression>
                      <binaryOperatorExpression operator="BooleanAnd">
                        <variableReferenceExpression name="useServerPaging"/>
                        <methodInvokeExpression methodName="RequiresHierarchy">
                          <parameters>
                            <argumentReferenceExpression name="page"/>
                          </parameters>
                        </methodInvokeExpression>
                      </binaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="countUsingHierarchy"/>
                      <primitiveExpression value="true"/>
                    </assignStatement>
                    <assignStatement>
                      <argumentReferenceExpression name="commandConfiguration"/>
                      <propertyReferenceExpression name="Select">
                        <typeReferenceExpression type="CommandConfigurationType"/>
                      </propertyReferenceExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <argumentReferenceExpression name="commandConfiguration"/>
                      <propertyReferenceExpression name="SelectExisting">
                        <typeReferenceExpression type="CommandConfigurationType"/>
                      </propertyReferenceExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="useServerPaging"/>
                      <primitiveExpression value="false"/>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <argumentReferenceExpression name="commandConfiguration"/>
                      <propertyReferenceExpression name="SelectCount">
                        <typeReferenceExpression type="CommandConfigurationType"/>
                      </propertyReferenceExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="AppendLine">
                      <target>
                        <variableReferenceExpression name="sb"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="select count(*)"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                  <falseStatements>
                    <conditionStatement>
                      <condition>
                        <variableReferenceExpression name="useServerPaging"/>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="AppendLine">
                          <target>
                            <variableReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="with page_cte__ as ("/>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                      <falseStatements>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="BooleanAnd">
                              <binaryOperatorExpression operator="ValueEquality">
                                <argumentReferenceExpression name="commandConfiguration"/>
                                <propertyReferenceExpression name="Sync">
                                  <typeReferenceExpression type="CommandConfigurationType"/>
                                </propertyReferenceExpression>
                              </binaryOperatorExpression>
                              <variableReferenceExpression name="useLimit"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="Append">
                              <target>
                                <argumentReferenceExpression name="sb"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="select * from (select @row_num := @row_num+1 row_number__,cte__.* from (select @row_num:=0) r,("/>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>
                      </falseStatements>
                    </conditionStatement>
                    <methodInvokeExpression methodName="AppendLine">
                      <target>
                        <variableReferenceExpression name="sb"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="select"/>
                      </parameters>
                    </methodInvokeExpression>
                    <conditionStatement>
                      <condition>
                        <variableReferenceExpression name="useServerPaging"/>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="AppendRowNumberExpression">
                          <parameters>
                            <variableReferenceExpression name="sb"/>
                            <argumentReferenceExpression name="page"/>
                            <argumentReferenceExpression name="expressions"/>
                            <argumentReferenceExpression name="orderByClause"/>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="ValueEquality">
                          <argumentReferenceExpression name="commandConfiguration"/>
                          <propertyReferenceExpression name="SelectDistinct">
                            <typeReferenceExpression type="CommandConfigurationType"/>
                          </propertyReferenceExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="DataField" name="distinctField">
                          <init>
                            <methodInvokeExpression methodName="FindField">
                              <target>
                                <variableReferenceExpression name="page"/>
                              </target>
                              <parameters>
                                <propertyReferenceExpression name="DistinctValueFieldName">
                                  <argumentReferenceExpression name="page"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <variableDeclarationStatement type="System.String" name="distinctExpression">
                          <init>
                            <arrayIndexerExpression>
                              <target>
                                <argumentReferenceExpression name="expressions"/>
                              </target>
                              <indices>
                                <methodInvokeExpression methodName="ExpressionName">
                                  <target>
                                    <variableReferenceExpression name="distinctField"/>
                                  </target>
                                </methodInvokeExpression>
                              </indices>
                            </arrayIndexerExpression>
                          </init>
                        </variableDeclarationStatement>
                        <!-- 
                    if (distinctField.Type.StartsWith("Date"))
                        if (command.GetType().ToString() == "System.Data.SqlClient.SqlCommand")
                            distinctExpression = String.Format("DATEADD(dd, 0, DATEDIFF(dd, 0, {0}))", distinctExpression);
                        else if (command.GetType().ToString() == "MySql.Data.MySqlClient.MySqlCommand")
                            distinctExpression = String.Format("cast({0} as date)", distinctExpression);
                        -->

                        <conditionStatement>
                          <condition>
                            <methodInvokeExpression methodName="StartsWith">
                              <target>
                                <propertyReferenceExpression name="Type">
                                  <variableReferenceExpression name="distinctField"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="Date"/>
                              </parameters>
                            </methodInvokeExpression>
                          </condition>
                          <trueStatements>
                            <variableDeclarationStatement type="System.String" name="commandType">
                              <init>
                                <methodInvokeExpression methodName="ToString">
                                  <target>
                                    <methodInvokeExpression methodName="GetType">
                                      <target>
                                        <argumentReferenceExpression name="command"/>
                                      </target>
                                    </methodInvokeExpression>
                                  </target>
                                </methodInvokeExpression>
                              </init>
                            </variableDeclarationStatement>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="ValueEquality">
                                  <variableReferenceExpression name="commandType"/>
                                  <primitiveExpression value="System.Data.SqlClient.SqlCommand"/>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="distinctExpression"/>
                                  <stringFormatExpression format="DATEADD(dd, 0, DATEDIFF(dd, 0, {{0}}))">
                                    <variableReferenceExpression name="distinctExpression"/>
                                  </stringFormatExpression>
                                  <!--<methodInvokeExpression methodName="Format">
                                    <target>
                                      <typeReferenceExpression type="String"/>
                                    </target>
                                    <parameters>
                                      <primitiveExpression value="DATEADD(dd, 0, DATEDIFF(dd, 0, {{0}}))"/>
                                      <variableReferenceExpression name="distinctExpression"/>
                                    </parameters>
                                  </methodInvokeExpression>-->
                                </assignStatement>
                              </trueStatements>
                            </conditionStatement>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="ValueEquality">
                                  <variableReferenceExpression name="commandType"/>
                                  <primitiveExpression value="MySql.Data.MySqlClient.MySqlCommand"/>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="distinctExpression"/>
                                  <stringFormatExpression format="cast({{0}} as date)">
                                    <variableReferenceExpression name="distinctExpression"/>
                                  </stringFormatExpression>
                                  <!--<methodInvokeExpression methodName="Format">
                                    <target>
                                      <typeReferenceExpression type="String"/>
                                    </target>
                                    <parameters>
                                      <primitiveExpression value="cast({{0}} as date)"/>
                                      <variableReferenceExpression name="distinctExpression"/>
                                    </parameters>
                                  </methodInvokeExpression>-->
                                </assignStatement>
                              </trueStatements>
                            </conditionStatement>
                          </trueStatements>
                        </conditionStatement>
                        <!--<conditionStatement>
													<condition>
														<binaryOperatorExpression operator="BooleanAnd">
															<binaryOperatorExpression operator="ValueEquality">
																<propertyReferenceExpression name="Type">
																	<variableReferenceExpression name="distinctField"/>
																</propertyReferenceExpression>
																<primitiveExpression value="DateTimeOffset"/>
															</binaryOperatorExpression>
															<binaryOperatorExpression operator="ValueEquality">
																<methodInvokeExpression methodName="ToString">
																	<target>
																		<methodInvokeExpression methodName="GetType">
																			<target>
																				<argumentReferenceExpression name="command"/>
																			</target>
																		</methodInvokeExpression>
																	</target>
																</methodInvokeExpression>
																<primitiveExpression value="System.Data.SqlClient.SqlCommand"/>
															</binaryOperatorExpression>
														</binaryOperatorExpression>
													</condition>
													<trueStatements>
														<assignStatement>
															<variableReferenceExpression name="distinctExpression"/>
															<methodInvokeExpression methodName="Format">
																<target>
																	<typeReferenceExpression type="String"/>
																</target>
																<parameters>
																	<primitiveExpression value="cast(floor(cast(cast({{0}} as datetime) as float)) as datetime)"/>
																	<variableReferenceExpression name="distinctExpression"/>
																</parameters>
															</methodInvokeExpression>
														</assignStatement>
													</trueStatements>
												</conditionStatement>-->
                        <methodInvokeExpression methodName="AppendFormat">
                          <target>
                            <variableReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="distinct {{0}} &quot;{{1}}&quot;&#13;&#10;"/>
                            <variableReferenceExpression name="distinctExpression"/>
                            <propertyReferenceExpression name="DistinctValueFieldName">
                              <argumentReferenceExpression name="page"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                      <falseStatements>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="ValueEquality">
                              <argumentReferenceExpression name="commandConfiguration"/>
                              <propertyReferenceExpression name="SelectAggregates">
                                <typeReferenceExpression type="CommandConfigurationType"/>
                              </propertyReferenceExpression>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="AppendAggregateExpressions">
                              <parameters>
                                <argumentReferenceExpression name="sb"/>
                                <argumentReferenceExpression name="page"/>
                                <argumentReferenceExpression name="expressions"/>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                          <falseStatements>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="ValueEquality">
                                  <argumentReferenceExpression name="commandConfiguration"/>
                                  <propertyReferenceExpression name="SelectFirstLetters">
                                    <typeReferenceExpression type="CommandConfigurationType"/>
                                  </propertyReferenceExpression>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <variableDeclarationStatement type="System.String" name="substringFunction">
                                  <init>
                                    <primitiveExpression value="substring"/>
                                  </init>
                                </variableDeclarationStatement>
                                <conditionStatement>
                                  <condition>
                                    <methodInvokeExpression methodName="DatabaseEngineIs">
                                      <parameters>
                                        <argumentReferenceExpression name="command"/>
                                        <primitiveExpression value="Oracle"/>
                                        <primitiveExpression value="DB2"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                    <!--<methodInvokeExpression methodName="Contains">
                                      <target>
                                        <propertyReferenceExpression name="Name">
                                          <methodInvokeExpression methodName="GetType">
                                            <target>
                                              <argumentReferenceExpression name="command"/>
                                            </target>
                                          </methodInvokeExpression>
                                        </propertyReferenceExpression>
                                      </target>
                                      <parameters>
                                        <primitiveExpression value="Oracle"/>
                                      </parameters>
                                    </methodInvokeExpression>-->
                                  </condition>
                                  <trueStatements>
                                    <assignStatement>
                                      <variableReferenceExpression name="substringFunction"/>
                                      <primitiveExpression value="substr"/>
                                    </assignStatement>
                                  </trueStatements>
                                </conditionStatement>
                                <methodInvokeExpression methodName="AppendFirstLetterExpressions">
                                  <parameters>
                                    <argumentReferenceExpression name="sb"/>
                                    <argumentReferenceExpression name="page"/>
                                    <argumentReferenceExpression name="expressions"/>
                                    <variableReferenceExpression name="substringFunction"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </trueStatements>
                              <falseStatements>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="BooleanAnd">
                                      <binaryOperatorExpression operator="ValueEquality">
                                        <variableReferenceExpression name="commandConfiguration"/>
                                        <propertyReferenceExpression name="Select">
                                          <typeReferenceExpression type="CommandConfigurationType"/>
                                        </propertyReferenceExpression>
                                      </binaryOperatorExpression>
                                      <variableReferenceExpression name="useSkip"/>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <methodInvokeExpression methodName="AppendFormat">
                                      <target>
                                        <variableReferenceExpression name="sb"/>
                                      </target>
                                      <parameters>
                                        <primitiveExpression value=" first {{0}} skip {{1}}&#13;&#10;"/>
                                        <propertyReferenceExpression name="PageSize">
                                          <argumentReferenceExpression name="page"/>
                                        </propertyReferenceExpression>
                                        <binaryOperatorExpression operator="Multiply">
                                          <propertyReferenceExpression name="PageSize">
                                            <argumentReferenceExpression name="page"/>
                                          </propertyReferenceExpression>
                                          <propertyReferenceExpression name="PageIndex">
                                            <argumentReferenceExpression name="page"/>
                                          </propertyReferenceExpression>
                                        </binaryOperatorExpression>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </trueStatements>
                                </conditionStatement>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="BooleanAnd">
                                      <binaryOperatorExpression operator="ValueEquality">
                                        <variableReferenceExpression name="commandConfiguration"/>
                                        <propertyReferenceExpression name="Sync">
                                          <typeReferenceExpression type="CommandConfigurationType"/>
                                        </propertyReferenceExpression>
                                      </binaryOperatorExpression>
                                      <variableReferenceExpression name="useSkip"/>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <comment>Only select the primary key.</comment>
                                    <foreachStatement>
                                      <variable type="DataField" name="field"/>
                                      <target>
                                        <propertyReferenceExpression name="Fields">
                                          <argumentReferenceExpression name="page"/>
                                        </propertyReferenceExpression>
                                      </target>
                                      <statements>
                                        <conditionStatement>
                                          <condition>
                                            <propertyReferenceExpression name="IsPrimaryKey">
                                              <variableReferenceExpression name="field"/>
                                            </propertyReferenceExpression>
                                          </condition>
                                          <trueStatements>
                                            <methodInvokeExpression methodName="Append">
                                              <target>
                                                <variableReferenceExpression name="sb"/>
                                              </target>
                                              <parameters>
                                                <arrayIndexerExpression>
                                                  <target>
                                                    <argumentReferenceExpression name="expressions"/>
                                                  </target>
                                                  <indices>
                                                    <methodInvokeExpression methodName="ExpressionName">
                                                      <target>
                                                        <variableReferenceExpression name="field"/>
                                                      </target>
                                                    </methodInvokeExpression>
                                                  </indices>
                                                </arrayIndexerExpression>
                                              </parameters>
                                            </methodInvokeExpression>
                                            <breakStatement/>
                                          </trueStatements>
                                        </conditionStatement>
                                      </statements>
                                    </foreachStatement>
                                  </trueStatements>
                                  <falseStatements>
                                    <conditionStatement>
                                      <condition>
                                        <binaryOperatorExpression operator="ValueEquality">
                                          <argumentReferenceExpression name="commandConfiguration"/>
                                          <propertyReferenceExpression name="SelectExisting">
                                            <typeReferenceExpression type="CommandConfigurationType"/>
                                          </propertyReferenceExpression>
                                        </binaryOperatorExpression>
                                      </condition>
                                      <trueStatements>
                                        <methodInvokeExpression methodName="AppendLine">
                                          <target>
                                            <variableReferenceExpression name="sb"/>
                                          </target>
                                          <parameters>
                                            <primitiveExpression value="*"/>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </trueStatements>
                                      <falseStatements>
                                        <methodInvokeExpression methodName="AppendSelectExpressions">
                                          <parameters>
                                            <variableReferenceExpression name="sb"/>
                                            <argumentReferenceExpression name="page"/>
                                            <argumentReferenceExpression name="expressions"/>
                                            <unaryOperatorExpression operator="Not">
                                              <variableReferenceExpression name="useServerPaging"/>
                                            </unaryOperatorExpression>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </falseStatements>
                                    </conditionStatement>
                                  </falseStatements>
                                </conditionStatement>
                              </falseStatements>
                            </conditionStatement>
                          </falseStatements>
                        </conditionStatement>
                      </falseStatements>
                    </conditionStatement>
                  </falseStatements>
                </conditionStatement>
                <methodInvokeExpression methodName="AppendLine">
                  <target>
                    <variableReferenceExpression name="sb"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="from"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="AppendLine">
                  <target>
                    <variableReferenceExpression name="sb"/>
                  </target>
                  <parameters>
                    <argumentReferenceExpression name="fromClause"/>
                  </parameters>
                </methodInvokeExpression>
                <assignStatement>
                  <fieldReferenceExpression name="hasWhere"/>
                  <primitiveExpression value="false"/>
                </assignStatement>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="IsNullOrEmpty">
                      <fieldReferenceExpression name="viewFilter"/>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <fieldReferenceExpression name="viewFilter"/>
                      <methodInvokeExpression methodName="GetAttribute">
                        <target>
                          <fieldReferenceExpression name="view"/>
                        </target>
                        <parameters>
                          <primitiveExpression value="filter"/>
                          <propertyReferenceExpression name="Empty">
                            <typeReferenceExpression type="String"/>
                          </propertyReferenceExpression>
                        </parameters>
                      </methodInvokeExpression>
                    </assignStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanAnd">
                          <unaryOperatorExpression operator="IsNullOrEmpty">
                            <fieldReferenceExpression name="viewFilter"/>
                          </unaryOperatorExpression>
                          <binaryOperatorExpression operator="BooleanAnd">
                            <binaryOperatorExpression operator="ValueEquality">
                              <fieldReferenceExpression name="viewType"/>
                              <primitiveExpression value="Form"/>
                            </binaryOperatorExpression>
                            <unaryOperatorExpression operator="IsNotNullOrEmpty">
                              <propertyReferenceExpression name="LastView">
                                <argumentReferenceExpression name="page"/>
                              </propertyReferenceExpression>
                            </unaryOperatorExpression>
                          </binaryOperatorExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="XPathNavigator" name="lastView">
                          <init>
                            <methodInvokeExpression methodName="SelectSingleNode">
                              <target>
                                <fieldReferenceExpression name="config"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="/c:dataController/c:views/c:view[@id='{{0}}']"/>
                                <propertyReferenceExpression name="LastView">
                                  <argumentReferenceExpression name="page"/>
                                </propertyReferenceExpression>
                                <!--<stringFormatExpression format="/c:dataController/c:views/c:view[@id='{{0}}']">
                                  <propertyReferenceExpression name="LastView">
                                    <argumentReferenceExpression name="page"/>
                                  </propertyReferenceExpression>
                                </stringFormatExpression>
                                <propertyReferenceExpression name="Resolver">
                                  <fieldReferenceExpression name="config"/>
                                </propertyReferenceExpression>-->
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="IdentityInequality">
                              <variableReferenceExpression name="lastView"/>
                              <primitiveExpression value="null"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <fieldReferenceExpression name="viewFilter"/>
                              <methodInvokeExpression methodName="GetAttribute">
                                <target>
                                  <variableReferenceExpression name="lastView"/>
                                </target>
                                <parameters>
                                  <primitiveExpression value="filter"/>
                                  <propertyReferenceExpression name="Empty">
                                    <typeReferenceExpression type="String"/>
                                  </propertyReferenceExpression>
                                </parameters>
                              </methodInvokeExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="IsNotNullOrEmpty">
                      <fieldReferenceExpression name="viewFilter"/>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <fieldReferenceExpression name="viewFilter"/>
                      <stringFormatExpression format="({{0}})">
                        <fieldReferenceExpression name="viewFilter"/>
                      </stringFormatExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <argumentReferenceExpression name="commandConfiguration"/>
                      <propertyReferenceExpression name="SelectExisting">
                        <typeReferenceExpression type="CommandConfigurationType"/>
                      </propertyReferenceExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="EnsureWhereKeyword">
                      <parameters>
                        <argumentReferenceExpression name="sb"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="Append">
                      <target>
                        <variableReferenceExpression name="sb"/>
                      </target>
                      <parameters>
                        <arrayIndexerExpression>
                          <target>
                            <argumentReferenceExpression name="expressions"/>
                          </target>
                          <indices>
                            <methodInvokeExpression methodName="ToLower">
                              <target>
                                <propertyReferenceExpression name="InnerJoinForeignKey">
                                  <argumentReferenceExpression name="page"/>
                                </propertyReferenceExpression>
                              </target>
                            </methodInvokeExpression>
                          </indices>
                        </arrayIndexerExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="Append">
                      <target>
                        <variableReferenceExpression name="sb"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="="/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="Append">
                      <target>
                        <variableReferenceExpression name="sb"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="InnerJoinPrimaryKey">
                          <argumentReferenceExpression name="page"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="AppendLine">
                      <target>
                        <variableReferenceExpression name="sb"/>
                      </target>
                      <parameters>
                        <primitiveExpression value=" and "/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <methodInvokeExpression methodName="AppendSystemFilter">
                  <parameters>
                    <argumentReferenceExpression name="command"/>
                    <argumentReferenceExpression name="page"/>
                    <argumentReferenceExpression name="expressions"/>
                  </parameters>
                </methodInvokeExpression>
                <xsl:if test="$IsPremium='true'">
                  <methodInvokeExpression methodName="AppendAccessControlRules">
                    <parameters>
                      <argumentReferenceExpression name="command"/>
                      <argumentReferenceExpression name="page"/>
                      <argumentReferenceExpression name="expressions"/>
                    </parameters>
                  </methodInvokeExpression>
                </xsl:if>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanOr">
                      <binaryOperatorExpression operator="BooleanAnd">
                        <binaryOperatorExpression operator="IdentityInequality">
                          <propertyReferenceExpression name="Filter">
                            <argumentReferenceExpression name="page"/>
                          </propertyReferenceExpression>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                        <binaryOperatorExpression operator="GreaterThan">
                          <propertyReferenceExpression name="Length">
                            <propertyReferenceExpression name="Filter">
                              <argumentReferenceExpression name="page"/>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                          <primitiveExpression value="0"/>
                        </binaryOperatorExpression>
                      </binaryOperatorExpression>
                      <unaryOperatorExpression operator="Not">
                        <methodInvokeExpression methodName="IsNullOrEmpty">
                          <target>
                            <typeReferenceExpression type="String"/>
                          </target>
                          <parameters>
                            <fieldReferenceExpression name="viewFilter"/>
                          </parameters>
                        </methodInvokeExpression>
                      </unaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="AppendFilterExpressionsToWhere">
                      <parameters>
                        <variableReferenceExpression name="sb"/>
                        <argumentReferenceExpression name="page"/>
                        <argumentReferenceExpression name="command"/>
                        <argumentReferenceExpression name="expressions"/>
                        <argumentReferenceExpression name="whereClause"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                  <falseStatements>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="Not">
                          <methodInvokeExpression methodName="IsNullOrEmpty">
                            <target>
                              <typeReferenceExpression type="String"/>
                            </target>
                            <parameters>
                              <argumentReferenceExpression name="whereClause"/>
                            </parameters>
                          </methodInvokeExpression>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="EnsureWhereKeyword">
                          <parameters>
                            <variableReferenceExpression name="sb"/>
                          </parameters>
                        </methodInvokeExpression>
                        <methodInvokeExpression methodName="AppendLine">
                          <target>
                            <variableReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <argumentReferenceExpression name="whereClause"/>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                  </falseStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <argumentReferenceExpression name="commandConfiguration"/>
                      <propertyReferenceExpression name="Select">
                        <typeReferenceExpression type="CommandConfigurationType"/>
                      </propertyReferenceExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="System.Boolean" name="preFetch">
                      <init>
                        <methodInvokeExpression methodName="RequiresPreFetching">
                          <parameters>
                            <variableReferenceExpression name="page"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <variableReferenceExpression name="useServerPaging"/>
                      </condition>
                      <trueStatements>
                        <conditionStatement>
                          <condition>
                            <unaryOperatorExpression operator="Not">
                              <methodInvokeExpression methodName="ConfigureCTE">
                                <parameters>
                                  <variableReferenceExpression name="sb"/>
                                  <variableReferenceExpression name="page"/>
                                  <variableReferenceExpression name="command"/>
                                  <variableReferenceExpression name="expressions"/>
                                  <variableReferenceExpression name="countUsingHierarchy"/>
                                </parameters>
                              </methodInvokeExpression>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="Append">
                              <target>
                                <variableReferenceExpression name="sb"/>
                              </target>
                              <parameters>
                                <primitiveExpression value=")&#13;&#10;select * from page_cte__ "/>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>
                        <conditionStatement>
                          <condition>
                            <unaryOperatorExpression operator="Not">
                              <variableReferenceExpression name="countUsingHierarchy"/>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="AppendFormat">
                              <target>
                                <variableReferenceExpression name="sb"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="where row_number__ > {{0}}PageRangeFirstRowNumber and row_number__ &lt;= {{0}}PageRangeLastRowNumber order by row_number__"/>
                                <fieldReferenceExpression name="parameterMarker"/>
                              </parameters>
                            </methodInvokeExpression>
                            <variableDeclarationStatement type="DbParameter" name="p">
                              <init>
                                <methodInvokeExpression methodName="CreateParameter">
                                  <target>
                                    <argumentReferenceExpression name="command"/>
                                  </target>
                                </methodInvokeExpression>
                              </init>
                            </variableDeclarationStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="ParameterName">
                                <variableReferenceExpression name="p"/>
                              </propertyReferenceExpression>
                              <binaryOperatorExpression operator="Add">
                                <fieldReferenceExpression name="parameterMarker"/>
                                <primitiveExpression value="PageRangeFirstRowNumber"/>
                              </binaryOperatorExpression>
                            </assignStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="Value">
                                <variableReferenceExpression name="p"/>
                              </propertyReferenceExpression>
                              <binaryOperatorExpression operator="Add">
                                <binaryOperatorExpression operator="Multiply">
                                  <propertyReferenceExpression name="PageSize">
                                    <argumentReferenceExpression name="page"/>
                                  </propertyReferenceExpression>
                                  <propertyReferenceExpression name="PageIndex">
                                    <argumentReferenceExpression name="page"/>
                                  </propertyReferenceExpression>
                                </binaryOperatorExpression>
                                <propertyReferenceExpression name="PageOffset">
                                  <argumentReferenceExpression name="page"/>
                                </propertyReferenceExpression>
                              </binaryOperatorExpression>
                            </assignStatement>
                            <conditionStatement>
                              <condition>
                                <variableReferenceExpression name="preFetch"/>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <propertyReferenceExpression name="Value">
                                    <variableReferenceExpression name="p"/>
                                  </propertyReferenceExpression>
                                  <binaryOperatorExpression operator="Subtract">
                                    <castExpression targetType="System.Int32">
                                      <propertyReferenceExpression name="Value">
                                        <variableReferenceExpression name="p"/>
                                      </propertyReferenceExpression>
                                    </castExpression>
                                    <propertyReferenceExpression name="PageSize">
                                      <argumentReferenceExpression name="page"/>
                                    </propertyReferenceExpression>
                                  </binaryOperatorExpression>
                                </assignStatement>
                              </trueStatements>
                            </conditionStatement>
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <propertyReferenceExpression name="Parameters">
                                  <argumentReferenceExpression name="command"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="p"/>
                              </parameters>
                            </methodInvokeExpression>
                            <variableDeclarationStatement type="DbParameter" name="p2">
                              <init>
                                <methodInvokeExpression methodName="CreateParameter">
                                  <target>
                                    <argumentReferenceExpression name="command"/>
                                  </target>
                                </methodInvokeExpression>
                              </init>
                            </variableDeclarationStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="ParameterName">
                                <variableReferenceExpression name="p2"/>
                              </propertyReferenceExpression>
                              <binaryOperatorExpression operator="Add">
                                <fieldReferenceExpression name="parameterMarker"/>
                                <primitiveExpression value="PageRangeLastRowNumber"/>
                              </binaryOperatorExpression>
                            </assignStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="Value">
                                <variableReferenceExpression name="p2"/>
                              </propertyReferenceExpression>
                              <binaryOperatorExpression operator="Add">
                                <binaryOperatorExpression operator="Multiply">
                                  <propertyReferenceExpression name="PageSize">
                                    <argumentReferenceExpression name="page"/>
                                  </propertyReferenceExpression>
                                  <binaryOperatorExpression operator="Add">
                                    <propertyReferenceExpression name="PageIndex">
                                      <argumentReferenceExpression name="page"/>
                                    </propertyReferenceExpression>
                                    <primitiveExpression value="1"/>
                                  </binaryOperatorExpression>
                                </binaryOperatorExpression>
                                <propertyReferenceExpression name="PageOffset">
                                  <argumentReferenceExpression name="page"/>
                                </propertyReferenceExpression>
                              </binaryOperatorExpression>
                            </assignStatement>
                            <conditionStatement>
                              <condition>
                                <variableReferenceExpression name="preFetch"/>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <propertyReferenceExpression name="Value">
                                    <variableReferenceExpression name="p2"/>
                                  </propertyReferenceExpression>
                                  <binaryOperatorExpression operator="Add">
                                    <castExpression targetType="System.Int32">
                                      <propertyReferenceExpression name="Value">
                                        <variableReferenceExpression name="p2"/>
                                      </propertyReferenceExpression>
                                    </castExpression>
                                    <propertyReferenceExpression name="PageSize">
                                      <argumentReferenceExpression name="page"/>
                                    </propertyReferenceExpression>
                                  </binaryOperatorExpression>
                                </assignStatement>
                              </trueStatements>
                            </conditionStatement>
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <propertyReferenceExpression name="Parameters">
                                  <argumentReferenceExpression name="command"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="p2"/>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>
                      </trueStatements>
                      <falseStatements>
                        <methodInvokeExpression methodName="AppendOrderByExpression">
                          <parameters>
                            <variableReferenceExpression name="sb"/>
                            <argumentReferenceExpression name="page"/>
                            <argumentReferenceExpression name="expressions"/>
                            <argumentReferenceExpression name="orderByClause"/>
                          </parameters>
                        </methodInvokeExpression>
                        <conditionStatement>
                          <condition>
                            <variableReferenceExpression name="useLimit"/>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="AppendFormat">
                              <target>
                                <variableReferenceExpression name="sb"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="&#13;&#10;limit {{0}}Limit_PageOffset, {{0}}Limit_PageSize"/>
                                <fieldReferenceExpression name="parameterMarker"/>
                              </parameters>
                            </methodInvokeExpression>
                            <variableDeclarationStatement type="DbParameter" name="p">
                              <init>
                                <methodInvokeExpression methodName="CreateParameter">
                                  <target>
                                    <argumentReferenceExpression name="command"/>
                                  </target>
                                </methodInvokeExpression>
                              </init>
                            </variableDeclarationStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="ParameterName">
                                <variableReferenceExpression name="p"/>
                              </propertyReferenceExpression>
                              <binaryOperatorExpression operator="Add">
                                <fieldReferenceExpression name="parameterMarker"/>
                                <primitiveExpression value="Limit_PageOffset"/>
                              </binaryOperatorExpression>
                            </assignStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="Value">
                                <variableReferenceExpression name="p"/>
                              </propertyReferenceExpression>
                              <binaryOperatorExpression operator="Add">
                                <binaryOperatorExpression operator="Multiply">
                                  <propertyReferenceExpression name="PageSize">
                                    <argumentReferenceExpression name="page"/>
                                  </propertyReferenceExpression>
                                  <propertyReferenceExpression name="PageIndex">
                                    <argumentReferenceExpression name="page"/>
                                  </propertyReferenceExpression>
                                </binaryOperatorExpression>
                                <propertyReferenceExpression name="PageOffset">
                                  <argumentReferenceExpression name="page"/>
                                </propertyReferenceExpression>
                              </binaryOperatorExpression>
                            </assignStatement>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="BooleanAnd">
                                  <variableReferenceExpression name="preFetch"/>
                                  <binaryOperatorExpression operator="GreaterThan">
                                    <castExpression targetType="System.Int32">
                                      <propertyReferenceExpression name="Value">
                                        <variableReferenceExpression name="p"/>
                                      </propertyReferenceExpression>
                                    </castExpression>
                                    <propertyReferenceExpression name="PageSize">
                                      <argumentReferenceExpression name="page"/>
                                    </propertyReferenceExpression>
                                  </binaryOperatorExpression>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <propertyReferenceExpression name="Value">
                                    <variableReferenceExpression name="p"/>
                                  </propertyReferenceExpression>
                                  <binaryOperatorExpression operator="Subtract">
                                    <castExpression targetType="System.Int32">
                                      <propertyReferenceExpression name="Value">
                                        <variableReferenceExpression name="p"/>
                                      </propertyReferenceExpression>
                                    </castExpression>
                                    <propertyReferenceExpression name="PageSize">
                                      <argumentReferenceExpression name="page"/>
                                    </propertyReferenceExpression>
                                  </binaryOperatorExpression>
                                </assignStatement>
                              </trueStatements>
                            </conditionStatement>
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <propertyReferenceExpression name="Parameters">
                                  <argumentReferenceExpression name="command"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="p"/>
                              </parameters>
                            </methodInvokeExpression>
                            <variableDeclarationStatement type="DbParameter" name="p2">
                              <init>
                                <methodInvokeExpression methodName="CreateParameter">
                                  <target>
                                    <argumentReferenceExpression name="command"/>
                                  </target>
                                </methodInvokeExpression>
                              </init>
                            </variableDeclarationStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="ParameterName">
                                <variableReferenceExpression name="p2"/>
                              </propertyReferenceExpression>
                              <binaryOperatorExpression operator="Add">
                                <fieldReferenceExpression name="parameterMarker"/>
                                <primitiveExpression value="Limit_PageSize"/>
                              </binaryOperatorExpression>
                            </assignStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="Value">
                                <variableReferenceExpression name="p2"/>
                              </propertyReferenceExpression>
                              <propertyReferenceExpression name="PageSize">
                                <argumentReferenceExpression name="page"/>
                              </propertyReferenceExpression>
                            </assignStatement>
                            <conditionStatement>
                              <condition>
                                <variableReferenceExpression name="preFetch"/>
                              </condition>
                              <trueStatements>
                                <variableDeclarationStatement type="System.Int32" name="pagesToFetch">
                                  <init>
                                    <primitiveExpression value="2"/>
                                  </init>
                                </variableDeclarationStatement>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="GreaterThan">
                                      <castExpression targetType="System.Int32">
                                        <propertyReferenceExpression name="Value">
                                          <variableReferenceExpression name="p"/>
                                        </propertyReferenceExpression>
                                      </castExpression>
                                      <propertyReferenceExpression name="PageSize">
                                        <argumentReferenceExpression name="page"/>
                                      </propertyReferenceExpression>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <assignStatement>
                                      <variableReferenceExpression name="pagesToFetch"/>
                                      <primitiveExpression value="3"/>
                                    </assignStatement>
                                  </trueStatements>
                                </conditionStatement>
                                <assignStatement>
                                  <propertyReferenceExpression name="Value">
                                    <variableReferenceExpression name="p2"/>
                                  </propertyReferenceExpression>
                                  <binaryOperatorExpression operator="Multiply">
                                    <propertyReferenceExpression name="PageSize">
                                      <argumentReferenceExpression name="page"/>
                                    </propertyReferenceExpression>
                                    <variableReferenceExpression name="pagesToFetch"/>
                                  </binaryOperatorExpression>
                                </assignStatement>
                              </trueStatements>
                            </conditionStatement>
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <propertyReferenceExpression name="Parameters">
                                  <argumentReferenceExpression name="command"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="p2"/>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>
                      </falseStatements>
                    </conditionStatement>
                  </trueStatements>
                  <falseStatements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="ValueEquality">
                          <argumentReferenceExpression name="commandConfiguration"/>
                          <propertyReferenceExpression name="Sync">
                            <typeReferenceExpression type="CommandConfigurationType"/>
                          </propertyReferenceExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <conditionStatement>
                          <condition>
                            <variableReferenceExpression name="useServerPaging"/>
                          </condition>
                          <trueStatements>
                            <conditionStatement>
                              <condition>
                                <unaryOperatorExpression operator="Not">
                                  <methodInvokeExpression methodName="ConfigureCTE">
                                    <parameters>
                                      <variableReferenceExpression name="sb"/>
                                      <variableReferenceExpression name="page"/>
                                      <variableReferenceExpression name="command"/>
                                      <variableReferenceExpression name="expressions"/>
                                      <primitiveExpression value="false"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                </unaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <methodInvokeExpression methodName="Append">
                                  <target>
                                    <variableReferenceExpression name="sb"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value=")&#13;&#10;select * from page_cte__ "/>
                                  </parameters>
                                </methodInvokeExpression>
                              </trueStatements>
                            </conditionStatement>
                            <methodInvokeExpression methodName="Append">
                              <target>
                                <argumentReferenceExpression name="sb"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="where "/>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                          <falseStatements>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="BooleanOr">
                                  <variableReferenceExpression name="useLimit"/>
                                  <variableReferenceExpression name="useSkip"/>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <methodInvokeExpression methodName="AppendOrderByExpression">
                                  <parameters>
                                    <argumentReferenceExpression name="sb"/>
                                    <argumentReferenceExpression name="page"/>
                                    <argumentReferenceExpression name="expressions"/>
                                    <argumentReferenceExpression name="orderByClause"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </trueStatements>
                            </conditionStatement>
                            <!--<conditionStatement>
                              <condition>
                                <variableReferenceExpression name="useSkip"/>
                              </condition>
                              <trueStatements>
                                <methodInvokeExpression methodName="Append">
                                  <target>
                                    <variableReferenceExpression name="sb"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="where "/>
                                  </parameters>
                                </methodInvokeExpression>
                              </trueStatements>
                              <falseStatements>-->
                            <conditionStatement>
                              <condition>
                                <unaryOperatorExpression operator="Not">
                                  <variableReferenceExpression name="useSkip"/>
                                </unaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <methodInvokeExpression methodName="Append">
                                  <target>
                                    <variableReferenceExpression name="sb"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value=") cte__)cte2__ where "/>
                                  </parameters>
                                </methodInvokeExpression>
                              </trueStatements>
                            </conditionStatement>
                            <!--</falseStatements>
                            </conditionStatement>-->
                          </falseStatements>
                        </conditionStatement>
                        <variableDeclarationStatement type="System.Boolean" name="first">
                          <init>
                            <primitiveExpression value="true"/>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <unaryOperatorExpression operator="Not">
                              <variableReferenceExpression name="useSkip"/>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <foreachStatement>
                              <variable type="DataField" name="field"/>
                              <target>
                                <propertyReferenceExpression name="Fields">
                                  <argumentReferenceExpression name="page"/>
                                </propertyReferenceExpression>
                              </target>
                              <statements>
                                <conditionStatement>
                                  <condition>
                                    <propertyReferenceExpression name="IsPrimaryKey">
                                      <variableReferenceExpression name="field"/>
                                    </propertyReferenceExpression>
                                  </condition>
                                  <trueStatements>
                                    <conditionStatement>
                                      <condition>
                                        <variableReferenceExpression name="first"/>
                                      </condition>
                                      <trueStatements>
                                        <assignStatement>
                                          <variableReferenceExpression name="first"/>
                                          <primitiveExpression value="false"/>
                                        </assignStatement>
                                      </trueStatements>
                                      <falseStatements>
                                        <methodInvokeExpression methodName="AppendFormat">
                                          <target>
                                            <argumentReferenceExpression name="sb"/>
                                          </target>
                                          <parameters>
                                            <primitiveExpression value=" and "/>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </falseStatements>
                                    </conditionStatement>
                                    <!--<conditionStatement>
                                  <condition>
                                    <variableReferenceExpression name="useSkip"/>
                                  </condition>
                                  <trueStatements>
                                    <methodInvokeExpression methodName="AppendFormat">
                                      <target>
                                        <argumentReferenceExpression name="sb"/>
                                      </target>
                                      <parameters>
                                        <primitiveExpression value="{{0}}.{{2}}={{1}}PrimaryKey_{{2}}"/>
                                        <propertyReferenceExpression name="Controller">
                                          <argumentReferenceExpression name="page"/>
                                        </propertyReferenceExpression>
                                        <fieldReferenceExpression name="parameterMarker"/>
                                        <propertyReferenceExpression name="Name">
                                          <variableReferenceExpression name="field"/>
                                        </propertyReferenceExpression>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </trueStatements>
                                  <falseStatements>-->
                                    <methodInvokeExpression methodName="AppendFormat">
                                      <target>
                                        <argumentReferenceExpression name="sb"/>
                                      </target>
                                      <parameters>
                                        <primitiveExpression value="{{1}}={{0}}PrimaryKey_{{1}}"/>
                                        <fieldReferenceExpression name="parameterMarker"/>
                                        <propertyReferenceExpression name="Name">
                                          <variableReferenceExpression name="field"/>
                                        </propertyReferenceExpression>
                                      </parameters>
                                    </methodInvokeExpression>
                                    <!--</falseStatements>
                                </conditionStatement>-->
                                  </trueStatements>
                                </conditionStatement>
                              </statements>
                            </foreachStatement>
                          </trueStatements>
                        </conditionStatement>
                      </trueStatements>
                      <falseStatements>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="BooleanOr">
                              <binaryOperatorExpression operator="ValueEquality">
                                <argumentReferenceExpression name="commandConfiguration"/>
                                <propertyReferenceExpression name="SelectDistinct">
                                  <typeReferenceExpression type="CommandConfigurationType"/>
                                </propertyReferenceExpression>
                              </binaryOperatorExpression>
                              <binaryOperatorExpression operator="ValueEquality">
                                <argumentReferenceExpression name="commandConfiguration"/>
                                <propertyReferenceExpression name="SelectFirstLetters">
                                  <typeReferenceExpression type="CommandConfigurationType"/>
                                </propertyReferenceExpression>
                              </binaryOperatorExpression>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="Append">
                              <target>
                                <variableReferenceExpression name="sb"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="order by 1"/>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>
                      </falseStatements>
                    </conditionStatement>
                  </falseStatements>
                </conditionStatement>
                <assignStatement>
                  <propertyReferenceExpression name="CommandText">
                    <argumentReferenceExpression name="command"/>
                  </propertyReferenceExpression>
                  <methodInvokeExpression methodName="ToString">
                    <target>
                      <variableReferenceExpression name="sb"/>
                    </target>
                  </methodInvokeExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="viewFilter"/>
                  <primitiveExpression value="null"/>
                </assignStatement>
              </statements>
            </memberMethod>
            <!-- method ConfigureCTE(StringBuilder, ViewPage, DbCommand, SelectClauseDictionary, bool) -->
            <memberMethod returnType="System.Boolean" name="ConfigureCTE">
              <attributes family="true"/>
              <parameters>
                <parameter type="StringBuilder" name="sb"/>
                <parameter type="ViewPage" name="page"/>
                <parameter type="DbCommand" name="command"/>
                <parameter type="SelectClauseDictionary" name="expressions"/>
                <parameter type="System.Boolean" name="performCount"/>
              </parameters>
              <statements>
                <xsl:choose>
                  <xsl:when test="$IsPremium='true'">
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="Not">
                          <methodInvokeExpression methodName="RequiresHierarchy">
                            <parameters>
                              <argumentReferenceExpression name="page"/>
                            </parameters>
                          </methodInvokeExpression>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodReturnStatement>
                          <primitiveExpression value="false"/>
                        </methodReturnStatement>
                      </trueStatements>
                    </conditionStatement>
                    <comment>detect hierarchy</comment>
                    <variableDeclarationStatement type="DataField" name="primaryKeyField">
                      <init>
                        <primitiveExpression value="null"/>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="DataField" name="parentField">
                      <init>
                        <primitiveExpression value="null"/>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="DataField" name="sortField">
                      <init>
                        <primitiveExpression value="null"/>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="System.String" name="sortOrder">
                      <init>
                        <primitiveExpression value="asc"/>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="System.String" name="hierarchyOrganization">
                      <init>
                        <propertyReferenceExpression name="HierarchyOrganizationFieldName"/>
                      </init>
                    </variableDeclarationStatement>
                    <foreachStatement>
                      <variable type="DataField" name="field"/>
                      <target>
                        <propertyReferenceExpression name="Fields">
                          <argumentReferenceExpression name="page"/>
                        </propertyReferenceExpression>
                      </target>
                      <statements>
                        <conditionStatement>
                          <condition>
                            <propertyReferenceExpression name="IsPrimaryKey">
                              <variableReferenceExpression name="field"/>
                            </propertyReferenceExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="primaryKeyField"/>
                              <variableReferenceExpression name="field"/>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <conditionStatement>
                          <condition>
                            <methodInvokeExpression methodName="IsTagged">
                              <target>
                                <variableReferenceExpression name="field"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="hierarchy-parent"/>
                              </parameters>
                            </methodInvokeExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="parentField"/>
                              <variableReferenceExpression name="field"/>
                            </assignStatement>
                          </trueStatements>
                          <falseStatements>
                            <conditionStatement>
                              <condition>
                                <methodInvokeExpression methodName="IsTagged">
                                  <target>
                                    <variableReferenceExpression name="field"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="hierarchy-organization"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="hierarchyOrganization"/>
                                  <propertyReferenceExpression name="Name">
                                    <variableReferenceExpression name="field"/>
                                  </propertyReferenceExpression>
                                </assignStatement>
                              </trueStatements>
                            </conditionStatement>
                          </falseStatements>
                        </conditionStatement>
                      </statements>
                    </foreachStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityEquality">
                          <variableReferenceExpression name="parentField"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodReturnStatement>
                          <primitiveExpression value="false"/>
                        </methodReturnStatement>
                      </trueStatements>
                    </conditionStatement>
                    <comment>select a hierarchy sort field</comment>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityEquality">
                          <variableReferenceExpression name="sortField"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <conditionStatement>
                          <condition>
                            <unaryOperatorExpression operator="IsNotNullOrEmpty">
                              <propertyReferenceExpression name="SortExpression">
                                <argumentReferenceExpression name="page"/>
                              </propertyReferenceExpression>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <variableDeclarationStatement type="Match" name="sortExpression">
                              <init>
                                <methodInvokeExpression methodName="Match">
                                  <target>
                                    <typeReferenceExpression type="Regex"/>
                                  </target>
                                  <parameters>
                                    <propertyReferenceExpression name="SortExpression">
                                      <argumentReferenceExpression name="page"/>
                                    </propertyReferenceExpression>
                                    <primitiveExpression value="(?'FieldName'\w+)(\s+(?'SortOrder'asc|desc)?)"/>
                                    <propertyReferenceExpression name="IgnoreCase">
                                      <typeReferenceExpression type="RegexOptions"/>
                                    </propertyReferenceExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </init>
                            </variableDeclarationStatement>
                            <conditionStatement>
                              <condition>
                                <propertyReferenceExpression name="Success">
                                  <variableReferenceExpression name="sortExpression"/>
                                </propertyReferenceExpression>
                              </condition>
                              <trueStatements>
                                <foreachStatement>
                                  <variable type="DataField" name="field"/>
                                  <target>
                                    <propertyReferenceExpression name="Fields">
                                      <argumentReferenceExpression name="page"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <statements>
                                    <conditionStatement>
                                      <condition>
                                        <binaryOperatorExpression operator="ValueEquality">
                                          <propertyReferenceExpression name="Name">
                                            <variableReferenceExpression name="field"/>
                                          </propertyReferenceExpression>
                                          <propertyReferenceExpression name="Value">
                                            <arrayIndexerExpression>
                                              <target>
                                                <propertyReferenceExpression name="Groups">
                                                  <variableReferenceExpression name="sortExpression"/>
                                                </propertyReferenceExpression>
                                              </target>
                                              <indices>
                                                <primitiveExpression value="FieldName"/>
                                              </indices>
                                            </arrayIndexerExpression>
                                          </propertyReferenceExpression>
                                        </binaryOperatorExpression>
                                      </condition>
                                      <trueStatements>
                                        <assignStatement>
                                          <variableReferenceExpression name="sortField"/>
                                          <variableReferenceExpression name="field"/>
                                        </assignStatement>
                                        <assignStatement>
                                          <variableReferenceExpression name="sortOrder"/>
                                          <propertyReferenceExpression name="Value">
                                            <arrayIndexerExpression>
                                              <target>
                                                <propertyReferenceExpression name="Groups">
                                                  <variableReferenceExpression name="sortExpression"/>
                                                </propertyReferenceExpression>
                                              </target>
                                              <indices>
                                                <primitiveExpression value="SortOrder"/>
                                              </indices>
                                            </arrayIndexerExpression>
                                          </propertyReferenceExpression>
                                        </assignStatement>
                                        <breakStatement/>
                                      </trueStatements>
                                    </conditionStatement>
                                  </statements>
                                </foreachStatement>
                              </trueStatements>
                            </conditionStatement>
                          </trueStatements>
                        </conditionStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="IdentityEquality">
                              <variableReferenceExpression name="sortField"/>
                              <primitiveExpression value="null"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <foreachStatement>
                              <variable type="DataField" name="field"/>
                              <target>
                                <propertyReferenceExpression name="Fields">
                                  <argumentReferenceExpression name="page"/>
                                </propertyReferenceExpression>
                              </target>
                              <statements>
                                <conditionStatement>
                                  <condition>
                                    <unaryOperatorExpression operator="Not">
                                      <propertyReferenceExpression name="Hidden">
                                        <variableReferenceExpression name="field"/>
                                      </propertyReferenceExpression>
                                    </unaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <assignStatement>
                                      <variableReferenceExpression name="sortField"/>
                                      <variableReferenceExpression name="field"/>
                                    </assignStatement>
                                    <breakStatement/>
                                  </trueStatements>
                                </conditionStatement>
                              </statements>
                            </foreachStatement>
                          </trueStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityEquality">
                          <variableReferenceExpression name="sortField"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="sortField"/>
                          <arrayIndexerExpression>
                            <target>
                              <propertyReferenceExpression name="Fields">
                                <argumentReferenceExpression name="page"/>
                              </propertyReferenceExpression>
                            </target>
                            <indices>
                              <primitiveExpression value="0"/>
                            </indices>
                          </arrayIndexerExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                    <comment>append a hierarchical CTE</comment>
                    <variableDeclarationStatement type="System.Boolean" name="isOracle">
                      <init>
                        <methodInvokeExpression methodName="DatabaseEngineIs">
                          <parameters>
                            <argumentReferenceExpression name="command"/>
                            <primitiveExpression value="Oracle"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <methodInvokeExpression methodName="AppendLine">
                      <target>
                        <variableReferenceExpression name="sb"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="),"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="AppendLine">
                      <target>
                        <variableReferenceExpression name="sb"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="h__("/>
                      </parameters>
                    </methodInvokeExpression>
                    <variableDeclarationStatement type="System.Boolean" name="first">
                      <init>
                        <primitiveExpression value="true"/>
                      </init>
                    </variableDeclarationStatement>
                    <foreachStatement>
                      <variable type="DataField" name="field"/>
                      <target>
                        <propertyReferenceExpression name="Fields">
                          <argumentReferenceExpression name="page"/>
                        </propertyReferenceExpression>
                      </target>
                      <statements>
                        <conditionStatement>
                          <condition>
                            <variableReferenceExpression name="first"/>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="first"/>
                              <primitiveExpression value="false"/>
                            </assignStatement>
                          </trueStatements>
                          <falseStatements>
                            <methodInvokeExpression methodName="Append">
                              <target>
                                <variableReferenceExpression name="sb"/>
                              </target>
                              <parameters>
                                <primitiveExpression value=","/>
                              </parameters>
                            </methodInvokeExpression>
                          </falseStatements>
                        </conditionStatement>
                        <methodInvokeExpression methodName="AppendFormat">
                          <target>
                            <variableReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="{{0}}{{1}}{{2}}"/>
                            <fieldReferenceExpression name="leftQuote"/>
                            <propertyReferenceExpression name="Name">
                              <variableReferenceExpression name="field"/>
                            </propertyReferenceExpression>
                            <fieldReferenceExpression name="rightQuote"/>
                          </parameters>
                        </methodInvokeExpression>
                        <methodInvokeExpression methodName="AppendLine">
                          <target>
                            <variableReferenceExpression name="sb"/>
                          </target>
                        </methodInvokeExpression>
                      </statements>
                    </foreachStatement>
                    <methodInvokeExpression methodName="AppendFormat">
                      <target>
                        <variableReferenceExpression name="sb"/>
                      </target>
                      <parameters>
                        <primitiveExpression value=",{{0}}{{1}}{{2}}"/>
                        <fieldReferenceExpression name="leftQuote"/>
                        <propertyReferenceExpression name="hierarchyOrganization"/>
                        <fieldReferenceExpression name="rightQuote"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="AppendLine">
                      <target>
                        <variableReferenceExpression name="sb"/>
                      </target>
                      <parameters>
                        <primitiveExpression value=")as("/>
                      </parameters>
                    </methodInvokeExpression>
                    <comment>top-level of self-referring CTE</comment>
                    <methodInvokeExpression methodName="AppendLine">
                      <target>
                        <variableReferenceExpression name="sb"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="select"/>
                      </parameters>
                    </methodInvokeExpression>
                    <assignStatement>
                      <variableReferenceExpression name="first"/>
                      <primitiveExpression value="true"/>
                    </assignStatement>
                    <foreachStatement>
                      <variable type="DataField" name="field"/>
                      <target>
                        <propertyReferenceExpression name="Fields">
                          <argumentReferenceExpression name="page"/>
                        </propertyReferenceExpression>
                      </target>
                      <statements>
                        <conditionStatement>
                          <condition>
                            <variableReferenceExpression name="first"/>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="first"/>
                              <primitiveExpression value="false"/>
                            </assignStatement>
                          </trueStatements>
                          <falseStatements>
                            <methodInvokeExpression methodName="Append">
                              <target>
                                <variableReferenceExpression name="sb"/>
                              </target>
                              <parameters>
                                <primitiveExpression value=","/>
                              </parameters>
                            </methodInvokeExpression>
                          </falseStatements>
                        </conditionStatement>
                        <methodInvokeExpression methodName="AppendFormat">
                          <target>
                            <variableReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="h1__.{{0}}{{1}}{{2}}"/>
                            <fieldReferenceExpression name="leftQuote"/>
                            <propertyReferenceExpression name="Name">
                              <variableReferenceExpression name="field"/>
                            </propertyReferenceExpression>
                            <fieldReferenceExpression name="rightQuote"/>
                          </parameters>
                        </methodInvokeExpression>
                        <methodInvokeExpression methodName="AppendLine">
                          <target>
                            <variableReferenceExpression name="sb"/>
                          </target>
                        </methodInvokeExpression>
                      </statements>
                    </foreachStatement>
                    <comment>add top-level hierarchy organization field</comment>
                    <conditionStatement>
                      <condition>
                        <variableReferenceExpression name="isOracle"/>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="AppendFormat">
                          <target>
                            <variableReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <primitiveExpression>
                              <xsl:attribute name="value"><![CDATA[,lpad(cast(row_number() over (partition by h1__.{0}{1}{2} order by h1__.{0}{3}{2} {4}) as varchar(5)), 5, '0') as {0}{5}{2}]]></xsl:attribute>
                            </primitiveExpression>
                            <fieldReferenceExpression name="leftQuote"/>
                            <propertyReferenceExpression name="Name">
                              <variableReferenceExpression name="parentField"/>
                            </propertyReferenceExpression>
                            <fieldReferenceExpression name="rightQuote"/>
                            <propertyReferenceExpression name="Name">
                              <variableReferenceExpression name="sortField"/>
                            </propertyReferenceExpression>
                            <variableReferenceExpression name="sortOrder"/>
                            <variableReferenceExpression name="hierarchyOrganization"/>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                      <falseStatements>
                        <methodInvokeExpression methodName="AppendFormat">
                          <target>
                            <variableReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <primitiveExpression>
                              <xsl:attribute name="value"><![CDATA[,cast(right('0000' + cast(row_number() over (partition by h1__.{0}{1}{2} order by h1__.{0}{3}{2} {4}) as varchar), 4) as varchar) as {0}{5}{2}]]></xsl:attribute>
                            </primitiveExpression>
                            <fieldReferenceExpression name="leftQuote"/>
                            <propertyReferenceExpression name="Name">
                              <variableReferenceExpression name="parentField"/>
                            </propertyReferenceExpression>
                            <fieldReferenceExpression name="rightQuote"/>
                            <propertyReferenceExpression name="Name">
                              <variableReferenceExpression name="sortField"/>
                            </propertyReferenceExpression>
                            <variableReferenceExpression name="sortOrder"/>
                            <variableReferenceExpression name="hierarchyOrganization"/>
                          </parameters>
                        </methodInvokeExpression>
                      </falseStatements>
                    </conditionStatement>
                    <comment>add top-level "from" clause</comment>
                    <methodInvokeExpression methodName="AppendLine">
                      <target>
                        <variableReferenceExpression name="sb"/>
                      </target>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="AppendFormat">
                      <target>
                        <variableReferenceExpression name="sb"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="from page_cte__ h1__ where h1__.{{0}}{{1}}{{2}} is null "/>
                        <fieldReferenceExpression name="leftQuote"/>
                        <propertyReferenceExpression name="Name">
                          <variableReferenceExpression name="parentField"/>
                        </propertyReferenceExpression>
                        <fieldReferenceExpression name="rightQuote"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="AppendLine">
                      <target>
                        <variableReferenceExpression name="sb"/>
                      </target>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="AppendLine">
                      <target>
                        <variableReferenceExpression name="sb"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="union all"/>
                      </parameters>
                    </methodInvokeExpression>
                    <comment>sublevel of self-referring CTE</comment>
                    <methodInvokeExpression methodName="AppendLine">
                      <target>
                        <variableReferenceExpression name="sb"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="select"/>
                      </parameters>
                    </methodInvokeExpression>
                    <assignStatement>
                      <variableReferenceExpression name="first"/>
                      <primitiveExpression value="true"/>
                    </assignStatement>
                    <foreachStatement>
                      <variable type="DataField" name="field"/>
                      <target>
                        <propertyReferenceExpression name="Fields">
                          <argumentReferenceExpression name="page"/>
                        </propertyReferenceExpression>
                      </target>
                      <statements>
                        <conditionStatement>
                          <condition>
                            <variableReferenceExpression name="first"/>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="first"/>
                              <primitiveExpression value="false"/>
                            </assignStatement>
                          </trueStatements>
                          <falseStatements>
                            <methodInvokeExpression methodName="Append">
                              <target>
                                <variableReferenceExpression name="sb"/>
                              </target>
                              <parameters>
                                <primitiveExpression value=","/>
                              </parameters>
                            </methodInvokeExpression>
                          </falseStatements>
                        </conditionStatement>
                        <methodInvokeExpression methodName="AppendFormat">
                          <target>
                            <variableReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="h2__.{{0}}{{1}}{{2}}"/>
                            <fieldReferenceExpression name="leftQuote"/>
                            <propertyReferenceExpression name="Name">
                              <variableReferenceExpression name="field"/>
                            </propertyReferenceExpression>
                            <fieldReferenceExpression name="rightQuote"/>
                          </parameters>
                        </methodInvokeExpression>
                        <methodInvokeExpression methodName="AppendLine">
                          <target>
                            <variableReferenceExpression name="sb"/>
                          </target>
                        </methodInvokeExpression>
                      </statements>
                    </foreachStatement>
                    <comment>add sublevel hierarchy organization field</comment>
                    <conditionStatement>
                      <condition>
                        <variableReferenceExpression name="isOracle"/>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="AppendFormat">
                          <target>
                            <variableReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <primitiveExpression>
                              <xsl:attribute name="value"><![CDATA[,h__.{0}{5}{2} || '/' || lpad(cast(row_number() over (partition by h2__.{0}{1}{2} order by h2__.{0}{3}{2} {4}) as varchar(5)), 5, '0') as {0}{5}{2}]]></xsl:attribute>
                            </primitiveExpression>
                            <fieldReferenceExpression name="leftQuote"/>
                            <propertyReferenceExpression name="Name">
                              <variableReferenceExpression name="parentField"/>
                            </propertyReferenceExpression>
                            <fieldReferenceExpression name="rightQuote"/>
                            <propertyReferenceExpression name="Name">
                              <variableReferenceExpression name="sortField"/>
                            </propertyReferenceExpression>
                            <variableReferenceExpression name="sortOrder"/>
                            <variableReferenceExpression name="hierarchyOrganization"/>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                      <falseStatements>
                        <methodInvokeExpression methodName="AppendFormat">
                          <target>
                            <variableReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <primitiveExpression>
                              <xsl:attribute name="value"><![CDATA[,convert(varchar, h__.{0}{5}{2} + '/' + cast(right('0000' + cast(row_number() over (partition by h2__.{0}{1}{2} order by h2__.{0}{3}{2} {4}) as varchar), 4) as varchar)) as {0}{5}{2}]]></xsl:attribute>
                            </primitiveExpression>
                            <fieldReferenceExpression name="leftQuote"/>
                            <propertyReferenceExpression name="Name">
                              <variableReferenceExpression name="parentField"/>
                            </propertyReferenceExpression>
                            <fieldReferenceExpression name="rightQuote"/>
                            <propertyReferenceExpression name="Name">
                              <variableReferenceExpression name="sortField"/>
                            </propertyReferenceExpression>
                            <variableReferenceExpression name="sortOrder"/>
                            <variableReferenceExpression name="hierarchyOrganization"/>
                          </parameters>
                        </methodInvokeExpression>
                      </falseStatements>
                    </conditionStatement>
                    <methodInvokeExpression methodName="AppendLine">
                      <target>
                        <variableReferenceExpression name="sb"/>
                      </target>
                    </methodInvokeExpression>
                    <comment>add sublevel "from" clause</comment>
                    <methodInvokeExpression methodName="AppendFormat">
                      <target>
                        <variableReferenceExpression name="sb"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="from page_cte__ h2__ inner join h__ on h2__.{{0}}{{1}}{{2}} = h__.{{0}}{{3}}{{2}}"/>
                        <fieldReferenceExpression name="leftQuote"/>
                        <propertyReferenceExpression name="Name">
                          <variableReferenceExpression name="parentField"/>
                        </propertyReferenceExpression>
                        <fieldReferenceExpression name="rightQuote"/>
                        <propertyReferenceExpression name="Name">
                          <variableReferenceExpression name="primaryKeyField"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="AppendLine">
                      <target>
                        <variableReferenceExpression name="sb"/>
                      </target>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="AppendLine">
                      <target>
                        <variableReferenceExpression name="sb"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="),"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="AppendFormat">
                      <target>
                        <variableReferenceExpression name="sb"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="ho__ as (select row_number() over (order by ({{0}}{{1}}{{2}})) as row_number__, h__.* from h__)"/>
                        <fieldReferenceExpression name="leftQuote"/>
                        <variableReferenceExpression name="hierarchyOrganization"/>
                        <fieldReferenceExpression name="rightQuote"/>
                      </parameters>
                    </methodInvokeExpression>
                    <conditionStatement>
                      <condition>
                        <argumentReferenceExpression name="performCount"/>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="AppendLine">
                          <target>
                            <argumentReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="select count(*) from ho__"/>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                      <falseStatements>
                        <methodInvokeExpression methodName="AppendLine">
                          <target>
                            <argumentReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="select * from ho__"/>
                          </parameters>
                        </methodInvokeExpression>
                      </falseStatements>
                    </conditionStatement>
                    <methodInvokeExpression methodName="AppendLine">
                      <target>
                        <variableReferenceExpression name="sb"/>
                      </target>
                    </methodInvokeExpression>
                    <methodReturnStatement>
                      <primitiveExpression value="true"/>
                    </methodReturnStatement>
                  </xsl:when>
                  <xsl:otherwise>
                    <methodReturnStatement>
                      <primitiveExpression value="false"/>
                    </methodReturnStatement>
                  </xsl:otherwise>
                </xsl:choose>
              </statements>
            </memberMethod>
            <!-- method AppendFirstLetterExpressions(StringBuilder, ViewPage, SelectClauseDictionary, string) -->
            <memberMethod name="AppendFirstLetterExpressions">
              <attributes private="true"/>
              <parameters>
                <parameter type="StringBuilder" name="sb"/>
                <parameter type="ViewPage" name="page"/>
                <parameter type="SelectClauseDictionary" name="expressions"/>
                <parameter type="System.String" name="substringFunction"/>
              </parameters>
              <statements>
                <foreachStatement>
                  <variable type="DataField" name="field"/>
                  <target>
                    <propertyReferenceExpression name="Fields">
                      <variableReferenceExpression name="page"/>
                    </propertyReferenceExpression>
                  </target>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanAnd">
                          <binaryOperatorExpression operator="BooleanAnd">
                            <unaryOperatorExpression operator="Not">
                              <propertyReferenceExpression name="Hidden">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                            </unaryOperatorExpression>
                            <propertyReferenceExpression name="AllowQBE">
                              <variableReferenceExpression name="field"/>
                            </propertyReferenceExpression>
                          </binaryOperatorExpression>
                          <binaryOperatorExpression operator="ValueEquality">
                            <propertyReferenceExpression name="Type">
                              <variableReferenceExpression name="field"/>
                            </propertyReferenceExpression>
                            <primitiveExpression value="String"/>
                          </binaryOperatorExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="System.String" name="fieldName">
                          <init>
                            <propertyReferenceExpression name="AliasName">
                              <variableReferenceExpression name="field"/>
                            </propertyReferenceExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <unaryOperatorExpression operator="IsNullOrEmpty">
                              <variableReferenceExpression name="fieldName"/>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="fieldName"/>
                              <propertyReferenceExpression name="Name">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <methodInvokeExpression methodName="AppendFormat">
                          <target>
                            <argumentReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="distinct {{1}}({{0}},1,1) first_letter__&#13;&#10;"/>
                            <arrayIndexerExpression>
                              <target>
                                <argumentReferenceExpression name="expressions"/>
                              </target>
                              <indices>
                                <variableReferenceExpression name="fieldName"/>
                              </indices>
                            </arrayIndexerExpression>
                            <argumentReferenceExpression name="substringFunction"/>
                          </parameters>
                        </methodInvokeExpression>
                        <assignStatement>
                          <propertyReferenceExpression name="FirstLetters">
                            <argumentReferenceExpression name="page"/>
                          </propertyReferenceExpression>
                          <variableReferenceExpression name="fieldName"/>
                        </assignStatement>
                        <methodInvokeExpression methodName="RemoveFromFilter">
                          <target>
                            <argumentReferenceExpression name="page"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="fieldName"/>
                          </parameters>
                        </methodInvokeExpression>
                        <breakStatement/>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
              </statements>
            </memberMethod>
            <!-- method AssignParameterDbType(DbParameter, string) -->
            <memberMethod name="AssignParameterDbType">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="DbParameter" name="parameter"/>
                <parameter type="System.String" name="systemType"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <argumentReferenceExpression name="systemType"/>
                      <primitiveExpression value="SByte"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <propertyReferenceExpression name="DbType">
                        <argumentReferenceExpression name="parameter"/>
                      </propertyReferenceExpression>
                      <propertyReferenceExpression name="Int16">
                        <typeReferenceExpression type="DbType"/>
                      </propertyReferenceExpression>
                    </assignStatement>
                  </trueStatements>
                  <falseStatements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="ValueEquality">
                          <argumentReferenceExpression name="systemType"/>
                          <primitiveExpression value="TimeSpan"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <propertyReferenceExpression name="DbType">
                            <argumentReferenceExpression name="parameter"/>
                          </propertyReferenceExpression>
                          <propertyReferenceExpression name="String">
                            <typeReferenceExpression type="DbType"/>
                          </propertyReferenceExpression>
                        </assignStatement>
                      </trueStatements>
                      <falseStatements>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="BooleanAnd">
                              <binaryOperatorExpression operator="ValueEquality">
                                <argumentReferenceExpression name="systemType"/>
                                <primitiveExpression value="Guid"/>
                              </binaryOperatorExpression>
                              <methodInvokeExpression methodName="Contains">
                                <target>
                                  <propertyReferenceExpression name="Name">
                                    <methodInvokeExpression methodName="GetType">
                                      <target>
                                        <argumentReferenceExpression name="parameter"/>
                                      </target>
                                    </methodInvokeExpression>
                                  </propertyReferenceExpression>
                                </target>
                                <parameters>
                                  <primitiveExpression value="Oracle"/>
                                </parameters>
                              </methodInvokeExpression>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="DbType">
                                <argumentReferenceExpression name="parameter"/>
                              </propertyReferenceExpression>
                              <propertyReferenceExpression name="Binary">
                                <typeReferenceExpression type="DbType"/>
                              </propertyReferenceExpression>
                            </assignStatement>
                          </trueStatements>
                          <falseStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="DbType">
                                <argumentReferenceExpression name="parameter"/>
                              </propertyReferenceExpression>
                              <castExpression targetType="DbType">
                                <methodInvokeExpression methodName="ConvertFrom">
                                  <target>
                                    <methodInvokeExpression methodName="GetConverter">
                                      <target>
                                        <typeReferenceExpression type="TypeDescriptor"/>
                                      </target>
                                      <parameters>
                                        <typeofExpression type="DbType"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </target>
                                  <parameters>
                                    <argumentReferenceExpression name="systemType"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </castExpression>
                            </assignStatement>
                          </falseStatements>
                        </conditionStatement>
                      </falseStatements>
                    </conditionStatement>
                  </falseStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method AssignParameterValue(DbParameter, string, object) -->
            <memberMethod name="AssignParameterValue">
              <attributes public="true" final="true" static="true"/>
              <parameters>
                <parameter type="DbParameter" name="parameter"/>
                <parameter type="System.String" name="systemType"/>
                <parameter type="System.Object" name="v"/>
              </parameters>
              <statements>
                <methodInvokeExpression methodName="AssignParameterDbType">
                  <parameters>
                    <argumentReferenceExpression name="parameter"/>
                    <argumentReferenceExpression name="systemType"/>
                  </parameters>
                </methodInvokeExpression>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <argumentReferenceExpression name="v"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <propertyReferenceExpression name="Value">
                        <argumentReferenceExpression name="parameter"/>
                      </propertyReferenceExpression>
                      <propertyReferenceExpression name="Value">
                        <typeReferenceExpression type="DBNull"/>
                      </propertyReferenceExpression>
                    </assignStatement>
                  </trueStatements>
                  <falseStatements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="ValueEquality">
                          <propertyReferenceExpression name="DbType">
                            <argumentReferenceExpression name="parameter"/>
                          </propertyReferenceExpression>
                          <propertyReferenceExpression name="String">
                            <typeReferenceExpression type="DbType"/>
                          </propertyReferenceExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <propertyReferenceExpression name="Value">
                            <argumentReferenceExpression name="parameter"/>
                          </propertyReferenceExpression>
                          <methodInvokeExpression methodName="ToString">
                            <target>
                              <argumentReferenceExpression name="v"/>
                            </target>
                          </methodInvokeExpression>
                        </assignStatement>
                      </trueStatements>
                      <falseStatements>
                        <assignStatement>
                          <propertyReferenceExpression name="Value">
                            <argumentReferenceExpression name="parameter"/>
                          </propertyReferenceExpression>
                          <methodInvokeExpression methodName="ConvertToType">
                            <parameters>
                              <arrayIndexerExpression>
                                <target>
                                  <propertyReferenceExpression name="TypeMap">
                                    <typeReferenceExpression type="Controller"/>
                                  </propertyReferenceExpression>
                                </target>
                                <indices>
                                  <argumentReferenceExpression name="systemType"/>
                                </indices>
                              </arrayIndexerExpression>
                              <argumentReferenceExpression name="v"/>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                      </falseStatements>
                    </conditionStatement>
                    <!-- 
                if ((parameter.DbType == DbType.Binary) && (parameter.Value is Guid))
                    parameter.Value = ((Guid)(parameter.Value)).ToByteArray();                    -->
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanAnd">
                          <binaryOperatorExpression operator="ValueEquality">
                            <propertyReferenceExpression name="DbType">
                              <variableReferenceExpression name="parameter"/>
                            </propertyReferenceExpression>
                            <propertyReferenceExpression name="Binary">
                              <typeReferenceExpression type="DbType"/>
                            </propertyReferenceExpression>
                          </binaryOperatorExpression>
                          <binaryOperatorExpression operator="IsTypeOf">
                            <propertyReferenceExpression name="Value">
                              <variableReferenceExpression name="parameter"/>
                            </propertyReferenceExpression>
                            <typeReferenceExpression type="Guid"/>
                          </binaryOperatorExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <propertyReferenceExpression name="Value">
                            <variableReferenceExpression name="parameter"/>
                          </propertyReferenceExpression>
                          <methodInvokeExpression methodName="ToByteArray">
                            <target>
                              <castExpression targetType="Guid">
                                <propertyReferenceExpression name="Value">
                                  <variableReferenceExpression name="parameter"/>
                                </propertyReferenceExpression>
                              </castExpression>
                            </target>
                          </methodInvokeExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                  </falseStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method AppendSelectExpressions(StringBuilder, ViewPage, SelectClauseDictionary, bool) -->
            <memberMethod name="AppendSelectExpressions">
              <attributes private ="true"/>
              <parameters>
                <parameter type="StringBuilder" name="sb"/>
                <parameter type="ViewPage" name="page"/>
                <parameter type="SelectClauseDictionary" name="expressions"/>
                <parameter type="System.Boolean" name="firstField"/>
              </parameters>
              <statements>
                <foreachStatement>
                  <variable type="DataField" name="field"/>
                  <target>
                    <propertyReferenceExpression name="Fields">
                      <argumentReferenceExpression name="page"/>
                    </propertyReferenceExpression>
                  </target>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <argumentReferenceExpression name="firstField"/>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="firstField"/>
                          <primitiveExpression value="false"/>
                        </assignStatement>
                      </trueStatements>
                      <falseStatements>
                        <methodInvokeExpression methodName="Append">
                          <target>
                            <argumentReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <primitiveExpression value=","/>
                          </parameters>
                        </methodInvokeExpression>
                      </falseStatements>
                    </conditionStatement>
                    <tryStatement>
                      <statements>
                        <conditionStatement>
                          <condition>
                            <propertyReferenceExpression name="OnDemand">
                              <variableReferenceExpression name="field"/>
                            </propertyReferenceExpression>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="Append">
                              <target>
                                <variableReferenceExpression name="sb"/>
                              </target>
                              <parameters>
                                <stringFormatExpression format="case when {{0}} is not null then 1 else null end as ">
                                  <arrayIndexerExpression>
                                    <target>
                                      <argumentReferenceExpression name="expressions"/>
                                    </target>
                                    <indices>
                                      <methodInvokeExpression methodName="ExpressionName">
                                        <target>
                                          <variableReferenceExpression name="field"/>
                                        </target>
                                      </methodInvokeExpression>
                                    </indices>
                                  </arrayIndexerExpression>
                                </stringFormatExpression>
                                <!--<methodInvokeExpression methodName="Format">
                                  <target>
                                    <typeReferenceExpression type="String"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="case when {{0}} is not null then 1 else null end as "/>
                                    <arrayIndexerExpression>
                                      <target>
                                        <argumentReferenceExpression name="expressions"/>
                                      </target>
                                      <indices>
                                        <methodInvokeExpression methodName="ExpressionName">
                                          <target>
                                            <variableReferenceExpression name="field"/>
                                          </target>
                                        </methodInvokeExpression>
                                      </indices>
                                    </arrayIndexerExpression>
                                  </parameters>
                                </methodInvokeExpression>-->
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                          <falseStatements>
                            <methodInvokeExpression methodName="Append">
                              <target>
                                <argumentReferenceExpression name="sb"/>
                              </target>
                              <parameters>
                                <arrayIndexerExpression>
                                  <target>
                                    <argumentReferenceExpression name="expressions"/>
                                  </target>
                                  <indices>
                                    <methodInvokeExpression methodName="ExpressionName">
                                      <target>
                                        <variableReferenceExpression name="field"/>
                                      </target>
                                    </methodInvokeExpression>
                                  </indices>
                                </arrayIndexerExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </falseStatements>
                        </conditionStatement>
                      </statements>
                      <catch exceptionType="Exception">
                        <throwExceptionStatement>
                          <objectCreateExpression type="Exception">
                            <parameters>
                              <stringFormatExpression format="Unknown data field '{{0}}'.">
                                <propertyReferenceExpression name="Name">
                                  <variableReferenceExpression name="field"/>
                                </propertyReferenceExpression>
                              </stringFormatExpression>
                              <!--<methodInvokeExpression methodName="Format">
                                <target>
                                  <typeReferenceExpression type="String"/>
                                </target>
                                <parameters>
                                  <primitiveExpression value="Unknown data field '{{0}}'."/>
                                  <propertyReferenceExpression name="Name">
                                    <variableReferenceExpression name="field"/>
                                  </propertyReferenceExpression>
                                </parameters>
                              </methodInvokeExpression>-->
                            </parameters>
                          </objectCreateExpression>
                        </throwExceptionStatement>
                      </catch>
                    </tryStatement>
                    <methodInvokeExpression methodName="Append">
                      <target>
                        <argumentReferenceExpression name="sb"/>
                      </target>
                      <parameters>
                        <primitiveExpression value=" &quot;"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="Append">
                      <target>
                        <argumentReferenceExpression name="sb"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="Name">
                          <variableReferenceExpression name="field"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="AppendLine">
                      <target>
                        <argumentReferenceExpression name="sb"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="&quot;"/>
                      </parameters>
                    </methodInvokeExpression>
                  </statements>
                </foreachStatement>
              </statements>
            </memberMethod>
            <!-- method AppendAggregateExpressions -->
            <memberMethod name="AppendAggregateExpressions">
              <attributes final="true"/>
              <parameters>
                <parameter type="StringBuilder" name="sb"/>
                <parameter type="ViewPage" name="page"/>
                <parameter type="SelectClauseDictionary" name="expressions"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.Boolean" name="firstField">
                  <init>
                    <primitiveExpression value="true"/>
                  </init>
                </variableDeclarationStatement>
                <foreachStatement>
                  <variable type="DataField" name="field"/>
                  <target>
                    <propertyReferenceExpression name="Fields">
                      <argumentReferenceExpression name="page"/>
                    </propertyReferenceExpression>
                  </target>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <variableReferenceExpression name="firstField"/>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="firstField"/>
                          <primitiveExpression value="false"/>
                        </assignStatement>
                      </trueStatements>
                      <falseStatements>
                        <methodInvokeExpression methodName="Append">
                          <target>
                            <argumentReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <primitiveExpression value=","/>
                          </parameters>
                        </methodInvokeExpression>
                      </falseStatements>
                    </conditionStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="ValueEquality">
                          <propertyReferenceExpression name="Aggregate">
                            <variableReferenceExpression name="field"/>
                          </propertyReferenceExpression>
                          <propertyReferenceExpression name="None">
                            <typeReferenceExpression type="DataFieldAggregate"/>
                          </propertyReferenceExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="Append">
                          <target>
                            <argumentReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="null "/>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                      <falseStatements>
                        <variableDeclarationStatement type="System.String" name="functionName">
                          <init>
                            <methodInvokeExpression methodName="ToString">
                              <target>
                                <propertyReferenceExpression name="Aggregate">
                                  <variableReferenceExpression name="field"/>
                                </propertyReferenceExpression>
                              </target>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="ValueEquality">
                              <variableReferenceExpression name="functionName"/>
                              <primitiveExpression value="Average"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="functionName"/>
                              <primitiveExpression value="Avg"/>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <variableDeclarationStatement type="System.String" name="fmt">
                          <init>
                            <primitiveExpression value="{{0}}({{1}})"/>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="ValueEquality">
                              <variableReferenceExpression name="functionName"/>
                              <primitiveExpression value="Count"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="fmt"/>
                              <primitiveExpression value="{{0}}(distinct {{1}})"/>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <methodInvokeExpression methodName="AppendFormat">
                          <target>
                            <argumentReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="fmt"/>
                            <variableReferenceExpression name="functionName"/>
                            <arrayIndexerExpression>
                              <target>
                                <argumentReferenceExpression name="expressions"/>
                              </target>
                              <indices>
                                <methodInvokeExpression methodName="ExpressionName">
                                  <target>
                                    <variableReferenceExpression name="field"/>
                                  </target>
                                </methodInvokeExpression>
                              </indices>
                            </arrayIndexerExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </falseStatements>
                    </conditionStatement>
                    <methodInvokeExpression methodName="Append">
                      <target>
                        <argumentReferenceExpression name="sb"/>
                      </target>
                      <parameters>
                        <primitiveExpression value=" &quot;"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="Append">
                      <target>
                        <argumentReferenceExpression name="sb"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="Name">
                          <variableReferenceExpression name="field"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="AppendLine">
                      <target>
                        <argumentReferenceExpression name="sb"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="&quot;"/>
                      </parameters>
                    </methodInvokeExpression>
                  </statements>
                </foreachStatement>
              </statements>
            </memberMethod>
            <!-- method AppendRowNumberExpression(StringBuilder, ViewPage, SelectClauseDictionary, string) -->
            <memberMethod name="AppendRowNumberExpression">
              <attributes private ="true"/>
              <parameters>
                <parameter type="StringBuilder" name="sb"/>
                <parameter type="ViewPage" name="page"/>
                <parameter type="SelectClauseDictionary" name="expressions"/>
                <parameter type="System.String" name="orderByClause"/>
              </parameters>
              <statements>
                <methodInvokeExpression methodName="Append">
                  <target>
                    <argumentReferenceExpression name="sb"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="row_number() over ("/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="AppendOrderByExpression">
                  <parameters>
                    <argumentReferenceExpression name="sb"/>
                    <argumentReferenceExpression name="page"/>
                    <argumentReferenceExpression name="expressions"/>
                    <argumentReferenceExpression name="orderByClause"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="AppendLine">
                  <target>
                    <argumentReferenceExpression name="sb"/>
                  </target>
                  <parameters>
                    <primitiveExpression value=") as row_number__"/>
                  </parameters>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- method AppendOrderByExpression(StringBuilder, ViewPage, SelectClauseDictionary, string)-->
            <memberMethod name="AppendOrderByExpression">
              <attributes private ="true"/>
              <parameters>
                <parameter type="StringBuilder" name="sb"/>
                <parameter type="ViewPage" name="page"/>
                <parameter type="SelectClauseDictionary" name="expressions"/>
                <parameter type="System.String" name="orderByClause"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="IsNullOrEmpty">
                      <target>
                        <typeReferenceExpression type="String"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="SortExpression">
                          <argumentReferenceExpression name="page"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <propertyReferenceExpression name="SortExpression">
                        <argumentReferenceExpression name="page"/>
                      </propertyReferenceExpression>
                      <methodInvokeExpression methodName="GetAttribute">
                        <target>
                          <fieldReferenceExpression name="view"/>
                        </target>
                        <parameters>
                          <primitiveExpression value="sortExpression"/>
                          <propertyReferenceExpression name="Empty">
                            <typeReferenceExpression type="String"/>
                          </propertyReferenceExpression>
                        </parameters>
                      </methodInvokeExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="System.Boolean" name="hasOrderBy">
                  <init>
                    <primitiveExpression value="false"/>
                  </init>
                </variableDeclarationStatement>
                <methodInvokeExpression methodName="Append">
                  <target>
                    <argumentReferenceExpression name="sb"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="order by "/>
                  </parameters>
                </methodInvokeExpression>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="IsNullOrEmpty">
                      <target>
                        <typeReferenceExpression type="String"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="SortExpression">
                          <argumentReferenceExpression name="page"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="Not">
                          <methodInvokeExpression methodName="IsNullOrEmpty">
                            <target>
                              <typeReferenceExpression type="String"/>
                            </target>
                            <parameters>
                              <argumentReferenceExpression name="orderByClause"/>
                            </parameters>
                          </methodInvokeExpression>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="Append">
                          <target>
                            <argumentReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <argumentReferenceExpression name="orderByClause"/>
                          </parameters>
                        </methodInvokeExpression>
                        <assignStatement>
                          <variableReferenceExpression name="hasOrderBy"/>
                          <primitiveExpression value="true"/>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                  </trueStatements>
                  <falseStatements>
                    <variableDeclarationStatement type="System.Boolean" name="firstSortField">
                      <init>
                        <primitiveExpression value="true"/>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="Match" name="orderByMatch">
                      <init>
                        <methodInvokeExpression methodName="Match">
                          <target>
                            <typeReferenceExpression type="Regex"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="SortExpression">
                              <argumentReferenceExpression name="page"/>
                            </propertyReferenceExpression>
                            <primitiveExpression value="\s*(?'Alias'[\s\w]+?)\s*(?'Order'\s(ASC|DESC))?\s*(,|$)"/>
                            <propertyReferenceExpression name="IgnoreCase">
                              <typeReferenceExpression type="RegexOptions"/>
                            </propertyReferenceExpression>
                            <!--<binaryOperatorExpression operator="BitwiseOr">
                              <propertyReferenceExpression name="IgnoreCase">
                                <typeReferenceExpression type="RegexOptions"/>
                              </propertyReferenceExpression>
                              <propertyReferenceExpression name="Compiled">
                                <typeReferenceExpression type="RegexOptions"/>
                              </propertyReferenceExpression>
                            </binaryOperatorExpression>-->
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <whileStatement>
                      <test>
                        <propertyReferenceExpression name="Success">
                          <variableReferenceExpression name="orderByMatch"/>
                        </propertyReferenceExpression>
                      </test>
                      <statements>
                        <conditionStatement>
                          <condition>
                            <variableReferenceExpression name="firstSortField"/>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="firstSortField"/>
                              <primitiveExpression value="false"/>
                            </assignStatement>
                          </trueStatements>
                          <falseStatements>
                            <methodInvokeExpression methodName="Append">
                              <target>
                                <argumentReferenceExpression name="sb"/>
                              </target>
                              <parameters>
                                <primitiveExpression value=","/>
                              </parameters>
                            </methodInvokeExpression>
                          </falseStatements>
                        </conditionStatement>
                        <variableDeclarationStatement type="System.String" name="fieldName">
                          <init>
                            <propertyReferenceExpression name="Value">
                              <arrayIndexerExpression>
                                <target>
                                  <propertyReferenceExpression name="Groups">
                                    <variableReferenceExpression name="orderByMatch"/>
                                  </propertyReferenceExpression>
                                </target>
                                <indices>
                                  <primitiveExpression value="Alias"/>
                                </indices>
                              </arrayIndexerExpression>
                            </propertyReferenceExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <methodInvokeExpression methodName="EndsWith">
                              <target>
                                <variableReferenceExpression name="fieldName"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="_Mirror"/>
                              </parameters>
                            </methodInvokeExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="fieldName"/>
                              <methodInvokeExpression methodName="Substring">
                                <target>
                                  <variableReferenceExpression name="fieldName"/>
                                </target>
                                <parameters>
                                  <primitiveExpression value="0"/>
                                  <binaryOperatorExpression operator="Subtract">
                                    <propertyReferenceExpression name="Length">
                                      <variableReferenceExpression name="fieldName"/>
                                    </propertyReferenceExpression>
                                    <primitiveExpression value="7"/>
                                  </binaryOperatorExpression>
                                </parameters>
                              </methodInvokeExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <methodInvokeExpression methodName="Append">
                          <target>
                            <argumentReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <arrayIndexerExpression>
                              <target>
                                <argumentReferenceExpression name="expressions"/>
                              </target>
                              <indices>
                                <variableReferenceExpression name="fieldName"/>
                              </indices>
                            </arrayIndexerExpression>
                          </parameters>
                        </methodInvokeExpression>
                        <methodInvokeExpression methodName="Append">
                          <target>
                            <argumentReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <primitiveExpression value=" "/>
                          </parameters>
                        </methodInvokeExpression>
                        <methodInvokeExpression methodName="Append">
                          <target>
                            <argumentReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="Value">
                              <arrayIndexerExpression>
                                <target>
                                  <propertyReferenceExpression name="Groups">
                                    <variableReferenceExpression name="orderByMatch"/>
                                  </propertyReferenceExpression>
                                </target>
                                <indices>
                                  <primitiveExpression value="Order"/>
                                </indices>
                              </arrayIndexerExpression>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                        <assignStatement>
                          <variableReferenceExpression name="orderByMatch"/>
                          <methodInvokeExpression methodName="NextMatch">
                            <target>
                              <variableReferenceExpression name="orderByMatch"/>
                            </target>
                          </methodInvokeExpression>
                        </assignStatement>
                        <assignStatement>
                          <variableReferenceExpression name="hasOrderBy"/>
                          <primitiveExpression value="true"/>
                        </assignStatement>
                      </statements>
                    </whileStatement>
                  </falseStatements>
                </conditionStatement>
                <variableDeclarationStatement type="System.Boolean" name="firstKey">
                  <init>
                    <unaryOperatorExpression operator="Not">
                      <variableReferenceExpression name="hasOrderBy"/>
                    </unaryOperatorExpression>
                  </init>
                </variableDeclarationStatement>
                <foreachStatement>
                  <variable type="DataField" name="field"/>
                  <target>
                    <propertyReferenceExpression name="Fields">
                      <argumentReferenceExpression name="page"/>
                    </propertyReferenceExpression>
                  </target>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <propertyReferenceExpression name="IsPrimaryKey">
                          <variableReferenceExpression name="field"/>
                        </propertyReferenceExpression>
                      </condition>
                      <trueStatements>
                        <conditionStatement>
                          <condition>
                            <variableReferenceExpression name="firstKey"/>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="firstKey"/>
                              <primitiveExpression value="false"/>
                            </assignStatement>
                          </trueStatements>
                          <falseStatements>
                            <methodInvokeExpression methodName="Append">
                              <target>
                                <argumentReferenceExpression name="sb"/>
                              </target>
                              <parameters>
                                <primitiveExpression value=","/>
                              </parameters>
                            </methodInvokeExpression>
                          </falseStatements>
                        </conditionStatement>
                        <methodInvokeExpression methodName="Append">
                          <target>
                            <argumentReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <arrayIndexerExpression>
                              <target>
                                <argumentReferenceExpression name="expressions"/>
                              </target>
                              <indices>
                                <methodInvokeExpression methodName="ExpressionName">
                                  <target>
                                    <variableReferenceExpression name="field"/>
                                  </target>
                                </methodInvokeExpression>
                              </indices>
                            </arrayIndexerExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
                <conditionStatement>
                  <condition>
                    <variableReferenceExpression name="firstKey"/>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="Append">
                      <target>
                        <argumentReferenceExpression name="sb"/>
                      </target>
                      <parameters>
                        <arrayIndexerExpression>
                          <target>
                            <argumentReferenceExpression name="expressions"/>
                          </target>
                          <indices>
                            <methodInvokeExpression methodName="ExpressionName">
                              <target>
                                <arrayIndexerExpression>
                                  <target>
                                    <propertyReferenceExpression name="Fields">
                                      <argumentReferenceExpression name="page"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <indices>
                                    <primitiveExpression value="0"/>
                                  </indices>
                                </arrayIndexerExpression>
                              </target>
                            </methodInvokeExpression>
                          </indices>
                        </arrayIndexerExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method EnsurePageFields(ViewPage, SelectClauseDictionary) -->
            <memberMethod name="EnsurePageFields">
              <attributes private="true"/>
              <parameters>
                <parameter type="ViewPage" name="page"/>
                <parameter type="SelectClauseDictionary" name="expressions"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="XPathNavigator" name="statusBar">
                  <init>
                    <methodInvokeExpression methodName="SelectSingleNode">
                      <target>
                        <fieldReferenceExpression name="config"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="/c:dataController/c:statusBar"/>
                        <!--<propertyReferenceExpression name="Resolver"/>-->
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <variableReferenceExpression name="statusBar"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <propertyReferenceExpression name="StatusBar">
                        <argumentReferenceExpression name="page"/>
                      </propertyReferenceExpression>
                      <propertyReferenceExpression name="Value">
                        <variableReferenceExpression name="statusBar"/>
                      </propertyReferenceExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <propertyReferenceExpression name="Count">
                        <propertyReferenceExpression name="Fields">
                          <argumentReferenceExpression name="page"/>
                        </propertyReferenceExpression>
                      </propertyReferenceExpression>
                      <primitiveExpression value="0"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="XPathNodeIterator" name="fieldIterator">
                      <init>
                        <methodInvokeExpression methodName="Select">
                          <target>
                            <fieldReferenceExpression name="config"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="/c:dataController/c:fields/c:field"/>
                            <!--<propertyReferenceExpression name="Resolver"/>-->
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
                            <!--<castExpression targetType="System.String">
                              <methodInvokeExpression methodName="Evaluate">
                                <target>
                                  <propertyReferenceExpression name="Current">
                                    <variableReferenceExpression name="fieldIterator"/>
                                  </propertyReferenceExpression>
                                </target>
                                <parameters>
                                  <primitiveExpression value="string(name)"/>
                                </parameters>
                              </methodInvokeExpression>
                            </castExpression>-->
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <methodInvokeExpression methodName="ContainsKey">
                              <target>
                                <argumentReferenceExpression name="expressions"/>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="fieldName"/>
                              </parameters>
                            </methodInvokeExpression>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <propertyReferenceExpression name="Fields">
                                  <argumentReferenceExpression name="page"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <objectCreateExpression type="DataField">
                                  <parameters>
                                    <propertyReferenceExpression name="Current">
                                      <variableReferenceExpression name="fieldIterator"/>
                                    </propertyReferenceExpression>
                                    <propertyReferenceExpression name="Resolver"/>
                                  </parameters>
                                </objectCreateExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>
                      </statements>
                    </whileStatement>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="XPathNodeIterator" name="keyFieldIterator">
                  <init>
                    <methodInvokeExpression methodName="Select">
                      <target>
                        <fieldReferenceExpression name="config"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="/c:dataController/c:fields/c:field[@isPrimaryKey='true' or @hidden='true']"/>
                        <!--<propertyReferenceExpression name="Resolver"/>-->
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <whileStatement>
                  <test>
                    <methodInvokeExpression methodName="MoveNext">
                      <target>
                        <variableReferenceExpression name="keyFieldIterator"/>
                      </target>
                    </methodInvokeExpression>
                  </test>
                  <statements>
                    <variableDeclarationStatement type="System.String" name="fieldName">
                      <init>
                        <methodInvokeExpression methodName="GetAttribute">
                          <target>
                            <propertyReferenceExpression name="Current">
                              <variableReferenceExpression name="keyFieldIterator"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <primitiveExpression value="name"/>
                            <propertyReferenceExpression name="Empty">
                              <typeReferenceExpression type="String"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                        <!--<castExpression targetType="System.String">
                          <methodInvokeExpression methodName="Evaluate">
                            <target>
                              <propertyReferenceExpression name="Current">
                                <variableReferenceExpression name="keyFieldIterator"/>
                              </propertyReferenceExpression>
                            </target>
                            <parameters>
                              <primitiveExpression value="string(@name)"/>
                            </parameters>
                          </methodInvokeExpression>
                        </castExpression>-->
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="Not">
                          <methodInvokeExpression methodName="ContainsField">
                            <target>
                              <argumentReferenceExpression name="page"/>
                            </target>
                            <parameters>
                              <variableReferenceExpression name="fieldName"/>
                            </parameters>
                          </methodInvokeExpression>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <!--<variableDeclarationStatement type="DataField" name="keyField">
                          <init>
                            <objectCreateExpression type="DataField">
                              <parameters>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="keyFieldIterator"/>
                                </propertyReferenceExpression>
                                <propertyReferenceExpression name="Resolver"/>
                                <primitiveExpression value="true"/>
                              </parameters>
                            </objectCreateExpression>
                          </init>
                        </variableDeclarationStatement>-->
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <propertyReferenceExpression name="Fields">
                              <argumentReferenceExpression name="page"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <!--<variableReferenceExpression name="keyField"/>-->
                            <objectCreateExpression type="DataField">
                              <parameters>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="keyFieldIterator"/>
                                </propertyReferenceExpression>
                                <propertyReferenceExpression name="Resolver"/>
                                <primitiveExpression value="true"/>
                              </parameters>
                            </objectCreateExpression>
                          </parameters>
                        </methodInvokeExpression>
                        <!--<assignStatement>
                          <propertyReferenceExpression name="Hidden">
                            <variableReferenceExpression name="keyField"/>
                          </propertyReferenceExpression>
                          <primitiveExpression value="true"/>
                        </assignStatement>-->
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </whileStatement>
                <variableDeclarationStatement type="XPathNodeIterator" name="aliasIterator">
                  <init>
                    <methodInvokeExpression methodName="Select">
                      <target>
                        <fieldReferenceExpression name="view"/>
                      </target>
                      <parameters>
                        <primitiveExpression value=".//c:dataFields/c:dataField/@aliasFieldName"/>
                        <propertyReferenceExpression name="Resolver"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <whileStatement>
                  <test>
                    <methodInvokeExpression methodName="MoveNext">
                      <target>
                        <variableReferenceExpression name="aliasIterator"/>
                      </target>
                    </methodInvokeExpression>
                  </test>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="Not">
                          <methodInvokeExpression methodName="ContainsField">
                            <target>
                              <argumentReferenceExpression name="page"/>
                            </target>
                            <parameters>
                              <propertyReferenceExpression name="Value">
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="aliasIterator"/>
                                </propertyReferenceExpression>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </unaryOperatorExpression>
                        <!--<binaryOperatorExpression operator="IdentityEquality">
                          <methodInvokeExpression methodName="FindField">
                            <target>
                              <argumentReferenceExpression name="page"/>
                            </target>
                            <parameters>
                              <propertyReferenceExpression name="Value">
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="aliasIterator"/>
                                </propertyReferenceExpression>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>-->
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="XPathNodeIterator" name="fieldIterator">
                          <init>
                            <methodInvokeExpression methodName="Select">
                              <target>
                                <fieldReferenceExpression name="config"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="/c:dataController/c:fields/c:field[@name='{{0}}']"/>
                                <propertyReferenceExpression name="Value">
                                  <propertyReferenceExpression name="Current">
                                    <variableReferenceExpression name="aliasIterator"/>
                                  </propertyReferenceExpression>
                                </propertyReferenceExpression>
                                <!--<stringFormatExpression format="/c:dataController/c:fields/c:field[@name='{{0}}']">
                                  <propertyReferenceExpression name="Value">
                                    <propertyReferenceExpression name="Current">
                                      <variableReferenceExpression name="aliasIterator"/>
                                    </propertyReferenceExpression>
                                  </propertyReferenceExpression>
                                </stringFormatExpression>
                                <propertyReferenceExpression name="Resolver"/>-->
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <methodInvokeExpression methodName="MoveNext">
                              <target>
                                <variableReferenceExpression name="fieldIterator"/>
                              </target>
                            </methodInvokeExpression>
                          </condition>
                          <trueStatements>
                            <!--<variableDeclarationStatement type="DataField" name="aliasField">
                              <init>
                                <objectCreateExpression type="DataField">
                                  <parameters>
                                    <propertyReferenceExpression name="Current">
                                      <variableReferenceExpression name="fieldIterator"/>
                                    </propertyReferenceExpression>
                                    <propertyReferenceExpression name="Resolver"/>
                                  </parameters>
                                </objectCreateExpression>
                              </init>
                            </variableDeclarationStatement>-->
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <propertyReferenceExpression name="Fields">
                                  <argumentReferenceExpression name="page"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <!--<variableReferenceExpression name="aliasField"/>-->
                                <objectCreateExpression type="DataField">
                                  <parameters>
                                    <propertyReferenceExpression name="Current">
                                      <variableReferenceExpression name="fieldIterator"/>
                                    </propertyReferenceExpression>
                                    <propertyReferenceExpression name="Resolver"/>
                                    <primitiveExpression value="true"/>
                                  </parameters>
                                </objectCreateExpression>
                              </parameters>
                            </methodInvokeExpression>
                            <!--<assignStatement>
                              <propertyReferenceExpression name="Hidden">
                                <variableReferenceExpression name="aliasField"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="true"/>
                            </assignStatement>-->
                          </trueStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </whileStatement>
                <variableDeclarationStatement type="XPathNodeIterator" name="lookupFieldIterator">
                  <init>
                    <methodInvokeExpression methodName="Select">
                      <target>
                        <fieldReferenceExpression name="config"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="/c:dataController/c:fields/c:field[c:items/@dataController]"/>
                        <!--<propertyReferenceExpression name="Resolver"/>-->
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <whileStatement>
                  <test>
                    <methodInvokeExpression methodName="MoveNext">
                      <target>
                        <variableReferenceExpression name="lookupFieldIterator"/>
                      </target>
                    </methodInvokeExpression>
                  </test>
                  <statements>
                    <variableDeclarationStatement type="System.String" name="fieldName">
                      <init>
                        <methodInvokeExpression methodName="GetAttribute">
                          <target>
                            <propertyReferenceExpression name="Current">
                              <variableReferenceExpression name="lookupFieldIterator"/>
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
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="Not">
                          <methodInvokeExpression methodName="ContainsField">
                            <target>
                              <argumentReferenceExpression name="page"/>
                            </target>
                            <parameters>
                              <variableReferenceExpression name="fieldName"/>
                            </parameters>
                          </methodInvokeExpression>
                        </unaryOperatorExpression>
                        <!--<binaryOperatorExpression operator="IdentityEquality">
                          <methodInvokeExpression methodName="FindField">
                            <target>
                              <argumentReferenceExpression name="page"/>
                            </target>
                            <parameters>
                              <variableReferenceExpression name="fieldName"/>
                            </parameters>
                          </methodInvokeExpression>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>-->
                      </condition>
                      <trueStatements>
                        <!--<variableDeclarationStatement type="DataField" name="lookupField">
                          <init>
                            <objectCreateExpression type="DataField">
                              <parameters>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="lookupFieldIterator"/>
                                </propertyReferenceExpression>
                                <propertyReferenceExpression name="Resolver"/>
                              </parameters>
                            </objectCreateExpression>
                          </init>
                        </variableDeclarationStatement>-->
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <propertyReferenceExpression name="Fields">
                              <argumentReferenceExpression name="page"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <!--<variableReferenceExpression name="lookupField"/>-->
                            <objectCreateExpression type="DataField">
                              <parameters>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="lookupFieldIterator"/>
                                </propertyReferenceExpression>
                                <propertyReferenceExpression name="Resolver"/>
                                <primitiveExpression value="true"/>
                              </parameters>
                            </objectCreateExpression>
                          </parameters>
                        </methodInvokeExpression>
                        <!--<assignStatement>
                          <propertyReferenceExpression name="Hidden">
                            <variableReferenceExpression name="lookupField"/>
                          </propertyReferenceExpression>
                          <primitiveExpression value="true"/>
                        </assignStatement>-->
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </whileStatement>
                <variableDeclarationStatement type="System.Int32" name="i">
                  <init>
                    <primitiveExpression value="0"/>
                  </init>
                </variableDeclarationStatement>
                <whileStatement>
                  <test>
                    <binaryOperatorExpression operator="LessThan">
                      <variableReferenceExpression name="i"/>
                      <propertyReferenceExpression name="Count">
                        <propertyReferenceExpression name="Fields">
                          <argumentReferenceExpression name="page"/>
                        </propertyReferenceExpression>
                      </propertyReferenceExpression>
                    </binaryOperatorExpression>
                  </test>
                  <statements>
                    <variableDeclarationStatement type="DataField" name="field">
                      <init>
                        <arrayIndexerExpression>
                          <target>
                            <propertyReferenceExpression name="Fields">
                              <argumentReferenceExpression name="page"/>
                            </propertyReferenceExpression>
                          </target>
                          <indices>
                            <variableReferenceExpression name="i"/>
                          </indices>
                        </arrayIndexerExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanAnd">
                          <binaryOperatorExpression operator="BooleanAnd">
                            <unaryOperatorExpression operator="Not">
                              <propertyReferenceExpression name="FormatOnClient">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                            </unaryOperatorExpression>
                            <unaryOperatorExpression operator="Not">
                              <methodInvokeExpression methodName="IsNullOrEmpty">
                                <target>
                                  <typeReferenceExpression type="String"/>
                                </target>
                                <parameters>
                                  <propertyReferenceExpression name="DataFormatString">
                                    <variableReferenceExpression name="field"/>
                                  </propertyReferenceExpression>
                                </parameters>
                              </methodInvokeExpression>
                            </unaryOperatorExpression>
                          </binaryOperatorExpression>
                          <unaryOperatorExpression operator="Not">
                            <propertyReferenceExpression name="IsMirror">
                              <variableReferenceExpression name="field"/>
                            </propertyReferenceExpression>
                          </unaryOperatorExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="Insert">
                          <target>
                            <propertyReferenceExpression name="Fields">
                              <argumentReferenceExpression name="page"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <binaryOperatorExpression operator="Add">
                              <variableReferenceExpression name="i"/>
                              <primitiveExpression value="1"/>
                            </binaryOperatorExpression>
                            <objectCreateExpression type="DataField">
                              <parameters>
                                <variableReferenceExpression name="field"/>
                              </parameters>
                            </objectCreateExpression>
                          </parameters>
                        </methodInvokeExpression>
                        <assignStatement>
                          <variableReferenceExpression name="i"/>
                          <binaryOperatorExpression operator="Add">
                            <variableReferenceExpression name="i"/>
                            <primitiveExpression value="2"/>
                          </binaryOperatorExpression>
                        </assignStatement>
                      </trueStatements>
                      <falseStatements>
                        <assignStatement>
                          <variableReferenceExpression name="i"/>
                          <binaryOperatorExpression operator="Add">
                            <variableReferenceExpression name="i"/>
                            <primitiveExpression value="1"/>
                          </binaryOperatorExpression>
                        </assignStatement>
                      </falseStatements>
                    </conditionStatement>
                  </statements>
                </whileStatement>
                <variableDeclarationStatement type="XPathNodeIterator" name="dynamicConfigIterator">
                  <init>
                    <methodInvokeExpression methodName="Select">
                      <target>
                        <fieldReferenceExpression name="config"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="/c:dataController/c:fields/c:field[c:configuration!='']/c:configuration|/c:dataController/c:fields/c:field/c:items[@copy!='']/@copy"/>
                        <!--<propertyReferenceExpression name="Resolver"/>-->
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <whileStatement>
                  <test>
                    <methodInvokeExpression methodName="MoveNext">
                      <target>
                        <variableReferenceExpression name="dynamicConfigIterator"/>
                      </target>
                    </methodInvokeExpression>
                  </test>
                  <statements>
                    <variableDeclarationStatement type="Match" name="dynamicConfig">
                      <init>
                        <methodInvokeExpression methodName="Match">
                          <target>
                            <typeReferenceExpression type="Regex"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="Value">
                              <propertyReferenceExpression name="Current">
                                <variableReferenceExpression name="dynamicConfigIterator"/>
                              </propertyReferenceExpression>
                            </propertyReferenceExpression>
                            <primitiveExpression value="(\w+)=(\w+)"/>
                            <!--<propertyReferenceExpression name="Compiled">
                              <typeReferenceExpression type="RegexOptions"/>
                            </propertyReferenceExpression>-->
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <whileStatement>
                      <test>
                        <propertyReferenceExpression name="Success">
                          <variableReferenceExpression name="dynamicConfig"/>
                        </propertyReferenceExpression>
                      </test>
                      <statements>
                        <variableDeclarationStatement type="System.Int32" name="groupIndex">
                          <init>
                            <primitiveExpression value="2"/>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="ValueEquality">
                              <propertyReferenceExpression name="Name">
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="dynamicConfigIterator"/>
                                </propertyReferenceExpression>
                              </propertyReferenceExpression>
                              <primitiveExpression value="copy"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="groupIndex"/>
                              <primitiveExpression value="1"/>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <conditionStatement>
                          <condition>
                            <unaryOperatorExpression operator="Not">
                              <methodInvokeExpression methodName="ContainsField">
                                <target>
                                  <argumentReferenceExpression name="page"/>
                                </target>
                                <parameters>
                                  <propertyReferenceExpression name="Value">
                                    <arrayIndexerExpression>
                                      <target>
                                        <propertyReferenceExpression name="Groups">
                                          <variableReferenceExpression name="dynamicConfig"/>
                                        </propertyReferenceExpression>
                                      </target>
                                      <indices>
                                        <variableReferenceExpression name="groupIndex"/>
                                      </indices>
                                    </arrayIndexerExpression>
                                  </propertyReferenceExpression>
                                </parameters>
                              </methodInvokeExpression>
                            </unaryOperatorExpression>
                            <!--<binaryOperatorExpression operator="IdentityEquality">
                              <methodInvokeExpression methodName="FindField">
                                <target>
                                  <argumentReferenceExpression name="page"/>
                                </target>
                                <parameters>
                                  <propertyReferenceExpression name="Value">
                                    <arrayIndexerExpression>
                                      <target>
                                        <propertyReferenceExpression name="Groups">
                                          <variableReferenceExpression name="dynamicConfig"/>
                                        </propertyReferenceExpression>
                                      </target>
                                      <indices>
                                        <variableReferenceExpression name="groupIndex"/>
                                      </indices>
                                    </arrayIndexerExpression>
                                  </propertyReferenceExpression>
                                </parameters>
                              </methodInvokeExpression>
                              <primitiveExpression value="null"/>
                            </binaryOperatorExpression>-->
                          </condition>
                          <trueStatements>
                            <variableDeclarationStatement type="XPathNavigator" name="nav">
                              <init>
                                <methodInvokeExpression methodName="SelectSingleNode">
                                  <target>
                                    <fieldReferenceExpression name="config"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression>
                                      <xsl:attribute name="value"><![CDATA[/c:dataController/c:fields/c:field[@name='{0}']]]></xsl:attribute>
                                    </primitiveExpression>
                                    <propertyReferenceExpression name="Value">
                                      <arrayIndexerExpression>
                                        <target>
                                          <propertyReferenceExpression name="Groups">
                                            <variableReferenceExpression name="dynamicConfig"/>
                                          </propertyReferenceExpression>
                                        </target>
                                        <indices>
                                          <primitiveExpression value="1"/>
                                        </indices>
                                      </arrayIndexerExpression>
                                    </propertyReferenceExpression>
                                    <!--<stringFormatExpression>
                                      <xsl:attribute name="format"><![CDATA[/c:dataController/c:fields/c:field[@name='{0}']]]></xsl:attribute>
                                      <propertyReferenceExpression name="Value">
                                        <arrayIndexerExpression>
                                          <target>
                                            <propertyReferenceExpression name="Groups">
                                              <variableReferenceExpression name="dynamicConfig"/>
                                            </propertyReferenceExpression>
                                          </target>
                                          <indices>
                                            <primitiveExpression value="1"/>
                                          </indices>
                                        </arrayIndexerExpression>
                                      </propertyReferenceExpression>
                                    </stringFormatExpression>
                                     <propertyReferenceExpression name="Resolver"/>-->
                                  </parameters>
                                </methodInvokeExpression>
                              </init>
                            </variableDeclarationStatement>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="IdentityInequality">
                                  <variableReferenceExpression name="nav"/>
                                  <primitiveExpression value="null"/>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <!--<variableDeclarationStatement type="DataField" name="dynamicConfigField">
                                  <init>
                                    <objectCreateExpression type="DataField">
                                      <parameters>
                                        <variableReferenceExpression name="nav"/>
                                        <propertyReferenceExpression name="Resolver"/>
                                      </parameters>
                                    </objectCreateExpression>
                                  </init>
                                </variableDeclarationStatement>-->
                                <methodInvokeExpression methodName="Add">
                                  <target>
                                    <propertyReferenceExpression name="Fields">
                                      <argumentReferenceExpression name="page"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <parameters>
                                    <!--<variableReferenceExpression name="dynamicConfigField"/>-->
                                    <objectCreateExpression type="DataField">
                                      <parameters>
                                        <variableReferenceExpression name="nav"/>
                                        <propertyReferenceExpression name="Resolver"/>
                                        <primitiveExpression value="true"/>
                                      </parameters>
                                    </objectCreateExpression>
                                  </parameters>
                                </methodInvokeExpression>
                                <!--<assignStatement>
                                  <propertyReferenceExpression name="Hidden">
                                    <variableReferenceExpression name="dynamicConfigField"/>
                                  </propertyReferenceExpression>
                                  <primitiveExpression value="true"/>
                                </assignStatement>-->
                              </trueStatements>
                            </conditionStatement>
                          </trueStatements>
                        </conditionStatement>
                        <assignStatement>
                          <variableReferenceExpression name="dynamicConfig"/>
                          <methodInvokeExpression methodName="NextMatch">
                            <target>
                              <variableReferenceExpression name="dynamicConfig"/>
                            </target>
                          </methodInvokeExpression>
                        </assignStatement>
                      </statements>
                    </whileStatement>
                    <conditionStatement>
                      <condition>
                        <propertyReferenceExpression name="InTransaction">
                          <argumentReferenceExpression name="page"/>
                        </propertyReferenceExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="XPathNodeIterator" name="globalFieldIterator">
                          <init>
                            <methodInvokeExpression methodName="Select">
                              <target>
                                <fieldReferenceExpression name="config"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="/c:dataController/c:fields/c:field"/>
                                <!--<propertyReferenceExpression name="Resolver"/>-->
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <whileStatement>
                          <test>
                            <methodInvokeExpression methodName="MoveNext">
                              <target>
                                <variableReferenceExpression name="globalFieldIterator"/>
                              </target>
                            </methodInvokeExpression>
                          </test>
                          <statements>
                            <variableDeclarationStatement type="System.String" name="fieldName">
                              <init>
                                <methodInvokeExpression methodName="GetAttribute">
                                  <target>
                                    <propertyReferenceExpression name="Current">
                                      <variableReferenceExpression name="globalFieldIterator"/>
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
                            <conditionStatement>
                              <condition>
                                <unaryOperatorExpression operator="Not">
                                  <methodInvokeExpression methodName="ContainsField">
                                    <target>
                                      <argumentReferenceExpression name="page"/>
                                    </target>
                                    <parameters>
                                      <variableReferenceExpression name="fieldName"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                </unaryOperatorExpression>
                                <!--<binaryOperatorExpression operator="IdentityEquality">
                                  <methodInvokeExpression methodName="FindField">
                                    <target>
                                      <argumentReferenceExpression name="page"/>
                                    </target>
                                    <parameters>
                                      <variableReferenceExpression name="fieldName"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                  <primitiveExpression value="null"/>
                                </binaryOperatorExpression>-->
                              </condition>
                              <trueStatements>
                                <!--<variableDeclarationStatement type="DataField" name="field">
                                  <init>
                                    <objectCreateExpression type="DataField">
                                      <parameters>
                                        <propertyReferenceExpression name="Current">
                                          <variableReferenceExpression name="globalFieldIterator"/>
                                        </propertyReferenceExpression>
                                        <propertyReferenceExpression name="Resolver"/>
                                      </parameters>
                                    </objectCreateExpression>
                                  </init>
                                </variableDeclarationStatement>-->
                                <methodInvokeExpression methodName="Add">
                                  <target>
                                    <propertyReferenceExpression name="Fields">
                                      <variableReferenceExpression name="page"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <parameters>
                                    <!--<variableReferenceExpression name="field"/>-->
                                    <objectCreateExpression type="DataField">
                                      <parameters>
                                        <propertyReferenceExpression name="Current">
                                          <variableReferenceExpression name="globalFieldIterator"/>
                                        </propertyReferenceExpression>
                                        <propertyReferenceExpression name="Resolver"/>
                                        <primitiveExpression value="true"/>
                                      </parameters>
                                    </objectCreateExpression>
                                  </parameters>
                                </methodInvokeExpression>
                                <!--<assignStatement>
                                  <propertyReferenceExpression name="Hidden">
                                    <variableReferenceExpression name="field"/>
                                  </propertyReferenceExpression>
                                  <primitiveExpression value="true"/>
                                </assignStatement>-->
                              </trueStatements>
                            </conditionStatement>
                          </statements>
                        </whileStatement>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </whileStatement>

                <!--<conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="Not">
                      <propertyReferenceExpression name="ViewOverridingDisabled"/>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="XPathNodeIterator" name="pivotRowFields">
                      <init>
                        <methodInvokeExpression methodName="Select">
                          <target>
                            <fieldReferenceExpression name="view"/>
                          </target>
                          <parameters>
                            <primitiveExpression value=".//c:dataFields/c:dataField[@pivot='RowKey']"/>
                            <propertyReferenceExpression name="Resolver"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="System.Boolean" name="resetPrimaryKeys">
                      <init>
                        <primitiveExpression value="true"/>
                      </init>
                    </variableDeclarationStatement>
                    <whileStatement>
                      <test>
                        <methodInvokeExpression methodName="MoveNext">
                          <target>
                            <variableReferenceExpression name="pivotRowFields"/>
                          </target>
                        </methodInvokeExpression>
                      </test>
                      <statements>
                        <conditionStatement>
                          <condition>
                            <variableReferenceExpression name="resetPrimaryKeys"/>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="resetPrimaryKeys"/>
                              <primitiveExpression value="false"/>
                            </assignStatement>
                            <foreachStatement>
                              <variable type="DataField" name="field"/>
                              <target>
                                <propertyReferenceExpression name="Fields">
                                  <argumentReferenceExpression name="page"/>
                                </propertyReferenceExpression>
                              </target>
                              <statements>
                                <assignStatement>
                                  <propertyReferenceExpression name="IsPrimaryKey">
                                    <variableReferenceExpression name="field"/>
                                  </propertyReferenceExpression>
                                  <primitiveExpression value="false"/>
                                </assignStatement>
                              </statements>
                            </foreachStatement>
                          </trueStatements>
                        </conditionStatement>
                        <variableDeclarationStatement type="DataField" name="pivotRowField">
                          <init>
                            <methodInvokeExpression methodName="FindField">
                              <target>
                                <argumentReferenceExpression name="page"/>
                              </target>
                              <parameters>
                                <methodInvokeExpression methodName="GetAttribute">
                                  <target>
                                    <propertyReferenceExpression name="Current">
                                      <variableReferenceExpression name="pivotRowFields"/>
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
                          </init>
                        </variableDeclarationStatement>
                        <assignStatement>
                          <propertyReferenceExpression name="IsPrimaryKey">
                            <variableReferenceExpression name="pivotRowField"/>
                          </propertyReferenceExpression>
                          <primitiveExpression value="true"/>
                        </assignStatement>
                      </statements>
                    </whileStatement>
                  </trueStatements>
                </conditionStatement>-->
                <foreachStatement>
                  <variable type="DataField" name="field"/>
                  <target>
                    <propertyReferenceExpression name="Fields">
                      <argumentReferenceExpression name="page"/>
                    </propertyReferenceExpression>
                  </target>
                  <statements>
                    <methodInvokeExpression methodName="ConfigureDataField">
                      <parameters>
                        <argumentReferenceExpression name="page"/>
                        <variableReferenceExpression name="field"/>
                      </parameters>
                    </methodInvokeExpression>
                  </statements>
                </foreachStatement>
              </statements>
            </memberMethod>
            <!-- field SelectExpressionRegex -->
            <memberField type="Regex" name="SelectExpressionRegex">
              <attributes public="true" static="true"/>
              <init>
                <objectCreateExpression type="Regex">
                  <parameters>
                    <primitiveExpression>
                      <xsl:attribute name="value"><![CDATA[\s*(?'Expression'[\S\s]*?(\([\s\S]*?\)|(\.(("|'|\[|`)(?'FieldName'[\S\s]*?)("|'|\]|`))|("|'|\[|`|)(?'FieldName'[\w\s]*?)("|'|\]|)|)))((\s+as\s+|\s+)("|'|\[|`|)(?'Alias'[\S\s]*?)|)("|'|\]|`|)\s*(,|$)]]></xsl:attribute>
                    </primitiveExpression>
                    <propertyReferenceExpression name="IgnoreCase">
                      <typeReferenceExpression type="RegexOptions"/>
                    </propertyReferenceExpression>
                  </parameters>
                </objectCreateExpression>
              </init>
            </memberField>
            <!-- method ParseSelectExpressions(string) -->
            <memberMethod returnType="SelectClauseDictionary" name="ParseSelectExpressions">
              <attributes private="true"/>
              <parameters>
                <parameter type="System.String" name="selectClause"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="SelectClauseDictionary" name="expressions">
                  <init>
                    <objectCreateExpression type="SelectClauseDictionary"/>
                  </init>
                </variableDeclarationStatement>
                <!--<comment>select clause regular expression:</comment>
								<comment>\s*(?'Expression'[\S\s]*?(\([\s\S]*?\)|(\.""(?'FieldName'[\w\s]*?)""|(""|'|\[|)(?'FieldName'[\w\s]*?)(""|'|\]|)|)))((\s+as\s+|\s+)(""|'|\[|)(?'Alias'[\S\s]*?)|)(""|'|\]|)\s*(,|$)</comment>-->
                <variableDeclarationStatement type="Match" name="fieldMatch">
                  <init>
                    <methodInvokeExpression methodName="Match">
                      <target>
                        <propertyReferenceExpression name="SelectExpressionRegex"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="selectClause"/>
                        <!--<binaryOperatorExpression operator="BitwiseOr">
                          <propertyReferenceExpression name="IgnoreCase">
                            <typeReferenceExpression type="RegexOptions"/>
                          </propertyReferenceExpression>
                          <propertyReferenceExpression name="Compiled">
                            <typeReferenceExpression type="RegexOptions"/>
                          </propertyReferenceExpression>
                        </binaryOperatorExpression>-->
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <whileStatement>
                  <test>
                    <propertyReferenceExpression name="Success">
                      <variableReferenceExpression name="fieldMatch"/>
                    </propertyReferenceExpression>
                  </test>
                  <statements>
                    <variableDeclarationStatement type="System.String" name="expression">
                      <init>
                        <propertyReferenceExpression name="Value">
                          <arrayIndexerExpression>
                            <target>
                              <propertyReferenceExpression name="Groups">
                                <variableReferenceExpression name="fieldMatch"/>
                              </propertyReferenceExpression>
                            </target>
                            <indices>
                              <primitiveExpression value="Expression"/>
                            </indices>
                          </arrayIndexerExpression>
                        </propertyReferenceExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="System.String" name="fieldName">
                      <init>
                        <propertyReferenceExpression name="Value">
                          <arrayIndexerExpression>
                            <target>
                              <propertyReferenceExpression name="Groups">
                                <variableReferenceExpression name="fieldMatch"/>
                              </propertyReferenceExpression>
                            </target>
                            <indices>
                              <primitiveExpression value="FieldName"/>
                            </indices>
                          </arrayIndexerExpression>
                        </propertyReferenceExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="System.String" name="alias">
                      <init>
                        <propertyReferenceExpression name="Value">
                          <arrayIndexerExpression>
                            <target>
                              <propertyReferenceExpression name="Groups">
                                <variableReferenceExpression name="fieldMatch"/>
                              </propertyReferenceExpression>
                            </target>
                            <indices>
                              <primitiveExpression value="Alias"/>
                            </indices>
                          </arrayIndexerExpression>
                        </propertyReferenceExpression>
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
                              <variableReferenceExpression name="expression"/>
                            </parameters>
                          </methodInvokeExpression>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <conditionStatement>
                          <condition>
                            <methodInvokeExpression methodName="IsNullOrEmpty">
                              <target>
                                <typeReferenceExpression type="String"/>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="alias"/>
                              </parameters>
                            </methodInvokeExpression>
                          </condition>
                          <trueStatements>
                            <conditionStatement>
                              <condition>
                                <methodInvokeExpression methodName="IsNullOrEmpty">
                                  <target>
                                    <typeReferenceExpression type="String"/>
                                  </target>
                                  <parameters>
                                    <variableReferenceExpression name="fieldName"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="alias"/>
                                  <variableReferenceExpression name="expression"/>
                                </assignStatement>
                              </trueStatements>
                              <falseStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="alias"/>
                                  <variableReferenceExpression name="fieldName"/>
                                </assignStatement>
                              </falseStatements>
                            </conditionStatement>
                          </trueStatements>
                        </conditionStatement>
                        <conditionStatement>
                          <condition>
                            <unaryOperatorExpression operator="Not">
                              <methodInvokeExpression methodName="ContainsKey">
                                <target>
                                  <variableReferenceExpression name="expressions"/>
                                </target>
                                <parameters>
                                  <variableReferenceExpression name="alias"/>
                                </parameters>
                              </methodInvokeExpression>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <variableReferenceExpression name="expressions"/>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="alias"/>
                                <variableReferenceExpression name="expression"/>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
                    <assignStatement>
                      <variableReferenceExpression name="fieldMatch"/>
                      <methodInvokeExpression methodName="NextMatch">
                        <target>
                          <variableReferenceExpression name="fieldMatch"/>
                        </target>
                      </methodInvokeExpression>
                    </assignStatement>
                  </statements>
                </whileStatement>
                <methodReturnStatement>
                  <variableReferenceExpression name="expressions"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method PopulatePageFields(ViewPage) -->
            <memberMethod name="PopulatePageFields">
              <attributes family="true" final="true"/>
              <parameters>
                <parameter type="ViewPage" name="page"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="GreaterThan">
                      <propertyReferenceExpression name="Count">
                        <propertyReferenceExpression name="Fields">
                          <argumentReferenceExpression name="page"/>
                        </propertyReferenceExpression>
                      </propertyReferenceExpression>
                      <primitiveExpression value="0"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement/>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="XPathNodeIterator" name="dataFieldIterator">
                  <init>
                    <methodInvokeExpression methodName="Select">
                      <target>
                        <fieldReferenceExpression name="view"/>
                      </target>
                      <parameters>
                        <primitiveExpression value=".//c:dataFields/c:dataField"/>
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
                    <variableDeclarationStatement type="XPathNodeIterator" name="fieldIterator">
                      <init>
                        <methodInvokeExpression methodName="Select">
                          <target>
                            <fieldReferenceExpression name="config"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="/c:dataController/c:fields/c:field[@name='{{0}}']"/>
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
                            <!--<stringFormatExpression format="/c:dataController/c:fields/c:field[@name='{{0}}']">
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
                            </stringFormatExpression>
                            <propertyReferenceExpression name="Resolver"/>-->
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <methodInvokeExpression methodName="MoveNext">
                          <target>
                            <variableReferenceExpression name="fieldIterator"/>
                          </target>
                        </methodInvokeExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="DataField" name="field">
                          <init>
                            <objectCreateExpression type="DataField">
                              <parameters>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="fieldIterator"/>
                                </propertyReferenceExpression>
                                <propertyReferenceExpression name="Resolver"/>
                              </parameters>
                            </objectCreateExpression>
                          </init>
                        </variableDeclarationStatement>
                        <assignStatement>
                          <propertyReferenceExpression name="Hidden">
                            <variableReferenceExpression name="field"/>
                          </propertyReferenceExpression>
                          <binaryOperatorExpression operator="ValueEquality">
                            <methodInvokeExpression methodName="GetAttribute">
                              <target>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="dataFieldIterator"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="hidden"/>
                                <propertyReferenceExpression name="Empty">
                                  <typeReferenceExpression type="String"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                            <primitiveExpression value="true" convertTo="String"/>
                          </binaryOperatorExpression>
                          <!--<castExpression targetType="System.Boolean">
                            <methodInvokeExpression methodName="Evaluate">
                              <target>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="dataFieldIterator"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="@hidden='true'"/>
                              </parameters>
                            </methodInvokeExpression>
                          </castExpression>-->
                        </assignStatement>
                        <assignStatement>
                          <propertyReferenceExpression name="DataFormatString">
                            <variableReferenceExpression name="field"/>
                          </propertyReferenceExpression>
                          <methodInvokeExpression methodName="GetAttribute">
                            <target>
                              <propertyReferenceExpression name="Current">
                                <variableReferenceExpression name="fieldIterator"/>
                              </propertyReferenceExpression>
                            </target>
                            <parameters>
                              <primitiveExpression value="dataFormatString"/>
                              <propertyReferenceExpression name="Empty">
                                <typeReferenceExpression type="String"/>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                        <variableDeclarationStatement type="System.String" name="formatOnClient">
                          <init>
                            <methodInvokeExpression methodName="GetAttribute">
                              <target>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="dataFieldIterator"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="formatOnClient"/>
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
                              <methodInvokeExpression methodName="IsNullOrEmpty">
                                <target>
                                  <typeReferenceExpression type="String"/>
                                </target>
                                <parameters>
                                  <variableReferenceExpression name="formatOnClient"/>
                                </parameters>
                              </methodInvokeExpression>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="FormatOnClient">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                              <binaryOperatorExpression operator="ValueInequality">
                                <variableReferenceExpression name="formatOnClient"/>
                                <primitiveExpression value="false" convertTo="String"/>
                              </binaryOperatorExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <conditionStatement>
                          <condition>
                            <methodInvokeExpression methodName="IsNullOrEmpty">
                              <target>
                                <typeReferenceExpression type="String"/>
                              </target>
                              <parameters>
                                <propertyReferenceExpression name="DataFormatString">
                                  <variableReferenceExpression name="field"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="DataFormatString">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                              <methodInvokeExpression methodName="GetAttribute">
                                <target>
                                  <propertyReferenceExpression name="Current">
                                    <variableReferenceExpression name="dataFieldIterator"/>
                                  </propertyReferenceExpression>
                                </target>
                                <parameters>
                                  <primitiveExpression value="dataFormatString"/>
                                  <propertyReferenceExpression name="Empty">
                                    <typeReferenceExpression type="String"/>
                                  </propertyReferenceExpression>
                                </parameters>
                              </methodInvokeExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <assignStatement>
                          <propertyReferenceExpression name="HeaderText">
                            <variableReferenceExpression name="field"/>
                          </propertyReferenceExpression>
                          <castExpression targetType="System.String">
                            <methodInvokeExpression methodName="Evaluate">
                              <target>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="dataFieldIterator"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="string(c:headerText)"/>
                                <propertyReferenceExpression name="Resolver"/>
                              </parameters>
                            </methodInvokeExpression>
                          </castExpression>
                        </assignStatement>
                        <assignStatement>
                          <propertyReferenceExpression name="FooterText">
                            <variableReferenceExpression name="field"/>
                          </propertyReferenceExpression>
                          <castExpression targetType="System.String">
                            <methodInvokeExpression methodName="Evaluate">
                              <target>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="dataFieldIterator"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="string(c:footerText)"/>
                                <propertyReferenceExpression name="Resolver"/>
                              </parameters>
                            </methodInvokeExpression>
                          </castExpression>
                        </assignStatement>
                        <assignStatement>
                          <propertyReferenceExpression name="ToolTip">
                            <variableReferenceExpression name="field"/>
                          </propertyReferenceExpression>
                          <methodInvokeExpression methodName="GetAttribute">
                            <target>
                              <propertyReferenceExpression name="Current">
                                <variableReferenceExpression name="dataFieldIterator"/>
                              </propertyReferenceExpression>
                            </target>
                            <parameters>
                              <primitiveExpression value="toolTip"/>
                              <propertyReferenceExpression name="Empty">
                                <typeReferenceExpression type="String"/>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                        <assignStatement>
                          <propertyReferenceExpression name="Watermark">
                            <variableReferenceExpression name="field"/>
                          </propertyReferenceExpression>
                          <methodInvokeExpression methodName="GetAttribute">
                            <target>
                              <propertyReferenceExpression name="Current">
                                <variableReferenceExpression name="dataFieldIterator"/>
                              </propertyReferenceExpression>
                            </target>
                            <parameters>
                              <primitiveExpression value="watermark"/>
                              <propertyReferenceExpression name="Empty">
                                <typeReferenceExpression type="String"/>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                        <assignStatement>
                          <propertyReferenceExpression name="HyperlinkFormatString">
                            <variableReferenceExpression name="field"/>
                          </propertyReferenceExpression>
                          <methodInvokeExpression methodName="GetAttribute">
                            <target>
                              <propertyReferenceExpression name="Current">
                                <variableReferenceExpression name="dataFieldIterator"/>
                              </propertyReferenceExpression>
                            </target>
                            <parameters>
                              <primitiveExpression value="hyperlinkFormatString"/>
                              <propertyReferenceExpression name="Empty">
                                <typeReferenceExpression type="String"/>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                        <assignStatement>
                          <propertyReferenceExpression name="AliasName">
                            <variableReferenceExpression name="field"/>
                          </propertyReferenceExpression>
                          <methodInvokeExpression methodName="GetAttribute">
                            <target>
                              <propertyReferenceExpression name="Current">
                                <variableReferenceExpression name="dataFieldIterator"/>
                              </propertyReferenceExpression>
                            </target>
                            <parameters>
                              <primitiveExpression value="aliasFieldName"/>
                              <stringEmptyExpression/>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                        <assignStatement>
                          <propertyReferenceExpression name="Tag">
                            <variableReferenceExpression name="field"/>
                          </propertyReferenceExpression>
                          <methodInvokeExpression methodName="GetAttribute">
                            <target>
                              <propertyReferenceExpression name="Current">
                                <variableReferenceExpression name="dataFieldIterator"/>
                              </propertyReferenceExpression>
                            </target>
                            <parameters>
                              <primitiveExpression value="tag"/>
                              <stringEmptyExpression/>
                            </parameters>
                          </methodInvokeExpression>
                          <!--<castExpression targetType="System.String">
                            <methodInvokeExpression methodName="Evaluate">
                              <target>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="dataFieldIterator"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="string(@aliasFieldName)"/>
                              </parameters>
                            </methodInvokeExpression>
                          </castExpression>-->
                        </assignStatement>
                        <conditionStatement>
                          <condition>
                            <unaryOperatorExpression operator="Not">
                              <methodInvokeExpression methodName="IsNullOrEmpty">
                                <target>
                                  <typeReferenceExpression type="String"/>
                                </target>
                                <parameters>
                                  <methodInvokeExpression methodName="GetAttribute">
                                    <target>
                                      <propertyReferenceExpression name="Current">
                                        <variableReferenceExpression name="dataFieldIterator"/>
                                      </propertyReferenceExpression>
                                    </target>
                                    <parameters>
                                      <primitiveExpression value="allowQBE"/>
                                      <propertyReferenceExpression name="Empty">
                                        <typeReferenceExpression type="String"/>
                                      </propertyReferenceExpression>
                                    </parameters>
                                  </methodInvokeExpression>
                                </parameters>
                              </methodInvokeExpression>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="AllowQBE">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                              <binaryOperatorExpression operator="ValueEquality">
                                <methodInvokeExpression methodName="GetAttribute">
                                  <target>
                                    <propertyReferenceExpression name="Current">
                                      <variableReferenceExpression name="dataFieldIterator"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="allowQBE"/>
                                    <propertyReferenceExpression name="Empty">
                                      <typeReferenceExpression type="String"/>
                                    </propertyReferenceExpression>
                                  </parameters>
                                </methodInvokeExpression>
                                <primitiveExpression value="true" convertTo="String"/>
                              </binaryOperatorExpression>
                              <!--<castExpression targetType="System.Boolean">
                                <methodInvokeExpression methodName="Evaluate">
                                  <target>
                                    <propertyReferenceExpression name="Current">
                                      <variableReferenceExpression name="dataFieldIterator"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="@allowQBE='true'"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </castExpression>-->
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <conditionStatement>
                          <condition>
                            <unaryOperatorExpression operator="Not">
                              <methodInvokeExpression methodName="IsNullOrEmpty">
                                <target>
                                  <typeReferenceExpression type="String"/>
                                </target>
                                <parameters>
                                  <methodInvokeExpression methodName="GetAttribute">
                                    <target>
                                      <propertyReferenceExpression name="Current">
                                        <variableReferenceExpression name="dataFieldIterator"/>
                                      </propertyReferenceExpression>
                                    </target>
                                    <parameters>
                                      <primitiveExpression value="allowSorting"/>
                                      <propertyReferenceExpression name="Empty">
                                        <typeReferenceExpression type="String"/>
                                      </propertyReferenceExpression>
                                    </parameters>
                                  </methodInvokeExpression>
                                </parameters>
                              </methodInvokeExpression>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="AllowSorting">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                              <binaryOperatorExpression operator="ValueEquality">
                                <methodInvokeExpression methodName="GetAttribute">
                                  <target>
                                    <propertyReferenceExpression name="Current">
                                      <variableReferenceExpression name="dataFieldIterator"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="allowSorting"/>
                                    <propertyReferenceExpression name="Empty">
                                      <typeReferenceExpression type="String"/>
                                    </propertyReferenceExpression>
                                  </parameters>
                                </methodInvokeExpression>
                                <primitiveExpression value="true" convertTo="String"/>
                              </binaryOperatorExpression>
                              <!--<castExpression targetType="System.Boolean">
                                <methodInvokeExpression methodName="Evaluate">
                                  <target>
                                    <propertyReferenceExpression name="Current">
                                      <variableReferenceExpression name="dataFieldIterator"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="@allowSorting='true'"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </castExpression>-->
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <assignStatement>
                          <propertyReferenceExpression name="CategoryIndex">
                            <variableReferenceExpression name="field"/>
                          </propertyReferenceExpression>
                          <methodInvokeExpression methodName="ToInt32">
                            <target>
                              <typeReferenceExpression type="Convert"/>
                            </target>
                            <parameters>
                              <methodInvokeExpression methodName="Evaluate">
                                <target>
                                  <propertyReferenceExpression name="Current">
                                    <variableReferenceExpression name="dataFieldIterator"/>
                                  </propertyReferenceExpression>
                                </target>
                                <parameters>
                                  <primitiveExpression value="count(parent::c:dataFields/parent::c:category/preceding-sibling::c:category)"/>
                                  <propertyReferenceExpression name="Resolver"/>
                                </parameters>
                              </methodInvokeExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                        <variableDeclarationStatement type="System.String" name="columns">
                          <init>
                            <methodInvokeExpression methodName="GetAttribute">
                              <target>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="dataFieldIterator"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="columns"/>
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
                              <methodInvokeExpression methodName="IsNullOrEmpty">
                                <target>
                                  <typeReferenceExpression type="String"/>
                                </target>
                                <parameters>
                                  <variableReferenceExpression name="columns"/>
                                </parameters>
                              </methodInvokeExpression>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="Columns">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                              <methodInvokeExpression methodName="ToInt32">
                                <target>
                                  <typeReferenceExpression type="Convert"/>
                                </target>
                                <parameters>
                                  <variableReferenceExpression name="columns"/>
                                </parameters>
                              </methodInvokeExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <variableDeclarationStatement type="System.String" name="rows">
                          <init>
                            <methodInvokeExpression methodName="GetAttribute">
                              <target>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="dataFieldIterator"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="rows"/>
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
                              <methodInvokeExpression methodName="IsNullOrEmpty">
                                <target>
                                  <typeReferenceExpression type="String"/>
                                </target>
                                <parameters>
                                  <variableReferenceExpression name="rows"/>
                                </parameters>
                              </methodInvokeExpression>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="Rows">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                              <methodInvokeExpression methodName="ToInt32">
                                <target>
                                  <typeReferenceExpression type="Convert"/>
                                </target>
                                <parameters>
                                  <variableReferenceExpression name="rows"/>
                                </parameters>
                              </methodInvokeExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <variableDeclarationStatement type="System.String" name="textMode">
                          <init>
                            <methodInvokeExpression methodName="GetAttribute">
                              <target>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="dataFieldIterator"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="textMode"/>
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
                              <methodInvokeExpression methodName="IsNullOrEmpty">
                                <target>
                                  <typeReferenceExpression type="String"/>
                                </target>
                                <parameters>
                                  <variableReferenceExpression name="textMode"/>
                                </parameters>
                              </methodInvokeExpression>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="TextMode">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                              <castExpression targetType="TextInputMode">
                                <methodInvokeExpression methodName="ConvertFromString">
                                  <target>
                                    <methodInvokeExpression methodName="GetConverter">
                                      <target>
                                        <typeReferenceExpression type="TypeDescriptor"/>
                                      </target>
                                      <parameters>
                                        <typeofExpression type="TextInputMode"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </target>
                                  <parameters>
                                    <variableReferenceExpression name="textMode"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </castExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <!-- 
                    string maskType = fieldIterator.Current.GetAttribute("maskType", String.Empty);
                    if (!String.IsNullOrEmpty(maskType))
                        field.MaskType = (DataFieldMaskType)TypeDescriptor.GetConverter(typeof(DataFieldMaskType)).ConvertFromString(maskType);
                    field.Mask = fieldIterator.Current.GetAttribute("mask", String.Empty);
												-->
                        <variableDeclarationStatement type="System.String" name="maskType">
                          <init>
                            <methodInvokeExpression  methodName="GetAttribute">
                              <target>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="fieldIterator"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="maskType"/>
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
                              <methodInvokeExpression methodName="IsNullOrEmpty">
                                <target>
                                  <typeReferenceExpression type="String"/>
                                </target>
                                <parameters>
                                  <variableReferenceExpression name="maskType"/>
                                </parameters>
                              </methodInvokeExpression>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="MaskType">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                              <castExpression targetType="DataFieldMaskType">
                                <methodInvokeExpression methodName="ConvertFromString">
                                  <target>
                                    <methodInvokeExpression methodName="GetConverter">
                                      <target>
                                        <typeReferenceExpression type="TypeDescriptor"/>
                                      </target>
                                      <parameters>
                                        <typeofExpression type="DataFieldMaskType"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </target>
                                  <parameters>
                                    <variableReferenceExpression name="maskType"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </castExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <assignStatement>
                          <propertyReferenceExpression name="Mask">
                            <variableReferenceExpression name="field"/>
                          </propertyReferenceExpression>
                          <methodInvokeExpression methodName="GetAttribute">
                            <target>
                              <propertyReferenceExpression name="Current">
                                <variableReferenceExpression name="fieldIterator"/>
                              </propertyReferenceExpression>
                            </target>
                            <parameters>
                              <primitiveExpression value="mask"/>
                              <propertyReferenceExpression name="Empty">
                                <typeReferenceExpression type="String"/>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                        <variableDeclarationStatement type="System.String" name="readOnly">
                          <init>
                            <methodInvokeExpression methodName="GetAttribute">
                              <target>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="dataFieldIterator"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="readOnly"/>
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
                              <methodInvokeExpression methodName="IsNullOrEmpty">
                                <target>
                                  <typeReferenceExpression type="String"/>
                                </target>
                                <parameters>
                                  <variableReferenceExpression name="readOnly"/>
                                </parameters>
                              </methodInvokeExpression>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="ReadOnly">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                              <binaryOperatorExpression operator="ValueEquality">
                                <variableReferenceExpression name="readOnly"/>
                                <primitiveExpression value="true" convertTo="String"/>
                              </binaryOperatorExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <variableDeclarationStatement type="System.String" name="aggregate">
                          <init>
                            <methodInvokeExpression methodName="GetAttribute">
                              <target>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="dataFieldIterator"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="aggregate"/>
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
                              <methodInvokeExpression methodName="IsNullOrEmpty">
                                <target>
                                  <typeReferenceExpression type="String"/>
                                </target>
                                <parameters>
                                  <variableReferenceExpression name="aggregate"/>
                                </parameters>
                              </methodInvokeExpression>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="Aggregate">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                              <castExpression targetType="DataFieldAggregate">
                                <methodInvokeExpression methodName="ConvertFromString">
                                  <target>
                                    <methodInvokeExpression methodName="GetConverter">
                                      <target>
                                        <typeReferenceExpression type="TypeDescriptor"/>
                                      </target>
                                      <parameters>
                                        <typeofExpression type="DataFieldAggregate"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </target>
                                  <parameters>
                                    <variableReferenceExpression name="aggregate"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </castExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <variableDeclarationStatement type="System.String" name="search">
                          <init>
                            <methodInvokeExpression methodName="GetAttribute">
                              <target>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="dataFieldIterator"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="search"/>
                                <propertyReferenceExpression name="Empty">
                                  <typeReferenceExpression type="String"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <unaryOperatorExpression operator="IsNotNullOrEmpty">
                              <variableReferenceExpression name="search"/>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="Search">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                              <castExpression targetType="FieldSearchMode">
                                <methodInvokeExpression methodName="ConvertFromString">
                                  <target>
                                    <methodInvokeExpression methodName="GetConverter">
                                      <target>
                                        <typeReferenceExpression type="TypeDescriptor"/>
                                      </target>
                                      <parameters>
                                        <typeofExpression type="FieldSearchMode"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </target>
                                  <parameters>
                                    <variableReferenceExpression name="search"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </castExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <assignStatement>
                          <propertyReferenceExpression name="SearchOptions">
                            <variableReferenceExpression name="field"/>
                          </propertyReferenceExpression>
                          <methodInvokeExpression methodName="GetAttribute">
                            <target>
                              <propertyReferenceExpression name="Current">
                                <variableReferenceExpression name="dataFieldIterator"/>
                              </propertyReferenceExpression>
                            </target>
                            <parameters>
                              <primitiveExpression value="searchOptions"/>
                              <propertyReferenceExpression name="Empty">
                                <typeReferenceExpression type="String"/>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                        <!--<assignStatement>
                          <propertyReferenceExpression name="Pivot">
                            <variableReferenceExpression name="field"/>
                          </propertyReferenceExpression>
                          <methodInvokeExpression methodName="GetAttribute">
                            <target>
                              <propertyReferenceExpression name="Current">
                                <variableReferenceExpression name="dataFieldIterator"/>
                              </propertyReferenceExpression>
                            </target>
                            <parameters>
                              <primitiveExpression value="pivot"/>
                              <propertyReferenceExpression name="Empty">
                                <typeReferenceExpression type="String"/>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>-->
                        <variableDeclarationStatement type="System.String" name="prefixLength">
                          <init>
                            <methodInvokeExpression methodName="GetAttribute">
                              <target>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="dataFieldIterator"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="autoCompletePrefixLength"/>
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
                              <methodInvokeExpression methodName="IsNullOrEmpty">
                                <target>
                                  <typeReferenceExpression type="String"/>
                                </target>
                                <parameters>
                                  <variableReferenceExpression name="prefixLength"/>
                                </parameters>
                              </methodInvokeExpression>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="AutoCompletePrefixLength">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                              <methodInvokeExpression methodName="ToInt32">
                                <target>
                                  <typeReferenceExpression type="Convert"/>
                                </target>
                                <parameters>
                                  <variableReferenceExpression name="prefixLength"/>
                                </parameters>
                              </methodInvokeExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <variableDeclarationStatement type="XPathNodeIterator" name="itemsIterator">
                          <init>
                            <methodInvokeExpression methodName="Select">
                              <target>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="dataFieldIterator"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="c:items[c:item]"/>
                                <propertyReferenceExpression name="Resolver"/>
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <unaryOperatorExpression operator="Not">
                              <methodInvokeExpression methodName="MoveNext">
                                <target>
                                  <variableReferenceExpression name="itemsIterator"/>
                                </target>
                              </methodInvokeExpression>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="itemsIterator"/>
                              <methodInvokeExpression methodName="Select">
                                <target>
                                  <propertyReferenceExpression name="Current">
                                    <variableReferenceExpression name="fieldIterator"/>
                                  </propertyReferenceExpression>
                                </target>
                                <parameters>
                                  <primitiveExpression value="c:items"/>
                                  <propertyReferenceExpression name="Resolver"/>
                                </parameters>
                              </methodInvokeExpression>
                            </assignStatement>
                            <conditionStatement>
                              <condition>
                                <unaryOperatorExpression operator="Not">
                                  <methodInvokeExpression methodName="MoveNext">
                                    <target>
                                      <variableReferenceExpression name="itemsIterator"/>
                                    </target>
                                  </methodInvokeExpression>
                                </unaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="itemsIterator"/>
                                  <primitiveExpression value="null"/>
                                </assignStatement>
                              </trueStatements>
                            </conditionStatement>
                          </trueStatements>
                        </conditionStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="IdentityInequality">
                              <variableReferenceExpression name="itemsIterator"/>
                              <primitiveExpression value="null"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="ItemsDataController">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                              <methodInvokeExpression methodName="GetAttribute">
                                <target>
                                  <propertyReferenceExpression name="Current">
                                    <variableReferenceExpression name="itemsIterator"/>
                                  </propertyReferenceExpression>
                                </target>
                                <parameters>
                                  <primitiveExpression value="dataController"/>
                                  <propertyReferenceExpression name="Empty">
                                    <typeReferenceExpression type="String"/>
                                  </propertyReferenceExpression>
                                </parameters>
                              </methodInvokeExpression>
                            </assignStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="ItemsDataView">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                              <methodInvokeExpression methodName="GetAttribute">
                                <target>
                                  <propertyReferenceExpression name="Current">
                                    <variableReferenceExpression name="itemsIterator"/>
                                  </propertyReferenceExpression>
                                </target>
                                <parameters>
                                  <primitiveExpression value="dataView"/>
                                  <propertyReferenceExpression name="Empty">
                                    <typeReferenceExpression type="String"/>
                                  </propertyReferenceExpression>
                                </parameters>
                              </methodInvokeExpression>
                            </assignStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="ItemsDataValueField">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                              <methodInvokeExpression methodName="GetAttribute">
                                <target>
                                  <propertyReferenceExpression name="Current">
                                    <variableReferenceExpression name="itemsIterator"/>
                                  </propertyReferenceExpression>
                                </target>
                                <parameters>
                                  <primitiveExpression value="dataValueField"/>
                                  <propertyReferenceExpression name="Empty">
                                    <typeReferenceExpression type="String"/>
                                  </propertyReferenceExpression>
                                </parameters>
                              </methodInvokeExpression>
                            </assignStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="ItemsDataTextField">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                              <methodInvokeExpression methodName="GetAttribute">
                                <target>
                                  <propertyReferenceExpression name="Current">
                                    <variableReferenceExpression name="itemsIterator"/>
                                  </propertyReferenceExpression>
                                </target>
                                <parameters>
                                  <primitiveExpression value="dataTextField"/>
                                  <propertyReferenceExpression name="Empty">
                                    <typeReferenceExpression type="String"/>
                                  </propertyReferenceExpression>
                                </parameters>
                              </methodInvokeExpression>
                            </assignStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="ItemsStyle">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                              <methodInvokeExpression methodName="GetAttribute">
                                <target>
                                  <propertyReferenceExpression name="Current">
                                    <variableReferenceExpression name="itemsIterator"/>
                                  </propertyReferenceExpression>
                                </target>
                                <parameters>
                                  <primitiveExpression value="style"/>
                                  <propertyReferenceExpression name="Empty">
                                    <typeReferenceExpression type="String"/>
                                  </propertyReferenceExpression>
                                </parameters>
                              </methodInvokeExpression>
                            </assignStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="ItemsNewDataView">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                              <methodInvokeExpression methodName="GetAttribute">
                                <target>
                                  <propertyReferenceExpression name="Current">
                                    <variableReferenceExpression name="itemsIterator"/>
                                  </propertyReferenceExpression>
                                </target>
                                <parameters>
                                  <primitiveExpression value="newDataView"/>
                                  <propertyReferenceExpression name="Empty">
                                    <typeReferenceExpression type="String"/>
                                  </propertyReferenceExpression>
                                </parameters>
                              </methodInvokeExpression>
                            </assignStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="Copy">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                              <methodInvokeExpression methodName="GetAttribute">
                                <target>
                                  <propertyReferenceExpression name="Current">
                                    <variableReferenceExpression name="itemsIterator"/>
                                  </propertyReferenceExpression>
                                </target>
                                <parameters>
                                  <primitiveExpression value="copy"/>
                                  <propertyReferenceExpression name="Empty">
                                    <typeReferenceExpression type="String"/>
                                  </propertyReferenceExpression>
                                </parameters>
                              </methodInvokeExpression>
                            </assignStatement>
                            <variableDeclarationStatement type="System.String" name="pageSize">
                              <init>
                                <methodInvokeExpression methodName="GetAttribute">
                                  <target>
                                    <propertyReferenceExpression name="Current">
                                      <variableReferenceExpression name="itemsIterator"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="pageSize"/>
                                    <propertyReferenceExpression name="Empty">
                                      <typeReferenceExpression type="String"/>
                                    </propertyReferenceExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </init>
                            </variableDeclarationStatement>
                            <conditionStatement>
                              <condition>
                                <unaryOperatorExpression operator="IsNotNullOrEmpty">
                                  <variableReferenceExpression name="pageSize"/>
                                </unaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <propertyReferenceExpression name="ItemsPageSize">
                                    <variableReferenceExpression name="field"/>
                                  </propertyReferenceExpression>
                                  <methodInvokeExpression methodName="ToInt32">
                                    <target>
                                      <typeReferenceExpression type="Convert"/>
                                    </target>
                                    <parameters>
                                      <variableReferenceExpression name="pageSize"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                </assignStatement>
                              </trueStatements>
                            </conditionStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="ItemsLetters">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                              <binaryOperatorExpression operator="ValueEquality">
                                <methodInvokeExpression methodName="GetAttribute">
                                  <target>
                                    <propertyReferenceExpression name="Current">
                                      <variableReferenceExpression name="itemsIterator"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="letters"/>
                                    <propertyReferenceExpression name="Empty">
                                      <typeReferenceExpression type="String"/>
                                    </propertyReferenceExpression>
                                  </parameters>
                                </methodInvokeExpression>
                                <primitiveExpression value="true" convertTo="String"/>
                              </binaryOperatorExpression>
                            </assignStatement>
                            <variableDeclarationStatement type="XPathNodeIterator" name="itemIterator">
                              <init>
                                <methodInvokeExpression methodName="Select">
                                  <target>
                                    <propertyReferenceExpression name="Current">
                                      <variableReferenceExpression name="itemsIterator"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="c:item"/>
                                    <propertyReferenceExpression name="Resolver"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </init>
                            </variableDeclarationStatement>
                            <whileStatement>
                              <test>
                                <methodInvokeExpression methodName="MoveNext">
                                  <target>
                                    <variableReferenceExpression name="itemIterator"/>
                                  </target>
                                </methodInvokeExpression>
                              </test>
                              <statements>
                                <variableDeclarationStatement type="System.String" name="itemValue">
                                  <init>
                                    <methodInvokeExpression methodName="GetAttribute">
                                      <target>
                                        <propertyReferenceExpression name="Current">
                                          <variableReferenceExpression name="itemIterator"/>
                                        </propertyReferenceExpression>
                                      </target>
                                      <parameters>
                                        <primitiveExpression value="value"/>
                                        <propertyReferenceExpression name="Empty">
                                          <typeReferenceExpression type="String"/>
                                        </propertyReferenceExpression>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </init>
                                </variableDeclarationStatement>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="ValueEquality">
                                      <variableReferenceExpression name="itemValue"/>
                                      <primitiveExpression value="NULL"/>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <assignStatement>
                                      <variableReferenceExpression name="itemValue"/>
                                      <propertyReferenceExpression name="Empty">
                                        <typeReferenceExpression type="String"/>
                                      </propertyReferenceExpression>
                                    </assignStatement>
                                  </trueStatements>
                                </conditionStatement>
                                <variableDeclarationStatement type="System.String" name="itemText">
                                  <init>
                                    <methodInvokeExpression methodName="GetAttribute">
                                      <target>
                                        <propertyReferenceExpression name="Current">
                                          <variableReferenceExpression name="itemIterator"/>
                                        </propertyReferenceExpression>
                                      </target>
                                      <parameters>
                                        <primitiveExpression value="text"/>
                                        <propertyReferenceExpression name="Empty">
                                          <typeReferenceExpression type="String"/>
                                        </propertyReferenceExpression>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </init>
                                </variableDeclarationStatement>
                                <methodInvokeExpression methodName="Add">
                                  <target>
                                    <propertyReferenceExpression name="Items">
                                      <variableReferenceExpression name="field"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <parameters>
                                    <arrayCreateExpression>
                                      <createType type="System.Object"/>
                                      <initializers>
                                        <variableReferenceExpression name="itemValue"/>
                                        <variableReferenceExpression name="itemText"/>
                                      </initializers>
                                    </arrayCreateExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </statements>
                            </whileStatement>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="BooleanAnd">
                                  <unaryOperatorExpression operator="IsNotNullOrEmpty">
                                    <propertyReferenceExpression name="ItemsNewDataView">
                                      <variableReferenceExpression name="field"/>
                                    </propertyReferenceExpression>
                                  </unaryOperatorExpression>
                                  <binaryOperatorExpression operator="BooleanAnd">
                                    <binaryOperatorExpression operator="BooleanOr">
                                      <binaryOperatorExpression operator="IdentityEquality">
                                        <propertyReferenceExpression name="Current">
                                          <typeReferenceExpression type="ActionArgs"/>
                                        </propertyReferenceExpression>
                                        <primitiveExpression value="null"/>
                                      </binaryOperatorExpression>
                                      <binaryOperatorExpression operator="ValueEquality">
                                        <propertyReferenceExpression name="Controller">
                                          <propertyReferenceExpression name="Current">
                                            <typeReferenceExpression type="ActionArgs"/>
                                          </propertyReferenceExpression>
                                        </propertyReferenceExpression>
                                        <propertyReferenceExpression name="ItemsDataController">
                                          <variableReferenceExpression name="field"/>
                                        </propertyReferenceExpression>
                                      </binaryOperatorExpression>
                                    </binaryOperatorExpression>
                                    <binaryOperatorExpression operator="BooleanOr">
                                      <binaryOperatorExpression operator="IdentityEquality">
                                        <propertyReferenceExpression name="Current">
                                          <typeReferenceExpression type="PageRequest"/>
                                        </propertyReferenceExpression>
                                        <primitiveExpression value="null"/>
                                      </binaryOperatorExpression>
                                      <binaryOperatorExpression operator="ValueEquality">
                                        <propertyReferenceExpression name="Controller">
                                          <propertyReferenceExpression name="Current">
                                            <typeReferenceExpression type="PageRequest"/>
                                          </propertyReferenceExpression>
                                        </propertyReferenceExpression>
                                        <propertyReferenceExpression name="ItemsDataController">
                                          <variableReferenceExpression name="field"/>
                                        </propertyReferenceExpression>
                                      </binaryOperatorExpression>
                                    </binaryOperatorExpression>
                                  </binaryOperatorExpression>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <variableDeclarationStatement type="Controller" name="itemsController">
                                  <init>
                                    <castExpression targetType="Controller">
                                      <methodInvokeExpression methodName="CreateInstance">
                                        <target>
                                          <propertyReferenceExpression name="Assembly">
                                            <methodInvokeExpression methodName="GetType">
                                              <target>
                                                <thisReferenceExpression/>
                                              </target>
                                            </methodInvokeExpression>
                                          </propertyReferenceExpression>
                                        </target>
                                        <parameters>
                                          <propertyReferenceExpression name="FullName">
                                            <methodInvokeExpression methodName="GetType">
                                              <target>
                                                <thisReferenceExpression/>
                                              </target>
                                            </methodInvokeExpression>
                                          </propertyReferenceExpression>
                                        </parameters>
                                      </methodInvokeExpression>
                                    </castExpression>
                                  </init>
                                </variableDeclarationStatement>
                                <methodInvokeExpression methodName="SelectView">
                                  <target>
                                    <variableReferenceExpression name="itemsController"/>
                                  </target>
                                  <parameters>
                                    <propertyReferenceExpression name="ItemsDataController">
                                      <variableReferenceExpression name="field"/>
                                    </propertyReferenceExpression>
                                    <propertyReferenceExpression name="ItemsNewDataView">
                                      <variableReferenceExpression name="field"/>
                                    </propertyReferenceExpression>
                                  </parameters>
                                </methodInvokeExpression>
                                <variableDeclarationStatement type="System.String" name="roles">
                                  <init>
                                    <castExpression targetType="System.String">
                                      <methodInvokeExpression methodName="Evaluate">
                                        <target>
                                          <fieldReferenceExpression name="config">
                                            <variableReferenceExpression name="itemsController"/>
                                          </fieldReferenceExpression>
                                        </target>
                                        <parameters>
                                          <primitiveExpression value="string(//c:action[@commandName='New' and @commandArgument='{{0}}'][1]/@roles)"/>
                                          <propertyReferenceExpression name="ItemsNewDataView">
                                            <variableReferenceExpression name="field"/>
                                          </propertyReferenceExpression>
                                          <!--<stringFormatExpression format="string(//c:action[@commandName='New' and @commandArgument='{{0}}'][1]/@roles)">
                                            <propertyReferenceExpression name="ItemsNewDataView">
                                              <variableReferenceExpression name="field"/>
                                            </propertyReferenceExpression>
                                          </stringFormatExpression>
                                          <propertyReferenceExpression name="Resolver"/>-->
                                        </parameters>
                                      </methodInvokeExpression>
                                    </castExpression>
                                  </init>
                                </variableDeclarationStatement>
                                <conditionStatement>
                                  <condition>
                                    <unaryOperatorExpression operator="Not">
                                      <methodInvokeExpression methodName="UserIsInRole">
                                        <target>
                                          <typeReferenceExpression type="Controller"/>
                                        </target>
                                        <parameters>
                                          <variableReferenceExpression name="roles"/>
                                        </parameters>
                                      </methodInvokeExpression>
                                    </unaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <assignStatement>
                                      <propertyReferenceExpression name="ItemsNewDataView">
                                        <variableReferenceExpression name="field"/>
                                      </propertyReferenceExpression>
                                      <primitiveExpression value="null"/>
                                    </assignStatement>
                                  </trueStatements>
                                </conditionStatement>
                              </trueStatements>
                            </conditionStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="AutoSelect">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                              <binaryOperatorExpression operator="ValueEquality">
                                <methodInvokeExpression methodName="GetAttribute">
                                  <target>
                                    <propertyReferenceExpression name="Current">
                                      <variableReferenceExpression name="itemsIterator"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="autoSelect"/>
                                    <propertyReferenceExpression name="Empty">
                                      <typeReferenceExpression type="String"/>
                                    </propertyReferenceExpression>
                                  </parameters>
                                </methodInvokeExpression>
                                <primitiveExpression value="true" convertTo="String"/>
                              </binaryOperatorExpression>
                            </assignStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="SearchOnStart">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                              <binaryOperatorExpression operator="ValueEquality">
                                <methodInvokeExpression methodName="GetAttribute">
                                  <target>
                                    <propertyReferenceExpression name="Current">
                                      <variableReferenceExpression name="itemsIterator"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="searchOnStart"/>
                                    <propertyReferenceExpression name="Empty">
                                      <typeReferenceExpression type="String"/>
                                    </propertyReferenceExpression>
                                  </parameters>
                                </methodInvokeExpression>
                                <primitiveExpression value="true" convertTo="String"/>
                              </binaryOperatorExpression>
                            </assignStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="ItemsDescription">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                              <methodInvokeExpression methodName="GetAttribute">
                                <target>
                                  <propertyReferenceExpression name="Current">
                                    <variableReferenceExpression name="itemsIterator"/>
                                  </propertyReferenceExpression>
                                </target>
                                <parameters>
                                  <primitiveExpression value="description"/>
                                  <propertyReferenceExpression name="Empty">
                                    <typeReferenceExpression type="String"/>
                                  </propertyReferenceExpression>
                                </parameters>
                              </methodInvokeExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <conditionStatement>
                          <condition>
                            <unaryOperatorExpression operator="Not">
                              <methodInvokeExpression methodName="UserIsInRole">
                                <target>
                                  <typeReferenceExpression type="Controller"/>
                                </target>
                                <parameters>
                                  <methodInvokeExpression methodName="GetAttribute">
                                    <target>
                                      <propertyReferenceExpression name="Current">
                                        <variableReferenceExpression name="fieldIterator"/>
                                      </propertyReferenceExpression>
                                    </target>
                                    <parameters>
                                      <primitiveExpression value="writeRoles"/>
                                      <propertyReferenceExpression name="Empty">
                                        <typeReferenceExpression type="String"/>
                                      </propertyReferenceExpression>
                                    </parameters>
                                  </methodInvokeExpression>
                                  <!--<castExpression targetType="System.String">
                                    <methodInvokeExpression methodName="Evaluate">
                                      <target>
                                        <propertyReferenceExpression name="Current">
                                          <variableReferenceExpression name="fieldIterator"/>
                                        </propertyReferenceExpression>
                                      </target>
                                      <parameters>
                                        <primitiveExpression value="string(@writeRoles)"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </castExpression>-->
                                </parameters>
                              </methodInvokeExpression>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="ReadOnly">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="true"/>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <conditionStatement>
                          <condition>
                            <unaryOperatorExpression operator="Not">
                              <methodInvokeExpression methodName="UserIsInRole">
                                <target>
                                  <typeReferenceExpression type="Controller"/>
                                </target>
                                <parameters>
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
                                </parameters>
                              </methodInvokeExpression>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="ReadOnly">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="true"/>
                            </assignStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="Hidden">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="true"/>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <propertyReferenceExpression name="Fields">
                              <variableReferenceExpression name="page"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="field"/>
                          </parameters>
                        </methodInvokeExpression>
                        <comment>populate pivot info</comment>
                        <foreachStatement>
                          <variable type="System.String" name="tag"/>
                          <target>
                            <methodInvokeExpression methodName="Split">
                              <target>
                                <propertyReferenceExpression name="Tag">
                                  <variableReferenceExpression name="field"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression convertTo="Char" value=" "/>
                              </parameters>
                            </methodInvokeExpression>
                          </target>
                          <statements>
                            <conditionStatement>
                              <condition>
                                <methodInvokeExpression methodName="StartsWith">
                                  <target>
                                    <variableReferenceExpression name="tag"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="pivot"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </condition>
                              <trueStatements>
                                <methodInvokeExpression methodName="AddPivotField">
                                  <target>
                                    <variableReferenceExpression name="page"/>
                                  </target>
                                  <parameters>
                                    <variableReferenceExpression name="field"/>
                                  </parameters>
                                </methodInvokeExpression>
                                <breakStatement/>
                              </trueStatements>
                            </conditionStatement>
                          </statements>
                        </foreachStatement>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </whileStatement>
              </statements>
            </memberMethod>
            <!-- method ConfigureDataField(ViewPage, DataField) -->
            <memberMethod name="ConfigureDataField">
              <attributes family="true"/>
              <parameters>
                <parameter type="ViewPage" name="page"/>
                <parameter type="DataField" name="field"/>
              </parameters>
            </memberMethod>
            <!-- method LookupText(string, string, string) -->
            <memberMethod returnType="System.String" name="LookupText">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="controllerName"/>
                <parameter type="System.String" name="filterExpression"/>
                <parameter type="System.String" name="fieldNames"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.String[]" name="dataTextFields">
                  <init>
                    <methodInvokeExpression methodName="Split">
                      <target>
                        <argumentReferenceExpression name="fieldNames"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="," convertTo="Char"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="PageRequest" name="request">
                  <init>
                    <objectCreateExpression type="PageRequest">
                      <parameters>
                        <primitiveExpression value="-1"/>
                        <primitiveExpression value="1"/>
                        <primitiveExpression value="null"/>
                        <arrayCreateExpression>
                          <createType type="System.String"/>
                          <initializers>
                            <argumentReferenceExpression name="filterExpression"/>
                          </initializers>
                        </arrayCreateExpression>
                      </parameters>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="ViewPage" name="page">
                  <init>
                    <methodInvokeExpression methodName="GetPage">
                      <target>
                        <methodInvokeExpression methodName="CreateDataController">
                          <target>
                            <typeReferenceExpression type="ControllerFactory"/>
                          </target>
                        </methodInvokeExpression>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="controllerName"/>
                        <propertyReferenceExpression name="Empty">
                          <typeReferenceExpression type="String"/>
                        </propertyReferenceExpression>
                        <variableReferenceExpression name="request"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.String" name="result">
                  <init>
                    <propertyReferenceExpression name="Empty">
                      <typeReferenceExpression type="String"/>
                    </propertyReferenceExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="GreaterThan">
                      <propertyReferenceExpression name="Count">
                        <propertyReferenceExpression name="Rows">
                          <variableReferenceExpression name="page"/>
                        </propertyReferenceExpression>
                      </propertyReferenceExpression>
                      <primitiveExpression value="0"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <forStatement>
                      <variable type="System.Int32" name="i">
                        <init>
                          <primitiveExpression value="0"/>
                        </init>
                      </variable>
                      <test>
                        <binaryOperatorExpression operator="LessThan">
                          <variableReferenceExpression name="i"/>
                          <propertyReferenceExpression name="Count">
                            <propertyReferenceExpression name="Fields">
                              <variableReferenceExpression name="page"/>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                        </binaryOperatorExpression>
                      </test>
                      <increment>
                        <variableReferenceExpression name="i"/>
                      </increment>
                      <statements>
                        <variableDeclarationStatement type="DataField" name="field">
                          <init>
                            <arrayIndexerExpression>
                              <target>
                                <propertyReferenceExpression name="Fields">
                                  <variableReferenceExpression name="page"/>
                                </propertyReferenceExpression>
                              </target>
                              <indices>
                                <variableReferenceExpression name="i"/>
                              </indices>
                            </arrayIndexerExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="GreaterThanOrEqual">
                              <methodInvokeExpression methodName="IndexOf">
                                <target>
                                  <typeReferenceExpression type="Array"/>
                                </target>
                                <parameters>
                                  <variableReferenceExpression name="dataTextFields"/>
                                  <propertyReferenceExpression name="Name">
                                    <variableReferenceExpression name="field"/>
                                  </propertyReferenceExpression>
                                </parameters>
                              </methodInvokeExpression>
                              <primitiveExpression value="0"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="GreaterThan">
                                  <propertyReferenceExpression name="Length">
                                    <variableReferenceExpression name="result"/>
                                  </propertyReferenceExpression>
                                  <primitiveExpression value="0"/>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="result"/>
                                  <binaryOperatorExpression operator="Add">
                                    <variableReferenceExpression name="result"/>
                                    <primitiveExpression value="; "/>
                                  </binaryOperatorExpression>
                                </assignStatement>
                              </trueStatements>
                            </conditionStatement>
                            <assignStatement>
                              <variableReferenceExpression name="result"/>
                              <binaryOperatorExpression operator="Add">
                                <variableReferenceExpression name="result"/>
                                <methodInvokeExpression methodName="ToString">
                                  <target>
                                    <typeReferenceExpression type="Convert"/>
                                  </target>
                                  <parameters>
                                    <arrayIndexerExpression>
                                      <target>
                                        <arrayIndexerExpression>
                                          <target>
                                            <propertyReferenceExpression name="Rows">
                                              <variableReferenceExpression name="page"/>
                                            </propertyReferenceExpression>
                                          </target>
                                          <indices>
                                            <primitiveExpression value="0"/>
                                          </indices>
                                        </arrayIndexerExpression>
                                      </target>
                                      <indices>
                                        <variableReferenceExpression name="i"/>
                                      </indices>
                                    </arrayIndexerExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </binaryOperatorExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                      </statements>
                    </forStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <variableReferenceExpression name="result"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method ConvertSampleToQuery-->
            <memberMethod returnType="System.String" name="ConvertSampleToQuery">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="sample"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="Match" name="m">
                  <init>
                    <methodInvokeExpression methodName="Match">
                      <target>
                        <typeReferenceExpression type="Regex"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="sample"/>
                        <primitiveExpression>
                          <xsl:attribute name="value"><![CDATA[^\s*(?'Operation'(<|>)={0,1}){0,1}\s*(?'Value'.+)\s*$]]></xsl:attribute>
                        </primitiveExpression>
                        <!--<propertyReferenceExpression name="Compiled">
                          <typeReferenceExpression type="RegexOptions"/>
                        </propertyReferenceExpression>-->
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="Not">
                      <propertyReferenceExpression name="Success">
                        <variableReferenceExpression name="m"/>
                      </propertyReferenceExpression>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="null"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="System.String" name="operation">
                  <init>
                    <propertyReferenceExpression name="Value">
                      <arrayIndexerExpression>
                        <target>
                          <propertyReferenceExpression name="Groups">
                            <variableReferenceExpression name="m"/>
                          </propertyReferenceExpression>
                        </target>
                        <indices>
                          <primitiveExpression value="Operation"/>
                        </indices>
                      </arrayIndexerExpression>
                    </propertyReferenceExpression>
                  </init>
                </variableDeclarationStatement>
                <assignStatement>
                  <argumentReferenceExpression name="sample"/>
                  <methodInvokeExpression methodName="Trim">
                    <target>
                      <propertyReferenceExpression name="Value">
                        <arrayIndexerExpression>
                          <target>
                            <propertyReferenceExpression name="Groups">
                              <variableReferenceExpression name="m"/>
                            </propertyReferenceExpression>
                          </target>
                          <indices>
                            <primitiveExpression value="Value"/>
                          </indices>
                        </arrayIndexerExpression>
                      </propertyReferenceExpression>
                    </target>
                  </methodInvokeExpression>
                </assignStatement>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="IsNullOrEmpty">
                      <target>
                        <typeReferenceExpression type="String"/>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="operation"/>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="operation"/>
                      <primitiveExpression value="*"/>
                    </assignStatement>
                    <variableDeclarationStatement type="System.Double" name="doubleTest"/>
                    <conditionStatement>
                      <condition>
                        <methodInvokeExpression methodName="TryParse">
                          <target>
                            <typeReferenceExpression type="Double"/>
                          </target>
                          <parameters>
                            <argumentReferenceExpression name="sample"/>
                            <directionExpression  direction="Out">
                              <variableReferenceExpression name="doubleTest"/>
                            </directionExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="operation"/>
                          <primitiveExpression value="="/>
                        </assignStatement>
                      </trueStatements>
                      <falseStatements>
                        <variableDeclarationStatement type="System.Boolean" name="boolTest"/>
                        <conditionStatement>
                          <condition>
                            <methodInvokeExpression methodName="TryParse">
                              <target>
                                <typeReferenceExpression type="Boolean"/>
                              </target>
                              <parameters>
                                <argumentReferenceExpression name="sample"/>
                                <directionExpression direction="Out">
                                  <variableReferenceExpression name="boolTest"/>
                                </directionExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="operation"/>
                              <primitiveExpression value="="/>
                            </assignStatement>
                          </trueStatements>
                          <falseStatements>
                            <variableDeclarationStatement type="DateTime" name="dateTest"/>
                            <conditionStatement>
                              <condition>
                                <methodInvokeExpression methodName="TryParse">
                                  <target>
                                    <typeReferenceExpression type="DateTime"/>
                                  </target>
                                  <parameters>
                                    <argumentReferenceExpression name="sample"/>
                                    <directionExpression direction="Out">
                                      <variableReferenceExpression name="dateTest"/>
                                    </directionExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="operation"/>
                                  <primitiveExpression value="="/>
                                </assignStatement>
                              </trueStatements>
                            </conditionStatement>
                          </falseStatements>
                        </conditionStatement>
                      </falseStatements>
                    </conditionStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <stringFormatExpression format="{{0}}{{1}}{{2}}">
                    <variableReferenceExpression name="operation"/>
                    <argumentReferenceExpression name="sample"/>
                    <methodInvokeExpression methodName="ToChar">
                      <target>
                        <typeReferenceExpression type="Convert"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="0"/>
                      </parameters>
                    </methodInvokeExpression>
                  </stringFormatExpression>
                  <!--<methodInvokeExpression methodName="Format">
                    <target>
                      <typeReferenceExpression type="String"/>
                    </target>
                    <parameters>
                      <primitiveExpression value="{{0}}{{1}}{{2}}"/>
                      <variableReferenceExpression name="operation"/>
                      <argumentReferenceExpression name="sample"/>
                      <methodInvokeExpression methodName="ToChar">
                        <target>
                          <typeReferenceExpression type="Convert"/>
                        </target>
                        <parameters>
                          <primitiveExpression value="0"/>
                        </parameters>
                      </methodInvokeExpression>
                    </parameters>
                  </methodInvokeExpression>-->
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method LookupActionArgument(string, string) -->
            <memberMethod returnType="System.String" name="LookupActionArgument">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="controllerName"/>
                <parameter type="System.String" name="commandName"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="Controller" name="c">
                  <init>
                    <objectCreateExpression type="Controller"/>
                  </init>
                </variableDeclarationStatement>
                <methodInvokeExpression methodName="SelectView">
                  <target>
                    <variableReferenceExpression name="c"/>
                  </target>
                  <parameters>
                    <argumentReferenceExpression name="controllerName"/>
                    <primitiveExpression value="null"/>
                  </parameters>
                </methodInvokeExpression>
                <variableDeclarationStatement type="XPathNavigator" name="action">
                  <init>
                    <methodInvokeExpression methodName="SelectSingleNode">
                      <target>
                        <fieldReferenceExpression name="config">
                          <variableReferenceExpression name="c"/>
                        </fieldReferenceExpression>
                      </target>
                      <parameters>
                        <primitiveExpression value="//c:action[@commandName='{{0}}' and contains(@commandArgument, 'Form')]"/>
                        <argumentReferenceExpression name="commandName"/>
                        <!--<stringFormatExpression format="//c:action[@commandName='{{0}}' and contains(@commandArgument, 'Form')]">
                          <argumentReferenceExpression name="commandName"/>
                        </stringFormatExpression>
                        <propertyReferenceExpression name="Resolver">
                          <variableReferenceExpression name="c"/>
                        </propertyReferenceExpression>-->
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <variableReferenceExpression name="action"/>
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
                    <unaryOperatorExpression operator="Not">
                      <methodInvokeExpression methodName="UserIsInRole">
                        <parameters>
                          <methodInvokeExpression methodName="GetAttribute">
                            <target>
                              <variableReferenceExpression name="action"/>
                            </target>
                            <parameters>
                              <primitiveExpression value="roles"/>
                              <propertyReferenceExpression name="Empty">
                                <typeReferenceExpression type="String"/>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </parameters>
                      </methodInvokeExpression>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="null"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="GetAttribute">
                    <target>
                      <variableReferenceExpression name="action"/>
                    </target>
                    <parameters>
                      <primitiveExpression value="commandArgument"/>
                      <propertyReferenceExpression name="Empty">
                        <typeReferenceExpression type="String"/>
                      </propertyReferenceExpression>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- CreateReportInstance -->
            <memberMethod returnType="System.String" name="CreateReportInstance">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="Type" name="t"/>
                <parameter type="System.String" name="name"/>
                <parameter type="System.String" name="controller"/>
                <parameter type="System.String" name="view"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="CreateReportInstance">
                    <parameters>
                      <argumentReferenceExpression name="t"/>
                      <argumentReferenceExpression name="name"/>
                      <argumentReferenceExpression name="controller"/>
                      <argumentReferenceExpression name="view"/>
                      <primitiveExpression value="true"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- CreateReportInstance -->
            <memberMethod returnType="System.String" name="CreateReportInstance">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="Type" name="t"/>
                <parameter type="System.String" name="name"/>
                <parameter type="System.String" name="controller"/>
                <parameter type="System.String" name="view"/>
                <parameter type="System.Boolean" name="validate"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="IsNullOrEmpty">
                      <target>
                        <typeReferenceExpression type="String"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="name"/>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="System.String" name="instance">
                      <init>
                        <methodInvokeExpression methodName="CreateReportInstance">
                          <parameters>
                            <argumentReferenceExpression name="t"/>
                            <stringFormatExpression  format="{{0}}_{{1}}.rdlc">
                              <argumentReferenceExpression name="controller"/>
                              <argumentReferenceExpression name="view"/>
                            </stringFormatExpression>
                            <argumentReferenceExpression name="controller"/>
                            <argumentReferenceExpression name="view"/>
                            <primitiveExpression value="false"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="IsNotNullOrEmpty">
                          <variableReferenceExpression name="instance"/>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodReturnStatement>
                          <variableReferenceExpression name="instance"/>
                        </methodReturnStatement>
                      </trueStatements>
                    </conditionStatement>
                    <assignStatement>
                      <variableReferenceExpression name="instance"/>
                      <methodInvokeExpression methodName="CreateReportInstance">
                        <parameters>
                          <argumentReferenceExpression name="t"/>
                          <primitiveExpression value="CustomTemplate.xslt"/>
                          <argumentReferenceExpression name="controller"/>
                          <argumentReferenceExpression name="view"/>
                          <primitiveExpression value="false"/>
                        </parameters>
                      </methodInvokeExpression>
                    </assignStatement>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="IsNotNullOrEmpty">
                          <variableReferenceExpression name="instance"/>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodReturnStatement>
                          <variableReferenceExpression name="instance"/>
                        </methodReturnStatement>
                      </trueStatements>
                    </conditionStatement>
                    <assignStatement>
                      <argumentReferenceExpression name="name"/>
                      <primitiveExpression value="Template.xslt"/>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="System.Boolean" name="isGeneric">
                  <init>
                    <binaryOperatorExpression operator="ValueEquality">
                      <methodInvokeExpression  methodName="ToLower">
                        <target>
                          <methodInvokeExpression methodName="GetExtension">
                            <target>
                              <typeReferenceExpression type="Path"/>
                            </target>
                            <parameters>
                              <variableReferenceExpression name="name"/>
                            </parameters>
                          </methodInvokeExpression>
                        </target>
                      </methodInvokeExpression>
                      <primitiveExpression value=".xslt"/>
                    </binaryOperatorExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.String" name="reportKey">
                  <init>
                    <binaryOperatorExpression operator="Add">
                      <primitiveExpression value="Report_"/>
                      <argumentReferenceExpression name="name"/>
                    </binaryOperatorExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <variableReferenceExpression name="isGeneric"/>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="reportKey"/>
                      <stringFormatExpression format="Reports_{{0}}_{{1}}">
                        <argumentReferenceExpression name="controller"/>
                        <argumentReferenceExpression name="view"/>
                      </stringFormatExpression>
                      <!--<methodInvokeExpression methodName="Format">
                        <target>
                          <typeReferenceExpression type="String"/>
                        </target>
                        <parameters>
                          <primitiveExpression value="Reports_{{0}}_{{1}}"/>
                          <argumentReferenceExpression name="controller"/>
                          <argumentReferenceExpression name="view"/>
                        </parameters>
                      </methodInvokeExpression>-->
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <!--<variableDeclarationStatement type="System.String" name="report">
                  <init>
                    <castExpression targetType="System.String">
                      <arrayIndexerExpression>
                        <target>
                          <propertyReferenceExpression name="Cache">
                            <typeReferenceExpression type="HttpRuntime"/>
                          </propertyReferenceExpression>
                        </target>
                        <indices>
                          <variableReferenceExpression name="reportKey"/>
                        </indices>
                      </arrayIndexerExpression>
                    </castExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="IsNullOrEmpty">
                      <target>
                        <typeReferenceExpression type="String"/>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="report"/>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                   
                  </trueStatements>
                </conditionStatement>-->
                <variableDeclarationStatement type="System.String" name="report">
                  <init>
                    <primitiveExpression value="null"/>
                  </init>
                </variableDeclarationStatement>
                <comment>try loading a report as a resource or from the folder ~/Reports/</comment>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <variableReferenceExpression name="t"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="t"/>
                      <typeofExpression type="{$Namespace}.Data.Controller"/>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="Stream" name="res">
                  <init>
                    <methodInvokeExpression methodName="GetManifestResourceStream">
                      <target>
                        <propertyReferenceExpression name="Assembly">
                          <argumentReferenceExpression name="t"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <stringFormatExpression format="{$Namespace}.Reports.{{0}}">
                          <argumentReferenceExpression name="name"/>
                        </stringFormatExpression>
                        <!--<methodInvokeExpression methodName="Format">
                              <target>
                                <typeReferenceExpression type="String"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="{$Namespace}.Reports.{{0}}"/>
                                <argumentReferenceExpression name="name"/>
                              </parameters>
                            </methodInvokeExpression>-->
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <variableReferenceExpression name="res"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="res"/>
                      <methodInvokeExpression methodName="GetManifestResourceStream">
                        <target>
                          <propertyReferenceExpression name="Assembly">
                            <argumentReferenceExpression name="t"/>
                          </propertyReferenceExpression>
                        </target>
                        <parameters>
                          <stringFormatExpression format="{$Namespace}.{{0}}">
                            <argumentReferenceExpression name="name"/>
                          </stringFormatExpression>
                          <!--<methodInvokeExpression methodName="Format">
                                <target>
                                  <typeReferenceExpression type="String"/>
                                </target>
                                <parameters>
                                  <primitiveExpression value="{$Namespace}.{{0}}"/>
                                  <argumentReferenceExpression name="name"/>
                                </parameters>
                              </methodInvokeExpression>-->
                        </parameters>
                      </methodInvokeExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <!--<variableDeclarationStatement type="CacheDependency" name="dependency">
                  <init>
                    <primitiveExpression value="null"/>
                  </init>
                </variableDeclarationStatement>-->
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <variableReferenceExpression  name="res"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="System.String" name="templatePath">
                      <init>
                        <methodInvokeExpression methodName="Combine">
                          <target>
                            <typeReferenceExpression type="Path"/>
                          </target>
                          <parameters>
                            <methodInvokeExpression methodName="Combine">
                              <target>
                                <typeReferenceExpression type="Path"/>
                              </target>
                              <parameters>
                                <propertyReferenceExpression name="AppDomainAppPath">
                                  <typeReferenceExpression type="HttpRuntime"/>
                                </propertyReferenceExpression>
                                <primitiveExpression value="Reports"/>
                              </parameters>
                            </methodInvokeExpression>
                            <argumentReferenceExpression name="name"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="Not">
                          <methodInvokeExpression methodName="Exists">
                            <target>
                              <typeReferenceExpression type="File"/>
                            </target>
                            <parameters>
                              <variableReferenceExpression name="templatePath"/>
                            </parameters>
                          </methodInvokeExpression>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <conditionStatement>
                          <condition>
                            <argumentReferenceExpression name="validate"/>
                          </condition>
                          <trueStatements>
                            <throwExceptionStatement>
                              <objectCreateExpression type="Exception">
                                <parameters>
                                  <stringFormatExpression format="Report or report template \'{{0}}\' does not exist.">
                                    <argumentReferenceExpression name="name"/>
                                  </stringFormatExpression>
                                </parameters>
                              </objectCreateExpression>
                            </throwExceptionStatement>
                          </trueStatements>
                          <falseStatements>
                            <methodReturnStatement>
                              <primitiveExpression value="null"/>
                            </methodReturnStatement>
                          </falseStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
                    <assignStatement>
                      <variableReferenceExpression name="report"/>
                      <methodInvokeExpression methodName="ReadAllText">
                        <target>
                          <typeReferenceExpression type="File"/>
                        </target>
                        <parameters>
                          <variableReferenceExpression name="templatePath"/>
                        </parameters>
                      </methodInvokeExpression>
                    </assignStatement>
                    <!--<assignStatement>
                      <variableReferenceExpression name="dependency"/>
                      <objectCreateExpression type="CacheDependency">
                        <parameters>
                          <variableReferenceExpression name="templatePath"/>
                        </parameters>
                      </objectCreateExpression>
                    </assignStatement>-->
                  </trueStatements>
                  <falseStatements>
                    <variableDeclarationStatement type="StreamReader" name="reader">
                      <init>
                        <objectCreateExpression type="StreamReader">
                          <parameters>
                            <variableReferenceExpression name="res"/>
                          </parameters>
                        </objectCreateExpression>
                      </init>
                    </variableDeclarationStatement>
                    <assignStatement>
                      <variableReferenceExpression name="report"/>
                      <methodInvokeExpression methodName="ReadToEnd">
                        <target>
                          <variableReferenceExpression name="reader"/>
                        </target>
                      </methodInvokeExpression>
                    </assignStatement>
                    <methodInvokeExpression methodName="Close">
                      <target>
                        <variableReferenceExpression name="reader"/>
                      </target>
                    </methodInvokeExpression>
                  </falseStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <variableReferenceExpression name="isGeneric"/>
                  </condition>
                  <trueStatements>
                    <comment>transform a data controller into a report by applying the specified template</comment>
                    <variableDeclarationStatement type="ControllerConfiguration" name="config">
                      <init>
                        <methodInvokeExpression methodName="CreateConfigurationInstance">
                          <target>
                            <typeReferenceExpression type="{$Namespace}.Data.Controller"/>
                          </target>
                          <parameters>
                            <argumentReferenceExpression name="t"/>
                            <argumentReferenceExpression name="controller"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="XsltArgumentList" name="arguments">
                      <init>
                        <objectCreateExpression type="XsltArgumentList"/>
                      </init>
                    </variableDeclarationStatement>
                    <methodInvokeExpression methodName="AddParam">
                      <target>
                        <variableReferenceExpression name="arguments"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="ViewName"/>
                        <propertyReferenceExpression name="Empty">
                          <typeReferenceExpression type="String"/>
                        </propertyReferenceExpression>
                        <argumentReferenceExpression name="view"/>
                      </parameters>
                    </methodInvokeExpression>
                    <variableDeclarationStatement type="XslCompiledTransform" name="transform">
                      <init>
                        <objectCreateExpression type="XslCompiledTransform"/>
                      </init>
                    </variableDeclarationStatement>
                    <methodInvokeExpression methodName="Load">
                      <target>
                        <variableReferenceExpression name="transform"/>
                      </target>
                      <parameters>
                        <objectCreateExpression type="XPathDocument">
                          <parameters>
                            <objectCreateExpression type="StringReader">
                              <parameters>
                                <variableReferenceExpression name="report"/>
                              </parameters>
                            </objectCreateExpression>
                          </parameters>
                        </objectCreateExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <variableDeclarationStatement type="MemoryStream" name="output">
                      <init>
                        <objectCreateExpression type="MemoryStream"/>
                      </init>
                    </variableDeclarationStatement>
                    <methodInvokeExpression methodName="Transform">
                      <target>
                        <variableReferenceExpression name="transform"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="TrimmedNavigator">
                          <variableReferenceExpression name="config"/>
                        </propertyReferenceExpression>
                        <variableReferenceExpression name="arguments"/>
                        <variableReferenceExpression name="output"/>
                      </parameters>
                    </methodInvokeExpression>
                    <assignStatement>
                      <propertyReferenceExpression name="Position">
                        <variableReferenceExpression name="output"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="0"/>
                    </assignStatement>
                    <variableDeclarationStatement type="StreamReader" name="sr">
                      <init>
                        <objectCreateExpression type="StreamReader">
                          <parameters>
                            <variableReferenceExpression name="output"/>
                          </parameters>
                        </objectCreateExpression>
                      </init>
                    </variableDeclarationStatement>
                    <assignStatement>
                      <variableReferenceExpression name="report"/>
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
                  </trueStatements>
                </conditionStatement>
                <!--<methodInvokeExpression methodName="Insert">
                  <target>
                    <propertyReferenceExpression name="Cache">
                      <typeReferenceExpression type="HttpRuntime"/>
                    </propertyReferenceExpression>
                  </target>
                  <parameters>
                    <variableReferenceExpression name="reportKey"/>
                    <variableReferenceExpression name="report"/>
                    <variableReferenceExpression name="dependency"/>
                  </parameters>
                </methodInvokeExpression>-->
                <assignStatement>
                  <variableReferenceExpression name="report"/>
                  <methodInvokeExpression methodName="Replace">
                    <target>
                      <typeReferenceExpression type="Regex"/>
                    </target>
                    <parameters>
                      <variableReferenceExpression name="report"/>
                      <primitiveExpression>
                        <xsl:attribute name="value"><![CDATA[(<Language>)(.+?)(</Language>)]]></xsl:attribute>
                      </primitiveExpression>
                      <stringFormatExpression format="$1{{0}}$3">
                        <propertyReferenceExpression name="Name">
                          <propertyReferenceExpression name="CurrentUICulture">
                            <propertyReferenceExpression name="CurrentThread">
                              <typeReferenceExpression type="System.Threading.Thread"/>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                      </stringFormatExpression>
                      <!--<methodInvokeExpression methodName="Format">
                        <target>
                          <typeReferenceExpression type="String"/>
                        </target>
                        <parameters>
                          <primitiveExpression value="$1{{0}}$3"/>
                          <propertyReferenceExpression name="Name">
                            <propertyReferenceExpression name="CurrentUICulture">
                              <propertyReferenceExpression name="CurrentThread">
                                <typeReferenceExpression type="System.Threading.Thread"/>
                              </propertyReferenceExpression>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                        </parameters>
                      </methodInvokeExpression>-->
                    </parameters>
                  </methodInvokeExpression>
                </assignStatement>
                <assignStatement>
                  <variableReferenceExpression name="report"/>
                  <methodInvokeExpression methodName="Replace">
                    <target>
                      <typeReferenceExpression type="Localizer"/>
                    </target>
                    <parameters>
                      <primitiveExpression value="Reports"/>
                      <argumentReferenceExpression name="name"/>
                      <variableReferenceExpression name="report"/>
                    </parameters>
                  </methodInvokeExpression>
                </assignStatement>
                <methodReturnStatement>
                  <variableReferenceExpression name="report"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- property TypeMap -->
            <memberField type="SortedDictionary" name="typeMap">
              <attributes private="true" static="true"/>
              <typeArguments>
                <typeReference type="System.String"/>
                <typeReference type="Type"/>
              </typeArguments>
            </memberField>
            <memberProperty type="SortedDictionary" name="TypeMap">
              <typeArguments>
                <typeReference type="System.String"/>
                <typeReference type="Type"/>
              </typeArguments>
              <attributes public="true" static="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="typeMap"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- method FindSelectedValueByTag(string tag) -->
            <memberMethod returnType="System.Object" name="FindSelectedValueByTag">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="tag"/>
              </parameters>
              <statements>
                <comment>#pragma warning disable 0618</comment>
                <variableDeclarationStatement type="System.Web.Script.Serialization.JavaScriptSerializer" name="serializer">
                  <init>
                    <objectCreateExpression type="System.Web.Script.Serialization.JavaScriptSerializer"/>
                  </init>
                </variableDeclarationStatement>
                <comment>#pragma warning restore 0618</comment>
                <variableDeclarationStatement type="System.Object[]"  name="selectedValues">
                  <init>
                    <methodInvokeExpression methodName="Deserialize">
                      <typeArguments>
                        <typeReference type="System.Object[]"/>
                      </typeArguments>
                      <target>
                        <variableReferenceExpression name="serializer"/>
                      </target>
                      <parameters>
                        <arrayIndexerExpression>
                          <target>
                            <propertyReferenceExpression name="Form">
                              <propertyReferenceExpression name="Request">
                                <propertyReferenceExpression name="Current">
                                  <typeReferenceExpression type="HttpContext"/>
                                </propertyReferenceExpression>
                              </propertyReferenceExpression>
                            </propertyReferenceExpression>
                          </target>
                          <indices>
                            <primitiveExpression value="__WEB_DATAVIEWSTATE"/>
                          </indices>
                        </arrayIndexerExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <variableReferenceExpression name="selectedValues"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="System.Int32" name="i">
                      <init>
                        <primitiveExpression value="0"/>
                      </init>
                    </variableDeclarationStatement>
                    <whileStatement>
                      <test>
                        <binaryOperatorExpression operator="LessThan">
                          <variableReferenceExpression name="i"/>
                          <propertyReferenceExpression name="Length">
                            <variableReferenceExpression name="selectedValues"/>
                          </propertyReferenceExpression>
                        </binaryOperatorExpression>
                      </test>
                      <statements>
                        <variableDeclarationStatement type="System.String" name="k">
                          <init>
                            <castExpression targetType="System.String">
                              <arrayIndexerExpression>
                                <target>
                                  <variableReferenceExpression name="selectedValues"/>
                                </target>
                                <indices>
                                  <variableReferenceExpression name="i"/>
                                </indices>
                              </arrayIndexerExpression>
                            </castExpression>
                          </init>
                        </variableDeclarationStatement>
                        <assignStatement>
                          <variableReferenceExpression name="i"/>
                          <binaryOperatorExpression operator="Add">
                            <variableReferenceExpression name="i"/>
                            <primitiveExpression value="1"/>
                          </binaryOperatorExpression>
                        </assignStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="ValueEquality">
                              <variableReferenceExpression name="k"/>
                              <argumentReferenceExpression name="tag"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <variableDeclarationStatement type="System.Object[]" name="v">
                              <init>
                                <castExpression targetType="System.Object[]">
                                  <arrayIndexerExpression>
                                    <target>
                                      <variableReferenceExpression name="selectedValues"/>
                                    </target>
                                    <indices>
                                      <variableReferenceExpression name="i"/>
                                    </indices>
                                  </arrayIndexerExpression>
                                </castExpression>
                              </init>
                            </variableDeclarationStatement>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="BooleanOr">
                                  <binaryOperatorExpression operator="IdentityEquality">
                                    <variableReferenceExpression name="v"/>
                                    <primitiveExpression value="null"/>
                                  </binaryOperatorExpression>
                                  <binaryOperatorExpression operator="ValueEquality">
                                    <propertyReferenceExpression name="Length">
                                      <variableReferenceExpression name="v"/>
                                    </propertyReferenceExpression>
                                    <primitiveExpression value="0"/>
                                  </binaryOperatorExpression>
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
                                <binaryOperatorExpression operator="ValueEquality">
                                  <propertyReferenceExpression name="Length">
                                    <variableReferenceExpression name="v"/>
                                  </propertyReferenceExpression>
                                  <primitiveExpression value="1"/>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <methodReturnStatement>
                                  <arrayIndexerExpression>
                                    <target>
                                      <variableReferenceExpression name="v"/>
                                    </target>
                                    <indices>
                                      <primitiveExpression value="0"/>
                                    </indices>
                                  </arrayIndexerExpression>
                                </methodReturnStatement>
                              </trueStatements>
                            </conditionStatement>
                            <methodReturnStatement>
                              <variableReferenceExpression name="v"/>
                            </methodReturnStatement>
                          </trueStatements>
                        </conditionStatement>
                        <assignStatement>
                          <variableReferenceExpression name="i"/>
                          <binaryOperatorExpression operator="Add">
                            <variableReferenceExpression name="i"/>
                            <primitiveExpression value="1"/>
                          </binaryOperatorExpression>
                        </assignStatement>
                      </statements>
                    </whileStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <primitiveExpression value="null"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
      </types>
    </compileUnit>
  </xsl:template>

</xsl:stylesheet>
