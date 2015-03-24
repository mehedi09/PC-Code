<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.codeontime.com/2008/codedom-compiler"  xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl a"
>
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/">
    <compileUnit namespace="{a:project/a:namespace}.Data">
      <imports>
        <namespaceImport name="System"/>
        <namespaceImport name="System.Collections.Generic"/>
        <namespaceImport name="System.ComponentModel"/>
        <namespaceImport name="System.Data"/>
        <namespaceImport name="System.Data.Common"/>
        <namespaceImport name="System.Linq"/>
        <namespaceImport name="System.Text"/>
        <namespaceImport name="System.Text.RegularExpressions"/>
        <namespaceImport name="System.Transactions"/>
        <namespaceImport name="System.Xml"/>
        <namespaceImport name="System.Xml.XPath"/>
        <namespaceImport name="System.Web"/>
        <namespaceImport name="System.Web.Caching"/>
        <namespaceImport name="System.Web.Configuration"/>
        <namespaceImport name="System.Web.Security"/>
      </imports>
      <types>
        <!-- class TransactionManager -->
        <typeDeclaration name="TransactionManager">
          <members>
            <!-- property Transaction -->
            <memberField type="System.String" name="transaction"/>
            <memberProperty type="System.String" name="Transaction">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="transaction"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="transaction"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property Status -->
            <memberField type="System.String" name="status"/>
            <memberProperty type="System.String" name="Status">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="status"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="status"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property Tables -->
            <memberField type="SortedDictionary" name="tables">
              <typeArguments>
                <typeReference type="System.String"/>
                <typeReference type="DataTable"/>
              </typeArguments>
            </memberField>
            <memberProperty type="SortedDictionary" name="Tables">
              <typeArguments>
                <typeReference type="System.String"/>
                <typeReference type="DataTable"/>
              </typeArguments>
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="tables"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property PrimaryKeys -->
            <memberField type="SortedDictionary" name="primaryKeys">
              <typeArguments>
                <typeReference type="System.String"/>
                <typeReference type="System.Object"/>
              </typeArguments>
            </memberField>
            <memberProperty type="SortedDictionary" name="PrimaryKeys">
              <typeArguments>
                <typeReference type="System.String"/>
                <typeReference type="System.Object"/>
              </typeArguments>
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="primaryKeys"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property Arguments -->
            <memberField type="List" name="arguments">
              <typeArguments>
                <typeReference type="ActionArgs"/>
              </typeArguments>
            </memberField>
            <memberProperty type="List" name="Arguments">
              <typeArguments>
                <typeReference type="ActionArgs"/>
              </typeArguments>
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="arguments"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- constructor TransactionManager(System.String) -->
            <constructor>
              <attributes public="true"/>
              <parameters>
                <parameter type="System.String" name="transaction"/>
              </parameters>
              <statements>
                <assignStatement>
                  <fieldReferenceExpression name="transaction"/>
                  <argumentReferenceExpression name="transaction"/>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="tables"/>
                  <objectCreateExpression type="SortedDictionary">
                    <typeArguments>
                      <typeReference type="System.String"/>
                      <typeReference type="DataTable"/>
                    </typeArguments>
                  </objectCreateExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="primaryKeys"/>
                  <objectCreateExpression type="SortedDictionary">
                    <typeArguments>
                      <typeReference type="System.String"/>
                      <typeReference type="System.Object"/>
                    </typeArguments>
                  </objectCreateExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="arguments"/>
                  <objectCreateExpression type="List">
                    <typeArguments>
                      <typeReference type="ActionArgs"/>
                    </typeArguments>
                  </objectCreateExpression>
                </assignStatement>
              </statements>
            </constructor>
            <!-- method GetTable(string, DbCommand) -->
            <memberMethod returnType="DataTable" name="GetTable">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="System.String" name="controller"/>
                <parameter type="DbCommand" name="command"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="DataTable" name="t">
                  <init>
                    <primitiveExpression value="null"/>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="Not">
                      <methodInvokeExpression methodName="TryGetValue">
                        <target>
                          <propertyReferenceExpression name="Tables"/>
                        </target>
                        <parameters>
                          <argumentReferenceExpression name="controller"/>
                          <directionExpression direction="Out">
                            <variableReferenceExpression name="t"/>
                          </directionExpression>
                        </parameters>
                      </methodInvokeExpression>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="DbParameter" name="p">
                      <init>
                        <arrayIndexerExpression>
                          <target>
                            <propertyReferenceExpression name="Parameters">
                              <argumentReferenceExpression name="command"/>
                            </propertyReferenceExpression>
                          </target>
                          <indices>
                            <primitiveExpression value="@PageRangeLastRowNumber"/>
                          </indices>
                        </arrayIndexerExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityInequality">
                          <variableReferenceExpression name="p"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <propertyReferenceExpression name="Value">
                            <variableReferenceExpression name="p"/>
                          </propertyReferenceExpression>
                          <primitiveExpression value="500"/>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                    <assignStatement>
                      <variableReferenceExpression name="t"/>
                      <objectCreateExpression type="DataTable">
                        <parameters>
                          <argumentReferenceExpression name="controller"/>
                        </parameters>
                      </objectCreateExpression>
                    </assignStatement>
                    <methodInvokeExpression methodName="Load">
                      <target>
                        <variableReferenceExpression name="t"/>
                      </target>
                      <parameters>
                        <methodInvokeExpression methodName="ExecuteReader">
                          <target>
                            <argumentReferenceExpression name="command"/>
                          </target>
                        </methodInvokeExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <foreachStatement>
                      <variable type="DataColumn" name="c"/>
                      <target>
                        <propertyReferenceExpression name="Columns">
                          <variableReferenceExpression name="t"/>
                        </propertyReferenceExpression>
                      </target>
                      <statements>
                        <assignStatement>
                          <propertyReferenceExpression name="AllowDBNull">
                            <variableReferenceExpression name="c"/>
                          </propertyReferenceExpression>
                          <primitiveExpression value="true"/>
                        </assignStatement>
                      </statements>
                    </foreachStatement>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <propertyReferenceExpression name="Tables"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="controller"/>
                        <variableReferenceExpression name="t"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <variableReferenceExpression name="t"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method Delete() -->
            <memberMethod name="Delete">
              <attributes public="true" final="true"/>
              <statements>
                <methodInvokeExpression methodName="Remove">
                  <target>
                    <propertyReferenceExpression name="Session">
                      <propertyReferenceExpression name="Current">
                        <typeReferenceExpression type="HttpContext"/>
                      </propertyReferenceExpression>
                    </propertyReferenceExpression>
                  </target>
                  <parameters>
                    <binaryOperatorExpression operator="Add">
                      <primitiveExpression value="TransactionManager_"/>
                      <fieldReferenceExpression name="transaction"/>
                    </binaryOperatorExpression>
                  </parameters>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- method Create(string) -->
            <memberMethod returnType="TransactionManager" name="Create">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="transaction"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="IsNullOrEmpty">
                      <target>
                        <typeReferenceExpression type="String"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="transaction"/>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="null"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="System.String[]" name="transactionInfo">
                  <init>
                    <methodInvokeExpression methodName="Split">
                      <target>
                        <argumentReferenceExpression name="transaction"/>
                      </target>
                      <parameters>
                        <primitiveExpression value=":" convertTo="Char"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <assignStatement>
                  <argumentReferenceExpression name="transaction"/>
                  <arrayIndexerExpression>
                    <target>
                      <variableReferenceExpression name="transactionInfo"/>
                    </target>
                    <indices>
                      <primitiveExpression value="0"/>
                    </indices>
                  </arrayIndexerExpression>
                </assignStatement>
                <variableDeclarationStatement type="System.String" name="key">
                  <init>
                    <binaryOperatorExpression operator="Add">
                      <primitiveExpression value="TransactionManager_"/>
                      <argumentReferenceExpression name="transaction"/>
                    </binaryOperatorExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="TransactionManager" name="tm">
                  <init>
                    <castExpression targetType="TransactionManager">
                      <arrayIndexerExpression>
                        <target>
                          <propertyReferenceExpression name="Session">
                            <propertyReferenceExpression name="Current">
                              <typeReferenceExpression type="HttpContext"/>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                        </target>
                        <indices>
                          <variableReferenceExpression name="key"/>
                        </indices>
                      </arrayIndexerExpression>
                    </castExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <variableReferenceExpression name="tm"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="tm"/>
                      <objectCreateExpression type="TransactionManager">
                        <parameters>
                          <argumentReferenceExpression name="transaction"/>
                        </parameters>
                      </objectCreateExpression>
                    </assignStatement>
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
                          <variableReferenceExpression name="key"/>
                        </indices>
                      </arrayIndexerExpression>
                      <variableReferenceExpression name="tm"/>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <propertyReferenceExpression name="Length">
                        <variableReferenceExpression name="transactionInfo"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="2"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <fieldReferenceExpression name="status">
                        <variableReferenceExpression name="tm"/>
                      </fieldReferenceExpression>
                      <arrayIndexerExpression>
                        <target>
                          <variableReferenceExpression name="transactionInfo"/>
                        </target>
                        <indices>
                          <primitiveExpression value="1"/>
                        </indices>
                      </arrayIndexerExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <propertyReferenceExpression name="Status">
                        <variableReferenceExpression name="tm"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="abort"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="Delete">
                      <target>
                        <variableReferenceExpression name="tm"/>
                      </target>
                    </methodInvokeExpression>
                    <methodReturnStatement>
                      <primitiveExpression value="null"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <variableReferenceExpression name="tm"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method RowIsMatched(PageRequest, ViewPage, DataRow) -->
            <memberMethod returnType="System.Boolean" name="RowIsMatched">
              <attributes private="true" static="true"/>
              <parameters>
                <parameter type="PageRequest" name="request"/>
                <parameter type="ViewPage" name="page"/>
                <parameter type="DataRow" name="row" />
              </parameters>
              <statements>
                <foreachStatement>
                  <variable type="System.String" name="f"/>
                  <target>
                    <propertyReferenceExpression name="Filter">
                      <variableReferenceExpression name="request"/>
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
                            <variableReferenceExpression name="f"/>
                            <primitiveExpression value="^(?'FieldName'\w+)\:(?'Operation'=)(?'Value'.+)$"/>
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
                        <variableDeclarationStatement type="System.String" name="fieldName">
                          <init>
                            <propertyReferenceExpression name="Value">
                              <arrayIndexerExpression>
                                <target>
                                  <propertyReferenceExpression name="Groups">
                                    <variableReferenceExpression name="m"/>
                                  </propertyReferenceExpression>
                                </target>
                                <indices>
                                  <primitiveExpression value="FieldName"/>
                                </indices>
                              </arrayIndexerExpression>
                            </propertyReferenceExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <methodInvokeExpression methodName="ContainsField">
                              <target>
                                <argumentReferenceExpression name="page"/>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="fieldName"/>
                              </parameters>
                            </methodInvokeExpression>
                          </condition>
                          <trueStatements>
                            <variableDeclarationStatement type="System.String" name="fieldValue">
                              <init>
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
                              </init>
                            </variableDeclarationStatement>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="ValueEquality">
                                  <variableReferenceExpression name="fieldValue"/>
                                  <primitiveExpression value="null" convertTo="String"/>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="fieldValue"/>
                                  <propertyReferenceExpression name="Empty">
                                    <typeReferenceExpression type="String"/>
                                  </propertyReferenceExpression>
                                </assignStatement>
                              </trueStatements>
                            </conditionStatement>
                            <variableDeclarationStatement type="System.Object" name="fv">
                              <init>
                                <arrayIndexerExpression>
                                  <target>
                                    <argumentReferenceExpression name="row"/>
                                  </target>
                                  <indices>
                                    <variableReferenceExpression name="fieldName"/>
                                  </indices>
                                </arrayIndexerExpression>
                              </init>
                            </variableDeclarationStatement>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="ValueInequality">
                                  <methodInvokeExpression methodName="ToString">
                                    <target>
                                      <typeReferenceExpression type="Convert"/>
                                    </target>
                                    <parameters>
                                      <variableReferenceExpression name="fv"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                  <variableReferenceExpression name="fieldValue"/>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <methodReturnStatement>
                                  <primitiveExpression value="false"/>
                                </methodReturnStatement>
                              </trueStatements>
                            </conditionStatement>
                          </trueStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
                <methodReturnStatement>
                  <primitiveExpression value="true"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method ExecuteReader(PageRequest, ViewPage, DbCommand) -->
            <memberMethod returnType="DbDataReader" name="ExecuteReader">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="PageRequest" name="request"/>
                <parameter type="ViewPage" name="page"/>
                <parameter type="DbCommand" name="command"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="TransactionManager" name="tm">
                  <init>
                    <methodInvokeExpression methodName="Create">
                      <parameters>
                        <propertyReferenceExpression name="Transaction">
                          <argumentReferenceExpression name="request"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <variableReferenceExpression name="tm"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <methodInvokeExpression methodName="ExecuteReader">
                        <target>
                          <argumentReferenceExpression name="command"/>
                        </target>
                      </methodInvokeExpression>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="DataTable" name="t">
                  <init>
                    <methodInvokeExpression methodName="GetTable">
                      <target>
                        <variableReferenceExpression name="tm"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="Controller">
                          <argumentReferenceExpression name="request"/>
                        </propertyReferenceExpression>
                        <argumentReferenceExpression name="command"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Sort">
                    <propertyReferenceExpression name="DefaultView">
                      <variableReferenceExpression name="t"/>
                    </propertyReferenceExpression>
                  </propertyReferenceExpression>
                  <propertyReferenceExpression name="SortExpression">
                    <argumentReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <variableDeclarationStatement type="DataTable" name="t2">
                  <init>
                    <methodInvokeExpression methodName="Clone">
                      <target>
                        <variableReferenceExpression name="t"/>
                      </target>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.Int32" name="rowsToSkip">
                  <init>
                    <binaryOperatorExpression operator="Multiply">
                      <propertyReferenceExpression name="PageIndex">
                        <argumentReferenceExpression name="page"/>
                      </propertyReferenceExpression>
                      <propertyReferenceExpression name="PageSize">
                        <argumentReferenceExpression name="page"/>
                      </propertyReferenceExpression>
                    </binaryOperatorExpression>
                  </init>
                </variableDeclarationStatement>
                <foreachStatement>
                  <variable type="DataRowView" name="r"/>
                  <target>
                    <propertyReferenceExpression name="DefaultView">
                      <variableReferenceExpression name="t"/>
                    </propertyReferenceExpression>
                  </target>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <methodInvokeExpression methodName="RowIsMatched">
                          <parameters>
                            <argumentReferenceExpression name="request"/>
                            <argumentReferenceExpression name="page"/>
                            <propertyReferenceExpression name="Row">
                              <variableReferenceExpression name="r"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </condition>
                      <trueStatements>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="GreaterThan">
                              <variableReferenceExpression name="rowsToSkip"/>
                              <primitiveExpression value="0"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="rowsToSkip"/>
                              <binaryOperatorExpression operator="Add">
                                <variableReferenceExpression name="rowsToSkip"/>
                                <primitiveExpression value="1"/>
                              </binaryOperatorExpression>
                            </assignStatement>
                          </trueStatements>
                          <falseStatements>
                            <variableDeclarationStatement type="DataRow" name="r2">
                              <init>
                                <methodInvokeExpression methodName="NewRow">
                                  <target>
                                    <variableReferenceExpression name="t2"/>
                                  </target>
                                </methodInvokeExpression>
                              </init>
                            </variableDeclarationStatement>
                            <foreachStatement>
                              <variable type="DataColumn" name="c"/>
                              <target>
                                <propertyReferenceExpression name="Columns">
                                  <variableReferenceExpression name="t"/>
                                </propertyReferenceExpression>
                              </target>
                              <statements>
                                <assignStatement>
                                  <arrayIndexerExpression>
                                    <target>
                                      <variableReferenceExpression name="r2"/>
                                    </target>
                                    <indices>
                                      <propertyReferenceExpression name="ColumnName">
                                        <variableReferenceExpression name="c"/>
                                      </propertyReferenceExpression>
                                    </indices>
                                  </arrayIndexerExpression>
                                  <arrayIndexerExpression>
                                    <target>
                                      <variableReferenceExpression name="r"/>
                                    </target>
                                    <indices>
                                      <propertyReferenceExpression name="ColumnName">
                                        <variableReferenceExpression name="c"/>
                                      </propertyReferenceExpression>
                                    </indices>
                                  </arrayIndexerExpression>
                                </assignStatement>
                              </statements>
                            </foreachStatement>
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <propertyReferenceExpression name="Rows">
                                  <variableReferenceExpression name="t2"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="r2"/>
                              </parameters>
                            </methodInvokeExpression>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="ValueEquality">
                                  <propertyReferenceExpression name="Count">
                                    <propertyReferenceExpression name="Rows">
                                      <variableReferenceExpression name="t2"/>
                                    </propertyReferenceExpression>
                                  </propertyReferenceExpression>
                                  <propertyReferenceExpression name="PageSize">
                                    <argumentReferenceExpression name="page"/>
                                  </propertyReferenceExpression>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <breakStatement/>
                              </trueStatements>
                            </conditionStatement>
                          </falseStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
                <conditionStatement>
                  <condition>
                    <propertyReferenceExpression name="RequiresRowCount">
                      <argumentReferenceExpression name="page"/>
                    </propertyReferenceExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="System.Int32" name="totalRowCount">
                      <init>
                        <primitiveExpression value="0"/>
                      </init>
                    </variableDeclarationStatement>
                    <foreachStatement>
                      <variable type="DataRowView" name="r"/>
                      <target>
                        <propertyReferenceExpression name="DefaultView">
                          <variableReferenceExpression name="t"/>
                        </propertyReferenceExpression>
                      </target>
                      <statements>
                        <conditionStatement>
                          <condition>
                            <methodInvokeExpression methodName="RowIsMatched">
                              <parameters>
                                <argumentReferenceExpression name="request"/>
                                <argumentReferenceExpression name="page"/>
                                <propertyReferenceExpression name="Row">
                                  <variableReferenceExpression name="r"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="totalRowCount"/>
                              <binaryOperatorExpression operator="Add">
                                <variableReferenceExpression name="totalRowCount"/>
                                <primitiveExpression value="1"/>
                              </binaryOperatorExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                      </statements>
                    </foreachStatement>
                    <assignStatement>
                      <propertyReferenceExpression name="TotalRowCount">
                        <argumentReferenceExpression name="page"/>
                      </propertyReferenceExpression>
                      <variableReferenceExpression name="totalRowCount"/>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <objectCreateExpression type="DataTableReader">
                    <parameters>
                      <variableReferenceExpression name="t2"/>
                    </parameters>
                  </objectCreateExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- ExecuteNonQuery(ActionArgs, ActionResult, ViewPage, DbCommand) -->
            <memberMethod returnType="System.Int32" name="ExecuteNonQuery">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="ActionArgs" name="args"/>
                <parameter type="ActionResult" name="result"/>
                <parameter type="ViewPage" name="page"/>
                <parameter type="DbCommand" name="command"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="TransactionManager" name="tm">
                  <init>
                    <methodInvokeExpression methodName="Create">
                      <parameters>
                        <propertyReferenceExpression name="Transaction">
                          <argumentReferenceExpression name="args"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <variableReferenceExpression name="tm"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <methodInvokeExpression methodName="ExecuteNonQuery">
                        <target>
                          <variableReferenceExpression name="command"/>
                        </target>
                      </methodInvokeExpression>
                    </methodReturnStatement>
                  </trueStatements>
                  <falseStatements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="ValueEquality">
                          <propertyReferenceExpression name="Status">
                            <variableReferenceExpression name="tm"/>
                          </propertyReferenceExpression>
                          <primitiveExpression value="complete"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodReturnStatement>
                          <methodInvokeExpression methodName="ExecuteNonQuery">
                            <target>
                              <argumentReferenceExpression name="command"/>
                            </target>
                          </methodInvokeExpression>
                        </methodReturnStatement>
                      </trueStatements>
                    </conditionStatement>
                  </falseStatements>
                </conditionStatement>
                <variableDeclarationStatement type="System.Int32" name="rowsAffected">
                  <init>
                    <methodInvokeExpression methodName="ExecuteAction">
                      <target>
                        <variableReferenceExpression name="tm"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="args"/>
                        <argumentReferenceExpression name="result"/>
                        <argumentReferenceExpression name="page"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <propertyReferenceExpression name="Arguments">
                      <variableReferenceExpression name="tm"/>
                    </propertyReferenceExpression>
                  </target>
                  <parameters>
                    <variableReferenceExpression name="args"/>
                  </parameters>
                </methodInvokeExpression>
                <methodReturnStatement>
                  <variableReferenceExpression name="rowsAffected"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method Complete(ActionArgs, ActionResult, ViewPage) -->
            <memberMethod name="Complete">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="ActionArgs" name="args"/>
                <parameter type="ActionResult" name="result"/>
                <parameter type="ViewPage" name="page"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="TransactionManager" name="tm">
                  <init>
                    <methodInvokeExpression methodName="Create">
                      <parameters>
                        <propertyReferenceExpression name="Transaction">
                          <variableReferenceExpression name="args"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <binaryOperatorExpression operator="IdentityInequality">
                        <variableReferenceExpression name="tm"/>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                      <binaryOperatorExpression operator="ValueEquality">
                        <propertyReferenceExpression name="Status">
                          <variableReferenceExpression name="tm"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="complete"/>
                      </binaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="Complete">
                      <target>
                        <variableReferenceExpression name="tm"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="result"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method InTransactoin(ActionArgs) -->
            <memberMethod returnType="System.Boolean" name="InTransaction">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="ActionArgs" name="args"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <binaryOperatorExpression operator="BooleanAnd">
                    <unaryOperatorExpression operator="Not">
                      <methodInvokeExpression methodName="IsNullOrEmpty">
                        <target>
                          <typeReferenceExpression type="String"/>
                        </target>
                        <parameters>
                          <propertyReferenceExpression name="Transaction">
                            <argumentReferenceExpression name="args"/>
                          </propertyReferenceExpression>
                        </parameters>
                      </methodInvokeExpression>
                    </unaryOperatorExpression>
                    <unaryOperatorExpression operator="Not">
                      <methodInvokeExpression methodName="EndsWith">
                        <target>
                          <propertyReferenceExpression name="Transaction">
                            <argumentReferenceExpression name="args"/>
                          </propertyReferenceExpression>
                        </target>
                        <parameters>
                          <primitiveExpression value=":complete"/>
                        </parameters>
                      </methodInvokeExpression>
                    </unaryOperatorExpression>
                  </binaryOperatorExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method Complete(ActionResult) -->
            <memberMethod name="Complete">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="ActionResult" name="result"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="IDataController" name="controller">
                  <init>
                    <methodInvokeExpression methodName="CreateDataController">
                      <target>
                        <typeReferenceExpression type="ControllerFactory"/>
                      </target>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="SortedDictionary" name="keys">
                  <typeArguments>
                    <typeReference type="System.String"/>
                    <typeReference type="System.Object"/>
                  </typeArguments>
                  <init>
                    <objectCreateExpression type="SortedDictionary">
                      <typeArguments>
                        <typeReference type="System.String"/>
                        <typeReference type="System.Object"/>
                      </typeArguments>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <foreachStatement>
                  <variable type="ActionArgs" name="args"/>
                  <target>
                    <propertyReferenceExpression name="Arguments"/>
                  </target>
                  <statements>
                    <assignStatement>
                      <propertyReferenceExpression name="Transaction">
                        <variableReferenceExpression name="args"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="null"/>
                    </assignStatement>
                    <comment>resolve foreign keys</comment>
                    <foreachStatement>
                      <variable type="FieldValue" name="v"/>
                      <target>
                        <propertyReferenceExpression name="Values">
                          <argumentReferenceExpression name="result"/>
                        </propertyReferenceExpression>
                      </target>
                      <statements>
                        <variableDeclarationStatement type="FieldValue" name="v2">
                          <init>
                            <methodInvokeExpression methodName="SelectFieldValueObject">
                              <target>
                                <variableReferenceExpression name="args"/>
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
                            <binaryOperatorExpression operator="IdentityEquality">
                              <variableReferenceExpression name="v2"/>
                              <primitiveExpression value="null"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <variableDeclarationStatement type="List" name="values">
                              <typeArguments>
                                <typeReference type="FieldValue"/>
                              </typeArguments>
                              <init>
                                <objectCreateExpression type="List">
                                  <typeArguments>
                                    <typeReference type="FieldValue"/>
                                  </typeArguments>
                                  <parameters>
                                    <propertyReferenceExpression name="Values">
                                      <variableReferenceExpression name="args"/>
                                    </propertyReferenceExpression>
                                  </parameters>
                                </objectCreateExpression>
                              </init>
                            </variableDeclarationStatement>
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <variableReferenceExpression name="values"/>
                              </target>
                              <parameters>
                                <objectCreateExpression type="FieldValue">
                                  <parameters>
                                    <propertyReferenceExpression name="Name">
                                      <variableReferenceExpression name="v"/>
                                    </propertyReferenceExpression>
                                    <propertyReferenceExpression name="Value">
                                      <variableReferenceExpression name="v"/>
                                    </propertyReferenceExpression>
                                  </parameters>
                                </objectCreateExpression>
                              </parameters>
                            </methodInvokeExpression>
                            <assignStatement>
                              <propertyReferenceExpression name="Values">
                                <variableReferenceExpression name="args"/>
                              </propertyReferenceExpression>
                              <methodInvokeExpression methodName="ToArray">
                                <target>
                                  <variableReferenceExpression name="values"/>
                                </target>
                              </methodInvokeExpression>
                            </assignStatement>
                          </trueStatements>
                          <falseStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="NewValue">
                                <variableReferenceExpression name="v2"/>
                              </propertyReferenceExpression>
                              <propertyReferenceExpression name="Value">
                                <variableReferenceExpression name="v"/>
                              </propertyReferenceExpression>
                            </assignStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="Modified">
                                <variableReferenceExpression name="v2"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="true"/>
                            </assignStatement>
                          </falseStatements>
                        </conditionStatement>
                      </statements>
                    </foreachStatement>
                    <comment>resolve virtual primary keys</comment>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanOr">
                          <binaryOperatorExpression operator="ValueEquality">
                            <propertyReferenceExpression name="CommandName">
                              <variableReferenceExpression name="args"/>
                            </propertyReferenceExpression>
                            <primitiveExpression value="Update"/>
                          </binaryOperatorExpression>
                          <binaryOperatorExpression operator="ValueEquality">
                            <propertyReferenceExpression name="CommandName">
                              <variableReferenceExpression name="args"/>
                            </propertyReferenceExpression>
                            <primitiveExpression value="Delete"/>
                          </binaryOperatorExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <foreachStatement>
                          <variable type="FieldValue" name="v"/>
                          <target>
                            <propertyReferenceExpression name="Values">
                              <variableReferenceExpression name="args"/>
                            </propertyReferenceExpression>
                          </target>
                          <statements>
                            <variableDeclarationStatement type="System.Object" name="key">
                              <init>
                                <primitiveExpression value="null"/>
                              </init>
                            </variableDeclarationStatement>
                            <conditionStatement>
                              <condition>
                                <methodInvokeExpression methodName="TryGetValue">
                                  <target>
                                    <variableReferenceExpression name="keys"/>
                                  </target>
                                  <parameters>
                                    <methodInvokeExpression methodName="Format">
                                      <target>
                                        <typeReferenceExpression type="String"/>
                                      </target>
                                      <parameters>
                                        <primitiveExpression value="{{0}}:{{1}}:{{2}}"/>
                                        <propertyReferenceExpression name="Controller">
                                          <variableReferenceExpression name="args"/>
                                        </propertyReferenceExpression>
                                        <propertyReferenceExpression name="Name">
                                          <variableReferenceExpression name="v"/>
                                        </propertyReferenceExpression>
                                        <propertyReferenceExpression name="Value">
                                          <variableReferenceExpression name="v"/>
                                        </propertyReferenceExpression>
                                      </parameters>
                                    </methodInvokeExpression>
                                    <directionExpression direction="Out">
                                      <variableReferenceExpression name="key"/>
                                    </directionExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <propertyReferenceExpression name="OldValue">
                                    <variableReferenceExpression name="v"/>
                                  </propertyReferenceExpression>
                                  <variableReferenceExpression name="key"/>
                                </assignStatement>
                              </trueStatements>
                            </conditionStatement>
                          </statements>
                        </foreachStatement>
                      </trueStatements>
                    </conditionStatement>
                    <comment>execute an actual update and raise exception if errors detected</comment>
                    <variableDeclarationStatement type="SortedDictionary" name="argValues">
                      <typeArguments>
                        <typeReference type="System.String"/>
                        <typeReference type="System.Object"/>
                      </typeArguments>
                      <init>
                        <objectCreateExpression type="SortedDictionary">
                          <typeArguments>
                            <typeReference type="System.String"/>
                            <typeReference type="System.Object"/>
                          </typeArguments>
                        </objectCreateExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="ValueEquality">
                          <propertyReferenceExpression name="CommandName">
                            <variableReferenceExpression name="args"/>
                          </propertyReferenceExpression>
                          <primitiveExpression value="Insert"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <foreachStatement>
                          <variable type="FieldValue" name="v"/>
                          <target>
                            <propertyReferenceExpression name="Values">
                              <variableReferenceExpression name="args"/>
                            </propertyReferenceExpression>
                          </target>
                          <statements>
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <variableReferenceExpression name="argValues"/>
                              </target>
                              <parameters>
                                <propertyReferenceExpression name="Name">
                                  <variableReferenceExpression name="v"/>
                                </propertyReferenceExpression>
                                <propertyReferenceExpression name="Value">
                                  <variableReferenceExpression name="v"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </statements>
                        </foreachStatement>
                      </trueStatements>
                    </conditionStatement>
                    <variableDeclarationStatement type="ActionResult" name="r">
                      <init>
                        <methodInvokeExpression methodName="Execute">
                          <target>
                            <variableReferenceExpression name="controller"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="Controller">
                              <variableReferenceExpression name="args"/>
                            </propertyReferenceExpression>
                            <propertyReferenceExpression name="View">
                              <variableReferenceExpression name="args"/>
                            </propertyReferenceExpression>
                            <variableReferenceExpression name="args"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <methodInvokeExpression methodName="RaiseExceptionIfErrors">
                      <target>
                        <variableReferenceExpression name="r"/>
                      </target>
                    </methodInvokeExpression>
                    <comment>register physical primary keys</comment>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="ValueEquality">
                          <propertyReferenceExpression name="CommandName">
                            <variableReferenceExpression name="args"/>
                          </propertyReferenceExpression>
                          <primitiveExpression value="Insert"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <foreachStatement>
                          <variable type="FieldValue" name="v"/>
                          <target>
                            <propertyReferenceExpression name="Values">
                              <variableReferenceExpression name="r"/>
                            </propertyReferenceExpression>
                          </target>
                          <statements>
                            <conditionStatement>
                              <condition>
                                <methodInvokeExpression methodName="ContainsKey">
                                  <target>
                                    <variableReferenceExpression name="argValues"/>
                                  </target>
                                  <parameters>
                                    <propertyReferenceExpression name="Name">
                                      <variableReferenceExpression name="v"/>
                                    </propertyReferenceExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </condition>
                              <trueStatements>
                                <methodInvokeExpression methodName="Add">
                                  <target>
                                    <variableReferenceExpression name="keys"/>
                                  </target>
                                  <parameters>
                                    <methodInvokeExpression methodName="Format">
                                      <target>
                                        <typeReferenceExpression type="String"/>
                                      </target>
                                      <parameters>
                                        <primitiveExpression value="{{0}}:{{1}}:{{2}}"/>
                                        <propertyReferenceExpression name="Controller">
                                          <variableReferenceExpression name="args"/>
                                        </propertyReferenceExpression>
                                        <propertyReferenceExpression name="Name">
                                          <variableReferenceExpression name="v"/>
                                        </propertyReferenceExpression>
                                        <arrayIndexerExpression>
                                          <target>
                                            <variableReferenceExpression name="argValues"/>
                                          </target>
                                          <indices>
                                            <propertyReferenceExpression name="Name">
                                              <variableReferenceExpression name="v"/>
                                            </propertyReferenceExpression>
                                          </indices>
                                        </arrayIndexerExpression>
                                      </parameters>
                                    </methodInvokeExpression>
                                    <propertyReferenceExpression name="NewValue">
                                      <variableReferenceExpression name="v"/>
                                    </propertyReferenceExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </trueStatements>
                            </conditionStatement>
                          </statements>
                        </foreachStatement>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
              </statements>
            </memberMethod>
            <!-- method ExecuteAction(ActionArgs, ActionResult, ViewPage) -->
            <memberMethod returnType="System.Int32" name="ExecuteAction">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="ActionArgs" name="args"/>
                <parameter type="ActionResult" name="result"/>
                <parameter type="ViewPage" name="page"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="DataTable" name="t">
                  <init>
                    <methodInvokeExpression methodName="GetTable">
                      <parameters>
                        <propertyReferenceExpression name="Controller">
                          <variableReferenceExpression name="args"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="null"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <propertyReferenceExpression name="CommandName">
                        <argumentReferenceExpression name="args"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="Insert"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="DataRow" name="r">
                      <init>
                        <methodInvokeExpression methodName="NewRow">
                          <target>
                            <variableReferenceExpression name="t"/>
                          </target>
                        </methodInvokeExpression>
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
                        <variableDeclarationStatement type="DataField" name="f">
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
                              <propertyReferenceExpression name="IsPrimaryKey">
                                <variableReferenceExpression name="f"/>
                              </propertyReferenceExpression>
                              <propertyReferenceExpression name="ReadOnly">
                                <variableReferenceExpression name="f"/>
                              </propertyReferenceExpression>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <variableDeclarationStatement type="System.Object" name="key">
                              <init>
                                <primitiveExpression value="null"/>
                              </init>
                            </variableDeclarationStatement>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="ValueEquality">
                                  <propertyReferenceExpression name="Type">
                                    <variableReferenceExpression name="f"/>
                                  </propertyReferenceExpression>
                                  <primitiveExpression value="Guid"/>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="key"/>
                                  <methodInvokeExpression methodName="NewGuid">
                                    <target>
                                      <typeReferenceExpression type="Guid"/>
                                    </target>
                                  </methodInvokeExpression>
                                </assignStatement>
                              </trueStatements>
                              <falseStatements>
                                <conditionStatement>
                                  <condition>
                                    <unaryOperatorExpression operator="Not">
                                      <methodInvokeExpression methodName="TryGetValue">
                                        <target>
                                          <propertyReferenceExpression name="PrimaryKeys"/>
                                        </target>
                                        <parameters>
                                          <propertyReferenceExpression name="Controller">
                                            <argumentReferenceExpression name="args"/>
                                          </propertyReferenceExpression>
                                          <directionExpression direction="Out">
                                            <variableReferenceExpression name="key"/>
                                          </directionExpression>
                                        </parameters>
                                      </methodInvokeExpression>
                                    </unaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <assignStatement>
                                      <variableReferenceExpression name="key"/>
                                      <primitiveExpression value="-1"/>
                                    </assignStatement>
                                    <methodInvokeExpression methodName="Add">
                                      <target>
                                        <variableReferenceExpression name="PrimaryKeys"/>
                                      </target>
                                      <parameters>
                                        <propertyReferenceExpression name="Controller">
                                          <variableReferenceExpression name="args"/>
                                        </propertyReferenceExpression>
                                        <variableReferenceExpression name="key"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </trueStatements>
                                  <falseStatements>
                                    <assignStatement>
                                      <variableReferenceExpression name="key"/>
                                      <binaryOperatorExpression operator="Subtract">
                                        <methodInvokeExpression methodName="ToInt32">
                                          <target>
                                            <typeReferenceExpression type="Convert"/>
                                          </target>
                                          <parameters>
                                            <variableReferenceExpression name="key"/>
                                          </parameters>
                                        </methodInvokeExpression>
                                        <primitiveExpression value="1"/>
                                      </binaryOperatorExpression>
                                    </assignStatement>
                                    <assignStatement>
                                      <arrayIndexerExpression>
                                        <target>
                                          <propertyReferenceExpression name="PrimaryKeys"/>
                                        </target>
                                        <indices>
                                          <propertyReferenceExpression name="Controller">
                                            <variableReferenceExpression name="args"/>
                                          </propertyReferenceExpression>
                                        </indices>
                                      </arrayIndexerExpression>
                                      <variableReferenceExpression name="key"/>
                                    </assignStatement>
                                  </falseStatements>
                                </conditionStatement>
                              </falseStatements>
                            </conditionStatement>
                            <assignStatement>
                              <arrayIndexerExpression>
                                <target>
                                  <variableReferenceExpression name="r"/>
                                </target>
                                <indices>
                                  <propertyReferenceExpression name="Name">
                                    <variableReferenceExpression name="v"/>
                                  </propertyReferenceExpression>
                                </indices>
                              </arrayIndexerExpression>
                              <variableReferenceExpression name="key"/>
                            </assignStatement>
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
                                      <variableReferenceExpression name="v"/>
                                    </propertyReferenceExpression>
                                    <variableReferenceExpression name="key"/>
                                  </parameters>
                                </objectCreateExpression>
                              </parameters>
                            </methodInvokeExpression>
                            <variableDeclarationStatement type="FieldValue" name="fv">
                              <init>
                                <methodInvokeExpression methodName="SelectFieldValueObject">
                                  <target>
                                    <argumentReferenceExpression name="args"/>
                                  </target>
                                  <parameters>
                                    <propertyReferenceExpression name="Name">
                                      <variableReferenceExpression name="v"/>
                                    </propertyReferenceExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </init>
                            </variableDeclarationStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="NewValue">
                                <variableReferenceExpression name="fv"/>
                              </propertyReferenceExpression>
                              <variableReferenceExpression name="key"/>
                            </assignStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="Modified">
                                <variableReferenceExpression name="fv"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="true"/>
                            </assignStatement>
                          </trueStatements>
                          <falseStatements>
                            <conditionStatement>
                              <condition>
                                <propertyReferenceExpression name="Modified">
                                  <variableReferenceExpression name="v"/>
                                </propertyReferenceExpression>
                              </condition>
                              <trueStatements>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="IdentityEquality">
                                      <propertyReferenceExpression name="NewValue">
                                        <variableReferenceExpression name="v"/>
                                      </propertyReferenceExpression>
                                      <primitiveExpression value="null"/>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <assignStatement>
                                      <arrayIndexerExpression>
                                        <target>
                                          <variableReferenceExpression name="r"/>
                                        </target>
                                        <indices>
                                          <propertyReferenceExpression name="Name">
                                            <variableReferenceExpression name="v"/>
                                          </propertyReferenceExpression>
                                        </indices>
                                      </arrayIndexerExpression>
                                      <propertyReferenceExpression name="Value">
                                        <typeReferenceExpression type="DBNull"/>
                                      </propertyReferenceExpression>
                                    </assignStatement>
                                  </trueStatements>
                                  <falseStatements>
                                    <assignStatement>
                                      <arrayIndexerExpression>
                                        <target>
                                          <variableReferenceExpression name="r"/>
                                        </target>
                                        <indices>
                                          <propertyReferenceExpression name="Name">
                                            <variableReferenceExpression name="v"/>
                                          </propertyReferenceExpression>
                                        </indices>
                                      </arrayIndexerExpression>
                                      <propertyReferenceExpression name="NewValue">
                                        <variableReferenceExpression name="v"/>
                                      </propertyReferenceExpression>
                                    </assignStatement>
                                  </falseStatements>
                                </conditionStatement>
                              </trueStatements>
                            </conditionStatement>
                          </falseStatements>
                        </conditionStatement>
                      </statements>
                    </foreachStatement>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <propertyReferenceExpression name="Rows">
                          <variableReferenceExpression name="t"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="r"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodReturnStatement>
                      <primitiveExpression value="1"/>
                    </methodReturnStatement>
                  </trueStatements>
                  <falseStatements>
                    <variableDeclarationStatement type="DataRow" name="targetRow">
                      <init>
                        <primitiveExpression value="null"/>
                      </init>
                    </variableDeclarationStatement>
                    <foreachStatement>
                      <variable type="DataRow" name="r"/>
                      <target>
                        <propertyReferenceExpression name="Rows">
                          <variableReferenceExpression name="t"/>
                        </propertyReferenceExpression>
                      </target>
                      <statements>
                        <variableDeclarationStatement type="System.Boolean" name="matched">
                          <init>
                            <primitiveExpression value="true"/>
                          </init>
                        </variableDeclarationStatement>
                        <foreachStatement>
                          <variable type="DataField" name="f"/>
                          <target>
                            <propertyReferenceExpression name="Fields">
                              <variableReferenceExpression name="page"/>
                            </propertyReferenceExpression>
                          </target>
                          <statements>
                            <conditionStatement>
                              <condition>
                                <propertyReferenceExpression name="IsPrimaryKey">
                                  <variableReferenceExpression name="f"/>
                                </propertyReferenceExpression>
                              </condition>
                              <trueStatements>
                                <variableDeclarationStatement type="System.Object" name="kv">
                                  <init>
                                    <arrayIndexerExpression>
                                      <target>
                                        <variableReferenceExpression name="r"/>
                                      </target>
                                      <indices>
                                        <propertyReferenceExpression name="Name">
                                          <variableReferenceExpression name="f"/>
                                        </propertyReferenceExpression>
                                      </indices>
                                    </arrayIndexerExpression>
                                  </init>
                                </variableDeclarationStatement>
                                <variableDeclarationStatement type="System.Object" name="kv2">
                                  <init>
                                    <propertyReferenceExpression name="OldValue">
                                      <methodInvokeExpression methodName="SelectFieldValueObject">
                                        <target>
                                          <argumentReferenceExpression name="args"/>
                                        </target>
                                        <parameters>
                                          <propertyReferenceExpression name="Name">
                                            <variableReferenceExpression name="f"/>
                                          </propertyReferenceExpression>
                                        </parameters>
                                      </methodInvokeExpression>
                                    </propertyReferenceExpression>
                                  </init>
                                </variableDeclarationStatement>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="BooleanOr">
                                      <binaryOperatorExpression operator="BooleanOr">
                                        <binaryOperatorExpression operator="IdentityEquality">
                                          <variableReferenceExpression name="kv"/>
                                          <primitiveExpression value="null"/>
                                        </binaryOperatorExpression>
                                        <binaryOperatorExpression operator="IdentityEquality">
                                          <variableReferenceExpression name="kv2"/>
                                          <primitiveExpression value="null"/>
                                        </binaryOperatorExpression>
                                      </binaryOperatorExpression>
                                      <binaryOperatorExpression operator="ValueInequality">
                                        <methodInvokeExpression methodName="ToString">
                                          <target>
                                            <variableReferenceExpression name="kv"/>
                                          </target>
                                        </methodInvokeExpression>
                                        <methodInvokeExpression methodName="ToString">
                                          <target>
                                            <variableReferenceExpression name="kv2"/>
                                          </target>
                                        </methodInvokeExpression>
                                      </binaryOperatorExpression>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <assignStatement>
                                      <variableReferenceExpression name="matched"/>
                                      <primitiveExpression value="false"/>
                                    </assignStatement>
                                    <breakStatement/>
                                  </trueStatements>
                                </conditionStatement>
                              </trueStatements>
                            </conditionStatement>
                          </statements>
                        </foreachStatement>
                        <conditionStatement>
                          <condition>
                            <variableReferenceExpression name="matched"/>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="targetRow"/>
                              <variableReferenceExpression name="r"/>
                            </assignStatement>
                            <breakStatement/>
                          </trueStatements>
                        </conditionStatement>
                      </statements>
                    </foreachStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityEquality">
                          <variableReferenceExpression name="targetRow"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodReturnStatement>
                          <primitiveExpression value="0"/>
                        </methodReturnStatement>
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
                        <methodInvokeExpression methodName="Remove">
                          <target>
                            <propertyReferenceExpression name="Rows">
                              <variableReferenceExpression name="t"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="targetRow"/>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                      <falseStatements>
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
                                <propertyReferenceExpression name="Modified">
                                  <variableReferenceExpression name="v"/>
                                </propertyReferenceExpression>
                              </condition>
                              <trueStatements>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="IdentityEquality">
                                      <propertyReferenceExpression name="NewValue">
                                        <variableReferenceExpression name="v"/>
                                      </propertyReferenceExpression>
                                      <primitiveExpression value="null"/>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <assignStatement>
                                      <arrayIndexerExpression>
                                        <target>
                                          <variableReferenceExpression name="targetRow"/>
                                        </target>
                                        <indices>
                                          <propertyReferenceExpression name="Name">
                                            <variableReferenceExpression name="v"/>
                                          </propertyReferenceExpression>
                                        </indices>
                                      </arrayIndexerExpression>
                                      <propertyReferenceExpression name="Value">
                                        <typeReferenceExpression type="DBNull"/>
                                      </propertyReferenceExpression>
                                    </assignStatement>
                                  </trueStatements>
                                  <falseStatements>
                                    <assignStatement>
                                      <arrayIndexerExpression>
                                        <target>
                                          <variableReferenceExpression name="targetRow"/>
                                        </target>
                                        <indices>
                                          <propertyReferenceExpression name="Name">
                                            <variableReferenceExpression name="v"/>
                                          </propertyReferenceExpression>
                                        </indices>
                                      </arrayIndexerExpression>
                                      <propertyReferenceExpression name="NewValue">
                                        <variableReferenceExpression name="v"/>
                                      </propertyReferenceExpression>
                                    </assignStatement>
                                  </falseStatements>
                                </conditionStatement>
                              </trueStatements>
                            </conditionStatement>
                          </statements>
                        </foreachStatement>
                      </falseStatements>
                    </conditionStatement>
                    <methodReturnStatement>
                      <primitiveExpression value="1"/>
                    </methodReturnStatement>
                  </falseStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method ExecuteNonQuery(DbCommand) -->
            <memberMethod returnType="System.Int32" name="ExecuteNonQuery">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="DbCommand" name="command"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.Int32" name="rowsAffected">
                  <init>
                    <methodInvokeExpression methodName="ExecuteNonQuery">
                      <target>
                        <argumentReferenceExpression name="command"/>
                      </target>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <foreachStatement>
                  <variable type="DbParameter" name="p"/>
                  <target>
                    <propertyReferenceExpression name="Parameters">
                      <argumentReferenceExpression name="command"/>
                    </propertyReferenceExpression>
                  </target>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="ValueEquality">
                          <propertyReferenceExpression name="Direction">
                            <variableReferenceExpression name="p"/>
                          </propertyReferenceExpression>
                          <propertyReferenceExpression name="ReturnValue">
                            <typeReferenceExpression type="ParameterDirection"/>
                          </propertyReferenceExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="TryParse">
                          <target>
                            <typeReferenceExpression type="System.Int32"/>
                          </target>
                          <parameters>
                            <methodInvokeExpression methodName="ToString">
                              <target>
                                <typeReferenceExpression type="Convert"/>
                              </target>
                              <parameters>
                                <propertyReferenceExpression name="Value">
                                  <variableReferenceExpression name="p"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                            <directionExpression direction="Out">
                              <variableReferenceExpression name="rowsAffected"/>
                            </directionExpression>
                          </parameters>
                        </methodInvokeExpression>
                        <breakStatement/>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <variableReferenceExpression name="rowsAffected"/>
                      <primitiveExpression value="-1"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="rowsAffected"/>
                      <primitiveExpression value="1"/>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <variableReferenceExpression name="rowsAffected"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
        <!-- class SinglePhaseTransactionScope -->
        <typeDeclaration name="SinglePhaseTransactionScope">
          <baseTypes>
            <typeReference type="System.Object"/>
            <typeReference type="IDisposable"/>
          </baseTypes>
          <members>
            <!-- property Current -->
            <memberProperty type="SinglePhaseTransactionScope" name="Current">
              <attributes public="true" final="true" static="true"/>
              <getStatements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <propertyReferenceExpression name="Current">
                        <typeReferenceExpression type="HttpContext"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="null"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <castExpression targetType="SinglePhaseTransactionScope">
                    <arrayIndexerExpression>
                      <target>
                        <propertyReferenceExpression name="Items">
                          <propertyReferenceExpression name="Current">
                            <typeReferenceExpression type="HttpContext"/>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                      </target>
                      <indices>
                        <primitiveExpression value="SinglePhaseTransactionScope_Current"/>
                      </indices>
                    </arrayIndexerExpression>
                  </castExpression>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property SortedDictionary<string, DbConnection> Connections -->
            <memberField type="SortedDictionary" name="_connections">
              <typeArguments>
                <typeReference type="System.String"/>
                <typeReference type="DbConnection"/>
              </typeArguments>
            </memberField>
            <memberProperty type="SortedDictionary" name="Connections">
              <typeArguments>
                <typeReference type="System.String"/>
                <typeReference type="DbConnection"/>
              </typeArguments>
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="connections"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property DbTransaction Transaction -->
            <memberField type="DbTransaction" name="transaction"/>
            <memberProperty type="DbTransaction" name="Transaction">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="transaction"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property IsRoot -->
            <memberField type="System.Boolean" name="isRoot"/>
            <memberProperty type="System.Boolean" name="IsRoot">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="isRoot"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- constructor -->
            <constructor>
              <attributes public="true"/>
              <statements>
                <assignStatement>
                  <fieldReferenceExpression name="connections"/>
                  <objectCreateExpression type="SortedDictionary">
                    <typeArguments>
                      <typeReference type="System.String"/>
                      <typeReference type="DbConnection"/>
                    </typeArguments>
                  </objectCreateExpression>
                </assignStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <propertyReferenceExpression name="Current"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <fieldReferenceExpression name="isRoot"/>
                      <primitiveExpression value="true"/>
                    </assignStatement>
                    <assignStatement>
                      <arrayIndexerExpression>
                        <target>
                          <propertyReferenceExpression name="Items">
                            <propertyReferenceExpression name="Current">
                              <typeReferenceExpression type="HttpContext"/>>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                        </target>
                        <indices>
                          <primitiveExpression value="SinglePhaseTransactionScope_Current"/>
                        </indices>
                      </arrayIndexerExpression>
                      <thisReferenceExpression/>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
              </statements>
            </constructor>
            <!-- method Enlist(DbCommand) -->
            <memberMethod name="Enlist">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="DbCommand" name="command"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="DbConnection" name="connection">
                  <init>
                    <primitiveExpression value="null"/>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="Not">
                      <methodInvokeExpression methodName="TryGetValue">
                        <target>
                          <propertyReferenceExpression name="Connections">
                            <propertyReferenceExpression name="Current"/>
                          </propertyReferenceExpression>
                        </target>
                        <parameters>
                          <propertyReferenceExpression name="ConnectionString">
                            <propertyReferenceExpression name="Connection">
                              <argumentReferenceExpression name="command"/>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                          <directionExpression direction="Out">
                            <variableReferenceExpression name="connection"/>
                          </directionExpression>
                        </parameters>
                      </methodInvokeExpression>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="connection"/>
                      <propertyReferenceExpression name="Connection">
                        <argumentReferenceExpression name="command"/>
                      </propertyReferenceExpression>
                    </assignStatement>
                    <assignStatement>
                      <fieldReferenceExpression name="transaction"/>
                      <methodInvokeExpression methodName="BeginTransaction">
                        <target>
                          <variableReferenceExpression name="connection"/>
                        </target>
                      </methodInvokeExpression>
                    </assignStatement>
                    <assignStatement>
                      <propertyReferenceExpression name="Transaction">
                        <argumentReferenceExpression name="command"/>
                      </propertyReferenceExpression>
                      <fieldReferenceExpression name="transaction"/>
                    </assignStatement>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <propertyReferenceExpression name="Connections">
                          <propertyReferenceExpression name="Current"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="ConnectionString">
                          <propertyReferenceExpression name="Connection">
                            <argumentReferenceExpression name="command"/>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                        <variableReferenceExpression name="connection"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                  <falseStatements>
                    <assignStatement>
                      <propertyReferenceExpression name="Connection">
                        <argumentReferenceExpression name="command"/>
                      </propertyReferenceExpression>
                      <variableReferenceExpression name="connection"/>
                    </assignStatement>
                    <assignStatement>
                      <propertyReferenceExpression name="Transaction">
                        <argumentReferenceExpression name="command"/>
                      </propertyReferenceExpression>
                      <propertyReferenceExpression name="Transaction">
                        <propertyReferenceExpression name="Current"/>
                      </propertyReferenceExpression>
                    </assignStatement>
                  </falseStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method Enlist(DbConnection) -->
            <memberMethod name="Enlist">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="DbConnection" name="connection"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="Not">
                      <methodInvokeExpression methodName="ContainsKey">
                        <target>
                          <propertyReferenceExpression name="Connections">
                            <propertyReferenceExpression name="Current"/>
                          </propertyReferenceExpression>
                        </target>
                        <parameters>
                          <propertyReferenceExpression name="ConnectionString">
                            <argumentReferenceExpression name="connection"/>
                          </propertyReferenceExpression>
                        </parameters>
                      </methodInvokeExpression>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <fieldReferenceExpression name="transaction"/>
                      <methodInvokeExpression methodName="BeginTransaction">
                        <target>
                          <argumentReferenceExpression name="connection"/>
                        </target>
                      </methodInvokeExpression>
                    </assignStatement>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <propertyReferenceExpression name="Connections">
                          <propertyReferenceExpression name="Current"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="ConnectionString">
                          <argumentReferenceExpression name="connection"/>
                        </propertyReferenceExpression>
                        <argumentReferenceExpression name="connection"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method Complete() -->
            <memberMethod name="Complete">
              <attributes public="true" final="true"/>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <fieldReferenceExpression name="isRoot"/>
                      <binaryOperatorExpression operator="IdentityInequality">
                        <fieldReferenceExpression name="transaction"/>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="Commit">
                      <target>
                        <fieldReferenceExpression name="transaction"/>
                      </target>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method Rollback -->
            <memberMethod name="Rollback">
              <attributes public="true" final="true"/>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <fieldReferenceExpression name="isRoot"/>
                      <binaryOperatorExpression operator="IdentityInequality">
                        <fieldReferenceExpression name="transaction"/>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="Rollback">
                      <target>
                        <fieldReferenceExpression name="_transaction"/>
                      </target>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method IDisposable.Dispose() -->
            <memberMethod name="Dispose" privateImplementationType="IDisposable">
              <attributes/>
              <statements>
                <methodInvokeExpression methodName="Clear">
                  <target>
                    <fieldReferenceExpression name="connections"/>
                  </target>
                </methodInvokeExpression>
                <conditionStatement>
                  <condition>
                    <fieldReferenceExpression name="isRoot"/>
                  </condition>
                  <trueStatements>
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
                          <primitiveExpression value="SinglePhaseTransactionScope_Current"/>
                        </indices>
                      </arrayIndexerExpression>
                      <primitiveExpression value="null"/>
                    </assignStatement>
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
