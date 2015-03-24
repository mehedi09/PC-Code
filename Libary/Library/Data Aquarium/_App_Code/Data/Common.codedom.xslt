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
        <namespaceImport name="System.Data.Common"/>
      </imports>
      <types>
        <!-- class SelectClauseDictionary -->
        <typeDeclaration name="SelectClauseDictionary">
          <baseTypes>
            <typeReference type="SortedDictionary">
              <typeArguments>
                <typeReference type="System.String"/>
                <typeReference type="System.String"/>
              </typeArguments>
            </typeReference>
          </baseTypes>
          <members>
            <!-- string this[string] -->
            <memberProperty type="System.String" name="Item">
              <attributes new="true" public="true" final="true"/>
              <parameters>
                <parameter type="System.String" name="name"/>
              </parameters>
              <getStatements>
                <variableDeclarationStatement type="System.String" name="expression">
                  <init>
                    <primitiveExpression value="null"/>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="TryGetValue">
                      <parameters>
                        <methodInvokeExpression methodName="ToLower">
                          <target>
                            <argumentReferenceExpression name="name"/>
                          </target>
                        </methodInvokeExpression>
                        <directionExpression direction="Out">
                          <variableReferenceExpression name="expression"/>
                        </directionExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <variableReferenceExpression name="expression"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <primitiveExpression value="null" convertTo="String"/>
                </methodReturnStatement>
                <!--<tryStatement>
                  <statements>
                    <methodReturnStatement>
                      <arrayIndexerExpression>
                        <target>
                          <baseReferenceExpression/>
                        </target>
                        <indices>
                          <methodInvokeExpression methodName="ToLower">
                            <target>
                              <argumentReferenceExpression name="name"/>
                            </target>
                          </methodInvokeExpression>
                        </indices>
                      </arrayIndexerExpression>
                    </methodReturnStatement>
                  </statements>
                  <catch exceptionType="Exception">
                    <throwExceptionStatement>
                      <objectCreateExpression type="Exception">
                        <parameters>
                          <stringFormatExpression format="Data field '{{0}}' is not present in the view.">
                            <argumentReferenceExpression name="name"/>
                          </stringFormatExpression>
                        </parameters>
                      </objectCreateExpression>
                    </throwExceptionStatement>
                  </catch>
                </tryStatement>-->
              </getStatements>
              <setStatements>
                <assignStatement>
                  <arrayIndexerExpression>
                    <target>
                      <baseReferenceExpression/>
                    </target>
                    <indices>
                      <methodInvokeExpression methodName="ToLower">
                        <target>
                          <argumentReferenceExpression name="name"/>
                        </target>
                      </methodInvokeExpression>
                    </indices>
                  </arrayIndexerExpression>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- bool ContainsKey(string) -->
            <memberMethod returnType="System.Boolean" name="ContainsKey">
              <attributes public="true" new="true" final="true"/>
              <parameters>
                <parameter type="System.String" name="name"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="ContainsKey">
                    <target>
                      <baseReferenceExpression/>
                    </target>
                    <parameters>
                      <methodInvokeExpression methodName="ToLower">
                        <target>
                          <argumentReferenceExpression name="name"/>
                        </target>
                      </methodInvokeExpression>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- void Add(string, string) -->
            <memberMethod name="Add">
              <attributes new="true" final="true" public="true"/>
              <parameters>
                <parameter name="key" type="System.String"/>
                <parameter type="System.String" name="value"/>
              </parameters>
              <statements>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <baseReferenceExpression/>
                  </target>
                  <parameters>
                    <methodInvokeExpression methodName="ToLower">
                      <target>
                        <argumentReferenceExpression name="key"/>
                      </target>
                    </methodInvokeExpression>
                    <argumentReferenceExpression name="value"/>
                  </parameters>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- bool TryGetValue(string key, out string) -->
            <memberMethod returnType="System.Boolean" name="TryGetValue">
              <attributes new="true" final="true" public="true"/>
              <parameters>
                <parameter type="System.String" name="key"/>
                <parameter type="System.String" name="value" direction="Out"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="TryGetValue">
                    <target>
                      <baseReferenceExpression/>
                    </target>
                    <parameters>
                      <methodInvokeExpression methodName="ToLower">
                        <target>
                          <argumentReferenceExpression name="key"/>
                        </target>
                      </methodInvokeExpression>
                      <directionExpression direction="Out">
                        <argumentReferenceExpression name="value"/>
                      </directionExpression>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>

        <!-- interface IDataController -->
        <typeDeclaration name="IDataController" isInterface="true">
          <members>
            <memberMethod returnType="ViewPage" name="GetPage">
              <attributes/>
              <parameters>
                <parameter type="System.String" name="controller"/>
                <parameter type="System.String" name="view"/>
                <parameter type="PageRequest" name="request"/>
              </parameters>
            </memberMethod>
            <memberMethod returnType="System.Object[]" name="GetListOfValues">
              <attributes/>
              <parameters>
                <parameter type="System.String" name="controller"/>
                <parameter type="System.String" name="view"/>
                <parameter type="DistinctValueRequest" name="request"/>
              </parameters>
            </memberMethod>
            <memberMethod returnType="ActionResult" name="Execute">
              <attributes/>
              <parameters>
                <parameter type="System.String" name="controller"/>
                <parameter type="System.String" name="view"/>
                <parameter type="ActionArgs" name="args"/>
              </parameters>
            </memberMethod>
          </members>
        </typeDeclaration>

        <!-- interface IAutoCompleteManager -->
        <typeDeclaration name="IAutoCompleteManager" isInterface="true">
          <members>
            <memberMethod returnType="System.String[]" name="GetCompletionList">
              <attributes/>
              <parameters>
                <parameter type="System.String" name="prefixText"/>
                <parameter type="System.Int32" name="count"/>
                <parameter type="System.String" name="contextKey"/>
              </parameters>
            </memberMethod>
          </members>
        </typeDeclaration>

        <!-- interface IActionHandler -->
        <typeDeclaration name="IActionHandler" isInterface="true">
          <members>
            <memberMethod name="BeforeSqlAction">
              <attributes/>
              <parameters>
                <parameter type="ActionArgs" name="args"/>
                <parameter type="ActionResult" name="result"/>
              </parameters>
            </memberMethod>
            <memberMethod name="AfterSqlAction">
              <attributes/>
              <parameters>
                <parameter type="ActionArgs" name="args"/>
                <parameter type="ActionResult" name="result"/>
              </parameters>
            </memberMethod>
            <memberMethod name="ExecuteAction">
              <attributes/>
              <parameters>
                <parameter type="ActionArgs" name="args"/>
                <parameter type="ActionResult" name="result"/>
              </parameters>
            </memberMethod>
          </members>
        </typeDeclaration>

        <!-- inteface IRowHandler -->
        <typeDeclaration name="IRowHandler" isInterface="true">
          <members>
            <memberMethod returnType="System.Boolean" name="SupportsNewRow">
              <attributes/>
              <parameters>
                <parameter type="PageRequest" name="requet"/>
              </parameters>
            </memberMethod>
            <memberMethod name="NewRow">
              <attributes/>
              <parameters>
                <parameter type="PageRequest" name="request"/>
                <parameter type="ViewPage" name="page"/>
                <parameter type="System.Object[]" name="row"/>
              </parameters>
            </memberMethod>
            <memberMethod returnType="System.Boolean" name="SupportsPrepareRow">
              <attributes/>
              <parameters>
                <parameter type="PageRequest" name="request"/>
              </parameters>
            </memberMethod>
            <memberMethod name="PrepareRow">
              <attributes/>
              <parameters>
                <parameter type="PageRequest" name="request"/>
                <parameter type="ViewPage" name="page"/>
                <parameter type="System.Object[]" name="row"/>
              </parameters>
            </memberMethod>
          </members>
        </typeDeclaration>

        <!-- interface IDataFilter -->
        <typeDeclaration name="IDataFilter" isInterface="true">
          <members>
            <memberMethod name="Filter">
              <attributes/>
              <parameters>
                <parameter type="SortedDictionary" name="filter">
                  <typeArguments>
                    <typeReference type="System.String"/>
                    <typeReference type="System.Object"/>
                  </typeArguments>
                </parameter>
              </parameters>
            </memberMethod>
          </members>
        </typeDeclaration>

        <!-- interface IDataFilter2 -->
        <typeDeclaration name="IDataFilter2" isInterface="true">
          <members>
            <memberMethod name="Filter">
              <attributes/>
              <parameters>
                <parameter type="System.String" name="controller"/>
                <parameter type="System.String" name="view"/>
                <parameter type="SortedDictionary" name="filter">
                  <typeArguments>
                    <typeReference type="System.String"/>
                    <typeReference type="System.Object"/>
                  </typeArguments>
                </parameter>
              </parameters>
            </memberMethod>
            <memberMethod name="AssignContext">
              <attributes/>
              <parameters>
                <parameter type="System.String" name="controller"/>
                <parameter type="System.String" name="view"/>
                <parameter type="System.String" name="lookupContextController"/>
                <parameter type="System.String" name="lookupContextView"/>
                <parameter type="System.String" name="lookupContextFieldName"/>
              </parameters>
            </memberMethod>
          </members>
        </typeDeclaration>

        <!-- interface IDataEngine -->
        <typeDeclaration name="IDataEngine" isInterface="true">
          <members>
            <memberMethod returnType="DbDataReader" name="ExecuteReader">
              <attributes/>
              <parameters>
                <parameter type="PageRequest" name="request"/>
              </parameters>
            </memberMethod>
          </members>
        </typeDeclaration>

        <!-- inteface IPlugIn -->
        <typeDeclaration name="IPlugIn" isInterface="true">
          <members>
            <memberProperty type="ControllerConfiguration" name="Config">
              <attributes/>
              <getStatements>
                <methodReturnStatement>
                  <primitiveExpression value="null"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <methodReturnStatement/>
              </setStatements>
            </memberProperty>
            <memberMethod returnType="ControllerConfiguration" name="Create">
              <attributes/>
              <parameters>
                <parameter type="ControllerConfiguration" name="config"/>
              </parameters>
            </memberMethod>
            <memberMethod name="PreProcessPageRequest">
              <attributes/>
              <parameters>
                <parameter type="PageRequest" name="request"/>
                <parameter type="ViewPage" name="page"/>
              </parameters>
            </memberMethod>
            <memberMethod name="ProcessPageRequest">
              <attributes/>
              <parameters>
                <parameter type="PageRequest" name="request"/>
                <parameter type="ViewPage" name="page"/>
              </parameters>
            </memberMethod>
            <memberMethod name="PreProcessArguments">
              <attributes/>
              <parameters>
                <parameter type="ActionArgs" name="args"/>
                <parameter type="ActionResult" name="result"/>
                <parameter type="ViewPage" name="page"/>
              </parameters>
            </memberMethod>
            <memberMethod name="ProcessArguments">
              <attributes/>
              <parameters>
                <parameter type="ActionArgs" name="args"/>
                <parameter type="ActionResult" name="result"/>
                <parameter type="ViewPage" name="page"/>
              </parameters>
            </memberMethod>
          </members>
        </typeDeclaration>

        <!-- class BusinessObjectParameters -->
        <typeDeclaration name="BusinessObjectParameters">
          <baseTypes>
            <typeReference type="SortedDictionary">
              <typeArguments>
                <typeReference type="System.String"/>
                <typeReference type="System.Object"/>
              </typeArguments>
            </typeReference>
          </baseTypes>
          <members>
            <constructor>
              <attributes public="true"/>
              <parameters>
                <parameter type="params FieldValue[]" name="values"/>
              </parameters>
              <statements>
                <foreachStatement>
                  <variable type="FieldValue" name="v"/>
                  <target>
                    <argumentReferenceExpression name="values"/>
                  </target>
                  <statements>
                    <methodInvokeExpression methodName="Add">
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
              </statements>
            </constructor>
          </members>
        </typeDeclaration>

        <!-- interface IBusinessObject -->
        <typeDeclaration name="IBusinessObject" isInterface="true">
          <members>
            <memberMethod name="AssignFilter">
              <attributes public="true"/>
              <parameters>
                <parameter type="System.String" name="filter"/>
                <parameter type="BusinessObjectParameters" name="parameters"/>
              </parameters>
            </memberMethod>
          </members>
        </typeDeclaration>

        <!-- enum CommandConfigurationType -->
        <typeDeclaration name="CommandConfigurationType" isEnum="true">
          <members>
            <memberField name="Select">
              <attributes public="true"/>
            </memberField>
            <memberField name="Update">
              <attributes public="true"/>
            </memberField>
            <memberField name="Insert">
              <attributes public="true"/>
            </memberField>
            <memberField name="Delete">
              <attributes public="true"/>
            </memberField>
            <memberField name="SelectCount">
              <attributes public="true"/>
            </memberField>
            <memberField name="SelectDistinct">
              <attributes public="true"/>
            </memberField>
            <memberField name="SelectAggregates">
              <attributes public="true"/>
            </memberField>
            <memberField name="SelectFirstLetters">
              <attributes public="true"/>
            </memberField>
            <memberField name="SelectExisting">
              <attributes public="true"/>
            </memberField>
            <memberField name="Sync">
              <attributes public="true"/>
            </memberField>
            <memberField name="None">
              <attributes public="true"/>
            </memberField>
          </members>
        </typeDeclaration>
      </types>
    </compileUnit>
  </xsl:template>
</xsl:stylesheet>
