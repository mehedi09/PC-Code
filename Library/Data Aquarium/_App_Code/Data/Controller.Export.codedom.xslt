<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.codeontime.com/2008/codedom-compiler"  xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl a"
>
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="IsPremium"/>
  <xsl:param name="UseMemoryStream"/>
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
            <memberField type="System.Int32" name="MaximumRssItems">
              <attributes public="true" const="true"/>
              <init>
                <primitiveExpression value="200"/>
              </init>
            </memberField>
            <!-- method ExecuteDataExport(ActionArgs, ActionResult) -->
            <memberMethod name="ExecuteDataExport">
              <attributes private="true"/>
              <parameters>
                <parameter type="ActionArgs" name="args"/>
                <parameter type="ActionResult" name="result"/>
              </parameters>
              <statements>
                <!-- 
            if (!String.IsNullOrEmpty(args.CommandArgument))
            {
                string[] arguments = args.CommandArgument.Split(',');
                if (arguments.Length > 0)
                {
                    bool sameController = args.Controller == arguments[0];
                    args.Controller = arguments[0];
                    if (arguments.Length == 1)
                        args.View = "grid1";
                    else
                        args.View = arguments[1];
                    if (!sameController)
                        args.SortExpression = null;
                    SelectView(args.Controller, args.View);
                }
            }                -->
                <conditionStatement>
                  <condition>
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
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="System.String[]" name="arguments">
                      <init>
                        <methodInvokeExpression methodName="Split">
                          <target>
                            <propertyReferenceExpression name="CommandArgument">
                              <argumentReferenceExpression name="args"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <primitiveExpression value="," convertTo="Char"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="GreaterThan">
                          <propertyReferenceExpression name="Length">
                            <variableReferenceExpression name="arguments"/>
                          </propertyReferenceExpression>
                          <primitiveExpression value="0"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="System.Boolean" name="sameController">
                          <init>
                            <binaryOperatorExpression operator="ValueEquality">
                              <propertyReferenceExpression name="Controller">
                                <argumentReferenceExpression name="args"/>
                              </propertyReferenceExpression>
                              <arrayIndexerExpression>
                                <target>
                                  <variableReferenceExpression name="arguments"/>
                                </target>
                                <indices>
                                  <primitiveExpression value="0"/>
                                </indices>
                              </arrayIndexerExpression>
                            </binaryOperatorExpression>
                          </init>
                        </variableDeclarationStatement>
                        <assignStatement>
                          <propertyReferenceExpression name="Controller">
                            <argumentReferenceExpression name="args"/>
                          </propertyReferenceExpression>
                          <arrayIndexerExpression>
                            <target>
                              <variableReferenceExpression name="arguments"/>
                            </target>
                            <indices>
                              <primitiveExpression value="0"/>
                            </indices>
                          </arrayIndexerExpression>
                        </assignStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="ValueEquality">
                              <propertyReferenceExpression name="Length">
                                <variableReferenceExpression name="arguments"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="1"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="View">
                                <argumentReferenceExpression name="args"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="grid1"/>
                            </assignStatement>
                          </trueStatements>
                          <falseStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="View">
                                <argumentReferenceExpression name="args"/>
                              </propertyReferenceExpression>
                              <arrayIndexerExpression>
                                <target>
                                  <variableReferenceExpression name="arguments"/>
                                </target>
                                <indices>
                                  <primitiveExpression value="1"/>
                                </indices>
                              </arrayIndexerExpression>
                            </assignStatement>
                          </falseStatements>
                        </conditionStatement>
                        <conditionStatement>
                          <condition>
                            <variableReferenceExpression name="sameController"/>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="SortExpression">
                                <variableReferenceExpression name="args"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="null"/>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <methodInvokeExpression methodName="SelectView">
                          <parameters>
                            <propertyReferenceExpression name="Controller">
                              <argumentReferenceExpression name="args"/>
                            </propertyReferenceExpression>
                            <propertyReferenceExpression name="View">
                              <argumentReferenceExpression name="args"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="PageRequest" name="request">
                  <init>
                    <objectCreateExpression type="PageRequest">
                      <parameters>
                        <primitiveExpression value="-1"/>
                        <primitiveExpression value="-1"/>
                        <primitiveExpression value="null"/>
                        <primitiveExpression value="null"/>
                      </parameters>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <assignStatement>
                  <propertyReferenceExpression name="SortExpression">
                    <variableReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                  <propertyReferenceExpression name="SortExpression">
                    <argumentReferenceExpression name="args"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Filter">
                    <variableReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                  <propertyReferenceExpression name="Filter">
                    <argumentReferenceExpression name="args"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="ContextKey">
                    <variableReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="null"/>
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
                  <propertyReferenceExpression name="MaxValue">
                    <typeReferenceExpression type="Int32"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="EndsWith">
                      <target>
                        <propertyReferenceExpression name="CommandName">
                          <argumentReferenceExpression name="args"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <primitiveExpression value="Template"/>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <propertyReferenceExpression name="PageSize">
                        <argumentReferenceExpression name="request"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="0"/>
                    </assignStatement>
                    <assignStatement>
                      <propertyReferenceExpression name="CommandName">
                        <argumentReferenceExpression name="args"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="ExportCsv"/>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <comment>store export data to a temporary file</comment>
                <xsl:choose>
                  <xsl:when test="$UseMemoryStream='true'">
                    <variableDeclarationStatement type="MemoryStream" name="stream">
                      <init>
                        <objectCreateExpression type="MemoryStream"/>
                      </init>
                    </variableDeclarationStatement>
                  </xsl:when>
                  <xsl:otherwise>
                    <variableDeclarationStatement type="System.String" name="fileName">
                      <init>
                        <methodInvokeExpression methodName="GetTempFileName">
                          <target>
                            <typeReferenceExpression type="Path"/>
                          </target>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                  </xsl:otherwise>
                </xsl:choose>
                <variableDeclarationStatement type="StreamWriter" name="writer">
                  <init>
                    <xsl:choose>
                      <xsl:when test="$UseMemoryStream='true'">
                        <objectCreateExpression type="StreamWriter">
                          <parameters>
                            <variableReferenceExpression name="stream"/>
                          </parameters>
                        </objectCreateExpression>
                      </xsl:when>
                      <xsl:otherwise>
                        <methodInvokeExpression methodName="CreateText">
                          <target>
                            <typeReferenceExpression type="File"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="fileName"/>
                          </parameters>
                        </methodInvokeExpression>
                      </xsl:otherwise>
                    </xsl:choose>
                  </init>
                </variableDeclarationStatement>
                <tryStatement>
                  <statements>
                    <variableDeclarationStatement type="ViewPage" name="page">
                      <init>
                        <objectCreateExpression type="ViewPage">
                          <parameters>
                            <variableReferenceExpression name="request"/>
                          </parameters>
                        </objectCreateExpression>
                      </init>
                    </variableDeclarationStatement>
                    <methodInvokeExpression methodName="ApplyDataFilter">
                      <target>
                        <variableReferenceExpression name="page"/>
                      </target>
                      <parameters>
                        <methodInvokeExpression methodName="CreateDataFilter">
                          <target>
                            <fieldReferenceExpression name="config"/>
                          </target>
                        </methodInvokeExpression>
                        <propertyReferenceExpression name="Controller">
                          <argumentReferenceExpression name="args"/>
                        </propertyReferenceExpression>
                        <propertyReferenceExpression name="View">
                          <argumentReferenceExpression name="args"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="null"/>
                        <primitiveExpression value="null"/>
                        <primitiveExpression value="null"/>
                      </parameters>
                    </methodInvokeExpression>

                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityEquality">
                          <fieldReferenceExpression name="serverRules"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <fieldReferenceExpression name="serverRules"/>
                          <methodInvokeExpression methodName="CreateBusinessRules">
                            <target>
                              <fieldReferenceExpression name="config"/>
                            </target>
                          </methodInvokeExpression>
                        </assignStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="IdentityEquality">
                              <fieldReferenceExpression name="serverRules"/>
                              <primitiveExpression value="null"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <fieldReferenceExpression name="serverRules"/>
                              <methodInvokeExpression methodName="CreateBusinessRules"/>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
                    <assignStatement>
                      <propertyReferenceExpression name="Page">
                        <fieldReferenceExpression name="serverRules"/>
                      </propertyReferenceExpression>
                      <variableReferenceExpression name="page"/>
                    </assignStatement>
                    <methodInvokeExpression methodName="ExecuteServerRules">
                      <target>
                        <fieldReferenceExpression name="serverRules"/>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="request"/>
                        <propertyReferenceExpression name="Before">
                          <typeReferenceExpression type="ActionPhase"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <usingStatement>
                      <variable type="DbConnection" name="connection">
                        <init>
                          <methodInvokeExpression methodName="CreateConnection"/>
                        </init>
                      </variable>
                      <statements>
                        <variableDeclarationStatement type="DbCommand" name="selectCommand">
                          <init>
                            <methodInvokeExpression methodName="CreateCommand">
                              <parameters>
                                <variableReferenceExpression name="connection"/>
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="BooleanAnd">
                              <binaryOperatorExpression operator="IdentityEquality">
                                <variableReferenceExpression name="selectCommand"/>
                                <primitiveExpression value="null"/>
                              </binaryOperatorExpression>
                              <propertyReferenceExpression name="EnableResultSet">
                                <fieldReferenceExpression name="serverRules"/>
                              </propertyReferenceExpression>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="PopulatePageFields">
                              <parameters>
                                <variableReferenceExpression name="page"/>
                              </parameters>
                            </methodInvokeExpression>
                            <methodInvokeExpression methodName="EnsurePageFields">
                              <parameters>
                                <variableReferenceExpression name="page"/>
                                <primitiveExpression value="null"/>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>
                        <methodInvokeExpression methodName="ConfigureCommand">
                          <parameters>
                            <variableReferenceExpression name="selectCommand"/>
                            <variableReferenceExpression name="page"/>
                            <propertyReferenceExpression name="Select">
                              <typeReferenceExpression type="CommandConfigurationType"/>
                            </propertyReferenceExpression>
                            <primitiveExpression value="null"/>
                          </parameters>
                        </methodInvokeExpression>
                        <variableDeclarationStatement type="DbDataReader" name="reader">
                          <init>
                            <methodInvokeExpression methodName="ExecuteResultSetReader">
                              <parameters>
                                <variableReferenceExpression name="page"/>
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="IdentityEquality">
                              <variableReferenceExpression name="reader"/>
                              <primitiveExpression value="null"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="reader"/>
                              <methodInvokeExpression methodName="ExecuteReader">
                                <target>
                                  <variableReferenceExpression name="selectCommand"/>
                                </target>
                              </methodInvokeExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <conditionStatement>
                          <condition>
                            <methodInvokeExpression methodName="EndsWith">
                              <target>
                                <propertyReferenceExpression name="CommandName">
                                  <argumentReferenceExpression name="args"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="Csv"/>
                              </parameters>
                            </methodInvokeExpression>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="ExportDataAsCsv">
                              <parameters>
                                <variableReferenceExpression name="page"/>
                                <variableReferenceExpression name="reader"/>
                                <variableReferenceExpression name="writer"/>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>
                        <conditionStatement>
                          <condition>
                            <methodInvokeExpression methodName="EndsWith">
                              <target>
                                <propertyReferenceExpression name="CommandName">
                                  <argumentReferenceExpression name="args"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="Rss"/>
                              </parameters>
                            </methodInvokeExpression>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="ExportDataAsRss">
                              <parameters>
                                <variableReferenceExpression name="page"/>
                                <variableReferenceExpression name="reader"/>
                                <variableReferenceExpression name="writer"/>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>
                        <conditionStatement>
                          <condition>
                            <methodInvokeExpression methodName="EndsWith">
                              <target>
                                <propertyReferenceExpression name="CommandName">
                                  <argumentReferenceExpression name="args"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="Rowset"/>
                              </parameters>
                            </methodInvokeExpression>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="ExportDataAsRowset">
                              <parameters>
                                <variableReferenceExpression name="page"/>
                                <variableReferenceExpression name="reader"/>
                                <variableReferenceExpression name="writer"/>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>
                        <methodInvokeExpression methodName="Close">
                          <target>
                            <variableReferenceExpression name="reader"/>
                          </target>
                        </methodInvokeExpression>
                      </statements>
                    </usingStatement>
                    <methodInvokeExpression methodName="ExecuteServerRules">
                      <target>
                        <fieldReferenceExpression name="serverRules"/>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="request"/>
                        <propertyReferenceExpression name="After">
                          <typeReferenceExpression type="ActionPhase"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </statements>
                  <finally>
                    <xsl:choose>
                      <xsl:when test="$UseMemoryStream='true'">
                        <methodInvokeExpression methodName="Flush">
                          <target>
                            <variableReferenceExpression name="writer"/>
                          </target>
                        </methodInvokeExpression>
                      </xsl:when>
                      <xsl:otherwise>
                        <methodInvokeExpression methodName="Close">
                          <target>
                            <variableReferenceExpression name="writer"/>
                          </target>
                        </methodInvokeExpression>
                      </xsl:otherwise>
                    </xsl:choose>
                  </finally>
                </tryStatement>
                <xsl:if test="$UseMemoryStream='true'">
                  <assignStatement>
                    <propertyReferenceExpression name="Position">
                      <variableReferenceExpression name="stream"/>
                    </propertyReferenceExpression>
                    <primitiveExpression value="0"/>
                  </assignStatement>
                </xsl:if>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <propertyReferenceExpression name="Values">
                      <argumentReferenceExpression name="result"/>
                    </propertyReferenceExpression>
                  </target>
                  <parameters>
                    <objectCreateExpression type="FieldValue">
                      <parameters>
                        <primitiveExpression value="FileName"/>
                        <primitiveExpression value="null"/>
                        <xsl:choose>
                          <xsl:when test="$UseMemoryStream='true'">
                            <variableReferenceExpression name="stream"/>
                          </xsl:when>
                          <xsl:otherwise>
                            <variableReferenceExpression name="fileName"/>
                          </xsl:otherwise>
                        </xsl:choose>
                      </parameters>
                    </objectCreateExpression>
                  </parameters>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- method ExportDataAsRowset(ViewPage page, DbDataReader reader, StreamWriter writer) -->
            <memberMethod name="ExportDataAsRowset">
              <attributes private="true"/>
              <parameters>
                <parameter type="ViewPage" name="page"/>
                <parameter type="DbDataReader" name="reader"/>
                <parameter type="StreamWriter" name="writer"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.String" name="s">
                  <init>
                    <primitiveExpression value="uuid:BDC6E3F0-6DA3-11d1-A2A3-00AA00C14882"/>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.String" name="dt">
                  <init>
                    <primitiveExpression value="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882"/>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.String" name="rs">
                  <init>
                    <primitiveExpression value="urn:schemas-microsoft-com:rowset"/>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.String" name="z">
                  <init>
                    <primitiveExpression value="#RowsetSchema"/>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="XmlWriterSettings" name="settings">
                  <init>
                    <objectCreateExpression type="XmlWriterSettings"/>
                  </init>
                </variableDeclarationStatement>
                <assignStatement>
                  <propertyReferenceExpression name="CloseOutput">
                    <variableReferenceExpression name="settings"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="false"/>
                </assignStatement>
                <variableDeclarationStatement type="XmlWriter" name="output">
                  <init>
                    <methodInvokeExpression methodName="Create">
                      <target>
                        <typeReferenceExpression type="XmlWriter"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="writer"/>
                        <variableReferenceExpression name="settings"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <methodInvokeExpression methodName="WriteStartDocument">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="WriteStartElement">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="xml"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="WriteAttributeString">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="xmlns"/>
                    <primitiveExpression value="s"/>
                    <primitiveExpression value="null"/>
                    <variableReferenceExpression name="s"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="WriteAttributeString">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="xmlns"/>
                    <primitiveExpression value="dt"/>
                    <primitiveExpression value="null"/>
                    <variableReferenceExpression name="dt"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="WriteAttributeString">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="xmlns"/>
                    <primitiveExpression value="rs"/>
                    <primitiveExpression value="null"/>
                    <variableReferenceExpression name="rs"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="WriteAttributeString">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="xmlns"/>
                    <primitiveExpression value="z"/>
                    <primitiveExpression value="null"/>
                    <variableReferenceExpression name="z"/>
                  </parameters>
                </methodInvokeExpression>
                <comment>declare rowset schema</comment>
                <methodInvokeExpression methodName="WriteStartElement">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Schema"/>
                    <variableReferenceExpression name="s"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="WriteAttributeString">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="id"/>
                    <primitiveExpression value="RowsetSchema"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="WriteStartElement">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="ElementType"/>
                    <variableReferenceExpression name="s"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="WriteAttributeString">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="name"/>
                    <primitiveExpression value="row"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="WriteAttributeString">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="content"/>
                    <primitiveExpression value="eltOnly"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="WriteAttributeString">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="CommandTimeout"/>
                    <variableReferenceExpression name="rs"/>
                    <primitiveExpression value="60" convertTo="String"/>
                  </parameters>
                </methodInvokeExpression>
                <!-- 
            List<DataField> fields = new List<DataField>();
            foreach (DataField field in page.Fields)
                if (!((field.Hidden || field.OnDemand)) && !fields.Contains(field))
                {
                    DataField aliasField = field;
                    if (!(String.IsNullOrEmpty(field.AliasName)))
                        aliasField = page.FindField(field.AliasName);
                    fields.Add(aliasField);
                }                -->
                <variableDeclarationStatement type="List" name="fields">
                  <typeArguments>
                    <typeReference type="DataField"/>
                  </typeArguments>
                  <init>
                    <objectCreateExpression type="List">
                      <typeArguments>
                        <typeReference type="DataField"/>
                      </typeArguments>
                    </objectCreateExpression>
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
                        <binaryOperatorExpression operator="BooleanAnd">
                          <unaryOperatorExpression operator="Not">
                            <binaryOperatorExpression operator="BooleanOr">
                              <propertyReferenceExpression name="Hidden">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                              <propertyReferenceExpression name="OnDemand">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                            </binaryOperatorExpression>
                          </unaryOperatorExpression>
                          <unaryOperatorExpression operator="Not">
                            <methodInvokeExpression methodName="Contains">
                              <target>
                                <variableReferenceExpression name="fields"/>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="field"/>
                              </parameters>
                            </methodInvokeExpression>
                          </unaryOperatorExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="DataField" name="aliasField">
                          <init>
                            <variableReferenceExpression name="field"/>
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
                            <assignStatement>
                              <variableReferenceExpression name="aliasField"/>
                              <methodInvokeExpression methodName="FindField">
                                <target>
                                  <argumentReferenceExpression name="page"/>
                                </target>
                                <parameters>
                                  <propertyReferenceExpression name="AliasName">
                                    <variableReferenceExpression name="field"/>
                                  </propertyReferenceExpression>
                                </parameters>
                              </methodInvokeExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <variableReferenceExpression name="fields"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="aliasField"/>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
                <variableDeclarationStatement type="System.Int32" name="number">
                  <init>
                    <primitiveExpression value="1"/>
                  </init>
                </variableDeclarationStatement>
                <foreachStatement>
                  <variable type="DataField" name="field"/>
                  <target>
                    <variableReferenceExpression name="fields"/>
                  </target>
                  <statements>
                    <methodInvokeExpression methodName="NormalizeDataFormatString">
                      <target>
                        <variableReferenceExpression name="field"/>
                      </target>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="WriteStartElement">
                      <target>
                        <variableReferenceExpression name="output"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="AttributeType"/>
                        <variableReferenceExpression name="s"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="WriteAttributeString">
                      <target>
                        <variableReferenceExpression name="output"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="name"/>
                        <propertyReferenceExpression name="Name">
                          <variableReferenceExpression name="field"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="WriteAttributeString">
                      <target>
                        <variableReferenceExpression name="output"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="number"/>
                        <variableReferenceExpression name="rs"/>
                        <methodInvokeExpression methodName="ToString">
                          <target>
                            <variableReferenceExpression name="number"/>
                          </target>
                        </methodInvokeExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="WriteAttributeString">
                      <target>
                        <variableReferenceExpression name="output"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="nullable"/>
                        <variableReferenceExpression name="rs"/>
                        <primitiveExpression value="true" convertTo="String"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="WriteAttributeString">
                      <target>
                        <variableReferenceExpression name="output"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="name"/>
                        <variableReferenceExpression name="rs"/>
                        <propertyReferenceExpression name="Label">
                          <variableReferenceExpression name="field"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="WriteStartElement">
                      <target>
                        <variableReferenceExpression name="output"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="datatype"/>
                        <variableReferenceExpression name="s"/>
                      </parameters>
                    </methodInvokeExpression>
                    <variableDeclarationStatement type="System.String" name="type">
                      <init>
                        <arrayIndexerExpression>
                          <target>
                            <propertyReferenceExpression name="RowsetTypeMap"/>
                          </target>
                          <indices>
                            <propertyReferenceExpression name="Type">
                              <variableReferenceExpression name="field"/>
                            </propertyReferenceExpression>
                          </indices>
                        </arrayIndexerExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="System.String" name="dbType">
                      <init>
                        <primitiveExpression value="null"/>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <methodInvokeExpression methodName="Equals">
                          <target>
                            <primitiveExpression value="{{0:c}}"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="DataFormatString">
                              <variableReferenceExpression name="field"/>
                            </propertyReferenceExpression>
                            <propertyReferenceExpression name="CurrentCultureIgnoreCase">
                              <typeReferenceExpression type="StringComparison"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="dbType"/>
                          <primitiveExpression value="currency"/>
                        </assignStatement>
                      </trueStatements>
                      <falseStatements>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="BooleanAnd">
                              <unaryOperatorExpression operator="IsNotNullOrEmpty">
                                <propertyReferenceExpression name="DataFormatString">
                                  <variableReferenceExpression name="field"/>
                                </propertyReferenceExpression>
                              </unaryOperatorExpression>
                              <binaryOperatorExpression operator="ValueInequality">
                                <propertyReferenceExpression name="Type">
                                  <variableReferenceExpression name="field"/>
                                </propertyReferenceExpression>
                                <primitiveExpression value="DateTime"/>
                              </binaryOperatorExpression>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="type"/>
                              <primitiveExpression value="string"/>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                      </falseStatements>
                    </conditionStatement>
                    <methodInvokeExpression methodName="WriteAttributeString">
                      <target>
                        <variableReferenceExpression name="output"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="type"/>
                        <variableReferenceExpression name="dt"/>
                        <variableReferenceExpression name="type"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="WriteAttributeString">
                      <target>
                        <variableReferenceExpression name="output"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="dbtype"/>
                        <variableReferenceExpression name="rs"/>
                        <variableReferenceExpression name="dbType"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="WriteEndElement">
                      <target>
                        <variableReferenceExpression name="output"/>
                      </target>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="WriteEndElement">
                      <target>
                        <variableReferenceExpression name="output"/>
                      </target>
                    </methodInvokeExpression>
                    <assignStatement>
                      <variableReferenceExpression name="number"/>
                      <binaryOperatorExpression operator="Add">
                        <variableReferenceExpression name="number"/>
                        <primitiveExpression value="1"/>
                      </binaryOperatorExpression>
                    </assignStatement>

                  </statements>
                </foreachStatement>
                <methodInvokeExpression methodName="WriteStartElement">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="extends"/>
                    <variableReferenceExpression name="s"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="WriteAttributeString">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="type"/>
                    <primitiveExpression value="rs:rowbase"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="WriteEndElement">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="WriteEndElement">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="WriteEndElement">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                </methodInvokeExpression>
                <comment>output rowset data</comment>
                <methodInvokeExpression methodName="WriteStartElement">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="data"/>
                    <variableReferenceExpression name="rs"/>
                  </parameters>
                </methodInvokeExpression>
                <whileStatement>
                  <test>
                    <methodInvokeExpression methodName="Read">
                      <target>
                        <variableReferenceExpression name="reader"/>
                      </target>
                    </methodInvokeExpression>
                  </test>
                  <statements>
                    <methodInvokeExpression methodName="WriteStartElement">
                      <target>
                        <argumentReferenceExpression name="output"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="row"/>
                        <variableReferenceExpression name="z"/>
                      </parameters>
                    </methodInvokeExpression>
                    <foreachStatement>
                      <variable type="DataField" name="field"/>
                      <target>
                        <variableReferenceExpression name="fields"/>
                      </target>
                      <statements>
                        <variableDeclarationStatement type="System.Object" name="v">
                          <init>
                            <arrayIndexerExpression>
                              <target>
                                <argumentReferenceExpression name="reader"/>
                              </target>
                              <indices>
                                <propertyReferenceExpression name="Name">
                                  <variableReferenceExpression name="field"/>
                                </propertyReferenceExpression>
                              </indices>
                            </arrayIndexerExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <unaryOperatorExpression operator="Not">
                              <methodInvokeExpression methodName="Equals">
                                <target>
                                  <propertyReferenceExpression name="Value">
                                    <typeReferenceExpression type="DBNull"/>
                                  </propertyReferenceExpression>
                                </target>
                                <parameters>
                                  <variableReferenceExpression name="v"/>
                                </parameters>
                              </methodInvokeExpression>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="BooleanAnd">
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
                                  <unaryOperatorExpression operator="Not">
                                    <binaryOperatorExpression operator="BooleanOr">
                                      <binaryOperatorExpression operator="ValueEquality">
                                        <propertyReferenceExpression name="DataFormatString">
                                          <variableReferenceExpression name="field"/>
                                        </propertyReferenceExpression>
                                        <primitiveExpression value="{{0:d}}"/>
                                      </binaryOperatorExpression>
                                      <binaryOperatorExpression operator="ValueEquality">
                                        <propertyReferenceExpression name="DataFormatString">
                                          <variableReferenceExpression name="field"/>
                                        </propertyReferenceExpression>
                                        <primitiveExpression value="{{0:c}}"/>
                                      </binaryOperatorExpression>
                                    </binaryOperatorExpression>
                                  </unaryOperatorExpression>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <methodInvokeExpression methodName="WriteAttributeString">
                                  <target>
                                    <variableReferenceExpression name="output"/>
                                  </target>
                                  <parameters>
                                    <propertyReferenceExpression name="Name">
                                      <variableReferenceExpression name="field"/>
                                    </propertyReferenceExpression>
                                    <methodInvokeExpression methodName="Format">
                                      <target>
                                        <typeReferenceExpression type="String"/>
                                      </target>
                                      <parameters>
                                        <propertyReferenceExpression name="DataFormatString">
                                          <variableReferenceExpression name="field"/>
                                        </propertyReferenceExpression>
                                        <variableReferenceExpression name="v"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </trueStatements>
                              <falseStatements>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="ValueEquality">
                                      <propertyReferenceExpression name="Type">
                                        <variableReferenceExpression name="field"/>
                                      </propertyReferenceExpression>
                                      <primitiveExpression value="DateTime"/>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <methodInvokeExpression methodName="WriteAttributeString">
                                      <target>
                                        <variableReferenceExpression name="output"/>
                                      </target>
                                      <parameters>
                                        <propertyReferenceExpression name="Name">
                                          <variableReferenceExpression name="field"/>
                                        </propertyReferenceExpression>
                                        <methodInvokeExpression methodName="ToString">
                                          <target>
                                            <castExpression targetType="DateTime">
                                              <variableReferenceExpression name="v"/>
                                            </castExpression>
                                          </target>
                                          <parameters>
                                            <primitiveExpression value="s"/>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </trueStatements>
                                  <falseStatements>
                                    <methodInvokeExpression methodName="WriteAttributeString">
                                      <target>
                                        <variableReferenceExpression name="output"/>
                                      </target>
                                      <parameters>
                                        <propertyReferenceExpression name="Name">
                                          <variableReferenceExpression name="field"/>
                                        </propertyReferenceExpression>
                                        <methodInvokeExpression methodName="ToString">
                                          <target>
                                            <variableReferenceExpression name="v"/>
                                          </target>
                                        </methodInvokeExpression>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </falseStatements>
                                </conditionStatement>
                              </falseStatements>
                            </conditionStatement>
                          </trueStatements>
                        </conditionStatement>

                      </statements>
                    </foreachStatement>
                    <methodInvokeExpression methodName="WriteEndElement">
                      <target>
                        <variableReferenceExpression name="output"/>
                      </target>
                    </methodInvokeExpression>
                  </statements>
                </whileStatement>
                <methodInvokeExpression methodName="WriteEndElement">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="WriteEndElement">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="WriteEndDocument">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Close">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- method ExportDataAsRss(ViewPage page, DbDataReader reader, StreamWriter writer) -->
            <memberMethod name="ExportDataAsRss">
              <attributes private="true"/>
              <parameters>
                <parameter type="ViewPage" name="page"/>
                <parameter type="DbDataReader" name="reader"/>
                <parameter type="StreamWriter" name="writer"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.String" name="appPath">
                  <init>
                    <methodInvokeExpression methodName="Replace">
                      <target>
                        <typeReferenceExpression type="Regex"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="AbsoluteUri">
                          <propertyReferenceExpression name="Url">
                            <propertyReferenceExpression name="Request">
                              <propertyReferenceExpression name="Current">
                                <typeReferenceExpression type="HttpContext"/>
                              </propertyReferenceExpression>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                        <primitiveExpression value="^(.+)Export.ashx.+$"/>
                        <primitiveExpression value="$1"/>
                        <propertyReferenceExpression name="IgnoreCase">
                          <typeReferenceExpression type="RegexOptions"/>
                        </propertyReferenceExpression>
                        <!--<binaryOperatorExpression operator="BitwiseOr">
                          <propertyReferenceExpression name="Compiled">
                            <typeReferenceExpression type="RegexOptions"/>
                          </propertyReferenceExpression>
                          <propertyReferenceExpression name="IgnoreCase">
                            <typeReferenceExpression type="RegexOptions"/>
                          </propertyReferenceExpression>
                        </binaryOperatorExpression>-->
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="XmlWriterSettings" name="settings">
                  <init>
                    <objectCreateExpression type="XmlWriterSettings"/>
                  </init>
                </variableDeclarationStatement>
                <assignStatement>
                  <propertyReferenceExpression name="CloseOutput">
                    <variableReferenceExpression name="settings"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="false"/>
                </assignStatement>
                <variableDeclarationStatement type="XmlWriter" name="output">
                  <init>
                    <methodInvokeExpression methodName="Create">
                      <target>
                        <variableReferenceExpression name="XmlWriter"/>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="writer"/>
                        <variableReferenceExpression name="settings"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <methodInvokeExpression methodName="WriteStartDocument">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="WriteStartElement">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="rss"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="WriteAttributeString">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="version"/>
                    <primitiveExpression value="2.0" convertTo="String"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="WriteStartElement">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="channel"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="WriteElementString">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="title"/>
                    <castExpression targetType="System.String">
                      <methodInvokeExpression methodName="Evaluate">
                        <target>
                          <fieldReferenceExpression name="view"/>
                        </target>
                        <parameters>
                          <primitiveExpression value="string(concat(/c:dataController/@label, ' | ',  @label))"/>
                          <propertyReferenceExpression name="Resolver"/>
                        </parameters>
                      </methodInvokeExpression>
                    </castExpression>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="WriteElementString">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="lastBuildDate"/>
                    <methodInvokeExpression methodName="ToString">
                      <target>
                        <propertyReferenceExpression name="Now">
                          <typeReferenceExpression type="DateTime"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <primitiveExpression value="r"/>
                      </parameters>
                    </methodInvokeExpression>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="WriteElementString">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="language"/>
                    <methodInvokeExpression methodName="ToLower">
                      <target>
                        <propertyReferenceExpression name="Name">
                          <propertyReferenceExpression name="CurrentCulture">
                            <propertyReferenceExpression name="CurrentThread">
                              <typeReferenceExpression type="System.Threading.Thread"/>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                      </target>
                    </methodInvokeExpression>
                  </parameters>
                </methodInvokeExpression>
                <variableDeclarationStatement type="System.Int32" name="rowCount">
                  <init>
                    <primitiveExpression value="0"/>
                  </init>
                </variableDeclarationStatement>
                <whileStatement>
                  <test>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <binaryOperatorExpression operator="LessThan">
                        <variableReferenceExpression name="rowCount"/>
                        <propertyReferenceExpression name="MaximumRssItems"/>
                      </binaryOperatorExpression>
                      <methodInvokeExpression methodName="Read">
                        <target>
                          <argumentReferenceExpression name="reader"/>
                        </target>
                      </methodInvokeExpression>
                    </binaryOperatorExpression>
                  </test>
                  <statements>
                    <methodInvokeExpression methodName="WriteStartElement">
                      <target>
                        <variableReferenceExpression name="output"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="item"/>
                      </parameters>
                    </methodInvokeExpression>
                    <variableDeclarationStatement type="System.Boolean" name="hasTitle">
                      <init>
                        <primitiveExpression value="false"/>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="System.Boolean" name="hasPubDate">
                      <init>
                        <primitiveExpression value="false"/>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="StringBuilder" name="desc">
                      <init>
                        <objectCreateExpression type="StringBuilder"/>
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
                            <propertyReferenceExpression name="Fields">
                              <argumentReferenceExpression name="page"/>
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
                            <unaryOperatorExpression operator="Not">
                              <propertyReferenceExpression name="Hidden">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="ValueEquality">
                                  <variableReferenceExpression name="rowCount"/>
                                  <primitiveExpression value="0"/>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <methodInvokeExpression methodName="NormalizeDataFormatString">
                                  <target>
                                    <variableReferenceExpression name="field"/>
                                  </target>
                                </methodInvokeExpression>
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
                                      <propertyReferenceExpression name="AliasName">
                                        <variableReferenceExpression name="field"/>
                                      </propertyReferenceExpression>
                                    </parameters>
                                  </methodInvokeExpression>
                                </unaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="field"/>
                                  <methodInvokeExpression methodName="FindField">
                                    <target>
                                      <argumentReferenceExpression name="page"/>
                                    </target>
                                    <parameters>
                                      <propertyReferenceExpression name="AliasName">
                                        <variableReferenceExpression name="field"/>
                                      </propertyReferenceExpression>
                                    </parameters>
                                  </methodInvokeExpression>
                                </assignStatement>
                              </trueStatements>
                            </conditionStatement>
                            <variableDeclarationStatement type="System.String" name="text">
                              <init>
                                <propertyReferenceExpression name="Empty">
                                  <typeReferenceExpression type="String"/>
                                </propertyReferenceExpression>
                              </init>
                            </variableDeclarationStatement>
                            <variableDeclarationStatement type="System.Object" name="v">
                              <init>
                                <arrayIndexerExpression>
                                  <target>
                                    <argumentReferenceExpression name="reader"/>
                                  </target>
                                  <indices>
                                    <propertyReferenceExpression name="Name">
                                      <variableReferenceExpression name="field"/>
                                    </propertyReferenceExpression>
                                  </indices>
                                </arrayIndexerExpression>
                              </init>
                            </variableDeclarationStatement>
                            <conditionStatement>
                              <condition>
                                <unaryOperatorExpression operator="Not">
                                  <methodInvokeExpression methodName="Equals">
                                    <target>
                                      <propertyReferenceExpression name="Value">
                                        <typeReferenceExpression type="DBNull"/>
                                      </propertyReferenceExpression>
                                    </target>
                                    <parameters>
                                      <variableReferenceExpression name="v"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                </unaryOperatorExpression>
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
                                          <propertyReferenceExpression name="DataFormatString">
                                            <variableReferenceExpression name="field"/>
                                          </propertyReferenceExpression>
                                        </parameters>
                                      </methodInvokeExpression>
                                    </unaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <assignStatement>
                                      <variableReferenceExpression name="text"/>
                                      <methodInvokeExpression methodName="Format">
                                        <target>
                                          <typeReferenceExpression type="String"/>
                                        </target>
                                        <parameters>
                                          <propertyReferenceExpression name="DataFormatString">
                                            <variableReferenceExpression name="field"/>
                                          </propertyReferenceExpression>
                                          <variableReferenceExpression name="v"/>
                                        </parameters>
                                      </methodInvokeExpression>
                                    </assignStatement>
                                  </trueStatements>
                                  <falseStatements>
                                    <assignStatement>
                                      <variableReferenceExpression name="text"/>
                                      <methodInvokeExpression methodName="ToString">
                                        <target>
                                          <typeReferenceExpression type="Convert"/>
                                        </target>
                                        <parameters>
                                          <variableReferenceExpression name="v"/>
                                        </parameters>
                                      </methodInvokeExpression>
                                    </assignStatement>
                                  </falseStatements>
                                </conditionStatement>
                              </trueStatements>
                            </conditionStatement>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="BooleanAnd">
                                  <unaryOperatorExpression operator="Not">
                                    <variableReferenceExpression name="hasPubDate"/>
                                  </unaryOperatorExpression>
                                  <binaryOperatorExpression operator="ValueEquality">
                                    <propertyReferenceExpression name="Type">
                                      <variableReferenceExpression name="field"/>
                                    </propertyReferenceExpression>
                                    <primitiveExpression value="DateTime"/>
                                  </binaryOperatorExpression>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="hasPubDate"/>
                                  <primitiveExpression value="true"/>
                                </assignStatement>
                                <conditionStatement>
                                  <condition>
                                    <unaryOperatorExpression operator="Not">
                                      <methodInvokeExpression methodName="IsNullOrEmpty">
                                        <target>
                                          <typeReferenceExpression type="String"/>
                                        </target>
                                        <parameters>
                                          <variableReferenceExpression name="text"/>
                                        </parameters>
                                      </methodInvokeExpression>
                                    </unaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <methodInvokeExpression methodName="WriteElementString">
                                      <target>
                                        <variableReferenceExpression name="output"/>
                                      </target>
                                      <parameters>
                                        <primitiveExpression value="pubDate"/>
                                        <methodInvokeExpression methodName="ToString">
                                          <target>
                                            <castExpression targetType="DateTime">
                                              <arrayIndexerExpression>
                                                <target>
                                                  <argumentReferenceExpression name="reader"/>
                                                </target>
                                                <indices>
                                                  <propertyReferenceExpression name="Name">
                                                    <variableReferenceExpression name="field"/>
                                                  </propertyReferenceExpression>
                                                </indices>
                                              </arrayIndexerExpression>
                                            </castExpression>
                                          </target>
                                          <parameters>
                                            <primitiveExpression value="r"/>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </trueStatements>
                                </conditionStatement>
                              </trueStatements>
                            </conditionStatement>
                            <conditionStatement>
                              <condition>
                                <unaryOperatorExpression operator="Not">
                                  <variableReferenceExpression name="hasTitle"/>
                                </unaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="hasTitle"/>
                                  <primitiveExpression value="true"/>
                                </assignStatement>
                                <methodInvokeExpression methodName="WriteElementString">
                                  <target>
                                    <variableReferenceExpression name="output"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="title"/>
                                    <variableReferenceExpression name="text"/>
                                  </parameters>
                                </methodInvokeExpression>
                                <variableDeclarationStatement type="StringBuilder" name="link">
                                  <init>
                                    <objectCreateExpression type="StringBuilder"/>
                                  </init>
                                </variableDeclarationStatement>
                                <methodInvokeExpression methodName="Append">
                                  <target>
                                    <variableReferenceExpression name="link"/>
                                  </target>
                                  <parameters>
                                    <methodInvokeExpression methodName="Evaluate">
                                      <target>
                                        <fieldReferenceExpression name="config"/>
                                      </target>
                                      <parameters>
                                        <primitiveExpression value="string(/c:dataController/@name)"/>
                                        <!--<propertyReferenceExpression name="Resolver"/>-->
                                      </parameters>
                                    </methodInvokeExpression>
                                  </parameters>
                                </methodInvokeExpression>
                                <foreachStatement>
                                  <variable type="DataField" name="pkf"/>
                                  <target>
                                    <propertyReferenceExpression name="Fields">
                                      <argumentReferenceExpression name="page"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <statements>
                                    <conditionStatement>
                                      <condition>
                                        <propertyReferenceExpression name="IsPrimaryKey">
                                          <variableReferenceExpression name="pkf"/>
                                        </propertyReferenceExpression>
                                      </condition>
                                      <trueStatements>
                                        <methodInvokeExpression methodName="Append">
                                          <target>
                                            <variableReferenceExpression name="link"/>
                                          </target>
                                          <parameters>
                                            <methodInvokeExpression methodName="Format">
                                              <target>
                                                <typeReferenceExpression type="String"/>
                                              </target>
                                              <parameters>
                                                <primitiveExpression value="&amp;{{0}}={{1}}"/>
                                                <propertyReferenceExpression name="Name">
                                                  <variableReferenceExpression name="pkf"/>
                                                </propertyReferenceExpression>
                                                <arrayIndexerExpression>
                                                  <target>
                                                    <argumentReferenceExpression name="reader"/>
                                                  </target>
                                                  <indices>
                                                    <propertyReferenceExpression name="Name">
                                                      <variableReferenceExpression name="pkf"/>
                                                    </propertyReferenceExpression>
                                                  </indices>
                                                </arrayIndexerExpression>
                                              </parameters>
                                            </methodInvokeExpression>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </trueStatements>
                                    </conditionStatement>
                                  </statements>
                                </foreachStatement>
                                <variableDeclarationStatement type="System.String" name="itemGuid">
                                  <init>
                                    <methodInvokeExpression methodName="Format">
                                      <target>
                                        <typeReferenceExpression type="String"/>
                                      </target>
                                      <parameters>
                                        <primitiveExpression value="{{0}}Details.aspx?l={{1}}"/>
                                        <variableReferenceExpression name="appPath"/>
                                        <methodInvokeExpression methodName="UrlEncode">
                                          <target>
                                            <typeReferenceExpression type="HttpUtility"/>
                                          </target>
                                          <parameters>
                                            <methodInvokeExpression methodName="ToBase64String">
                                              <target>
                                                <typeReferenceExpression type="Convert"/>
                                              </target>
                                              <parameters>
                                                <methodInvokeExpression methodName="GetBytes">
                                                  <target>
                                                    <propertyReferenceExpression name="Default">
                                                      <typeReferenceExpression type="Encoding"/>
                                                    </propertyReferenceExpression>
                                                  </target>
                                                  <parameters>
                                                    <methodInvokeExpression methodName="ToString">
                                                      <target>
                                                        <variableReferenceExpression name="link"/>
                                                      </target>
                                                    </methodInvokeExpression>
                                                  </parameters>
                                                </methodInvokeExpression>
                                              </parameters>
                                            </methodInvokeExpression>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </init>
                                </variableDeclarationStatement>
                                <methodInvokeExpression methodName="WriteElementString">
                                  <target>
                                    <variableReferenceExpression name="output"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="link"/>
                                    <variableReferenceExpression name="itemGuid"/>
                                  </parameters>
                                </methodInvokeExpression>
                                <methodInvokeExpression methodName="WriteElementString">
                                  <target>
                                    <variableReferenceExpression name="output"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="guid"/>
                                    <variableReferenceExpression name="itemGuid"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </trueStatements>
                              <falseStatements>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="BooleanAnd">
                                      <unaryOperatorExpression operator="Not">
                                        <methodInvokeExpression methodName="IsNullOrEmpty">
                                          <target>
                                            <typeReferenceExpression type="String"/>
                                          </target>
                                          <parameters>
                                            <propertyReferenceExpression name="OnDemandHandler">
                                              <variableReferenceExpression name="field"/>
                                            </propertyReferenceExpression>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </unaryOperatorExpression>
                                      <binaryOperatorExpression operator="ValueEquality">
                                        <propertyReferenceExpression name="OnDemandStyle">
                                          <propertyReferenceExpression name="field"/>
                                        </propertyReferenceExpression>
                                        <propertyReferenceExpression name="Thumbnail">
                                          <typeReferenceExpression type="OnDemandDisplayStyle"/>
                                        </propertyReferenceExpression>
                                      </binaryOperatorExpression>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <conditionStatement>
                                      <condition>
                                        <methodInvokeExpression methodName="Equals">
                                          <target>
                                            <variableReferenceExpression name="text"/>
                                          </target>
                                          <parameters>
                                            <primitiveExpression value="1" convertTo="String"/>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </condition>
                                      <trueStatements>
                                        <methodInvokeExpression methodName="AppendFormat">
                                          <target>
                                            <variableReferenceExpression name="desc"/>
                                          </target>
                                          <parameters>
                                            <primitiveExpression>
                                              <xsl:attribute name="value"><![CDATA[{0}:<br /><img src="{1}Blob.ashx?{2}=t]]></xsl:attribute>
                                            </primitiveExpression>
                                            <methodInvokeExpression methodName="HtmlEncode">
                                              <target>
                                                <typeReferenceExpression type="HttpUtility"/>
                                              </target>
                                              <parameters>
                                                <propertyReferenceExpression name="Label">
                                                  <variableReferenceExpression name="field"/>
                                                </propertyReferenceExpression>
                                              </parameters>
                                            </methodInvokeExpression>
                                            <variableReferenceExpression name="appPath"/>
                                            <propertyReferenceExpression name="OnDemandHandler">
                                              <variableReferenceExpression name="field"/>
                                            </propertyReferenceExpression>
                                          </parameters>
                                        </methodInvokeExpression>
                                        <foreachStatement>
                                          <variable type="DataField" name="f"/>
                                          <target>
                                            <propertyReferenceExpression name="Fields">
                                              <argumentReferenceExpression name="page"/>
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
                                                <methodInvokeExpression methodName="Append">
                                                  <target>
                                                    <variableReferenceExpression name="desc"/>
                                                  </target>
                                                  <parameters>
                                                    <primitiveExpression value="|"/>
                                                  </parameters>
                                                </methodInvokeExpression>
                                                <methodInvokeExpression methodName="Append">
                                                  <target>
                                                    <variableReferenceExpression name="desc"/>
                                                  </target>
                                                  <parameters>
                                                    <arrayIndexerExpression>
                                                      <target>
                                                        <argumentReferenceExpression name="reader"/>
                                                      </target>
                                                      <indices>
                                                        <propertyReferenceExpression name="Name">
                                                          <variableReferenceExpression name="f"/>
                                                        </propertyReferenceExpression>
                                                      </indices>
                                                    </arrayIndexerExpression>
                                                  </parameters>
                                                </methodInvokeExpression>
                                              </trueStatements>
                                            </conditionStatement>
                                          </statements>
                                        </foreachStatement>
                                        <methodInvokeExpression methodName="Append">
                                          <target>
                                            <variableReferenceExpression name="desc"/>
                                          </target>
                                          <parameters>
                                            <primitiveExpression>
                                              <xsl:attribute name="value"><![CDATA[" style="width:92px;height:71px;"/><br />]]></xsl:attribute>
                                            </primitiveExpression>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </trueStatements>
                                    </conditionStatement>
                                  </trueStatements>
                                  <falseStatements>
                                    <methodInvokeExpression methodName="AppendFormat">
                                      <target>
                                        <variableReferenceExpression name="desc"/>
                                      </target>
                                      <parameters>
                                        <primitiveExpression>
                                          <xsl:attribute name="value"><![CDATA[{0}: {1}<br />]]></xsl:attribute>
                                        </primitiveExpression>
                                        <methodInvokeExpression methodName="HtmlEncode">
                                          <target>
                                            <typeReferenceExpression type="HttpUtility"/>
                                          </target>
                                          <parameters>
                                            <propertyReferenceExpression name="Label">
                                              <variableReferenceExpression name="field"/>
                                            </propertyReferenceExpression>
                                          </parameters>
                                        </methodInvokeExpression>
                                        <methodInvokeExpression methodName="HtmlEncode">
                                          <target>
                                            <typeReferenceExpression type="HttpUtility"/>
                                          </target>
                                          <parameters>
                                            <variableReferenceExpression name="text"/>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </falseStatements>
                                </conditionStatement>
                              </falseStatements>
                            </conditionStatement>
                          </trueStatements>
                        </conditionStatement>
                      </statements>
                    </forStatement>
                    <methodInvokeExpression methodName="WriteStartElement">
                      <target>
                        <variableReferenceExpression name="output"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="description"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="WriteCData">
                      <target>
                        <variableReferenceExpression name="output"/>
                      </target>
                      <parameters>
                        <methodInvokeExpression methodName="Format">
                          <target>
                            <typeReferenceExpression type="String"/>
                          </target>
                          <parameters>
                            <primitiveExpression>
                              <xsl:attribute name="value"><![CDATA[<span style=\"font-size:small;\">{0}</span>]]></xsl:attribute>
                            </primitiveExpression>
                            <methodInvokeExpression methodName="ToString">
                              <target>
                                <variableReferenceExpression name="desc"/>
                              </target>
                            </methodInvokeExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="WriteEndElement">
                      <target>
                        <variableReferenceExpression name="output"/>
                      </target>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="WriteEndElement">
                      <target>
                        <variableReferenceExpression name="output"/>
                      </target>
                    </methodInvokeExpression>
                    <assignStatement>
                      <variableReferenceExpression name="rowCount"/>
                      <binaryOperatorExpression operator="Add">
                        <variableReferenceExpression name="rowCount"/>
                        <primitiveExpression value="1"/>
                      </binaryOperatorExpression>
                    </assignStatement>
                  </statements>
                </whileStatement>
                <methodInvokeExpression methodName="WriteEndElement">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="WriteEndElement">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="WriteEndDocument">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Close">
                  <target>
                    <variableReferenceExpression name="output"/>
                  </target>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- ExportDataAsCsv(ViewPage page, DbDataReader reader, StreamWriter writer) -->
            <memberMethod name="ExportDataAsCsv">
              <attributes private="true"/>
              <parameters>
                <parameter type="ViewPage" name="page"/>
                <parameter type="DbDataReader" name="reader"/>
                <parameter type="StreamWriter" name="writer"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.Boolean" name="firstField">
                  <init>
                    <primitiveExpression value="true"/>
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
                        <propertyReferenceExpression name="Fields">
                          <argumentReferenceExpression name="page"/>
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
                        <unaryOperatorExpression operator="Not">
                          <propertyReferenceExpression name="Hidden">
                            <variableReferenceExpression name="field"/>
                          </propertyReferenceExpression>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
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
                            <methodInvokeExpression methodName="Write">
                              <target>
                                <argumentReferenceExpression name="writer"/>
                              </target>
                              <parameters>
                                <propertyReferenceExpression  name="ListSeparator">
                                  <typeReferenceExpression type="System.Globalization.CultureInfo.CurrentCulture.TextInfo"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </falseStatements>
                        </conditionStatement>
                        <conditionStatement>
                          <condition>
                            <unaryOperatorExpression operator="Not">
                              <methodInvokeExpression methodName="IsNullOrEmpty">
                                <target>
                                  <typeReferenceExpression type="String"/>
                                </target>
                                <parameters>
                                  <propertyReferenceExpression name="AliasName">
                                    <variableReferenceExpression name="field"/>
                                  </propertyReferenceExpression>
                                </parameters>
                              </methodInvokeExpression>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="field"/>
                              <methodInvokeExpression methodName="FindField">
                                <target>
                                  <argumentReferenceExpression name="page"/>
                                </target>
                                <parameters>
                                  <propertyReferenceExpression name="AliasName">
                                    <variableReferenceExpression name="field"/>
                                  </propertyReferenceExpression>
                                </parameters>
                              </methodInvokeExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <methodInvokeExpression methodName="Write">
                          <target>
                            <argumentReferenceExpression name="writer"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="&quot;{{0}}&quot;"/>
                            <methodInvokeExpression methodName="Replace">
                              <target>
                                <propertyReferenceExpression name="Label">
                                  <variableReferenceExpression name="field"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="&quot;"/>
                                <primitiveExpression value="&quot;&quot;"/>
                              </parameters>
                            </methodInvokeExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                    <methodInvokeExpression methodName="NormalizeDataFormatString">
                      <target>
                        <variableReferenceExpression name="field"/>
                      </target>
                    </methodInvokeExpression>
                  </statements>
                </forStatement>
                <methodInvokeExpression methodName="WriteLine">
                  <target>
                    <argumentReferenceExpression name="writer"/>
                  </target>
                </methodInvokeExpression>
                <whileStatement>
                  <test>
                    <methodInvokeExpression methodName="Read">
                      <target>
                        <argumentReferenceExpression name="reader"/>
                      </target>
                    </methodInvokeExpression>
                  </test>
                  <statements>
                    <assignStatement>
                      <variableReferenceExpression name="firstField"/>
                      <primitiveExpression value="true"/>
                    </assignStatement>
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
                            <propertyReferenceExpression name="Fields">
                              <argumentReferenceExpression name="page"/>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                        </binaryOperatorExpression>
                      </test>
                      <increment>
                        <variableReferenceExpression name="j"/>
                      </increment>
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
                                <variableReferenceExpression name="j"/>
                              </indices>
                            </arrayIndexerExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <unaryOperatorExpression operator="Not">
                              <propertyReferenceExpression name="Hidden">
                                <variableReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
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
                                <methodInvokeExpression methodName="Write">
                                  <target>
                                    <argumentReferenceExpression name="writer"/>
                                  </target>
                                  <parameters>
                                    <propertyReferenceExpression  name="ListSeparator">
                                      <typeReferenceExpression type="System.Globalization.CultureInfo.CurrentCulture.TextInfo"/>
                                    </propertyReferenceExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </falseStatements>
                            </conditionStatement>
                            <conditionStatement>
                              <condition>
                                <unaryOperatorExpression operator="Not">
                                  <methodInvokeExpression methodName="IsNullOrEmpty">
                                    <target>
                                      <typeReferenceExpression type="String"/>
                                    </target>
                                    <parameters>
                                      <propertyReferenceExpression name="AliasName">
                                        <variableReferenceExpression name="field"/>
                                      </propertyReferenceExpression>
                                    </parameters>
                                  </methodInvokeExpression>
                                </unaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="field"/>
                                  <methodInvokeExpression methodName="FindField">
                                    <target>
                                      <argumentReferenceExpression name="page"/>
                                    </target>
                                    <parameters>
                                      <propertyReferenceExpression name="AliasName">
                                        <variableReferenceExpression name="field"/>
                                      </propertyReferenceExpression>
                                    </parameters>
                                  </methodInvokeExpression>
                                </assignStatement>
                              </trueStatements>
                            </conditionStatement>
                            <variableDeclarationStatement type="System.String" name="text">
                              <init>
                                <propertyReferenceExpression name="Empty">
                                  <typeReferenceExpression type="String"/>
                                </propertyReferenceExpression>
                              </init>
                            </variableDeclarationStatement>
                            <variableDeclarationStatement type="System.Object" name="v">
                              <init>
                                <arrayIndexerExpression>
                                  <target>
                                    <argumentReferenceExpression name="reader"/>
                                  </target>
                                  <indices>
                                    <propertyReferenceExpression name="Name">
                                      <variableReferenceExpression name="field"/>
                                    </propertyReferenceExpression>
                                  </indices>
                                </arrayIndexerExpression>
                              </init>
                            </variableDeclarationStatement>
                            <conditionStatement>
                              <condition>
                                <unaryOperatorExpression operator="Not">
                                  <methodInvokeExpression methodName="Equals">
                                    <target>
                                      <propertyReferenceExpression name="Value">
                                        <typeReferenceExpression type="DBNull"/>
                                      </propertyReferenceExpression>
                                    </target>
                                    <parameters>
                                      <variableReferenceExpression name="v"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                </unaryOperatorExpression>
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
                                          <propertyReferenceExpression name="DataFormatString">
                                            <variableReferenceExpression name="field"/>
                                          </propertyReferenceExpression>
                                        </parameters>
                                      </methodInvokeExpression>
                                    </unaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <assignStatement>
                                      <variableReferenceExpression name="text"/>
                                      <methodInvokeExpression methodName="Format">
                                        <target>
                                          <typeReferenceExpression type="String"/>
                                        </target>
                                        <parameters>
                                          <propertyReferenceExpression name="DataFormatString">
                                            <variableReferenceExpression name="field"/>
                                          </propertyReferenceExpression>
                                          <variableReferenceExpression name="v"/>
                                        </parameters>
                                      </methodInvokeExpression>
                                    </assignStatement>
                                  </trueStatements>
                                  <falseStatements>
                                    <assignStatement>
                                      <variableReferenceExpression name="text"/>
                                      <methodInvokeExpression methodName="ToString">
                                        <target>
                                          <typeReferenceExpression type="Convert"/>
                                        </target>
                                        <parameters>
                                          <variableReferenceExpression name="v"/>
                                        </parameters>
                                      </methodInvokeExpression>
                                    </assignStatement>
                                  </falseStatements>
                                </conditionStatement>
                                <methodInvokeExpression methodName="Write">
                                  <target>
                                    <argumentReferenceExpression name="writer"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="&quot;{{0}}&quot;"/>
                                    <methodInvokeExpression methodName="Replace">
                                      <target>
                                        <variableReferenceExpression name="text"/>
                                      </target>
                                      <parameters>
                                        <primitiveExpression value="&quot;"/>
                                        <primitiveExpression value="&quot;&quot;"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </trueStatements>
                              <falseStatements>
                                <methodInvokeExpression methodName="Write">
                                  <target>
                                    <argumentReferenceExpression name="writer"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="&quot;&quot;"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </falseStatements>
                            </conditionStatement>
                          </trueStatements>
                        </conditionStatement>
                      </statements>
                    </forStatement>
                    <methodInvokeExpression methodName="WriteLine">
                      <target>
                        <argumentReferenceExpression name="writer"/>
                      </target>
                    </methodInvokeExpression>
                  </statements>
                </whileStatement>
              </statements>
            </memberMethod>
            <!-- property RowsetTypeMap -->
            <memberField type="SortedDictionary" name="rowsetTypeMap">
              <attributes private="true" static="true"/>
              <typeArguments>
                <typeReference type="System.String"/>
                <typeReference type="System.String"/>
              </typeArguments>
            </memberField>
            <memberProperty type="SortedDictionary" name="RowsetTypeMap">
              <typeArguments>
                <typeReference type="System.String"/>
                <typeReference type="System.String"/>
              </typeArguments>
              <attributes public="true" static="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="rowsetTypeMap"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
          </members>
        </typeDeclaration>
      </types>
    </compileUnit>
  </xsl:template>

</xsl:stylesheet>
