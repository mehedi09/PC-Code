<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.codeontime.com/2008/codedom-compiler"  xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    xmlns:bo="urn:schemas-codeontime-com:business-objects"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl a bo"
>
  <xsl:param name="Namespace"/>
  <xsl:param name="Host"/>
  <xsl:param name="UseMemoryStream"/>
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/">

    <compileUnit>
      <xsl:attribute name="namespace">
        <xsl:value-of select="$Namespace"/>
        <xsl:if test="$Host='SharePoint'">
          <xsl:text>.WebParts</xsl:text>
        </xsl:if>
        <xsl:text>.Handlers</xsl:text>
      </xsl:attribute>
      <imports>
        <namespaceImport name="System"/>
        <namespaceImport name="System.Collections.Generic"/>
        <namespaceImport name="System.IO"/>
        <namespaceImport name="System.Text"/>
        <namespaceImport name="System.Text.RegularExpressions"/>
        <namespaceImport name="System.Web"/>
        <namespaceImport name="System.Xml"/>
        <namespaceImport name="System.Xml.XPath"/>
        <namespaceImport name="{$Namespace}.Data"/>
      </imports>
      <types>
        <typeDeclaration name="Export">
          <baseTypes>
            <typeReference type="GenericHandlerBase"/>
            <typeReference type="IHttpHandler"/>
            <typeReference type="System.Web.SessionState.IRequiresSessionState"/>
          </baseTypes>
          <members>
            <memberMethod name="ProcessRequest" privateImplementationType="IHttpHandler">
              <attributes/>
              <parameters>
                <parameter type="HttpContext" name="context"/>
              </parameters>
              <statements>
                <xsl:if test="$UseMemoryStream!='true'">
                  <variableDeclarationStatement type="System.String" name="fileName">
                    <init>
                      <primitiveExpression value="null"/>
                    </init>
                  </variableDeclarationStatement>
                </xsl:if>
                <variableDeclarationStatement type="System.String" name="q">
                  <init>
                    <arrayIndexerExpression>
                      <target>
                        <propertyReferenceExpression name="Params">
                          <propertyReferenceExpression name="Request">
                            <argumentReferenceExpression name="context"/>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                      </target>
                      <indices>
                        <primitiveExpression value="q"/>
                      </indices>
                    </arrayIndexerExpression>
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
                          <variableReferenceExpression name="q"/>
                        </parameters>
                      </methodInvokeExpression>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <conditionStatement>
                      <condition>
                        <methodInvokeExpression methodName="Contains">
                          <target>
                            <variableReferenceExpression name="q"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="{{"/>
                          </parameters>
                        </methodInvokeExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="q"/>
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
                                  <variableReferenceExpression name="q"/>
                                </parameters>
                              </methodInvokeExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                        <methodInvokeExpression methodName="Redirect">
                          <target>
                            <propertyReferenceExpression name="Response">
                              <argumentReferenceExpression name="context"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <binaryOperatorExpression operator="Add">
                              <!--<primitiveExpression value="~/Export.ashx?q="/>-->
                              <binaryOperatorExpression operator="Add">
                                <propertyReferenceExpression name="AppRelativeCurrentExecutionFilePath">
                                  <propertyReferenceExpression name="Request">
                                    <argumentReferenceExpression name="context"/>
                                  </propertyReferenceExpression>
                                </propertyReferenceExpression>
                                <primitiveExpression value="?q="/>
                              </binaryOperatorExpression>
                              <methodInvokeExpression methodName="UrlEncode">
                                <target>
                                  <typeReferenceExpression type="HttpUtility"/>
                                </target>
                                <parameters>
                                  <variableReferenceExpression name="q"/>
                                </parameters>
                              </methodInvokeExpression>
                            </binaryOperatorExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                    <assignStatement>
                      <variableReferenceExpression name="q"/>
                      <methodInvokeExpression methodName="GetString">
                        <target>
                          <propertyReferenceExpression name="Default">
                            <typeReferenceExpression type="Encoding"/>
                          </propertyReferenceExpression>
                        </target>
                        <parameters>
                          <methodInvokeExpression methodName="FromBase64String">
                            <target>
                              <typeReferenceExpression type="Convert"/>
                            </target>
                            <parameters>
                              <variableReferenceExpression name="q"/>
                            </parameters>
                          </methodInvokeExpression>
                        </parameters>
                      </methodInvokeExpression>
                    </assignStatement>
                    <comment>
                      <xsl:text>
