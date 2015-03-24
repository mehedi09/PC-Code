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
        <namespaceImport name="System.Xml"/>
        <namespaceImport name="System.Xml.XPath"/>
        <namespaceImport name="System.Web"/>
        <namespaceImport name="System.Web.Caching"/>
        <namespaceImport name="System.Web.Configuration"/>
        <namespaceImport name="System.Web.Security"/>
        <namespaceImport name="System.Globalization"/>
      </imports>
      <types>
        <!-- class ViewPage -->
        <typeDeclaration name="ViewPage">
          <members>
            <memberField type="System.Int32" name="skipCount"/>
            <memberField type="System.Int32" name="readCount"/>
            <memberField type="System.String[]" name="originalFilter"/>
            <!-- property Tag -->
            <memberProperty type="System.String" name="Tag">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property RequiresMetaData -->
            <memberField type="System.Boolean" name="requiresMetaData"/>
            <memberProperty type="System.Boolean" name="RequiresMetaData">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="requiresMetaData"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property RequiresPivot-->
            <memberProperty type="System.Boolean" name="RequiresPivot">
              <attributes public="true"/>
            </memberProperty>
            <!-- field pivots-->
            <memberField type="Dictionary" name="pivots">
              <typeArguments>
                <typeReference type="System.Int32"/>
                <typeReference type="PivotTable"/>
              </typeArguments>
              <attributes private="true"/>
              <init>
                <objectCreateExpression type="Dictionary">
                  <typeArguments>
                    <typeReference type="System.Int32"/>
                    <typeReference type="PivotTable"/>
                  </typeArguments>
                </objectCreateExpression>
              </init>
            </memberField>
            <!-- property Pivots-->
            <memberProperty type="PivotTable[]" name="Pivots">
              <attributes public="true"/>
              <getStatements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="ToArray">
                    <target>
                      <propertyReferenceExpression name="Values">
                        <fieldReferenceExpression name="pivots"/>
                      </propertyReferenceExpression>
                    </target>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property requiresRowCount -->
            <memberField type="System.Boolean" name="requiresRowCount"/>
            <memberProperty type="System.Boolean" name="RequiresRowCount">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="requiresRowCount"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property RequiresAggregates -->
            <memberProperty type="System.Boolean" name="RequiresAggregates">
              <attributes public="true" final="true"/>
              <getStatements>
                <foreachStatement>
                  <variable type="DataField" name="field"/>
                  <target>
                    <propertyReferenceExpression name="Fields"/>
                  </target>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="ValueInequality">
                          <propertyReferenceExpression name="Aggregate">
                            <variableReferenceExpression name="field"/>
                          </propertyReferenceExpression>
                          <propertyReferenceExpression name="None">
                            <typeReferenceExpression type="DataFieldAggregate"/>
                          </propertyReferenceExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodReturnStatement>
                          <primitiveExpression value="true"/>
                        </methodReturnStatement>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
                <methodReturnStatement>
                  <primitiveExpression value="false"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property Aggregates -->
            <memberField type="System.Object[]" name="aggregates"/>
            <memberProperty type="System.Object[]" name="Aggregates">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="aggregates"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="aggregates"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property NewRow -->
            <memberField type="System.Object[]" name="newRow"/>
            <memberProperty type="System.Object[]" name="NewRow">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="newRow"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="newRow"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- propert Fields -->
            <memberField type="List" name="fields">
              <typeArguments>
                <typeReference type="DataField"/>
              </typeArguments>
            </memberField>
            <memberProperty type="List" name="Fields">
              <typeArguments>
                <typeReference type="DataField"/>
              </typeArguments>
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="fields"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property SortExpression -->
            <memberField type="System.String" name="sortExpression"/>
            <memberProperty type="System.String" name="SortExpression">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="sortExpression"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="sortExpression"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property TotalRowCount -->
            <memberField type="System.Int32" name="totalRowCount"/>
            <memberProperty type="System.Int32" name="TotalRowCount">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="totalRowCount"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="totalRowCount"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
                <variableDeclarationStatement type="System.Int32" name="pageCount">
                  <init>
                    <binaryOperatorExpression operator="Divide">
                      <propertySetValueReferenceExpression/>
                      <propertyReferenceExpression name="PageSize">
                        <thisReferenceExpression/>
                      </propertyReferenceExpression>
                    </binaryOperatorExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="GreaterThan">
                      <binaryOperatorExpression operator="Modulus">
                        <propertySetValueReferenceExpression/>
                        <propertyReferenceExpression name="PageSize">
                          <thisReferenceExpression/>
                        </propertyReferenceExpression>
                      </binaryOperatorExpression>
                      <primitiveExpression value="0"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <incrementStatement>
                      <variableReferenceExpression name="pageCount"/>
                    </incrementStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="LessThanOrEqual">
                      <variableReferenceExpression name="pageCount"/>
                      <propertyReferenceExpression name="PageIndex"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <fieldReferenceExpression name="pageIndex">
                        <thisReferenceExpression/>
                      </fieldReferenceExpression>
                      <primitiveExpression value="0"/>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
              </setStatements>
            </memberProperty>
            <!-- property PageIndex -->
            <memberProperty type="System.Int32" name="PageIndex">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property PageSize -->
            <memberField type="System.Int32" name="pageSize"/>
            <memberProperty type="System.Int32" name="PageSize">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="pageSize"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property PageOffset -->
            <memberField type="System.Int32" name="pageOffset"/>
            <memberProperty type="System.Int32" name="PageOffset">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="pageOffset"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="pageOffset"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property ClientScript -->
            <memberProperty type="System.String" name="ClientScript">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property FirstLetters -->
            <memberProperty type="System.String" name="FirstLetters">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property Filter -->
            <memberProperty type="System.String[]" name="Filter">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property SystemFilter-->
            <memberProperty type="System.String[]" name="SystemFilter">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- method ChangeFilter(string[]) -->
            <memberMethod name="ChangeFilter">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="System.String[]" name="filter"/>
              </parameters>
              <statements>
                <assignStatement>
                  <fieldReferenceExpression name="filter"/>
                  <argumentReferenceExpression name="filter"/>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="originalFilter"/>
                  <primitiveExpression value="null"/>
                </assignStatement>
              </statements>
            </memberMethod>
            <!-- property Rows -->
            <memberField type="List" name="rows">
              <typeArguments>
                <typeReference type="System.Object[]"/>
              </typeArguments>
            </memberField>
            <memberProperty type="List" name="Rows">
              <typeArguments>
                <typeReference type="System.Object[]"/>
              </typeArguments>
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="rows"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property DistinctValueFieldName -->
            <memberField type="System.String" name="distinctValueFieldName"/>
            <memberProperty type="System.String" name="DistinctValueFieldName">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="distinctValueFieldName"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property Views -->
            <memberField type="List" name="views">
              <typeArguments>
                <typeReference type="View"/>
              </typeArguments>
            </memberField>
            <memberProperty type="List" name="Views">
              <typeArguments>
                <typeReference type="View"/>
              </typeArguments>
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="views"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property ActionGroups -->
            <memberField type="List" name="actionGroups">
              <typeArguments>
                <typeReference type="ActionGroup"/>
              </typeArguments>
            </memberField>
            <memberProperty type="List" name="ActionGroups">
              <typeArguments>
                <typeReference type="ActionGroup"/>
              </typeArguments>
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="actionGroups"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property Categories -->
            <memberField type="List" name="categories">
              <typeArguments>
                <typeReference type="Category"/>
              </typeArguments>
            </memberField>
            <memberProperty type="List" name="Categories">
              <typeArguments>
                <typeReference type="Category"/>
              </typeArguments>
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="categories"/>
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
            <!-- property Controller -->
            <memberField type="System.String" name="controller"/>
            <memberProperty type="System.String" name="Controller">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="controller"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property View -->
            <memberField type="System.String" name="view"/>
            <memberProperty type="System.String" name="View">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="view"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property SupportsCaching -->
            <memberProperty type="System.Boolean" name="SupportsCaching">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property ViewType -->
            <memberProperty type="System.String" name="ViewType">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property LastView -->
            <memberProperty type="System.String" name="LastView">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property InTransaction -->
            <memberField type="System.Boolean" name="inTransaction"/>
            <memberProperty type="System.Boolean" name="InTransaction">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="inTransaction"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property StatusBar -->
            <memberProperty type="System.String" name="StatusBar">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- method LoadStatefulObject(string, string) -->
            <!--<memberMethod returnType="System.Object" name="LoadStatefulObject">
              <attributes family="true" final="true"/>
              <parameters>
                <parameter type="System.String" name="cookie"/>
                <parameter type="System.String" name="name"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <binaryOperatorExpression operator="IdentityInequality">
                        <propertyReferenceExpression name="Current">
                          <typeReferenceExpression type="HttpContext"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                      <binaryOperatorExpression operator="IdentityInequality">
                        <propertyReferenceExpression name="Session">
                          <propertyReferenceExpression name="Current">
                            <typeReferenceExpression type="HttpContext"/>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <arrayIndexerExpression>
                        <target>
                          <propertyReferenceExpression name="Session">
                            <propertyReferenceExpression name="Current">
                              <typeReferenceExpression type="HttpContext"/>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                        </target>
                        <indices>
                          <argumentReferenceExpression name="name"/>
                        </indices>
                      </arrayIndexerExpression>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <arrayIndexerExpression>
                    <target>
                      <propertyReferenceExpression name="Cache">
                        <typeReferenceExpression type="HttpRuntime"/>
                      </propertyReferenceExpression>
                    </target>
                    <indices>
                      <binaryOperatorExpression operator="Add">
                        <argumentReferenceExpression name="cookie"/>
                        <argumentReferenceExpression name="name"/>
                      </binaryOperatorExpression>
                    </indices>
                  </arrayIndexerExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>-->
            <!-- SaveStatefulObject(string, string, object) -->
            <!--<memberMethod name="SaveStatefulObject">
              <attributes family="true" final="true"/>
              <parameters>
                <parameter type="System.String" name="cookie"/>
                <parameter type="System.String" name="name"/>
                <parameter type="System.Object" name="instance"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <binaryOperatorExpression operator="IdentityInequality">
                        <propertyReferenceExpression name="Current">
                          <typeReferenceExpression type="HttpContext"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                      <binaryOperatorExpression operator="IdentityInequality">
                        <propertyReferenceExpression name="Session">
                          <propertyReferenceExpression name="Current">
                            <typeReferenceExpression type="HttpContext"/>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                        <primitiveExpression value="null"/>
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
                          <argumentReferenceExpression name="name"/>
                        </indices>
                      </arrayIndexerExpression>
                      <argumentReferenceExpression name="instance"/>
                    </assignStatement>
                  </trueStatements>
                  <falseStatements>
                    <variableDeclarationStatement type="System.String" name="cacheKey">
                      <init>
                        <binaryOperatorExpression operator="Add">
                          <argumentReferenceExpression name="cookie"/>
                          <argumentReferenceExpression name="name"/>
                        </binaryOperatorExpression>
                      </init>
                    </variableDeclarationStatement>
                    <methodInvokeExpression methodName="Remove">
                      <target>
                        <propertyReferenceExpression name="Cache">
                          <typeReferenceExpression type="HttpRuntime"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="cacheKey"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <propertyReferenceExpression name="Cache">
                          <typeReferenceExpression type="HttpRuntime"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="cacheKey"/>
                        <argumentReferenceExpression name="instance"/>
                        <primitiveExpression value="null"/>
                        <propertyReferenceExpression name="NoAbsoluteExpiration">
                          <typeReferenceExpression type="Cache"/>
                        </propertyReferenceExpression>
                        <methodInvokeExpression methodName="FromMinutes">
                          <target>
                            <typeReferenceExpression type="TimeSpan"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="20"/>
                          </parameters>
                        </methodInvokeExpression>
                        <propertyReferenceExpression name="Normal">
                          <typeReferenceExpression type="CacheItemPriority"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="null"/>
                      </parameters>
                    </methodInvokeExpression>
                  </falseStatements>
                </conditionStatement>
              </statements>
            </memberMethod>-->
            <!-- property AllowDistinctFieldInFilter -->
            <memberField type="System.Boolean" name="allowDistinctFieldInFilter"/>
            <memberProperty type="System.Boolean" name="AllowDistinctFieldInFilter">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="allowDistinctFieldInFilter"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!--  property Icons -->
            <memberField type="System.String[]" name="icons"/>
            <memberProperty type="System.String[]" name="Icons">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="icons"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="icons"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property IsAuthenticated -->
            <memberProperty type="System.Boolean" name="IsAuthenticated">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <propertyReferenceExpression name="IsAuthenticated">
                    <propertyReferenceExpression name="Identity">
                      <propertyReferenceExpression name="User">
                        <propertyReferenceExpression name="Current">
                          <typeReferenceExpression type="HttpContext"/>
                        </propertyReferenceExpression>
                      </propertyReferenceExpression>
                    </propertyReferenceExpression>
                  </propertyReferenceExpression>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property LEVs-->
            <memberField type="FieldValue[]" name="levs"/>
            <memberProperty type="FieldValue[]" name="LEVs">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="levs"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="levs"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property QuickFindHint -->
            <memberProperty type="System.String" name="QuickFindHint">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property InnerJoinPrimaryKey -->
            <memberProperty type="System.String" name="InnerJoinPrimaryKey">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property InnerJoinForeignKey -->
            <memberProperty type="System.String" name="InnerJoinForeignKey">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- constructor ViewPage() -->
            <constructor>
              <attributes public="true"/>
              <chainedConstructorArgs>
                <objectCreateExpression type="PageRequest">
                  <parameters>
                    <primitiveExpression value="0"/>
                    <primitiveExpression value="0"/>
                    <primitiveExpression value="null"/>
                    <primitiveExpression value="null"/>
                  </parameters>
                </objectCreateExpression>
              </chainedConstructorArgs>
            </constructor>
            <!-- constructor ViewPape(DistinctValueRequest) -->
            <constructor>
              <attributes public="true"/>
              <parameters>
                <parameter type="DistinctValueRequest" name="request"/>
              </parameters>
              <chainedConstructorArgs>
                <objectCreateExpression type="PageRequest">
                  <parameters>
                    <primitiveExpression value="0"/>
                    <primitiveExpression value="0"/>
                    <primitiveExpression value="null"/>
                    <propertyReferenceExpression name="Filter">
                      <argumentReferenceExpression name="request"/>
                    </propertyReferenceExpression>
                  </parameters>
                </objectCreateExpression>
              </chainedConstructorArgs>
              <statements>
                <assignStatement>
                  <fieldReferenceExpression name="tag"/>
                  <propertyReferenceExpression name="Tag">
                    <argumentReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="distinctValueFieldName"/>
                  <propertyReferenceExpression name="FieldName">
                    <argumentReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="pageSize"/>
                  <propertyReferenceExpression name="MaximumValueCount">
                    <argumentReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="allowDistinctFieldInFilter"/>
                  <propertyReferenceExpression name="AllowFieldInFilter">
                    <argumentReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="controller"/>
                  <propertyReferenceExpression name="Controller">
                    <argumentReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="view"/>
                  <propertyReferenceExpression name="View">
                    <argumentReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="filter"/>
                  <propertyReferenceExpression name="Filter">
                    <argumentReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="quickFindHint"/>
                  <propertyReferenceExpression name="QuickFindHint">
                    <argumentReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                </assignStatement>
              </statements>
            </constructor>
            <!-- constructor ViewPage(PageRequest) -->
            <constructor>
              <attributes public="true"/>
              <parameters>
                <parameter type="PageRequest" name="request"/>
              </parameters>
              <statements>
                <assignStatement>
                  <fieldReferenceExpression name="tag"/>
                  <propertyReferenceExpression name="Tag">
                    <argumentReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="PageOffset">
                    <thisReferenceExpression/>
                  </propertyReferenceExpression>
                  <propertyReferenceExpression name="PageOffset">
                    <argumentReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="requiresMetaData"/>
                  <binaryOperatorExpression operator="BooleanOr">
                    <binaryOperatorExpression operator="ValueEquality">
                      <propertyReferenceExpression name="PageIndex">
                        <argumentReferenceExpression name="request"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="-1"/>
                    </binaryOperatorExpression>
                    <propertyReferenceExpression name="RequiresMetaData">
                      <argumentReferenceExpression name="request"/>
                    </propertyReferenceExpression>
                  </binaryOperatorExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="requiresRowCount"/>
                  <binaryOperatorExpression operator="BooleanOr">
                    <binaryOperatorExpression operator="LessThan">
                      <propertyReferenceExpression name="PageIndex">
                        <argumentReferenceExpression name="request"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="0"/>
                    </binaryOperatorExpression>
                    <propertyReferenceExpression name="RequiresRowCount">
                      <argumentReferenceExpression name="request"/>
                    </propertyReferenceExpression>
                  </binaryOperatorExpression>
                </assignStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <propertyReferenceExpression name="PageIndex">
                        <argumentReferenceExpression name="request"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="-2"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <propertyReferenceExpression name="PageIndex">
                        <argumentReferenceExpression name="request"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="0"/>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <assignStatement>
                  <fieldReferenceExpression name="pageSize"/>
                  <propertyReferenceExpression name="PageSize">
                    <variableReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <conditionStatement>
                  <condition>
                    <propertyReferenceExpression name="RequiresPivot">
                      <argumentReferenceExpression name="request"/>
                    </propertyReferenceExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <propertyReferenceExpression name="RequiresPivot"/>
                      <primitiveExpression value="true"/>
                    </assignStatement>
                    <assignStatement>
                      <fieldReferenceExpression name="requiresMetaData"/>
                      <primitiveExpression value="false"/>
                    </assignStatement>
                    <assignStatement>
                      <fieldReferenceExpression name="requiresRowCount"/>
                      <primitiveExpression value="false"/>
                    </assignStatement>
                    <assignStatement>
                      <fieldReferenceExpression name="pageSize"/>
                      <propertyReferenceExpression name="MaxValue">
                        <typeReferenceExpression type="Int32"/>
                      </propertyReferenceExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="GreaterThan">
                      <propertyReferenceExpression name="PageIndex">
                        <argumentReferenceExpression name="request"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="0"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <fieldReferenceExpression name="pageIndex"/>
                      <propertyReferenceExpression name="PageIndex">
                        <argumentReferenceExpression name="request"/>
                      </propertyReferenceExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <assignStatement>
                  <fieldReferenceExpression name="rows"/>
                  <objectCreateExpression type="List">
                    <typeArguments>
                      <typeReference type="System.Object[]"/>
                    </typeArguments>
                  </objectCreateExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="fields"/>
                  <objectCreateExpression type="List">
                    <typeArguments>
                      <typeReference type="DataField"/>
                    </typeArguments>
                  </objectCreateExpression>
                </assignStatement>
                <methodInvokeExpression methodName="ResetSkipCount">
                  <parameters>
                    <primitiveExpression value="false"/>
                  </parameters>
                </methodInvokeExpression>
                <assignStatement>
                  <fieldReferenceExpression name="readCount"/>
                  <propertyReferenceExpression name="PageSize">
                    <argumentReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="sortExpression"/>
                  <propertyReferenceExpression name="SortExpression">
                    <argumentReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="filter"/>
                  <propertyReferenceExpression name="Filter">
                    <argumentReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="systemFilter"/>
                  <propertyReferenceExpression name="SystemFilter">
                    <argumentReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="totalRowCount"/>
                  <primitiveExpression value="-1"/>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="views"/>
                  <objectCreateExpression type="List">
                    <typeArguments>
                      <typeReference type="View"/>
                    </typeArguments>
                  </objectCreateExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="actionGroups"/>
                  <objectCreateExpression type="List">
                    <typeArguments>
                      <typeReference type="ActionGroup"/>
                    </typeArguments>
                  </objectCreateExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="categories"/>
                  <objectCreateExpression type="List">
                    <typeArguments>
                      <typeReference type="Category"/>
                    </typeArguments>
                  </objectCreateExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="controller"/>
                  <propertyReferenceExpression name="Controller">
                    <argumentReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="view"/>
                  <propertyReferenceExpression name="View">
                    <argumentReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="inTransaction"/>
                  <unaryOperatorExpression operator="Not">
                    <methodInvokeExpression methodName="IsNullOrEmpty">
                      <target>
                        <typeReferenceExpression type="String"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="Transaction">
                          <argumentReferenceExpression name="request"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </unaryOperatorExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="lastView"/>
                  <propertyReferenceExpression name="LastView">
                    <argumentReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="viewType"/>
                  <propertyReferenceExpression name="ViewType">
                    <argumentReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="SupportsCaching"/>
                  <propertyReferenceExpression name="SupportsCaching">
                    <argumentReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="quickFindHint"/>
                  <propertyReferenceExpression name="QuickFindHint">
                    <argumentReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="innerJoinPrimaryKey"/>
                  <propertyReferenceExpression name="InnerJoinPrimaryKey">
                    <argumentReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="InnerJoinForeignKey"/>
                  <propertyReferenceExpression name="InnerJoinForeignKey">
                    <argumentReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                </assignStatement>
              </statements>
            </constructor>
            <!-- method SkipNext() -->
            <memberMethod returnType="System.Boolean" name="SkipNext" >
              <attributes public="true" final="true"/>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <fieldReferenceExpression name="skipCount"/>
                      <primitiveExpression value="0"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="false"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <decrementStatement>
                  <fieldReferenceExpression name="skipCount"/>
                </decrementStatement>
                <methodReturnStatement>
                  <primitiveExpression value="true"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method ResetSkipCount(bool) -->
            <memberMethod name="ResetSkipCount">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="System.Boolean" name="preFetch"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <argumentReferenceExpression name="preFetch"/>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <fieldReferenceExpression name="skipCount"/>
                      <binaryOperatorExpression operator="Multiply">
                        <binaryOperatorExpression operator="Subtract">
                          <fieldReferenceExpression name="pageIndex"/>
                          <primitiveExpression value="1"/>
                        </binaryOperatorExpression>
                        <fieldReferenceExpression name="pageSize"/>
                      </binaryOperatorExpression>
                    </assignStatement>
                    <assignStatement>
                      <fieldReferenceExpression name="readCount"/>
                      <binaryOperatorExpression operator="Multiply">
                        <fieldReferenceExpression name="readCount"/>
                        <primitiveExpression value="3"/>
                      </binaryOperatorExpression>
                    </assignStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="LessThan">
                          <fieldReferenceExpression name="skipCount"/>
                          <primitiveExpression value="0"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <fieldReferenceExpression name="skipCount"/>
                          <primitiveExpression value="0"/>
                        </assignStatement>
                        <assignStatement>
                          <fieldReferenceExpression name="readCount"/>
                          <binaryOperatorExpression operator="Subtract">
                            <fieldReferenceExpression name="readCount"/>
                            <fieldReferenceExpression name="pageSize"/>
                          </binaryOperatorExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                  </trueStatements>
                  <falseStatements>
                    <assignStatement>
                      <fieldReferenceExpression name="skipCount"/>
                      <binaryOperatorExpression operator="Multiply">
                        <fieldReferenceExpression name="pageIndex"/>
                        <fieldReferenceExpression name="pageSize"/>
                      </binaryOperatorExpression>
                    </assignStatement>
                  </falseStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method ReadNext() -->
            <memberMethod returnType="System.Boolean" name="ReadNext">
              <attributes public="true" final="true"/>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <fieldReferenceExpression name="readCount"/>
                      <primitiveExpression value="0"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="false"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <decrementStatement>
                  <fieldReferenceExpression name="readCount"/>
                </decrementStatement>
                <methodReturnStatement>
                  <primitiveExpression value="true"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method AcceptAllRows() -->
            <memberMethod name="AcceptAllRows">
              <attributes public="true" final="true"/>
              <statements>
                <assignStatement>
                  <fieldReferenceExpression name="readCount"/>
                  <propertyReferenceExpression name="MaxValue">
                    <typeReferenceExpression type="Int32"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="skipCount"/>
                  <primitiveExpression value="0"/>
                </assignStatement>
              </statements>
            </memberMethod>
            <!-- method ContainsField(string) -->
            <memberMethod returnType="System.Boolean" name="ContainsField">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="System.String" name="name"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <binaryOperatorExpression operator="IdentityInequality">
                    <methodInvokeExpression methodName="FindField">
                      <parameters>
                        <argumentReferenceExpression name="name"/>
                      </parameters>
                    </methodInvokeExpression>
                    <primitiveExpression value="null"/>
                  </binaryOperatorExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method FindField(string) -->
            <memberMethod returnType="DataField" name="FindField">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="System.String" name="name"/>
              </parameters>
              <statements>
                <foreachStatement>
                  <variable type="DataField" name="field"/>
                  <target>
                    <propertyReferenceExpression name="Fields"/>
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
                            <argumentReferenceExpression name="name"/>
                            <propertyReferenceExpression name="InvariantCultureIgnoreCase">
                              <typeReferenceExpression type="StringComparison"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </condition>
                      <trueStatements>
                        <methodReturnStatement>
                          <variableReferenceExpression name="field"/>
                        </methodReturnStatement>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
                <methodReturnStatement>
                  <primitiveExpression value="null"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- property PopulatingStaticItems -->
            <!-- 
        [ThreadStatic]
        public static bool PopulatingStaticItems = false;            -->
            <memberField type="System.Boolean" name="PopulatingStaticItems">
              <attributes public="true" static="true"/>
              <customAttributes>
                <customAttribute type="ThreadStatic"/>
              </customAttributes>
            </memberField>
            <!-- method PopulateStaticItems(DataField, FieldValue[]) -->
            <memberMethod returnType="System.Boolean" name="PopulateStaticItems">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="DataField" name="field"/>
                <parameter type="FieldValue[]" name="contextValues"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <methodInvokeExpression methodName="SupportsStaticItems">
                        <target>
                          <variableReferenceExpression name="field"/>
                        </target>
                      </methodInvokeExpression>
                      <binaryOperatorExpression operator="BooleanOr">
                        <methodInvokeExpression methodName="IsNullOrEmpty">
                          <target>
                            <typeReferenceExpression type="String"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="ContextFields">
                              <variableReferenceExpression name="field"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                        <binaryOperatorExpression operator="BooleanOr">
                          <binaryOperatorExpression operator="IdentityInequality">
                            <argumentReferenceExpression name="contextValues"/>
                            <primitiveExpression value="null"/>
                          </binaryOperatorExpression>
                          <binaryOperatorExpression operator="ValueEquality">
                            <propertyReferenceExpression name="ItemsStyle">
                              <argumentReferenceExpression name="field"/>
                            </propertyReferenceExpression>
                            <primitiveExpression value="CheckBoxList"/>
                          </binaryOperatorExpression>
                        </binaryOperatorExpression>
                      </binaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <conditionStatement>
                      <condition>
                        <propertyReferenceExpression name="PopulatingStaticItems"/>
                      </condition>
                      <trueStatements>
                        <methodReturnStatement>
                          <primitiveExpression value="true"/>
                        </methodReturnStatement>
                      </trueStatements>
                    </conditionStatement>
                    <assignStatement>
                      <propertyReferenceExpression name="PopulatingStaticItems"/>
                      <primitiveExpression value="true"/>
                    </assignStatement>
                    <tryStatement>
                      <statements>
                        <variableDeclarationStatement type="System.String[]" name="filter">
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
                                  <propertyReferenceExpression name="ContextFields">
                                    <argumentReferenceExpression name="field"/>
                                  </propertyReferenceExpression>
                                </parameters>
                              </methodInvokeExpression>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <variableDeclarationStatement type="List" name="contextFilter">
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
                            <variableDeclarationStatement type="Match" name="m">
                              <init>
                                <methodInvokeExpression methodName="Match">
                                  <target>
                                    <typeReferenceExpression type="Regex"/>
                                  </target>
                                  <parameters>
                                    <propertyReferenceExpression name="ContextFields">
                                      <argumentReferenceExpression name="field"/>
                                    </propertyReferenceExpression>
                                    <primitiveExpression value="(\w+)=(.+?)($|,)"/>
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
                                <variableDeclarationStatement type="Match" name="vm">
                                  <init>
                                    <methodInvokeExpression methodName="Match">
                                      <target>
                                        <typeReferenceExpression type="Regex"/>
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
                                              <primitiveExpression value="2"/>
                                            </indices>
                                          </arrayIndexerExpression>
                                        </propertyReferenceExpression>
                                        <primitiveExpression value="^'(.+?)'$"/>
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
                                      <variableReferenceExpression name="vm"/>
                                    </propertyReferenceExpression>
                                  </condition>
                                  <trueStatements>
                                    <methodInvokeExpression methodName="Add">
                                      <target>
                                        <variableReferenceExpression name="contextFilter"/>
                                      </target>
                                      <parameters>
                                        <methodInvokeExpression methodName="Format">
                                          <target>
                                            <typeReferenceExpression type="String"/>
                                          </target>
                                          <parameters>
                                            <primitiveExpression value="{{0}}:={{1}}"/>
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
                                                    <variableReferenceExpression name="vm"/>
                                                  </propertyReferenceExpression>
                                                </target>
                                                <indices>
                                                  <primitiveExpression value="1"/>
                                                </indices>
                                              </arrayIndexerExpression>
                                            </propertyReferenceExpression>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </trueStatements>
                                  <falseStatements>
                                    <conditionStatement>
                                      <condition>
                                        <binaryOperatorExpression operator="IdentityInequality">
                                          <argumentReferenceExpression name="contextValues"/>
                                          <primitiveExpression value="null"/>
                                        </binaryOperatorExpression>
                                      </condition>
                                      <trueStatements>
                                        <foreachStatement>
                                          <variable type="FieldValue" name="cv"/>
                                          <target>
                                            <variableReferenceExpression name="contextValues"/>
                                          </target>
                                          <statements>
                                            <conditionStatement>
                                              <condition>
                                                <binaryOperatorExpression operator="ValueEquality">
                                                  <propertyReferenceExpression name="Name">
                                                    <variableReferenceExpression name="cv"/>
                                                  </propertyReferenceExpression>
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
                                                </binaryOperatorExpression>
                                              </condition>
                                              <trueStatements>
                                                <methodInvokeExpression methodName="Add">
                                                  <target>
                                                    <variableReferenceExpression name="contextFilter"/>
                                                  </target>
                                                  <parameters>
                                                    <methodInvokeExpression methodName="Format">
                                                      <target>
                                                        <typeReferenceExpression type="String"/>
                                                      </target>
                                                      <parameters>
                                                        <primitiveExpression value="{{0}}:={{1}}"/>
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
                                                        <propertyReferenceExpression name="NewValue">
                                                          <variableReferenceExpression name="cv"/>
                                                        </propertyReferenceExpression>
                                                      </parameters>
                                                    </methodInvokeExpression>
                                                  </parameters>
                                                </methodInvokeExpression>
                                                <breakStatement/>
                                              </trueStatements>
                                            </conditionStatement>
                                          </statements>
                                        </foreachStatement>
                                      </trueStatements>
                                    </conditionStatement>
                                  </falseStatements>
                                </conditionStatement>
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
                            <assignStatement>
                              <variableReferenceExpression name="filter"/>
                              <methodInvokeExpression methodName="ToArray">
                                <target>
                                  <variableReferenceExpression name="contextFilter"/>
                                </target>
                              </methodInvokeExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <variableDeclarationStatement type="PageRequest" name="request">
                          <init>
                            <objectCreateExpression type="PageRequest">
                              <parameters>
                                <primitiveExpression value="-1"/>
                                <primitiveExpression value="1000"/>
                                <propertyReferenceExpression name="ItemsDataTextField">
                                  <variableReferenceExpression name="field"/>
                                </propertyReferenceExpression>
                                <variableReferenceExpression name="filter"/>
                              </parameters>
                            </objectCreateExpression>
                          </init>
                        </variableDeclarationStatement>
                        <!-- 
                    ActionArgs args = ActionArgs.Current;
                    if (args != null)
                    {
                        request.ExternalFilter = args.ExternalFilter;
                    }                        -->
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="IdentityInequality">
                              <propertyReferenceExpression name="Current">
                                <typeReferenceExpression type="ActionArgs"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="null"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="ExternalFilter">
                                <variableReferenceExpression name="request"/>
                              </propertyReferenceExpression>
                              <propertyReferenceExpression name="ExternalFilter">
                                <propertyReferenceExpression name="Current">
                                  <typeReferenceExpression type="ActionArgs"/>
                                </propertyReferenceExpression>
                              </propertyReferenceExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
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
                                <propertyReferenceExpression name="ItemsDataController">
                                  <variableReferenceExpression name="field"/>
                                </propertyReferenceExpression>
                                <propertyReferenceExpression name="ItemsDataView">
                                  <variableReferenceExpression name="field"/>
                                </propertyReferenceExpression>
                                <variableReferenceExpression name="request"/>
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <variableDeclarationStatement type="System.Int32" name="dataValueFieldIndex">
                          <init>
                            <methodInvokeExpression methodName="IndexOf">
                              <target>
                                <propertyReferenceExpression name="Fields">
                                  <variableReferenceExpression name="page"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <methodInvokeExpression methodName="FindField">
                                  <target>
                                    <variableReferenceExpression name="page"/>
                                  </target>
                                  <parameters>
                                    <propertyReferenceExpression name="ItemsDataValueField">
                                      <variableReferenceExpression name="field"/>
                                    </propertyReferenceExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="ValueEquality">
                              <variableReferenceExpression name="dataValueFieldIndex"/>
                              <primitiveExpression value="-1"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <foreachStatement>
                              <variable type="DataField" name="aField"/>
                              <target>
                                <propertyReferenceExpression name="Fields">
                                  <variableReferenceExpression name="page"/>
                                </propertyReferenceExpression>
                              </target>
                              <statements>
                                <conditionStatement>
                                  <condition>
                                    <propertyReferenceExpression name="IsPrimaryKey">
                                      <variableReferenceExpression name="aField"/>
                                    </propertyReferenceExpression>
                                  </condition>
                                  <trueStatements>
                                    <assignStatement>
                                      <variableReferenceExpression name="dataValueFieldIndex"/>
                                      <methodInvokeExpression methodName="IndexOf">
                                        <target>
                                          <propertyReferenceExpression name="Fields">
                                            <variableReferenceExpression name="page"/>
                                          </propertyReferenceExpression>
                                        </target>
                                        <parameters>
                                          <variableReferenceExpression name="aField"/>
                                        </parameters>
                                      </methodInvokeExpression>
                                    </assignStatement>
                                    <breakStatement/>
                                  </trueStatements>
                                </conditionStatement>
                              </statements>
                            </foreachStatement>
                          </trueStatements>
                        </conditionStatement>
                        <variableDeclarationStatement type="System.Int32" name="dataTextFieldIndex">
                          <init>
                            <methodInvokeExpression methodName="IndexOf">
                              <target>
                                <propertyReferenceExpression name="Fields">
                                  <variableReferenceExpression name="page"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <methodInvokeExpression methodName="FindField">
                                  <target>
                                    <variableReferenceExpression name="page"/>
                                  </target>
                                  <parameters>
                                    <propertyReferenceExpression name="ItemsDataTextField">
                                      <variableReferenceExpression name="field"/>
                                    </propertyReferenceExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="ValueEquality">
                              <variableReferenceExpression name="dataTextFieldIndex"/>
                              <primitiveExpression value="-1"/>
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
                                <binaryOperatorExpression operator="BooleanAnd">
                                  <binaryOperatorExpression operator="ValueEquality">
                                    <variableReferenceExpression name="dataTextFieldIndex"/>
                                    <primitiveExpression value="-1"/>
                                  </binaryOperatorExpression>
                                  <binaryOperatorExpression operator="LessThan">
                                    <variableReferenceExpression name="i"/>
                                    <propertyReferenceExpression name="Count">
                                      <propertyReferenceExpression name="Fields">
                                        <argumentReferenceExpression name="page"/>
                                      </propertyReferenceExpression>
                                    </propertyReferenceExpression>
                                  </binaryOperatorExpression>
                                </binaryOperatorExpression>
                              </test>
                              <statements>
                                <variableDeclarationStatement type="DataField" name="f">
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
                                      <unaryOperatorExpression operator="Not">
                                        <propertyReferenceExpression name="Hidden">
                                          <variableReferenceExpression name="f"/>
                                        </propertyReferenceExpression>
                                      </unaryOperatorExpression>
                                      <binaryOperatorExpression operator="ValueEquality">
                                        <propertyReferenceExpression name="Type">
                                          <variableReferenceExpression name="f"/>
                                        </propertyReferenceExpression>
                                        <primitiveExpression value="String"/>
                                      </binaryOperatorExpression>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <assignStatement>
                                      <variableReferenceExpression name="dataTextFieldIndex"/>
                                      <variableReferenceExpression name="i"/>
                                    </assignStatement>
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
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="ValueEquality">
                                  <variableReferenceExpression name="dataTextFieldIndex"/>
                                  <primitiveExpression value="-1"/>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="dataTextFieldIndex"/>
                                  <primitiveExpression value="0"/>
                                </assignStatement>
                              </trueStatements>
                            </conditionStatement>
                          </trueStatements>
                        </conditionStatement>
                        <variableDeclarationStatement type="List" name="fieldIndexes">
                          <typeArguments>
                            <typeReference type="System.Int32"/>
                          </typeArguments>
                          <init>
                            <objectCreateExpression type="List">
                              <typeArguments>
                                <typeReference type="System.Int32"/>
                              </typeArguments>
                            </objectCreateExpression>
                          </init>
                        </variableDeclarationStatement>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <variableReferenceExpression name="fieldIndexes"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="dataValueFieldIndex"/>
                          </parameters>
                        </methodInvokeExpression>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <variableReferenceExpression name="fieldIndexes"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="dataTextFieldIndex"/>
                          </parameters>
                        </methodInvokeExpression>
                        <conditionStatement>
                          <condition>
                            <unaryOperatorExpression operator="Not">
                              <methodInvokeExpression methodName="IsNullOrEmpty">
                                <target>
                                  <typeReferenceExpression type="String"/>
                                </target>
                                <parameters>
                                  <propertyReferenceExpression name="Copy">
                                    <argumentReferenceExpression name="field"/>
                                  </propertyReferenceExpression>
                                </parameters>
                              </methodInvokeExpression>
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
                                    <propertyReferenceExpression name="Copy">
                                      <argumentReferenceExpression name="field"/>
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
                                  <variableReferenceExpression name="m"/>
                                </propertyReferenceExpression>
                              </test>
                              <statements>
                                <variableDeclarationStatement type="System.Int32" name="copyFieldIndex">
                                  <init>
                                    <methodInvokeExpression methodName="IndexOf">
                                      <target>
                                        <propertyReferenceExpression name="Fields">
                                          <argumentReferenceExpression name="page"/>
                                        </propertyReferenceExpression>
                                      </target>
                                      <parameters>
                                        <methodInvokeExpression methodName="FindField">
                                          <target>
                                            <argumentReferenceExpression name="page"/>
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
                                                  <primitiveExpression value="2"/>
                                                </indices>
                                              </arrayIndexerExpression>
                                            </propertyReferenceExpression>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </init>
                                </variableDeclarationStatement>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="GreaterThanOrEqual">
                                      <variableReferenceExpression name="copyFieldIndex"/>
                                      <primitiveExpression value="0"/>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <methodInvokeExpression methodName="Add">
                                      <target>
                                        <variableReferenceExpression name="fieldIndexes"/>
                                      </target>
                                      <parameters>
                                        <variableReferenceExpression name="copyFieldIndex"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </trueStatements>
                                </conditionStatement>
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
                        <foreachStatement>
                          <variable type="System.Object[]" name="row"/>
                          <target>
                            <propertyReferenceExpression name="Rows">
                              <argumentReferenceExpression name="page"/>
                            </propertyReferenceExpression>
                          </target>
                          <statements>
                            <variableDeclarationStatement type="System.Object[]" name="values">
                              <init>
                                <arrayCreateExpression>
                                  <createType type="System.Object"/>
                                  <sizeExpression>
                                    <propertyReferenceExpression name="Count">
                                      <variableReferenceExpression name="fieldIndexes"/>
                                    </propertyReferenceExpression>
                                  </sizeExpression>
                                </arrayCreateExpression>
                              </init>
                            </variableDeclarationStatement>
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
                                    <variableReferenceExpression name="fieldIndexes"/>
                                  </propertyReferenceExpression>
                                </binaryOperatorExpression>
                              </test>
                              <increment>
                                <variableReferenceExpression name="i"/>
                              </increment>
                              <statements>
                                <variableDeclarationStatement type="System.Int32" name="copyFieldIndex">
                                  <init>
                                    <arrayIndexerExpression>
                                      <target>
                                        <variableReferenceExpression name="fieldIndexes"/>
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
                                      <variableReferenceExpression name="copyFieldIndex"/>
                                      <primitiveExpression value="0"/>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <assignStatement>
                                      <arrayIndexerExpression>
                                        <target>
                                          <variableReferenceExpression name="values"/>
                                        </target>
                                        <indices>
                                          <variableReferenceExpression name="i"/>
                                        </indices>
                                      </arrayIndexerExpression>
                                      <arrayIndexerExpression>
                                        <target>
                                          <variableReferenceExpression name="row"/>
                                        </target>
                                        <indices>
                                          <variableReferenceExpression name="copyFieldIndex"/>
                                        </indices>
                                      </arrayIndexerExpression>
                                    </assignStatement>
                                  </trueStatements>
                                </conditionStatement>
                              </statements>
                            </forStatement>
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <propertyReferenceExpression name="Items">
                                  <argumentReferenceExpression name="field"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="values"/>
                              </parameters>
                            </methodInvokeExpression>
                          </statements>
                        </foreachStatement>
                        <!--<conditionStatement>
                          <condition>
                            <methodInvokeExpression methodName="IsNullOrEmpty">
                              <target>
                                <typeReferenceExpression type="String"/>
                              </target>
                              <parameters>
                                <propertyReferenceExpression name="ItemsDataTextField">
                                  <variableReferenceExpression name="field"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </condition>
                          <trueStatements>
                            <variableDeclarationStatement type="SortedDictionary" name="sortedList">
                              <typeArguments>
                                <typeReference type="System.String"/>
                                <typeReference type="System.Object[]"/>
                              </typeArguments>
                              <init>
                                <objectCreateExpression type="SortedDictionary">
                                  <typeArguments>
                                    <typeReference type="System.String"/>
                                    <typeReference type="System.Object[]"/>
                                  </typeArguments>
                                </objectCreateExpression>
                              </init>
                            </variableDeclarationStatement>
                            <foreachStatement>
                              <variable type="System.Object[]" name="item"/>
                              <target>
                                <propertyReferenceExpression name="Items">
                                  <variableReferenceExpression name="field"/>
                                </propertyReferenceExpression>
                              </target>
                              <statements>
                                <variableDeclarationStatement type="System.String" name="s">
                                  <init>
                                    <methodInvokeExpression methodName="ToString">
                                      <target>
                                        <typeReferenceExpression type="Convert"/>
                                      </target>
                                      <parameters>
                                        <arrayIndexerExpression>
                                          <target>
                                            <variableReferenceExpression name="item"/>
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
                                    <unaryOperatorExpression operator="Not">
                                      <methodInvokeExpression methodName="ContainsKey">
                                        <target>
                                          <variableReferenceExpression name="sortedList"/>
                                        </target>
                                        <parameters>
                                          <variableReferenceExpression name="s"/>
                                        </parameters>
                                      </methodInvokeExpression>
                                    </unaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <methodInvokeExpression methodName="Add">
                                      <target>
                                        <variableReferenceExpression name="sortedList"/>
                                      </target>
                                      <parameters>
                                        <variableReferenceExpression name="s"/>
                                        <variableReferenceExpression name="item"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </trueStatements>
                                </conditionStatement>
                              </statements>
                            </foreachStatement>
                            <methodInvokeExpression methodName="Clear">
                              <target>
                                <propertyReferenceExpression name="Items">
                                  <variableReferenceExpression name="field"/>
                                </propertyReferenceExpression>
                              </target>
                            </methodInvokeExpression>
                            <foreachStatement>
                              <variable type="System.Object[]" name="item"/>
                              <target>
                                <propertyReferenceExpression name="Values">
                                  <variableReferenceExpression name="sortedList"/>
                                </propertyReferenceExpression>
                              </target>
                              <statements>
                                <methodInvokeExpression methodName="Add">
                                  <target>
                                    <propertyReferenceExpression name="Items">
                                      <variableReferenceExpression name="field"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <parameters>
                                    <variableReferenceExpression name="item"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </statements>
                            </foreachStatement>
                          </trueStatements>
                        </conditionStatement>-->
                        <methodReturnStatement>
                          <primitiveExpression value="true"/>
                        </methodReturnStatement>
                      </statements>
                      <finally>
                        <assignStatement>
                          <variableReferenceExpression name="PopulatingStaticItems"/>
                          <primitiveExpression value="false"/>
                        </assignStatement>
                      </finally>
                    </tryStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <primitiveExpression value="false"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method ToResult(ControllerConfiguration, XPathNavigator) -->
            <memberMethod returnType="ViewPage" name="ToResult">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="ControllerConfiguration" name="configuration"/>
                <parameter type="XPathNavigator" name="mainView"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="Not">
                      <fieldReferenceExpression name="requiresMetaData"/>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="Clear">
                      <target>
                        <propertyReferenceExpression name="Fields"/>
                      </target>
                    </methodInvokeExpression>
                    <assignStatement>
                      <propertyReferenceExpression name="Expressions"/>
                      <primitiveExpression value="null"/>
                    </assignStatement>
                  </trueStatements>
                  <falseStatements>
                    <variableDeclarationStatement type="XPathNodeIterator" name="viewIterator">
                      <init>
                        <methodInvokeExpression methodName="Select">
                          <target>
                            <argumentReferenceExpression name="configuration"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="/c:dataController/c:views/c:view[not(@virtualViewId!='')]"/>
                            <!--<propertyReferenceExpression name="Resolver">
                              <argumentReferenceExpression name="configuration"/>
                            </propertyReferenceExpression>-->
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <whileStatement>
                      <test>
                        <methodInvokeExpression methodName="MoveNext">
                          <target>
                            <variableReferenceExpression name="viewIterator"/>
                          </target>
                        </methodInvokeExpression>
                      </test>
                      <statements>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <propertyReferenceExpression name="Views"/>
                          </target>
                          <parameters>
                            <objectCreateExpression type="View">
                              <parameters>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="viewIterator"/>
                                </propertyReferenceExpression>
                                <argumentReferenceExpression name="mainView"/>
                                <propertyReferenceExpression name="Resolver">
                                  <argumentReferenceExpression name="configuration"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </objectCreateExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </statements>
                    </whileStatement>
                    <variableDeclarationStatement type="XPathNodeIterator" name="actionGroupIterator">
                      <init>
                        <methodInvokeExpression methodName="Select">
                          <target>
                            <argumentReferenceExpression name="configuration"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="/c:dataController/c:actions//c:actionGroup"/>
                            <!--<propertyReferenceExpression name="Resolver">
                              <argumentReferenceExpression name="configuration"/>
                            </propertyReferenceExpression>-->
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <whileStatement>
                      <test>
                        <methodInvokeExpression methodName="MoveNext">
                          <target>
                            <variableReferenceExpression name="actionGroupIterator"/>
                          </target>
                        </methodInvokeExpression>
                      </test>
                      <statements>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <propertyReferenceExpression name="ActionGroups"/>
                          </target>
                          <parameters>
                            <objectCreateExpression type="ActionGroup">
                              <parameters>
                                <propertyReferenceExpression name="Current">
                                  <variableReferenceExpression name="actionGroupIterator"/>
                                </propertyReferenceExpression>
                                <propertyReferenceExpression name="Resolver">
                                  <argumentReferenceExpression name="configuration"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </objectCreateExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </statements>
                    </whileStatement>
                    <foreachStatement>
                      <variable type="DataField" name="field"/>
                      <target>
                        <propertyReferenceExpression name="Fields"/>
                      </target>
                      <statements>
                        <methodInvokeExpression methodName="PopulateStaticItems">
                          <parameters>
                            <variableReferenceExpression name="field"/>
                            <primitiveExpression value="null"/>
                          </parameters>
                        </methodInvokeExpression>
                      </statements>
                    </foreachStatement>
                  </falseStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <fieldReferenceExpression name="originalFilter"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <fieldReferenceExpression name="filter"/>
                      <fieldReferenceExpression name="originalFilter"/>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <fieldReferenceExpression name="filter"/>
                      <primitiveExpression value="null"/>
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
                          <propertyReferenceExpression name="Length">
                            <fieldReferenceExpression name="filter"/>
                          </propertyReferenceExpression>
                        </binaryOperatorExpression>
                      </test>
                      <increment>
                        <variableReferenceExpression name="i"/>
                      </increment>
                      <statements>
                        <variableDeclarationStatement type="System.String" name="f">
                          <init>
                            <arrayIndexerExpression>
                              <target>
                                <fieldReferenceExpression name="filter"/>
                              </target>
                              <indices>
                                <variableReferenceExpression name="i"/>
                              </indices>
                            </arrayIndexerExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="BooleanOr">
                              <methodInvokeExpression methodName="StartsWith">
                                <target>
                                  <variableReferenceExpression name="f"/>
                                </target>
                                <parameters>
                                  <primitiveExpression value="_match_"/>
                                </parameters>
                              </methodInvokeExpression>
                              <methodInvokeExpression methodName="StartsWith">
                                <target>
                                  <variableReferenceExpression name="f"/>
                                </target>
                                <parameters>
                                  <primitiveExpression value="_donotmatch_"/>
                                </parameters>
                              </methodInvokeExpression>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <variableDeclarationStatement type="System.String[]" name="oldFilter">
                              <init>
                                <fieldReferenceExpression name="filter"/>
                              </init>
                            </variableDeclarationStatement>
                            <assignStatement>
                              <fieldReferenceExpression name="filter"/>
                              <arrayCreateExpression>
                                <createType type="System.String"/>
                                <sizeExpression>
                                  <variableReferenceExpression name="i"/>
                                </sizeExpression>
                              </arrayCreateExpression>
                            </assignStatement>
                            <methodInvokeExpression methodName="Copy">
                              <target>
                                <typeReferenceExpression type="Array"/>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="oldFilter"/>
                                <fieldReferenceExpression name="filter"/>
                                <variableReferenceExpression name="i"/>
                              </parameters>
                            </methodInvokeExpression>
                            <breakStatement/>
                          </trueStatements>
                        </conditionStatement>
                      </statements>
                    </forStatement>
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
                          <thisReferenceExpression/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanAnd">
                          <propertyReferenceExpression name="RequiresMetaData"/>
                          <binaryOperatorExpression operator="BooleanAnd">
                            <binaryOperatorExpression operator="IdentityInequality">
                              <propertyReferenceExpression name="Current">
                                <typeReferenceExpression type="HttpContext"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="null"/>
                            </binaryOperatorExpression>
                            <binaryOperatorExpression operator="IdentityInequality">
                              <propertyReferenceExpression name="Session">
                                <propertyReferenceExpression name="Current">
                                  <typeReferenceExpression type="HttpContext"/>
                                </propertyReferenceExpression>
                              </propertyReferenceExpression>
                              <primitiveExpression value="null"/>
                            </binaryOperatorExpression>
                          </binaryOperatorExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <propertyReferenceExpression name="LEVs"/>
                          <castExpression targetType="FieldValue[]">
                            <arrayIndexerExpression>
                              <target>
                                <propertyReferenceExpression name="Session">
                                  <propertyReferenceExpression name="Current">
                                    <typeReferenceExpression type="HttpContext"/>
                                  </propertyReferenceExpression>
                                </propertyReferenceExpression>
                              </target>
                              <indices>
                                <methodInvokeExpression methodName="Format">
                                  <target>
                                    <typeReferenceExpression type="String"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="{{0}}$LEVs"/>
                                    <fieldReferenceExpression name="controller"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </indices>
                            </arrayIndexerExpression>
                          </castExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                  </trueStatements>
                </conditionStatement>
                <!--<methodInvokeExpression methodName="AddPivotHeadersToFields"/>-->
                <!--
            if (FindField("Status") == null)
            {
                DataField field = new DataField();
                field.Name = "Status";
                field.ReadOnly = true;
                field.Type = "String";
                field.AllowNulls = true;
                field.Hidden = true;
                Fields.Add(field);
            }
                -->
                <methodInvokeExpression methodName="EnsureJsonCompatibility">
                  <target>
                    <typeReferenceExpression type="DataControllerBase"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="NewRow"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="EnsureJsonCompatibility">
                  <target>
                    <typeReferenceExpression type="DataControllerBase"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Rows"/>
                  </parameters>
                </methodInvokeExpression>
                <methodReturnStatement>
                  <thisReferenceExpression/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method ToDataTable() -->
            <memberMethod returnType="DataTable" name="ToDataTable">
              <attributes public="true" final="true"/>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="ToDataTable">
                    <parameters>
                      <primitiveExpression value="table"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method ToDataTable(string) -->
            <memberMethod returnType="DataTable"  name="ToDataTable">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="System.String" name="tableName"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="DataTable" name="table">
                  <init>
                    <objectCreateExpression type="DataTable">
                      <parameters>
                        <argumentReferenceExpression name="tableName"/>
                      </parameters>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="List" name="columnTypes">
                  <typeArguments>
                    <typeReference type="Type"/>
                  </typeArguments>
                  <init>
                    <objectCreateExpression type="List">
                      <typeArguments>
                        <typeReference type="Type"/>
                      </typeArguments>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <foreachStatement>
                  <variable type="DataField" name="field"/>
                  <target>
                    <propertyReferenceExpression name="Fields"/>
                  </target>
                  <statements>
                    <variableDeclarationStatement type="System.Type" name="t">
                      <init>
                        <typeofExpression type="System.String"/>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="ValueInequality">
                          <propertyReferenceExpression name="Type">
                            <variableReferenceExpression name="field"/>
                          </propertyReferenceExpression>
                          <primitiveExpression value="Byte[]"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="t"/>
                          <arrayIndexerExpression>
                            <target>
                              <propertyReferenceExpression name="TypeMap">
                                <typeReferenceExpression type="DataControllerBase"/>
                              </propertyReferenceExpression>
                            </target>
                            <indices>
                              <propertyReferenceExpression name="Type">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                            </indices>
                          </arrayIndexerExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <propertyReferenceExpression name="Columns">
                          <variableReferenceExpression name="table"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="Name">
                          <variableReferenceExpression name="field"/>
                        </propertyReferenceExpression>
                        <variableReferenceExpression name="t"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <variableReferenceExpression name="columnTypes"/>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="t"/>
                      </parameters>
                    </methodInvokeExpression>
                  </statements>
                </foreachStatement>
                <foreachStatement>
                  <variable type="System.Object[]" name="row"/>
                  <target>
                    <propertyReferenceExpression name="Rows"/>
                  </target>
                  <statements>
                    <variableDeclarationStatement type="DataRow" name="newRow">
                      <init>
                        <methodInvokeExpression methodName="NewRow">
                          <target>
                            <variableReferenceExpression name="table"/>
                          </target>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
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
                            <propertyReferenceExpression name="Fields"/>
                          </propertyReferenceExpression>
                        </binaryOperatorExpression>
                      </test>
                      <increment>
                        <variableReferenceExpression name="i"/>
                      </increment>
                      <statements>
                        <variableDeclarationStatement type="System.Object" name="v">
                          <init>
                            <arrayIndexerExpression>
                              <target>
                                <variableReferenceExpression name="row"/>
                              </target>
                              <indices>
                                <variableReferenceExpression name="i"/>
                              </indices>
                            </arrayIndexerExpression>
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
                              <variableReferenceExpression name="v"/>
                              <propertyReferenceExpression name="Value">
                                <typeReferenceExpression type="DBNull"/>
                              </propertyReferenceExpression>
                            </assignStatement>
                          </trueStatements>
                          <falseStatements>
                            <variableDeclarationStatement type="Type" name="t">
                              <init>
                                <arrayIndexerExpression>
                                  <target>
                                    <variableReferenceExpression name="columnTypes"/>
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
                                  <binaryOperatorExpression operator="ValueEquality">
                                    <variableReferenceExpression name="t"/>
                                    <typeofExpression type="DateTime"/>
                                  </binaryOperatorExpression>
                                  <binaryOperatorExpression operator="IsTypeOf">
                                    <variableReferenceExpression name="v"/>
                                    <typeofExpression type="System.String"/>
                                  </binaryOperatorExpression>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="v"/>
                                  <methodInvokeExpression methodName="ToUniversalTime">
                                    <target>
                                      <methodInvokeExpression methodName="Parse">
                                        <target>
                                          <typeReferenceExpression type="DateTime"/>
                                        </target>
                                        <parameters>
                                          <castExpression targetType="System.String">
                                            <variableReferenceExpression name="v"/>
                                          </castExpression>
                                        </parameters>
                                      </methodInvokeExpression>
                                    </target>
                                  </methodInvokeExpression>
                                </assignStatement>
                              </trueStatements>
                              <falseStatements>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="BooleanAnd">
                                      <binaryOperatorExpression operator="IdentityEquality">
                                        <variableReferenceExpression name="t"/>
                                        <typeofExpression type="DateTimeOffset"/>
                                      </binaryOperatorExpression>
                                      <binaryOperatorExpression operator="IsTypeOf">
                                        <variableReferenceExpression name="v"/>
                                        <typeReferenceExpression type="System.String"/>
                                      </binaryOperatorExpression>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <variableDeclarationStatement type="DateTimeOffset" name="dto"/>
                                    <conditionStatement>
                                      <condition>
                                        <methodInvokeExpression methodName="TryParse">
                                          <target>
                                            <typeReferenceExpression type="DateTimeOffset"/>
                                          </target>
                                          <parameters>
                                            <castExpression targetType="System.String">
                                              <variableReferenceExpression name="v"/>
                                            </castExpression>
                                            <directionExpression direction="Out">
                                              <variableReferenceExpression name="dto"/>
                                            </directionExpression>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </condition>
                                      <trueStatements>
                                        <assignStatement>
                                          <variableReferenceExpression name="v"/>
                                          <variableReferenceExpression name="dto"/>
                                        </assignStatement>
                                      </trueStatements>
                                      <falseStatements>
                                        <assignStatement>
                                          <variableReferenceExpression name="v"/>
                                          <propertyReferenceExpression name="Value">
                                            <typeReferenceExpression type="DBNull"/>
                                          </propertyReferenceExpression>
                                        </assignStatement>
                                      </falseStatements>
                                    </conditionStatement>
                                  </trueStatements>
                                </conditionStatement>
                              </falseStatements>
                            </conditionStatement>
                          </falseStatements>
                        </conditionStatement>
                        <assignStatement>
                          <arrayIndexerExpression>
                            <target>
                              <variableReferenceExpression name="newRow"/>
                            </target>
                            <indices>
                              <variableReferenceExpression name="i"/>
                            </indices>
                          </arrayIndexerExpression>
                          <variableReferenceExpression name="v"/>
                        </assignStatement>
                      </statements>
                    </forStatement>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <propertyReferenceExpression name="Rows">
                          <variableReferenceExpression name="table"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="newRow"/>
                      </parameters>
                    </methodInvokeExpression>
                  </statements>
                </foreachStatement>
                <methodInvokeExpression methodName="AcceptChanges">
                  <target>
                    <variableReferenceExpression name="table"/>
                  </target>
                </methodInvokeExpression>
                <methodReturnStatement>
                  <variableReferenceExpression name="table"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method ToList<T>() -->
            <memberMethod returnType="List" name="ToList">
              <typeArguments>
                <typeReference type="T"/>
              </typeArguments>
              <typeParameters>
                <typeParameter name="T"/>
              </typeParameters>
              <attributes public="true" final="true"/>
              <statements>
                <variableDeclarationStatement type="Type" name="objectType">
                  <init>
                    <typeofExpression type="T"/>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="List" name="list">
                  <typeArguments>
                    <typeReference type="T"/>
                  </typeArguments>
                  <init>
                    <objectCreateExpression type="List">
                      <typeArguments>
                        <typeReference type="T"/>
                      </typeArguments>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.Object[]" name="args">
                  <init>
                    <arrayCreateExpression>
                      <createType type="System.Object"/>
                      <sizeExpression>
                        <primitiveExpression value="1"/>
                      </sizeExpression>
                    </arrayCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="Type[]" name="types">
                  <init>
                    <arrayCreateExpression>
                      <createType type="Type"/>
                      <sizeExpression>
                        <propertyReferenceExpression name="Count">
                          <propertyReferenceExpression name="Fields"/>
                        </propertyReferenceExpression>
                      </sizeExpression>
                    </arrayCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <forStatement>
                  <variable type="System.Int32" name="j">
                    <init>
                      <primitiveExpression value="0"/>
                    </init>
                  </variable>
                  <test>
                    <binaryOperatorExpression operator="LessThan">
                      <variableReferenceExpression name="j"/>
                      <propertyReferenceExpression name="Count">
                        <propertyReferenceExpression name="Fields"/>
                      </propertyReferenceExpression>
                    </binaryOperatorExpression>
                  </test>
                  <increment>
                    <variableReferenceExpression name="j"/>
                  </increment>
                  <statements>
                    <variableDeclarationStatement type="System.Reflection.PropertyInfo" name="propInfo">
                      <init>
                        <methodInvokeExpression methodName="GetProperty">
                          <target>
                            <variableReferenceExpression name="objectType"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="Name">
                              <arrayIndexerExpression>
                                <target>
                                  <propertyReferenceExpression name="Fields"/>
                                </target>
                                <indices>
                                  <variableReferenceExpression name="j"/>
                                </indices>
                              </arrayIndexerExpression>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityInequality">
                          <variableReferenceExpression name="propInfo"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <arrayIndexerExpression>
                            <target>
                              <variableReferenceExpression name="types"/>
                            </target>
                            <indices>
                              <variableReferenceExpression name="j"/>
                            </indices>
                          </arrayIndexerExpression>
                          <propertyReferenceExpression name="PropertyType">
                            <variableReferenceExpression name="propInfo"/>
                          </propertyReferenceExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </forStatement>
                <foreachStatement>
                  <variable type="System.Object[]" name="row"/>
                  <target>
                    <propertyReferenceExpression name="Rows"/>
                  </target>
                  <statements>
                    <variableDeclarationStatement type="T" name="instance">
                      <init>
                        <castExpression targetType="T">
                          <methodInvokeExpression  methodName="CreateInstance">
                            <target>
                              <propertyReferenceExpression name="Assembly">
                                <variableReferenceExpression name="objectType"/>
                              </propertyReferenceExpression>
                            </target>
                            <parameters>
                              <propertyReferenceExpression name="FullName">
                                <variableReferenceExpression name="objectType"/>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </castExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="System.Int32" name="i">
                      <init>
                        <primitiveExpression value="0"/>
                      </init>
                    </variableDeclarationStatement>
                    <foreachStatement>
                      <variable type="DataField" name="field"/>
                      <target>
                        <propertyReferenceExpression name="Fields"/>
                      </target>
                      <statements>
                        <tryStatement>
                          <statements>
                            <variableDeclarationStatement type="Type" name="fieldType">
                              <init>
                                <arrayIndexerExpression>
                                  <target>
                                    <variableReferenceExpression name="types"/>
                                  </target>
                                  <indices>
                                    <variableReferenceExpression name="i"/>
                                  </indices>
                                </arrayIndexerExpression>
                              </init>
                            </variableDeclarationStatement>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="IdentityInequality">
                                  <variableReferenceExpression name="fieldType"/>
                                  <primitiveExpression value="null"/>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <arrayIndexerExpression>
                                    <target>
                                      <variableReferenceExpression name="args"/>
                                    </target>
                                    <indices>
                                      <primitiveExpression value="0"/>
                                    </indices>
                                  </arrayIndexerExpression>
                                  <methodInvokeExpression methodName="ConvertToType">
                                    <target>
                                      <typeReferenceExpression type="DataControllerBase"/>
                                    </target>
                                    <parameters>
                                      <variableReferenceExpression name="fieldType"/>
                                      <arrayIndexerExpression>
                                        <target>
                                          <variableReferenceExpression name="row"/>
                                        </target>
                                        <indices>
                                          <variableReferenceExpression name="i"/>
                                        </indices>
                                      </arrayIndexerExpression>
                                    </parameters>
                                  </methodInvokeExpression>
                                </assignStatement>
                                <methodInvokeExpression methodName="InvokeMember">
                                  <target>
                                    <variableReferenceExpression name="objectType"/>
                                  </target>
                                  <parameters>
                                    <propertyReferenceExpression name="Name">
                                      <variableReferenceExpression name="field"/>
                                    </propertyReferenceExpression>
                                    <propertyReferenceExpression name="SetProperty">
                                      <typeReferenceExpression type="System.Reflection.BindingFlags"/>
                                    </propertyReferenceExpression>
                                    <primitiveExpression value="null"/>
                                    <variableReferenceExpression name="instance"/>
                                    <variableReferenceExpression name="args"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </trueStatements>
                            </conditionStatement>
                          </statements>
                          <catch exceptionType="Exception">
                          </catch>
                        </tryStatement>
                        <assignStatement>
                          <variableReferenceExpression name="i"/>
                          <binaryOperatorExpression operator="Add">
                            <variableReferenceExpression name="i"/>
                            <primitiveExpression value="1"/>
                          </binaryOperatorExpression>
                        </assignStatement>
                      </statements>
                    </foreachStatement>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <variableReferenceExpression name="list"/>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="instance"/>
                      </parameters>
                    </methodInvokeExpression>
                  </statements>
                </foreachStatement>
                <methodReturnStatement>
                  <variableReferenceExpression name="list"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- property CustomFilter -->
            <memberField type="SortedDictionary" name="customFilter">
              <typeArguments>
                <typeReference type="System.String"/>
                <typeReference type="System.Object"/>
              </typeArguments>
            </memberField>
            <!-- method CustomFilteredBy(string) -->
            <memberMethod returnType="System.Boolean" name="CustomFilteredBy">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="System.String" name="fieldName"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <binaryOperatorExpression operator="BooleanAnd">
                    <binaryOperatorExpression operator="IdentityInequality">
                      <fieldReferenceExpression name="customFilter"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                    <methodInvokeExpression methodName="ContainsKey">
                      <target>
                        <fieldReferenceExpression name="customFilter"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="fieldName"/>
                      </parameters>
                    </methodInvokeExpression>
                  </binaryOperatorExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method ApplyDataFilter(IDataFilter) -->
            <memberMethod name="ApplyDataFilter">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="IDataFilter" name="dataFilter"/>
                <parameter type="System.String" name="controller"/>
                <parameter type="System.String" name="view"/>
                <parameter type="System.String" name="lookupContextController"/>
                <parameter type="System.String" name="lookupContextView"/>
                <parameter type="System.String" name="lookupContextFieldName"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <argumentReferenceExpression name="dataFilter"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement/>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <fieldReferenceExpression name="filter"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <fieldReferenceExpression name="filter"/>
                      <arrayCreateExpression>
                        <createType type="System.String"/>
                        <sizeExpression>
                          <primitiveExpression value="0"/>
                        </sizeExpression>
                      </arrayCreateExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="IDataFilter2" name="dataFilter2">
                  <init>
                    <primitiveExpression value="null"/>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="IsInstanceOfType">
                      <target>
                        <typeofExpression type="IDataFilter2"/>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="dataFilter"/>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="dataFilter2"/>
                      <castExpression targetType="IDataFilter2">
                        <variableReferenceExpression name="dataFilter"/>
                      </castExpression>
                    </assignStatement>
                    <methodInvokeExpression methodName="AssignContext">
                      <target>
                        <variableReferenceExpression name="dataFilter2"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="controller"/>
                        <argumentReferenceExpression name="view"/>
                        <argumentReferenceExpression name="lookupContextController"/>
                        <argumentReferenceExpression name="lookupContextView"/>
                        <argumentReferenceExpression name="lookupContextFieldName"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="List" name="newFilter">
                  <typeArguments>
                    <typeReference type="System.String"/>
                  </typeArguments>
                  <init>
                    <objectCreateExpression type="List">
                      <typeArguments>
                        <typeReference type="System.String"/>
                      </typeArguments>
                      <parameters>
                        <fieldReferenceExpression name="filter"/>
                      </parameters>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <assignStatement>
                  <fieldReferenceExpression name="customFilter"/>
                  <objectCreateExpression type="SortedDictionary">
                    <typeArguments>
                      <typeReference type="System.String"/>
                      <typeReference type="System.Object"/>
                    </typeArguments>
                  </objectCreateExpression>
                </assignStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <variableReferenceExpression name="dataFilter2"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="Filter">
                      <target>
                        <variableReferenceExpression name="dataFilter2"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="controller"/>
                        <argumentReferenceExpression name="view"/>
                        <fieldReferenceExpression name="customFilter"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                  <falseStatements>
                    <methodInvokeExpression methodName="Filter">
                      <target>
                        <argumentReferenceExpression name="dataFilter"/>
                      </target>
                      <parameters>
                        <fieldReferenceExpression name="customFilter"/>
                      </parameters>
                    </methodInvokeExpression>
                  </falseStatements>
                </conditionStatement>
                <foreachStatement>
                  <variable type="System.String" name="key"/>
                  <target>
                    <propertyReferenceExpression name="Keys">
                      <fieldReferenceExpression name="customFilter"/>
                    </propertyReferenceExpression>
                  </target>
                  <statements>
                    <variableDeclarationStatement type="System.Object" name="v">
                      <init>
                        <arrayIndexerExpression>
                          <target>
                            <fieldReferenceExpression name="customFilter"/>
                          </target>
                          <indices>
                            <variableReferenceExpression name="key"/>
                          </indices>
                        </arrayIndexerExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanOr">
                          <binaryOperatorExpression operator="IdentityEquality">
                            <variableReferenceExpression name="v"/>
                            <primitiveExpression value="null"/>
                          </binaryOperatorExpression>
                          <unaryOperatorExpression operator="Not">
                            <propertyReferenceExpression name="IsArray">
                              <methodInvokeExpression methodName="GetType">
                                <target>
                                  <variableReferenceExpression name="v"/>
                                </target>
                              </methodInvokeExpression>
                            </propertyReferenceExpression>
                          </unaryOperatorExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="v"/>
                          <arrayCreateExpression>
                            <createType type="System.Object"/>
                            <initializers>
                              <variableReferenceExpression name="v"/>
                            </initializers>
                          </arrayCreateExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
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
                        <primitiveExpression value="{{0}}:"/>
                        <variableReferenceExpression name="key"/>
                      </parameters>
                    </methodInvokeExpression>
                    <foreachStatement>
                      <variable type="System.Object" name="item"/>
                      <target>
                        <castExpression targetType="Array">
                          <variableReferenceExpression name="v"/>
                        </castExpression>
                      </target>
                      <statements>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="IdentityInequality">
                              <variableReferenceExpression name="dataFilter2"/>
                              <primitiveExpression value="null"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="Append">
                              <target>
                                <variableReferenceExpression name="sb"/>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="item"/>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                          <falseStatements>
                            <methodInvokeExpression methodName="AppendFormat">
                              <target>
                                <variableReferenceExpression name="sb"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="={{0}}"/>
                                <variableReferenceExpression name="item"/>
                              </parameters>
                            </methodInvokeExpression>
                          </falseStatements>
                        </conditionStatement>
                        <methodInvokeExpression methodName="Append">
                          <target>
                            <variableReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <methodInvokeExpression methodName="ToChar">
                              <target>
                                <typeReferenceExpression type="Convert"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="0"/>
                              </parameters>
                            </methodInvokeExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </statements>
                    </foreachStatement>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <variableReferenceExpression name="newFilter"/>
                      </target>
                      <parameters>
                        <methodInvokeExpression methodName="ToString">
                          <target>
                            <variableReferenceExpression name="sb"/>
                          </target>
                        </methodInvokeExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </statements>
                </foreachStatement>
                <assignStatement>
                  <fieldReferenceExpression name="originalFilter"/>
                  <fieldReferenceExpression name="filter"/>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="filter"/>
                  <methodInvokeExpression methodName="ToArray">
                    <target>
                      <variableReferenceExpression name="newFilter"/>
                    </target>
                  </methodInvokeExpression>
                </assignStatement>
              </statements>
            </memberMethod>
            <!-- method UpdataFieldValue(string, object[], object) -->
            <memberMethod name="UpdateFieldValue">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="System.String" name="fieldName"/>
                <parameter type="System.Object[]" name="row"/>
                <parameter type="System.Object" name="value"/>
              </parameters>
              <statements>
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
                        <propertyReferenceExpression name="Fields"/>
                      </propertyReferenceExpression>
                    </binaryOperatorExpression>
                  </test>
                  <increment>
                    <variableReferenceExpression name="i"/>
                  </increment>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <methodInvokeExpression methodName="Equals">
                          <target>
                            <propertyReferenceExpression name="Name">
                              <arrayIndexerExpression>
                                <target>
                                  <propertyReferenceExpression name="Fields"/>
                                </target>
                                <indices>
                                  <variableReferenceExpression name="i"/>
                                </indices>
                              </arrayIndexerExpression>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <argumentReferenceExpression name="fieldName"/>
                            <propertyReferenceExpression name="InvariantCultureIgnoreCase">
                              <typeReferenceExpression type="StringComparison"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <arrayIndexerExpression>
                            <target>
                              <argumentReferenceExpression name="row"/>
                            </target>
                            <indices>
                              <variableReferenceExpression name="i"/>
                            </indices>
                          </arrayIndexerExpression>
                          <argumentReferenceExpression name="value"/>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </forStatement>
              </statements>
            </memberMethod>
            <!-- method SelectFieldValue(string, object[]) -->
            <memberMethod returnType="System.Object" name="SelectFieldValue">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="System.String" name="fieldName"/>
                <parameter type="System.Object[]" name="row"/>
              </parameters>
              <statements>
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
                        <propertyReferenceExpression name="Fields"/>
                      </propertyReferenceExpression>
                    </binaryOperatorExpression>
                  </test>
                  <increment>
                    <variableReferenceExpression name="i"/>
                  </increment>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <methodInvokeExpression methodName="Equals">
                          <target>
                            <propertyReferenceExpression name="Name">
                              <arrayIndexerExpression>
                                <target>
                                  <propertyReferenceExpression name="Fields"/>
                                </target>
                                <indices>
                                  <variableReferenceExpression name="i"/>
                                </indices>
                              </arrayIndexerExpression>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <argumentReferenceExpression name="fieldName"/>
                            <propertyReferenceExpression name="InvariantCultureIgnoreCase">
                              <typeReferenceExpression type="StringComparison"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </condition>
                      <trueStatements>
                        <methodReturnStatement>
                          <arrayIndexerExpression>
                            <target>
                              <argumentReferenceExpression name="row"/>
                            </target>
                            <indices>
                              <variableReferenceExpression name="i"/>
                            </indices>
                          </arrayIndexerExpression>
                        </methodReturnStatement>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </forStatement>
                <methodReturnStatement>
                  <primitiveExpression value="null"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method SelectFieldValueObject(string, object[]) -->
            <memberMethod returnType="FieldValue" name="SelectFieldValueObject">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="System.String" name="fieldName"/>
                <parameter type="System.Object[]" name="row"/>
              </parameters>
              <statements>
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
                        <propertyReferenceExpression name="Fields"/>
                      </propertyReferenceExpression>
                    </binaryOperatorExpression>
                  </test>
                  <increment>
                    <variableReferenceExpression name="i"/>
                  </increment>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <methodInvokeExpression methodName="Equals">
                          <target>
                            <propertyReferenceExpression name="Name">
                              <arrayIndexerExpression>
                                <target>
                                  <propertyReferenceExpression name="Fields"/>
                                </target>
                                <indices>
                                  <variableReferenceExpression name="i"/>
                                </indices>
                              </arrayIndexerExpression>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <argumentReferenceExpression name="fieldName"/>
                            <propertyReferenceExpression name="InvariantCultureIgnoreCase">
                              <typeReferenceExpression type="StringComparison"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </condition>
                      <trueStatements>
                        <methodReturnStatement>
                          <objectCreateExpression type="FieldValue">
                            <parameters>
                              <argumentReferenceExpression name="fieldName"/>
                              <arrayIndexerExpression>
                                <target>
                                  <argumentReferenceExpression name="row"/>
                                </target>
                                <indices>
                                  <variableReferenceExpression name="i"/>
                                </indices>
                              </arrayIndexerExpression>
                            </parameters>
                          </objectCreateExpression>
                        </methodReturnStatement>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </forStatement>
                <methodReturnStatement>
                  <primitiveExpression value="null"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- TODO
        private void AddPivotHeadersToFields()
        {
            if (_pivotColumns == null) return;
            foreach (DataField field in Fields)
                if (!field.Hidden && String.IsNullOrEmpty(field.Pivot))
                {
                    Match m = Regex.Match(field.Name, @"PivotCol(\d+)_(\w+)");
                    if (m.Success)
                    {
                        int rowIndex = Convert.ToInt32(m.Groups[1].Value);
                        if (rowIndex < _pivotColumns.Rows.Count)
                        {
                            string prefix = null;
                            foreach (DataColumn c in _pivotColumns.Columns)
                                if (c.DataType == typeof(String))
                                {
                                    prefix = Convert.ToString(_pivotColumns.Rows[rowIndex][c]);
                                    break;
                                }
                            if (String.IsNullOrEmpty(field.HeaderText))
                                field.Label = String.Format("{0} {1}", prefix, field.Label);
                            else
                                field.HeaderText = String.Format("{0} {1}", prefix, field.HeaderText);
                        }
                        else
                            field.Hidden = true;
                    }
                }
        }
            -->
            <!-- field pivotColumns -->
            <!--<memberField type="DataTable" name="pivotColumns"/>-->
            <!-- method AddPivotHeadersToField() -->
            <!--<memberMethod name="AddPivotHeadersToFields">
              <attributes public="true" final="true"/>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <fieldReferenceExpression name="pivotColumns"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement/>
                  </trueStatements>
                </conditionStatement>
                <foreachStatement>
                  <variable type="DataField" name="field"/>
                  <target>
                    <propertyReferenceExpression name="Fields"/>
                  </target>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanAnd">
                          <unaryOperatorExpression operator="Not">
                            <propertyReferenceExpression name="Hidden">
                              <variableReferenceExpression name="field"/>
                            </propertyReferenceExpression>
                          </unaryOperatorExpression>
                          <unaryOperatorExpression operator="IsNullOrEmpty">
                            <propertyReferenceExpression name="Pivot">
                              <variableReferenceExpression name="field"/>
                            </propertyReferenceExpression>
                          </unaryOperatorExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="Match" name="m">
                          <init>
                            <methodInvokeExpression methodName="Match">
                              <target>
                                <typeReferenceExpression type="Regex"/>
                              </target>
                              <parameters>
                                <propertyReferenceExpression name="Name">
                                  <variableReferenceExpression name="field"/>
                                </propertyReferenceExpression>
                                <primitiveExpression value="PivotCol(\d+)_(\w+)"/>
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
                                            <variableReferenceExpression name="m"/>
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
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="LessThan">
                                  <variableReferenceExpression name="rowIndex"/>
                                  <propertyReferenceExpression name="Count">
                                    <propertyReferenceExpression name="Rows">
                                      <fieldReferenceExpression name="pivotColumns"/>
                                    </propertyReferenceExpression>
                                  </propertyReferenceExpression>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <variableDeclarationStatement type="System.String" name="prefix">
                                  <init>
                                    <primitiveExpression value="null"/>
                                  </init>
                                </variableDeclarationStatement>
                                <foreachStatement>
                                  <variable type="DataColumn" name="c"/>
                                  <target>
                                    <propertyReferenceExpression name="Columns">
                                      <fieldReferenceExpression name="pivotColumns"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <statements>
                                    <conditionStatement>
                                      <condition>
                                        <binaryOperatorExpression operator="IdentityEquality">
                                          <propertyReferenceExpression name="DataType">
                                            <variableReferenceExpression name="c"/>
                                          </propertyReferenceExpression>
                                          <typeofExpression type="System.String"/>
                                        </binaryOperatorExpression>
                                      </condition>
                                      <trueStatements>
                                        <assignStatement>
                                          <variableReferenceExpression name="prefix"/>
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
                                                        <fieldReferenceExpression name="pivotColumns"/>
                                                      </propertyReferenceExpression>
                                                    </target>
                                                    <indices>
                                                      <variableReferenceExpression name="rowIndex"/>
                                                    </indices>
                                                  </arrayIndexerExpression>
                                                </target>
                                                <indices>
                                                  <variableReferenceExpression name="c"/>
                                                </indices>
                                              </arrayIndexerExpression>
                                            </parameters>
                                          </methodInvokeExpression>
                                        </assignStatement>
                                        <breakStatement/>
                                      </trueStatements>
                                    </conditionStatement>
                                  </statements>
                                </foreachStatement>
                                <conditionStatement>
                                  <condition>
                                    <unaryOperatorExpression operator="IsNullOrEmpty">
                                      <propertyReferenceExpression name="HeaderText">
                                        <variableReferenceExpression name="field"/>
                                      </propertyReferenceExpression>
                                    </unaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <assignStatement>
                                      <propertyReferenceExpression name="Label">
                                        <variableReferenceExpression name="field"/>
                                      </propertyReferenceExpression>
                                      <methodInvokeExpression methodName="Format">
                                        <target>
                                          <typeReferenceExpression type="String"/>
                                        </target>
                                        <parameters>
                                          <primitiveExpression value="{{0}} {{1}}"/>
                                          <variableReferenceExpression name="prefix"/>
                                          <propertyReferenceExpression name="Label">
                                            <variableReferenceExpression name="field"/>
                                          </propertyReferenceExpression>
                                        </parameters>
                                      </methodInvokeExpression>
                                    </assignStatement>
                                  </trueStatements>
                                  <falseStatements>
                                    <assignStatement>
                                      <propertyReferenceExpression name="HeaderText">
                                        <variableReferenceExpression name="field"/>
                                      </propertyReferenceExpression>
                                      <methodInvokeExpression methodName="Format">
                                        <target>
                                          <typeReferenceExpression type="String"/>
                                        </target>
                                        <parameters>
                                          <primitiveExpression value="{{0}} {{1}}"/>
                                          <variableReferenceExpression name="prefix"/>
                                          <propertyReferenceExpression name="HeaderText">
                                            <variableReferenceExpression name="field"/>
                                          </propertyReferenceExpression>
                                        </parameters>
                                      </methodInvokeExpression>
                                    </assignStatement>
                                  </falseStatements>
                                </conditionStatement>
                              </trueStatements>
                              <falseStatements>
                                <assignStatement>
                                  <propertyReferenceExpression name="Hidden">
                                    <variableReferenceExpression name="field"/>
                                  </propertyReferenceExpression>
                                  <primitiveExpression value="true"/>
                                </assignStatement>
                              </falseStatements>
                            </conditionStatement>
                          </trueStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
              </statements>
            </memberMethod>-->
            <!-- 
        private DataTable _pivotColumns;
        public DataTable EnumeratePivotColumns()
        {
            if (_pivotColumns == null)
                foreach (DataField field in Fields)
                    if (field.Pivot == "ColumnKey" && !field.Name.StartsWith("PivotCol"))
                    {
                        PageRequest request = new PageRequest();
                        request.Controller = field.ItemsDataController;
                        request.View = field.ItemsDataView;
                        request.RequiresMetaData = true;
                        request.PageIndex = 0;
                        request.PageSize = 10;
                        ViewPage page = ControllerFactory.CreateDataController().GetPage(field.ItemsDataController, field.ItemsDataView, request);
                        _pivotColumns = page.ToDataTable();
                        // rename columns
                        Match m = Regex.Match(field.Copy, @"(\w+)=(\w+)");
                        while (m.Success)
                        {
                            DataColumn c = _pivotColumns.Columns[m.Groups[2].Value];
                            if (c != null)
                                c.ColumnName = m.Groups[1].Value;
                            m = m.NextMatch();
                        }
                        break;
                    }
            return _pivotColumns;
        }            -->
            <!-- method EnumeratePivotColumns() -->
            <!--<memberMethod returnType="DataTable" name="EnumeratePivotColumns">
              <attributes public="true" final="true"/>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <fieldReferenceExpression name="pivotColumns"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <foreachStatement>
                      <variable type="DataField" name="field"/>
                      <target>
                        <propertyReferenceExpression name="Fields"/>
                      </target>
                      <statements>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="BooleanAnd">
                              <binaryOperatorExpression operator="ValueEquality">
                                <propertyReferenceExpression name="Pivot">
                                  <variableReferenceExpression name="field"/>
                                </propertyReferenceExpression>
                                <primitiveExpression value="ColumnKey"/>
                              </binaryOperatorExpression>
                              <unaryOperatorExpression operator="Not">
                                <methodInvokeExpression methodName="StartsWith">
                                  <target>
                                    <propertyReferenceExpression name="Name">
                                      <variableReferenceExpression name="field"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="PivotCol"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </unaryOperatorExpression>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <variableDeclarationStatement type="PageRequest" name="request">
                              <init>
                                <objectCreateExpression type="PageRequest"/>
                              </init>
                            </variableDeclarationStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="Controller">
                                <variableReferenceExpression name="request"/>
                              </propertyReferenceExpression>
                              <propertyReferenceExpression name="ItemsDataController">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                            </assignStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="View">
                                <variableReferenceExpression name="request"/>
                              </propertyReferenceExpression>
                              <propertyReferenceExpression name="ItemsDataView">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                            </assignStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="RequiresMetaData">
                                <variableReferenceExpression name="request"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="true"/>
                            </assignStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="PageIndex">
                                <variableReferenceExpression name="request"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="0"/>
                            </assignStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="PageSize">
                                <variableReferenceExpression name="request"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="10"/>
                            </assignStatement>
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
                                    <propertyReferenceExpression name="ItemsDataController">
                                      <variableReferenceExpression name="field"/>
                                    </propertyReferenceExpression>
                                    <propertyReferenceExpression name="ItemsDataView">
                                      <variableReferenceExpression name="field"/>
                                    </propertyReferenceExpression>
                                    <variableReferenceExpression name="request"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </init>
                            </variableDeclarationStatement>
                            <assignStatement>
                              <fieldReferenceExpression name="pivotColumns"/>
                              <methodInvokeExpression methodName="ToDataTable">
                                <target>
                                  <variableReferenceExpression name="page"/>
                                </target>
                              </methodInvokeExpression>
                            </assignStatement>
                            <comment>rename columns</comment>
                            <variableDeclarationStatement type="Match" name="m">
                              <init>
                                <methodInvokeExpression methodName="Match">
                                  <target>
                                    <typeReferenceExpression type="Regex"/>
                                  </target>
                                  <parameters>
                                    <propertyReferenceExpression name="Copy">
                                      <variableReferenceExpression name="field"/>
                                    </propertyReferenceExpression>
                                    <primitiveExpression value="(\w+)=(\w+)"/>
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
                                <variableDeclarationStatement type="DataColumn" name="c">
                                  <init>
                                    <arrayIndexerExpression>
                                      <target>
                                        <propertyReferenceExpression name="Columns">
                                          <fieldReferenceExpression name="pivotColumns"/>
                                        </propertyReferenceExpression>
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
                                              <primitiveExpression value="2"/>
                                            </indices>
                                          </arrayIndexerExpression>
                                        </propertyReferenceExpression>
                                      </indices>
                                    </arrayIndexerExpression>
                                  </init>
                                </variableDeclarationStatement>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="IdentityInequality">
                                      <variableReferenceExpression name="c"/>
                                      <primitiveExpression value="null"/>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <assignStatement>
                                      <propertyReferenceExpression name="ColumnName">
                                        <variableReferenceExpression name="c"/>
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
                                </conditionStatement>
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
                            <breakStatement/>
                          </trueStatements>
                        </conditionStatement>
                      </statements>
                    </foreachStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <fieldReferenceExpression name="pivotColumns"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>-->
            <!-- method RemoveFromFilter(string) -->
            <memberMethod name="RemoveFromFilter">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="System.String" name="fieldName"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <fieldReferenceExpression name="filter"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement/>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="List" name="newFilter">
                  <typeArguments>
                    <typeReference type="System.String"/>
                  </typeArguments>
                  <init>
                    <objectCreateExpression type="List">
                      <typeArguments>
                        <typeReference type="System.String"/>
                      </typeArguments>
                      <parameters>
                        <fieldReferenceExpression name="filter"/>
                      </parameters>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.String" name="prefix">
                  <init>
                    <binaryOperatorExpression operator="Add">
                      <argumentReferenceExpression name="fieldName"/>
                      <primitiveExpression value=":"/>
                    </binaryOperatorExpression>
                  </init>
                </variableDeclarationStatement>
                <foreachStatement>
                  <variable type="System.String" name="s"/>
                  <target>
                    <variableReferenceExpression name="newFilter"/>
                  </target>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <methodInvokeExpression methodName="StartsWith">
                          <target>
                            <variableReferenceExpression name="s"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="prefix"/>
                          </parameters>
                        </methodInvokeExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="Remove">
                          <target>
                            <variableReferenceExpression name="newFilter"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="s"/>
                          </parameters>
                        </methodInvokeExpression>
                        <breakStatement/>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
                <assignStatement>
                  <fieldReferenceExpression name="filter"/>
                  <methodInvokeExpression methodName="ToArray">
                    <target>
                      <variableReferenceExpression name="newFilter"/>
                    </target>
                  </methodInvokeExpression>
                </assignStatement>
              </statements>
            </memberMethod>
            <!-- method RequiresResultSet -->
            <memberMethod returnType="System.Boolean" name="RequiresResultSet">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="CommandConfigurationType" name="configuration"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="IsNotNullOrEmpty">
                      <propertyReferenceExpression name="QuickFindHint"/>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="true"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <fieldReferenceExpression name="filter"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <foreachStatement>
                      <variable type="System.String" name="s"/>
                      <target>
                        <fieldReferenceExpression name="filter"/>
                      </target>
                      <statements>
                        <variableDeclarationStatement type="Match" name="m">
                          <init>
                            <methodInvokeExpression methodName="Match">
                              <target>
                                <propertyReferenceExpression name="FilterExpressionRegex">
                                  <typeReferenceExpression type="DataControllerBase"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="s"/>
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="ValueEquality">
                              <propertyReferenceExpression name="Success">
                                <variableReferenceExpression name="m"/>
                              </propertyReferenceExpression>
                              <methodInvokeExpression methodName="Contains">
                                <target>
                                  <propertyReferenceExpression name="Value">
                                    <arrayIndexerExpression>
                                      <target>
                                        <propertyReferenceExpression name="Groups">
                                          <variableReferenceExpression name="m"/>
                                        </propertyReferenceExpression>
                                      </target>
                                      <indices>
                                        <primitiveExpression value="Alias"/>
                                      </indices>
                                    </arrayIndexerExpression>
                                  </propertyReferenceExpression>
                                </target>
                                <parameters>
                                  <primitiveExpression value=","/>
                                </parameters>
                              </methodInvokeExpression>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <methodReturnStatement>
                              <primitiveExpression value="true"/>
                            </methodReturnStatement>
                          </trueStatements>
                        </conditionStatement>
                      </statements>
                    </foreachStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <primitiveExpression value="false"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- field stringNumSplitter-->
            <memberField type="Regex" name="stringNumSplitter">
              <attributes static="true" private="true"/>
              <init>
                <objectCreateExpression type="Regex">
                  <parameters>
                    <primitiveExpression value="(?'PropertyName'.+?)(?'PropertyValue'\d+)?$"/>
                  </parameters>
                </objectCreateExpression>
              </init>
            </memberField>
            <!-- method AddPivotField(DataField)-->
            <memberMethod name="AddPivotField">
              <attributes public="true"/>
              <parameters>
                <parameter type="DataField" name="field"/>
              </parameters>
              <statements>
                <comment>process tags</comment>
                <foreachStatement>
                  <variable type="System.String" name="tag"/>
                  <target>
                    <methodInvokeExpression methodName="Split">
                      <target>
                        <propertyReferenceExpression name="Tag">
                          <argumentReferenceExpression name="field"/>
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
                        <variableDeclarationStatement type="System.String[]" name="properties">
                          <init>
                            <methodInvokeExpression methodName="Split">
                              <target>
                                <variableReferenceExpression name="tag"/>
                              </target>
                              <parameters>
                                <primitiveExpression convertTo="Char" value="-"/>
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="GreaterThanOrEqual">
                              <propertyReferenceExpression name="Length">
                                <variableReferenceExpression name="properties"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="2"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <comment>populate properties</comment>
                            <variableDeclarationStatement type="System.Int32" name="pivotID">
                              <init>
                                <primitiveExpression value="0"/>
                              </init>
                            </variableDeclarationStatement>
                            <variableDeclarationStatement type="System.String" name="chartType">
                              <init>
                                <stringEmptyExpression/>
                              </init>
                            </variableDeclarationStatement>
                            <variableDeclarationStatement type="System.String" name="fieldType">
                              <init>
                                <stringEmptyExpression/>
                              </init>
                            </variableDeclarationStatement>
                            <variableDeclarationStatement type="System.Boolean" name="subtotalsEnabled">
                              <init>
                                <primitiveExpression value="false"/>
                              </init>
                            </variableDeclarationStatement>
                            <variableDeclarationStatement type="System.Boolean" name="grandTotalsEnabled">
                              <init>
                                <primitiveExpression value="false"/>
                              </init>
                            </variableDeclarationStatement>
                            <variableDeclarationStatement type="System.Int32" name="fieldTypeIndex">
                              <init>
                                <primitiveExpression value="0"/>
                              </init>
                            </variableDeclarationStatement>
                            <variableDeclarationStatement type="Dictionary" name="additionalProperties">
                              <typeArguments>
                                <typeReference type="System.String"/>
                                <typeReference type="System.Object"/>
                              </typeArguments>
                              <init>
                                <objectCreateExpression type="Dictionary">
                                  <typeArguments>
                                    <typeReference type="System.String"/>
                                    <typeReference type="System.Object"/>
                                  </typeArguments>
                                </objectCreateExpression>
                              </init>
                            </variableDeclarationStatement>
                            <foreachStatement>
                              <variable type="System.String" name="property"/>
                              <target>
                                <variableReferenceExpression name="properties"/>
                              </target>
                              <statements>
                                <variableDeclarationStatement type="Match" name="match">
                                  <init>
                                    <methodInvokeExpression methodName="Match">
                                      <target>
                                        <fieldReferenceExpression name="stringNumSplitter"/>
                                      </target>
                                      <parameters>
                                        <variableReferenceExpression name="property"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </init>
                                </variableDeclarationStatement>
                                <conditionStatement>
                                  <condition>
                                    <propertyReferenceExpression name="Success">
                                      <variableReferenceExpression name="match"/>
                                    </propertyReferenceExpression>
                                  </condition>
                                  <trueStatements>
                                    <variableDeclarationStatement type="System.String" name="propertyName">
                                      <init>
                                        <castExpression targetType="System.String">
                                          <methodInvokeExpression methodName="Trim">
                                            <target>
                                              <methodInvokeExpression methodName="ToLower">
                                                <target>
                                                  <propertyReferenceExpression name="Value">
                                                    <arrayIndexerExpression>
                                                      <target>
                                                        <propertyReferenceExpression name="Groups">
                                                          <variableReferenceExpression name="match"/>
                                                        </propertyReferenceExpression>
                                                      </target>
                                                      <indices>
                                                        <primitiveExpression value="PropertyName"/>
                                                      </indices>
                                                    </arrayIndexerExpression>
                                                  </propertyReferenceExpression>
                                                </target>
                                              </methodInvokeExpression>
                                            </target>
                                          </methodInvokeExpression>
                                        </castExpression>
                                      </init>
                                    </variableDeclarationStatement>
                                    <variableDeclarationStatement type="System.Int32" name="propertyValue"/>
                                    <conditionStatement>
                                      <condition>
                                        <unaryOperatorExpression operator="Not">
                                          <methodInvokeExpression methodName="TryParse">
                                            <target>
                                              <typeReferenceExpression type="System.Int32"/>
                                            </target>
                                            <parameters>
                                              <propertyReferenceExpression name="Value">
                                                <arrayIndexerExpression>
                                                  <target>
                                                    <propertyReferenceExpression name="Groups">
                                                      <variableReferenceExpression name="match"/>
                                                    </propertyReferenceExpression>
                                                  </target>
                                                  <indices>
                                                    <primitiveExpression value="PropertyValue"/>
                                                  </indices>
                                                </arrayIndexerExpression>
                                              </propertyReferenceExpression>
                                              <directionExpression direction="Out">
                                                <variableReferenceExpression name="propertyValue"/>
                                              </directionExpression>
                                            </parameters>
                                          </methodInvokeExpression>
                                        </unaryOperatorExpression>
                                      </condition>
                                      <trueStatements>
                                        <assignStatement>
                                          <variableReferenceExpression name="propertyValue"/>
                                          <primitiveExpression value="0"/>
                                        </assignStatement>
                                      </trueStatements>
                                    </conditionStatement>
                                    <conditionStatement>
                                      <!-- pivot -->
                                      <condition>
                                        <binaryOperatorExpression operator="ValueEquality">
                                          <variableReferenceExpression name="propertyName"/>
                                          <primitiveExpression value="pivot"/>
                                        </binaryOperatorExpression>
                                      </condition>
                                      <trueStatements>
                                        <assignStatement>
                                          <variableReferenceExpression name="pivotID"/>
                                          <variableReferenceExpression name="propertyValue"/>
                                        </assignStatement>
                                      </trueStatements>
                                      <falseStatements>
                                        <conditionStatement>
                                          <!-- row,col,val,value-->
                                          <condition>
                                            <binaryOperatorExpression operator="BooleanOr">
                                              <binaryOperatorExpression operator="BooleanOr">
                                                <binaryOperatorExpression operator="ValueEquality">
                                                  <variableReferenceExpression name="propertyName"/>
                                                  <primitiveExpression value="row"/>
                                                </binaryOperatorExpression>
                                                <binaryOperatorExpression operator="ValueEquality">
                                                  <variableReferenceExpression name="propertyName"/>
                                                  <primitiveExpression value="col"/>
                                                </binaryOperatorExpression>
                                              </binaryOperatorExpression>
                                              <binaryOperatorExpression operator="BooleanOr">
                                                <binaryOperatorExpression operator="ValueEquality">
                                                  <variableReferenceExpression name="propertyName"/>
                                                  <primitiveExpression value="val"/>
                                                </binaryOperatorExpression>
                                                <binaryOperatorExpression operator="ValueEquality">
                                                  <variableReferenceExpression name="propertyName"/>
                                                  <primitiveExpression value="value"/>
                                                </binaryOperatorExpression>
                                              </binaryOperatorExpression>
                                            </binaryOperatorExpression>
                                          </condition>
                                          <trueStatements>
                                            <assignStatement>
                                              <variableReferenceExpression name="fieldType"/>
                                              <variableReferenceExpression name="propertyName"/>
                                            </assignStatement>
                                            <assignStatement>
                                              <variableReferenceExpression name="fieldTypeIndex"/>
                                              <variableReferenceExpression name="propertyValue"/>
                                            </assignStatement>
                                          </trueStatements>
                                          <falseStatements>
                                            <conditionStatement>
                                              <!-- column-->
                                              <condition>
                                                <binaryOperatorExpression operator="ValueEquality">
                                                  <variableReferenceExpression name="propertyName"/>
                                                  <primitiveExpression value="column"/>
                                                </binaryOperatorExpression>
                                              </condition>
                                              <trueStatements>
                                                <conditionStatement>
                                                  <condition>
                                                    <binaryOperatorExpression operator="ValueEquality">
                                                      <variableReferenceExpression name="propertyValue"/>
                                                      <primitiveExpression value="0"/>
                                                    </binaryOperatorExpression>
                                                  </condition>
                                                  <trueStatements>
                                                    <assignStatement>
                                                      <variableReferenceExpression name="pivotID"/>
                                                      <variableReferenceExpression name="propertyValue"/>
                                                    </assignStatement>
                                                  </trueStatements>
                                                  <falseStatements>
                                                    <assignStatement>
                                                      <variableReferenceExpression name="fieldType"/>
                                                      <variableReferenceExpression name="propertyName"/>
                                                    </assignStatement>
                                                    <assignStatement>
                                                      <variableReferenceExpression name="fieldTypeIndex"/>
                                                      <variableReferenceExpression name="propertyValue"/>
                                                    </assignStatement>
                                                  </falseStatements>
                                                </conditionStatement>
                                              </trueStatements>
                                              <falseStatements>
                                                <conditionStatement>
                                                  <condition>
                                                    <!-- subtotal-->
                                                    <binaryOperatorExpression operator="BooleanOr">
                                                      <binaryOperatorExpression operator="ValueEquality">
                                                        <variableReferenceExpression name="propertyName"/>
                                                        <primitiveExpression value="subtotal"/>
                                                      </binaryOperatorExpression>
                                                      <binaryOperatorExpression operator="ValueEquality">
                                                        <variableReferenceExpression name="propertyName"/>
                                                        <primitiveExpression value="subtotals"/>
                                                      </binaryOperatorExpression>
                                                    </binaryOperatorExpression>
                                                  </condition>
                                                  <trueStatements>
                                                    <assignStatement>
                                                      <variableReferenceExpression name="subtotalsEnabled"/>
                                                      <primitiveExpression value="true"/>
                                                    </assignStatement>
                                                  </trueStatements>
                                                  <falseStatements>
                                                    <conditionStatement>
                                                      <condition>
                                                        <!-- grand total-->
                                                        <binaryOperatorExpression operator="BooleanOr">
                                                          <binaryOperatorExpression operator="ValueEquality">
                                                            <variableReferenceExpression name="propertyName"/>
                                                            <primitiveExpression value="grandtotal"/>
                                                          </binaryOperatorExpression>
                                                          <binaryOperatorExpression operator="ValueEquality">
                                                            <variableReferenceExpression name="propertyName"/>
                                                            <primitiveExpression value="grandtotals"/>
                                                          </binaryOperatorExpression>
                                                        </binaryOperatorExpression>
                                                      </condition>
                                                      <trueStatements>
                                                        <assignStatement>
                                                          <variableReferenceExpression name="grandTotalsEnabled"/>
                                                          <primitiveExpression value="true"/>
                                                        </assignStatement>
                                                      </trueStatements>
                                                      <falseStatements>
                                                        <conditionStatement>
                                                          <!-- chart types-->
                                                          <condition>
                                                            <binaryOperatorExpression operator="BooleanOr">
                                                              <binaryOperatorExpression operator="BooleanOr">
                                                                <binaryOperatorExpression operator="BooleanOr">
                                                                  <binaryOperatorExpression operator="BooleanOr">
                                                                    <binaryOperatorExpression operator="BooleanOr">
                                                                      <binaryOperatorExpression operator="ValueEquality">
                                                                        <variableReferenceExpression name="propertyName"/>
                                                                        <primitiveExpression value="annotation"/>
                                                                      </binaryOperatorExpression>
                                                                      <binaryOperatorExpression operator="ValueEquality">
                                                                        <variableReferenceExpression name="propertyName"/>
                                                                        <primitiveExpression value="area"/>
                                                                      </binaryOperatorExpression>
                                                                    </binaryOperatorExpression>
                                                                    <binaryOperatorExpression operator="BooleanOr">
                                                                      <binaryOperatorExpression operator="ValueEquality">
                                                                        <variableReferenceExpression name="propertyName"/>
                                                                        <primitiveExpression value="bar"/>
                                                                      </binaryOperatorExpression>
                                                                      <binaryOperatorExpression operator="ValueEquality">
                                                                        <variableReferenceExpression name="propertyName"/>
                                                                        <primitiveExpression value="bubble"/>
                                                                      </binaryOperatorExpression>
                                                                    </binaryOperatorExpression>
                                                                  </binaryOperatorExpression>
                                                                  <binaryOperatorExpression operator="BooleanOr">
                                                                    <binaryOperatorExpression operator="BooleanOr">
                                                                      <binaryOperatorExpression operator="ValueEquality">
                                                                        <variableReferenceExpression name="propertyName"/>
                                                                        <primitiveExpression value="calendar"/>
                                                                      </binaryOperatorExpression>
                                                                      <binaryOperatorExpression operator="ValueEquality">
                                                                        <variableReferenceExpression name="propertyName"/>
                                                                        <primitiveExpression value="candlestick"/>
                                                                      </binaryOperatorExpression>
                                                                    </binaryOperatorExpression>
                                                                    <binaryOperatorExpression operator="BooleanOr">
                                                                      <binaryOperatorExpression operator="ValueEquality">
                                                                        <variableReferenceExpression name="propertyName"/>
                                                                        <primitiveExpression value="combo"/>
                                                                      </binaryOperatorExpression>
                                                                      <binaryOperatorExpression operator="ValueEquality">
                                                                        <variableReferenceExpression name="propertyName"/>
                                                                        <primitiveExpression value="diff"/>
                                                                      </binaryOperatorExpression>
                                                                    </binaryOperatorExpression>
                                                                  </binaryOperatorExpression>
                                                                </binaryOperatorExpression>
                                                                <binaryOperatorExpression operator="BooleanOr">
                                                                  <binaryOperatorExpression operator="BooleanOr">
                                                                    <binaryOperatorExpression operator="BooleanOr">
                                                                      <binaryOperatorExpression operator="ValueEquality">
                                                                        <variableReferenceExpression name="propertyName"/>
                                                                        <primitiveExpression value="gauge"/>
                                                                      </binaryOperatorExpression>
                                                                      <binaryOperatorExpression operator="ValueEquality">
                                                                        <variableReferenceExpression name="propertyName"/>
                                                                        <primitiveExpression value="geo"/>
                                                                      </binaryOperatorExpression>
                                                                    </binaryOperatorExpression>
                                                                    <binaryOperatorExpression operator="BooleanOr">
                                                                      <binaryOperatorExpression operator="ValueEquality">
                                                                        <variableReferenceExpression name="propertyName"/>
                                                                        <primitiveExpression value="histogram"/>
                                                                      </binaryOperatorExpression>
                                                                      <binaryOperatorExpression operator="ValueEquality">
                                                                        <variableReferenceExpression name="propertyName"/>
                                                                        <primitiveExpression value="interval"/>
                                                                      </binaryOperatorExpression>
                                                                    </binaryOperatorExpression>
                                                                  </binaryOperatorExpression>
                                                                  <binaryOperatorExpression operator="BooleanOr">
                                                                    <binaryOperatorExpression operator="BooleanOr">
                                                                      <binaryOperatorExpression operator="ValueEquality">
                                                                        <variableReferenceExpression name="propertyName"/>
                                                                        <primitiveExpression value="line"/>
                                                                      </binaryOperatorExpression>
                                                                      <binaryOperatorExpression operator="ValueEquality">
                                                                        <variableReferenceExpression name="propertyName"/>
                                                                        <primitiveExpression value="map"/>
                                                                      </binaryOperatorExpression>
                                                                    </binaryOperatorExpression>
                                                                    <binaryOperatorExpression operator="BooleanOr">
                                                                      <binaryOperatorExpression operator="ValueEquality">
                                                                        <variableReferenceExpression name="propertyName"/>
                                                                        <primitiveExpression value="org"/>
                                                                      </binaryOperatorExpression>
                                                                      <binaryOperatorExpression operator="ValueEquality">
                                                                        <variableReferenceExpression name="propertyName"/>
                                                                        <primitiveExpression value="pie"/>
                                                                      </binaryOperatorExpression>
                                                                    </binaryOperatorExpression>
                                                                  </binaryOperatorExpression>
                                                                </binaryOperatorExpression>
                                                              </binaryOperatorExpression>
                                                              <binaryOperatorExpression operator="BooleanOr">
                                                                <binaryOperatorExpression operator="BooleanOr">
                                                                  <binaryOperatorExpression operator="BooleanOr">
                                                                    <binaryOperatorExpression operator="BooleanOr">
                                                                      <binaryOperatorExpression operator="ValueEquality">
                                                                        <variableReferenceExpression name="propertyName"/>
                                                                        <primitiveExpression value="pie3d"/>
                                                                      </binaryOperatorExpression>
                                                                      <binaryOperatorExpression operator="ValueEquality">
                                                                        <variableReferenceExpression name="propertyName"/>
                                                                        <primitiveExpression value="donut"/>
                                                                      </binaryOperatorExpression>
                                                                    </binaryOperatorExpression>
                                                                    <binaryOperatorExpression operator="BooleanOr">
                                                                      <binaryOperatorExpression operator="ValueEquality">
                                                                        <variableReferenceExpression name="propertyName"/>
                                                                        <primitiveExpression value="sankey"/>
                                                                      </binaryOperatorExpression>
                                                                      <binaryOperatorExpression operator="ValueEquality">
                                                                        <variableReferenceExpression name="propertyName"/>
                                                                        <primitiveExpression value="scatter"/>
                                                                      </binaryOperatorExpression>
                                                                    </binaryOperatorExpression>
                                                                  </binaryOperatorExpression>
                                                                  <binaryOperatorExpression operator="BooleanOr">
                                                                    <binaryOperatorExpression operator="BooleanOr">
                                                                      <binaryOperatorExpression operator="ValueEquality">
                                                                        <variableReferenceExpression name="propertyName"/>
                                                                        <primitiveExpression value="steppedarea"/>
                                                                      </binaryOperatorExpression>
                                                                      <binaryOperatorExpression operator="ValueEquality">
                                                                        <variableReferenceExpression name="propertyName"/>
                                                                        <primitiveExpression value="table"/>
                                                                      </binaryOperatorExpression>
                                                                    </binaryOperatorExpression>
                                                                    <binaryOperatorExpression operator="BooleanOr">
                                                                      <binaryOperatorExpression operator="ValueEquality">
                                                                        <variableReferenceExpression name="propertyName"/>
                                                                        <primitiveExpression value="timeline"/>
                                                                      </binaryOperatorExpression>
                                                                      <binaryOperatorExpression operator="ValueEquality">
                                                                        <variableReferenceExpression name="propertyName"/>
                                                                        <primitiveExpression value="treemap"/>
                                                                      </binaryOperatorExpression>
                                                                    </binaryOperatorExpression>
                                                                  </binaryOperatorExpression>
                                                                </binaryOperatorExpression>
                                                                <binaryOperatorExpression operator="BooleanOr">
                                                                  <binaryOperatorExpression operator="ValueEquality">
                                                                    <variableReferenceExpression name="propertyName"/>
                                                                    <primitiveExpression value="trendline"/>
                                                                  </binaryOperatorExpression>
                                                                  <binaryOperatorExpression operator="ValueEquality">
                                                                    <variableReferenceExpression name="propertyName"/>
                                                                    <primitiveExpression value="wordtree"/>
                                                                  </binaryOperatorExpression>
                                                                </binaryOperatorExpression>
                                                              </binaryOperatorExpression>
                                                            </binaryOperatorExpression>
                                                          </condition>
                                                          <trueStatements>
                                                            <assignStatement>
                                                              <variableReferenceExpression name="chartType"/>
                                                              <variableReferenceExpression name="propertyName"/>
                                                            </assignStatement>
                                                          </trueStatements>
                                                          <falseStatements>
                                                            <methodInvokeExpression methodName="Add">
                                                              <target>
                                                                <variableReferenceExpression name="additionalProperties"/>
                                                              </target>
                                                              <parameters>
                                                                <methodInvokeExpression methodName="ToLower">
                                                                  <target>
                                                                    <variableReferenceExpression name="propertyName"/>
                                                                  </target>
                                                                </methodInvokeExpression>
                                                                <variableReferenceExpression name="propertyValue"/>
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
                                  </trueStatements>
                                </conditionStatement>
                              </statements>
                            </foreachStatement>
                            <comment>get or add pivot</comment>
                            <variableDeclarationStatement type="PivotTable" name="pivot"/>
                            <conditionStatement>
                              <condition>
                                <unaryOperatorExpression operator="Not">
                                  <methodInvokeExpression methodName="ContainsKey">
                                    <target>
                                      <fieldReferenceExpression name="pivots"/>
                                    </target>
                                    <parameters>
                                      <variableReferenceExpression name="pivotID"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                </unaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="pivot"/>
                                  <objectCreateExpression type="PivotTable">
                                    <parameters>
                                      <variableReferenceExpression name="pivotID"/>
                                      <thisReferenceExpression/>
                                    </parameters>
                                  </objectCreateExpression>
                                </assignStatement>
                                <methodInvokeExpression methodName="Add">
                                  <target>
                                    <fieldReferenceExpression name="pivots"/>
                                  </target>
                                  <parameters>
                                    <variableReferenceExpression name="pivotID"/>
                                    <variableReferenceExpression name="pivot"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </trueStatements>
                              <falseStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="pivot"/>
                                  <arrayIndexerExpression>
                                    <target>
                                      <fieldReferenceExpression name="pivots"/>
                                    </target>
                                    <indices>
                                      <variableReferenceExpression name="pivotID"/>
                                    </indices>
                                  </arrayIndexerExpression>
                                </assignStatement>
                              </falseStatements>
                            </conditionStatement>
                            <conditionStatement>
                              <condition>
                                <unaryOperatorExpression operator="IsNotNullOrEmpty">
                                  <variableReferenceExpression name="chartType"/>
                                </unaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <propertyReferenceExpression name="ChartType">
                                    <variableReferenceExpression name="pivot"/>
                                  </propertyReferenceExpression>
                                  <variableReferenceExpression name="chartType"/>
                                </assignStatement>
                              </trueStatements>
                            </conditionStatement>
                            <conditionStatement>
                              <condition>
                                <variableReferenceExpression name="subtotalsEnabled"/>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <propertyReferenceExpression name="SubtotalsEnabled">
                                    <variableReferenceExpression name="pivot"/>
                                  </propertyReferenceExpression>
                                  <primitiveExpression value="true"/>
                                </assignStatement>
                              </trueStatements>
                            </conditionStatement>
                            <conditionStatement>
                              <condition>
                                <variableReferenceExpression name="grandTotalsEnabled"/>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <propertyReferenceExpression name="GrandTotalsEnabled">
                                    <variableReferenceExpression name="pivot"/>
                                  </propertyReferenceExpression>
                                  <primitiveExpression value="true"/>
                                </assignStatement>
                              </trueStatements>
                            </conditionStatement>
                            <comment>add field to pivot</comment>
                            <conditionStatement>
                              <condition>
                                <unaryOperatorExpression operator="IsNotNullOrEmpty">
                                  <variableReferenceExpression name="fieldType"/>
                                </unaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <variableDeclarationStatement type="FieldInfo" name="fi">
                                  <init>
                                    <objectCreateExpression type="FieldInfo">
                                      <parameters>
                                        <argumentReferenceExpression name="field"/>
                                      </parameters>
                                    </objectCreateExpression>
                                  </init>
                                </variableDeclarationStatement>
                                <comment>check properties</comment>
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
                                        <variableReferenceExpression name="additionalProperties"/>
                                      </propertyReferenceExpression>
                                    </binaryOperatorExpression>
                                  </test>
                                  <increment>
                                    <variableReferenceExpression name="i"/>
                                  </increment>
                                  <statements>
                                    <variableDeclarationStatement type="KeyValuePair" name="kvp">
                                      <typeArguments>
                                        <typeReference type="System.String"/>
                                        <typeReference type="System.Object"/>
                                      </typeArguments>
                                      <init>
                                        <methodInvokeExpression methodName="ElementAt">
                                          <target>
                                            <variableReferenceExpression name="additionalProperties"/>
                                          </target>
                                          <parameters>
                                            <variableReferenceExpression name="i"/>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </init>
                                    </variableDeclarationStatement>
                                    <variableDeclarationStatement type="System.Boolean" name="remove">
                                      <init>
                                        <primitiveExpression value="true"/>
                                      </init>
                                    </variableDeclarationStatement>
                                    <variableDeclarationStatement type="System.String" name="property">
                                      <init>
                                        <propertyReferenceExpression name="Key">
                                          <variableReferenceExpression name="kvp"/>
                                        </propertyReferenceExpression>
                                      </init>
                                    </variableDeclarationStatement>
                                    <conditionStatement>
                                      <!-- sum, min, max, average, avg-->
                                      <condition>
                                        <binaryOperatorExpression operator="BooleanOr">
                                          <binaryOperatorExpression operator="BooleanOr">
                                            <binaryOperatorExpression operator="ValueEquality">
                                              <variableReferenceExpression name="property"/>
                                              <primitiveExpression value="sum"/>
                                            </binaryOperatorExpression>
                                            <binaryOperatorExpression operator="ValueEquality">
                                              <variableReferenceExpression name="property"/>
                                              <primitiveExpression value="min"/>
                                            </binaryOperatorExpression>
                                          </binaryOperatorExpression>
                                          <binaryOperatorExpression operator="BooleanOr">
                                            <binaryOperatorExpression operator="ValueEquality">
                                              <variableReferenceExpression name="property"/>
                                              <primitiveExpression value="max"/>
                                            </binaryOperatorExpression>
                                            <binaryOperatorExpression operator="BooleanOr">
                                              <binaryOperatorExpression operator="ValueEquality">
                                                <variableReferenceExpression name="property"/>
                                                <primitiveExpression value="avg"/>
                                              </binaryOperatorExpression>
                                              <binaryOperatorExpression operator="ValueEquality">
                                                <variableReferenceExpression name="property"/>
                                                <primitiveExpression value="average"/>
                                              </binaryOperatorExpression>
                                            </binaryOperatorExpression>
                                          </binaryOperatorExpression>
                                        </binaryOperatorExpression>
                                      </condition>
                                      <trueStatements>
                                        <assignStatement>
                                          <propertyReferenceExpression name="Mode">
                                            <variableReferenceExpression name="fi"/>
                                          </propertyReferenceExpression>
                                          <variableReferenceExpression name="property"/>
                                        </assignStatement>
                                      </trueStatements>
                                      <falseStatements>
                                        <conditionStatement>
                                          <!-- buckets-->
                                          <condition>
                                            <binaryOperatorExpression operator="BooleanOr">
                                              <binaryOperatorExpression operator="BooleanOr">
                                                <binaryOperatorExpression operator="BooleanOr">
                                                  <binaryOperatorExpression operator="BooleanOr">
                                                    <binaryOperatorExpression operator="ValueEquality">
                                                      <variableReferenceExpression name="property"/>
                                                      <primitiveExpression value="timeofday"/>
                                                    </binaryOperatorExpression>
                                                    <binaryOperatorExpression operator="ValueEquality">
                                                      <variableReferenceExpression name="property"/>
                                                      <primitiveExpression value="second"/>
                                                    </binaryOperatorExpression>
                                                  </binaryOperatorExpression>
                                                  <binaryOperatorExpression operator="BooleanOr">
                                                    <binaryOperatorExpression operator="ValueEquality">
                                                      <variableReferenceExpression name="property"/>
                                                      <primitiveExpression value="minute"/>
                                                    </binaryOperatorExpression>
                                                    <binaryOperatorExpression operator="ValueEquality">
                                                      <variableReferenceExpression name="property"/>
                                                      <primitiveExpression value="halfhour"/>
                                                    </binaryOperatorExpression>
                                                  </binaryOperatorExpression>
                                                </binaryOperatorExpression>
                                                <binaryOperatorExpression operator="BooleanOr">
                                                  <binaryOperatorExpression operator="BooleanOr">
                                                    <binaryOperatorExpression operator="ValueEquality">
                                                      <variableReferenceExpression name="property"/>
                                                      <primitiveExpression value="hour"/>
                                                    </binaryOperatorExpression>
                                                    <binaryOperatorExpression operator="ValueEquality">
                                                      <variableReferenceExpression name="property"/>
                                                      <primitiveExpression value="day"/>
                                                    </binaryOperatorExpression>
                                                  </binaryOperatorExpression>
                                                  <binaryOperatorExpression operator="BooleanOr">
                                                    <binaryOperatorExpression operator="ValueEquality">
                                                      <variableReferenceExpression name="property"/>
                                                      <primitiveExpression value="dayofweek"/>
                                                    </binaryOperatorExpression>
                                                    <binaryOperatorExpression operator="ValueEquality">
                                                      <variableReferenceExpression name="property"/>
                                                      <primitiveExpression value="dayofyear"/>
                                                    </binaryOperatorExpression>
                                                  </binaryOperatorExpression>
                                                </binaryOperatorExpression>
                                              </binaryOperatorExpression>
                                              <binaryOperatorExpression operator="BooleanOr">
                                                <binaryOperatorExpression operator="BooleanOr">
                                                  <binaryOperatorExpression operator="BooleanOr">
                                                    <binaryOperatorExpression operator="ValueEquality">
                                                      <variableReferenceExpression name="property"/>
                                                      <primitiveExpression value="weekofmonth"/>
                                                    </binaryOperatorExpression>
                                                    <binaryOperatorExpression operator="ValueEquality">
                                                      <variableReferenceExpression name="property"/>
                                                      <primitiveExpression value="week"/>
                                                    </binaryOperatorExpression>
                                                  </binaryOperatorExpression>
                                                  <binaryOperatorExpression operator="BooleanOr">
                                                    <binaryOperatorExpression operator="ValueEquality">
                                                      <variableReferenceExpression name="property"/>
                                                      <primitiveExpression value="weekofyear"/>
                                                    </binaryOperatorExpression>
                                                    <binaryOperatorExpression operator="ValueEquality">
                                                      <variableReferenceExpression name="property"/>
                                                      <primitiveExpression value="twoweek"/>
                                                    </binaryOperatorExpression>
                                                  </binaryOperatorExpression>
                                                </binaryOperatorExpression>
                                                <binaryOperatorExpression operator="BooleanOr">
                                                  <binaryOperatorExpression operator="BooleanOr">
                                                    <binaryOperatorExpression operator="ValueEquality">
                                                      <variableReferenceExpression name="property"/>
                                                      <primitiveExpression value="twoweeks"/>
                                                    </binaryOperatorExpression>
                                                    <binaryOperatorExpression operator="ValueEquality">
                                                      <variableReferenceExpression name="property"/>
                                                      <primitiveExpression value="month"/>
                                                    </binaryOperatorExpression>
                                                  </binaryOperatorExpression>
                                                  <binaryOperatorExpression operator="BooleanOr">
                                                    <binaryOperatorExpression operator="ValueEquality">
                                                      <variableReferenceExpression name="property"/>
                                                      <primitiveExpression value="quarter"/>
                                                    </binaryOperatorExpression>
                                                    <binaryOperatorExpression operator="ValueEquality">
                                                      <variableReferenceExpression name="property"/>
                                                      <primitiveExpression value="year"/>
                                                    </binaryOperatorExpression>
                                                  </binaryOperatorExpression>
                                                </binaryOperatorExpression>
                                              </binaryOperatorExpression>
                                            </binaryOperatorExpression>
                                          </condition>
                                          <trueStatements>
                                            <assignStatement>
                                              <propertyReferenceExpression name="Bucket">
                                                <variableReferenceExpression name="fi"/>
                                              </propertyReferenceExpression>
                                              <variableReferenceExpression name="property"/>
                                            </assignStatement>
                                          </trueStatements>
                                          <falseStatements>
                                            <conditionStatement>
                                              <!-- all-->
                                              <condition>
                                                <binaryOperatorExpression operator="ValueEquality">
                                                  <variableReferenceExpression name="property"/>
                                                  <primitiveExpression value="all"/>
                                                </binaryOperatorExpression>
                                              </condition>
                                              <trueStatements>
                                                <assignStatement>
                                                  <propertyReferenceExpression name="ExpandBuckets">
                                                    <variableReferenceExpression name="fi"/>
                                                  </propertyReferenceExpression>
                                                  <primitiveExpression value="true"/>
                                                </assignStatement>
                                                <conditionStatement>
                                                  <condition>
                                                    <binaryOperatorExpression operator="ValueEquality">
                                                      <variableReferenceExpression name="fieldType"/>
                                                      <primitiveExpression value="row"/>
                                                    </binaryOperatorExpression>
                                                  </condition>
                                                  <trueStatements>
                                                    <incrementStatement>
                                                      <propertyReferenceExpression name="ExpandBucketsInRowCount">
                                                        <variableReferenceExpression name="pivot"/>
                                                      </propertyReferenceExpression>
                                                    </incrementStatement>
                                                  </trueStatements>
                                                  <falseStatements>
                                                    <conditionStatement>
                                                      <condition>
                                                        <methodInvokeExpression methodName="StartsWith">
                                                          <target>
                                                            <variableReferenceExpression name="fieldType"/>
                                                          </target>
                                                          <parameters>
                                                            <primitiveExpression value="col"/>
                                                          </parameters>
                                                        </methodInvokeExpression>
                                                      </condition>
                                                      <trueStatements>
                                                        <incrementStatement>
                                                          <propertyReferenceExpression name="ExpandBucketsInRowCount">
                                                            <variableReferenceExpression name="pivot"/>
                                                          </propertyReferenceExpression>
                                                        </incrementStatement>
                                                      </trueStatements>
                                                    </conditionStatement>
                                                  </falseStatements>
                                                </conditionStatement>
                                              </trueStatements>
                                              <falseStatements>
                                                <assignStatement>
                                                  <variableReferenceExpression name="remove"/>
                                                  <primitiveExpression value="true"/>
                                                </assignStatement>
                                              </falseStatements>
                                            </conditionStatement>

                                          </falseStatements>
                                        </conditionStatement>
                                      </falseStatements>
                                    </conditionStatement>
                                    <conditionStatement>
                                      <condition>
                                        <variableReferenceExpression name="remove"/>
                                      </condition>
                                      <trueStatements>
                                        <decrementStatement>
                                          <variableReferenceExpression name="i"/>
                                        </decrementStatement>
                                        <methodInvokeExpression methodName="Remove">
                                          <target>
                                            <variableReferenceExpression name="additionalProperties"/>
                                          </target>
                                          <parameters>
                                            <propertyReferenceExpression name="Key">
                                              <variableReferenceExpression name="kvp"/>
                                            </propertyReferenceExpression>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </trueStatements>
                                    </conditionStatement>
                                  </statements>
                                </forStatement>
                                <comment>add the field</comment>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="ValueEquality">
                                      <variableReferenceExpression name="fieldType"/>
                                      <primitiveExpression value="row"/>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <methodInvokeExpression methodName="AddRowField">
                                      <target>
                                        <variableReferenceExpression name="pivot"/>
                                      </target>
                                      <parameters>
                                        <variableReferenceExpression name="fieldTypeIndex"/>
                                        <variableReferenceExpression name="fi"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </trueStatements>
                                  <falseStatements>
                                    <conditionStatement>
                                      <condition>
                                        <methodInvokeExpression methodName="StartsWith">
                                          <target>
                                            <variableReferenceExpression name="fieldType"/>
                                          </target>
                                          <parameters>
                                            <primitiveExpression value="col"/>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </condition>
                                      <trueStatements>
                                        <methodInvokeExpression methodName="AddColumnField">
                                          <target>
                                            <variableReferenceExpression name="pivot"/>
                                          </target>
                                          <parameters>
                                            <variableReferenceExpression name="fieldTypeIndex"/>
                                            <variableReferenceExpression name="fi"/>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </trueStatements>
                                      <falseStatements>
                                        <conditionStatement>
                                          <condition>
                                            <methodInvokeExpression methodName="StartsWith">
                                              <target>
                                                <variableReferenceExpression name="fieldType"/>
                                              </target>
                                              <parameters>
                                                <primitiveExpression value="val"/>
                                              </parameters>
                                            </methodInvokeExpression>
                                          </condition>
                                          <trueStatements>
                                            <methodInvokeExpression methodName="AddValueField">
                                              <target>
                                                <variableReferenceExpression name="pivot"/>
                                              </target>
                                              <parameters>
                                                <variableReferenceExpression name="fieldTypeIndex"/>
                                                <variableReferenceExpression name="fi"/>
                                              </parameters>
                                            </methodInvokeExpression>
                                          </trueStatements>
                                        </conditionStatement>
                                      </falseStatements>
                                    </conditionStatement>
                                  </falseStatements>
                                </conditionStatement>
                                <comment>add special properties</comment>
                                <foreachStatement>
                                  <variable type="KeyValuePair" name="kvp">
                                    <typeArguments>
                                      <typeReference type="System.String"/>
                                      <typeReference type="System.Object"/>
                                    </typeArguments>
                                  </variable>
                                  <target>
                                    <variableReferenceExpression name="additionalProperties"/>
                                  </target>
                                  <statements>
                                    <methodInvokeExpression methodName="AddProperty">
                                      <target>
                                        <variableReferenceExpression name="pivot"/>
                                      </target>
                                      <parameters>
                                        <propertyReferenceExpression name="Key">
                                          <variableReferenceExpression name="kvp"/>
                                        </propertyReferenceExpression>
                                        <propertyReferenceExpression name="Value">
                                          <variableReferenceExpression name="kvp"/>
                                        </propertyReferenceExpression>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </statements>
                                </foreachStatement>
                              </trueStatements>
                            </conditionStatement>
                          </trueStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
              </statements>
            </memberMethod>
            <!-- method AddPivotValues(object[])-->
            <memberMethod name="AddPivotValues">
              <attributes public="true"/>
              <parameters>
                <parameter type="System.Object[]" name="values"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanOr">
                      <binaryOperatorExpression operator="IdentityEquality">
                        <fieldReferenceExpression name="pivots"/>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                      <binaryOperatorExpression operator="ValueEquality">
                        <propertyReferenceExpression name="Count">
                          <fieldReferenceExpression name="pivots"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="0"/>
                      </binaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement/>
                  </trueStatements>
                </conditionStatement>
                <foreachStatement>
                  <variable type="PivotTable" name="pivot"/>
                  <target>
                    <propertyReferenceExpression name="Values">
                      <fieldReferenceExpression name="pivots"/>
                    </propertyReferenceExpression>
                  </target>
                  <statements>
                    <methodInvokeExpression methodName="Insert">
                      <target>
                        <variableReferenceExpression name="pivot"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="values"/>
                      </parameters>
                    </methodInvokeExpression>
                  </statements>
                </foreachStatement>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
        <!-- class PivotTable -->
        <typeDeclaration name="PivotTable">
          <attributes public="true"/>
          <members>
            <!-- field Id-->
            <memberField type="System.Int32" name="Id">
              <attributes public="true"/>
            </memberField>
            <!-- field Name-->
            <memberField type="System.String" name="Name">
              <attributes public="true"/>
            </memberField>
            <!-- field Title-->
            <memberField type="System.String" name="Title"/>
            <!-- property Title-->
            <memberProperty type="System.String" name="Title">
              <attributes public="true"/>
              <getStatements>
                <methodReturnStatement>
                  <propertyReferenceExpression name="ValuesName"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- field ValuesName-->
            <memberField type="System.String" name="ValuesName"/>
            <!-- property ValuesName-->
            <memberProperty type="System.String" name="ValuesName">
              <getStatements>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="IsNullOrEmpty">
                      <fieldReferenceExpression name="valuesName"/>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="StringBuilder" name="sb">
                      <init>
                        <objectCreateExpression type="StringBuilder"/>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="System.Boolean" name="first">
                      <init>
                        <primitiveExpression value="true"/>
                      </init>
                    </variableDeclarationStatement>
                    <foreachStatement>
                      <variable type="FieldInfo" name="info"/>
                      <target>
                        <propertyReferenceExpression name="Values">
                          <fieldReferenceExpression name="valueFields"/>
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
                                <primitiveExpression value=", "/>
                              </parameters>
                            </methodInvokeExpression>
                          </falseStatements>
                        </conditionStatement>
                        <methodInvokeExpression methodName="Append">
                          <target>
                            <variableReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <binaryOperatorExpression operator="Add">
                              <methodInvokeExpression methodName="ToUpper">
                                <target>
                                  <methodInvokeExpression methodName="Substring">
                                    <target>
                                      <propertyReferenceExpression name="Mode">
                                        <variableReferenceExpression name="info"/>
                                      </propertyReferenceExpression>
                                    </target>
                                    <parameters>
                                      <primitiveExpression value="0"/>
                                      <primitiveExpression value="1"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                </target>
                              </methodInvokeExpression>
                              <methodInvokeExpression methodName="Substring">
                                <target>
                                  <propertyReferenceExpression name="Mode">
                                    <variableReferenceExpression name="info"/>
                                  </propertyReferenceExpression>
                                </target>
                                <parameters>
                                  <primitiveExpression value="1"/>
                                </parameters>
                              </methodInvokeExpression>
                            </binaryOperatorExpression>
                          </parameters>
                        </methodInvokeExpression>
                        <methodInvokeExpression methodName="Append">
                          <target>
                            <variableReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <primitiveExpression value=" of "/>
                          </parameters>
                        </methodInvokeExpression>
                        <comment>TODO localize</comment>
                        <methodInvokeExpression methodName="Append">
                          <target>
                            <variableReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="Label">
                              <propertyReferenceExpression name="Field">
                                <variableReferenceExpression name="info"/>
                              </propertyReferenceExpression>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </statements>
                    </foreachStatement>
                    <assignStatement>
                      <fieldReferenceExpression name="valuesName"/>
                      <methodInvokeExpression methodName="ToString">
                        <target>
                          <variableReferenceExpression name="sb"/>
                        </target>
                      </methodInvokeExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <fieldReferenceExpression name="valuesName"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- field ChartType-->
            <memberField type="System.String" name="ChartType">
              <attributes public="true"/>
            </memberField>
            <!-- field ExpandBucketsInRowCount-->
            <memberField type="System.Int32" name="ExpandBucketsInRowCount">
              <attributes assembly="true"/>
              <init>
                <primitiveExpression value="0"/>
              </init>
            </memberField>
            <!-- field ExpandBucketsInColumnCount-->
            <memberField type="System.Int32" name="ExpandBucketsInColumnCount">
              <attributes assembly="true"/>
              <init>
                <primitiveExpression value="0"/>
              </init>
            </memberField>
            <!-- field SubtotalsEnabled-->
            <memberField type="System.Boolean" name="SubtotalsEnabled">
              <attributes assembly="true"/>
              <init>
                <primitiveExpression value="false"/>
              </init>
            </memberField>
            <!-- field GrandTotalsEnabled-->
            <memberField type="System.Boolean" name="GrandTotalsEnabled">
              <attributes assembly="true"/>
              <init>
                <primitiveExpression value="false"/>
              </init>
            </memberField>
            <!-- field RecordCount-->
            <memberField type="System.Int32" name="RecordCount">
              <attributes public="true"/>
              <init>
                <primitiveExpression value="0"/>
              </init>
            </memberField>
            <!-- property Data-->
            <memberProperty type="System.Object[]" name="Data">
              <attributes public="true"/>
              <getStatements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="Serialize"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- field Page-->
            <memberField type="ViewPage" name="Page">
              <attributes private="true"/>
            </memberField>
            <!-- field StructureValidated-->
            <memberField type="System.Boolean" name="StructureValidated">
              <init>
                <primitiveExpression value="false"/>
              </init>
            </memberField>
            <!-- field RowFields-->
            <memberField type="SortedDictionary" name="RowFields">
              <typeArguments>
                <typeReference type="System.Int32"/>
                <typeReference type="FieldInfo"/>
              </typeArguments>
              <init>
                <objectCreateExpression type="SortedDictionary">
                  <typeArguments>
                    <typeReference type="System.Int32"/>
                    <typeReference type="FieldInfo"/>
                  </typeArguments>
                </objectCreateExpression>
              </init>
            </memberField>
            <!-- field ColumnFields-->
            <memberField type="SortedDictionary" name="ColumnFields">
              <typeArguments>
                <typeReference type="System.Int32"/>
                <typeReference type="FieldInfo"/>
              </typeArguments>
              <init>
                <objectCreateExpression type="SortedDictionary">
                  <typeArguments>
                    <typeReference type="System.Int32"/>
                    <typeReference type="FieldInfo"/>
                  </typeArguments>
                </objectCreateExpression>
              </init>
            </memberField>
            <!-- field ValueFields-->
            <memberField type="SortedDictionary" name="ValueFields">
              <typeArguments>
                <typeReference type="System.Int32"/>
                <typeReference type="FieldInfo"/>
              </typeArguments>
              <init>
                <objectCreateExpression type="SortedDictionary">
                  <typeArguments>
                    <typeReference type="System.Int32"/>
                    <typeReference type="FieldInfo"/>
                  </typeArguments>
                </objectCreateExpression>
              </init>
            </memberField>
            <!-- field Rows-->
            <memberField type="SortedDictionary" name="Rows">
              <typeArguments>
                <typeReference type="System.String"/>
                <typeReference type="DimensionInfo"/>
              </typeArguments>
              <init>
                <objectCreateExpression type="SortedDictionary">
                  <typeArguments>
                    <typeReference type="System.String"/>
                    <typeReference type="DimensionInfo"/>
                  </typeArguments>
                </objectCreateExpression>
              </init>
            </memberField>
            <!-- field Columns-->
            <memberField type="SortedDictionary" name="Columns">
              <typeArguments>
                <typeReference type="System.String"/>
                <typeReference type="DimensionInfo"/>
              </typeArguments>
              <init>
                <objectCreateExpression type="SortedDictionary">
                  <typeArguments>
                    <typeReference type="System.String"/>
                    <typeReference type="DimensionInfo"/>
                  </typeArguments>
                </objectCreateExpression>
              </init>
            </memberField>
            <!-- field Values-->
            <memberField type="SortedDictionary" name="Values">
              <typeArguments>
                <typeReference type="System.String"/>
                <typeReference type="ValueInfo"/>
              </typeArguments>
              <init>
                <objectCreateExpression type="SortedDictionary">
                  <typeArguments>
                    <typeReference type="System.String"/>
                    <typeReference type="ValueInfo"/>
                  </typeArguments>
                </objectCreateExpression>
              </init>
            </memberField>
            <!-- field Properties-->
            <memberField type="SortedDictionary" name="Properties">
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
            </memberField>
            <!-- PivotTable(int, ViewPage)-->
            <constructor>
              <attributes public="true"/>
              <parameters>
                <parameter type="System.Int32" name="id"/>
                <parameter type="ViewPage" name="page"/>
              </parameters>
              <statements>
                <assignStatement>
                  <propertyReferenceExpression name="Id">
                    <thisReferenceExpression/>
                  </propertyReferenceExpression>
                  <argumentReferenceExpression name="id"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Name">
                    <thisReferenceExpression/>
                  </propertyReferenceExpression>
                  <binaryOperatorExpression operator="Add">
                    <primitiveExpression value="pivot"/>
                    <methodInvokeExpression methodName="ToString">
                      <target>
                        <argumentReferenceExpression name="id"/>
                      </target>
                    </methodInvokeExpression>
                  </binaryOperatorExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="page">
                    <thisReferenceExpression/>
                  </fieldReferenceExpression>
                  <argumentReferenceExpression name="page"/>
                </assignStatement>
              </statements>
            </constructor>
            <!-- method ValidateStructure()-->
            <memberMethod name="ValidateStructure">
              <attributes private="true"/>
              <statements>
                <comment>Assign value field</comment>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <propertyReferenceExpression name="Count">
                        <fieldReferenceExpression name="valueFields"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="0"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="DataField" name="primaryKeyField">
                      <init>
                        <primitiveExpression value="null"/>
                      </init>
                    </variableDeclarationStatement>
                    <foreachStatement>
                      <variable type="DataField" name="field"/>
                      <target>
                        <propertyReferenceExpression name="Fields">
                          <fieldReferenceExpression name="page"/>
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
                            <breakStatement/>
                          </trueStatements>
                        </conditionStatement>
                      </statements>
                    </foreachStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityEquality">
                          <variableReferenceExpression name="primaryKeyField"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="primaryKeyField"/>
                          <methodInvokeExpression methodName="First">
                            <target>
                              <propertyReferenceExpression name="Fields">
                                <fieldReferenceExpression name="page"/>
                              </propertyReferenceExpression>
                            </target>
                          </methodInvokeExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityInequality">
                          <variableReferenceExpression name="primaryKeyField"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="AddValueField">
                          <parameters>
                            <primitiveExpression value="0"/>
                            <objectCreateExpression type="FieldInfo">
                              <parameters>
                                <variableReferenceExpression name="primaryKeyField"/>
                              </parameters>
                            </objectCreateExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                  </trueStatements>
                </conditionStatement>
                <comment>Validate aliases</comment>
                <methodInvokeExpression methodName="ValidateAliases">
                  <parameters>
                    <fieldReferenceExpression name="rowFields"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="ValidateAliases">
                  <parameters>
                    <fieldReferenceExpression name="columnFields"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="ValidateAliases">
                  <parameters>
                    <fieldReferenceExpression name="valueFields"/>
                  </parameters>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- method ValidateData()-->
            <memberMethod name="ValidateData">
              <attributes private="true"/>
              <statements>
                <comment>Ensure rows and columns</comment>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <propertyReferenceExpression name="Count">
                        <fieldReferenceExpression name="rows"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="0"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <fieldReferenceExpression name="rows"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="Empty">
                          <typeReferenceExpression type="String"/>
                        </propertyReferenceExpression>
                        <objectCreateExpression type="DimensionInfo">
                          <parameters>
                            <propertyReferenceExpression name="String.Empty"/>
                            <arrayCreateExpression>
                              <createType type="System.Object"/>
                              <sizeExpression>
                                <primitiveExpression value="1"/>
                              </sizeExpression>
                              <initializers>
                                <propertyReferenceExpression name="Empty">
                                  <typeReferenceExpression type="System.String"/>
                                </propertyReferenceExpression>
                              </initializers>
                            </arrayCreateExpression>
                            <propertyReferenceExpression name="Count">
                              <fieldReferenceExpression name="rowFields"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </objectCreateExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <propertyReferenceExpression name="Count">
                        <fieldReferenceExpression name="columns"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="0"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <fieldReferenceExpression name="columns"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="Empty">
                          <typeReferenceExpression type="String"/>
                        </propertyReferenceExpression>
                        <objectCreateExpression type="DimensionInfo">
                          <parameters>
                            <propertyReferenceExpression name="String.Empty"/>
                            <arrayCreateExpression>
                              <createType type="System.Object"/>
                              <sizeExpression>
                                <primitiveExpression value="1"/>
                              </sizeExpression>
                              <initializers>
                                <propertyReferenceExpression name="Empty">
                                  <typeReferenceExpression type="System.String"/>
                                </propertyReferenceExpression>
                              </initializers>
                            </arrayCreateExpression>
                            <propertyReferenceExpression name="Count">
                              <fieldReferenceExpression name="columnFields"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </objectCreateExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <comment>Expand Buckets</comment>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="GreaterThan">
                      <propertyReferenceExpression name="ExpandBucketsInRowCount"/>
                      <primitiveExpression value="0"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="Stack" name="rowStack">
                      <typeArguments>
                        <typeReference type="FieldInfo"/>
                      </typeArguments>
                      <init>
                        <objectCreateExpression type="Stack">
                          <typeArguments>
                            <typeReference type="FieldInfo"/>
                          </typeArguments>
                          <parameters>
                            <methodInvokeExpression methodName="Reverse">
                              <target>
                                <propertyReferenceExpression name="Values">
                                  <fieldReferenceExpression name="rowFields"/>
                                </propertyReferenceExpression>
                              </target>
                            </methodInvokeExpression>
                          </parameters>
                        </objectCreateExpression>
                      </init>
                    </variableDeclarationStatement>
                    <methodInvokeExpression methodName="ExpandBuckets">
                      <parameters>
                        <variableReferenceExpression name="rowStack"/>
                        <fieldReferenceExpression name="rows"/>
                        <propertyReferenceExpression name="ExpandBucketsInRowCount"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="GreaterThan">
                      <propertyReferenceExpression name="ExpandBucketsInColumnCount"/>
                      <primitiveExpression value="0"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="Stack" name="columnStack">
                      <typeArguments>
                        <typeReference type="FieldInfo"/>
                      </typeArguments>
                      <init>
                        <objectCreateExpression type="Stack">
                          <typeArguments>
                            <typeReference type="FieldInfo"/>
                          </typeArguments>
                          <parameters>
                            <methodInvokeExpression methodName="Reverse">
                              <target>
                                <propertyReferenceExpression name="Values">
                                  <fieldReferenceExpression name="columnFields"/>
                                </propertyReferenceExpression>
                              </target>
                            </methodInvokeExpression>
                          </parameters>
                        </objectCreateExpression>
                      </init>
                    </variableDeclarationStatement>
                    <methodInvokeExpression methodName="ExpandBuckets">
                      <parameters>
                        <variableReferenceExpression name="columnStack"/>
                        <fieldReferenceExpression name="columns"/>
                        <propertyReferenceExpression name="ExpandBucketsInColumnCount"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method ExpandBuckets(Stack<FieldInfo>, SortedDictionary<string, DimensionInfo, int expandBucketsCount)-->
            <memberMethod name="ExpandBuckets">
              <attributes private="true"/>
              <parameters>
                <parameter type="Stack" name="fieldStack">
                  <typeArguments>
                    <typeReference type="FieldInfo"/>
                  </typeArguments>
                </parameter>
                <parameter type="SortedDictionary" name="dimension">
                  <typeArguments>
                    <typeReference type="System.String"/>
                    <typeReference type="DimensionInfo"/>
                  </typeArguments>
                </parameter>
                <parameter type="System.Int32" name="expandBucketsCount"/>
              </parameters>
              <statements>
                <methodInvokeExpression methodName="ExpandBuckets">
                  <parameters>
                    <propertyReferenceExpression name="Empty">
                      <typeReferenceExpression type="System.String"/>
                    </propertyReferenceExpression>
                    <objectCreateExpression type="List">
                      <typeArguments>
                        <typeReference type="System.Object"/>
                      </typeArguments>
                    </objectCreateExpression>
                    <primitiveExpression value="1"/>
                    <argumentReferenceExpression name="expandBucketsCount"/>
                    <argumentReferenceExpression name="fieldStack"/>
                    <argumentReferenceExpression name="dimension"/>
                  </parameters>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- method ExpandBuckets(String, List<object>, int, int, Stack<FieldInfo>, SortedDictionary<string, DimensionInfo)-->
            <memberMethod name="ExpandBuckets">
              <attributes private="true"/>
              <parameters>
                <parameter type="System.String" name="key"/>
                <parameter type="List" name="keyValues">
                  <typeArguments>
                    <typeReference type="System.Object"/>
                  </typeArguments>
                </parameter>
                <parameter type="System.Int32" name="depth"/>
                <parameter type="System.Int32" name="expandBucketsCount"/>
                <parameter type="Stack" name="fieldStack">
                  <typeArguments>
                    <typeReference type="FieldInfo"/>
                  </typeArguments>
                </parameter>
                <parameter type="SortedDictionary" name="dimension">
                  <typeArguments>
                    <typeReference type="System.String"/>
                    <typeReference type="DimensionInfo"/>
                  </typeArguments>
                </parameter>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueInequality">
                      <argumentReferenceExpression name="depth"/>
                      <primitiveExpression value="1"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <argumentReferenceExpression name="key"/>
                      <binaryOperatorExpression operator="Add">
                        <argumentReferenceExpression name="key"/>
                        <primitiveExpression value="|"/>
                      </binaryOperatorExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <propertyReferenceExpression name="Count">
                        <argumentReferenceExpression name="fieldStack"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="0"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement/>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="FieldInfo" name="fieldInfo">
                  <init>
                    <methodInvokeExpression methodName="Pop">
                      <target>
                        <argumentReferenceExpression name="fieldStack"/>
                      </target>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="List" name="bucketKeys">
                  <typeArguments>
                    <typeReference type="System.Object"/>
                  </typeArguments>
                  <init>
                    <objectCreateExpression type="List">
                      <typeArguments>
                        <typeReference type="System.Object"/>
                      </typeArguments>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <propertyReferenceExpression name="ExpandBuckets">
                      <variableReferenceExpression name="fieldInfo"/>
                    </propertyReferenceExpression>
                  </condition>
                  <trueStatements>
                    <comment>find all possible buckets in range</comment>
                    <decrementStatement>
                      <argumentReferenceExpression name="expandBucketsCount"/>
                    </decrementStatement>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="IsNotNullOrEmpty">
                          <propertyReferenceExpression name="Bucket">
                            <variableReferenceExpression name="fieldInfo"/>
                          </propertyReferenceExpression>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <comment>Create row for each missing bucket</comment>
                        <variableDeclarationStatement type="System.Object" name="iterator">
                          <init>
                            <propertyReferenceExpression name="Min">
                              <variableReferenceExpression name="fieldInfo"/>
                            </propertyReferenceExpression>
                          </init>
                        </variableDeclarationStatement>
                        <variableDeclarationStatement type="System.Object" name="max">
                          <init>
                            <propertyReferenceExpression name="Max">
                              <variableReferenceExpression name="fieldInfo"/>
                            </propertyReferenceExpression>
                          </init>
                        </variableDeclarationStatement>
                        <whileStatement>
                          <test>
                            <unaryOperatorExpression operator="Not">
                              <methodInvokeExpression methodName="EqualToMax">
                                <target>
                                  <variableReferenceExpression name="fieldInfo"/>
                                </target>
                                <parameters>
                                  <variableReferenceExpression name="iterator"/>
                                </parameters>
                              </methodInvokeExpression>
                            </unaryOperatorExpression>
                          </test>
                          <statements>
                            <methodInvokeExpression methodName="FindNextBucket">
                              <parameters>
                                <directionExpression direction="Ref">
                                  <variableReferenceExpression name="iterator"/>
                                </directionExpression>
                                <propertyReferenceExpression name="Bucket">
                                  <variableReferenceExpression name="fieldInfo"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <variableReferenceExpression name="bucketKeys"/>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="iterator"/>
                              </parameters>
                            </methodInvokeExpression>
                          </statements>
                        </whileStatement>
                      </trueStatements>
                      <falseStatements>
                        <comment>Expand lookup fields with distinct values</comment>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="IdentityEquality">
                              <propertyReferenceExpression name="ValueField">
                                <variableReferenceExpression name="fieldInfo"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="null"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <methodReturnStatement/>
                          </trueStatements>
                        </conditionStatement>
                        <variableDeclarationStatement type="DataField" name="originalField">
                          <init>
                            <propertyReferenceExpression name="ValueField">
                              <variableReferenceExpression name="fieldInfo"/>
                            </propertyReferenceExpression>
                          </init>
                        </variableDeclarationStatement>
                        <variableDeclarationStatement type="System.String" name="view">
                          <init>
                            <primitiveExpression value="grid1"/>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <unaryOperatorExpression operator="IsNotNullOrEmpty">
                              <propertyReferenceExpression name="ItemsDataView">
                                <variableReferenceExpression name="originalField"/>
                              </propertyReferenceExpression>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="view"/>
                              <propertyReferenceExpression name="ItemsDataView">
                                <variableReferenceExpression name="originalField"/>
                              </propertyReferenceExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <variableDeclarationStatement type="System.String" name="field">
                          <init>
                            <propertyReferenceExpression name="ItemsDataTextField">
                              <variableReferenceExpression name="originalField"/>
                            </propertyReferenceExpression>
                          </init>
                        </variableDeclarationStatement>
                        <variableDeclarationStatement type="IDataEngine" name="engine">
                          <init>
                            <methodInvokeExpression methodName="CreateDataEngine">
                              <target>
                                <typeReferenceExpression type="ControllerFactory"/>
                              </target>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <variableDeclarationStatement type="PageRequest" name="lookupRequest">
                          <init>
                            <objectCreateExpression type="PageRequest"/>
                          </init>
                        </variableDeclarationStatement>
                        <assignStatement>
                          <propertyReferenceExpression name="Controller">
                            <variableReferenceExpression name="lookupRequest"/>
                          </propertyReferenceExpression>
                          <propertyReferenceExpression name="ItemsDataController">
                            <variableReferenceExpression name="originalField"/>
                          </propertyReferenceExpression>
                        </assignStatement>
                        <assignStatement>
                          <propertyReferenceExpression name="PageSize">
                            <variableReferenceExpression name="lookupRequest"/>
                          </propertyReferenceExpression>
                          <propertyReferenceExpression name="MaximumDistinctValues">
                            <typeReferenceExpression type="DataControllerBase"/>
                          </propertyReferenceExpression>
                        </assignStatement>
                        <usingStatement>
                          <variable type="DbDataReader" name="reader">
                            <init>
                              <methodInvokeExpression methodName="ExecuteReader">
                                <target>
                                  <variableReferenceExpression name="engine"/>
                                </target>
                                <parameters>
                                  <variableReferenceExpression name="lookupRequest"/>
                                </parameters>
                              </methodInvokeExpression>
                            </init>
                          </variable>
                          <statements>
                            <whileStatement>
                              <test>
                                <methodInvokeExpression methodName="Read">
                                  <target>
                                    <variableReferenceExpression name="reader"/>
                                  </target>
                                </methodInvokeExpression>
                              </test>
                              <statements>
                                <comment>Get first string field</comment>
                                <conditionStatement>
                                  <condition>
                                    <unaryOperatorExpression operator="IsNullOrEmpty">
                                      <castExpression targetType="System.String">
                                        <variableReferenceExpression name="field"/>
                                      </castExpression>
                                    </unaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <variableDeclarationStatement type="System.Object[]" name="values">
                                      <init>
                                        <arrayCreateExpression>
                                          <createType type="System.Object"/>
                                          <sizeExpression>
                                            <propertyReferenceExpression name="FieldCount">
                                              <variableReferenceExpression name="reader"/>
                                            </propertyReferenceExpression>
                                          </sizeExpression>
                                        </arrayCreateExpression>
                                      </init>
                                    </variableDeclarationStatement>
                                    <variableDeclarationStatement type="System.Int32" name="length">
                                      <init>
                                        <methodInvokeExpression methodName="GetValues">
                                          <target>
                                            <variableReferenceExpression name="reader"/>
                                          </target>
                                          <parameters>
                                            <variableReferenceExpression name="values"/>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </init>
                                    </variableDeclarationStatement>
                                    <forStatement>
                                      <variable type="System.Int32" name="i">
                                        <init>
                                          <primitiveExpression value="0"/>
                                        </init>
                                      </variable>
                                      <test>
                                        <binaryOperatorExpression operator="LessThan">
                                          <variableReferenceExpression name="i"/>
                                          <variableReferenceExpression name="length"/>
                                        </binaryOperatorExpression>
                                      </test>
                                      <increment>
                                        <variableReferenceExpression name="i"/>
                                      </increment>
                                      <statements>
                                        <conditionStatement>
                                          <condition>
                                            <binaryOperatorExpression operator="ValueEquality">
                                              <methodInvokeExpression methodName="GetType">
                                                <target>
                                                  <arrayIndexerExpression>
                                                    <target>
                                                      <variableReferenceExpression name="values"/>
                                                    </target>
                                                    <indices>
                                                      <variableReferenceExpression name="i"/>
                                                    </indices>
                                                  </arrayIndexerExpression>
                                                </target>
                                              </methodInvokeExpression>
                                              <typeofExpression type="System.String"/>
                                            </binaryOperatorExpression>
                                          </condition>
                                          <trueStatements>
                                            <assignStatement>
                                              <variableReferenceExpression name="field"/>
                                              <methodInvokeExpression methodName="GetName">
                                                <target>
                                                  <variableReferenceExpression name="reader"/>
                                                </target>
                                                <parameters>
                                                  <variableReferenceExpression name="i"/>
                                                </parameters>
                                              </methodInvokeExpression>
                                            </assignStatement>
                                            <breakStatement/>
                                          </trueStatements>
                                        </conditionStatement>
                                      </statements>
                                    </forStatement>
                                  </trueStatements>
                                </conditionStatement>
                                <methodInvokeExpression methodName="Add">
                                  <target>
                                    <variableReferenceExpression name="bucketKeys"/>
                                  </target>
                                  <parameters>
                                    <convertExpression to="String">
                                      <arrayIndexerExpression>
                                        <target>
                                          <variableReferenceExpression name="reader"/>
                                        </target>
                                        <indices>
                                          <variableReferenceExpression name="field"/>
                                        </indices>
                                      </arrayIndexerExpression>
                                    </convertExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </statements>
                            </whileStatement>
                          </statements>
                        </usingStatement>
                      </falseStatements>
                    </conditionStatement>
                  </trueStatements>
                  <falseStatements>
                    <comment>Find all columns in this level</comment>
                    <foreachStatement>
                      <variable type="DimensionInfo" name="dim"/>
                      <target>
                        <propertyReferenceExpression name="Values">
                          <argumentReferenceExpression name="dimension"/>
                        </propertyReferenceExpression>
                      </target>
                      <statements>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="ValueEquality">
                              <propertyReferenceExpression name="Depth">
                                <variableReferenceExpression name="dim"/>
                              </propertyReferenceExpression>
                              <variableReferenceExpression name="depth"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <variableReferenceExpression name="bucketKeys"/>
                              </target>
                              <parameters>
                                <methodInvokeExpression methodName="Last">
                                  <target>
                                    <propertyReferenceExpression name="Labels">
                                      <variableReferenceExpression name="dim"/>
                                    </propertyReferenceExpression>
                                  </target>
                                </methodInvokeExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>
                      </statements>
                    </foreachStatement>
                  </falseStatements>
                </conditionStatement>
                <foreachStatement>
                  <variable type="System.Object" name="bucketKey"/>
                  <target>
                    <variableReferenceExpression name="bucketKeys"/>
                  </target>
                  <statements>
                    <variableDeclarationStatement type="List" name="newKeyValues">
                      <typeArguments>
                        <typeReference type="System.Object"/>
                      </typeArguments>
                      <init>
                        <objectCreateExpression type="List">
                          <typeArguments>
                            <typeReference type="System.Object"/>
                          </typeArguments>
                          <parameters>
                            <variableReferenceExpression name="keyValues"/>
                          </parameters>
                        </objectCreateExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="System.Object" name="unformattedKey">
                      <init>
                        <variableReferenceExpression name="bucketKey"/>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="System.String" name="newKey">
                      <init>
                        <binaryOperatorExpression operator="Add">
                          <variableReferenceExpression name="key"/>
                          <methodInvokeExpression methodName="FormatPivotValue">
                            <parameters>
                              <directionExpression direction="Ref">
                                <variableReferenceExpression name="unformattedKey"/>
                              </directionExpression>
                              <variableReferenceExpression name="newKeyValues"/>
                              <variableReferenceExpression name="fieldInfo"/>
                            </parameters>
                          </methodInvokeExpression>
                        </binaryOperatorExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="DimensionInfo" name="val">
                      <init>
                        <primitiveExpression value="null"/>
                      </init>
                    </variableDeclarationStatement>
                    <comment>expand buckets</comment>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="Not">
                          <methodInvokeExpression methodName="TryGetValue">
                            <target>
                              <variableReferenceExpression name="dimension"/>
                            </target>
                            <parameters>
                              <variableReferenceExpression name="newKey"/>
                              <directionExpression direction="Out">
                                <variableReferenceExpression name="val"/>
                              </directionExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <variableReferenceExpression name="dimension"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="newKey"/>
                            <objectCreateExpression type="DimensionInfo">
                              <parameters>
                                <variableReferenceExpression name="newKey"/>
                                <methodInvokeExpression methodName="ToArray">
                                  <target>
                                    <variableReferenceExpression name="newKeyValues"/>
                                  </target>
                                </methodInvokeExpression>
                                <argumentReferenceExpression name="depth"/>
                              </parameters>
                            </objectCreateExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                    <comment>expand lower levels</comment>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanAnd">
                          <binaryOperatorExpression operator="ValueInequality">
                            <propertyReferenceExpression name="Count">
                              <variableReferenceExpression name="fieldStack"/>
                            </propertyReferenceExpression>
                            <primitiveExpression value="0"/>
                          </binaryOperatorExpression>
                          <binaryOperatorExpression operator="ValueInequality">
                            <argumentReferenceExpression name="expandBucketsCount"/>
                            <primitiveExpression value="0"/>
                          </binaryOperatorExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="ExpandBuckets">
                          <parameters>
                            <variableReferenceExpression name="newKey"/>
                            <variableReferenceExpression name="newKeyValues"/>
                            <binaryOperatorExpression operator="Add">
                              <argumentReferenceExpression name="depth"/>
                              <primitiveExpression value="1"/>
                            </binaryOperatorExpression>
                            <variableReferenceExpression name="expandBucketsCount"/>
                            <objectCreateExpression type="Stack">
                              <typeArguments>
                                <typeReference type="FieldInfo"/>
                              </typeArguments>
                              <parameters>
                                <variableReferenceExpression name="fieldStack"/>
                              </parameters>
                            </objectCreateExpression>
                            <variableReferenceExpression name="dimension"/>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
              </statements>
            </memberMethod>
            <!-- method FindNextBucket(ref object, string)-->
            <memberMethod name="FindNextBucket">
              <attributes private="true"/>
              <parameters>
                <parameter type="System.Object" direction="Ref" name="iterator"/>
                <parameter type="System.String" name="bucket"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <argumentReferenceExpression name="bucket"/>
                      <primitiveExpression value="timeofday"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                  </trueStatements>
                  <falseStatements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="ValueEquality">
                          <argumentReferenceExpression name="bucket"/>
                          <primitiveExpression value="second"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <castExpression targetType="TimeSpan">
                              <argumentReferenceExpression name="iterator"/>
                            </castExpression>
                          </target>
                          <parameters>
                            <methodInvokeExpression methodName="FromSeconds">
                              <target>
                                <typeReferenceExpression type="TimeSpan"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="1"/>
                              </parameters>
                            </methodInvokeExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                      <falseStatements>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="ValueEquality">
                              <argumentReferenceExpression name="bucket"/>
                              <primitiveExpression value="minute"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <castExpression targetType="TimeSpan">
                                  <argumentReferenceExpression name="iterator"/>
                                </castExpression>
                              </target>
                              <parameters>
                                <methodInvokeExpression methodName="FromMinutes">
                                  <target>
                                    <typeReferenceExpression type="TimeSpan"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="1"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                          <falseStatements>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="ValueEquality">
                                  <argumentReferenceExpression name="bucket"/>
                                  <primitiveExpression value="halfhour"/>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <methodInvokeExpression methodName="Add">
                                  <target>
                                    <castExpression targetType="TimeSpan">
                                      <argumentReferenceExpression name="iterator"/>
                                    </castExpression>
                                  </target>
                                  <parameters>
                                    <methodInvokeExpression methodName="FromMinutes">
                                      <target>
                                        <typeReferenceExpression type="TimeSpan"/>
                                      </target>
                                      <parameters>
                                        <primitiveExpression value="30"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </trueStatements>
                              <falseStatements>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="ValueEquality">
                                      <argumentReferenceExpression name="bucket"/>
                                      <primitiveExpression value="hour"/>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <methodInvokeExpression methodName="Add">
                                      <target>
                                        <castExpression targetType="TimeSpan">
                                          <argumentReferenceExpression name="iterator"/>
                                        </castExpression>
                                      </target>
                                      <parameters>
                                        <methodInvokeExpression methodName="FromHours">
                                          <target>
                                            <typeReferenceExpression type="TimeSpan"/>
                                          </target>
                                          <parameters>
                                            <primitiveExpression value="1"/>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </trueStatements>
                                  <falseStatements>
                                    <conditionStatement>
                                      <condition>
                                        <binaryOperatorExpression operator="ValueEquality">
                                          <methodInvokeExpression methodName="GetType">
                                            <target>
                                              <argumentReferenceExpression name="iterator"/>
                                            </target>
                                          </methodInvokeExpression>
                                          <typeofExpression type="System.Int32"/>
                                        </binaryOperatorExpression>
                                      </condition>
                                      <trueStatements>
                                        <assignStatement>
                                          <argumentReferenceExpression name="iterator"/>
                                          <binaryOperatorExpression operator="Add">
                                            <castExpression targetType="System.Int32">
                                              <argumentReferenceExpression name="iterator"/>
                                            </castExpression>
                                            <primitiveExpression value="1"/>
                                          </binaryOperatorExpression>
                                        </assignStatement>
                                      </trueStatements>
                                      <falseStatements>
                                        <conditionStatement>
                                          <condition>
                                            <binaryOperatorExpression operator="ValueEquality">
                                              <methodInvokeExpression methodName="GetType">
                                                <target>
                                                  <argumentReferenceExpression name="iterator"/>
                                                </target>
                                              </methodInvokeExpression>
                                              <typeofExpression type="System.Int64"/>
                                            </binaryOperatorExpression>
                                          </condition>
                                          <trueStatements>
                                            <assignStatement>
                                              <argumentReferenceExpression name="iterator"/>
                                              <binaryOperatorExpression operator="Add">
                                                <castExpression targetType="System.Int64">
                                                  <argumentReferenceExpression name="iterator"/>
                                                </castExpression>
                                                <primitiveExpression value="1"/>
                                              </binaryOperatorExpression>
                                            </assignStatement>
                                          </trueStatements>
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
                  </falseStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method ValidateAliases(SortedDictionary<int, FieldInfo>)-->
            <memberMethod name="ValidateAliases">
              <attributes private="true"/>
              <parameters>
                <parameter type="SortedDictionary" name="fieldList">
                  <typeArguments>
                    <typeReference type="System.Int32"/>
                    <typeReference type="FieldInfo"/>
                  </typeArguments>
                </parameter>
              </parameters>
              <statements>
                <comment>detect alias fields</comment>
                <variableDeclarationStatement type="SortedDictionary" name="fieldsToReplace">
                  <typeArguments>
                    <typeReference type="System.Int32"/>
                    <typeReference type="DataField"/>
                  </typeArguments>
                  <init>
                    <objectCreateExpression type="SortedDictionary">
                      <typeArguments>
                        <typeReference type="System.Int32"/>
                        <typeReference type="DataField"/>
                      </typeArguments>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <foreachStatement>
                  <variable type="KeyValuePair" name="kvp">
                    <typeArguments>
                      <typeReference type="System.Int32"/>
                      <typeReference type="FieldInfo"/>
                    </typeArguments>
                  </variable>
                  <target>
                    <argumentReferenceExpression name="fieldList"/>
                  </target>
                  <statements>
                    <variableDeclarationStatement type="DataField" name="field">
                      <init>
                        <propertyReferenceExpression name="Field">
                          <propertyReferenceExpression name="Value">
                            <variableReferenceExpression name="kvp"/>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="IsNotNullOrEmpty">
                          <propertyReferenceExpression name="AliasName">
                            <variableReferenceExpression name="field"/>
                          </propertyReferenceExpression>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="DataField" name="aliasField">
                          <init>
                            <primitiveExpression value="null"/>
                          </init>
                        </variableDeclarationStatement>
                        <foreachStatement>
                          <variable type="DataField" name="f"/>
                          <target>
                            <propertyReferenceExpression name="Fields">
                              <fieldReferenceExpression name="page"/>
                            </propertyReferenceExpression>
                          </target>
                          <statements>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="ValueEquality">
                                  <propertyReferenceExpression name="Name">
                                    <variableReferenceExpression name="f"/>
                                  </propertyReferenceExpression>
                                  <propertyReferenceExpression name="AliasName">
                                    <variableReferenceExpression name="field"/>
                                  </propertyReferenceExpression>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="aliasField"/>
                                  <variableReferenceExpression name="f"/>
                                </assignStatement>
                              </trueStatements>
                            </conditionStatement>
                          </statements>
                        </foreachStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="IdentityInequality">
                              <variableReferenceExpression name="aliasField"/>
                              <primitiveExpression value="null"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <arrayIndexerExpression>
                                <target>
                                  <variableReferenceExpression name="fieldsToReplace"/>
                                </target>
                                <indices>
                                  <propertyReferenceExpression name="Key">
                                    <variableReferenceExpression name="kvp"/>
                                  </propertyReferenceExpression>
                                </indices>
                              </arrayIndexerExpression>
                              <variableReferenceExpression name="aliasField"/>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
                <comment>Replace alias fields</comment>
                <foreachStatement>
                  <variable type="KeyValuePair" name="kvp">
                    <typeArguments>
                      <typeReference type="System.Int32"/>
                      <typeReference type="DataField"/>
                    </typeArguments>
                  </variable>
                  <target>
                    <variableReferenceExpression name="fieldsToReplace"/>
                  </target>
                  <statements>
                    <variableDeclarationStatement type="FieldInfo" name="fi">
                      <init>
                        <arrayIndexerExpression>
                          <target>
                            <argumentReferenceExpression name="fieldList"/>
                          </target>
                          <indices>
                            <propertyReferenceExpression name="Key">
                              <variableReferenceExpression name="kvp"/>
                            </propertyReferenceExpression>
                          </indices>
                        </arrayIndexerExpression>
                      </init>
                    </variableDeclarationStatement>
                    <assignStatement>
                      <propertyReferenceExpression name="ValueField">
                        <variableReferenceExpression name="fi"/>
                      </propertyReferenceExpression>
                      <propertyReferenceExpression name="Field">
                        <variableReferenceExpression name="fi"/>
                      </propertyReferenceExpression>
                    </assignStatement>
                    <assignStatement>
                      <propertyReferenceExpression name="Field">
                        <variableReferenceExpression name="fi"/>
                      </propertyReferenceExpression>
                      <propertyReferenceExpression name="Value">
                        <variableReferenceExpression name="kvp"/>
                      </propertyReferenceExpression>
                    </assignStatement>
                  </statements>
                </foreachStatement>
              </statements>
            </memberMethod>
            <!-- method Insert(object[])-->
            <memberMethod name="Insert">
              <attributes public="true"/>
              <parameters>
                <parameter type="System.Object[]" name="values"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="Not">
                      <fieldReferenceExpression name="structureValidated"/>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="ValidateStructure"/>
                  </trueStatements>
                </conditionStatement>
                <comment>calculate row and column</comment>
                <variableDeclarationStatement type="List" name="keyList">
                  <typeArguments>
                    <typeReference type="DimensionInfo"/>
                  </typeArguments>
                  <init>
                    <objectCreateExpression type="List">
                      <typeArguments>
                        <typeReference type="DimensionInfo"/>
                      </typeArguments>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.String" name="rowKey">
                  <init>
                    <methodInvokeExpression methodName="GetPivotKey">
                      <parameters>
                        <argumentReferenceExpression name="values"/>
                        <fieldReferenceExpression name="rowFields"/>
                        <fieldReferenceExpression name="rows"/>
                        <variableReferenceExpression name="keyList"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.String" name="columnKey">
                  <init>
                    <methodInvokeExpression methodName="GetPivotKey">
                      <parameters>
                        <argumentReferenceExpression name="values"/>
                        <fieldReferenceExpression name="columnFields"/>
                        <fieldReferenceExpression name="columns"/>
                        <variableReferenceExpression name="keyList"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <foreachStatement>
                  <variable type="FieldInfo" name="fi"/>
                  <target>
                    <propertyReferenceExpression name="Values">
                      <fieldReferenceExpression name="valueFields"/>
                    </propertyReferenceExpression>
                  </target>
                  <statements>
                    <comment>calculate key</comment>
                    <variableDeclarationStatement type="System.String" name="dataKey">
                      <init>
                        <stringFormatExpression format="{{0}},{{1}}">
                          <variableReferenceExpression name="rowKey"/>
                          <variableReferenceExpression name="columnKey"/>
                        </stringFormatExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="GreaterThan">
                          <propertyReferenceExpression name="Count">
                            <fieldReferenceExpression name="valueFields"/>
                          </propertyReferenceExpression>
                          <primitiveExpression value="1"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="dataKey"/>
                          <stringFormatExpression format="{{0}},{{1}}">
                            <variableReferenceExpression name="dataKey"/>
                            <propertyReferenceExpression name="Name">
                              <propertyReferenceExpression name="Field">
                                <variableReferenceExpression name="fi"/>
                              </propertyReferenceExpression>
                            </propertyReferenceExpression>
                          </stringFormatExpression>
                        </assignStatement>
                        <conditionStatement>
                          <condition>
                            <unaryOperatorExpression operator="IsNotNullOrEmpty">
                              <propertyReferenceExpression name="Bucket">
                                <variableReferenceExpression name="fi"/>
                              </propertyReferenceExpression>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="dataKey"/>
                              <stringFormatExpression format="{{0}},{{1}}">
                                <variableReferenceExpression name="dataKey"/>
                                <propertyReferenceExpression name="Mode">
                                  <variableReferenceExpression name="fi"/>
                                </propertyReferenceExpression>
                              </stringFormatExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
                    <variableDeclarationStatement type="DataField" name="valueField">
                      <init>
                        <propertyReferenceExpression name="Field">
                          <variableReferenceExpression name="fi"/>
                        </propertyReferenceExpression>
                      </init>
                    </variableDeclarationStatement>
                    <comment>get the value</comment>
                    <variableDeclarationStatement type="System.Int32" name="valIndex">
                      <init>
                        <methodInvokeExpression methodName="IndexOf">
                          <target>
                            <propertyReferenceExpression name="Fields">
                              <fieldReferenceExpression name="page"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="valueField"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="System.Object" name="val">
                      <init>
                        <arrayIndexerExpression>
                          <target>
                            <argumentReferenceExpression name="values"/>
                          </target>
                          <indices>
                            <variableReferenceExpression name="valIndex"/>
                          </indices>
                        </arrayIndexerExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="ValueInfo" name="data">
                      <init>
                        <primitiveExpression value="null"/>
                      </init>
                    </variableDeclarationStatement>
                    <comment>find the data in Values</comment>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="Not">
                          <methodInvokeExpression methodName="TryGetValue">
                            <target>
                              <fieldReferenceExpression name="values"/>
                            </target>
                            <parameters>
                              <variableReferenceExpression name="dataKey"/>
                              <directionExpression direction="Out">
                                <variableReferenceExpression name="data"/>
                              </directionExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="data"/>
                          <objectCreateExpression type="ValueInfo">
                            <parameters>
                              <variableReferenceExpression name="fi"/>
                            </parameters>
                          </objectCreateExpression>
                        </assignStatement>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <fieldReferenceExpression name="values"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="dataKey"/>
                            <variableReferenceExpression name="data"/>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                    <conditionStatement>
                      <condition>
                        <propertyReferenceExpression name="GrandTotalsEnabled"/>
                      </condition>
                      <trueStatements>
                        <foreachStatement>
                          <variable type="DimensionInfo" name="dimension"/>
                          <target>
                            <variableReferenceExpression name="keyList"/>
                          </target>
                          <statements>
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <propertyReferenceExpression name="Values">
                                  <variableReferenceExpression name="dimension"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="val"/>
                              </parameters>
                            </methodInvokeExpression>
                          </statements>
                        </foreachStatement>
                      </trueStatements>
                    </conditionStatement>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <variableReferenceExpression name="data"/>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="val"/>
                      </parameters>
                    </methodInvokeExpression>
                  </statements>
                </foreachStatement>
                <incrementStatement>
                  <propertyReferenceExpression name="RecordCount"/>
                </incrementStatement>
              </statements>
            </memberMethod>
            <!-- method AddRowField(int, FieldInfo)-->
            <memberMethod name="AddRowField">
              <attributes public="true"/>
              <parameters>
                <parameter type="System.Int32" name="index"/>
                <parameter type="FieldInfo" name="info"/>
              </parameters>
              <statements>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="rowFields"/>
                  </target>
                  <parameters>
                    <argumentReferenceExpression name="index"/>
                    <argumentReferenceExpression name="info"/>
                  </parameters>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- method AddColumnField(int, FieldInfo)-->
            <memberMethod name="AddColumnField">
              <attributes public="true"/>
              <parameters>
                <parameter type="System.Int32" name="index"/>
                <parameter type="FieldInfo" name="info"/>
              </parameters>
              <statements>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="columnFields"/>
                  </target>
                  <parameters>
                    <argumentReferenceExpression name="index"/>
                    <argumentReferenceExpression name="info"/>
                  </parameters>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- method AddValueField(int, FieldInfo)-->
            <memberMethod name="AddValueField">
              <attributes public="true"/>
              <parameters>
                <parameter type="System.Int32" name="index"/>
                <parameter type="FieldInfo" name="info"/>
              </parameters>
              <statements>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="valueFields"/>
                  </target>
                  <parameters>
                    <argumentReferenceExpression name="index"/>
                    <argumentReferenceExpression name="info"/>
                  </parameters>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- method AddProperty(int, object)-->
            <memberMethod name="AddProperty">
              <attributes public="true"/>
              <parameters>
                <parameter type="System.String" name="key"/>
                <parameter type="System.Object" name="value"/>
              </parameters>
              <statements>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="properties"/>
                  </target>
                  <parameters>
                    <argumentReferenceExpression name="key"/>
                    <argumentReferenceExpression name="value"/>
                  </parameters>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- method GetPivotKey(object[], SortedDictionary<int, FieldInfo>, SortedDictionary<string, DimensionInfo>, List<DimensionInfo>)-->
            <memberMethod returnType="System.String" name="GetPivotKey">
              <attributes private="true"/>
              <parameters>
                <parameter type="System.Object[]" name="values"/>
                <parameter type="SortedDictionary" name="fieldList">
                  <typeArguments>
                    <typeReference type="System.Int32"/>
                    <typeReference type="FieldInfo"/>
                  </typeArguments>
                </parameter>
                <parameter type="SortedDictionary" name="dimensionList">
                  <typeArguments>
                    <typeReference type="System.String"/>
                    <typeReference type="DimensionInfo"/>
                  </typeArguments>
                </parameter>
                <parameter type="List" name="keyList">
                  <typeArguments>
                    <typeReference type="DimensionInfo"/>
                  </typeArguments>
                </parameter>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.String" name="pivotKey">
                  <init>
                    <stringEmptyExpression/>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="List" name="pivotValuesList">
                  <typeArguments>
                    <typeReference type="System.Object"/>
                  </typeArguments>
                  <init>
                    <objectCreateExpression type="List">
                      <typeArguments>
                        <typeReference type="System.Object"/>
                      </typeArguments>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.Int32" name="depth">
                  <init>
                    <primitiveExpression value="1"/>
                  </init>
                </variableDeclarationStatement>
                <foreachStatement>
                  <variable type="KeyValuePair" name="fieldPair">
                    <typeArguments>
                      <typeReference type="System.Int32"/>
                      <typeReference type="FieldInfo"/>
                    </typeArguments>
                  </variable>
                  <target>
                    <argumentReferenceExpression name="fieldList"/>
                  </target>
                  <statements>
                    <variableDeclarationStatement type="FieldInfo" name="fi">
                      <init>
                        <propertyReferenceExpression name="Value">
                          <variableReferenceExpression name="fieldPair"/>
                        </propertyReferenceExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="DataField" name="field">
                      <init>
                        <propertyReferenceExpression name="Field">
                          <variableReferenceExpression name="fi"/>
                        </propertyReferenceExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="ValueInequality">
                          <variableReferenceExpression name="depth"/>
                          <primitiveExpression value="1"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="pivotKey"/>
                          <binaryOperatorExpression operator="Add">
                            <variableReferenceExpression name="pivotKey"/>
                            <primitiveExpression value="|"/>
                          </binaryOperatorExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                    <comment>append value</comment>
                    <variableDeclarationStatement type="System.Int32" name="index">
                      <init>
                        <methodInvokeExpression methodName="IndexOf">
                          <target>
                            <propertyReferenceExpression name="Fields">
                              <fieldReferenceExpression name="page"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="field"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="System.Object" name="value">
                      <init>
                        <arrayIndexerExpression>
                          <target>
                            <argumentReferenceExpression name="values"/>
                          </target>
                          <indices>
                            <variableReferenceExpression name="index"/>
                          </indices>
                        </arrayIndexerExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="System.Object" name="dimensionKey">
                      <init>
                        <methodInvokeExpression methodName="FormatPivotValue">
                          <parameters>
                            <directionExpression direction="Ref">
                              <variableReferenceExpression name="value"/>
                            </directionExpression>
                            <variableReferenceExpression name="pivotValuesList"/>
                            <variableReferenceExpression name="fi"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <assignStatement>
                      <variableReferenceExpression name="pivotKey"/>
                      <binaryOperatorExpression operator="Add">
                        <variableReferenceExpression name="pivotKey"/>
                        <variableReferenceExpression name="dimensionKey"/>
                      </binaryOperatorExpression>
                    </assignStatement>
                    <comment>update field info</comment>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <variableReferenceExpression name="fi"/>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="value"/>
                      </parameters>
                    </methodInvokeExpression>
                    <comment>initialize row or column</comment>
                    <variableDeclarationStatement type="DimensionInfo" name="dimKey">
                      <init>
                        <primitiveExpression value="null"/>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="Not">
                          <methodInvokeExpression methodName="TryGetValue">
                            <target>
                              <argumentReferenceExpression name="dimensionList"/>
                            </target>
                            <parameters>
                              <variableReferenceExpression name="pivotKey"/>
                              <directionExpression direction="Out">
                                <variableReferenceExpression name="dimKey"/>
                              </directionExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="dimKey"/>
                          <objectCreateExpression type="DimensionInfo">
                            <parameters>
                              <variableReferenceExpression name="pivotKey"/>
                              <methodInvokeExpression methodName="ToArray">
                                <target>
                                  <variableReferenceExpression name="pivotValuesList"/>
                                </target>
                              </methodInvokeExpression>
                              <variableReferenceExpression name="depth"/>
                            </parameters>
                          </objectCreateExpression>
                        </assignStatement>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <argumentReferenceExpression name="dimensionList"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="pivotKey"/>
                            <variableReferenceExpression name="dimKey"/>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <variableReferenceExpression name="keyList"/>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="dimKey"/>
                      </parameters>
                    </methodInvokeExpression>
                    <incrementStatement>
                      <variableReferenceExpression name="depth"/>
                    </incrementStatement>
                  </statements>
                </foreachStatement>
                <methodReturnStatement>
                  <variableReferenceExpression name="pivotKey"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method FormatPivotValue(ref object, List<object>, FieldInfo)-->
            <memberMethod returnType="System.Object" name="FormatPivotValue">
              <attributes private="true" static="true"/>
              <parameters>
                <parameter type="System.Object" direction="Ref" name="value"/>
                <parameter type="List" name="pivotValuesList">
                  <typeArguments>
                    <typeReference type="System.Object"/>
                  </typeArguments>
                </parameter>
                <parameter type="FieldInfo" name="fi"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.Boolean" name="addValueToArray">
                  <init>
                    <primitiveExpression value="true"/>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="CultureInfo" name="ci">
                  <init>
                    <propertyReferenceExpression name="CurrentCulture">
                      <typeReferenceExpression type="CultureInfo"/>
                    </propertyReferenceExpression>
                  </init>
                </variableDeclarationStatement>
                <comment>form buckets based on bucket mode</comment>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="IsNotNullOrEmpty">
                      <propertyReferenceExpression name="Bucket">
                        <argumentReferenceExpression name="fi"/>
                      </propertyReferenceExpression>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <!-- if DateTime-->
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="ValueEquality">
                          <methodInvokeExpression methodName="GetType">
                            <target>
                              <argumentReferenceExpression name="value"/>
                            </target>
                          </methodInvokeExpression>
                          <typeofExpression type="DateTime"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="DateTime" name="date">
                          <init>
                            <castExpression targetType="DateTime">
                              <argumentReferenceExpression name="value"/>
                            </castExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <!-- timeofday-->
                          <condition>
                            <binaryOperatorExpression operator="ValueEquality">
                              <propertyReferenceExpression name="Bucket">
                                <argumentReferenceExpression name="fi"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="timeofday"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <argumentReferenceExpression name="value"/>
                              <propertyReferenceExpression name="TimeOfDay">
                                <variableReferenceExpression name="date"/>
                              </propertyReferenceExpression>
                            </assignStatement>
                            <assignStatement>
                              <variableReferenceExpression name="addValueToArray"/>
                              <primitiveExpression value="false"/>
                            </assignStatement>
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <argumentReferenceExpression name="pivotValuesList"/>
                              </target>
                              <parameters>
                                <methodInvokeExpression methodName="ToString">
                                  <target>
                                    <castExpression targetType="TimeSpan">
                                      <argumentReferenceExpression name="value"/>
                                    </castExpression>
                                  </target>
                                </methodInvokeExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                          <falseStatements>
                            <conditionStatement>
                              <!-- minute-->
                              <condition>
                                <binaryOperatorExpression operator="ValueEquality">
                                  <propertyReferenceExpression name="Bucket">
                                    <argumentReferenceExpression name="fi"/>
                                  </propertyReferenceExpression>
                                  <primitiveExpression value="minute"/>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <argumentReferenceExpression name="value"/>
                                  <objectCreateExpression type="TimeSpan">
                                    <parameters>
                                      <propertyReferenceExpression name="Hour">
                                        <variableReferenceExpression name="date"/>
                                      </propertyReferenceExpression>
                                      <propertyReferenceExpression name="Minute">
                                        <variableReferenceExpression name="date"/>
                                      </propertyReferenceExpression>
                                      <propertyReferenceExpression name="Second">
                                        <variableReferenceExpression name="date"/>
                                      </propertyReferenceExpression>
                                    </parameters>
                                  </objectCreateExpression>
                                </assignStatement>
                                <assignStatement>
                                  <variableReferenceExpression name="addValueToArray"/>
                                  <primitiveExpression value="false"/>
                                </assignStatement>
                                <methodInvokeExpression methodName="Add">
                                  <target>
                                    <argumentReferenceExpression name="pivotValuesList"/>
                                  </target>
                                  <parameters>
                                    <stringFormatExpression format="{{0:d2}}:{{1:d2}}">
                                      <propertyReferenceExpression name="Hour">
                                        <variableReferenceExpression name="date"/>
                                      </propertyReferenceExpression>
                                      <propertyReferenceExpression name="Minute">
                                        <variableReferenceExpression name="date"/>
                                      </propertyReferenceExpression>
                                    </stringFormatExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </trueStatements>
                              <falseStatements>
                                <conditionStatement>
                                  <!-- halfhour-->
                                  <condition>
                                    <binaryOperatorExpression operator="ValueEquality">
                                      <propertyReferenceExpression name="Bucket">
                                        <argumentReferenceExpression name="fi"/>
                                      </propertyReferenceExpression>
                                      <primitiveExpression value="halfhour"/>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <variableDeclarationStatement type="System.Int32" name="minute">
                                      <init>
                                        <primitiveExpression value="0"/>
                                      </init>
                                    </variableDeclarationStatement>
                                    <conditionStatement>
                                      <condition>
                                        <binaryOperatorExpression operator="GreaterThanOrEqual">
                                          <propertyReferenceExpression name="Minute">
                                            <variableReferenceExpression name="date"/>
                                          </propertyReferenceExpression>
                                          <primitiveExpression value="30"/>
                                        </binaryOperatorExpression>
                                      </condition>
                                      <trueStatements>
                                        <assignStatement>
                                          <variableReferenceExpression name="minute"/>
                                          <primitiveExpression value="30"/>
                                        </assignStatement>
                                      </trueStatements>
                                    </conditionStatement>
                                    <assignStatement>
                                      <variableReferenceExpression name="addValueToArray"/>
                                      <primitiveExpression value="false"/>
                                    </assignStatement>
                                    <methodInvokeExpression methodName="Add">
                                      <target>
                                        <argumentReferenceExpression name="pivotValuesList"/>
                                      </target>
                                      <parameters>
                                        <stringFormatExpression format="{{0:d2}}:{{1:d2}}">
                                          <propertyReferenceExpression name="Hour">
                                            <variableReferenceExpression name="date"/>
                                          </propertyReferenceExpression>
                                          <variableReferenceExpression name="minute"/>
                                        </stringFormatExpression>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </trueStatements>
                                  <falseStatements>
                                    <conditionStatement>
                                      <!-- hour-->
                                      <condition>
                                        <binaryOperatorExpression operator="ValueEquality">
                                          <propertyReferenceExpression name="Bucket">
                                            <argumentReferenceExpression name="fi"/>
                                          </propertyReferenceExpression>
                                          <primitiveExpression value="hour"/>
                                        </binaryOperatorExpression>
                                      </condition>
                                      <trueStatements>
                                        <assignStatement>
                                          <argumentReferenceExpression name="value"/>
                                          <objectCreateExpression type="TimeSpan">
                                            <parameters>
                                              <propertyReferenceExpression name="Hour">
                                                <variableReferenceExpression name="date"/>
                                              </propertyReferenceExpression>
                                              <primitiveExpression value="0"/>
                                              <primitiveExpression value="0"/>
                                            </parameters>
                                          </objectCreateExpression>
                                        </assignStatement>
                                        <assignStatement>
                                          <variableReferenceExpression name="addValueToArray"/>
                                          <primitiveExpression value="false"/>
                                        </assignStatement>
                                        <methodInvokeExpression methodName="Add">
                                          <target>
                                            <argumentReferenceExpression name="pivotValuesList"/>
                                          </target>
                                          <parameters>
                                            <stringFormatExpression format="{{0:d2}}:00">
                                              <propertyReferenceExpression name="Hour">
                                                <variableReferenceExpression name="date"/>
                                              </propertyReferenceExpression>
                                            </stringFormatExpression>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </trueStatements>
                                      <falseStatements>
                                        <conditionStatement>
                                          <!-- day || dayofmonth-->
                                          <condition>
                                            <binaryOperatorExpression operator="BooleanOr">
                                              <binaryOperatorExpression operator="ValueEquality">
                                                <propertyReferenceExpression name="Bucket">
                                                  <argumentReferenceExpression name="fi"/>
                                                </propertyReferenceExpression>
                                                <primitiveExpression value="day"/>
                                              </binaryOperatorExpression>
                                              <binaryOperatorExpression operator="ValueEquality">
                                                <propertyReferenceExpression name="Bucket">
                                                  <argumentReferenceExpression name="fi"/>
                                                </propertyReferenceExpression>
                                                <primitiveExpression value="dayofmonth"/>
                                              </binaryOperatorExpression>
                                            </binaryOperatorExpression>
                                          </condition>
                                          <trueStatements>
                                            <assignStatement>
                                              <argumentReferenceExpression name="value"/>
                                              <propertyReferenceExpression name="Day">
                                                <variableReferenceExpression name="date"/>
                                              </propertyReferenceExpression>
                                            </assignStatement>
                                          </trueStatements>
                                          <falseStatements>
                                            <conditionStatement>
                                              <!-- dayofweek-->
                                              <condition>
                                                <binaryOperatorExpression operator="ValueEquality">
                                                  <propertyReferenceExpression name="Bucket">
                                                    <argumentReferenceExpression name="fi"/>
                                                  </propertyReferenceExpression>
                                                  <primitiveExpression value="dayofweek"/>
                                                </binaryOperatorExpression>
                                              </condition>
                                              <trueStatements>
                                                <assignStatement>
                                                  <argumentReferenceExpression name="value"/>
                                                  <castExpression targetType="System.Int32">
                                                    <propertyReferenceExpression name="DayOfWeek">
                                                      <variableReferenceExpression name="date"/>
                                                    </propertyReferenceExpression>
                                                  </castExpression>
                                                </assignStatement>
                                                <assignStatement>
                                                  <variableReferenceExpression name="addValueToArray"/>
                                                  <primitiveExpression value="false"/>
                                                </assignStatement>
                                                <methodInvokeExpression methodName="Add">
                                                  <target>
                                                    <argumentReferenceExpression name="pivotValuesList"/>
                                                  </target>
                                                  <parameters>
                                                    <propertyReferenceExpression name="DayOfWeek">
                                                      <variableReferenceExpression name="date"/>
                                                    </propertyReferenceExpression>
                                                  </parameters>
                                                </methodInvokeExpression>
                                              </trueStatements>
                                              <falseStatements>
                                                <conditionStatement>
                                                  <!-- dayofyear-->
                                                  <condition>
                                                    <binaryOperatorExpression operator="ValueEquality">
                                                      <propertyReferenceExpression name="Bucket">
                                                        <argumentReferenceExpression name="fi"/>
                                                      </propertyReferenceExpression>
                                                      <primitiveExpression value="dayofyear"/>
                                                    </binaryOperatorExpression>
                                                  </condition>
                                                  <trueStatements>
                                                    <assignStatement>
                                                      <argumentReferenceExpression name="value"/>
                                                      <propertyReferenceExpression name="DayOfYear">
                                                        <variableReferenceExpression name="date"/>
                                                      </propertyReferenceExpression>
                                                    </assignStatement>
                                                  </trueStatements>
                                                  <falseStatements>
                                                    <conditionStatement>
                                                      <!-- weekofmonth-->
                                                      <condition>
                                                        <binaryOperatorExpression operator="ValueEquality">
                                                          <propertyReferenceExpression name="Bucket">
                                                            <argumentReferenceExpression name="fi"/>
                                                          </propertyReferenceExpression>
                                                          <primitiveExpression value="weekofmonth"/>
                                                        </binaryOperatorExpression>
                                                      </condition>
                                                      <trueStatements>
                                                        <assignStatement>
                                                          <argumentReferenceExpression name="value"/>
                                                          <binaryOperatorExpression operator="Subtract">
                                                            <methodInvokeExpression methodName="Iso8601WeekNumber">
                                                              <parameters>
                                                                <variableReferenceExpression name="date"/>
                                                              </parameters>
                                                            </methodInvokeExpression>
                                                            <binaryOperatorExpression operator="Add">
                                                              <methodInvokeExpression methodName="Iso8601WeekNumber">
                                                                <parameters>
                                                                  <methodInvokeExpression methodName="AddDays">
                                                                    <target>
                                                                      <variableReferenceExpression name="date"/>
                                                                    </target>
                                                                    <parameters>
                                                                      <binaryOperatorExpression operator="Subtract">
                                                                        <primitiveExpression value="1"/>
                                                                        <propertyReferenceExpression name="Day">
                                                                          <variableReferenceExpression name="date"/>
                                                                        </propertyReferenceExpression>
                                                                      </binaryOperatorExpression>
                                                                    </parameters>
                                                                  </methodInvokeExpression>
                                                                </parameters>
                                                              </methodInvokeExpression>
                                                              <primitiveExpression value="1"/>
                                                            </binaryOperatorExpression>
                                                          </binaryOperatorExpression>
                                                        </assignStatement>
                                                      </trueStatements>
                                                      <falseStatements>
                                                        <conditionStatement>
                                                          <!-- week || weekofyear-->
                                                          <condition>
                                                            <binaryOperatorExpression operator="BooleanOr">
                                                              <binaryOperatorExpression operator="ValueEquality">
                                                                <propertyReferenceExpression name="Bucket">
                                                                  <argumentReferenceExpression name="fi"/>
                                                                </propertyReferenceExpression>
                                                                <primitiveExpression value="week"/>
                                                              </binaryOperatorExpression>
                                                              <binaryOperatorExpression operator="ValueEquality">
                                                                <propertyReferenceExpression name="Bucket">
                                                                  <argumentReferenceExpression name="fi"/>
                                                                </propertyReferenceExpression>
                                                                <primitiveExpression value="weekofyear"/>
                                                              </binaryOperatorExpression>
                                                            </binaryOperatorExpression>
                                                          </condition>
                                                          <trueStatements>
                                                            <assignStatement>
                                                              <argumentReferenceExpression name="value"/>
                                                              <methodInvokeExpression methodName="GetWeekOfYear">
                                                                <target>
                                                                  <propertyReferenceExpression name="Calendar">
                                                                    <variableReferenceExpression name="ci"/>
                                                                  </propertyReferenceExpression>
                                                                </target>
                                                                <parameters>
                                                                  <variableReferenceExpression name="date"/>
                                                                  <propertyReferenceExpression name="FirstDay">
                                                                    <typeReferenceExpression type="CalendarWeekRule"/>
                                                                  </propertyReferenceExpression>
                                                                  <propertyReferenceExpression name="Sunday">
                                                                    <typeReferenceExpression type="DayOfWeek"/>
                                                                  </propertyReferenceExpression>
                                                                </parameters>
                                                              </methodInvokeExpression>
                                                            </assignStatement>
                                                          </trueStatements>
                                                          <falseStatements>
                                                            <conditionStatement>
                                                              <!-- twoweek-->
                                                              <condition>
                                                                <binaryOperatorExpression operator="BooleanOr">
                                                                  <binaryOperatorExpression operator="ValueEquality">
                                                                    <propertyReferenceExpression name="Bucket">
                                                                      <argumentReferenceExpression name="fi"/>
                                                                    </propertyReferenceExpression>
                                                                    <primitiveExpression value="twoweek"/>
                                                                  </binaryOperatorExpression>
                                                                  <binaryOperatorExpression operator="ValueEquality">
                                                                    <propertyReferenceExpression name="Bucket">
                                                                      <argumentReferenceExpression name="fi"/>
                                                                    </propertyReferenceExpression>
                                                                    <primitiveExpression value="twoweeks"/>
                                                                  </binaryOperatorExpression>
                                                                </binaryOperatorExpression>
                                                              </condition>
                                                              <trueStatements>

                                                              </trueStatements>
                                                              <falseStatements>
                                                                <conditionStatement>
                                                                  <!-- month-->
                                                                  <condition>
                                                                    <binaryOperatorExpression operator="ValueEquality">
                                                                      <propertyReferenceExpression name="Bucket">
                                                                        <argumentReferenceExpression name="fi"/>
                                                                      </propertyReferenceExpression>
                                                                      <primitiveExpression value="month"/>
                                                                    </binaryOperatorExpression>
                                                                  </condition>
                                                                  <trueStatements>
                                                                    <assignStatement>
                                                                      <argumentReferenceExpression name="value"/>
                                                                      <propertyReferenceExpression name="Month">
                                                                        <variableReferenceExpression name="date"/>
                                                                      </propertyReferenceExpression>
                                                                    </assignStatement>
                                                                    <assignStatement>
                                                                      <variableReferenceExpression name="addValueToArray"/>
                                                                      <primitiveExpression value="false"/>
                                                                    </assignStatement>
                                                                    <methodInvokeExpression methodName="Add">
                                                                      <target>
                                                                        <argumentReferenceExpression name="pivotValuesList"/>
                                                                      </target>
                                                                      <parameters>
                                                                        <arrayIndexerExpression>
                                                                          <target>
                                                                            <propertyReferenceExpression name="MonthNames">
                                                                              <propertyReferenceExpression name="DateTimeFormat">
                                                                                <variableReferenceExpression name="ci"/>
                                                                              </propertyReferenceExpression>
                                                                            </propertyReferenceExpression>
                                                                          </target>
                                                                          <indices>
                                                                            <binaryOperatorExpression operator="Subtract">
                                                                              <propertyReferenceExpression name="Month">
                                                                                <variableReferenceExpression name="date"/>
                                                                              </propertyReferenceExpression>
                                                                              <primitiveExpression value="1"/>
                                                                            </binaryOperatorExpression>
                                                                          </indices>
                                                                        </arrayIndexerExpression>
                                                                      </parameters>
                                                                    </methodInvokeExpression>
                                                                  </trueStatements>
                                                                  <falseStatements>
                                                                    <conditionStatement>
                                                                      <!-- quarter-->
                                                                      <condition>
                                                                        <binaryOperatorExpression operator="ValueEquality">
                                                                          <propertyReferenceExpression name="Bucket">
                                                                            <argumentReferenceExpression name="fi"/>
                                                                          </propertyReferenceExpression>
                                                                          <primitiveExpression value="quarter"/>
                                                                        </binaryOperatorExpression>
                                                                      </condition>
                                                                      <trueStatements>
                                                                        <variableDeclarationStatement type="System.Int32" name="month">
                                                                          <init>
                                                                            <propertyReferenceExpression name="Month">
                                                                              <variableReferenceExpression name="date"/>
                                                                            </propertyReferenceExpression>
                                                                          </init>
                                                                        </variableDeclarationStatement>
                                                                        <conditionStatement>
                                                                          <condition>
                                                                            <binaryOperatorExpression operator="LessThan">
                                                                              <variableReferenceExpression name="month"/>
                                                                              <primitiveExpression value="3"/>
                                                                            </binaryOperatorExpression>
                                                                          </condition>
                                                                          <trueStatements>
                                                                            <assignStatement>
                                                                              <argumentReferenceExpression name="value"/>
                                                                              <primitiveExpression value="1"/>
                                                                            </assignStatement>
                                                                          </trueStatements>
                                                                          <falseStatements>
                                                                            <conditionStatement>
                                                                              <condition>
                                                                                <binaryOperatorExpression operator="LessThan">
                                                                                  <variableReferenceExpression name="month"/>
                                                                                  <primitiveExpression value="6"/>
                                                                                </binaryOperatorExpression>
                                                                              </condition>
                                                                              <trueStatements>
                                                                                <assignStatement>
                                                                                  <argumentReferenceExpression name="value"/>
                                                                                  <primitiveExpression value="2"/>
                                                                                </assignStatement>
                                                                              </trueStatements>
                                                                              <falseStatements>
                                                                                <conditionStatement>
                                                                                  <condition>
                                                                                    <binaryOperatorExpression operator="LessThan">
                                                                                      <variableReferenceExpression name="month"/>
                                                                                      <primitiveExpression value="9"/>
                                                                                    </binaryOperatorExpression>
                                                                                  </condition>
                                                                                  <trueStatements>
                                                                                    <assignStatement>
                                                                                      <argumentReferenceExpression name="value"/>
                                                                                      <primitiveExpression value="3"/>
                                                                                    </assignStatement>
                                                                                  </trueStatements>
                                                                                  <falseStatements>
                                                                                    <assignStatement>
                                                                                      <argumentReferenceExpression name="value"/>
                                                                                      <primitiveExpression value="4"/>
                                                                                    </assignStatement>
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
                                                                            <binaryOperatorExpression operator="ValueEquality">
                                                                              <propertyReferenceExpression name="Bucket">
                                                                                <argumentReferenceExpression name="fi"/>
                                                                              </propertyReferenceExpression>
                                                                              <primitiveExpression value="year"/>
                                                                            </binaryOperatorExpression>
                                                                          </condition>
                                                                          <trueStatements>
                                                                            <assignStatement>
                                                                              <argumentReferenceExpression name="value"/>
                                                                              <propertyReferenceExpression name="Year">
                                                                                <variableReferenceExpression name="date"/>
                                                                              </propertyReferenceExpression>
                                                                            </assignStatement>
                                                                          </trueStatements>
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
                          </falseStatements>
                        </conditionStatement>
                      </trueStatements>
                      <!-- if long-->
                      <falseStatements>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="ValueEquality">
                              <methodInvokeExpression methodName="GetType">
                                <target>
                                  <argumentReferenceExpression name="value"/>
                                </target>
                              </methodInvokeExpression>
                              <typeofExpression type="System.Int64"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <variableDeclarationStatement type="System.Int64" name="val">
                              <init>
                                <castExpression targetType="System.Int64">
                                  <argumentReferenceExpression name="value"/>
                                </castExpression>
                              </init>
                            </variableDeclarationStatement>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="ValueEquality">
                                  <propertyReferenceExpression name="Bucket">
                                    <argumentReferenceExpression name="fi"/>
                                  </propertyReferenceExpression>
                                  <primitiveExpression value="dayofweek"/>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="addValueToArray"/>
                                  <primitiveExpression value="false"/>
                                </assignStatement>
                                <methodInvokeExpression methodName="Add">
                                  <target>
                                    <variableReferenceExpression name="pivotValuesList"/>
                                  </target>
                                  <parameters>
                                    <arrayIndexerExpression>
                                      <target>
                                        <propertyReferenceExpression name="DayNames">
                                          <propertyReferenceExpression name="DateTimeFormat">
                                            <variableReferenceExpression name="ci"/>
                                          </propertyReferenceExpression>
                                        </propertyReferenceExpression>
                                      </target>
                                      <indices>
                                        <variableReferenceExpression name="val"/>
                                      </indices>
                                    </arrayIndexerExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </trueStatements>
                              <falseStatements>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="ValueEquality">
                                      <propertyReferenceExpression name="Bucket">
                                        <argumentReferenceExpression name="fi"/>
                                      </propertyReferenceExpression>
                                      <primitiveExpression value="month"/>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <assignStatement>
                                      <variableReferenceExpression name="addValueToArray"/>
                                      <primitiveExpression value="false"/>
                                    </assignStatement>
                                    <methodInvokeExpression methodName="Add">
                                      <target>
                                        <variableReferenceExpression name="pivotValuesList"/>
                                      </target>
                                      <parameters>
                                        <arrayIndexerExpression>
                                          <target>
                                            <propertyReferenceExpression name="MonthNames">
                                              <propertyReferenceExpression name="DateTimeFormat">
                                                <variableReferenceExpression name="ci"/>
                                              </propertyReferenceExpression>
                                            </propertyReferenceExpression>
                                          </target>
                                          <indices>
                                            <binaryOperatorExpression operator="Subtract">
                                              <variableReferenceExpression name="val"/>
                                              <primitiveExpression value="1"/>
                                            </binaryOperatorExpression>
                                          </indices>
                                        </arrayIndexerExpression>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </trueStatements>
                                </conditionStatement>
                              </falseStatements>
                            </conditionStatement>
                          </trueStatements>
                          <!-- if TimeSpan-->
                          <falseStatements>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="ValueEquality">
                                  <methodInvokeExpression methodName="GetType">
                                    <target>
                                      <argumentReferenceExpression name="value"/>
                                    </target>
                                  </methodInvokeExpression>
                                  <typeofExpression type="TimeSpan"/>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <variableDeclarationStatement type="TimeSpan" name="time">
                                  <init>
                                    <castExpression targetType="TimeSpan">
                                      <argumentReferenceExpression name="value"/>
                                    </castExpression>
                                  </init>
                                </variableDeclarationStatement>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="ValueEquality">
                                      <propertyReferenceExpression name="Bucket">
                                        <argumentReferenceExpression name="fi"/>
                                      </propertyReferenceExpression>
                                      <primitiveExpression value="second"/>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>

                                    <assignStatement>
                                      <variableReferenceExpression name="value"/>
                                      <propertyReferenceExpression name="Seconds">
                                        <variableReferenceExpression name="time"/>
                                      </propertyReferenceExpression>
                                    </assignStatement>
                                  </trueStatements>
                                  <falseStatements>
                                    <conditionStatement>
                                      <condition>
                                        <binaryOperatorExpression operator="ValueEquality">
                                          <propertyReferenceExpression name="Bucket">
                                            <argumentReferenceExpression name="fi"/>
                                          </propertyReferenceExpression>
                                          <primitiveExpression value="minute"/>
                                        </binaryOperatorExpression>
                                      </condition>
                                      <trueStatements>

                                        <assignStatement>
                                          <variableReferenceExpression name="value"/>
                                          <propertyReferenceExpression name="Minutes">
                                            <variableReferenceExpression name="time"/>
                                          </propertyReferenceExpression>
                                        </assignStatement>
                                      </trueStatements>
                                      <falseStatements>
                                        <conditionStatement>
                                          <condition>
                                            <binaryOperatorExpression operator="ValueEquality">
                                              <propertyReferenceExpression name="Bucket">
                                                <argumentReferenceExpression name="fi"/>
                                              </propertyReferenceExpression>
                                              <primitiveExpression value="hour"/>
                                            </binaryOperatorExpression>
                                          </condition>
                                          <trueStatements>

                                            <assignStatement>
                                              <variableReferenceExpression name="value"/>
                                              <propertyReferenceExpression name="Hours">
                                                <variableReferenceExpression name="time"/>
                                              </propertyReferenceExpression>
                                            </assignStatement>
                                          </trueStatements>
                                          <falseStatements>
                                            <conditionStatement>
                                              <condition>
                                                <binaryOperatorExpression operator="ValueEquality">
                                                  <propertyReferenceExpression name="Bucket">
                                                    <argumentReferenceExpression name="fi"/>
                                                  </propertyReferenceExpression>
                                                  <primitiveExpression value="day"/>
                                                </binaryOperatorExpression>
                                              </condition>
                                              <trueStatements>
                                                <assignStatement>
                                                  <variableReferenceExpression name="value"/>
                                                  <propertyReferenceExpression name="Days">
                                                    <variableReferenceExpression name="time"/>
                                                  </propertyReferenceExpression>
                                                </assignStatement>
                                              </trueStatements>
                                            </conditionStatement>
                                          </falseStatements>
                                        </conditionStatement>
                                      </falseStatements>
                                    </conditionStatement>
                                  </falseStatements>
                                </conditionStatement>
                              </trueStatements>
                            </conditionStatement>
                          </falseStatements>
                        </conditionStatement>
                      </falseStatements>
                    </conditionStatement>
                  </trueStatements>
                </conditionStatement>

                <conditionStatement>
                  <condition>
                    <variableReferenceExpression name="addValueToArray"/>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <argumentReferenceExpression name="pivotValuesList"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="value"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="System.Object" name="formattedValue">
                  <init>
                    <argumentReferenceExpression name="value"/>
                  </init>
                </variableDeclarationStatement>
                <comment>Format field value in sortable form</comment>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <methodInvokeExpression methodName="GetType">
                        <target>
                          <argumentReferenceExpression name="value"/>
                        </target>
                      </methodInvokeExpression>
                      <typeofExpression type="DateTime"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="formattedValue"/>
                      <methodInvokeExpression methodName="ToString">
                        <target>
                          <castExpression targetType="DateTime">
                            <argumentReferenceExpression name="value"/>
                          </castExpression>
                        </target>
                        <parameters>
                          <primitiveExpression value="s"/>
                        </parameters>
                      </methodInvokeExpression>
                    </assignStatement>
                  </trueStatements>
                  <falseStatements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="ValueEquality">
                          <methodInvokeExpression methodName="GetType">
                            <target>
                              <argumentReferenceExpression name="value"/>
                            </target>
                          </methodInvokeExpression>
                          <typeofExpression type="TimeSpan"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="formattedValue"/>
                          <methodInvokeExpression methodName="ToString">
                            <target>
                              <castExpression targetType="TimeSpan">
                                <argumentReferenceExpression name="value"/>
                              </castExpression>
                            </target>
                            <parameters>
                              <primitiveExpression value="hh\:mm\:ss"/>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                      </trueStatements>
                      <falseStatements>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="ValueEquality">
                              <methodInvokeExpression methodName="GetType">
                                <target>
                                  <argumentReferenceExpression name="value"/>
                                </target>
                              </methodInvokeExpression>
                              <typeofExpression type="System.Int32"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="formattedValue"/>
                              <methodInvokeExpression methodName="ToString">
                                <target>
                                  <castExpression targetType="System.Int32">
                                    <argumentReferenceExpression name="value"/>
                                  </castExpression>
                                </target>
                                <parameters>
                                  <primitiveExpression value="D10"/>
                                </parameters>
                              </methodInvokeExpression>
                            </assignStatement>
                          </trueStatements>
                          <falseStatements>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="ValueEquality">
                                  <methodInvokeExpression methodName="GetType">
                                    <target>
                                      <argumentReferenceExpression name="value"/>
                                    </target>
                                  </methodInvokeExpression>
                                  <typeofExpression type="System.Int16"/>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="formattedValue"/>
                                  <methodInvokeExpression methodName="ToString">
                                    <target>
                                      <castExpression targetType="System.Int16">
                                        <argumentReferenceExpression name="value"/>
                                      </castExpression>
                                    </target>
                                    <parameters>
                                      <primitiveExpression value="D5"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                </assignStatement>
                              </trueStatements>
                              <falseStatements>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="ValueEquality">
                                      <methodInvokeExpression methodName="GetType">
                                        <target>
                                          <argumentReferenceExpression name="value"/>
                                        </target>
                                      </methodInvokeExpression>
                                      <typeofExpression type="System.Int64"/>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <assignStatement>
                                      <variableReferenceExpression name="formattedValue"/>
                                      <methodInvokeExpression methodName="ToString">
                                        <target>
                                          <castExpression targetType="System.Int64">
                                            <argumentReferenceExpression name="value"/>
                                          </castExpression>
                                        </target>
                                        <parameters>
                                          <primitiveExpression value="D10"/>
                                        </parameters>
                                      </methodInvokeExpression>
                                    </assignStatement>
                                  </trueStatements>
                                  <falseStatements>
                                    <conditionStatement>
                                      <condition>
                                        <binaryOperatorExpression operator="ValueEquality">
                                          <methodInvokeExpression methodName="GetType">
                                            <target>
                                              <argumentReferenceExpression name="value"/>
                                            </target>
                                          </methodInvokeExpression>
                                          <typeofExpression type="System.Decimal"/>
                                        </binaryOperatorExpression>
                                      </condition>
                                      <trueStatements>
                                        <assignStatement>
                                          <variableReferenceExpression name="formattedValue"/>
                                          <methodInvokeExpression methodName="ToString">
                                            <target>
                                              <castExpression targetType="System.Decimal">
                                                <argumentReferenceExpression name="value"/>
                                              </castExpression>
                                            </target>
                                            <parameters>
                                              <primitiveExpression value="D20"/>
                                            </parameters>
                                          </methodInvokeExpression>
                                        </assignStatement>
                                      </trueStatements>
                                      <falseStatements>
                                        <conditionStatement>
                                          <condition>
                                            <binaryOperatorExpression operator="ValueInequality">
                                              <argumentReferenceExpression name="value"/>
                                              <primitiveExpression value="null"/>
                                            </binaryOperatorExpression>
                                          </condition>
                                          <trueStatements>
                                            <assignStatement>
                                              <variableReferenceExpression name="formattedValue"/>
                                              <methodInvokeExpression methodName="ToString">
                                                <target>
                                                  <argumentReferenceExpression name="value"/>
                                                </target>
                                              </methodInvokeExpression>
                                            </assignStatement>
                                          </trueStatements>
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
                  </falseStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <variableReferenceExpression name="formattedValue"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- Iso8601WeekNumber(DateTime)-->
            <memberMethod returnType="System.Int32" name="Iso8601WeekNumber">
              <attributes static="true"/>
              <parameters>
                <parameter type="DateTime" name="dt"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="GetWeekOfYear">
                    <target>
                      <propertyReferenceExpression name="Calendar">
                        <propertyReferenceExpression name="CurrentCulture">
                          <typeReferenceExpression type="CultureInfo"/>
                        </propertyReferenceExpression>
                      </propertyReferenceExpression>
                    </target>
                    <parameters>
                      <argumentReferenceExpression name="dt"/>
                      <propertyReferenceExpression name="FirstFourDayWeek">
                        <typeReferenceExpression type="CalendarWeekRule"/>
                      </propertyReferenceExpression>
                      <propertyReferenceExpression name="Monday">
                        <typeReferenceExpression type="DayOfWeek"/>
                      </propertyReferenceExpression>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- Serialize()-->
            <memberMethod returnType="System.Object[]" name="Serialize">
              <attributes />
              <statements>
                <methodInvokeExpression methodName="ValidateData"/>
                <variableDeclarationStatement type="System.Int32" name="columnDepth">
                  <init>
                    <propertyReferenceExpression name="Count">
                      <fieldReferenceExpression name="columnFields"/>
                    </propertyReferenceExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.Int32" name="rowDepth">
                  <init>
                    <propertyReferenceExpression name="Count">
                      <fieldReferenceExpression name="rowFields"/>
                    </propertyReferenceExpression>
                  </init>
                </variableDeclarationStatement>
                <comment>rows of the pivot</comment>
                <variableDeclarationStatement type="List" name="rowList">
                  <typeArguments>
                    <typeReference type="System.Object"/>
                  </typeArguments>
                  <init>
                    <objectCreateExpression type="List">
                      <typeArguments>
                        <typeReference type="System.Object"/>
                      </typeArguments>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <comment>add header row</comment>
                <variableDeclarationStatement type="List" name="columnHeaderList">
                  <typeArguments>
                    <typeReference type="System.Object"/>
                  </typeArguments>
                  <init>
                    <objectCreateExpression type="List">
                      <typeArguments>
                        <typeReference type="System.Object"/>
                      </typeArguments>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <comment>add row label label</comment>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueInequality">
                      <variableReferenceExpression name="rowDepth"/>
                      <primitiveExpression value="0"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <variableReferenceExpression name="columnHeaderList"/>
                      </target>
                      <parameters>
                        <methodInvokeExpression methodName="GetLabel">
                          <parameters>
                            <methodInvokeExpression methodName="ToArray">
                              <target>
                                <propertyReferenceExpression name="Values">
                                  <fieldReferenceExpression name="rowFields"/>
                                </propertyReferenceExpression>
                              </target>
                            </methodInvokeExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                  <falseStatements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="ValueInequality">
                          <variableReferenceExpression name="columnDepth"/>
                          <primitiveExpression value="0"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <variableReferenceExpression name="columnHeaderList"/>
                          </target>
                          <parameters>
                            <methodInvokeExpression methodName="GetLabel">
                              <parameters>
                                <methodInvokeExpression methodName="ToArray">
                                  <target>
                                    <propertyReferenceExpression name="Values">
                                      <fieldReferenceExpression name="columnFields"/>
                                    </propertyReferenceExpression>
                                  </target>
                                </methodInvokeExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                      <falseStatements>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <variableReferenceExpression name="columnHeaderList"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="ValuesName"/>
                          </parameters>
                        </methodInvokeExpression>
                      </falseStatements>
                    </conditionStatement>
                  </falseStatements>
                </conditionStatement>
                <comment>add column header labels</comment>
                <foreachStatement>
                  <variable type="DimensionInfo" name="dim"/>
                  <target>
                    <propertyReferenceExpression name="Values">
                      <fieldReferenceExpression name="columns"/>
                    </propertyReferenceExpression>
                  </target>
                  <statements>
                    <comment>skip group headers</comment>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanOr">
                          <binaryOperatorExpression operator="ValueEquality">
                            <propertyReferenceExpression name="Depth">
                              <variableReferenceExpression name="dim"/>
                            </propertyReferenceExpression>
                            <variableReferenceExpression name="columnDepth"/>
                          </binaryOperatorExpression>
                          <propertyReferenceExpression name="SubtotalsEnabled"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="System.String" name="columnLabel">
                          <init>
                            <methodInvokeExpression methodName="GetLabel">
                              <parameters>
                                <propertyReferenceExpression name="Labels">
                                  <variableReferenceExpression name="dim"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="ValueEquality">
                              <propertyReferenceExpression name="Count">
                                <fieldReferenceExpression name="valueFields"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="1"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <conditionStatement>
                              <condition>
                                <unaryOperatorExpression operator="IsNotNullOrEmpty">
                                  <variableReferenceExpression name="columnLabel"/>
                                </unaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <methodInvokeExpression methodName="Add">
                                  <target>
                                    <variableReferenceExpression name="columnHeaderList"/>
                                  </target>
                                  <parameters>
                                    <variableReferenceExpression name="columnLabel"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </trueStatements>
                              <falseStatements>
                                <methodInvokeExpression methodName="Add">
                                  <target>
                                    <variableReferenceExpression name="columnHeaderList"/>
                                  </target>
                                  <parameters>
                                    <propertyReferenceExpression name="ValuesName"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </falseStatements>
                            </conditionStatement>
                          </trueStatements>
                          <falseStatements>
                            <foreachStatement>
                              <variable type="FieldInfo" name="fi"/>
                              <target>
                                <propertyReferenceExpression name="Values">
                                  <fieldReferenceExpression name="valueFields"/>
                                </propertyReferenceExpression>
                              </target>
                              <statements>
                                <conditionStatement>
                                  <condition>
                                    <unaryOperatorExpression operator="IsNotNullOrEmpty">
                                      <variableReferenceExpression name="columnLabel"/>
                                    </unaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <methodInvokeExpression methodName="Add">
                                      <target>
                                        <variableReferenceExpression name="columnHeaderList"/>
                                      </target>
                                      <parameters>
                                        <stringFormatExpression format="{{0}}, {{1}}">
                                          <variableReferenceExpression name="columnLabel"/>
                                          <propertyReferenceExpression name="Name">
                                            <propertyReferenceExpression name="Field">
                                              <variableReferenceExpression name="fi"/>
                                            </propertyReferenceExpression>
                                          </propertyReferenceExpression>
                                        </stringFormatExpression>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </trueStatements>
                                  <falseStatements>
                                    <methodInvokeExpression methodName="Add">
                                      <target>
                                        <variableReferenceExpression name="columnHeaderList"/>
                                      </target>
                                      <parameters>
                                        <propertyReferenceExpression name="Name">
                                          <propertyReferenceExpression name="Field">
                                            <variableReferenceExpression name="fi"/>
                                          </propertyReferenceExpression>
                                        </propertyReferenceExpression>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </falseStatements>
                                </conditionStatement>
                              </statements>
                            </foreachStatement>
                          </falseStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
                <comment>TODO localize</comment>
                <conditionStatement>
                  <condition>
                    <propertyReferenceExpression name="GrandTotalsEnabled"/>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <variableReferenceExpression name="columnHeaderList"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="Grand Totals"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <variableReferenceExpression name="rowList"/>
                  </target>
                  <parameters>
                    <methodInvokeExpression methodName="ToArray">
                      <target>
                        <variableReferenceExpression name="columnHeaderList"/>
                      </target>
                    </methodInvokeExpression>
                  </parameters>
                </methodInvokeExpression>
                <comment>add rows</comment>
                <foreachStatement>
                  <variable type="DimensionInfo" name="rowInfo"/>
                  <target>
                    <propertyReferenceExpression name="Values">
                      <fieldReferenceExpression name="rows"/>
                    </propertyReferenceExpression>
                  </target>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanOr">
                          <binaryOperatorExpression operator="ValueEquality">
                            <propertyReferenceExpression name="Depth">
                              <variableReferenceExpression name="rowInfo"/>
                            </propertyReferenceExpression>
                            <variableReferenceExpression name="rowDepth"/>
                          </binaryOperatorExpression>
                          <propertyReferenceExpression name="SubtotalsEnabled"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="System.String" name="row">
                          <init>
                            <propertyReferenceExpression name="Key">
                              <variableReferenceExpression name="rowInfo"/>
                            </propertyReferenceExpression>
                          </init>
                        </variableDeclarationStatement>
                        <variableDeclarationStatement type="List" name="columnList">
                          <typeArguments>
                            <typeReference type="System.Object"/>
                          </typeArguments>
                          <init>
                            <objectCreateExpression type="List">
                              <typeArguments>
                                <typeReference type="System.Object"/>
                              </typeArguments>
                            </objectCreateExpression>
                          </init>
                        </variableDeclarationStatement>
                        <comment>row label</comment>
                        <variableDeclarationStatement type="System.String" name="rowLabel">
                          <init>
                            <methodInvokeExpression methodName="GetLabel">
                              <parameters>
                                <propertyReferenceExpression name="Labels">
                                  <variableReferenceExpression name="rowInfo"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <unaryOperatorExpression operator="IsNotNullOrEmpty">
                              <variableReferenceExpression name="rowLabel"/>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <variableReferenceExpression name="columnList"/>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="rowLabel"/>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                          <falseStatements>
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <variableReferenceExpression name="columnList"/>
                              </target>
                              <parameters>
                                <propertyReferenceExpression name="ValuesName"/>
                              </parameters>
                            </methodInvokeExpression>
                          </falseStatements>
                        </conditionStatement>
                        <comment>columns</comment>
                        <foreachStatement>
                          <variable type="DimensionInfo" name="columnInfo"/>
                          <target>
                            <propertyReferenceExpression name="Values">
                              <fieldReferenceExpression name="columns"/>
                            </propertyReferenceExpression>
                          </target>
                          <statements>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="BooleanOr">
                                  <binaryOperatorExpression operator="ValueEquality">
                                    <propertyReferenceExpression name="Depth">
                                      <variableReferenceExpression name="columnInfo"/>
                                    </propertyReferenceExpression>
                                    <variableReferenceExpression name="columnDepth"/>
                                  </binaryOperatorExpression>
                                  <propertyReferenceExpression name="SubtotalsEnabled"/>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <variableDeclarationStatement type="System.String" name="column">
                                  <init>
                                    <propertyReferenceExpression name="Key">
                                      <variableReferenceExpression name="columnInfo"/>
                                    </propertyReferenceExpression>
                                  </init>
                                </variableDeclarationStatement>
                                <comment>add values</comment>
                                <foreachStatement>
                                  <variable type="FieldInfo" name="fi"/>
                                  <target>
                                    <propertyReferenceExpression name="Values">
                                      <fieldReferenceExpression name="valueFields"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <statements>
                                    <comment>form value key</comment>
                                    <variableDeclarationStatement type="System.String" name="valueKey">
                                      <init>
                                        <stringFormatExpression format="{{0}},{{1}}">
                                          <variableReferenceExpression name="row"/>
                                          <variableReferenceExpression name="column"/>
                                        </stringFormatExpression>
                                      </init>
                                    </variableDeclarationStatement>
                                    <conditionStatement>
                                      <condition>
                                        <binaryOperatorExpression operator="GreaterThan">
                                          <propertyReferenceExpression name="Count">
                                            <fieldReferenceExpression name="valueFields"/>
                                          </propertyReferenceExpression>
                                          <primitiveExpression value="1"/>
                                        </binaryOperatorExpression>
                                      </condition>
                                      <trueStatements>
                                        <assignStatement>
                                          <variableReferenceExpression name="valueKey"/>
                                          <stringFormatExpression format="{{0}},{{1}}">
                                            <variableReferenceExpression name="valueKey"/>
                                            <propertyReferenceExpression name="Name">
                                              <propertyReferenceExpression name="Field">
                                                <variableReferenceExpression name="fi"/>
                                              </propertyReferenceExpression>
                                            </propertyReferenceExpression>
                                          </stringFormatExpression>
                                        </assignStatement>
                                        <conditionStatement>
                                          <condition>
                                            <unaryOperatorExpression operator="IsNotNullOrEmpty">
                                              <propertyReferenceExpression name="Bucket">
                                                <variableReferenceExpression name="fi"/>
                                              </propertyReferenceExpression>
                                            </unaryOperatorExpression>
                                          </condition>
                                          <trueStatements>
                                            <assignStatement>
                                              <variableReferenceExpression name="valueKey"/>
                                              <stringFormatExpression format="{{0}},{{1}}">
                                                <variableReferenceExpression name="valueKey"/>
                                                <propertyReferenceExpression name="Mode">
                                                  <variableReferenceExpression name="fi"/>
                                                </propertyReferenceExpression>
                                              </stringFormatExpression>
                                            </assignStatement>
                                          </trueStatements>
                                        </conditionStatement>
                                      </trueStatements>
                                    </conditionStatement>
                                    <variableDeclarationStatement type="ValueInfo" name="value">
                                      <init>
                                        <primitiveExpression value="null"/>
                                      </init>
                                    </variableDeclarationStatement>
                                    <conditionStatement>
                                      <condition>
                                        <methodInvokeExpression methodName="TryGetValue">
                                          <target>
                                            <fieldReferenceExpression name="values"/>
                                          </target>
                                          <parameters>
                                            <variableReferenceExpression name="valueKey"/>
                                            <directionExpression direction="Out">
                                              <variableReferenceExpression name="value"/>
                                            </directionExpression>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </condition>
                                      <trueStatements>
                                        <methodInvokeExpression methodName="Add">
                                          <target>
                                            <variableReferenceExpression name="columnList"/>
                                          </target>
                                          <parameters>
                                            <methodInvokeExpression methodName="Serialize">
                                              <target>
                                                <variableReferenceExpression name="value"/>
                                              </target>
                                            </methodInvokeExpression>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </trueStatements>
                                      <falseStatements>
                                        <methodInvokeExpression methodName="Add">
                                          <target>
                                            <variableReferenceExpression name="columnList"/>
                                          </target>
                                          <parameters>
                                            <primitiveExpression value="null"/>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </falseStatements>
                                    </conditionStatement>
                                  </statements>
                                </foreachStatement>
                              </trueStatements>
                            </conditionStatement>
                          </statements>
                        </foreachStatement>
                        <comment>grand total of row</comment>
                        <conditionStatement>
                          <condition>
                            <propertyReferenceExpression name="GrandTotalsEnabled"/>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <variableReferenceExpression name="columnList"/>
                              </target>
                              <parameters>
                                <methodInvokeExpression methodName="Serialize">
                                  <target>
                                    <propertyReferenceExpression name="Values">
                                      <variableReferenceExpression name="rowInfo"/>
                                    </propertyReferenceExpression>
                                  </target>
                                </methodInvokeExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <variableReferenceExpression name="rowList"/>
                          </target>
                          <parameters>
                            <methodInvokeExpression methodName="ToArray">
                              <target>
                                <variableReferenceExpression name="columnList"/>
                              </target>
                            </methodInvokeExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
                <conditionStatement>
                  <condition>
                    <propertyReferenceExpression name="GrandTotalsEnabled"/>
                  </condition>
                  <trueStatements>
                    <comment>grand totals for columns</comment>
                    <variableDeclarationStatement type="List" name="grandTotalRowList">
                      <typeArguments>
                        <typeReference type="System.Object"/>
                      </typeArguments>
                      <init>
                        <objectCreateExpression type="List">
                          <typeArguments>
                            <typeReference type="System.Object"/>
                          </typeArguments>
                        </objectCreateExpression>
                      </init>
                    </variableDeclarationStatement>
                    <comment>TODO localize</comment>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <variableReferenceExpression name="grandTotalRowList"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="Grand Totals"/>
                      </parameters>
                    </methodInvokeExpression>
                    <foreachStatement>
                      <variable type="DimensionInfo" name="columnInfo"/>
                      <target>
                        <propertyReferenceExpression name="Values">
                          <fieldReferenceExpression name="columns"/>
                        </propertyReferenceExpression>
                      </target>
                      <statements>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <variableReferenceExpression name="grandTotalRowList"/>
                          </target>
                          <parameters>
                            <methodInvokeExpression methodName="Serialize">
                              <target>
                                <propertyReferenceExpression name="Values">
                                  <variableReferenceExpression name="columnInfo"/>
                                </propertyReferenceExpression>
                              </target>
                            </methodInvokeExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </statements>
                    </foreachStatement>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <variableReferenceExpression name="grandTotalRowList"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="RecordCount"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <variableReferenceExpression name="rowList"/>
                      </target>
                      <parameters>
                        <methodInvokeExpression methodName="ToArray">
                          <target>
                            <variableReferenceExpression name="grandTotalRowList"/>
                          </target>
                        </methodInvokeExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="ToArray">
                    <target>
                      <variableReferenceExpression name="rowList"/>
                    </target>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- GetLabel(object[])-->
            <memberMethod returnType="System.String" name="GetLabel">
              <attributes static="true"/>
              <parameters>
                <parameter type="System.Object[]" name="list"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <argumentReferenceExpression name="list"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <stringEmptyExpression/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="StringBuilder" name="columnBuilder">
                  <init>
                    <objectCreateExpression type="StringBuilder"/>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.Boolean" name="firstRowValue">
                  <init>
                    <primitiveExpression value="true"/>
                  </init>
                </variableDeclarationStatement>
                <foreachStatement>
                  <variable type="System.Object" name="val"/>
                  <target>
                    <argumentReferenceExpression name="list"/>
                  </target>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanOr">
                          <binaryOperatorExpression operator="ValueInequality">
                            <methodInvokeExpression methodName="GetType">
                              <target>
                                <argumentReferenceExpression name="val"/>
                              </target>
                            </methodInvokeExpression>
                            <typeofExpression type="System.String"/>
                          </binaryOperatorExpression>
                          <unaryOperatorExpression operator="IsNotNullOrEmpty">
                            <castExpression targetType="System.String">
                              <argumentReferenceExpression name="val"/>
                            </castExpression>
                          </unaryOperatorExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <conditionStatement>
                          <condition>
                            <variableReferenceExpression name="firstRowValue"/>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="firstRowValue"/>
                              <primitiveExpression value="false"/>
                            </assignStatement>
                          </trueStatements>
                          <falseStatements>
                            <methodInvokeExpression methodName="Append">
                              <target>
                                <variableReferenceExpression name="columnBuilder"/>
                              </target>
                              <parameters>
                                <primitiveExpression value=", "/>
                              </parameters>
                            </methodInvokeExpression>
                          </falseStatements>
                        </conditionStatement>
                        <methodInvokeExpression methodName="Append">
                          <target>
                            <variableReferenceExpression name="columnBuilder"/>
                          </target>
                          <parameters>
                            <argumentReferenceExpression name="val"/>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="ToString">
                    <target>
                      <variableReferenceExpression name="columnBuilder"/>
                    </target>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
        <typeDeclaration name="ValueInfo">
          <attributes public="true"/>
          <members>
            <!-- property Count-->
            <memberProperty type="System.Int32" name="Count"/>
            <!-- property Sum-->
            <memberProperty type="System.Object" name="Sum">
              <attributes public="true"/>
            </memberProperty>
            <!-- property Min-->
            <memberProperty type="System.Object" name="Min">
              <attributes public="true"/>
            </memberProperty>
            <!-- property Max-->
            <memberProperty type="System.Object" name="Max">
              <attributes public="true"/>
            </memberProperty>
            <!-- property Average-->
            <memberProperty type="System.Object" name="Average">
              <attributes public="true"/>
            </memberProperty>
            <!-- field Field-->
            <memberField type="FieldInfo" name="Field">
              <attributes public="true"/>
            </memberField>
            <!-- field FieldType-->
            <memberField type="Type" name="fieldType"/>
            <!-- property FieldType-->
            <memberProperty type="Type" name="FieldType">
              <attributes public="true"/>
              <getStatements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <binaryOperatorExpression operator="IdentityEquality">
                        <fieldReferenceExpression name="fieldType"/>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                      <binaryOperatorExpression operator="IdentityInequality">
                        <propertyReferenceExpression name="Field"/>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <fieldReferenceExpression name="fieldType"/>
                      <propertyReferenceExpression name="FieldType">
                        <propertyReferenceExpression name="Field"/>
                      </propertyReferenceExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <fieldReferenceExpression name="fieldType"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="fieldType"/>
                  <variableReferenceExpression name="value"/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property Mode-->
            <memberProperty type="System.String" name="Mode">
              <attributes private="true"/>
              <getStatements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <propertyReferenceExpression name="Field"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <propertyReferenceExpression name="Mode">
                        <propertyReferenceExpression name="Field"/>
                      </propertyReferenceExpression>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <primitiveExpression value="count"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- field values-->
            <memberField type="List" name="values">
              <typeArguments>
                <typeReference type="System.Object"/>
              </typeArguments>
              <init>
                <objectCreateExpression type="List">
                  <typeArguments>
                    <typeReference type="System.Object"/>
                  </typeArguments>
                </objectCreateExpression>
              </init>
            </memberField>
            <!-- property Values-->
            <memberProperty type="List" name="Values">
              <typeArguments>
                <typeReference type="System.Object"/>
              </typeArguments>
              <attributes public="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="values"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="values"/>
                  <variableReferenceExpression name="value"/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- constructor ValueInfo() -->
            <constructor>
              <attributes public="true"/>
            </constructor>
            <!-- constructor ValueInfo(FieldInfo)-->
            <constructor>
              <attributes public="true"/>
              <parameters>
                <parameter type="FieldInfo" name="fi"/>
              </parameters>
              <statements>
                <assignStatement>
                  <propertyReferenceExpression name="Field">
                    <thisReferenceExpression/>
                  </propertyReferenceExpression>
                  <argumentReferenceExpression name="fi"/>
                </assignStatement>
              </statements>
            </constructor>
            <!-- method Add(object)-->
            <memberMethod name="Add">
              <attributes public="true"/>
              <parameters>
                <parameter type="System.Object" name="value"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <propertyReferenceExpression name="FieldType"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <propertyReferenceExpression name="FieldType"/>
                      <methodInvokeExpression methodName="GetType">
                        <target>
                          <argumentReferenceExpression name="value"/>
                        </target>
                      </methodInvokeExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <incrementStatement>
                  <propertyReferenceExpression name="Count"/>
                </incrementStatement>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <propertyReferenceExpression name="Values"/>
                  </target>
                  <parameters>
                    <argumentReferenceExpression name="value"/>
                  </parameters>
                </methodInvokeExpression>

                <comment>additional processing based on type</comment>
                <conditionStatement>
                  <!-- bool-->
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <propertyReferenceExpression name="FieldType"/>
                      <typeofExpression type="System.Boolean"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="ValueEquality">
                          <propertyReferenceExpression name="Sum"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <propertyReferenceExpression name="Sum"/>
                          <castExpression targetType="System.Int64">
                            <primitiveExpression value="0"/>
                          </castExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                    <conditionStatement>
                      <condition>
                        <castExpression targetType="System.Boolean">
                          <argumentReferenceExpression name="value"/>
                        </castExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <propertyReferenceExpression name="Sum"/>
                          <binaryOperatorExpression operator="Add">
                            <castExpression targetType="System.Int64">
                              <propertyReferenceExpression name="Sum"/>
                            </castExpression>
                            <primitiveExpression value="1"/>
                          </binaryOperatorExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                  </trueStatements>
                  <falseStatements>
                    <conditionStatement>
                      <!-- signed #s-->
                      <condition>
                        <binaryOperatorExpression operator="BooleanOr">
                          <binaryOperatorExpression operator="ValueEquality">
                            <propertyReferenceExpression name="FieldType"/>
                            <typeofExpression type="System.SByte"/>
                          </binaryOperatorExpression>
                          <binaryOperatorExpression operator="BooleanOr">
                            <binaryOperatorExpression operator="ValueEquality">
                              <propertyReferenceExpression name="FieldType"/>
                              <typeofExpression type="System.Int16"/>
                            </binaryOperatorExpression>
                            <binaryOperatorExpression operator="BooleanOr">
                              <binaryOperatorExpression operator="ValueEquality">
                                <propertyReferenceExpression name="FieldType"/>
                                <typeofExpression type="System.Int32"/>
                              </binaryOperatorExpression>
                              <binaryOperatorExpression operator="ValueEquality">
                                <propertyReferenceExpression name="FieldType"/>
                                <typeofExpression type="System.Int64"/>
                              </binaryOperatorExpression>
                            </binaryOperatorExpression>
                          </binaryOperatorExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="System.Int64" name="val">
                          <init>
                            <convertExpression to="Int64">
                              <argumentReferenceExpression name="value"/>
                            </convertExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="ValueEquality">
                              <propertyReferenceExpression name="Sum"/>
                              <primitiveExpression value="null"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="Sum"/>
                              <variableReferenceExpression name="val"/>
                            </assignStatement>
                          </trueStatements>
                          <falseStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="Sum"/>
                              <binaryOperatorExpression operator="Add">
                                <castExpression targetType="System.Int64">
                                  <propertyReferenceExpression name="Sum"/>
                                </castExpression>
                                <variableReferenceExpression name="val"/>
                              </binaryOperatorExpression>
                            </assignStatement>
                          </falseStatements>
                        </conditionStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="BooleanOr">
                              <binaryOperatorExpression operator="ValueEquality">
                                <propertyReferenceExpression name="Min"/>
                                <primitiveExpression value="null"/>
                              </binaryOperatorExpression>
                              <binaryOperatorExpression operator="LessThan">
                                <variableReferenceExpression name="val"/>
                                <castExpression targetType="System.Int64">
                                  <propertyReferenceExpression name="Min"/>
                                </castExpression>
                              </binaryOperatorExpression>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="Min"/>
                              <variableReferenceExpression name="val"/>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="BooleanOr">
                              <binaryOperatorExpression operator="ValueEquality">
                                <propertyReferenceExpression name="Max"/>
                                <primitiveExpression value="null"/>
                              </binaryOperatorExpression>
                              <binaryOperatorExpression operator="GreaterThan">
                                <variableReferenceExpression name="val"/>
                                <castExpression targetType="System.Int64">
                                  <propertyReferenceExpression name="Max"/>
                                </castExpression>
                              </binaryOperatorExpression>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="Max"/>
                              <variableReferenceExpression name="val"/>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <assignStatement>
                          <propertyReferenceExpression name="Average"/>
                          <binaryOperatorExpression operator="Divide">
                            <castExpression targetType="System.Int64">
                              <propertyReferenceExpression name="Sum"/>
                            </castExpression>
                            <convertExpression to="Int64">
                              <propertyReferenceExpression name="Count"/>
                            </convertExpression>
                          </binaryOperatorExpression>
                        </assignStatement>
                      </trueStatements>
                      <falseStatements>
                        <conditionStatement>
                          <!-- unsigned #s-->
                          <condition>
                            <binaryOperatorExpression operator="BooleanOr">
                              <binaryOperatorExpression operator="ValueEquality">
                                <propertyReferenceExpression name="FieldType"/>
                                <typeofExpression type="System.Byte"/>
                              </binaryOperatorExpression>
                              <binaryOperatorExpression operator="BooleanOr">
                                <binaryOperatorExpression operator="ValueEquality">
                                  <propertyReferenceExpression name="FieldType"/>
                                  <typeofExpression type="System.UInt16"/>
                                </binaryOperatorExpression>
                                <binaryOperatorExpression operator="BooleanOr">
                                  <binaryOperatorExpression operator="ValueEquality">
                                    <propertyReferenceExpression name="FieldType"/>
                                    <typeofExpression type="System.UInt32"/>
                                  </binaryOperatorExpression>
                                  <binaryOperatorExpression operator="ValueEquality">
                                    <propertyReferenceExpression name="FieldType"/>
                                    <typeofExpression type="System.UInt64"/>
                                  </binaryOperatorExpression>
                                </binaryOperatorExpression>
                              </binaryOperatorExpression>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <variableDeclarationStatement type="System.UInt64" name="val">
                              <init>
                                <convertExpression to="UInt64">
                                  <argumentReferenceExpression name="value"/>
                                </convertExpression>
                              </init>
                            </variableDeclarationStatement>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="ValueEquality">
                                  <propertyReferenceExpression name="Sum"/>
                                  <primitiveExpression value="null"/>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <propertyReferenceExpression name="Sum"/>
                                  <variableReferenceExpression name="val"/>
                                </assignStatement>
                              </trueStatements>
                              <falseStatements>
                                <assignStatement>
                                  <propertyReferenceExpression name="Sum"/>
                                  <binaryOperatorExpression operator="Add">
                                    <castExpression targetType="System.UInt64">
                                      <propertyReferenceExpression name="Sum"/>
                                    </castExpression>
                                    <variableReferenceExpression name="val"/>
                                  </binaryOperatorExpression>
                                </assignStatement>
                              </falseStatements>
                            </conditionStatement>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="BooleanOr">
                                  <binaryOperatorExpression operator="ValueEquality">
                                    <propertyReferenceExpression name="Min"/>
                                    <primitiveExpression value="null"/>
                                  </binaryOperatorExpression>
                                  <binaryOperatorExpression operator="LessThan">
                                    <variableReferenceExpression name="val"/>
                                    <castExpression targetType="System.UInt64">
                                      <propertyReferenceExpression name="Min"/>
                                    </castExpression>
                                  </binaryOperatorExpression>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <propertyReferenceExpression name="Min"/>
                                  <variableReferenceExpression name="val"/>
                                </assignStatement>
                              </trueStatements>
                            </conditionStatement>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="BooleanOr">
                                  <binaryOperatorExpression operator="ValueEquality">
                                    <propertyReferenceExpression name="Max"/>
                                    <primitiveExpression value="null"/>
                                  </binaryOperatorExpression>
                                  <binaryOperatorExpression operator="GreaterThan">
                                    <variableReferenceExpression name="val"/>
                                    <castExpression targetType="System.UInt64">
                                      <propertyReferenceExpression name="Max"/>
                                    </castExpression>
                                  </binaryOperatorExpression>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <propertyReferenceExpression name="Max"/>
                                  <variableReferenceExpression name="val"/>
                                </assignStatement>
                              </trueStatements>
                            </conditionStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="Average"/>
                              <binaryOperatorExpression operator="Divide">
                                <castExpression targetType="System.UInt64">
                                  <propertyReferenceExpression name="Sum"/>
                                </castExpression>
                                <convertExpression to="UInt64">
                                  <propertyReferenceExpression name="Count"/>
                                </convertExpression>
                              </binaryOperatorExpression>
                            </assignStatement>
                          </trueStatements>
                          <falseStatements>
                            <conditionStatement>
                              <!-- floats-->
                              <condition>
                                <binaryOperatorExpression operator="BooleanOr">
                                  <binaryOperatorExpression operator="ValueEquality">
                                    <propertyReferenceExpression name="FieldType"/>
                                    <typeofExpression type="System.Single"/>
                                  </binaryOperatorExpression>
                                  <binaryOperatorExpression operator="ValueEquality">
                                    <propertyReferenceExpression name="FieldType"/>
                                    <typeofExpression type="System.Double"/>
                                  </binaryOperatorExpression>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <variableDeclarationStatement type="System.Double" name="val">
                                  <init>
                                    <convertExpression to="Double">
                                      <argumentReferenceExpression name="value"/>
                                    </convertExpression>
                                  </init>
                                </variableDeclarationStatement>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="ValueEquality">
                                      <propertyReferenceExpression name="Sum"/>
                                      <primitiveExpression value="null"/>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <assignStatement>
                                      <propertyReferenceExpression name="Sum"/>
                                      <variableReferenceExpression name="val"/>
                                    </assignStatement>
                                  </trueStatements>
                                  <falseStatements>
                                    <assignStatement>
                                      <propertyReferenceExpression name="Sum"/>
                                      <binaryOperatorExpression operator="Add">
                                        <castExpression targetType="System.Double">
                                          <propertyReferenceExpression name="Sum"/>
                                        </castExpression>
                                        <variableReferenceExpression name="val"/>
                                      </binaryOperatorExpression>
                                    </assignStatement>
                                  </falseStatements>
                                </conditionStatement>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="BooleanOr">
                                      <binaryOperatorExpression operator="ValueEquality">
                                        <propertyReferenceExpression name="Min"/>
                                        <primitiveExpression value="null"/>
                                      </binaryOperatorExpression>
                                      <binaryOperatorExpression operator="LessThan">
                                        <variableReferenceExpression name="val"/>
                                        <castExpression targetType="System.Double">
                                          <propertyReferenceExpression name="Min"/>
                                        </castExpression>
                                      </binaryOperatorExpression>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <assignStatement>
                                      <propertyReferenceExpression name="Min"/>
                                      <variableReferenceExpression name="val"/>
                                    </assignStatement>
                                  </trueStatements>
                                </conditionStatement>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="BooleanOr">
                                      <binaryOperatorExpression operator="ValueEquality">
                                        <propertyReferenceExpression name="Max"/>
                                        <primitiveExpression value="null"/>
                                      </binaryOperatorExpression>
                                      <binaryOperatorExpression operator="GreaterThan">
                                        <variableReferenceExpression name="val"/>
                                        <castExpression targetType="System.Double">
                                          <propertyReferenceExpression name="Max"/>
                                        </castExpression>
                                      </binaryOperatorExpression>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <assignStatement>
                                      <propertyReferenceExpression name="Max"/>
                                      <variableReferenceExpression name="val"/>
                                    </assignStatement>
                                  </trueStatements>
                                </conditionStatement>
                                <assignStatement>
                                  <propertyReferenceExpression name="Average"/>
                                  <binaryOperatorExpression operator="Divide">
                                    <castExpression targetType="System.Double">
                                      <propertyReferenceExpression name="Sum"/>
                                    </castExpression>
                                    <convertExpression to="Double">
                                      <propertyReferenceExpression name="Count"/>
                                    </convertExpression>
                                  </binaryOperatorExpression>
                                </assignStatement>
                              </trueStatements>
                              <falseStatements>
                                <conditionStatement>
                                  <!-- decimal -->
                                  <condition>
                                    <binaryOperatorExpression operator="ValueEquality">
                                      <propertyReferenceExpression name="FieldType"/>
                                      <typeofExpression type="System.Decimal"/>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <variableDeclarationStatement type="System.Decimal" name="val">
                                      <init>
                                        <convertExpression to="Decimal">
                                          <argumentReferenceExpression name="value"/>
                                        </convertExpression>
                                      </init>
                                    </variableDeclarationStatement>
                                    <conditionStatement>
                                      <condition>
                                        <binaryOperatorExpression operator="ValueEquality">
                                          <propertyReferenceExpression name="Sum"/>
                                          <primitiveExpression value="null"/>
                                        </binaryOperatorExpression>
                                      </condition>
                                      <trueStatements>
                                        <assignStatement>
                                          <propertyReferenceExpression name="Sum"/>
                                          <variableReferenceExpression name="val"/>
                                        </assignStatement>
                                      </trueStatements>
                                      <falseStatements>
                                        <assignStatement>
                                          <propertyReferenceExpression name="Sum"/>
                                          <binaryOperatorExpression operator="Add">
                                            <castExpression targetType="System.Decimal">
                                              <propertyReferenceExpression name="Sum"/>
                                            </castExpression>
                                            <variableReferenceExpression name="val"/>
                                          </binaryOperatorExpression>
                                        </assignStatement>
                                      </falseStatements>
                                    </conditionStatement>
                                    <conditionStatement>
                                      <condition>
                                        <binaryOperatorExpression operator="BooleanOr">
                                          <binaryOperatorExpression operator="ValueEquality">
                                            <propertyReferenceExpression name="Min"/>
                                            <primitiveExpression value="null"/>
                                          </binaryOperatorExpression>
                                          <binaryOperatorExpression operator="LessThan">
                                            <variableReferenceExpression name="val"/>
                                            <castExpression targetType="System.Decimal">
                                              <propertyReferenceExpression name="Min"/>
                                            </castExpression>
                                          </binaryOperatorExpression>
                                        </binaryOperatorExpression>
                                      </condition>
                                      <trueStatements>
                                        <assignStatement>
                                          <propertyReferenceExpression name="Min"/>
                                          <variableReferenceExpression name="val"/>
                                        </assignStatement>
                                      </trueStatements>
                                    </conditionStatement>
                                    <conditionStatement>
                                      <condition>
                                        <binaryOperatorExpression operator="BooleanOr">
                                          <binaryOperatorExpression operator="ValueEquality">
                                            <propertyReferenceExpression name="Max"/>
                                            <primitiveExpression value="null"/>
                                          </binaryOperatorExpression>
                                          <binaryOperatorExpression operator="GreaterThan">
                                            <variableReferenceExpression name="val"/>
                                            <castExpression targetType="System.Decimal">
                                              <propertyReferenceExpression name="Max"/>
                                            </castExpression>
                                          </binaryOperatorExpression>
                                        </binaryOperatorExpression>
                                      </condition>
                                      <trueStatements>
                                        <assignStatement>
                                          <propertyReferenceExpression name="Max"/>
                                          <variableReferenceExpression name="val"/>
                                        </assignStatement>
                                      </trueStatements>
                                    </conditionStatement>
                                    <assignStatement>
                                      <propertyReferenceExpression name="Average"/>
                                      <binaryOperatorExpression operator="Divide">
                                        <castExpression targetType="System.Decimal">
                                          <propertyReferenceExpression name="Sum"/>
                                        </castExpression>
                                        <convertExpression to="Decimal">
                                          <propertyReferenceExpression name="Count"/>
                                        </convertExpression>
                                      </binaryOperatorExpression>
                                    </assignStatement>
                                  </trueStatements>
                                  <falseStatements>
                                    <conditionStatement>
                                      <!-- datetime-->
                                      <condition>
                                        <binaryOperatorExpression operator="ValueEquality">
                                          <propertyReferenceExpression name="FieldType"/>
                                          <typeofExpression type="DateTime"/>
                                        </binaryOperatorExpression>
                                      </condition>
                                      <trueStatements>
                                        <variableDeclarationStatement type="DateTime" name="val">
                                          <init>
                                            <castExpression targetType="DateTime">
                                              <argumentReferenceExpression name="value"/>
                                            </castExpression>
                                          </init>
                                        </variableDeclarationStatement>
                                        <conditionStatement>
                                          <condition>
                                            <binaryOperatorExpression operator="BooleanOr">
                                              <binaryOperatorExpression operator="ValueEquality">
                                                <propertyReferenceExpression name="Min"/>
                                                <primitiveExpression value="null"/>
                                              </binaryOperatorExpression>
                                              <binaryOperatorExpression operator="LessThan">
                                                <variableReferenceExpression name="val"/>
                                                <castExpression targetType="DateTime">
                                                  <propertyReferenceExpression name="Min"/>
                                                </castExpression>
                                              </binaryOperatorExpression>
                                            </binaryOperatorExpression>
                                          </condition>
                                          <trueStatements>
                                            <assignStatement>
                                              <propertyReferenceExpression name="Min"/>
                                              <variableReferenceExpression name="val"/>
                                            </assignStatement>
                                          </trueStatements>
                                        </conditionStatement>
                                        <conditionStatement>
                                          <condition>
                                            <binaryOperatorExpression operator="BooleanOr">
                                              <binaryOperatorExpression operator="ValueEquality">
                                                <propertyReferenceExpression name="Max"/>
                                                <primitiveExpression value="null"/>
                                              </binaryOperatorExpression>
                                              <binaryOperatorExpression operator="GreaterThan">
                                                <variableReferenceExpression name="val"/>
                                                <castExpression targetType="DateTime">
                                                  <propertyReferenceExpression name="Max"/>
                                                </castExpression>
                                              </binaryOperatorExpression>
                                            </binaryOperatorExpression>
                                          </condition>
                                          <trueStatements>
                                            <assignStatement>
                                              <propertyReferenceExpression name="Max"/>
                                              <variableReferenceExpression name="val"/>
                                            </assignStatement>
                                          </trueStatements>
                                        </conditionStatement>
                                      </trueStatements>
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


              </statements>
            </memberMethod>
            <!-- Serialize()-->
            <memberMethod returnType="System.Object" name="Serialize">
              <attributes public="true"/>
              <statements>
                <variableDeclarationStatement type="Dictionary" name="valueList">
                  <typeArguments>
                    <typeReference type="System.String"/>
                    <typeReference type="System.Object"/>
                  </typeArguments>
                  <init>
                    <objectCreateExpression type="Dictionary">
                      <typeArguments>
                        <typeReference type="System.String"/>
                        <typeReference type="System.Object"/>
                      </typeArguments>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <variableReferenceExpression name="valueList"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="count"/>
                    <propertyReferenceExpression name="Count"/>
                  </parameters>
                </methodInvokeExpression>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanOr">
                      <binaryOperatorExpression operator="BooleanOr">
                        <binaryOperatorExpression operator="BooleanOr">
                          <binaryOperatorExpression operator="ValueEquality">
                            <propertyReferenceExpression name="FieldType"/>
                            <typeofExpression type="System.SByte"/>
                          </binaryOperatorExpression>
                          <binaryOperatorExpression operator="BooleanOr">
                            <binaryOperatorExpression operator="ValueEquality">
                              <propertyReferenceExpression name="FieldType"/>
                              <typeofExpression type="System.Int16"/>
                            </binaryOperatorExpression>
                            <binaryOperatorExpression operator="BooleanOr">
                              <binaryOperatorExpression operator="ValueEquality">
                                <propertyReferenceExpression name="FieldType"/>
                                <typeofExpression type="System.Int32"/>
                              </binaryOperatorExpression>
                              <binaryOperatorExpression operator="ValueEquality">
                                <propertyReferenceExpression name="FieldType"/>
                                <typeofExpression type="System.Int64"/>
                              </binaryOperatorExpression>
                            </binaryOperatorExpression>
                          </binaryOperatorExpression>
                        </binaryOperatorExpression>
                        <binaryOperatorExpression operator="BooleanOr">
                          <binaryOperatorExpression operator="ValueEquality">
                            <propertyReferenceExpression name="FieldType"/>
                            <typeofExpression type="System.Byte"/>
                          </binaryOperatorExpression>
                          <binaryOperatorExpression operator="BooleanOr">
                            <binaryOperatorExpression operator="ValueEquality">
                              <propertyReferenceExpression name="FieldType"/>
                              <typeofExpression type="System.UInt16"/>
                            </binaryOperatorExpression>
                            <binaryOperatorExpression operator="BooleanOr">
                              <binaryOperatorExpression operator="ValueEquality">
                                <propertyReferenceExpression name="FieldType"/>
                                <typeofExpression type="System.UInt32"/>
                              </binaryOperatorExpression>
                              <binaryOperatorExpression operator="ValueEquality">
                                <propertyReferenceExpression name="FieldType"/>
                                <typeofExpression type="System.UInt64"/>
                              </binaryOperatorExpression>
                            </binaryOperatorExpression>
                          </binaryOperatorExpression>
                        </binaryOperatorExpression>
                      </binaryOperatorExpression>
                      <binaryOperatorExpression operator="BooleanOr">
                        <binaryOperatorExpression operator="BooleanOr">
                          <binaryOperatorExpression operator="ValueEquality">
                            <propertyReferenceExpression name="FieldType"/>
                            <typeofExpression type="System.Single"/>
                          </binaryOperatorExpression>
                          <binaryOperatorExpression operator="ValueEquality">
                            <propertyReferenceExpression name="FieldType"/>
                            <typeofExpression type="System.Double"/>
                          </binaryOperatorExpression>
                        </binaryOperatorExpression>
                        <binaryOperatorExpression operator="ValueEquality">
                          <propertyReferenceExpression name="FieldType"/>
                          <typeofExpression type="System.Decimal"/>
                        </binaryOperatorExpression>
                      </binaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <variableReferenceExpression name="valueList"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="sum"/>
                        <propertyReferenceExpression name="Sum"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <variableReferenceExpression name="valueList"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="min"/>
                        <propertyReferenceExpression name="Min"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <variableReferenceExpression name="valueList"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="max"/>
                        <propertyReferenceExpression name="Max"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <variableReferenceExpression name="valueList"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="average"/>
                        <propertyReferenceExpression name="Average"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                  <falseStatements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="ValueEquality">
                          <propertyReferenceExpression name="FieldType"/>
                          <typeofExpression type="DateTime"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <variableReferenceExpression name="valueList"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="min"/>
                            <propertyReferenceExpression name="Min"/>
                          </parameters>
                        </methodInvokeExpression>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <variableReferenceExpression name="valueList"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="max"/>
                            <propertyReferenceExpression name="Max"/>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                  </falseStatements>
                </conditionStatement>

                <variableDeclarationStatement type="System.Object" name="value">
                  <init>
                    <primitiveExpression value="null"/>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanOr">
                      <unaryOperatorExpression operator="Not">
                        <methodInvokeExpression methodName="TryGetValue">
                          <target>
                            <variableReferenceExpression name="valueList"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="Mode"/>
                            <directionExpression direction="Out">
                              <variableReferenceExpression name="value"/>
                            </directionExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </unaryOperatorExpression>
                      <binaryOperatorExpression operator="ValueEquality">
                        <variableReferenceExpression name="value"/>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="value"/>
                      <arrayIndexerExpression>
                        <target>
                          <variableReferenceExpression name="valueList"/>
                        </target>
                        <indices>
                          <primitiveExpression value="count"/>
                        </indices>
                      </arrayIndexerExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <variableReferenceExpression name="value"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
        <typeDeclaration name="FieldInfo">
          <attributes public="true"/>
          <members>
            <!-- property Field-->
            <memberProperty type="DataField" name="Field">
              <attributes public="true"/>
            </memberProperty>
            <!-- property ValueField-->
            <memberProperty type="DataField" name="ValueField">
              <attributes public="true"/>
            </memberProperty>
            <!-- property FieldType-->
            <memberProperty type="Type" name="FieldType">
              <attributes public="true"/>
            </memberProperty>
            <!-- property Mode-->
            <memberProperty type="System.String" name="Mode">
              <attributes public="true"/>
            </memberProperty>
            <!-- property Bucket-->
            <memberProperty type="System.String" name="Bucket">
              <attributes public="true"/>
            </memberProperty>
            <!-- property ExpandBuckets-->
            <memberProperty type="System.Boolean" name="ExpandBuckets">
              <attributes public="true"/>
            </memberProperty>
            <!-- field Values-->
            <memberProperty type="ValueInfo" name="Values">
              <attributes public="true"/>
            </memberProperty>
            <!-- property Min-->
            <memberProperty type="System.Object" name="Min">
              <attributes public="true"/>
              <getStatements>
                <methodReturnStatement>
                  <propertyReferenceExpression name="Min">
                    <fieldReferenceExpression name="values"/>
                  </propertyReferenceExpression>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property Max-->
            <memberProperty type="System.Object" name="Max">
              <attributes public="true"/>
              <getStatements>
                <methodReturnStatement>
                  <propertyReferenceExpression name="Max">
                    <fieldReferenceExpression name="values"/>
                  </propertyReferenceExpression>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- constructor FieldInfo(DataField)-->
            <constructor>
              <attributes public="true"/>
              <parameters>
                <parameter type="DataField" name="field"/>
              </parameters>
              <chainedConstructorArgs>
                <argumentReferenceExpression name="field"/>
                <primitiveExpression value="Count"/>
              </chainedConstructorArgs>
            </constructor>
            <!-- constructor FieldInfo(DataField, string)-->
            <constructor>
              <attributes public="true"/>
              <parameters>
                <parameter type="DataField" name="field"/>
                <parameter type="System.String" name="mode"/>
              </parameters>
              <statements>
                <assignStatement>
                  <propertyReferenceExpression name="Field">
                    <thisReferenceExpression/>
                  </propertyReferenceExpression>
                  <argumentReferenceExpression name="field"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Mode">
                    <thisReferenceExpression/>
                  </propertyReferenceExpression>
                  <methodInvokeExpression methodName="ToLower">
                    <target>
                      <argumentReferenceExpression name="mode"/>
                    </target>
                  </methodInvokeExpression>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="ExpandBuckets"/>
                  <primitiveExpression value="false"/>
                </assignStatement>
              </statements>
            </constructor>
            <!-- method Add(object)-->
            <memberMethod name="Add">
              <attributes public="true"/>
              <parameters>
                <parameter type="System.Object" name="value"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="IsNullOrEmpty">
                      <propertyReferenceExpression name="Bucket"/>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement/>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <propertyReferenceExpression name="FieldType"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <propertyReferenceExpression name="FieldType"/>
                      <methodInvokeExpression methodName="GetType">
                        <target>
                          <argumentReferenceExpression name="value"/>
                        </target>
                      </methodInvokeExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <fieldReferenceExpression name="values"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <fieldReferenceExpression name="values"/>
                      <objectCreateExpression type="ValueInfo">
                        <parameters>
                          <thisReferenceExpression/>
                        </parameters>
                      </objectCreateExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="values"/>
                  </target>
                  <parameters>
                    <argumentReferenceExpression name="value"/>
                  </parameters>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- method EqualToMax(object)-->
            <memberMethod returnType="System.Boolean" name="EqualToMax">
              <attributes public="true"/>
              <parameters>
                <parameter type="System.Object" name="value"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanOr">
                      <binaryOperatorExpression operator="ValueEquality">
                        <argumentReferenceExpression name="value"/>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                      <binaryOperatorExpression operator="ValueEquality">
                        <propertyReferenceExpression name="Max"/>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="true"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="Type" name="type">
                  <init>
                    <methodInvokeExpression methodName="GetType">
                      <target>
                        <argumentReferenceExpression name="value"/>
                      </target>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <!-- long-->
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <variableReferenceExpression name="type"/>
                      <typeofExpression type="System.Int64"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <methodInvokeExpression methodName="Equals">
                        <target>
                          <castExpression targetType="System.Int64">
                            <argumentReferenceExpression name="value"/>
                          </castExpression>
                        </target>
                        <parameters>
                          <castExpression targetType="System.Int64">
                            <propertyReferenceExpression name="Max"/>
                          </castExpression>
                        </parameters>
                      </methodInvokeExpression>
                    </methodReturnStatement>
                  </trueStatements>
                  <falseStatements>
                    <conditionStatement>
                      <!-- ulong-->
                      <condition>
                        <binaryOperatorExpression operator="ValueEquality">
                          <variableReferenceExpression name="type"/>
                          <typeofExpression type="System.UInt64"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodReturnStatement>
                          <methodInvokeExpression methodName="Equals">
                            <target>
                              <castExpression targetType="System.UInt64">
                                <argumentReferenceExpression name="value"/>
                              </castExpression>
                            </target>
                            <parameters>
                              <castExpression targetType="System.UInt64">
                                <propertyReferenceExpression name="Max"/>
                              </castExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </methodReturnStatement>
                      </trueStatements>
                      <falseStatements>
                        <conditionStatement>
                          <!-- double-->
                          <condition>
                            <binaryOperatorExpression operator="ValueEquality">
                              <variableReferenceExpression name="type"/>
                              <typeofExpression type="System.Double"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <methodReturnStatement>
                              <methodInvokeExpression methodName="Equals">
                                <target>
                                  <castExpression targetType="System.Double">
                                    <argumentReferenceExpression name="value"/>
                                  </castExpression>
                                </target>
                                <parameters>
                                  <castExpression targetType="System.Double">
                                    <propertyReferenceExpression name="Max"/>
                                  </castExpression>
                                </parameters>
                              </methodInvokeExpression>
                            </methodReturnStatement>
                          </trueStatements>
                          <falseStatements>
                            <conditionStatement>
                              <!-- decimal-->
                              <condition>
                                <binaryOperatorExpression operator="ValueEquality">
                                  <variableReferenceExpression name="type"/>
                                  <typeofExpression type="System.Decimal"/>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <methodReturnStatement>
                                  <methodInvokeExpression methodName="Equals">
                                    <target>
                                      <castExpression targetType="System.Decimal">
                                        <argumentReferenceExpression name="value"/>
                                      </castExpression>
                                    </target>
                                    <parameters>
                                      <castExpression targetType="System.Decimal">
                                        <propertyReferenceExpression name="Max"/>
                                      </castExpression>
                                    </parameters>
                                  </methodInvokeExpression>
                                </methodReturnStatement>
                              </trueStatements>
                              <falseStatements>
                                <conditionStatement>
                                  <!-- DateTime-->
                                  <condition>
                                    <binaryOperatorExpression operator="ValueEquality">
                                      <variableReferenceExpression name="type"/>
                                      <typeofExpression type="DateTime"/>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <methodReturnStatement>
                                      <methodInvokeExpression methodName="Equals">
                                        <target>
                                          <castExpression targetType="DateTime">
                                            <argumentReferenceExpression name="value"/>
                                          </castExpression>
                                        </target>
                                        <parameters>
                                          <castExpression targetType="DateTime">
                                            <propertyReferenceExpression name="Max"/>
                                          </castExpression>
                                        </parameters>
                                      </methodInvokeExpression>
                                    </methodReturnStatement>
                                  </trueStatements>
                                  <falseStatements>
                                    <conditionStatement>
                                      <!-- TimeSpan-->
                                      <condition>
                                        <binaryOperatorExpression operator="ValueEquality">
                                          <variableReferenceExpression name="type"/>
                                          <typeofExpression type="TimeSpan"/>
                                        </binaryOperatorExpression>
                                      </condition>
                                      <trueStatements>
                                        <methodReturnStatement>
                                          <methodInvokeExpression methodName="Equals">
                                            <target>
                                              <castExpression targetType="TimeSpan">
                                                <argumentReferenceExpression name="value"/>
                                              </castExpression>
                                            </target>
                                            <parameters>
                                              <castExpression targetType="TimeSpan">
                                                <propertyReferenceExpression name="Max"/>
                                              </castExpression>
                                            </parameters>
                                          </methodInvokeExpression>
                                        </methodReturnStatement>
                                      </trueStatements>
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
                <methodReturnStatement>
                  <primitiveExpression value="true"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method ToString()-->
            <memberMethod returnType="System.String" name="ToString">
              <attributes public="true" override="true"/>
              <statements>
                <methodReturnStatement>
                  <propertyReferenceExpression name="Label">
                    <propertyReferenceExpression name="Field"/>
                  </propertyReferenceExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
        <typeDeclaration name="DimensionInfo">
          <attributes public="true"/>
          <members>
            <!-- property Key-->
            <memberProperty type="System.String" name="Key">
              <attributes public="true"/>
            </memberProperty>
            <!-- property Labels-->
            <memberProperty type="System.Object[]" name="Labels">
              <attributes public="true"/>
            </memberProperty>
            <!-- property Values-->
            <memberProperty type="ValueInfo" name="Values">
              <attributes public="true"/>
            </memberProperty>
            <!-- property Depth-->
            <memberProperty type="System.Int32" name="Depth">
              <attributes public="true"/>
            </memberProperty>
            <!-- property Count-->
            <memberProperty type="System.Int32" name="Count">
              <attributes public="true"/>
              <getStatements>
                <methodReturnStatement>
                  <propertyReferenceExpression name="Length">
                    <propertyReferenceExpression name="Labels"/>
                  </propertyReferenceExpression>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- constructor DimensionInfo(string, object[], int)-->
            <constructor>
              <attributes public="true"/>
              <parameters>
                <parameter type="System.String" name="key"/>
                <parameter type="System.Object[]" name="labels"/>
                <parameter type="System.Int32" name="depth"/>
              </parameters>
              <statements>
                <assignStatement>
                  <propertyReferenceExpression name="Key">
                    <thisReferenceExpression/>
                  </propertyReferenceExpression>
                  <argumentReferenceExpression name="key"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Labels">
                    <thisReferenceExpression/>
                  </propertyReferenceExpression>
                  <argumentReferenceExpression name="labels"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Depth">
                    <thisReferenceExpression/>
                  </propertyReferenceExpression>
                  <argumentReferenceExpression name="depth"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Values">
                    <thisReferenceExpression/>
                  </propertyReferenceExpression>
                  <objectCreateExpression type="ValueInfo"/>
                </assignStatement>
              </statements>
            </constructor>
            <!-- method ToString()-->
            <memberMethod returnType="System.String" name="ToString">
              <attributes public="true" override="true"/>
              <statements>
                <methodReturnStatement>
                  <propertyReferenceExpression name="Key"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
      </types>
    </compileUnit>
  </xsl:template>
</xsl:stylesheet>
