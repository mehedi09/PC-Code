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
      </imports>
      <types>
        <!-- class PageRequest -->
        <typeDeclaration name="PageRequest">
          <customAttributes>
            <customAttribute name="Serializable"/>
          </customAttributes>
          <members>
            <!-- property Tag -->
            <memberProperty type="System.String" name="Tag">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property ViewType -->
            <memberProperty type="System.String" name="ViewType">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property SupportsCaching -->
            <memberProperty type="System.Boolean" name="SupportsCaching">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property RequiresFirstLetters -->
            <memberProperty type="System.Boolean" name="RequiresFirstLetters">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property PageIndex -->
            <memberField type="System.Int32" name="PageIndex"/>
            <memberProperty type="System.Int32" name="PageIndex">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="pageIndex"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="pageIndex"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property PageSize -->
            <memberField type="System.Int32" name="PageSize"/>
            <memberProperty type="System.Int32" name="PageSize">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="pageSize"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="pageSize"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
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
            <!-- property SortExpression -->
            <memberField type="System.String" name="SortExpression"/>
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
            <!-- property Filter -->
            <memberProperty type="System.String[]" name="Filter">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property SystemFilter -->
            <memberProperty type="System.String[]" name="SystemFilter">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property filterDetails -->
            <memberField type="System.String" name="filterDetails"/>
            <memberProperty type="System.String" name="FilterDetails">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="filterDetails"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="filterDetails"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property SelectedValues-->
            <memberProperty type="System.Object[]" name="SyncKey">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property ContextKey -->
            <memberField type="System.String" name="contextKey"/>
            <memberProperty type="System.String" name="ContextKey">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="contextKey"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="contextKey"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property FilterIsExternal -->
            <memberField type="System.Boolean" name="filterIsExternal"/>
            <memberProperty type="System.Boolean" name="FilterIsExternal">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="filterIsExternal"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="filterIsExternal"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property Cookie -->
            <memberProperty type="System.String" name="Cookie">
              <attributes final="true" public="true"/>
            </memberProperty>
            <!-- property RequiresMetaData -->
            <memberProperty type="System.Boolean" name="RequiresMetaData">
              <attributes final="true" public="true"/>
            </memberProperty>
            <!-- property RequiresPivot -->
            <memberProperty type="System.Boolean" name="RequiresPivot">
              <attributes final="true" public="true"/>
            </memberProperty>
            <!-- property RequiresRowCount -->
            <memberProperty type="System.Boolean" name="RequiresRowCount">
              <attributes final="true" public="true"/>
            </memberProperty>
            <!-- property DoesNotRequireData -->
            <memberProperty type="System.Boolean" name="DoesNotRequireData">
              <attributes final="true" public="true"/>
            </memberProperty>
            <!-- property Controller -->
            <memberProperty type="System.String" name="Controller">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property View -->
            <memberProperty type="System.String" name="View">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property LastView -->
            <memberProperty type="System.String" name="LastView">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property LookupContextController -->
            <memberProperty type="System.String" name="LookupContextController">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property LookupContextView -->
            <memberProperty type="System.String" name="LookupContextView">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property LookupContextFieldName -->
            <memberProperty type="System.String" name="LookupContextFieldName">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property Inserting -->
            <memberProperty type="System.Boolean" name="Inserting">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property LastCommandName -->
            <memberProperty type="System.String" name="LastCommandName">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property LastCommandArgument -->
            <memberProperty type="System.String" name="LastCommandArgument">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property ExternalFilter -->
            <memberProperty type="FieldValue[]" name="ExternalFilter">
              <attributes public="true" final="true"/>
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
            <!-- property IsModal -->
            <memberProperty type="System.Boolean" name="IsModal">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <binaryOperatorExpression operator="BooleanAnd">
                    <unaryOperatorExpression operator="Not">
                      <methodInvokeExpression methodName="IsNullOrEmpty">
                        <target>
                          <typeReferenceExpression type="String"/>
                        </target>
                        <parameters>
                          <fieldReferenceExpression name="contextKey"/>
                        </parameters>
                      </methodInvokeExpression>
                    </unaryOperatorExpression>
                    <methodInvokeExpression methodName="Contains">
                      <target>
                        <fieldReferenceExpression name="contextKey"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="_ModalDataView"/>
                      </parameters>
                    </methodInvokeExpression>
                  </binaryOperatorExpression>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
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
            <!-- property Current -->
            <memberProperty type="PageRequest" name="Current">
              <attributes public="true" static="true"/>
              <getStatements>
                <methodReturnStatement>
                  <castExpression targetType="PageRequest">
                    <arrayIndexerExpression>
                      <target>
                        <propertyReferenceExpression name="Items">
                          <propertyReferenceExpression name="Current">
                            <typeReferenceExpression type="HttpContext"/>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                      </target>
                      <indices>
                        <primitiveExpression value="PageRequest_Current"/>
                      </indices>
                    </arrayIndexerExpression>
                  </castExpression>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- constructor PageRequest() -->
            <constructor>
              <attributes public="true"/>
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
                      <binaryOperatorExpression operator="IdentityEquality">
                        <propertyReferenceExpression name="Current"/>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                    </binaryOperatorExpression>
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
                          <primitiveExpression value="PageRequest_Current"/>
                        </indices>
                      </arrayIndexerExpression>
                      <thisReferenceExpression/>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
              </statements>
            </constructor>
            <!-- constructor PageRequest(int, int, string, string[])-->
            <constructor>
              <attributes public="true"/>
              <parameters>
                <parameter type="System.Int32" name="pageIndex"/>
                <parameter type="System.Int32" name="pageSize"/>
                <parameter type="System.String" name="sortExpression"/>
                <parameter type="System.String[]" name="filter"/>
              </parameters>
              <statements>
                <!--<conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <argumentReferenceExpression name="pageSize"/>
                      <primitiveExpression value="0"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <argumentReferenceExpression name="pageSize"/>
                      <primitiveExpression value="-1"/>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>-->
                <assignStatement>
                  <fieldReferenceExpression name="pageIndex">
                    <thisReferenceExpression/>
                  </fieldReferenceExpression>
                  <argumentReferenceExpression name="pageIndex"/>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="pageSize">
                    <thisReferenceExpression/>
                  </fieldReferenceExpression>
                  <argumentReferenceExpression name="pageSize"/>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="sortExpression">
                    <thisReferenceExpression/>
                  </fieldReferenceExpression>
                  <argumentReferenceExpression name="sortExpression"/>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="filter">
                    <thisReferenceExpression/>
                  </fieldReferenceExpression>
                  <argumentReferenceExpression name="filter"/>
                </assignStatement>
              </statements>
            </constructor>
            <!-- AssignContext -->
            <memberMethod name="AssignContext">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="System.String" name="controller"/>
                <parameter type="System.String" name="view"/>
                <parameter type="ControllerConfiguration" name="config"/>
              </parameters>
              <statements>
                <assignStatement>
                  <fieldReferenceExpression name="controller"/>
                  <argumentReferenceExpression name="controller"/>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="view"/>
                  <argumentReferenceExpression name="view"/>
                </assignStatement>
                <variableDeclarationStatement type="System.String" name="referrer">
                  <init>
                    <propertyReferenceExpression name="Empty">
                      <typeReferenceExpression type="String"/>
                    </propertyReferenceExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <propertyReferenceExpression name="PageSize"/>
                      <primitiveExpression value="1000"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <comment>we are processing a request to retrieve static lookup data</comment>
                    <variableDeclarationStatement type="XPathNavigator" name="sortExpressionNode">
                      <init>
                        <methodInvokeExpression methodName="SelectSingleNode">
                          <target>
                            <argumentReferenceExpression name="config"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="c:dataController/c:views/c:view[@id='{{0}}']/@sortExpression"/>
                            <argumentReferenceExpression name="view"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanAnd">
                          <binaryOperatorExpression operator="IdentityInequality">
                            <variableReferenceExpression name="sortExpressionNode"/>
                            <primitiveExpression value="null"/>
                          </binaryOperatorExpression>
                          <unaryOperatorExpression operator="IsNotNullOrEmpty">
                            <propertyReferenceExpression name="Value">
                              <variableReferenceExpression name="sortExpressionNode"/>
                            </propertyReferenceExpression>
                          </unaryOperatorExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <propertyReferenceExpression name="SortExpression">
                            <thisReferenceExpression/>
                          </propertyReferenceExpression>
                          <propertyReferenceExpression name="Value">
                            <variableReferenceExpression name="sortExpressionNode"/>
                          </propertyReferenceExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                  </trueStatements>
                </conditionStatement>
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
                        <propertyReferenceExpression name="UrlReferrer">
                          <propertyReferenceExpression name="Request">
                            <propertyReferenceExpression name="Current">
                              <typeReferenceExpression type="HttpContext"/>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="referrer"/>
                      <propertyReferenceExpression name="AbsolutePath">
                        <propertyReferenceExpression name="UrlReferrer">
                          <propertyReferenceExpression name="Request">
                            <propertyReferenceExpression name="Current">
                              <typeReferenceExpression type="HttpContext"/>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                      </propertyReferenceExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <assignStatement>
                  <fieldReferenceExpression name="contextKey">
                    <thisReferenceExpression/>
                  </fieldReferenceExpression>
                  <methodInvokeExpression methodName="Format">
                    <target>
                      <typeReferenceExpression type="System.String"/>
                    </target>
                    <parameters>
                      <primitiveExpression value="{{0}}/{{1}}.{{2}}.{{3}}"/>
                      <variableReferenceExpression name="referrer"/>
                      <argumentReferenceExpression name="controller"/>
                      <argumentReferenceExpression name="view"/>
                      <propertyReferenceExpression name="ContextKey"/>
                    </parameters>
                  </methodInvokeExpression>
                </assignStatement>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
      </types>
    </compileUnit>
  </xsl:template>
</xsl:stylesheet>