#pragma warning disable 0618</xsl:text>
                    </comment>
                    <variableDeclarationStatement type="System.Web.Script.Serialization.JavaScriptSerializer" name="serializer">
                      <init>
                        <objectCreateExpression type="System.Web.Script.Serialization.JavaScriptSerializer"/>
                      </init>
                    </variableDeclarationStatement>
                    <comment>
                      <xsl:text>
#pragma warning restore 0618</xsl:text>
                    </comment>
                    <variableDeclarationStatement type="ActionArgs" name="args">
                      <init>
                        <methodInvokeExpression methodName="Deserialize">
                          <typeArguments>
                            <typeReference type="ActionArgs"/>
                          </typeArguments>
                          <target>
                            <variableReferenceExpression name="serializer"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="q"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <comment>execute data export</comment>
                    <variableDeclarationStatement type="IDataController" name="controller">
                      <init>
                        <methodInvokeExpression methodName="CreateDataController">
                          <target>
                            <typeReferenceExpression type="ControllerFactory"/>
                          </target>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <comment>create an Excel Web Query</comment>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanAnd">
                          <binaryOperatorExpression operator="ValueEquality">
                            <propertyReferenceExpression name="CommandName">
                              <variableReferenceExpression name="args"/>
                            </propertyReferenceExpression>
                            <primitiveExpression value="ExportRowset"/>
                          </binaryOperatorExpression>
                          <unaryOperatorExpression operator="Not">
                            <methodInvokeExpression methodName="Contains">
                              <target>
                                <propertyReferenceExpression name="AbsoluteUri">
                                  <propertyReferenceExpression name="Url">
                                    <propertyReferenceExpression name="Request">
                                      <argumentReferenceExpression name="context"/>
                                    </propertyReferenceExpression>
                                  </propertyReferenceExpression>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="&amp;d"/>
                              </parameters>
                            </methodInvokeExpression>
                          </unaryOperatorExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="System.String" name="webQueryUrl">
                          <init>
                            <binaryOperatorExpression operator="Add">
                              <propertyReferenceExpression name="AbsoluteUri">
                                <propertyReferenceExpression name="Url">
                                  <propertyReferenceExpression name="Request">
                                    <argumentReferenceExpression name="context"/>
                                  </propertyReferenceExpression>
                                </propertyReferenceExpression>
                              </propertyReferenceExpression>
                              <primitiveExpression value="&amp;d"/>
                            </binaryOperatorExpression>
                          </init>
                        </variableDeclarationStatement>
                        <methodInvokeExpression methodName="Write">
                          <target>
                            <propertyReferenceExpression name="Response">
                              <argumentReferenceExpression name="context"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <binaryOperatorExpression operator="Add">
                              <primitiveExpression value="Web&#13;&#10;1&#13;&#10;"/>
                              <variableReferenceExpression name="webQueryUrl"/>
                            </binaryOperatorExpression>
                          </parameters>
                        </methodInvokeExpression>
                        <assignStatement>
                          <propertyReferenceExpression name="ContentType">
                            <propertyReferenceExpression name="Response">
                              <argumentReferenceExpression name="context"/>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                          <primitiveExpression value="text/x-ms-iqy"/>
                        </assignStatement>
                        <methodInvokeExpression methodName="AddHeader">
                          <target>
                            <propertyReferenceExpression name="Response">
                              <argumentReferenceExpression name="context"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <primitiveExpression value="Content-Disposition"/>
                            <methodInvokeExpression methodName="Format">
                              <target>
                                <typeReferenceExpression type="String"/>
                              </target>
                              <parameters>
                                <stringFormatExpression format="attachment; filename={{0}}">
                                  <methodInvokeExpression methodName="GenerateOutputFileName">
                                    <parameters>
                                      <variableReferenceExpression name="args"/>
                                      <stringFormatExpression format="{{0}}_{{1}}.iqy">
                                        <propertyReferenceExpression name="Controller">
                                          <variableReferenceExpression name="args"/>
                                        </propertyReferenceExpression>
                                        <propertyReferenceExpression name="View">
                                          <variableReferenceExpression name="args"/>
                                        </propertyReferenceExpression>
                                      </stringFormatExpression>
                                    </parameters>
                                  </methodInvokeExpression>
                                </stringFormatExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </parameters>
                        </methodInvokeExpression>
                        <methodReturnStatement/>
                      </trueStatements>
                    </conditionStatement>
                    <comment>export data in the requested format</comment>
                    <variableDeclarationStatement type="ActionResult" name="result">
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
                    <xsl:choose>
                      <xsl:when test="$UseMemoryStream='true'">
                        <variableDeclarationStatement type="Stream" name="stream">
                          <init>
                            <castExpression targetType="Stream">
                              <propertyReferenceExpression name="Value">
                                <arrayIndexerExpression>
                                  <target>
                                    <propertyReferenceExpression name="Values">
                                      <variableReferenceExpression name="result"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <indices>
                                    <primitiveExpression value="0"/>
                                  </indices>
                                </arrayIndexerExpression>
                              </propertyReferenceExpression>
                            </castExpression>
                          </init>
                        </variableDeclarationStatement>
                      </xsl:when>
                      <xsl:otherwise>
                        <assignStatement>
                          <variableReferenceExpression name="fileName"/>
                          <castExpression targetType="System.String">
                            <propertyReferenceExpression name="Value">
                              <arrayIndexerExpression>
                                <target>
                                  <propertyReferenceExpression name="Values">
                                    <variableReferenceExpression name="result"/>
                                  </propertyReferenceExpression>
                                </target>
                                <indices>
                                  <primitiveExpression value="0"/>
                                </indices>
                              </arrayIndexerExpression>
                            </propertyReferenceExpression>
                          </castExpression>
                        </assignStatement>
                      </xsl:otherwise>
                    </xsl:choose>
                    <comment>send file to output</comment>
                    <conditionStatement>
                      <condition>
                        <xsl:choose>
                          <xsl:when test="$UseMemoryStream='true'">
                            <binaryOperatorExpression operator="IdentityInequality">
                              <variableReferenceExpression name="stream"/>
                              <primitiveExpression value="null"/>
                            </binaryOperatorExpression>
                          </xsl:when>
                          <xsl:otherwise>
                            <methodInvokeExpression methodName="Exists">
                              <target>
                                <typeReferenceExpression type="File"/>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="fileName"/>
                              </parameters>
                            </methodInvokeExpression>
                          </xsl:otherwise>
                        </xsl:choose>
                      </condition>
                      <trueStatements>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="ValueEquality">
                              <propertyReferenceExpression name="CommandName">
                                <variableReferenceExpression name="args"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="ExportCsv"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="ContentType">
                                <propertyReferenceExpression name="Response">
                                  <argumentReferenceExpression name="context"/>
                                </propertyReferenceExpression>
                              </propertyReferenceExpression>
                              <primitiveExpression value="text/csv"/>
                            </assignStatement>
                            <methodInvokeExpression methodName="AddHeader">
                              <target>
                                <propertyReferenceExpression name="Response">
                                  <argumentReferenceExpression name="context"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="Content-Disposition"/>
                                <methodInvokeExpression methodName="Format">
                                  <target>
                                    <typeReferenceExpression type="String"/>
                                  </target>
                                  <parameters>
                                    <stringFormatExpression format="attachment; filename={{0}}">
                                      <methodInvokeExpression methodName="GenerateOutputFileName">
                                        <parameters>
                                          <variableReferenceExpression name="args"/>
                                          <stringFormatExpression format="{{0}}_{{1}}.csv">
                                            <propertyReferenceExpression name="Controller">
                                              <variableReferenceExpression name="args"/>
                                            </propertyReferenceExpression>
                                            <propertyReferenceExpression name="View">
                                              <variableReferenceExpression name="args"/>
                                            </propertyReferenceExpression>
                                          </stringFormatExpression>
                                        </parameters>
                                      </methodInvokeExpression>
                                    </stringFormatExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </parameters>
                            </methodInvokeExpression>
                            <assignStatement>
                              <propertyReferenceExpression name="Charset">
                                <propertyReferenceExpression name="Response">
                                  <argumentReferenceExpression name="context"/>
                                </propertyReferenceExpression>
                              </propertyReferenceExpression>
                              <primitiveExpression value="utf-8"/>
                            </assignStatement>
                            <methodInvokeExpression methodName="Write">
                              <target>
                                <propertyReferenceExpression name="Response">
                                  <argumentReferenceExpression name="context"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <methodInvokeExpression methodName="ToChar">
                                  <target>
                                    <typeReferenceExpression type="Convert"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="65279"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                          <falseStatements>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="ValueEquality">
                                  <propertyReferenceExpression name="CommandName">
                                    <variableReferenceExpression name="args"/>
                                  </propertyReferenceExpression>
                                  <primitiveExpression value="ExportRowset"/>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <propertyReferenceExpression name="ContentType">
                                    <propertyReferenceExpression name="Response">
                                      <argumentReferenceExpression name="context"/>
                                    </propertyReferenceExpression>
                                  </propertyReferenceExpression>
                                  <primitiveExpression value="text/xml"/>
                                </assignStatement>
                              </trueStatements>
                              <falseStatements>
                                <assignStatement>
                                  <propertyReferenceExpression name="ContentType">
                                    <propertyReferenceExpression name="Response">
                                      <argumentReferenceExpression name="context"/>
                                    </propertyReferenceExpression>
                                  </propertyReferenceExpression>
                                  <primitiveExpression value="application/rss+xml"/>
                                </assignStatement>
                              </falseStatements>
                            </conditionStatement>
                          </falseStatements>
                        </conditionStatement>
                        <variableDeclarationStatement type="StreamReader" name="reader">
                          <init>
                            <xsl:choose>
                              <xsl:when test="$UseMemoryStream='true'">
                                <objectCreateExpression type="StreamReader">
                                  <parameters>
                                    <variableReferenceExpression name="stream"/>
                                  </parameters>
                                </objectCreateExpression>
                              </xsl:when>
                              <xsl:otherwise>
                                <methodInvokeExpression methodName="OpenText">
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
                        <whileStatement>
                          <test>
                            <unaryOperatorExpression operator="Not">
                              <propertyReferenceExpression name="EndOfStream">
                                <variableReferenceExpression name="reader"/>
                              </propertyReferenceExpression>
                            </unaryOperatorExpression>
                          </test>
                          <statements>
                            <variableDeclarationStatement type="System.String" name="s">
                              <init>
                                <methodInvokeExpression methodName="ReadLine">
                                  <target>
                                    <variableReferenceExpression name="reader"/>
                                  </target>
                                </methodInvokeExpression>
                              </init>
                            </variableDeclarationStatement>
                            <methodInvokeExpression methodName="WriteLine">
                              <target>
                                <propertyReferenceExpression name="Output">
                                  <propertyReferenceExpression name="Response">
                                    <argumentReferenceExpression name="context"/>
                                  </propertyReferenceExpression>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="s"/>
                              </parameters>
                            </methodInvokeExpression>
                          </statements>
                        </whileStatement>
                        <methodInvokeExpression methodName="Close">
                          <target>
                            <variableReferenceExpression name="reader"/>
                          </target>
                        </methodInvokeExpression>
                        <xsl:if test="$UseMemoryStream!='true'">
                          <methodInvokeExpression methodName="Delete">
                            <target>
                              <typeReferenceExpression type="File"/>
                            </target>
                            <parameters>
                              <variableReferenceExpression name="fileName"/>
                            </parameters>
                          </methodInvokeExpression>
                        </xsl:if>
                      </trueStatements>
                    </conditionStatement>
                  </trueStatements>
                </conditionStatement>
                <xsl:if test="$UseMemoryStream!='true'">
                  <conditionStatement>
                    <condition>
                      <methodInvokeExpression methodName="IsNullOrEmpty">
                        <target>
                          <typeReferenceExpression type="String"/>
                        </target>
                        <parameters>
                          <variableReferenceExpression name="fileName"/>
                        </parameters>
                      </methodInvokeExpression>
                    </condition>
                    <trueStatements>
                      <throwExceptionStatement>
                        <objectCreateExpression type="HttpException">
                          <parameters>
                            <primitiveExpression value="404"/>
                            <propertyReferenceExpression name="Empty">
                              <typeReferenceExpression type="String"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </objectCreateExpression>
                      </throwExceptionStatement>
                    </trueStatements>
                  </conditionStatement>
                </xsl:if>
              </statements>
            </memberMethod>
            <!-- property IsReusable -->
            <memberProperty type="System.Boolean" name="IsReusable" privateImplementationType="IHttpHandler">
              <attributes/>
              <getStatements>
                <methodReturnStatement>
                  <primitiveExpression value="true"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
          </members>
        </typeDeclaration>
      </types>
    </compileUnit>
  </xsl:template>
</xsl:stylesheet>
