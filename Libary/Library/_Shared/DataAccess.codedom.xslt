<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.codeontime.com/2008/codedom-compiler"  xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl a"
>
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="Namespace"/>
  <xsl:param name="HostType"/>

  <xsl:template match="/">
    <compileUnit namespace="{$Namespace}.Data">
      <imports>
        <namespaceImport name="System"/>
        <namespaceImport name="System.Collections.Generic"/>
        <namespaceImport name="System.ComponentModel"/>
        <namespaceImport name="System.Configuration"/>
        <namespaceImport name="System.Data"/>
        <namespaceImport name="System.Data.Common"/>
        <namespaceImport name="System.Diagnostics"/>
        <namespaceImport name="System.Text.RegularExpressions"/>
        <namespaceImport name="System.Threading"/>
        <namespaceImport name="System.Web.Configuration"/>
      </imports>
      <types>
        <!-- class SessionStateMonitor -->
        <xsl:variable name="ManualResetEvent">
          <xsl:text>ManualResetEvent</xsl:text>
          <xsl:if test="a:project/@targetFramework='4.0'">
            <xsl:text>Slim</xsl:text>
          </xsl:if>
        </xsl:variable>
        <xsl:variable name="WaitMethod">
          <xsl:text>Wait</xsl:text>
          <xsl:if test="a:project/@targetFramework!='4.0'">
            <xsl:text>One</xsl:text>
          </xsl:if>
        </xsl:variable>
        <typeDeclaration name="SessionStateMonitor">
          <members>
            <!-- field SessionStateResetEvent -->
            <memberField type="{$ManualResetEvent}" name="monitorResetEvent">
              <attributes private="true" static="true"/>
              <init>
                <objectCreateExpression type="{$ManualResetEvent}">
                  <parameters>
                    <primitiveExpression value="false"/>
                  </parameters>
                </objectCreateExpression>
              </init>
            </memberField>
            <!-- method Start() -->
            <memberMethod name="Start">
              <attributes public="true" static="true"/>
              <statements>
                <variableDeclarationStatement type="WaitCallback" name="callback">
                  <init>
                    <addressOfExpression>
                      <methodReferenceExpression methodName="DeleteExpiredSessionsWorkItem"/>
                    </addressOfExpression>
                  </init>
                </variableDeclarationStatement>
                <methodInvokeExpression methodName="QueueUserWorkItem">
                  <target>
                    <typeReferenceExpression type="ThreadPool"/>
                  </target>
                  <parameters>
                    <variableReferenceExpression name="callback"/>
                  </parameters>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- method Stop() -->
            <memberMethod name="Stop">
              <attributes public="true" static="true"/>
              <statements>
                <methodInvokeExpression methodName="Set">
                  <target>
                    <fieldReferenceExpression name="monitorResetEvent"/>
                  </target>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- method DeleteExpiredSessionsWorkItem(object) -->
            <memberMethod name="DeleteExpiredSessionsWorkItem">
              <attributes private="true" static="true"/>
              <parameters>
                <parameter type="System.Object" name="state"/>
              </parameters>
              <statements>
                <whileStatement>
                  <test>
                    <unaryOperatorExpression operator="Not">
                      <methodInvokeExpression methodName="{$WaitMethod}">
                        <target>
                          <fieldReferenceExpression name="monitorResetEvent"/>
                        </target>
                        <parameters>
                          <primitiveExpression value="60000"/>
                        </parameters>
                      </methodInvokeExpression>
                    </unaryOperatorExpression>
                  </test>
                  <statements>
                    <tryStatement>
                      <statements>
                        <usingStatement>
                          <variable type="SqlProcedure" name="deleteExpiredSessions">
                            <init>
                              <objectCreateExpression type="SqlProcedure">
                                <parameters>
                                  <primitiveExpression value="DeleteExpiredSessions"/>
                                </parameters>
                              </objectCreateExpression>
                            </init>
                          </variable>
                          <statements>
                            <methodInvokeExpression methodName="ExecuteNonQuery">
                              <target>
                                <variableReferenceExpression name="deleteExpiredSessions"/>
                              </target>
                            </methodInvokeExpression>
                          </statements>
                        </usingStatement>
                      </statements>
                      <catch exceptionType="Exception"/>
                    </tryStatement>
                  </statements>
                </whileStatement>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
        <!-- class ConnectionStringSettingsFactoryBase -->
        <typeDeclaration name="ConnectionStringSettingsFactoryBase">
          <members>
            <!-- method CreateConnectionStringSettings(string) -->
            <memberMethod returnType="ConnectionStringSettings" name="CreateSettings">
              <attributes family="true" />
              <parameters>
                <parameter type="System.String" name="connectionStringName"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="IsNullOrEmpty">
                      <target>
                        <typeReferenceExpression type="String"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="connectionStringName"/>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="connectionStringName"/>
                      <!--<primitiveExpression value="{$Namespace}"/>-->
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
                <methodReturnStatement>
                  <arrayIndexerExpression>
                    <target>
                      <propertyReferenceExpression name="ConnectionStrings">
                        <typeReferenceExpression type="WebConfigurationManager"/>
                      </propertyReferenceExpression>
                    </target>
                    <indices>
                      <argumentReferenceExpression name="connectionStringName"/>
                    </indices>
                  </arrayIndexerExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
        <!-- class ConnectionStringSettingsFactory -->
        <typeDeclaration name="ConnectionStringSettingsFactory" isPartial="true">
          <baseTypes>
            <typeReference type="ConnectionStringSettingsFactoryBase"/>
          </baseTypes>
          <members>
            <!-- method Create(string) -->
            <memberMethod returnType="ConnectionStringSettings" name="Create">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="connectionStringName"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="ConnectionStringSettingsFactory" name="settingsFactory">
                  <init>
                    <objectCreateExpression type="ConnectionStringSettingsFactory"/>
                  </init>
                </variableDeclarationStatement>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="CreateSettings">
                    <target>
                      <variableReferenceExpression name="settingsFactory"/>
                    </target>
                    <parameters>
                      <argumentReferenceExpression name="connectionStringName"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
        <!-- class SqlParam-->
        <typeDeclaration name="SqlParam">
          <members>
            <memberProperty type="System.String" name="Name">
              <attributes public="true"/>
            </memberProperty>
            <memberProperty type="System.Object" name="Value">
              <attributes public="true"/>
            </memberProperty>
            <constructor>
              <attributes public="true"/>
              <parameters>
                <parameter type="System.String" name="name"/>
                <parameter type="System.Object" name="value"/>
              </parameters>
              <statements>
                <assignStatement>
                  <propertyReferenceExpression name="Name">
                    <thisReferenceExpression/>
                  </propertyReferenceExpression>
                  <argumentReferenceExpression name="name"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Value">
                    <thisReferenceExpression/>
                  </propertyReferenceExpression>
                  <argumentReferenceExpression name="value"/>
                </assignStatement>
              </statements>
            </constructor>
          </members>
        </typeDeclaration>
        <!-- class SqlStatement -->
        <typeDeclaration name="SqlStatement" isPartial="true">
          <baseTypes>
            <typeReference type="System.Object"/>
            <typeReference type="IDisposable"/>
          </baseTypes>
          <members>
            <memberField type="System.Boolean" name="disposed"/>
            <memberField type="System.Object" name="scalar"/>
            <memberField type="DbConnection" name="connection"/>
            <memberField type="DbCommand" name="command"/>
            <memberField type="DbDataReader" name="reader"/>
            <!-- property Name -->
            <memberProperty type="System.String" name="Name">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property WriteExceptionsToEventLog -->
            <memberProperty type="System.Boolean" name="WriteExceptionsToEventLog">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- constructor (CommandType, string, string) -->
            <constructor>
              <attributes public="true"/>
              <parameters>
                <parameter type="CommandType" name="commandType"/>
                <parameter type="System.String" name="commandText"/>
                <parameter type="System.String" name="connectionStringName"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="ConnectionStringSettings" name="settings">
                  <init>
                    <methodInvokeExpression methodName="Create">
                      <target>
                        <typeReferenceExpression type="ConnectionStringSettingsFactory"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="connectionStringName"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
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
                <assignStatement>
                  <fieldReferenceExpression name="connection"/>
                  <methodInvokeExpression methodName="CreateConnection">
                    <target>
                      <variableReferenceExpression name="factory"/>
                    </target>
                  </methodInvokeExpression>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="ConnectionString">
                    <fieldReferenceExpression name="connection"/>
                  </propertyReferenceExpression>
                  <propertyReferenceExpression name="ConnectionString">
                    <variableReferenceExpression name="settings"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <methodInvokeExpression methodName="Open">
                  <target>
                    <fieldReferenceExpression name="connection"/>
                  </target>
                </methodInvokeExpression>
                <assignStatement>
                  <fieldReferenceExpression name="command"/>
                  <methodInvokeExpression methodName="CreateCommand">
                    <target>
                      <typeReferenceExpression type="SqlStatement"/>
                    </target>
                    <parameters>
                      <fieldReferenceExpression name="connection"/>
                    </parameters>
                  </methodInvokeExpression>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="CommandType">
                    <fieldReferenceExpression name="command"/>
                  </propertyReferenceExpression>
                  <argumentReferenceExpression name="commandType"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="CommandText">
                    <fieldReferenceExpression name="command"/>
                  </propertyReferenceExpression>
                  <argumentReferenceExpression name="commandText"/>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="parameterMarker"/>
                  <methodInvokeExpression methodName="ConvertTypeToParameterMarker">
                    <parameters>
                      <propertyReferenceExpression name="ProviderName">
                        <variableReferenceExpression name="settings"/>
                      </propertyReferenceExpression>
                    </parameters>
                  </methodInvokeExpression>
                  <!--<methodInvokeExpression methodName="GetParameterMarker">
                    <parameters>
                      <variableReferenceExpression name="settings"/>
                    </parameters>
                  </methodInvokeExpression>-->
                </assignStatement>
              </statements>
            </constructor>

            <!-- 
        private static Regex SqlClientValueEscape = new Regex(@"(%|_|\[)");

        public static string EscapePattern(DbCommand command, string v)
        {
            if (String.IsNullOrEmpty(v))
                return v;
            if (command.GetType().FullName == "System.Data.SqlClient.SqlCommand")
                return SqlClientValueEscape.Replace(v, "[$1]");
            return v;
        }            -->
            <!-- member SqlClientPatternEscape -->
            <memberField type="Regex" name="sqlClientPatternEscape">
              <attributes private="true" static="true"/>
              <init>
                <objectCreateExpression type="Regex">
                  <parameters>
                    <primitiveExpression value="(%|_|\[)"/>
                  </parameters>
                </objectCreateExpression>
              </init>
            </memberField>
            <!-- method Escape(DbCommand, string) -->
            <memberMethod returnType="System.String" name="EscapePattern">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="DbCommand" name="command"/>
                <parameter type="System.String" name="s"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="IsNullOrEmpty">
                      <argumentReferenceExpression name="s"/>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <argumentReferenceExpression name="s"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <propertyReferenceExpression name="FullName">
                        <methodInvokeExpression methodName="GetType">
                          <target>
                            <argumentReferenceExpression name="command"/>
                          </target>
                        </methodInvokeExpression>
                      </propertyReferenceExpression>
                      <primitiveExpression value="System.Data.SqlClient.SqlCommand"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <methodInvokeExpression methodName="Replace">
                        <target>
                          <fieldReferenceExpression name="sqlClientPatternEscape"/>
                        </target>
                        <parameters>
                          <argumentReferenceExpression name="s"/>
                          <primitiveExpression value="[$1]"/>
                        </parameters>
                      </methodInvokeExpression>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <argumentReferenceExpression name="s"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- property Reader -->
            <memberProperty type="DbDataReader" name="Reader">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="reader"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property Command-->
            <memberProperty type="DbCommand" name="Command">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="command"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property Scalar -->
            <memberProperty type="System.Object" name="Scalar">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="scalar"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property Parameters -->
            <memberProperty type="DbParameterCollection" name="Parameters">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <propertyReferenceExpression name="Parameters">
                    <fieldReferenceExpression name="command"/>
                  </propertyReferenceExpression>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property this[string] -->
            <memberProperty type="System.Object" name="Item">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="System.String" name="name"/>
              </parameters>
              <getStatements>
                <methodReturnStatement>
                  <arrayIndexerExpression>
                    <target>
                      <fieldReferenceExpression name="reader"/>
                    </target>
                    <indices>
                      <argumentReferenceExpression name="name"/>
                    </indices>
                  </arrayIndexerExpression>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property ParameterMarker -->
            <memberField type="System.String" name="parameterMarker"/>
            <memberProperty type="System.String" name="ParameterMarker">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="parameterMarker"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>

            <!-- method GetParameterMarker(string) -->
            <memberMethod returnType="System.String" name="GetParameterMarker">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="connectionStringName"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="ConnectionStringSettings" name="settings">
                  <init>
                    <methodInvokeExpression methodName="Create">
                      <target>
                        <typeReferenceExpression type="ConnectionStringSettingsFactory"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="connectionStringName"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <methodReturnStatement>
                  <!--<methodInvokeExpression methodName="GetParameterMarker">
                    <parameters>
                      <variableReferenceExpression name="settings"/>
                    </parameters>
                  </methodInvokeExpression>-->
                  <methodInvokeExpression methodName="ConvertTypeToParameterMarker">
                    <parameters>
                      <propertyReferenceExpression name="ProviderName">
                        <variableReferenceExpression name="settings"/>
                      </propertyReferenceExpression>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method GetParameterMarker(ConnectionStringSettings) -->
            <!--<memberMethod returnType="System.String" name="GetParameterMarker">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="ConnectionStringSettings" name="settings"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="Contains">
                      <target>
                        <propertyReferenceExpression name="ProviderName">
                          <argumentReferenceExpression name="settings"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <primitiveExpression value="Oracle"/>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value=":"/>
                    </methodReturnStatement>
                  </trueStatements>
                  <falseStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="@"/>
                    </methodReturnStatement>
                  </falseStatements>
                </conditionStatement>
              </statements>
            </memberMethod>-->
            <!-- method ConvertTypeToParameterMarker(Type) -->
            <memberMethod returnType="System.String" name="ConvertTypeToParameterMarker">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="Type" name="t"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="ConvertTypeToParameterMarker">
                    <parameters>
                      <propertyReferenceExpression name="FullName">
                        <argumentReferenceExpression name="t"/>
                      </propertyReferenceExpression>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method ConvertTypeToParameterMarker(string) -->
            <memberMethod returnType="System.String" name="ConvertTypeToParameterMarker">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="typeName"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanOr">
                      <methodInvokeExpression methodName="Contains">
                        <target>
                          <argumentReferenceExpression name="typeName"/>
                        </target>
                        <parameters>
                          <primitiveExpression value="Oracle"/>
                        </parameters>
                      </methodInvokeExpression>
                      <methodInvokeExpression methodName="Contains">
                        <target>
                          <argumentReferenceExpression name="typeName"/>
                        </target>
                        <parameters>
                          <primitiveExpression value="SQLAnywhere"/>
                        </parameters>
                      </methodInvokeExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value=":"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <primitiveExpression value="@"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method ConvertTypeToLeftQuote(string) -->
            <memberMethod returnType="System.String" name="ConvertTypeToLeftQuote">
              <attributes static="true" public="true"/>
              <parameters>
                <parameter type="System.String" name="typeName"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="Contains">
                      <target>
                        <argumentReferenceExpression name="typeName"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="OleDb"/>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="["/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="Contains">
                      <target>
                        <argumentReferenceExpression name="typeName"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="MySql"/>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="`"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <primitiveExpression value="&quot;"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method ConvertTypeToRightQuote(string) -->
            <memberMethod returnType="System.String" name="ConvertTypeToRightQuote">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="typeName"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.String" name="quote">
                  <init>
                    <methodInvokeExpression methodName="ConvertTypeToLeftQuote">
                      <parameters>
                        <argumentReferenceExpression name="typeName"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <variableReferenceExpression name="quote"/>
                      <primitiveExpression value="["/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="]"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <variableReferenceExpression name="quote"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- 
        ~SqlStatement()
        {
            Dispose(true);
        }
            -->
            <!-- property this[int] -->
            <memberProperty type="System.Object" name="Item">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="System.Int32" name="index"/>
              </parameters>
              <getStatements>
                <methodReturnStatement>
                  <arrayIndexerExpression>
                    <target>
                      <fieldReferenceExpression name="reader"/>
                    </target>
                    <indices>
                      <argumentReferenceExpression name="index"/>
                    </indices>
                  </arrayIndexerExpression>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- method Close()-->
            <memberMethod name="Close">
              <attributes public="true" final="true"/>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <binaryOperatorExpression operator="IdentityInequality">
                        <fieldReferenceExpression name="reader"/>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                      <unaryOperatorExpression operator="Not">
                        <propertyReferenceExpression name="IsClosed">
                          <fieldReferenceExpression name="reader"/>
                        </propertyReferenceExpression>
                      </unaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="Close">
                      <target>
                        <fieldReferenceExpression name="reader"/>
                      </target>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <binaryOperatorExpression operator="IdentityInequality">
                        <fieldReferenceExpression name="command"/>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                      <binaryOperatorExpression operator="ValueEquality">
                        <propertyReferenceExpression name="State">
                          <propertyReferenceExpression name="Connection">
                            <fieldReferenceExpression name="command"/>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                        <propertyReferenceExpression name="Open">
                          <typeReferenceExpression type="ConnectionState"/>
                        </propertyReferenceExpression>
                      </binaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="Close">
                      <target>
                        <propertyReferenceExpression name="Connection">
                          <fieldReferenceExpression name="command"/>
                        </propertyReferenceExpression>
                      </target>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method IDisposable.Dispose() -->
            <memberMethod name="Dispose" privateImplementationType="IDisposable">
              <attributes private="true" final="true"/>
              <statements>
                <methodInvokeExpression methodName="Dispose">
                  <parameters>
                    <primitiveExpression value="true"/>
                  </parameters>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- method Dispose(bool) -->
            <memberMethod name="Dispose">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="System.Boolean" name="disposing"/>
              </parameters>
              <statements>
                <methodInvokeExpression methodName="Close"/>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="Not">
                      <fieldReferenceExpression name="disposed"/>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityInequality">
                          <fieldReferenceExpression name="reader"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="Dispose">
                          <target>
                            <fieldReferenceExpression name="reader"/>
                          </target>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityInequality">
                          <fieldReferenceExpression name="command"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="Dispose">
                          <target>
                            <fieldReferenceExpression name="command"/>
                          </target>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityInequality">
                          <fieldReferenceExpression name="connection"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="Dispose">
                          <target>
                            <fieldReferenceExpression name="connection"/>
                          </target>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                    <assignStatement>
                      <fieldReferenceExpression name="disposed"/>
                      <primitiveExpression value="true"/>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <argumentReferenceExpression name="disposing"/>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="SuppressFinalize">
                      <target>
                        <typeReferenceExpression type="GC"/>
                      </target>
                      <parameters>
                        <thisReferenceExpression/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method ExecuteReader() -->
            <memberMethod returnType="DbDataReader" name="ExecuteReader">
              <attributes public="true" final="true"/>
              <statements>
                <tryStatement>
                  <statements>
                    <assignStatement>
                      <fieldReferenceExpression name="reader"/>
                      <methodInvokeExpression methodName="ExecuteReader">
                        <target>
                          <fieldReferenceExpression name="command"/>
                        </target>
                      </methodInvokeExpression>
                    </assignStatement>
                    <methodReturnStatement>
                      <fieldReferenceExpression name="reader"/>
                    </methodReturnStatement>
                  </statements>
                  <catch exceptionType="Exception" localName="e">
                    <methodInvokeExpression methodName="Log">
                      <parameters>
                        <variableReferenceExpression name="e"/>
                      </parameters>
                    </methodInvokeExpression>
                    <throwExceptionStatement/>
                  </catch>
                </tryStatement>
              </statements>
            </memberMethod>
            <!-- method ExecuteScalar -->
            <memberMethod returnType="System.Object" name="ExecuteScalar">
              <attributes public="true" final="true"/>
              <statements>
                <tryStatement>
                  <statements>
                    <assignStatement>
                      <fieldReferenceExpression name="scalar"/>
                      <methodInvokeExpression methodName="ExecuteScalar">
                        <target>
                          <fieldReferenceExpression name="command"/>
                        </target>
                      </methodInvokeExpression>
                    </assignStatement>
                    <methodReturnStatement>
                      <fieldReferenceExpression name="scalar"/>
                    </methodReturnStatement>
                  </statements>
                  <catch exceptionType="Exception" localName="e">
                    <methodInvokeExpression methodName="Log">
                      <parameters>
                        <variableReferenceExpression name="e"/>
                      </parameters>
                    </methodInvokeExpression>
                    <throwExceptionStatement/>
                  </catch>
                </tryStatement>
              </statements>
            </memberMethod>
            <!-- method ExecuteNonQuery() -->
            <memberMethod returnType="System.Int32" name="ExecuteNonQuery">
              <attributes public="true" final="true"/>
              <statements>
                <tryStatement>
                  <statements>
                    <methodReturnStatement>
                      <methodInvokeExpression methodName="ExecuteNonQuery">
                        <target>
                          <fieldReferenceExpression name="command"/>
                        </target>
                      </methodInvokeExpression>
                    </methodReturnStatement>
                  </statements>
                  <catch exceptionType="Exception" localName="e">
                    <methodInvokeExpression methodName="Log">
                      <parameters>
                        <variableReferenceExpression name="e"/>
                      </parameters>
                    </methodInvokeExpression>
                    <throwExceptionStatement/>
                  </catch>
                </tryStatement>
              </statements>
            </memberMethod>
            <!-- method Read()-->
            <memberMethod returnType="System.Boolean" name="Read">
              <attributes public="true" final="true"/>
              <statements>
                <tryStatement>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityEquality">
                          <fieldReferenceExpression name="reader"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="ExecuteReader"/>
                      </trueStatements>
                    </conditionStatement>
                    <methodReturnStatement>
                      <methodInvokeExpression methodName="Read">
                        <target>
                          <fieldReferenceExpression name="reader"/>
                        </target>
                      </methodInvokeExpression>
                    </methodReturnStatement>
                  </statements>
                  <catch exceptionType="Exception" localName="e">
                    <methodInvokeExpression methodName="Log">
                      <parameters>
                        <variableReferenceExpression name="e"/>
                      </parameters>
                    </methodInvokeExpression>
                    <throwExceptionStatement/>
                  </catch>
                </tryStatement>
              </statements>
            </memberMethod>
            <!-- method Log(Exception) -->
            <memberMethod name="Log">
              <attributes family="true"/>
              <parameters>
                <parameter type="Exception" name="ex"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <propertyReferenceExpression name="WriteExceptionsToEventLog"/>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="EventLog" name="log">
                      <init>
                        <objectCreateExpression type="EventLog"/>
                      </init>
                    </variableDeclarationStatement>
                    <assignStatement>
                      <propertyReferenceExpression name="Log">
                        <variableReferenceExpression name="log"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="Application"/>
                    </assignStatement>
                    <assignStatement>
                      <propertyReferenceExpression name="Source">
                        <variableReferenceExpression name="log"/>
                      </propertyReferenceExpression>
                      <propertyReferenceExpression name="FullName">
                        <methodInvokeExpression methodName="GetType"/>
                      </propertyReferenceExpression>
                    </assignStatement>
                    <variableDeclarationStatement type="System.String" name="action">
                      <init>
                        <primitiveExpression value="null"/>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="IsNotNullOrEmpty">
                          <propertyReferenceExpression name="Name"/>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="System.String[]" name="parts">
                          <init>
                            <methodInvokeExpression methodName="Split">
                              <target>
                                <propertyReferenceExpression name="Name"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="," convertTo="Char"/>
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <assignStatement>
                          <propertyReferenceExpression name="Source">
                            <variableReferenceExpression name="log"/>
                          </propertyReferenceExpression>
                          <arrayIndexerExpression>
                            <target>
                              <variableReferenceExpression name="parts"/>
                            </target>
                            <indices>
                              <primitiveExpression value="0"/>
                            </indices>
                          </arrayIndexerExpression>
                        </assignStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="GreaterThan">
                              <propertyReferenceExpression name="Length">
                                <variableReferenceExpression name="parts"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="1"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="action"/>
                              <arrayIndexerExpression>
                                <target>
                                  <variableReferenceExpression name="parts"/>
                                </target>
                                <indices>
                                  <primitiveExpression value="1"/>
                                </indices>
                              </arrayIndexerExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
                    <variableDeclarationStatement type="System.String" name="message">
                      <init>
                        <primitiveExpression value="An exception has occurred. Please check the Event Log.&#10;&#10;"/>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="IsNotNullOrEmpty">
                          <variableReferenceExpression name="action"/>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="message"/>
                          <stringFormatExpression format="{{0}}Action: {{1}}&#10;&#10;">
                            <variableReferenceExpression name="message"/>
                            <variableReferenceExpression name="action"/>
                          </stringFormatExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                    <assignStatement>
                      <variableReferenceExpression name="message"/>
                      <stringFormatExpression format="{{0}}Exception: {{1}}">
                        <variableReferenceExpression name="message"/>
                        <methodInvokeExpression methodName="ToString">
                          <target>
                            <variableReferenceExpression name="message"/>
                          </target>
                        </methodInvokeExpression>
                      </stringFormatExpression>
                    </assignStatement>
                    <methodInvokeExpression methodName="WriteEntry">
                      <target>
                        <variableReferenceExpression name="log"/>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="message"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                  <falseStatements>
                    <throwExceptionStatement>
                      <argumentReferenceExpression name="ex"/>
                    </throwExceptionStatement>
                  </falseStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method AddParameterWithoutValue(string) -->
            <memberMethod returnType="DbParameter" name="AddParameterWithoutValue">
              <attributes private="true" final="true"/>
              <parameters>
                <parameter type="System.String" name="parameterName"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="DbParameter" name="p">
                  <init>
                    <methodInvokeExpression methodName="CreateParameter">
                      <target>
                        <fieldReferenceExpression name="command"/>
                      </target>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <assignStatement>
                  <propertyReferenceExpression name="ParameterName">
                    <variableReferenceExpression name="p"/>
                  </propertyReferenceExpression>
                  <argumentReferenceExpression name="parameterName"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Value">
                    <variableReferenceExpression name="p"/>
                  </propertyReferenceExpression>
                  <propertyReferenceExpression name="Value">
                    <typeReferenceExpression type="DBNull"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <propertyReferenceExpression name="Parameters">
                      <fieldReferenceExpression name="command"/>
                    </propertyReferenceExpression>
                  </target>
                  <parameters>
                    <variableReferenceExpression name="p"/>
                  </parameters>
                </methodInvokeExpression>
                <methodReturnStatement>
                  <variableReferenceExpression name="p"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- AddParameterWithValue(string, object) -->
            <memberMethod returnType="DbParameter" name="AddParameterWithValue">
              <attributes private="true" final="true"/>
              <parameters>
                <parameter type="System.String" name="parameterName"/>
                <parameter type="System.Object" name="value"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="DbParameter" name="p">
                  <init>
                    <methodInvokeExpression methodName="CreateParameter">
                      <target>
                        <fieldReferenceExpression name="command"/>
                      </target>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <assignStatement>
                  <propertyReferenceExpression name="ParameterName">
                    <variableReferenceExpression name="p"/>
                  </propertyReferenceExpression>
                  <argumentReferenceExpression name="parameterName"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Value">
                    <variableReferenceExpression name="p"/>
                  </propertyReferenceExpression>
                  <argumentReferenceExpression name="value"/>
                </assignStatement>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <propertyReferenceExpression name="Parameters">
                      <fieldReferenceExpression name="command"/>
                    </propertyReferenceExpression>
                  </target>
                  <parameters>
                    <variableReferenceExpression name="p"/>
                  </parameters>
                </methodInvokeExpression>
                <methodReturnStatement>
                  <variableReferenceExpression name="p"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <xsl:call-template name="DeclareAddValueMethod">
              <xsl:with-param name="Type" select="'SByte'"/>
            </xsl:call-template>
            <xsl:call-template name="DeclareAddValueMethod">
              <xsl:with-param name="Type" select="'Byte'"/>
            </xsl:call-template>
            <xsl:call-template name="DeclareAddValueMethod">
              <xsl:with-param name="Type" select="'Int16'"/>
            </xsl:call-template>
            <xsl:call-template name="DeclareAddValueMethod">
              <xsl:with-param name="Type" select="'UInt16'"/>
            </xsl:call-template>
            <xsl:call-template name="DeclareAddValueMethod">
              <xsl:with-param name="Type" select="'Int32'"/>
            </xsl:call-template>
            <xsl:call-template name="DeclareAddValueMethod">
              <xsl:with-param name="Type" select="'UInt32'"/>
            </xsl:call-template>
            <xsl:call-template name="DeclareAddValueMethod">
              <xsl:with-param name="Type" select="'Int64'"/>
            </xsl:call-template>
            <xsl:call-template name="DeclareAddValueMethod">
              <xsl:with-param name="Type" select="'UInt64'"/>
            </xsl:call-template>
            <xsl:call-template name="DeclareAddValueMethod">
              <xsl:with-param name="Type" select="'Single'"/>
            </xsl:call-template>
            <xsl:call-template name="DeclareAddValueMethod">
              <xsl:with-param name="Type" select="'Decimal'"/>
            </xsl:call-template>
            <xsl:call-template name="DeclareAddValueMethod">
              <xsl:with-param name="Type" select="'Double'"/>
            </xsl:call-template>
            <xsl:call-template name="DeclareAddValueMethod">
              <xsl:with-param name="Type" select="'Char'"/>
            </xsl:call-template>
            <xsl:call-template name="DeclareAddValueMethod">
              <xsl:with-param name="Type" select="'Boolean'"/>
            </xsl:call-template>
            <xsl:call-template name="DeclareAddValueMethod">
              <xsl:with-param name="Type" select="'DateTime'"/>
            </xsl:call-template>
            <memberMethod returnType="DbParameter" name="AddParameter">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="System.String" name="parameterName"/>
                <parameter type="System.Object" name="value"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanOr">
                      <binaryOperatorExpression operator="IdentityEquality">
                        <argumentReferenceExpression name="value"/>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                      <methodInvokeExpression methodName="Equals">
                        <target>
                          <propertyReferenceExpression name="Value">
                            <typeReferenceExpression type="DBNull"/>
                          </propertyReferenceExpression>
                        </target>
                        <parameters>
                          <argumentReferenceExpression name="value"/>
                        </parameters>
                      </methodInvokeExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <methodInvokeExpression methodName="AddParameterWithoutValue">
                        <parameters>
                          <argumentReferenceExpression name="parameterName"/>
                        </parameters>
                      </methodInvokeExpression>
                    </methodReturnStatement>
                  </trueStatements>
                  <falseStatements>
                    <methodReturnStatement>
                      <methodInvokeExpression methodName="AddParameterWithValue">
                        <parameters>
                          <argumentReferenceExpression name="parameterName"/>
                          <argumentReferenceExpression name="value"/>
                        </parameters>
                      </methodInvokeExpression>
                    </methodReturnStatement>
                  </falseStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method CreateCommand(DbConnection) -->
            <memberMethod returnType="DbCommand" name="CreateCommand">
              <attributes public="true" static="true"/>
              <parameters >
                <parameter type="DbConnection" name="connection"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="DbCommand" name="command">
                  <init>
                    <methodInvokeExpression methodName="CreateCommand">
                      <target>
                        <argumentReferenceExpression name="connection"/>
                      </target>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="Type" name="t">
                  <init>
                    <methodInvokeExpression methodName="GetType">
                      <target>
                        <variableReferenceExpression name="command"/>
                      </target>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.String" name="typeName">
                  <init>
                    <propertyReferenceExpression name="FullName">
                      <variableReferenceExpression name="t"/>
                    </propertyReferenceExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <methodInvokeExpression methodName="Contains">
                        <target>
                          <variableReferenceExpression name="typeName"/>
                        </target>
                        <parameters>
                          <primitiveExpression value="Oracle"/>
                        </parameters>
                      </methodInvokeExpression>
                      <methodInvokeExpression methodName="Contains">
                        <target>
                          <variableReferenceExpression name="typeName"/>
                        </target>
                        <parameters>
                          <primitiveExpression value="DataAccess"/>
                        </parameters>
                      </methodInvokeExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="SetValue">
                      <target>
                        <methodInvokeExpression methodName="GetProperty">
                          <target>
                            <variableReferenceExpression name="t"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="BindByName"/>
                          </parameters>
                        </methodInvokeExpression>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="command"/>
                        <primitiveExpression value="true"/>
                        <primitiveExpression value="null"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <variableReferenceExpression name="command"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- 
        private static DateTime MinSqlServerDate = new DateTime(1753, 1, 1);

        internal static bool TryPaseDate(Type type, string pv, out DateTime paramValueAsDate)
        {
            bool success = DateTime.TryParse(pv, out paramValueAsDate);
            if (success)
            {
                if (type.FullName.Contains(".SqlClient.") && paramValueAsDate < MinSqlServerDate)
                    return false;
                return true;
            }
            return false;
        }            -->
            <!-- method TryParseDate(Type, string, DateTime) -->
            <memberField type="System.DateTime" name="MinSqlServerDate">
              <attributes public="true" static="true"/>
              <init>
                <objectCreateExpression type="DateTime">
                  <parameters>
                    <primitiveExpression value="1753"/>
                    <primitiveExpression value="1"/>
                    <primitiveExpression value="1"/>
                  </parameters>
                </objectCreateExpression>
              </init>
            </memberField>
            <memberMethod returnType="System.Boolean" name="TryParseDate">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="Type" name="t"/>
                <parameter type="System.String" name="s"/>
                <parameter type="System.DateTime" name="result" direction="Out"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.Boolean" name="success">
                  <init>
                    <methodInvokeExpression methodName="TryParse">
                      <target>
                        <typeReferenceExpression type="System.DateTime"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="s"/>
                        <directionExpression direction="Out">
                          <argumentReferenceExpression name="result"/>
                        </directionExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <variableReferenceExpression name="success"/>
                  </condition>
                  <trueStatements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanAnd">
                          <methodInvokeExpression methodName="Contains">
                            <target>
                              <propertyReferenceExpression name="FullName">
                                <argumentReferenceExpression name="t"/>
                              </propertyReferenceExpression>
                            </target>
                            <parameters>
                              <primitiveExpression value=".SqlClient."/>
                            </parameters>
                          </methodInvokeExpression>
                          <binaryOperatorExpression operator="LessThan">
                            <argumentReferenceExpression name="result"/>
                            <propertyReferenceExpression name="MinSqlServerDate"/>
                          </binaryOperatorExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodReturnStatement>
                          <primitiveExpression value="false"/>
                        </methodReturnStatement>
                      </trueStatements>
                    </conditionStatement>
                    <methodReturnStatement>
                      <primitiveExpression value="true"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <primitiveExpression value="false"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method AssignParameter(string, object)  -->
            <memberMethod name="AssignParameter">
              <comment>
                <![CDATA[
        /// <summary>
        /// The method will automatically locate and change an existing parameter for a given name with or without a parameter marker. 
        /// If the parameter is not found then a new parameter is created. Otherwise the value of an existing parameter is changed.
        /// </summary>
        /// <param name="name">The name of a parameter.</param>
        /// <param name="value">The new value of a parameter.</param>
              ]]>
              </comment>
              <attributes public="true"/>
              <parameters>
                <parameter type="System.String" name="name"/>
                <parameter type="System.Object" name="value"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <binaryOperatorExpression operator="IdentityInequality">
                        <argumentReferenceExpression name="value"/>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                      <binaryOperatorExpression operator="IsTypeOf">
                        <argumentReferenceExpression name="value"/>
                        <typeReferenceExpression type="System.Boolean"/>
                      </binaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <conditionStatement>
                      <condition>
                        <castExpression targetType="System.Boolean">
                          <argumentReferenceExpression name="value"/>
                        </castExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <argumentReferenceExpression name="value"/>
                          <primitiveExpression value="1"/>
                        </assignStatement>
                      </trueStatements>
                      <falseStatements>
                        <assignStatement>
                          <variableReferenceExpression name="value"/>
                          <primitiveExpression value="0"/>
                        </assignStatement>
                      </falseStatements>
                    </conditionStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="Not">
                      <methodInvokeExpression methodName="StartsWith">
                        <target>
                          <argumentReferenceExpression name="name"/>
                        </target>
                        <parameters>
                          <propertyReferenceExpression name="ParameterMarker"/>
                        </parameters>
                      </methodInvokeExpression>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <argumentReferenceExpression name="name"/>
                      <binaryOperatorExpression operator="Add">
                        <propertyReferenceExpression name="ParameterMarker"/>
                        <argumentReferenceExpression name="name"/>
                      </binaryOperatorExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <foreachStatement>
                  <variable type="DbParameter" name="p"/>
                  <target>
                    <propertyReferenceExpression name="Parameters">
                      <propertyReferenceExpression name="Command"/>
                    </propertyReferenceExpression>
                  </target>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="ValueEquality">
                          <propertyReferenceExpression name="ParameterName">
                            <variableReferenceExpression name="p"/>
                          </propertyReferenceExpression>
                          <argumentReferenceExpression name="name"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <propertyReferenceExpression name="Value">
                            <variableReferenceExpression name="p"/>
                          </propertyReferenceExpression>
                          <argumentReferenceExpression name="value"/>
                        </assignStatement>
                        <methodReturnStatement/>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
                <methodInvokeExpression methodName="AddParameter">
                  <parameters>
                    <argumentReferenceExpression name="name"/>
                    <argumentReferenceExpression name="value"/>
                  </parameters>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
        <!-- class SqlProcedure -->
        <typeDeclaration name="SqlProcedure">
          <baseTypes>
            <typeReference type="SqlStatement"/>
          </baseTypes>
          <members>
            <!-- constructor(string) -->
            <constructor>
              <attributes public="true"/>
              <parameters>
                <parameter type="System.String" name="procedureName"/>
              </parameters>
              <chainedConstructorArgs>
                <argumentReferenceExpression name="procedureName"/>
                <primitiveExpression value="null"/>
              </chainedConstructorArgs>
            </constructor>
            <!-- constructor(string, string connectionStringName) -->
            <constructor>
              <attributes public="true"/>
              <parameters>
                <parameter type="System.String" name="procedureName"/>
                <parameter type="System.String" name="connectionStringName"/>
              </parameters>
              <baseConstructorArgs>
                <propertyReferenceExpression name="StoredProcedure">
                  <typeReferenceExpression type="CommandType"/>
                </propertyReferenceExpression>
                <argumentReferenceExpression name="procedureName"/>
                <argumentReferenceExpression name="connectionStringName"/>
              </baseConstructorArgs>
            </constructor>
          </members>
        </typeDeclaration>
        <!-- class SqlText -->
        <typeDeclaration name="SqlText">
          <baseTypes>
            <typeReference type="SqlStatement"/>
          </baseTypes>
          <members>
            <!-- constructor(string) -->
            <constructor>
              <attributes public="true"/>
              <parameters>
                <parameter type="System.String" name="text"/>
              </parameters>
              <chainedConstructorArgs>
                <argumentReferenceExpression name="text"/>
                <primitiveExpression value="null"/>
              </chainedConstructorArgs>
            </constructor>
            <!-- constructor(string, string connectionStringName) -->
            <constructor>
              <attributes public="true"/>
              <parameters>
                <parameter type="System.String" name="text"/>
                <parameter type="System.String" name="connectionStringName"/>
              </parameters>
              <baseConstructorArgs>
                <propertyReferenceExpression name="Text">
                  <typeReferenceExpression type="CommandType"/>
                </propertyReferenceExpression>
                <argumentReferenceExpression name="text"/>
                <argumentReferenceExpression name="connectionStringName"/>
              </baseConstructorArgs>
            </constructor>
            <!--
        public static SqlText Create(string text, params System.Object[] args)
        {
            SqlText sel = new SqlText(text);

            Match m = Regex.Match(text, String.Format("({0}\\w+)", sel.ParameterMarker));
            int parameterIndex = 0;
            while (m.Success)
            {
                sel.AddParameter(m.Value, args[parameterIndex]);
                parameterIndex++;
                m = m.NextMatch();
            }
            return sel;
        }
            -->
            <!-- static method Create(string, params object[]) -->
            <memberMethod returnType="SqlText" name="Create">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="text"/>
                <parameter type="params System.Object[]" name="args"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="SqlText" name="sel">
                  <init>
                    <objectCreateExpression type="SqlText">
                      <parameters>
                        <argumentReferenceExpression name="text"/>
                      </parameters>
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
                        <argumentReferenceExpression name="text"/>
                        <methodInvokeExpression methodName="Format">
                          <target>
                            <typeReferenceExpression type="String"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="({{0}}\w+)"/>
                            <propertyReferenceExpression name="ParameterMarker">
                              <variableReferenceExpression name="sel"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.Int32" name="parameterIndex">
                  <init>
                    <primitiveExpression value="0"/>
                  </init>
                </variableDeclarationStatement>
                <whileStatement>
                  <test>
                    <propertyReferenceExpression name="Success">
                      <variableReferenceExpression name="m"/>
                    </propertyReferenceExpression>
                  </test>
                  <statements>
                    <methodInvokeExpression methodName="AddParameter">
                      <target>
                        <variableReferenceExpression name="sel"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="Value">
                          <variableReferenceExpression name="m"/>
                        </propertyReferenceExpression>
                        <arrayIndexerExpression>
                          <target>
                            <argumentReferenceExpression name="args"/>
                          </target>
                          <indices>
                            <variableReferenceExpression name="parameterIndex"/>
                          </indices>
                        </arrayIndexerExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <assignStatement>
                      <variableReferenceExpression name="parameterIndex"/>
                      <binaryOperatorExpression operator="Add">
                        <variableReferenceExpression name="parameterIndex"/>
                        <primitiveExpression value="1"/>
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
                  <variableReferenceExpression name="sel"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- static method ExecuteScalar(string, params object[]) -->
            <memberMethod returnType="System.Object" name="ExecuteScalar">
              <attributes public="true" static="true" overloaded="true"/>
              <parameters>
                <parameter type="System.String" name="text"/>
                <parameter type="params System.Object[]" name="args"/>
              </parameters>
              <statements>
                <usingStatement>
                  <variable type="SqlText" name="sel">
                    <init>
                      <methodInvokeExpression methodName="Create">
                        <parameters>
                          <argumentReferenceExpression name="text"/>
                          <argumentReferenceExpression name="args"/>
                        </parameters>
                      </methodInvokeExpression>
                    </init>
                  </variable>
                  <statements>
                    <methodReturnStatement>
                      <methodInvokeExpression methodName="ExecuteScalar">
                        <target>
                          <variableReferenceExpression name="sel"/>
                        </target>
                      </methodInvokeExpression>
                    </methodReturnStatement>
                  </statements>
                </usingStatement>
              </statements>
            </memberMethod>
            <!-- static method ExecuteNonQuery(string, params object[]) -->
            <memberMethod returnType="System.Int32" name="ExecuteNonQuery">
              <attributes public="true" static="true" overloaded="true"/>
              <parameters>
                <parameter type="System.String" name="text"/>
                <parameter type="params System.Object[]" name="args"/>
              </parameters>
              <statements>
                <usingStatement>
                  <variable type="SqlText" name="sel">
                    <init>
                      <methodInvokeExpression methodName="Create">
                        <parameters>
                          <argumentReferenceExpression name="text"/>
                          <argumentReferenceExpression name="args"/>
                        </parameters>
                      </methodInvokeExpression>
                    </init>
                  </variable>
                  <statements>
                    <methodReturnStatement>
                      <methodInvokeExpression methodName="ExecuteNonQuery">
                        <target>
                          <variableReferenceExpression name="sel"/>
                        </target>
                      </methodInvokeExpression>
                    </methodReturnStatement>
                  </statements>
                </usingStatement>
              </statements>
            </memberMethod>
            <!-- static method Execute(string, params object[]) -->
            <memberMethod returnType="System.Object[]" name="Execute">
              <attributes public="true" static="true" overloaded="true"/>
              <parameters>
                <parameter type="System.String" name="text"/>
                <parameter type="params System.Object[]" name="args"/>
              </parameters>
              <statements>
                <usingStatement>
                  <variable type="SqlText" name="sel">
                    <init>
                      <methodInvokeExpression methodName="Create">
                        <parameters>
                          <argumentReferenceExpression name="text"/>
                          <argumentReferenceExpression name="args"/>
                        </parameters>
                      </methodInvokeExpression>
                    </init>
                  </variable>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <methodInvokeExpression methodName="Read">
                          <target>
                            <variableReferenceExpression name="sel"/>
                          </target>
                        </methodInvokeExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="System.Object[]" name="result">
                          <init>
                            <arrayCreateExpression>
                              <createType type="System.Object"/>
                              <sizeExpression>
                                <propertyReferenceExpression name="FieldCount">
                                  <propertyReferenceExpression name="Reader">
                                    <variableReferenceExpression name="sel"/>
                                  </propertyReferenceExpression>
                                </propertyReferenceExpression>
                              </sizeExpression>
                            </arrayCreateExpression>
                          </init>
                        </variableDeclarationStatement>
                        <methodInvokeExpression methodName="GetValues">
                          <target>
                            <propertyReferenceExpression name="Reader">
                              <variableReferenceExpression name="sel"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="result"/>
                          </parameters>
                        </methodInvokeExpression>
                        <methodReturnStatement>
                          <variableReferenceExpression name="result"/>
                        </methodReturnStatement>
                      </trueStatements>
                      <falseStatements>
                        <methodReturnStatement>
                          <primitiveExpression value="null"/>
                        </methodReturnStatement>
                      </falseStatements>
                    </conditionStatement>
                  </statements>
                </usingStatement>
              </statements>
            </memberMethod>
            <!-- method NextSequenceValue -->
            <memberMethod returnType="System.Int32" name="NextSequenceValue">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="sequence"/>
              </parameters>
              <statements>
                <tryStatement>
                  <statements>
                    <methodReturnStatement>
                      <methodInvokeExpression methodName="ToInt32">
                        <target>
                          <typeReferenceExpression type="Convert"/>
                        </target>
                        <parameters>
                          <methodInvokeExpression methodName="ExecuteScalar">
                            <target>
                              <typeReferenceExpression type="SqlText"/>
                            </target>
                            <parameters>
                              <methodInvokeExpression methodName="Format">
                                <target>
                                  <typeReferenceExpression type="String"/>
                                </target>
                                <parameters>
                                  <primitiveExpression value="select {{0}}.nextval from dual"/>
                                  <argumentReferenceExpression name="sequence"/>
                                </parameters>
                              </methodInvokeExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </parameters>
                      </methodInvokeExpression>
                    </methodReturnStatement>
                  </statements>
                  <catch exceptionType="Exception">
                    <methodReturnStatement>
                      <primitiveExpression value="0"/>
                    </methodReturnStatement>
                  </catch>
                </tryStatement>
              </statements>
            </memberMethod>
            <!-- method NextGeneratorValue-->
            <memberMethod returnType="System.Int32" name="NextGeneratorValue">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="generator"/>
              </parameters>
              <statements>
                <tryStatement>
                  <statements>
                    <methodReturnStatement>
                      <methodInvokeExpression methodName="ToInt32">
                        <target>
                          <typeReferenceExpression type="Convert"/>
                        </target>
                        <parameters>
                          <methodInvokeExpression methodName="ExecuteScalar">
                            <target>
                              <typeReferenceExpression type="SqlText"/>
                            </target>
                            <parameters>
                              <methodInvokeExpression methodName="Format">
                                <target>
                                  <typeReferenceExpression type="String"/>
                                </target>
                                <parameters>
                                  <primitiveExpression value="SELECT NEXT VALUE FOR {{0}} FROM RDB$DATABASE"/>
                                  <argumentReferenceExpression name="generator"/>
                                </parameters>
                              </methodInvokeExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </parameters>
                      </methodInvokeExpression>
                    </methodReturnStatement>
                  </statements>
                  <catch exceptionType="Exception">
                    <methodReturnStatement>
                      <primitiveExpression value="0"/>
                    </methodReturnStatement>
                  </catch>
                </tryStatement>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
      </types>
    </compileUnit>
  </xsl:template>

  <xsl:template name="DeclareAddValueMethod">
    <xsl:param name="Type"/>
    <xsl:call-template name="DeclareAddValueParameter">
      <xsl:with-param name="Type" select="$Type"/>
    </xsl:call-template>
    <xsl:call-template name="DeclareAddReferenceParameter">
      <xsl:with-param name="Type" select="$Type"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="DeclareAddValueParameter">
    <xsl:param name="Type"/>
    <memberMethod returnType="DbParameter" name="AddParameter">
      <attributes public="true" final="true"/>
      <parameters>
        <parameter type="System.String" name="parameterName"/>
        <parameter type="System.{$Type}" name="value"/>
      </parameters>
      <statements>
        <methodReturnStatement>
          <methodInvokeExpression methodName="AddParameterWithValue">
            <parameters>
              <argumentReferenceExpression name="parameterName"/>
              <argumentReferenceExpression name="value"/>
            </parameters>
          </methodInvokeExpression>
        </methodReturnStatement>
      </statements>
    </memberMethod>
  </xsl:template>

  <xsl:template name="DeclareAddReferenceParameter">
    <xsl:param name="Type"/>
    <memberMethod returnType="DbParameter" name="AddParameter">
      <attributes public="true" final="true"/>
      <parameters>
        <parameter type="System.String" name="parameterName"/>
        <parameter type="Nullable" name="value">
          <typeArguments>
            <typeReference type="System.{$Type}"/>
          </typeArguments>
        </parameter>
      </parameters>
      <statements>
        <conditionStatement>
          <condition>
            <propertyReferenceExpression name="HasValue">
              <variableReferenceExpression name="value"/>
            </propertyReferenceExpression>
          </condition>
          <trueStatements>
            <methodReturnStatement>
              <methodInvokeExpression methodName="AddParameterWithValue">
                <parameters>
                  <argumentReferenceExpression name="parameterName"/>
                  <argumentReferenceExpression name="value"/>
                </parameters>
              </methodInvokeExpression>
            </methodReturnStatement>
          </trueStatements>
          <falseStatements>
            <methodReturnStatement>
              <methodInvokeExpression methodName="AddParameterWithoutValue">
                <parameters>
                  <argumentReferenceExpression name="parameterName"/>
                </parameters>
              </methodInvokeExpression>
            </methodReturnStatement>
          </falseStatements>
        </conditionStatement>
      </statements>
    </memberMethod>
  </xsl:template>

</xsl:stylesheet>
