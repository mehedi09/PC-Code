﻿<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.codeontime.com/2008/codedom-compiler"  xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    xmlns:da="urn:schemas-codeontime-com:data-aquarium" xmlns:ontime="urn:schemas-codeontime-com:extensions"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl a da ontime"
>
  <xsl:param name="IsPremium"/>
  <xsl:param name="IsUnlimited"/>
  <xsl:param name="Namespace"/>
  <xsl:param name="ProviderName"/>
  <xsl:param name="Host"/>
  <xsl:param name="IsClassLibrary"/>
  <xsl:param name="Mobile" select="'true'"/>

  <xsl:output method="xml" indent="yes"/>

  <msxsl:script language="C#" implements-prefix="ontime">
    <![CDATA[
  public string NormalizeLineEndings(string s) {
    return s.Replace("\n", "\r\n");
  }
  ]]>
  </msxsl:script>

  <xsl:variable name="Quote">
    <xsl:choose>
      <xsl:when test="contains($ProviderName,'MySql')">
        <xsl:text>`</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>"</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

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
        <namespaceImport name="System.Drawing"/>
        <namespaceImport name="System.Drawing.Imaging"/>
        <namespaceImport name="System.IO"/>
        <namespaceImport name="System.Collections.Generic"/>
        <namespaceImport name="System.Net"/>
        <namespaceImport name="System.Text"/>
        <namespaceImport name="System.Text.RegularExpressions"/>
        <namespaceImport name="System.Web"/>
        <namespaceImport name="System.Web.UI"/>
        <namespaceImport name="System.Xml.XPath"/>
        <namespaceImport name="{$Namespace}.Data"/>
        <namespaceImport name="{$Namespace}.Services"/>
      </imports>
      <types>
        <!-- class  BlobFactory -->
        <typeDeclaration name="BlobFactory" isPartial="true">
          <members>
            <typeConstructor>
              <statements>
                <comment>register blob handlers</comment>
                <xsl:variable name="OnDemandFields" select="//da:field[@onDemand='true']"/>
                <!-- previous condition in for-each: not(@onDemandHandler = preceding::da:field/@onDemandHandler)-->
                <xsl:for-each select="$OnDemandFields[not(@readOnly='true') and not(@onDemandHandler = preceding::da:field/@onDemandHandler)]">
                  <xsl:variable name="Object" select="parent::da:fields/parent::da:dataController"/>
                  <xsl:variable name="OnDemandControllers" select="//da:dataController[da:field/@onDemandHandler=current()/@onDemandHandler]"/>
                  <methodInvokeExpression methodName="RegisterHandler">
                    <parameters>
                      <primitiveExpression value="{@onDemandHandler}"/>
                      <xsl:choose>
                        <xsl:when test="$Object/@nativeSchema != ''">
                          <primitiveExpression value="{$Quote}{$Object/@nativeSchema}{$Quote}.{$Quote}{$Object/@nativeTableName}{$Quote}"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <primitiveExpression value="{$Quote}{$Object/@nativeTableName}{$Quote}"/>
                        </xsl:otherwise>
                      </xsl:choose>
                      <primitiveExpression value="{$Quote}{@name}{$Quote}"/>
                      <arrayCreateExpression>
                        <createType type="System.String"/>
                        <initializers>
                          <xsl:for-each select="$Object/da:fields/da:field[@isPrimaryKey='true']">
                            <primitiveExpression value="{$Quote}{@name}{$Quote}"/>
                          </xsl:for-each>
                        </initializers>
                      </arrayCreateExpression>
                      <primitiveExpression value="{$Object/@label} {@label}"/>
                      <!--<xsl:choose>
                        <xsl:when test="@onDemandStyle='Thumbnail'">
                          <propertyReferenceExpression name="Empty">
                            <typeReferenceExpression type="String"/>
                          </propertyReferenceExpression>
                        </xsl:when>
                        <xsl:when test="@nativeDataType='xml'">
                          <primitiveExpression value="text/xml"/>
                        </xsl:when>
                        <xsl:when test="contains(@name, 'Doc')">
                          <primitiveExpression value="application/msword"/>
                        </xsl:when>
                        <xsl:otherwise>
                          <primitiveExpression value="application/octet-stream"/>
                        </xsl:otherwise>
                      </xsl:choose>-->
                      <primitiveExpression value="{$Object/@name}"/>
                      <primitiveExpression value="{@name}"/>
                    </parameters>
                  </methodInvokeExpression>
                </xsl:for-each>
              </statements>
            </typeConstructor>
          </members>
        </typeDeclaration>
        <!-- enum BlobMode -->
        <typeDeclaration name="BlobMode" isEnum="true">
          <members>
            <memberField name="Thumbnail">
              <attributes public="true"/>
            </memberField>
            <memberField name="Original">
              <attributes public="true"/>
            </memberField>
            <memberField name="Upload">
              <attributes public="true"/>
            </memberField>
          </members>
        </typeDeclaration>
        <!-- class BlobHandlerInfo -->
        <typeDeclaration name="BlobHandlerInfo">
          <members>
            <!-- property Key -->
            <memberField type="System.String" name="key"/>
            <memberProperty type="System.String" name="Key">
              <attributes public="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="key"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression  name="key"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property this[string] -->
            <memberProperty type="System.String" name="Item">
              <attributes final="true" family="true"/>
              <parameters>
                <parameter type="System.String" name="name"/>
              </parameters>
              <getStatements>
                <methodReturnStatement>
                  <castExpression targetType="System.String">
                    <arrayIndexerExpression>
                      <target>
                        <propertyReferenceExpression name="Items">
                          <propertyReferenceExpression name="Current">
                            <typeReferenceExpression type="HttpContext"/>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                      </target>
                      <indices>
                        <binaryOperatorExpression operator="Add">
                          <primitiveExpression value="BlobHandlerInfo_"/>
                          <argumentReferenceExpression name="name"/>
                        </binaryOperatorExpression>
                      </indices>
                    </arrayIndexerExpression>
                  </castExpression>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
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
                      <binaryOperatorExpression operator="Add">
                        <primitiveExpression value="BlobHandlerInfo_"/>
                        <argumentReferenceExpression name="name"/>
                      </binaryOperatorExpression>
                    </indices>
                  </arrayIndexerExpression>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property TableName -->
            <memberField type="System.String" name="tableName"/>
            <memberProperty type="System.String" name="TableName">
              <attributes public="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="tableName"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="tableName"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property FieldName-->
            <memberField type="System.String" name="fieldName"/>
            <memberProperty type="System.String" name="FieldName">
              <attributes public="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="fieldName"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="fieldName"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property KeyFieldNames -->
            <memberField type="System.String[]" name="keyFieldNames"/>
            <memberProperty type="System.String[]" name="KeyFieldNames">
              <attributes public="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="keyFieldNames"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="keyFieldNames"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property Text -->
            <memberField type="System.String" name="text"/>
            <memberProperty type="System.String" name="Text">
              <attributes public="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="text"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="text"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property Error -->
            <memberProperty type="System.String" name="Error">
              <attributes public="true"/>
              <getStatements>
                <methodReturnStatement>
                  <arrayIndexerExpression>
                    <target>
                      <thisReferenceExpression/>
                    </target>
                    <indices>
                      <primitiveExpression value="Error"/>
                    </indices>
                  </arrayIndexerExpression>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <arrayIndexerExpression>
                    <target>
                      <thisReferenceExpression/>
                    </target>
                    <indices>
                      <primitiveExpression value="Error"/>
                    </indices>
                  </arrayIndexerExpression>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property FileName -->
            <memberProperty type="System.String" name="FileName">
              <attributes public="true"/>
              <getStatements>
                <methodReturnStatement>
                  <arrayIndexerExpression>
                    <target>
                      <thisReferenceExpression/>
                    </target>
                    <indices>
                      <primitiveExpression value="FileName"/>
                    </indices>
                  </arrayIndexerExpression>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <arrayIndexerExpression>
                    <target>
                      <thisReferenceExpression/>
                    </target>
                    <indices>
                      <primitiveExpression value="FileName"/>
                    </indices>
                  </arrayIndexerExpression>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- ContentType-->
            <memberField type="System.String" name="contentType"/>
            <memberProperty type="System.String" name="ContentType">
              <attributes public="true"/>
              <getStatements>
                <variableDeclarationStatement type="System.String" name="s">
                  <init>
                    <arrayIndexerExpression>
                      <target>
                        <thisReferenceExpression/>
                      </target>
                      <indices>
                        <primitiveExpression value="ContentType"/>
                      </indices>
                    </arrayIndexerExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="IsNullOrEmpty">
                      <variableReferenceExpression name="s"/>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="s"/>
                      <fieldReferenceExpression name="contentType">
                        <thisReferenceExpression/>
                      </fieldReferenceExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <variableReferenceExpression name="s"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <arrayIndexerExpression>
                    <target>
                      <thisReferenceExpression/>
                    </target>
                    <indices>
                      <primitiveExpression value="ContentType"/>
                    </indices>
                  </arrayIndexerExpression>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property DataController-->
            <memberField type="System.String" name="dataController"/>
            <memberProperty type="System.String" name="DataController">
              <attributes public="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="dataController"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="dataController"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property UploadDownloadViewName -->
            <memberProperty type="System.String" name="UploadDownloadViewName">
              <attributes public="true"/>
              <getStatements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="GetUpdateView">
                    <target>
                      <typeReferenceExpression type="Controller"/>
                    </target>
                    <parameters>
                      <propertyReferenceExpression name="DataController"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property ControllerFieldName-->
            <memberField type="System.String" name="controllerFieldName"/>
            <memberProperty type="System.String" name="ControllerFieldName">
              <attributes public="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="controllerFieldName"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="controllerFieldName"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property Current -->
            <memberProperty type="BlobHandlerInfo" name="Current">
              <attributes public="true" static="true"/>
              <getStatements>
                <variableDeclarationStatement type="BlobHandlerInfo" name="d">
                  <init>
                    <castExpression targetType="BlobHandlerInfo">
                      <arrayIndexerExpression>
                        <target>
                          <propertyReferenceExpression name="Items">
                            <propertyReferenceExpression name="Current">
                              <typeReferenceExpression type="HttpContext"/>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                        </target>
                        <indices>
                          <primitiveExpression value="BlobHandler_Current"/>
                        </indices>
                      </arrayIndexerExpression>
                    </castExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <variableReferenceExpression name="d"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <foreachStatement>
                      <variable type="System.String" name="key"/>
                      <target>
                        <propertyReferenceExpression name="Keys">
                          <propertyReferenceExpression name="QueryString">
                            <propertyReferenceExpression name="Request">
                              <propertyReferenceExpression name="Current">
                                <typeReferenceExpression type="HttpContext"/>
                              </propertyReferenceExpression>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                      </target>
                      <statements>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="BooleanAnd">
                              <unaryOperatorExpression operator="IsNotNullOrEmpty">
                                <variableReferenceExpression name="key"/>
                              </unaryOperatorExpression>
                              <methodInvokeExpression methodName="ContainsKey">
                                <target>
                                  <propertyReferenceExpression name="Handlers">
                                    <typeReferenceExpression type="BlobFactory"/>
                                  </propertyReferenceExpression>
                                </target>
                                <parameters>
                                  <variableReferenceExpression name="key"/>
                                </parameters>
                              </methodInvokeExpression>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="d"/>
                              <arrayIndexerExpression>
                                <target>
                                  <propertyReferenceExpression name="Handlers">
                                    <typeReferenceExpression type="BlobFactory"/>
                                  </propertyReferenceExpression>
                                </target>
                                <indices>
                                  <variableReferenceExpression name="key"/>
                                </indices>
                              </arrayIndexerExpression>
                            </assignStatement>
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
                                  <primitiveExpression value="BlobHandler_Current"/>
                                </indices>
                              </arrayIndexerExpression>
                              <variableReferenceExpression name="d"/>
                            </assignStatement>
                            <breakStatement/>
                          </trueStatements>
                        </conditionStatement>
                      </statements>
                    </foreachStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <variableReferenceExpression name="d"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property Mode -->
            <memberProperty type="BlobMode" name="Mode">
              <attributes public="true" final="true"/>
              <getStatements>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="StartsWith">
                      <target>
                        <propertyReferenceExpression name="Value"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="u|"/>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <propertyReferenceExpression name="Upload">
                        <typeReferenceExpression type="BlobMode"/>
                      </propertyReferenceExpression>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="StartsWith">
                      <target>
                        <propertyReferenceExpression name="Value"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="t|"/>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <propertyReferenceExpression name="Thumbnail">
                        <typeReferenceExpression type="BlobMode"/>
                      </propertyReferenceExpression>
                    </methodReturnStatement>
                  </trueStatements>
                  <falseStatements>
                    <methodReturnStatement>
                      <propertyReferenceExpression name="Original">
                        <typeReferenceExpression type="BlobMode"/>
                      </propertyReferenceExpression>
                    </methodReturnStatement>
                  </falseStatements>
                </conditionStatement>
              </getStatements>
            </memberProperty>
            <!-- property Value -->
            <memberProperty type="System.String" name="Value">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <arrayIndexerExpression>
                    <target>
                      <propertyReferenceExpression name="QueryString">
                        <propertyReferenceExpression name="Request">
                          <propertyReferenceExpression name="Current">
                            <typeReferenceExpression type="HttpContext"/>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                      </propertyReferenceExpression>
                    </target>
                    <indices>
                      <propertyReferenceExpression name="Key"/>
                    </indices>
                  </arrayIndexerExpression>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property Reference-->
            <memberProperty type="System.String" name="Reference">
              <attributes public="true" final="true"/>
              <getStatements>
                <variableDeclarationStatement type="System.String" name="s">
                  <init>
                    <methodInvokeExpression methodName="Replace">
                      <target>
                        <propertyReferenceExpression name="Value"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="|"/>
                        <primitiveExpression value="_"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="Substring">
                    <target>
                      <variableReferenceExpression name="s"/>
                    </target>
                    <parameters>
                      <primitiveExpression value="1"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- constructor BlobHandlerInfo() -->
            <constructor>
              <attributes public="true"/>
            </constructor>
            <!-- constructor BlobHandlerInfo(string, string, string, string[], string, string)  -->
            <constructor>
              <attributes public="true"/>
              <parameters>
                <parameter type="System.String" name="key"/>
                <parameter type="System.String" name="tableName"/>
                <parameter type="System.String" name="fieldName"/>
                <parameter type="System.String[]" name="keyFieldNames"/>
                <parameter type="System.String" name="text"/>
                <parameter type="System.String" name="contentType"/>
              </parameters>
              <chainedConstructorArgs>
                <argumentReferenceExpression name="key"/>
                <argumentReferenceExpression name="tableName"/>
                <argumentReferenceExpression name="fieldName"/>
                <argumentReferenceExpression name="keyFieldNames"/>
                <argumentReferenceExpression name="text"/>
                <argumentReferenceExpression name="contentType"/>
                <propertyReferenceExpression name="Empty">
                  <typeReferenceExpression type="String"/>
                </propertyReferenceExpression>
                <propertyReferenceExpression name="Empty">
                  <typeReferenceExpression type="String"/>
                </propertyReferenceExpression>
              </chainedConstructorArgs>
              <statements/>
            </constructor>
            <!-- constructor BlobHandlerInfo(string, string, string, string[], string, string, string, string)  -->
            <constructor>
              <attributes public="true"/>
              <parameters>
                <parameter type="System.String" name="key"/>
                <parameter type="System.String" name="tableName"/>
                <parameter type="System.String" name="fieldName"/>
                <parameter type="System.String[]" name="keyFieldNames"/>
                <parameter type="System.String" name="text"/>
                <parameter type="System.String" name="contentType"/>
                <parameter type="System.String" name="dataController"/>
                <parameter type="System.String" name="controllerFieldName"/>
              </parameters>
              <statements>
                <assignStatement>
                  <propertyReferenceExpression name="Key">
                    <thisReferenceExpression/>
                  </propertyReferenceExpression>
                  <argumentReferenceExpression name="key"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="TableName">
                    <thisReferenceExpression/>
                  </propertyReferenceExpression>
                  <argumentReferenceExpression name="tableName"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="FieldName">
                    <thisReferenceExpression/>
                  </propertyReferenceExpression>
                  <argumentReferenceExpression name="fieldName"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="KeyFieldNames">
                    <thisReferenceExpression/>
                  </propertyReferenceExpression>
                  <argumentReferenceExpression name="keyFieldNames"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Text">
                    <thisReferenceExpression/>
                  </propertyReferenceExpression>
                  <argumentReferenceExpression name="text"/>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="ContentType">
                    <thisReferenceExpression/>
                  </fieldReferenceExpression>
                  <argumentReferenceExpression name="contentType"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="DataController">
                    <thisReferenceExpression/>
                  </propertyReferenceExpression>
                  <argumentReferenceExpression name="dataController"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="ControllerFieldName">
                    <thisReferenceExpression/>
                  </propertyReferenceExpression>
                  <argumentReferenceExpression name="controllerFieldName"/>
                </assignStatement>
              </statements>
            </constructor>
            <!-- method SaveFile(HttpContext)-->
            <memberMethod returnType="System.Boolean" name="SaveFile">
              <attributes public="true"/>
              <parameters>
                <parameter type="HttpContext" name="context"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="SaveFile">
                    <target>
                      <thisReferenceExpression/>
                    </target>
                    <parameters>
                      <variableReferenceExpression name="context"/>
                      <primitiveExpression value="null"/>
                      <primitiveExpression value="null"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method SaveFile(HttpContext, BlobAdapter, string)-->
            <memberMethod returnType="System.Boolean" name="SaveFile">
              <attributes public="true"/>
              <parameters>
                <parameter type="HttpContext" name="context"/>
                <parameter type="BlobAdapter" name="ba"/>
                <parameter type="System.String" name="keyValue"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueInequality">
                      <propertyReferenceExpression name="Count">
                        <propertyReferenceExpression name="Files">
                          <propertyReferenceExpression name="Request">
                            <argumentReferenceExpression name="context"/>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                      </propertyReferenceExpression>
                      <primitiveExpression value="1"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="false"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <!--<variableDeclarationStatement type="HttpPostedFile" name="file">
                  <init>
                    <arrayIndexerExpression>
                      <target>
                        <propertyReferenceExpression name="Files">
                          <propertyReferenceExpression name="Request">
                            <argumentReferenceExpression name="context"/>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                      </target>
                      <indices>
                        <primitiveExpression value="0"/>
                      </indices>
                    </arrayIndexerExpression>
                  </init>
                </variableDeclarationStatement>-->
                <!--<conditionStatement>
									<condition>
										<binaryOperatorExpression operator="ValueEquality">
											<propertyReferenceExpression name="ContentLength">
												<variableReferenceExpression name="file"/>
											</propertyReferenceExpression>
											<primitiveExpression value="0"/>
										</binaryOperatorExpression>
									</condition>
									<trueStatements>
										<methodReturnStatement>
											<primitiveExpression value="false"/>
										</methodReturnStatement>
									</trueStatements>
								</conditionStatement>-->
                <tryStatement>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanAnd">
                          <binaryOperatorExpression operator="IdentityInequality">
                            <propertyReferenceExpression name="Current">
                              <typeReferenceExpression type="BlobHandlerInfo"/>
                            </propertyReferenceExpression>
                            <primitiveExpression value="null"/>
                          </binaryOperatorExpression>
                          <methodInvokeExpression methodName="ProcessUploadViaBusinessRule">
                            <target>
                              <propertyReferenceExpression name="Current">
                                <typeReferenceExpression type="BlobHandlerInfo"/>
                              </propertyReferenceExpression>
                            </target>
                            <parameters>
                              <argumentReferenceExpression name="ba"/>
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
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityEquality">
                          <argumentReferenceExpression name="ba"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <usingStatement>
                          <variable type="SqlStatement" name="updateBlob">
                            <init>
                              <methodInvokeExpression methodName="CreateBlobUpdateStatement">
                                <target>
                                  <typeReferenceExpression type="BlobFactory"/>
                                </target>
                              </methodInvokeExpression>
                            </init>
                          </variable>
                          <statements>
                            <methodReturnStatement>
                              <binaryOperatorExpression operator="ValueEquality">
                                <methodInvokeExpression methodName="ExecuteNonQuery">
                                  <target>
                                    <variableReferenceExpression name="updateBlob"/>
                                  </target>
                                </methodInvokeExpression>
                                <primitiveExpression value="1"/>
                              </binaryOperatorExpression>
                            </methodReturnStatement>
                          </statements>
                        </usingStatement>
                      </trueStatements>
                      <falseStatements>
                        <variableDeclarationStatement type="HttpPostedFile" name="file">
                          <init>
                            <arrayIndexerExpression>
                              <target>
                                <propertyReferenceExpression name="Files">
                                  <propertyReferenceExpression name="Request">
                                    <argumentReferenceExpression name="context"/>
                                  </propertyReferenceExpression>
                                </propertyReferenceExpression>
                              </target>
                              <indices>
                                <primitiveExpression value="0"/>
                              </indices>
                            </arrayIndexerExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <methodInvokeExpression methodName="Equals">
                              <target>
                                <propertyReferenceExpression name="ContentLength">
                                  <variableReferenceExpression name="file"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="0"/>
                              </parameters>
                            </methodInvokeExpression>
                          </condition>
                          <trueStatements>
                            <methodReturnStatement>
                              <primitiveExpression value="true"/>
                            </methodReturnStatement>
                          </trueStatements>
                        </conditionStatement>
                        <methodReturnStatement>
                          <methodInvokeExpression methodName="WriteBlob">
                            <target>
                              <argumentReferenceExpression name="ba"/>
                            </target>
                            <parameters>
                              <variableReferenceExpression name="file"/>
                              <argumentReferenceExpression name="keyValue"/>
                            </parameters>
                          </methodInvokeExpression>
                        </methodReturnStatement>
                      </falseStatements>
                    </conditionStatement>

                  </statements>
                  <catch exceptionType="Exception" localName="err">
                    <assignStatement>
                      <propertyReferenceExpression name="Error"/>
                      <propertyReferenceExpression name="Message">
                        <variableReferenceExpression name="err"/>
                      </propertyReferenceExpression>
                    </assignStatement>
                    <methodReturnStatement>
                      <primitiveExpression value="false"/>
                    </methodReturnStatement>
                  </catch>
                </tryStatement>
              </statements>
            </memberMethod>
            <!-- method CreateKeyValues() -->
            <memberMethod returnType="List" name="CreateKeyValues">
              <typeArguments>
                <typeReference type="System.String"/>
              </typeArguments>
              <attributes public="true" final="true"/>
              <statements>
                <variableDeclarationStatement type="List" name="keyValues">
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
                        <propertyReferenceExpression name="Value"/>
                        <primitiveExpression value="\|([\w-]+)"/>
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
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <variableReferenceExpression name="keyValues"/>
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
                  <variableReferenceExpression name="keyValues"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- CreateActionValues(Stream, string, string, int) -->
            <memberMethod returnType="List" name="CreateActionValues">
              <typeArguments>
                <typeReference type="FieldValue"/>
              </typeArguments>
              <attributes private="true" final="true"/>
              <parameters>
                <parameter type="Stream" name="stream"/>
                <parameter type="System.String" name="contentType"/>
                <parameter type="System.String" name="fileName"/>
                <parameter type="System.Int32" name="contentLength"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.Boolean" name="deleting">
                  <init>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <binaryOperatorExpression operator="BooleanAnd">
                        <binaryOperatorExpression operator="ValueEquality">
                          <argumentReferenceExpression name="contentType"/>
                          <primitiveExpression value="application/octet-stream"/>
                        </binaryOperatorExpression>
                        <binaryOperatorExpression operator="ValueEquality">
                          <argumentReferenceExpression name="contentLength"/>
                          <primitiveExpression value="0"/>
                        </binaryOperatorExpression>
                      </binaryOperatorExpression>
                      <unaryOperatorExpression operator="IsNullOrEmpty">
                        <argumentReferenceExpression name="fileName"/>
                      </unaryOperatorExpression>
                    </binaryOperatorExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="List" name="keyValues">
                  <typeArguments>
                    <typeReference type="System.String"/>
                  </typeArguments>
                  <init>
                    <methodInvokeExpression methodName="CreateKeyValues"/>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.Int32" name="keyValueIndex">
                  <init>
                    <primitiveExpression value="0"/>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="List" name="actionValues">
                  <typeArguments>
                    <typeReference type="FieldValue"/>
                  </typeArguments>
                  <init>
                    <objectCreateExpression type="List">
                      <typeArguments>
                        <typeReference type="FieldValue"/>
                      </typeArguments>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="ControllerConfiguration" name="config">
                  <init>
                    <methodInvokeExpression methodName="CreateConfigurationInstance">
                      <target>
                        <typeReferenceExpression type="Controller"/>
                      </target>
                      <parameters>
                        <typeofExpression type="Controller"/>
                        <propertyReferenceExpression name="DataController"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="XPathNodeIterator" name="keyFieldIterator">
                  <init>
                    <methodInvokeExpression methodName="Select">
                      <target>
                        <variableReferenceExpression name="config"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="/c:dataController/c:fields/c:field[@isPrimaryKey='true']"/>
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
                    <variableDeclarationStatement type="FieldValue" name="v">
                      <init>
                        <objectCreateExpression type="FieldValue">
                          <parameters>
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
                          </parameters>
                        </objectCreateExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="LessThan">
                          <variableReferenceExpression name="keyValueIndex"/>
                          <propertyReferenceExpression name="Count">
                            <variableReferenceExpression name="keyValues"/>
                          </propertyReferenceExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <propertyReferenceExpression name="OldValue">
                            <variableReferenceExpression name="v"/>
                          </propertyReferenceExpression>
                          <arrayIndexerExpression>
                            <target>
                              <variableReferenceExpression name="keyValues"/>
                            </target>
                            <indices>
                              <variableReferenceExpression name="keyValueIndex"/>
                            </indices>
                          </arrayIndexerExpression>
                        </assignStatement>
                        <assignStatement>
                          <propertyReferenceExpression name="Modified">
                            <variableReferenceExpression name="v"/>
                          </propertyReferenceExpression>
                          <primitiveExpression value="false"/>
                        </assignStatement>
                        <assignStatement>
                          <variableReferenceExpression name="keyValueIndex"/>
                          <binaryOperatorExpression operator="Add">
                            <variableReferenceExpression name="keyValueIndex"/>
                            <primitiveExpression value="1"/>
                          </binaryOperatorExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <variableReferenceExpression name="actionValues"/>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="v"/>
                      </parameters>
                    </methodInvokeExpression>
                  </statements>
                </whileStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <argumentReferenceExpression name="stream"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="XPathNavigator" name="lengthField">
                      <init>
                        <methodInvokeExpression methodName="SelectSingleNode">
                          <target>
                            <variableReferenceExpression name="config"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="/c:dataController/c:fields/c:field[@name='{{0}}']"/>
                            <propertyReferenceExpression name="LengthField">
                              <thisReferenceExpression/>
                            </propertyReferenceExpression>

                            <!--<methodInvokeExpression methodName="Format">
                              <target>
                                <typeReferenceExpression type="String"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="/c:dataController/c:fields/c:field[@name='{{0}}Length']"/>
                                <propertyReferenceExpression name="ControllerFieldName"/>
                              </parameters>
                            </methodInvokeExpression>
                            <propertyReferenceExpression name="Resolver">
                              <variableReferenceExpression name="config"/>
                            </propertyReferenceExpression>-->
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityEquality">
                          <variableReferenceExpression name="lengthField"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="lengthField"/>
                          <methodInvokeExpression methodName="SelectSingleNode">
                            <target>
                              <variableReferenceExpression name="config"/>
                            </target>
                            <parameters>
                              <primitiveExpression value="/c:dataController/c:fields/c:field[@name='{{0}}Length' or @name='{{0}}LENGTH']"/>
                              <propertyReferenceExpression name="ControllerFieldName"/>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityInequality">
                          <variableReferenceExpression name="lengthField"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <variableReferenceExpression name="actionValues"/>
                          </target>
                          <parameters>
                            <objectCreateExpression type="FieldValue">
                              <parameters>
                                <methodInvokeExpression methodName="GetAttribute">
                                  <target>
                                    <variableReferenceExpression name="lengthField"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="name"/>
                                    <propertyReferenceExpression name="Empty">
                                      <typeReferenceExpression type="String"/>
                                    </propertyReferenceExpression>
                                  </parameters>
                                </methodInvokeExpression>
                                <variableReferenceExpression name="contentLength"/>
                              </parameters>
                            </objectCreateExpression>
                          </parameters>
                        </methodInvokeExpression>
                        <conditionStatement>
                          <condition>
                            <variableReferenceExpression name="deleting"/>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="ClearLastFieldValue">
                              <parameters>
                                <variableReferenceExpression name="actionValues"/>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
                    <variableDeclarationStatement type="XPathNavigator" name="contentTypeField">
                      <init>
                        <methodInvokeExpression methodName="SelectSingleNode">
                          <target>
                            <variableReferenceExpression name="config"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="/c:dataController/c:fields/c:field[@name='{{0}}']"/>
                            <propertyReferenceExpression name="ContentTypeField">
                              <thisReferenceExpression/>
                            </propertyReferenceExpression>
                            <!--<methodInvokeExpression methodName="Format">
                              <target>
                                <typeReferenceExpression type="String"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="/c:dataController/c:fields/c:field[@name='{{0}}ContentType']"/>
                                <propertyReferenceExpression name="ControllerFieldName"/>
                              </parameters>
                            </methodInvokeExpression>
                            <propertyReferenceExpression name="Resolver">
                              <variableReferenceExpression name="config"/>
                            </propertyReferenceExpression>-->
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityEquality">
                          <propertyReferenceExpression name="ContentTypeField"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="contentTypeField"/>
                          <methodInvokeExpression methodName="SelectSingleNode">
                            <target>
                              <variableReferenceExpression name="config"/>
                            </target>
                            <parameters>
                              <primitiveExpression value="/c:dataController/c:fields/c:field[@name='{{0}}ContentType' or @name='{{0}}CONTENTTYPE']"/>
                              <propertyReferenceExpression name="ControllerFieldName"/>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityInequality">
                          <variableReferenceExpression name="contentTypeField"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <variableReferenceExpression name="actionValues"/>
                          </target>
                          <parameters>
                            <objectCreateExpression type="FieldValue">
                              <parameters>
                                <methodInvokeExpression methodName="GetAttribute">
                                  <target>
                                    <variableReferenceExpression name="contentTypeField"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="name"/>
                                    <propertyReferenceExpression name="Empty">
                                      <typeReferenceExpression type="String"/>
                                    </propertyReferenceExpression>
                                  </parameters>
                                </methodInvokeExpression>
                                <variableReferenceExpression name="contentType"/>
                              </parameters>
                            </objectCreateExpression>
                          </parameters>
                        </methodInvokeExpression>
                        <conditionStatement>
                          <condition>
                            <variableReferenceExpression name="deleting"/>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="ClearLastFieldValue">
                              <parameters>
                                <variableReferenceExpression name="actionValues"/>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
                    <variableDeclarationStatement type="XPathNavigator" name="fileNameField">
                      <init>
                        <methodInvokeExpression methodName="SelectSingleNode">
                          <target>
                            <variableReferenceExpression name="config"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="/c:dataController/c:fields/c:field[@name='{{0}}']"/>
                            <propertyReferenceExpression name="FileNameField">
                              <thisReferenceExpression/>
                            </propertyReferenceExpression>
                            <!--<methodInvokeExpression methodName="Format">
                              <target>
                                <typeReferenceExpression type="String"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="/c:dataController/c:fields/c:field[@name='{{0}}FileName']"/>
                                <propertyReferenceExpression name="ControllerFieldName"/>
                              </parameters>
                            </methodInvokeExpression>
                            <propertyReferenceExpression name="Resolver">
                              <variableReferenceExpression name="config"/>
                            </propertyReferenceExpression>-->
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityEquality">
                          <propertyReferenceExpression name="fileNameField"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="fileNameField"/>
                          <methodInvokeExpression methodName="SelectSingleNode">
                            <target>
                              <variableReferenceExpression name="config"/>
                            </target>
                            <parameters>
                              <primitiveExpression value="/c:dataController/c:fields/c:field[@name='{{0}}FileName' or @name='{{0}}FILENAME']"/>
                              <propertyReferenceExpression name="ControllerFieldName"/>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityInequality">
                          <variableReferenceExpression name="fileNameField"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <variableReferenceExpression name="actionValues"/>
                          </target>
                          <parameters>
                            <objectCreateExpression type="FieldValue">
                              <parameters>
                                <methodInvokeExpression methodName="GetAttribute">
                                  <target>
                                    <variableReferenceExpression name="fileNameField"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="name"/>
                                    <propertyReferenceExpression name="Empty">
                                      <typeReferenceExpression type="String"/>
                                    </propertyReferenceExpression>
                                  </parameters>
                                </methodInvokeExpression>
                                <methodInvokeExpression methodName="GetFileName">
                                  <target>
                                    <typeReferenceExpression type="Path"/>
                                  </target>
                                  <parameters>
                                    <argumentReferenceExpression name="fileName"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </parameters>
                            </objectCreateExpression>
                          </parameters>
                        </methodInvokeExpression>
                        <conditionStatement>
                          <condition>
                            <variableReferenceExpression name="deleting"/>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="ClearLastFieldValue">
                              <parameters>
                                <variableReferenceExpression name="actionValues"/>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <variableReferenceExpression name="actionValues"/>
                      </target>
                      <parameters>
                        <objectCreateExpression type="FieldValue">
                          <parameters>
                            <propertyReferenceExpression name="ControllerFieldName"/>
                            <argumentReferenceExpression name="stream"/>
                          </parameters>
                        </objectCreateExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <variableReferenceExpression name="actionValues"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method ClearLastFieldValue(List<FieldValue>) -->
            <memberMethod name="ClearLastFieldValue">
              <attributes private="true"/>
              <parameters>
                <parameter type="List" name="values">
                  <typeArguments>
                    <typeReference type="FieldValue"/>
                  </typeArguments>
                </parameter>
              </parameters>
              <statements>
                <variableDeclarationStatement type="FieldValue" name="v">
                  <init>
                    <arrayIndexerExpression>
                      <target>
                        <argumentReferenceExpression name="values"/>
                      </target>
                      <indices>
                        <binaryOperatorExpression operator="Subtract">
                          <propertyReferenceExpression name="Count">
                            <argumentReferenceExpression name="values"/>
                          </propertyReferenceExpression>
                          <primitiveExpression value="1"/>
                        </binaryOperatorExpression>
                      </indices>
                    </arrayIndexerExpression>
                  </init>
                </variableDeclarationStatement>
                <assignStatement>
                  <propertyReferenceExpression name="NewValue">
                    <variableReferenceExpression name="v"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="null"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Modified">
                    <variableReferenceExpression name="v"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="true"/>
                </assignStatement>
              </statements>
            </memberMethod>
            <!-- method ProcessUploadViaBusinessRule(BlobAdapter) -->
            <memberMethod returnType="System.Boolean" name="ProcessUploadViaBusinessRule">
              <attributes private="true" final="true"/>
              <parameters>
                <parameter type="BlobAdapter" name="ba"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="HttpPostedFile" name="file">
                  <init>
                    <arrayIndexerExpression>
                      <target>
                        <propertyReferenceExpression name="Files">
                          <propertyReferenceExpression name="Request">
                            <propertyReferenceExpression name="Current">
                              <typeReferenceExpression type="HttpContext"/>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                      </target>
                      <indices>
                        <primitiveExpression value="0"/>
                      </indices>
                    </arrayIndexerExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="List" name="actionValues">
                  <typeArguments>
                    <typeReference type="FieldValue"/>
                  </typeArguments>
                  <init>
                    <methodInvokeExpression methodName="CreateActionValues">
                      <parameters>
                        <propertyReferenceExpression name="InputStream">
                          <variableReferenceExpression name="file"/>
                        </propertyReferenceExpression>
                        <propertyReferenceExpression name="ContentType">
                          <variableReferenceExpression name="file"/>
                        </propertyReferenceExpression>
                        <propertyReferenceExpression name="FileName">
                          <variableReferenceExpression name="file"/>
                        </propertyReferenceExpression>
                        <propertyReferenceExpression name="ContentLength">
                          <variableReferenceExpression name="file"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <argumentReferenceExpression name="ba"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <foreachStatement>
                      <variable type="FieldValue" name="fv"/>
                      <target>
                        <variableReferenceExpression name="actionValues"/>
                      </target>
                      <statements>
                        <methodInvokeExpression methodName="ValidateFieldValue">
                          <target>
                            <argumentReferenceExpression name="ba"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="fv"/>
                          </parameters>
                        </methodInvokeExpression>
                      </statements>
                    </foreachStatement>
                  </trueStatements>
                </conditionStatement>
                <comment>try process uploading via a business rule</comment>
                <variableDeclarationStatement type="ActionArgs" name="args">
                  <init>
                    <objectCreateExpression type="ActionArgs"/>
                  </init>
                </variableDeclarationStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Controller">
                    <variableReferenceExpression name="args"/>
                  </propertyReferenceExpression>
                  <propertyReferenceExpression name="DataController"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="CommandName">
                    <variableReferenceExpression name="args"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="UploadFile"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="CommandArgument">
                    <variableReferenceExpression name="args"/>
                  </propertyReferenceExpression>
                  <propertyReferenceExpression name="ControllerFieldName"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Values">
                    <variableReferenceExpression name="args"/>
                  </propertyReferenceExpression>
                  <methodInvokeExpression methodName="ToArray">
                    <target>
                      <variableReferenceExpression name="actionValues"/>
                    </target>
                  </methodInvokeExpression>
                </assignStatement>
                <variableDeclarationStatement type="ActionResult" name="r">
                  <init>
                    <methodInvokeExpression methodName="Execute">
                      <target>
                        <methodInvokeExpression methodName="CreateDataController">
                          <target>
                            <typeReferenceExpression type="ControllerFactory"/>
                          </target>
                        </methodInvokeExpression>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="DataController"/>
                        <variableReferenceExpression name="UploadDownloadViewName"/>
                        <variableReferenceExpression name="args"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.Boolean" name="supportsContentType">
                  <init>
                    <primitiveExpression value="false"/>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.Boolean" name="supportsFileName">
                  <init>
                    <primitiveExpression value="false"/>
                  </init>
                </variableDeclarationStatement>
                <methodInvokeExpression methodName="DetectSupportForSpecialFields">
                  <parameters>
                    <variableReferenceExpression name="actionValues"/>
                    <directionExpression direction="Out">
                      <variableReferenceExpression name="supportsContentType"/>
                    </directionExpression>
                    <directionExpression direction="Out">
                      <variableReferenceExpression name="supportsFileName"/>
                    </directionExpression>
                  </parameters>
                </methodInvokeExpression>
                <variableDeclarationStatement type="System.Boolean" name="canceled">
                  <init>
                    <propertyReferenceExpression name="Canceled">
                      <variableReferenceExpression name="r"/>
                    </propertyReferenceExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <variableReferenceExpression name="canceled"/>
                      <unaryOperatorExpression operator="Not">
                        <binaryOperatorExpression operator="BooleanOr">
                          <variableReferenceExpression name="supportsContentType"/>
                          <variableReferenceExpression name="supportsFileName"/>
                        </binaryOperatorExpression>
                      </unaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="true"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <comment>update Content Type and Length</comment>
                <assignStatement>
                  <propertyReferenceExpression name="LastCommandName">
                    <variableReferenceExpression name="args"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="Edit"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="CommandName">
                    <variableReferenceExpression name="args"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="Update"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="CommandArgument">
                    <variableReferenceExpression name="args"/>
                  </propertyReferenceExpression>
                  <variableReferenceExpression name="UploadDownloadViewName"/>
                </assignStatement>
                <methodInvokeExpression methodName="RemoveAt">
                  <target>
                    <variableReferenceExpression name="actionValues"/>
                  </target>
                  <parameters>
                    <binaryOperatorExpression operator="Subtract">
                      <propertyReferenceExpression name="Count">
                        <variableReferenceExpression name="actionValues"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="1"/>
                    </binaryOperatorExpression>
                  </parameters>
                </methodInvokeExpression>
                <assignStatement>
                  <propertyReferenceExpression name="Values">
                    <variableReferenceExpression name="args"/>
                  </propertyReferenceExpression>
                  <methodInvokeExpression methodName="ToArray">
                    <target>
                      <variableReferenceExpression name="actionValues"/>
                    </target>
                  </methodInvokeExpression>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="IgnoreBusinessRules">
                    <variableReferenceExpression name="args"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="true"/>
                </assignStatement>
                <assignStatement>
                  <variableReferenceExpression name="r"/>
                  <methodInvokeExpression methodName="Execute">
                    <target>
                      <methodInvokeExpression methodName="CreateDataController">
                        <target>
                          <typeReferenceExpression type="ControllerFactory"/>
                        </target>
                      </methodInvokeExpression>
                    </target>
                    <parameters>
                      <propertyReferenceExpression name="DataController"/>
                      <variableReferenceExpression name="UploadDownloadViewName"/>
                      <variableReferenceExpression name="args"/>
                    </parameters>
                  </methodInvokeExpression>
                </assignStatement>
                <methodReturnStatement>
                  <variableReferenceExpression name="canceled"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method LoadFile(Stream) -->
            <memberMethod name="LoadFile">
              <attributes public="true"/>
              <parameters>
                <parameter type="Stream" name="stream"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <binaryOperatorExpression operator="IdentityInequality">
                        <propertyReferenceExpression name="Current">
                          <typeReferenceExpression type="BlobHandlerInfo"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                      <methodInvokeExpression methodName="ProcessDownloadViaBusinessRule">
                        <target>
                          <propertyReferenceExpression name="Current">
                            <typeReferenceExpression type="BlobHandlerInfo"/>
                          </propertyReferenceExpression>
                        </target>
                        <parameters>
                          <argumentReferenceExpression name="stream"/>
                        </parameters>
                      </methodInvokeExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement/>
                  </trueStatements>
                </conditionStatement>
                <usingStatement>
                  <variable type="SqlStatement" name="getBlob">
                    <init>
                      <methodInvokeExpression methodName="CreateBlobSelectStatement">
                        <target>
                          <typeReferenceExpression type="BlobFactory"/>
                        </target>
                      </methodInvokeExpression>
                    </init>
                  </variable>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <methodInvokeExpression methodName="Read">
                          <target>
                            <variableReferenceExpression name="getBlob"/>
                          </target>
                        </methodInvokeExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="System.Object" name="v">
                          <init>
                            <arrayIndexerExpression>
                              <target>
                                <variableReferenceExpression name="getBlob"/>
                              </target>
                              <indices>
                                <primitiveExpression value="0"/>
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
                                  <!--<arrayIndexerExpression>
                                    <target>
                                      <variableReferenceExpression name="getBlob"/>
                                    </target>
                                    <indices>
                                      <primitiveExpression value="0"/>
                                    </indices>
                                  </arrayIndexerExpression>-->
                                </parameters>
                              </methodInvokeExpression>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <conditionStatement>
                              <condition>
                                <methodInvokeExpression methodName="Equals">
                                  <target>
                                    <typeofExpression type="System.String"/>
                                  </target>
                                  <parameters>
                                    <methodInvokeExpression methodName="GetFieldType">
                                      <target>
                                        <propertyReferenceExpression name="Reader">
                                          <variableReferenceExpression name="getBlob"/>
                                        </propertyReferenceExpression>
                                      </target>
                                      <parameters>
                                        <primitiveExpression value="0"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </condition>
                              <trueStatements>
                                <variableDeclarationStatement type="System.Byte[]" name="stringData">
                                  <init>
                                    <methodInvokeExpression methodName="GetBytes">
                                      <target>
                                        <propertyReferenceExpression name="Default">
                                          <typeReferenceExpression type="Encoding"/>
                                        </propertyReferenceExpression>
                                      </target>
                                      <parameters>
                                        <castExpression targetType="System.String">
                                          <variableReferenceExpression name="v"/>
                                          <!--<arrayIndexerExpression>
                                            <target>
                                              <variableReferenceExpression name="getBlob"/>
                                            </target>
                                            <indices>
                                              <primitiveExpression value="0"/>
                                            </indices>
                                          </arrayIndexerExpression>-->
                                        </castExpression>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </init>
                                </variableDeclarationStatement>
                                <methodInvokeExpression methodName="Write">
                                  <target>
                                    <argumentReferenceExpression name="stream"/>
                                  </target>
                                  <parameters>
                                    <variableReferenceExpression name="stringData"/>
                                    <primitiveExpression value="0"/>
                                    <propertyReferenceExpression name="Length">
                                      <variableReferenceExpression name="stringData"/>
                                    </propertyReferenceExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </trueStatements>
                              <falseStatements>
                                <variableDeclarationStatement type="System.Byte[]" name="data">
                                  <init>
                                    <castExpression targetType="System.Byte[]">
                                      <variableReferenceExpression name="v"/>
                                    </castExpression>
                                  </init>
                                </variableDeclarationStatement>
                                <methodInvokeExpression methodName="Write">
                                  <target>
                                    <propertyReferenceExpression name="stream"/>
                                  </target>
                                  <parameters>
                                    <variableReferenceExpression name="data"/>
                                    <primitiveExpression value="0"/>
                                    <propertyReferenceExpression name="Length">
                                      <variableReferenceExpression name="data"/>
                                    </propertyReferenceExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </falseStatements>
                              <!--<falseStatements>
                                <variableDeclarationStatement type="System.Byte[]" name="buffer">
                                  <init>
                                    <arrayCreateExpression>
                                      <createType type="System.Byte"/>
                                      <sizeExpression>
                                        <binaryOperatorExpression operator="Multiply">
                                          <primitiveExpression value="1024"/>
                                          <primitiveExpression value="64"/>
                                        </binaryOperatorExpression>
                                      </sizeExpression>
                                    </arrayCreateExpression>
                                  </init>
                                </variableDeclarationStatement>
                                <variableDeclarationStatement type="System.Int64" name="offset">
                                  <init>
                                    <primitiveExpression value="0"/>
                                  </init>
                                </variableDeclarationStatement>
                                <variableDeclarationStatement type="System.Int64" name="bytesRead">
                                  <init>
                                    <methodInvokeExpression methodName="GetBytes">
                                      <target>
                                        <propertyReferenceExpression name="Reader">
                                          <variableReferenceExpression name="getBlob"/>
                                        </propertyReferenceExpression>
                                      </target>
                                      <parameters>
                                        <primitiveExpression value="0"/>
                                        <variableReferenceExpression name="offset"/>
                                        <variableReferenceExpression name="buffer"/>
                                        <variableReferenceExpression name="0"/>
                                        <propertyReferenceExpression name="Length">
                                          <variableReferenceExpression name="buffer"/>
                                        </propertyReferenceExpression>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </init>
                                </variableDeclarationStatement>
                                <whileStatement>
                                  <test>
                                    <binaryOperatorExpression operator="GreaterThan">
                                      <variableReferenceExpression name="bytesRead"/>
                                      <primitiveExpression value="0"/>
                                    </binaryOperatorExpression>
                                  </test>
                                  <statements>
                                    <methodInvokeExpression methodName="Write">
                                      <target>
                                        <argumentReferenceExpression name="stream"/>
                                      </target>
                                      <parameters>
                                        <variableReferenceExpression name="buffer"/>
                                        <primitiveExpression value="0"/>
                                        <methodInvokeExpression methodName="ToInt32">
                                          <target>
                                            <typeReferenceExpression type="Convert"/>
                                          </target>
                                          <parameters>
                                            <variableReferenceExpression name="bytesRead"/>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </parameters>
                                    </methodInvokeExpression>
                                    <assignStatement>
                                      <variableReferenceExpression name="offset"/>
                                      <binaryOperatorExpression operator="Add">
                                        <variableReferenceExpression name="offset"/>
                                        <variableReferenceExpression name="bytesRead"/>
                                      </binaryOperatorExpression>
                                    </assignStatement>
                                    <conditionStatement>
                                      <condition>
                                        <binaryOperatorExpression operator="LessThan">
                                          <variableReferenceExpression name="bytesRead"/>
                                          <propertyReferenceExpression name="Length">
                                            <variableReferenceExpression name="buffer"/>
                                          </propertyReferenceExpression>
                                        </binaryOperatorExpression>
                                      </condition>
                                      <trueStatements>
                                        <breakStatement/>
                                      </trueStatements>
                                    </conditionStatement>
                                    <assignStatement>
                                      <variableReferenceExpression name="bytesRead"/>
                                      <methodInvokeExpression methodName="GetBytes">
                                        <target>
                                          <propertyReferenceExpression name="Reader">
                                            <variableReferenceExpression name="getBlob"/>
                                          </propertyReferenceExpression>
                                        </target>
                                        <parameters>
                                          <primitiveExpression value="0"/>
                                          <variableReferenceExpression name="offset"/>
                                          <variableReferenceExpression name="buffer"/>
                                          <primitiveExpression value="0"/>
                                          <propertyReferenceExpression name="Length">
                                            <variableReferenceExpression name="buffer"/>
                                          </propertyReferenceExpression>
                                        </parameters>
                                      </methodInvokeExpression>
                                    </assignStatement>
                                  </statements>
                                </whileStatement>
                              </falseStatements>-->
                            </conditionStatement>
                          </trueStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </usingStatement>
              </statements>
            </memberMethod>
            <!-- field ContentTypeField-->
            <memberField type="System.String" name="ContentTypeField">
              <attributes private="true"/>
            </memberField>
            <!-- property ContentTypeField -->
            <memberProperty type="System.String" name="ContentTypeField">
              <attributes public="true"/>
              <getStatements>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="IsNotNullOrEmpty">
                      <fieldReferenceExpression name="ContentTypeField"/>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <fieldReferenceExpression name="ContentTypeField">
                        <thisReferenceExpression/>
                      </fieldReferenceExpression>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <binaryOperatorExpression operator="Add">
                    <propertyReferenceExpression name="ControllerFieldName"/>
                    <primitiveExpression value="ContentType"/>
                  </binaryOperatorExpression>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="ContentTypeField"/>
                  <argumentReferenceExpression name="value"/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- field FileNameField-->
            <memberField type="System.String" name="FileNameField">
              <attributes private="true"/>
            </memberField>
            <!-- property FileNameField -->
            <memberProperty type="System.String" name="FileNameField">
              <attributes public="true"/>
              <getStatements>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="IsNotNullOrEmpty">
                      <fieldReferenceExpression name="FileNameField"/>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <fieldReferenceExpression name="FileNameField">
                        <thisReferenceExpression/>
                      </fieldReferenceExpression>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <binaryOperatorExpression operator="Add">
                    <fieldReferenceExpression name="ControllerFieldName"/>
                    <primitiveExpression value="FileName"/>
                  </binaryOperatorExpression>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="FileNameField"/>
                  <argumentReferenceExpression name="value"/>
                </assignStatement>
              </setStatements>


            </memberProperty>
            <!-- field FileNameField-->
            <memberField type="System.String" name="LengthField">
              <attributes private="true"/>
            </memberField>
            <!-- property FileNameField -->
            <memberProperty type="System.String" name="LengthField">
              <attributes public="true"/>
              <getStatements>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="IsNotNullOrEmpty">
                      <fieldReferenceExpression name="LengthField"/>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <fieldReferenceExpression name="LengthField">
                        <thisReferenceExpression/>
                      </fieldReferenceExpression>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <binaryOperatorExpression operator="Add">
                    <fieldReferenceExpression name="ControllerFieldName"/>
                    <primitiveExpression value="Length"/>
                  </binaryOperatorExpression>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="LengthField"/>
                  <argumentReferenceExpression name="value"/>
                </assignStatement>
              </setStatements>


            </memberProperty>
            <!-- member DetectSupportForSpecialFields(List<FieldValue>, out bool, out bool) -->
            <memberMethod name="DetectSupportForSpecialFields">
              <attributes private="true"/>
              <parameters>
                <parameter type="List" name="values">
                  <typeArguments>
                    <typeReference type="FieldValue"/>
                  </typeArguments>
                </parameter>
                <parameter direction="Out" type="System.Boolean" name="supportsContentType"/>
                <parameter direction="Out" type="System.Boolean" name="supportsFileName"/>
              </parameters>
              <statements>
                <assignStatement>
                  <argumentReferenceExpression name="supportsContentType"/>
                  <primitiveExpression value="false"/>
                </assignStatement>
                <assignStatement>
                  <argumentReferenceExpression name="supportsFileName"/>
                  <primitiveExpression value="false"/>
                </assignStatement>
                <foreachStatement>
                  <variable type="FieldValue" name="v"/>
                  <target>
                    <argumentReferenceExpression name="values"/>
                  </target>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <methodInvokeExpression methodName="Equals">
                          <target>
                            <propertyReferenceExpression name="Name">
                              <variableReferenceExpression name="v"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="ContentTypeField"/>
                            <propertyReferenceExpression name="OrdinalIgnoreCase">
                              <typeReferenceExpression type="StringComparison"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="supportsContentType"/>
                          <primitiveExpression value="true"/>
                        </assignStatement>
                      </trueStatements>
                      <falseStatements>
                        <conditionStatement>
                          <condition>
                            <methodInvokeExpression methodName="Equals">
                              <target>
                                <propertyReferenceExpression name="Name">
                                  <variableReferenceExpression name="v"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <propertyReferenceExpression name="FileNameField"/>
                                <propertyReferenceExpression name="OrdinalIgnoreCase">
                                  <typeReferenceExpression type="StringComparison"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="supportsFileName"/>
                              <primitiveExpression value="true"/>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                      </falseStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
              </statements>
            </memberMethod>
            <!-- method ProcessDownloadViaBusinessRule(Stream) -->
            <memberMethod returnType="System.Boolean" name="ProcessDownloadViaBusinessRule">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="Stream" name="stream"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.Boolean" name="supportsContentType">
                  <init>
                    <primitiveExpression value="false"/>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.Boolean" name="supportsFileName">
                  <init>
                    <primitiveExpression value="false"/>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="List" name="actionValues">
                  <typeArguments>
                    <typeReference type="FieldValue"/>
                  </typeArguments>
                  <init>
                    <methodInvokeExpression methodName="CreateActionValues">
                      <parameters>
                        <argumentReferenceExpression name="stream"/>
                        <primitiveExpression value="null"/>
                        <primitiveExpression value="null"/>
                        <primitiveExpression value="0"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <methodInvokeExpression methodName="DetectSupportForSpecialFields">
                  <parameters>
                    <variableReferenceExpression name="actionValues"/>
                    <directionExpression direction="Out">
                      <variableReferenceExpression name="supportsContentType"/>
                    </directionExpression>
                    <directionExpression direction="Out">
                      <variableReferenceExpression name="supportsFileName"/>
                    </directionExpression>
                  </parameters>
                </methodInvokeExpression>
                <comment>try processing download via a business rule</comment>
                <variableDeclarationStatement type="ActionArgs" name="args">
                  <init>
                    <objectCreateExpression type="ActionArgs"/>
                  </init>
                </variableDeclarationStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Controller">
                    <variableReferenceExpression name="args"/>
                  </propertyReferenceExpression>
                  <propertyReferenceExpression name="DataController"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="CommandName">
                    <variableReferenceExpression name="args"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="DownloadFile"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="CommandArgument">
                    <variableReferenceExpression name="args"/>
                  </propertyReferenceExpression>
                  <propertyReferenceExpression name="ControllerFieldName"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Values">
                    <variableReferenceExpression name="args"/>
                  </propertyReferenceExpression>
                  <methodInvokeExpression methodName="ToArray">
                    <target>
                      <variableReferenceExpression name="actionValues"/>
                    </target>
                  </methodInvokeExpression>
                </assignStatement>
                <variableDeclarationStatement type="ActionResult" name="r">
                  <init>
                    <methodInvokeExpression methodName="Execute">
                      <target>
                        <methodInvokeExpression methodName="CreateDataController">
                          <target>
                            <typeReferenceExpression type="ControllerFactory"/>
                          </target>
                        </methodInvokeExpression>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="DataController"/>
                        <variableReferenceExpression name="UploadDownloadViewName"/>
                        <variableReferenceExpression name="args"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
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
                        <methodInvokeExpression methodName="Equals">
                          <target>
                            <propertyReferenceExpression name="Name">
                              <variableReferenceExpression name="v"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="ContentTypeField"/>
                            <propertyReferenceExpression name="OrdinalIgnoreCase">
                              <typeReferenceExpression type="StringComparison"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <propertyReferenceExpression name="ContentType">
                            <propertyReferenceExpression name="Current"/>
                          </propertyReferenceExpression>
                          <methodInvokeExpression methodName="ToString">
                            <target>
                              <typeReferenceExpression type="Convert"/>
                            </target>
                            <parameters>
                              <propertyReferenceExpression name="Value">
                                <variableReferenceExpression name="v"/>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                      </trueStatements>
                      <falseStatements>
                        <conditionStatement>
                          <condition>
                            <methodInvokeExpression methodName="Equals">
                              <target>
                                <propertyReferenceExpression name="Name">
                                  <variableReferenceExpression name="v"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <propertyReferenceExpression name="FileNameField"/>
                                <propertyReferenceExpression name="OrdinalIgnoreCase">
                                  <typeReferenceExpression type="StringComparison"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="FileName">
                                <propertyReferenceExpression name="Current"/>
                              </propertyReferenceExpression>
                              <methodInvokeExpression methodName="ToString">
                                <target>
                                  <typeReferenceExpression type="Convert"/>
                                </target>
                                <parameters>
                                  <propertyReferenceExpression name="Value">
                                    <variableReferenceExpression name="v"/>
                                  </propertyReferenceExpression>
                                </parameters>
                              </methodInvokeExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                      </falseStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
                <comment>see if we still need to retrieve the content type or the file name from the database</comment>
                <variableDeclarationStatement type="System.Boolean" name="needsContentType">
                  <init>
                    <unaryOperatorExpression operator="IsNullOrEmpty">
                      <propertyReferenceExpression name="ContentType">
                        <propertyReferenceExpression name="Current"/>
                      </propertyReferenceExpression>
                    </unaryOperatorExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.Boolean" name="needsFileName">
                  <init>
                    <unaryOperatorExpression operator="IsNullOrEmpty">
                      <propertyReferenceExpression name="FileName">
                        <propertyReferenceExpression name="Current"/>
                      </propertyReferenceExpression>
                    </unaryOperatorExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanOr">
                      <binaryOperatorExpression operator="BooleanAnd">
                        <variableReferenceExpression name="needsContentType"/>
                        <variableReferenceExpression name="supportsContentType"/>
                      </binaryOperatorExpression>
                      <binaryOperatorExpression operator="BooleanAnd">
                        <variableReferenceExpression name="needsFileName"/>
                        <variableReferenceExpression name="supportsFileName"/>
                      </binaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="actionValues"/>
                      <methodInvokeExpression methodName="CreateActionValues">
                        <parameters>
                          <primitiveExpression value="null"/>
                          <primitiveExpression value="null"/>
                          <primitiveExpression value="null"/>
                          <primitiveExpression value="0"/>
                        </parameters>
                      </methodInvokeExpression>
                    </assignStatement>
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
                    <foreachStatement>
                      <variable type="FieldValue" name="v"/>
                      <target>
                        <variableReferenceExpression name="actionValues"/>
                      </target>
                      <statements>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <variableReferenceExpression name="filter"/>
                          </target>
                          <parameters>
                            <methodInvokeExpression methodName="Format">
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
                            </methodInvokeExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </statements>
                    </foreachStatement>
                    <variableDeclarationStatement type="PageRequest" name="request">
                      <init>
                        <objectCreateExpression type="PageRequest"/>
                      </init>
                    </variableDeclarationStatement>
                    <assignStatement>
                      <propertyReferenceExpression name="Controller">
                        <variableReferenceExpression name="request"/>
                      </propertyReferenceExpression>
                      <propertyReferenceExpression name="DataController"/>
                    </assignStatement>
                    <assignStatement>
                      <propertyReferenceExpression name="View">
                        <variableReferenceExpression name="request"/>
                      </propertyReferenceExpression>
                      <variableReferenceExpression name="UploadDownloadViewName"/>
                    </assignStatement>
                    <assignStatement>
                      <propertyReferenceExpression name="PageSize">
                        <variableReferenceExpression name="request"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="1"/>
                    </assignStatement>
                    <assignStatement>
                      <propertyReferenceExpression name="RequiresMetaData">
                        <variableReferenceExpression name="request"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="true"/>
                    </assignStatement>
                    <assignStatement>
                      <propertyReferenceExpression name="Filter">
                        <variableReferenceExpression name="request"/>
                      </propertyReferenceExpression>
                      <methodInvokeExpression methodName="ToArray">
                        <target>
                          <variableReferenceExpression name="filter"/>
                        </target>
                      </methodInvokeExpression>
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
                            <propertyReferenceExpression name="Controller">
                              <variableReferenceExpression name="request"/>
                            </propertyReferenceExpression>
                            <propertyReferenceExpression name="View">
                              <variableReferenceExpression name="request"/>
                            </propertyReferenceExpression>
                            <variableReferenceExpression name="request"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="ValueEquality">
                          <propertyReferenceExpression name="Count">
                            <propertyReferenceExpression name="Rows">
                              <variableReferenceExpression name="page"/>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                          <primitiveExpression value="1"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="System.Object[]" name="row">
                          <init>
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
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <variableReferenceExpression name="supportsContentType"/>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="ContentType">
                                <propertyReferenceExpression name="Current"/>
                              </propertyReferenceExpression>
                              <methodInvokeExpression methodName="ToString">
                                <target>
                                  <typeReferenceExpression type="Convert"/>
                                </target>
                                <parameters>
                                  <methodInvokeExpression methodName="SelectFieldValue">
                                    <target>
                                      <variableReferenceExpression name="page"/>
                                    </target>
                                    <parameters>
                                      <propertyReferenceExpression name="ContentTypeField"/>
                                      <variableReferenceExpression name="row"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                </parameters>
                              </methodInvokeExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <conditionStatement>
                          <condition>
                            <variableReferenceExpression name="supportsFileName"/>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="FileName">
                                <propertyReferenceExpression name="Current"/>
                              </propertyReferenceExpression>
                              <methodInvokeExpression methodName="ToString">
                                <target>
                                  <typeReferenceExpression type="Convert"/>
                                </target>
                                <parameters>
                                  <methodInvokeExpression methodName="SelectFieldValue">
                                    <target>
                                      <variableReferenceExpression name="page"/>
                                    </target>
                                    <parameters>
                                      <propertyReferenceExpression name="FileNameField"/>
                                      <variableReferenceExpression name="row"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                </parameters>
                              </methodInvokeExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <propertyReferenceExpression name="Canceled">
                    <variableReferenceExpression name="r"/>
                  </propertyReferenceExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
        <!-- class BlobFactory -->
        <typeDeclaration name="BlobFactory" isPartial="true">
          <members>
            <!-- field Handlers -->
            <memberField type="SortedDictionary" name="Handlers">
              <attributes static="true" public="true"/>
              <typeArguments>
                <typeReference type="System.String"/>
                <typeReference type="BlobHandlerInfo"/>
              </typeArguments>
              <init>
                <objectCreateExpression type="SortedDictionary">
                  <typeArguments>
                    <typeReference type="System.String"/>
                    <typeReference type="BlobHandlerInfo"/>
                  </typeArguments>
                </objectCreateExpression>
              </init>
            </memberField>
            <!-- method RegisterHandler(string, string, string, string[], string, string) -->
            <memberMethod name="RegisterHandler">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="key"/>
                <parameter type="System.String" name="tableName"/>
                <parameter type="System.String" name="fieldName"/>
                <parameter type="System.String[]" name="keyFieldNames"/>
                <parameter type="System.String" name="text"/>
                <parameter type="System.String" name="contentType"/>
              </parameters>
              <statements>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <propertyReferenceExpression name="Handlers"/>
                  </target>
                  <parameters>
                    <argumentReferenceExpression name="key"/>
                    <objectCreateExpression type="BlobHandlerInfo">
                      <parameters>
                        <argumentReferenceExpression name="key"/>
                        <argumentReferenceExpression name="tableName"/>
                        <argumentReferenceExpression name="fieldName"/>
                        <argumentReferenceExpression name="keyFieldNames"/>
                        <argumentReferenceExpression name="text"/>
                        <argumentReferenceExpression name="contentType"/>
                      </parameters>
                    </objectCreateExpression>
                  </parameters>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- method RegisterHandler(string, string, string, string[], string, string, string, string) -->
            <memberMethod name="RegisterHandler">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="key"/>
                <parameter type="System.String" name="tableName"/>
                <parameter type="System.String" name="fieldName"/>
                <parameter type="System.String[]" name="keyFieldNames"/>
                <parameter type="System.String" name="text"/>
                <parameter type="System.String" name="dataController"/>
                <parameter type="System.String" name="controllerFieldName"/>
              </parameters>
              <statements>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <propertyReferenceExpression name="Handlers"/>
                  </target>
                  <parameters>
                    <argumentReferenceExpression name="key"/>
                    <objectCreateExpression type="BlobHandlerInfo">
                      <parameters>
                        <argumentReferenceExpression name="key"/>
                        <argumentReferenceExpression name="tableName"/>
                        <argumentReferenceExpression name="fieldName"/>
                        <argumentReferenceExpression name="keyFieldNames"/>
                        <argumentReferenceExpression name="text"/>
                        <propertyReferenceExpression name="Empty">
                          <typeReferenceExpression type="String"/>
                        </propertyReferenceExpression>
                        <argumentReferenceExpression name="dataController"/>
                        <argumentReferenceExpression name="controllerFieldName"/>
                      </parameters>
                    </objectCreateExpression>
                  </parameters>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- method CreateBlobSelectStatement -->
            <memberMethod returnType="SqlStatement" name="CreateBlobSelectStatement">
              <attributes public="true" static="true"/>
              <statements>
                <variableDeclarationStatement type="BlobHandlerInfo" name="handler">
                  <init>
                    <propertyReferenceExpression name="Current">
                      <typeReferenceExpression type="BlobHandlerInfo"/>
                    </propertyReferenceExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <variableReferenceExpression name="handler"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="System.String" name="parameterMarker">
                      <init>
                        <methodInvokeExpression methodName="GetParameterMarker">
                          <target>
                            <typeReferenceExpression type="SqlStatement"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="Empty">
                              <typeReferenceExpression type="String"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="List" name="keyValues">
                      <typeArguments>
                        <typeReference type="System.String"/>
                      </typeArguments>
                      <init>
                        <methodInvokeExpression methodName="CreateKeyValues">
                          <target>
                            <variableReferenceExpression name="handler"/>
                          </target>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
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
                        <primitiveExpression value="select {{0}} from {{1}} where "/>
                        <propertyReferenceExpression name="FieldName">
                          <variableReferenceExpression name="handler"/>
                        </propertyReferenceExpression>
                        <propertyReferenceExpression name="TableName">
                          <variableReferenceExpression name="handler"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
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
                            <propertyReferenceExpression name="KeyFieldNames">
                              <variableReferenceExpression name="handler"/>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                        </binaryOperatorExpression>
                      </test>
                      <increment>
                        <variableReferenceExpression name="i"/>
                      </increment>
                      <statements>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="GreaterThan">
                              <variableReferenceExpression name="i"/>
                              <primitiveExpression value="0"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="Append">
                              <target>
                                <variableReferenceExpression name="sb"/>
                              </target>
                              <parameters>
                                <primitiveExpression value=" and "/>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>
                        <methodInvokeExpression methodName="AppendFormat">
                          <target>
                            <variableReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="{{0}}={{1}}p{{2}}"/>
                            <arrayIndexerExpression>
                              <target>
                                <propertyReferenceExpression name="KeyFieldNames">
                                  <variableReferenceExpression name="handler"/>
                                </propertyReferenceExpression>
                              </target>
                              <indices>
                                <variableReferenceExpression name="i"/>
                              </indices>
                            </arrayIndexerExpression>
                            <variableReferenceExpression name="parameterMarker"/>
                            <variableReferenceExpression name="i"/>
                          </parameters>
                        </methodInvokeExpression>
                      </statements>
                    </forStatement>
                    <variableDeclarationStatement type="SqlText" name="getBlob">
                      <init>
                        <objectCreateExpression type="SqlText">
                          <parameters>
                            <methodInvokeExpression methodName="ToString">
                              <target>
                                <variableReferenceExpression name="sb"/>
                              </target>
                            </methodInvokeExpression>
                          </parameters>
                        </objectCreateExpression>
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
                          <propertyReferenceExpression name="Length">
                            <propertyReferenceExpression name="KeyFieldNames">
                              <variableReferenceExpression name="handler"/>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                        </binaryOperatorExpression>
                      </test>
                      <increment>
                        <variableReferenceExpression name="j"/>
                      </increment>
                      <statements>
                        <methodInvokeExpression methodName="AddParameter">
                          <target>
                            <variableReferenceExpression name="getBlob"/>
                          </target>
                          <parameters>
                            <methodInvokeExpression methodName="Format">
                              <target>
                                <typeReferenceExpression type="String"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="{{0}}p{{1}}"/>
                                <variableReferenceExpression name="parameterMarker"/>
                                <variableReferenceExpression name="j"/>
                              </parameters>
                            </methodInvokeExpression>
                            <arrayIndexerExpression>
                              <target>
                                <variableReferenceExpression name="keyValues"/>
                              </target>
                              <indices>
                                <variableReferenceExpression name="j"/>
                              </indices>
                            </arrayIndexerExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </statements>
                    </forStatement>
                    <methodReturnStatement>
                      <variableReferenceExpression name="getBlob"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <primitiveExpression value="null"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method CreateBlobUpdateStatement -->
            <memberMethod returnType="SqlStatement" name="CreateBlobUpdateStatement">
              <attributes static="true" public="true"/>
              <statements>
                <variableDeclarationStatement type="BlobHandlerInfo" name="handler">
                  <init>
                    <propertyReferenceExpression name="Current">
                      <typeReferenceExpression type="BlobHandlerInfo"/>
                    </propertyReferenceExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <variableReferenceExpression name="handler"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="System.String" name="parameterMarker">
                      <init>
                        <methodInvokeExpression methodName="GetParameterMarker">
                          <target>
                            <typeReferenceExpression type="SqlStatement"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="Empty">
                              <typeReferenceExpression type="String"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="List" name="keyValues">
                      <typeArguments>
                        <typeReference type="System.String"/>
                      </typeArguments>
                      <init>
                        <methodInvokeExpression methodName="CreateKeyValues">
                          <target>
                            <variableReferenceExpression name="handler"/>
                          </target>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="HttpPostedFile" name="file">
                      <init>
                        <arrayIndexerExpression>
                          <target>
                            <propertyReferenceExpression name="Files">
                              <propertyReferenceExpression name="Request">
                                <propertyReferenceExpression name="Current">
                                  <typeReferenceExpression type="HttpContext"/>
                                </propertyReferenceExpression>
                              </propertyReferenceExpression>
                            </propertyReferenceExpression>
                          </target>
                          <indices>
                            <primitiveExpression value="0"/>
                          </indices>
                        </arrayIndexerExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="StringBuilder" name="sb">
                      <init>
                        <objectCreateExpression type="StringBuilder"/>
                      </init>
                    </variableDeclarationStatement>
                    <methodInvokeExpression methodName="AppendFormat">
                      <target>
                        <variableReferenceExpression  name="sb"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="update {{0}} set {{1}} = "/>
                        <propertyReferenceExpression name="TableName">
                          <variableReferenceExpression name="handler"/>
                        </propertyReferenceExpression>
                        <propertyReferenceExpression name="FieldName">
                          <variableReferenceExpression name="handler"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>

                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="ValueEquality">
                          <propertyReferenceExpression name="ContentLength">
                            <variableReferenceExpression name="file"/>
                          </propertyReferenceExpression>
                          <primitiveExpression value="0"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="Append">
                          <target>
                            <variableReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="null" convertTo="String"/>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                      <falseStatements>
                        <methodInvokeExpression methodName="AppendFormat">
                          <target>
                            <variableReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="{{0}}blob"/>
                            <variableReferenceExpression name="parameterMarker"/>
                          </parameters>
                        </methodInvokeExpression>
                      </falseStatements>
                    </conditionStatement>
                    <methodInvokeExpression methodName="Append">
                      <target>
                        <variableReferenceExpression name="sb"/>
                      </target>
                      <parameters>
                        <primitiveExpression value=" where "/>
                      </parameters>
                    </methodInvokeExpression>


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
                            <propertyReferenceExpression name="KeyFieldNames">
                              <variableReferenceExpression name="handler"/>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                        </binaryOperatorExpression>
                      </test>
                      <increment>
                        <variableReferenceExpression name="i"/>
                      </increment>
                      <statements>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="GreaterThan">
                              <variableReferenceExpression name="i"/>
                              <primitiveExpression value="0"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="Append">
                              <target>
                                <variableReferenceExpression name="sb"/>
                              </target>
                              <parameters>
                                <primitiveExpression value=" and "/>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>
                        <methodInvokeExpression methodName="AppendFormat">
                          <target>
                            <variableReferenceExpression name="sb"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="{{0}}={{1}}p{{2}}"/>
                            <arrayIndexerExpression>
                              <target>
                                <propertyReferenceExpression name="KeyFieldNames">
                                  <variableReferenceExpression name="handler"/>
                                </propertyReferenceExpression>
                              </target>
                              <indices>
                                <variableReferenceExpression name="i"/>
                              </indices>
                            </arrayIndexerExpression>
                            <variableReferenceExpression name="parameterMarker"/>
                            <variableReferenceExpression name="i"/>
                          </parameters>
                        </methodInvokeExpression>
                      </statements>
                    </forStatement>
                    <variableDeclarationStatement type="SqlText" name="updateBlob">
                      <init>
                        <objectCreateExpression type="SqlText">
                          <parameters>
                            <methodInvokeExpression methodName="ToString">
                              <target>
                                <variableReferenceExpression name="sb"/>
                              </target>
                            </methodInvokeExpression>
                          </parameters>
                        </objectCreateExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="GreaterThan">
                          <propertyReferenceExpression name="ContentLength">
                            <variableReferenceExpression name="file"/>
                          </propertyReferenceExpression>
                          <primitiveExpression value="0"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="System.Byte[]" name="data">
                          <init>
                            <arrayCreateExpression>
                              <createType type="System.Byte"/>
                              <sizeExpression>
                                <propertyReferenceExpression name="ContentLength">
                                  <variableReferenceExpression name="file"/>
                                </propertyReferenceExpression>
                              </sizeExpression>
                            </arrayCreateExpression>
                          </init>
                        </variableDeclarationStatement>
                        <methodInvokeExpression methodName="Read">
                          <target>
                            <propertyReferenceExpression name="InputStream">
                              <variableReferenceExpression name="file"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="data"/>
                            <primitiveExpression value="0"/>
                            <propertyReferenceExpression name="Length">
                              <variableReferenceExpression name="data"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                        <methodInvokeExpression methodName="AddParameter">
                          <target>
                            <variableReferenceExpression name="updateBlob"/>
                          </target>
                          <parameters>
                            <binaryOperatorExpression operator="Add">
                              <variableReferenceExpression name="parameterMarker"/>
                              <primitiveExpression value="blob"/>
                            </binaryOperatorExpression>
                            <variableReferenceExpression name="data"/>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                    <forStatement>
                      <variable type="System.Int32" name="j">
                        <init>
                          <primitiveExpression value="0"/>
                        </init>
                      </variable>
                      <test>
                        <binaryOperatorExpression operator="LessThan">
                          <variableReferenceExpression name="j"/>
                          <propertyReferenceExpression name="Length">
                            <propertyReferenceExpression name="KeyFieldNames">
                              <variableReferenceExpression name="handler"/>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                        </binaryOperatorExpression>
                      </test>
                      <increment>
                        <variableReferenceExpression name="j"/>
                      </increment>
                      <statements>
                        <methodInvokeExpression methodName="AddParameter">
                          <target>
                            <variableReferenceExpression name="updateBlob"/>
                          </target>
                          <parameters>
                            <methodInvokeExpression methodName="Format">
                              <target>
                                <typeReferenceExpression type="String"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="{{0}}p{{1}}"/>
                                <variableReferenceExpression name="parameterMarker"/>
                                <variableReferenceExpression name="j"/>
                              </parameters>
                            </methodInvokeExpression>
                            <arrayIndexerExpression>
                              <target>
                                <variableReferenceExpression name="keyValues"/>
                              </target>
                              <indices>
                                <variableReferenceExpression name="j"/>
                              </indices>
                            </arrayIndexerExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </statements>
                    </forStatement>
                    <methodReturnStatement>
                      <variableReferenceExpression name="updateBlob"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <primitiveExpression value="null"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
        <!-- class Blob -->
        <typeDeclaration name="Blob">
          <baseTypes>
            <typeReference type="GenericHandlerBase"/>
            <typeReference type="IHttpHandler"/>
            <typeReference type="System.Web.SessionState.IRequiresSessionState"/>
          </baseTypes>
          <members>
            <memberField type="System.Int32" name="ThumbnailCacheTimeout">
              <attributes public="true" const="true"/>
              <init>
                <primitiveExpression value="5"/>
              </init>
            </memberField>
            <!-- method ProcessRequest(context) -->
            <memberMethod name="ProcessRequest" privateImplementationType="IHttpHandler">
              <attributes/>
              <parameters>
                <parameter type="HttpContext" name="context"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="BlobHandlerInfo" name="handler">
                  <init>
                    <propertyReferenceExpression name="Current">
                      <typeReferenceExpression type="BlobHandlerInfo"/>
                    </propertyReferenceExpression>
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
                <variableDeclarationStatement type="BlobAdapter" name="ba">
                  <init>
                    <primitiveExpression value="null"/>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <propertyReferenceExpression name="DataController">
                        <variableReferenceExpression name="handler"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="ba"/>
                      <methodInvokeExpression methodName="Create">
                        <target>
                          <propertyReferenceExpression name="BlobAdapterFactory"/>
                        </target>
                        <parameters>
                          <propertyReferenceExpression name="DataController">
                            <variableReferenceExpression name="handler"/>
                          </propertyReferenceExpression>
                          <methodInvokeExpression methodName="Replace">
                            <target>
                              <propertyReferenceExpression name="FieldName">
                                <variableReferenceExpression name="handler"/>
                              </propertyReferenceExpression>
                            </target>
                            <parameters>
                              <xsl:choose>
                                <xsl:when test="contains($ProviderName,'MySql')">
                                  <primitiveExpression value="`"/>
                                </xsl:when>
                                <xsl:otherwise>
                                  <primitiveExpression value="&quot;"/>
                                </xsl:otherwise>
                              </xsl:choose>
                              <propertyReferenceExpression name="Empty">
                                <propertyReferenceExpression name="String"/>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </parameters>
                      </methodInvokeExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <variableReferenceExpression name="ba"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <propertyReferenceExpression name="ContentTypeField">
                        <variableReferenceExpression name="handler"/>
                      </propertyReferenceExpression>
                      <propertyReferenceExpression name="ContentTypeField">
                        <variableReferenceExpression name="ba"/>
                      </propertyReferenceExpression>
                    </assignStatement>
                    <assignStatement>
                      <propertyReferenceExpression name="FileNameField">
                        <variableReferenceExpression name="handler"/>
                      </propertyReferenceExpression>
                      <propertyReferenceExpression name="FileNameField">
                        <variableReferenceExpression name="ba"/>
                      </propertyReferenceExpression>
                    </assignStatement>
                    <assignStatement>
                      <propertyReferenceExpression name="LengthField">
                        <variableReferenceExpression name="handler"/>
                      </propertyReferenceExpression>
                      <propertyReferenceExpression name="LengthField">
                        <variableReferenceExpression name="ba"/>
                      </propertyReferenceExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="System.String" name="val">
                  <init>
                    <arrayIndexerExpression>
                      <target>
                        <methodInvokeExpression methodName="Split">
                          <target>
                            <propertyReferenceExpression name="Value">
                              <variableReferenceExpression name="handler"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <primitiveExpression value="|" convertTo="Char"/>
                          </parameters>
                        </methodInvokeExpression>
                      </target>
                      <indices>
                        <primitiveExpression value="1"/>
                      </indices>
                    </arrayIndexerExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanOr">
                      <binaryOperatorExpression operator="ValueEquality">
                        <propertyReferenceExpression name="Mode">
                          <variableReferenceExpression name="handler"/>
                        </propertyReferenceExpression>
                        <propertyReferenceExpression name="Original">
                          <typeReferenceExpression type="BlobMode"/>
                        </propertyReferenceExpression>
                      </binaryOperatorExpression>
                      <binaryOperatorExpression operator="ValueEquality">
                        <propertyReferenceExpression name="HttpMethod">
                          <propertyReferenceExpression name="Request">
                            <argumentReferenceExpression name="context"/>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                        <primitiveExpression value="POST"/>
                      </binaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="AppendDownloadTokenCookie"/>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <propertyReferenceExpression name="Mode">
                        <variableReferenceExpression name="handler"/>
                      </propertyReferenceExpression>
                      <propertyReferenceExpression name="Upload">
                        <typeReferenceExpression type="BlobMode"/>
                      </propertyReferenceExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="RenderUploader">
                      <parameters>
                        <argumentReferenceExpression name="context"/>
                        <variableReferenceExpression name="handler"/>
                        <methodInvokeExpression methodName="SaveFile">
                          <target>
                            <variableReferenceExpression name="handler"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="context"/>
                            <variableReferenceExpression name="ba"/>
                            <variableReferenceExpression name="val"/>
                          </parameters>
                        </methodInvokeExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                  <falseStatements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityEquality">
                          <variableReferenceExpression name="ba"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="System.String" name="tempFileName">
                          <init>
                            <methodInvokeExpression methodName="GetTempFileName">
                              <target>
                                <typeReferenceExpression type="Path"/>
                              </target>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <variableDeclarationStatement type="Stream" name="stream">
                          <init>
                            <methodInvokeExpression methodName="Create">
                              <target>
                                <typeReferenceExpression type="File"/>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="tempFileName"/>
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <methodInvokeExpression methodName="LoadFile">
                          <target>
                            <variableReferenceExpression name="handler"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="stream"/>
                          </parameters>
                        </methodInvokeExpression>
                        <methodInvokeExpression methodName="CopyToOutput">
                          <parameters>
                            <argumentReferenceExpression name="context"/>
                            <variableReferenceExpression name="stream"/>
                            <variableReferenceExpression name="handler"/>
                          </parameters>
                        </methodInvokeExpression>
                        <methodInvokeExpression methodName="Close">
                          <target>
                            <variableReferenceExpression name="stream"/>
                          </target>
                        </methodInvokeExpression>
                        <methodInvokeExpression methodName="Delete">
                          <target>
                            <typeReferenceExpression type="File"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="tempFileName"/>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                      <falseStatements>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="BooleanAnd">
                              <unaryOperatorExpression operator="Not">
                                <propertyReferenceExpression name="IsPublic">
                                  <variableReferenceExpression name="ba"/>
                                </propertyReferenceExpression>
                              </unaryOperatorExpression>
                              <unaryOperatorExpression operator="Not">
                                <propertyReferenceExpression name="IsAuthenticated">
                                  <propertyReferenceExpression name="Identity">
                                    <propertyReferenceExpression name="User">
                                      <propertyReferenceExpression name="context"/>
                                    </propertyReferenceExpression>
                                  </propertyReferenceExpression>
                                </propertyReferenceExpression>
                              </unaryOperatorExpression>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="StatusCode">
                                <propertyReferenceExpression name="Response">
                                  <argumentReferenceExpression name="context"/>
                                </propertyReferenceExpression>
                              </propertyReferenceExpression>
                              <primitiveExpression value="403"/>
                            </assignStatement>
                            <methodReturnStatement/>
                          </trueStatements>
                        </conditionStatement>
                        <variableDeclarationStatement type="Stream" name="stream">
                          <init>
                            <primitiveExpression value="null"/>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <methodInvokeExpression methodName="Equals">
                              <target>
                                <propertyReferenceExpression name="Mode">
                                  <variableReferenceExpression name="handler"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <propertyReferenceExpression name="Thumbnail">
                                  <propertyReferenceExpression name="BlobMode"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </condition>
                          <trueStatements>
                            <variableDeclarationStatement type="System.String" name="contentType">
                              <init>
                                <methodInvokeExpression methodName="ReadContentType">
                                  <target>
                                    <variableReferenceExpression name="ba"/>
                                  </target>
                                  <parameters>
                                    <variableReferenceExpression name="val"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </init>
                            </variableDeclarationStatement>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="BooleanOr">
                                  <unaryOperatorExpression operator="IsNullOrEmpty">
                                    <variableReferenceExpression name="contentType"/>
                                  </unaryOperatorExpression>
                                  <unaryOperatorExpression operator="Not">
                                    <methodInvokeExpression methodName="StartsWith">
                                      <target>
                                        <variableReferenceExpression name="contentType"/>
                                      </target>
                                      <parameters>
                                        <primitiveExpression value="image/"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </unaryOperatorExpression>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="stream"/>
                                  <objectCreateExpression type="MemoryStream"/>
                                </assignStatement>
                              </trueStatements>
                            </conditionStatement>
                          </trueStatements>
                        </conditionStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="IdentityEquality">
                              <variableReferenceExpression name="stream"/>
                              <primitiveExpression value="null"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="stream"/>
                              <methodInvokeExpression methodName="ReadBlob">
                                <target>
                                  <argumentReferenceExpression name="ba"/>
                                </target>
                                <parameters>
                                  <variableReferenceExpression name="val"/>
                                </parameters>
                              </methodInvokeExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <methodInvokeExpression methodName="ProcessDownloadViaBusinessRule">
                          <target>
                            <variableReferenceExpression name="handler"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="stream"/>
                          </parameters>
                        </methodInvokeExpression>
                        <methodInvokeExpression methodName="CopyToOutput">
                          <parameters>
                            <argumentReferenceExpression name="context"/>
                            <argumentReferenceExpression name="stream"/>
                            <argumentReferenceExpression name="handler"/>
                          </parameters>
                        </methodInvokeExpression>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="IdentityInequality">
                              <variableReferenceExpression name="stream"/>
                              <primitiveExpression value="null"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="Close">
                              <target>
                                <variableReferenceExpression name="stream"/>
                              </target>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>

                      </falseStatements>
                    </conditionStatement>
                  </falseStatements>
                </conditionStatement>


                <!-- 
            bool requireCaching = context.Request.Browser.Browser == "IE" && context.Request.Browser.MajorVersion < 9 && context.Request.IsSecureConnection;
            if (handler.Mode != BlobMode.Thumbnail && !requireCaching)
                context.Response.Cache.SetCacheability(HttpCacheability.NoCache);
-->
                <variableDeclarationStatement type="HttpRequest" name="request">
                  <init>
                    <propertyReferenceExpression name="Request">
                      <argumentReferenceExpression name="context"/>
                    </propertyReferenceExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.Boolean" name="requireCaching">
                  <init>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <propertyReferenceExpression name="IsSecureConnection">
                        <variableReferenceExpression name="request"/>
                      </propertyReferenceExpression>
                      <binaryOperatorExpression operator="BooleanAnd">
                        <binaryOperatorExpression operator="ValueEquality">
                          <propertyReferenceExpression name="Browser">
                            <propertyReferenceExpression name="Browser">
                              <variableReferenceExpression name="request"/>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                          <primitiveExpression value="IE"/>
                        </binaryOperatorExpression>
                        <binaryOperatorExpression operator="LessThan">
                          <propertyReferenceExpression name="MajorVersion">
                            <propertyReferenceExpression name="Browser">
                              <variableReferenceExpression name="request"/>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                          <primitiveExpression value="9"/>
                        </binaryOperatorExpression>
                      </binaryOperatorExpression>
                    </binaryOperatorExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <unaryOperatorExpression operator="Not">
                        <variableReferenceExpression name="requireCaching"/>
                      </unaryOperatorExpression>
                      <binaryOperatorExpression operator="ValueInequality">
                        <propertyReferenceExpression name="Mode">
                          <variableReferenceExpression name="handler"/>
                        </propertyReferenceExpression>
                        <propertyReferenceExpression name="Thumbnail">
                          <typeReferenceExpression type="BlobMode"/>
                        </propertyReferenceExpression>
                      </binaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="SetCacheability">
                      <target>
                        <propertyReferenceExpression name="Cache">
                          <propertyReferenceExpression name="Response">
                            <argumentReferenceExpression name="context"/>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="NoCache">
                          <typeReferenceExpression type="HttpCacheability"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- property IsReusable -->
            <memberProperty type="System.Boolean" name="IsReusable" privateImplementationType="IHttpHandler">
              <attributes/>
              <getStatements>
                <methodReturnStatement>
                  <primitiveExpression value="false"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- field ImageFormats -->
            <memberField type="SortedDictionary" name="ImageFormats">
              <typeArguments>
                <typeReference type="Guid"/>
                <typeReference type="System.String"/>
              </typeArguments>
              <attributes public="true" static="true"/>
            </memberField>
            <!--<memberField type="System.String" name="error"/>-->
            <!-- static constructor Blob() -->
            <typeConstructor>
              <statements>
                <assignStatement>
                  <propertyReferenceExpression name="ImageFormats"/>
                  <objectCreateExpression type="SortedDictionary">
                    <typeArguments>
                      <typeReference type="Guid"/>
                      <typeReference type="System.String"/>
                    </typeArguments>
                  </objectCreateExpression>
                </assignStatement>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <propertyReferenceExpression name="ImageFormats"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Guid">
                      <propertyReferenceExpression name="Bmp">
                        <typeReferenceExpression type="ImageFormat"/>
                      </propertyReferenceExpression>
                    </propertyReferenceExpression>
                    <primitiveExpression value="image/bmp"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <propertyReferenceExpression name="ImageFormats"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Guid">
                      <propertyReferenceExpression name="Emf">
                        <typeReferenceExpression type="ImageFormat"/>
                      </propertyReferenceExpression>
                    </propertyReferenceExpression>
                    <primitiveExpression value="image/emf"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <propertyReferenceExpression name="ImageFormats"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Guid">
                      <propertyReferenceExpression name="Exif">
                        <typeReferenceExpression type="ImageFormat"/>
                      </propertyReferenceExpression>
                    </propertyReferenceExpression>
                    <primitiveExpression value="image/bmp"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <propertyReferenceExpression name="ImageFormats"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Guid">
                      <propertyReferenceExpression name="Gif">
                        <typeReferenceExpression type="ImageFormat"/>
                      </propertyReferenceExpression>
                    </propertyReferenceExpression>
                    <primitiveExpression value="image/gif"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <propertyReferenceExpression name="ImageFormats"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Guid">
                      <propertyReferenceExpression name="Jpeg">
                        <typeReferenceExpression type="ImageFormat"/>
                      </propertyReferenceExpression>
                    </propertyReferenceExpression>
                    <primitiveExpression value="image/jpeg"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <propertyReferenceExpression name="ImageFormats"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Guid">
                      <propertyReferenceExpression name="Png">
                        <typeReferenceExpression type="ImageFormat"/>
                      </propertyReferenceExpression>
                    </propertyReferenceExpression>
                    <primitiveExpression value="image/png"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <propertyReferenceExpression name="ImageFormats"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Guid">
                      <propertyReferenceExpression name="Tiff">
                        <typeReferenceExpression type="ImageFormat"/>
                      </propertyReferenceExpression>
                    </propertyReferenceExpression>
                    <primitiveExpression value="image/tiff"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <propertyReferenceExpression name="ImageFormats"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Guid">
                      <propertyReferenceExpression name="Wmf">
                        <typeReferenceExpression type="ImageFormat"/>
                      </propertyReferenceExpression>
                    </propertyReferenceExpression>
                    <primitiveExpression value="image/Wmf"/>
                  </parameters>
                </methodInvokeExpression>
              </statements>
            </typeConstructor>
            <!-- method CopyToOutput -->
            <memberMethod name="CopyToOutput">
              <attributes private="true" final="true"/>
              <parameters>
                <parameter type="HttpContext" name="context"/>
                <parameter type="Stream" name="stream"/>
                <parameter type="BlobHandlerInfo" name="handler"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.Int32" name="offset">
                  <init>
                    <primitiveExpression value="0"/>
                  </init>
                </variableDeclarationStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Position">
                    <variableReferenceExpression name="stream"/>
                  </propertyReferenceExpression>
                  <variableReferenceExpression name="offset"/>
                </assignStatement>
                <variableDeclarationStatement type="System.Byte[]" name="buffer">
                  <init>
                    <primitiveExpression value="null"/>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="Image" name="img">
                  <init>
                    <primitiveExpression value="null"/>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.Int64" name="streamLength">
                  <init>
                    <propertyReferenceExpression name="Length">
                      <argumentReferenceExpression name="stream"/>
                    </propertyReferenceExpression>
                  </init>
                </variableDeclarationStatement>
                <comment>attempt to auto-detect content type as an image</comment>
                <variableDeclarationStatement type="System.String" name="contentType">
                  <init>
                    <propertyReferenceExpression name="ContentType">
                      <argumentReferenceExpression name="handler"/>
                    </propertyReferenceExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <binaryOperatorExpression operator="BooleanOr">
                        <unaryOperatorExpression operator="IsNullOrEmpty">
                          <variableReferenceExpression name="contentType"/>
                        </unaryOperatorExpression>
                        <methodInvokeExpression methodName="StartsWith">
                          <target>
                            <variableReferenceExpression name="contentType"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="image/"/>
                          </parameters>
                        </methodInvokeExpression>
                      </binaryOperatorExpression>
                      <binaryOperatorExpression operator="GreaterThan">
                        <propertyReferenceExpression name="Length">
                          <argumentReferenceExpression name="stream"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="0"/>
                      </binaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <tryStatement>
                      <statements>
                        <assignStatement>
                          <variableReferenceExpression name="img"/>
                          <methodInvokeExpression methodName="FromStream">
                            <target>
                              <typeReferenceExpression type="Image"/>
                            </target>
                            <parameters>
                              <argumentReferenceExpression name="stream"/>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                      </statements>
                      <catch exceptionType="Exception">
                        <tryStatement>
                          <statements>
                            <comment>Correction for Northwind database image format</comment>
                            <assignStatement>
                              <variableReferenceExpression name="offset"/>
                              <primitiveExpression value="78"/>
                            </assignStatement>
                            <assignStatement>
                              <variableReferenceExpression name="streamLength"/>
                              <binaryOperatorExpression operator="Subtract">
                                <variableReferenceExpression name="streamLength"/>
                                <primitiveExpression value="78"/>
                              </binaryOperatorExpression>
                            </assignStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="Position">
                                <argumentReferenceExpression name="stream"/>
                              </propertyReferenceExpression>
                              <variableReferenceExpression name="offset"/>
                            </assignStatement>
                            <assignStatement>
                              <variableReferenceExpression name="buffer"/>
                              <arrayCreateExpression>
                                <createType type="System.Byte"/>
                                <sizeExpression>
                                  <binaryOperatorExpression operator="Subtract">
                                    <propertyReferenceExpression name="Length">
                                      <argumentReferenceExpression name="stream"/>
                                    </propertyReferenceExpression>
                                    <variableReferenceExpression name="offset"/>
                                  </binaryOperatorExpression>
                                </sizeExpression>
                              </arrayCreateExpression>
                            </assignStatement>
                            <methodInvokeExpression methodName="Read">
                              <target>
                                <argumentReferenceExpression name="stream"/>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="buffer"/>
                                <primitiveExpression value="0"/>
                                <propertyReferenceExpression name="Length">
                                  <variableReferenceExpression name="buffer"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                            <assignStatement>
                              <variableReferenceExpression name="img"/>
                              <methodInvokeExpression methodName="FromStream">
                                <target>
                                  <typeReferenceExpression type="Image"/>
                                </target>
                                <parameters>
                                  <objectCreateExpression type="MemoryStream">
                                    <parameters>
                                      <variableReferenceExpression name="buffer"/>
                                      <primitiveExpression value="0"/>
                                      <propertyReferenceExpression name="Length">
                                        <variableReferenceExpression name="buffer"/>
                                      </propertyReferenceExpression>
                                    </parameters>
                                  </objectCreateExpression>
                                </parameters>
                              </methodInvokeExpression>
                            </assignStatement>
                          </statements>
                          <catch exceptionType="Exception" localName="ex">
                            <!-- context.Trace.Write(ex.ToString()); -->
                            <methodInvokeExpression methodName="Write">
                              <target>
                                <propertyReferenceExpression name="Trace">
                                  <argumentReferenceExpression name="context"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <methodInvokeExpression methodName="ToString">
                                  <target>
                                    <variableReferenceExpression name="ex"/>
                                  </target>
                                </methodInvokeExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </catch>
                        </tryStatement>
                      </catch>
                    </tryStatement>
                  </trueStatements>
                </conditionStatement>
                <comment>send an original or a thumbnail to the output</comment>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <propertyReferenceExpression name="Mode">
                        <argumentReferenceExpression name="handler"/>
                      </propertyReferenceExpression>
                      <propertyReferenceExpression name="Thumbnail">
                        <typeReferenceExpression type="BlobMode"/>
                      </propertyReferenceExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <comment>draw a thumbnail</comment>
                    <variableDeclarationStatement type="System.Int32" name="thumbWidth">
                      <init>
                        <primitiveExpression value="92"/>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="System.Int32" name="thumbHeight">
                      <init>
                        <primitiveExpression value="64"/>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="System.Boolean" name="crop">
                      <init>
                        <primitiveExpression value="false"/>
                      </init>
                    </variableDeclarationStatement>
                    <xsl:if test="$Mobile='true'">
                      <conditionStatement>
                        <condition>
                          <propertyReferenceExpression name="IsMobileClient">
                            <typeReferenceExpression type="ApplicationServices"/>
                          </propertyReferenceExpression>
                        </condition>
                        <trueStatements>
                          <assignStatement>
                            <variableReferenceExpression name="thumbWidth"/>
                            <primitiveExpression value="80"/>
                          </assignStatement>
                          <assignStatement>
                            <variableReferenceExpression name="thumbHeight"/>
                            <primitiveExpression value="80"/>
                          </assignStatement>
                          <assignStatement>
                            <variableReferenceExpression name="crop"/>
                            <unaryOperatorExpression operator="Not">
                              <methodInvokeExpression methodName="Contains">
                                <target>
                                  <propertyReferenceExpression name="RawUrl">
                                    <propertyReferenceExpression name="Request">
                                      <argumentReferenceExpression name="context"/>
                                    </propertyReferenceExpression>
                                  </propertyReferenceExpression>
                                </target>
                                <parameters>
                                  <primitiveExpression value="_nocrop"/>
                                </parameters>
                              </methodInvokeExpression>
                            </unaryOperatorExpression>
                          </assignStatement>
                        </trueStatements>
                      </conditionStatement>
                    </xsl:if>
                    <variableDeclarationStatement type="Bitmap" name="thumbnail">
                      <init>
                        <objectCreateExpression type="Bitmap">
                          <parameters>
                            <variableReferenceExpression name="thumbWidth"/>
                            <variableReferenceExpression name="thumbHeight"/>
                          </parameters>
                        </objectCreateExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="Graphics" name="g">
                      <init>
                        <methodInvokeExpression methodName="FromImage">
                          <target>
                            <typeReferenceExpression type="Graphics"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="thumbnail"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="Rectangle" name="r">
                      <init>
                        <objectCreateExpression type="Rectangle">
                          <parameters>
                            <primitiveExpression value="0"/>
                            <primitiveExpression value="0"/>
                            <variableReferenceExpression name="thumbWidth"/>
                            <variableReferenceExpression name="thumbHeight"/>
                          </parameters>
                        </objectCreateExpression>
                      </init>
                    </variableDeclarationStatement>
                    <methodInvokeExpression methodName="FillRectangle">
                      <target>
                        <variableReferenceExpression name="g"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="Transparent">
                          <typeReferenceExpression type="Brushes"/>
                        </propertyReferenceExpression>
                        <variableReferenceExpression name="r"/>
                      </parameters>
                    </methodInvokeExpression>
                    <!--<methodInvokeExpression methodName="DrawRectangle">
                      <target>
                        <variableReferenceExpression name="g"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="Silver">
                          <typeReferenceExpression type="Pens"/>
                        </propertyReferenceExpression>
                        <variableReferenceExpression name="r"/>
                      </parameters>
                    </methodInvokeExpression>-->
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityInequality">
                          <variableReferenceExpression name="img"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="System.Double" name="thumbnailAspect">
                          <init>
                            <binaryOperatorExpression operator="Divide">
                              <methodInvokeExpression methodName="ToDouble">
                                <target>
                                  <typeReferenceExpression type="Convert"/>
                                </target>
                                <parameters>
                                  <propertyReferenceExpression name="Height">
                                    <variableReferenceExpression name="r"/>
                                  </propertyReferenceExpression>
                                </parameters>
                              </methodInvokeExpression>
                              <methodInvokeExpression methodName="ToDouble">
                                <target>
                                  <typeReferenceExpression type="Convert"/>
                                </target>
                                <parameters>
                                  <propertyReferenceExpression name="Width">
                                    <variableReferenceExpression name="r"/>
                                  </propertyReferenceExpression>
                                </parameters>
                              </methodInvokeExpression>
                            </binaryOperatorExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="BooleanAnd">
                              <binaryOperatorExpression operator="LessThan">
                                <propertyReferenceExpression name="Width">
                                  <variableReferenceExpression name="img"/>
                                </propertyReferenceExpression>
                                <propertyReferenceExpression name="Width">
                                  <variableReferenceExpression name="r"/>
                                </propertyReferenceExpression>
                              </binaryOperatorExpression>
                              <binaryOperatorExpression operator="LessThan">
                                <propertyReferenceExpression name="Height">
                                  <variableReferenceExpression name="img"/>
                                </propertyReferenceExpression>
                                <propertyReferenceExpression name="Height">
                                  <variableReferenceExpression name="r"/>
                                </propertyReferenceExpression>
                              </binaryOperatorExpression>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="Width">
                                <variableReferenceExpression name="r"/>
                              </propertyReferenceExpression>
                              <propertyReferenceExpression name="Width">
                                <variableReferenceExpression name="img"/>
                              </propertyReferenceExpression>
                            </assignStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="Height">
                                <variableReferenceExpression name="r"/>
                              </propertyReferenceExpression>
                              <propertyReferenceExpression name="Height">
                                <variableReferenceExpression name="img"/>
                              </propertyReferenceExpression>
                            </assignStatement>
                          </trueStatements>
                          <falseStatements>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator ="GreaterThan">
                                  <propertyReferenceExpression name="Width">
                                    <variableReferenceExpression name="img"/>
                                  </propertyReferenceExpression>
                                  <propertyReferenceExpression name="Height">
                                    <variableReferenceExpression name="img"/>
                                  </propertyReferenceExpression>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <propertyReferenceExpression name="Height">
                                    <variableReferenceExpression name="r"/>
                                  </propertyReferenceExpression>
                                  <methodInvokeExpression methodName="ToInt32">
                                    <target>
                                      <typeReferenceExpression type="Convert"/>
                                    </target>
                                    <parameters>
                                      <binaryOperatorExpression operator="Multiply">
                                        <methodInvokeExpression methodName="ToDouble">
                                          <target>
                                            <typeReferenceExpression type="Convert"/>
                                          </target>
                                          <parameters>
                                            <propertyReferenceExpression name="Width">
                                              <variableReferenceExpression name="r"/>
                                            </propertyReferenceExpression>
                                          </parameters>
                                        </methodInvokeExpression>
                                        <variableReferenceExpression name="thumbnailAspect"/>
                                      </binaryOperatorExpression>
                                    </parameters>
                                  </methodInvokeExpression>
                                </assignStatement>
                                <assignStatement>
                                  <propertyReferenceExpression name="Width">
                                    <variableReferenceExpression name="r"/>
                                  </propertyReferenceExpression>
                                  <methodInvokeExpression methodName="ToInt32">
                                    <target>
                                      <typeReferenceExpression type="Convert"/>
                                    </target>
                                    <parameters>
                                      <binaryOperatorExpression operator="Multiply">
                                        <methodInvokeExpression methodName="ToDouble">
                                          <target>
                                            <typeReferenceExpression type="Convert"/>
                                          </target>
                                          <parameters>
                                            <propertyReferenceExpression name="Height">
                                              <variableReferenceExpression name="r"/>
                                            </propertyReferenceExpression>
                                          </parameters>
                                        </methodInvokeExpression>
                                        <binaryOperatorExpression operator="Divide">
                                          <methodInvokeExpression methodName="ToDouble">
                                            <target>
                                              <typeReferenceExpression type="Convert"/>
                                            </target>
                                            <parameters>
                                              <propertyReferenceExpression name="Width">
                                                <variableReferenceExpression name="img"/>
                                              </propertyReferenceExpression>
                                            </parameters>
                                          </methodInvokeExpression>
                                          <methodInvokeExpression methodName="ToDouble">
                                            <target>
                                              <typeReferenceExpression type="Convert"/>
                                            </target>
                                            <parameters>
                                              <propertyReferenceExpression name="Height">
                                                <variableReferenceExpression name="img"/>
                                              </propertyReferenceExpression>
                                            </parameters>
                                          </methodInvokeExpression>
                                        </binaryOperatorExpression>
                                      </binaryOperatorExpression>
                                    </parameters>
                                  </methodInvokeExpression>
                                </assignStatement>
                              </trueStatements>
                              <falseStatements>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="GreaterThan">
                                      <propertyReferenceExpression name="Height">
                                        <variableReferenceExpression name="img"/>
                                      </propertyReferenceExpression>
                                      <propertyReferenceExpression name="Width">
                                        <variableReferenceExpression name="img"/>
                                      </propertyReferenceExpression>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <assignStatement>
                                      <variableReferenceExpression name="thumbnailAspect"/>
                                      <binaryOperatorExpression operator="Divide">
                                        <methodInvokeExpression methodName="ToDouble">
                                          <target>
                                            <typeReferenceExpression type="Convert"/>
                                          </target>
                                          <parameters>
                                            <propertyReferenceExpression name="Width">
                                              <variableReferenceExpression name="r"/>
                                            </propertyReferenceExpression>
                                          </parameters>
                                        </methodInvokeExpression>
                                        <methodInvokeExpression methodName="ToDouble">
                                          <target>
                                            <typeReferenceExpression type="Convert"/>
                                          </target>
                                          <parameters>
                                            <propertyReferenceExpression name="Height">
                                              <variableReferenceExpression name="r"/>
                                            </propertyReferenceExpression>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </binaryOperatorExpression>
                                    </assignStatement>
                                    <assignStatement>
                                      <propertyReferenceExpression name="Width">
                                        <variableReferenceExpression name="r"/>
                                      </propertyReferenceExpression>
                                      <methodInvokeExpression methodName="ToInt32">
                                        <target>
                                          <typeReferenceExpression type="Convert"/>
                                        </target>
                                        <parameters>
                                          <binaryOperatorExpression operator="Multiply">
                                            <methodInvokeExpression methodName="ToDouble">
                                              <target>
                                                <typeReferenceExpression type="Convert"/>
                                              </target>
                                              <parameters>
                                                <propertyReferenceExpression name="Height">
                                                  <variableReferenceExpression name="r"/>
                                                </propertyReferenceExpression>
                                              </parameters>
                                            </methodInvokeExpression>
                                            <variableReferenceExpression name="thumbnailAspect"/>
                                          </binaryOperatorExpression>
                                        </parameters>
                                      </methodInvokeExpression>
                                    </assignStatement>
                                    <assignStatement>
                                      <propertyReferenceExpression name="Height">
                                        <variableReferenceExpression name="r"/>
                                      </propertyReferenceExpression>
                                      <methodInvokeExpression methodName="ToInt32">
                                        <target>
                                          <typeReferenceExpression type="Convert"/>
                                        </target>
                                        <parameters>
                                          <binaryOperatorExpression operator="Multiply">
                                            <methodInvokeExpression methodName="ToDouble">
                                              <target>
                                                <typeReferenceExpression type="Convert"/>
                                              </target>
                                              <parameters>
                                                <propertyReferenceExpression name="Width">
                                                  <variableReferenceExpression name="r"/>
                                                </propertyReferenceExpression>
                                              </parameters>
                                            </methodInvokeExpression>
                                            <binaryOperatorExpression operator="Divide">
                                              <methodInvokeExpression methodName="ToDouble">
                                                <target>
                                                  <typeReferenceExpression type="Convert"/>
                                                </target>
                                                <parameters>
                                                  <propertyReferenceExpression name="Height">
                                                    <variableReferenceExpression name="img"/>
                                                  </propertyReferenceExpression>
                                                </parameters>
                                              </methodInvokeExpression>
                                              <methodInvokeExpression methodName="ToDouble">
                                                <target>
                                                  <typeReferenceExpression type="Convert"/>
                                                </target>
                                                <parameters>
                                                  <propertyReferenceExpression name="Width">
                                                    <variableReferenceExpression name="img"/>
                                                  </propertyReferenceExpression>
                                                </parameters>
                                              </methodInvokeExpression>
                                            </binaryOperatorExpression>
                                          </binaryOperatorExpression>
                                        </parameters>
                                      </methodInvokeExpression>
                                    </assignStatement>
                                  </trueStatements>
                                  <falseStatements>
                                    <assignStatement>
                                      <propertyReferenceExpression name="Width">
                                        <variableReferenceExpression name="r"/>
                                      </propertyReferenceExpression>
                                      <methodInvokeExpression methodName="ToInt32">
                                        <target>
                                          <typeReferenceExpression type="Convert"/>
                                        </target>
                                        <parameters>
                                          <binaryOperatorExpression operator="Multiply">
                                            <methodInvokeExpression methodName="ToDouble">
                                              <target>
                                                <typeReferenceExpression type="Convert"/>
                                              </target>
                                              <parameters>
                                                <propertyReferenceExpression name="Height">
                                                  <variableReferenceExpression name="img"/>
                                                </propertyReferenceExpression>
                                              </parameters>
                                            </methodInvokeExpression>
                                            <variableReferenceExpression name="thumbnailAspect"/>
                                          </binaryOperatorExpression>
                                        </parameters>
                                      </methodInvokeExpression>
                                    </assignStatement>
                                    <assignStatement>
                                      <propertyReferenceExpression name="Height">
                                        <variableReferenceExpression name="r"/>
                                      </propertyReferenceExpression>
                                      <propertyReferenceExpression name="Width">
                                        <variableReferenceExpression name="r"/>
                                      </propertyReferenceExpression>
                                    </assignStatement>
                                  </falseStatements>
                                </conditionStatement>
                              </falseStatements>
                            </conditionStatement>

                          </falseStatements>
                        </conditionStatement>
                        <variableDeclarationStatement type="System.Double" name="aspect">
                          <init>
                            <binaryOperatorExpression operator="Divide">
                              <methodInvokeExpression methodName="ToDouble">
                                <target>
                                  <typeReferenceExpression type="Convert"/>
                                </target>
                                <parameters>
                                  <propertyReferenceExpression name="Width">
                                    <variableReferenceExpression name="thumbnail"/>
                                  </propertyReferenceExpression>
                                </parameters>
                              </methodInvokeExpression>
                              <propertyReferenceExpression name="Width">
                                <variableReferenceExpression name="r"/>
                              </propertyReferenceExpression>
                            </binaryOperatorExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="LessThanOrEqual">
                              <propertyReferenceExpression name="Width">
                                <variableReferenceExpression name="r"/>
                              </propertyReferenceExpression>
                              <propertyReferenceExpression name="Height">
                                <variableReferenceExpression name="r"/>
                              </propertyReferenceExpression>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="aspect"/>
                              <binaryOperatorExpression operator="Divide">
                                <methodInvokeExpression methodName="ToDouble">
                                  <target>
                                    <typeReferenceExpression type="Convert"/>
                                  </target>
                                  <parameters>
                                    <propertyReferenceExpression name="Height">
                                      <variableReferenceExpression name="thumbnail"/>
                                    </propertyReferenceExpression>
                                  </parameters>
                                </methodInvokeExpression>
                                <propertyReferenceExpression name="Height">
                                  <variableReferenceExpression name="r"/>
                                </propertyReferenceExpression>
                              </binaryOperatorExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="GreaterThan">
                              <variableReferenceExpression name="aspect"/>
                              <primitiveExpression value="1"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="aspect"/>
                              <primitiveExpression value="1"/>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <assignStatement>
                          <propertyReferenceExpression name="Width">
                            <variableReferenceExpression name="r"/>
                          </propertyReferenceExpression>
                          <methodInvokeExpression methodName="ToInt32">
                            <target>
                              <typeReferenceExpression type="Convert"/>
                            </target>
                            <parameters>
                              <binaryOperatorExpression operator="Multiply">
                                <methodInvokeExpression methodName="ToDouble">
                                  <target>
                                    <typeReferenceExpression type="Convert"/>
                                  </target>
                                  <parameters>
                                    <propertyReferenceExpression name="Width">
                                      <variableReferenceExpression name="r"/>
                                    </propertyReferenceExpression>
                                  </parameters>
                                </methodInvokeExpression>
                                <variableReferenceExpression name="aspect"/>
                              </binaryOperatorExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                        <assignStatement>
                          <propertyReferenceExpression name="Height">
                            <variableReferenceExpression name="r"/>
                          </propertyReferenceExpression>
                          <methodInvokeExpression methodName="ToInt32">
                            <target>
                              <typeReferenceExpression type="Convert"/>
                            </target>
                            <parameters>
                              <binaryOperatorExpression operator="Multiply">
                                <methodInvokeExpression methodName="ToDouble">
                                  <target>
                                    <typeReferenceExpression type="Convert"/>
                                  </target>
                                  <parameters>
                                    <propertyReferenceExpression name="Height">
                                      <variableReferenceExpression name="r"/>
                                    </propertyReferenceExpression>
                                  </parameters>
                                </methodInvokeExpression>
                                <variableReferenceExpression name="aspect"/>
                              </binaryOperatorExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                        <!-- 
                    if (crop)
                        if (r.Width > r.Height)
                            r.Inflate(r.Width - r.Height, Convert.ToInt32(Convert.ToDouble(r.Width - r.Height) * aspect));
                        else if (r.Width < r.Height)
                            r.Inflate(Convert.ToInt32(Convert.ToDouble(r.Height - r.Width) * aspect), r.Height - r.Width);
                        -->
                        <conditionStatement>
                          <condition>
                            <variableReferenceExpression name="crop"/>
                          </condition>
                          <trueStatements>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="GreaterThan">
                                  <propertyReferenceExpression name="Width">
                                    <variableReferenceExpression name="r"/>
                                  </propertyReferenceExpression>
                                  <propertyReferenceExpression name="Height">
                                    <variableReferenceExpression name="r"/>
                                  </propertyReferenceExpression>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <methodInvokeExpression methodName="Inflate">
                                  <target>
                                    <variableReferenceExpression name="r"/>
                                  </target>
                                  <parameters>
                                    <binaryOperatorExpression operator="Subtract">
                                      <propertyReferenceExpression name="Width">
                                        <variableReferenceExpression name="r"/>
                                      </propertyReferenceExpression>
                                      <propertyReferenceExpression name="Height">
                                        <variableReferenceExpression name="r"/>
                                      </propertyReferenceExpression>
                                    </binaryOperatorExpression>
                                    <convertExpression to="Int32">
                                      <binaryOperatorExpression operator="Multiply">
                                        <convertExpression to="Double">
                                          <binaryOperatorExpression operator="Subtract">
                                            <propertyReferenceExpression name="Width">
                                              <variableReferenceExpression name="r"/>
                                            </propertyReferenceExpression>
                                            <propertyReferenceExpression name="Height">
                                              <variableReferenceExpression name="r"/>
                                            </propertyReferenceExpression>
                                          </binaryOperatorExpression>
                                        </convertExpression>
                                        <variableReferenceExpression name="aspect"/>
                                      </binaryOperatorExpression>
                                    </convertExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </trueStatements>
                              <falseStatements>
                                <methodInvokeExpression methodName="Inflate">
                                  <target>
                                    <variableReferenceExpression name="r"/>
                                  </target>
                                  <parameters>
                                    <convertExpression to="Int32">
                                      <binaryOperatorExpression operator="Multiply">
                                        <convertExpression to="Double">
                                          <binaryOperatorExpression operator="Subtract">
                                            <propertyReferenceExpression name="Height">
                                              <variableReferenceExpression name="r"/>
                                            </propertyReferenceExpression>
                                            <propertyReferenceExpression name="Width">
                                              <variableReferenceExpression name="r"/>
                                            </propertyReferenceExpression>
                                          </binaryOperatorExpression>
                                        </convertExpression>
                                        <variableReferenceExpression name="aspect"/>
                                      </binaryOperatorExpression>
                                    </convertExpression>
                                    <binaryOperatorExpression operator="Subtract">
                                      <propertyReferenceExpression name="Height">
                                        <variableReferenceExpression name="r"/>
                                      </propertyReferenceExpression>
                                      <propertyReferenceExpression name="Width">
                                        <variableReferenceExpression name="r"/>
                                      </propertyReferenceExpression>
                                    </binaryOperatorExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </falseStatements>
                            </conditionStatement>
                          </trueStatements>
                        </conditionStatement>
                        <assignStatement>
                          <propertyReferenceExpression name="Location">
                            <variableReferenceExpression name="r"/>
                          </propertyReferenceExpression>
                          <objectCreateExpression type="Point">
                            <parameters>
                              <binaryOperatorExpression operator="Divide">
                                <binaryOperatorExpression operator="Subtract">
                                  <propertyReferenceExpression name="Width">
                                    <variableReferenceExpression name="thumbnail"/>
                                  </propertyReferenceExpression>
                                  <propertyReferenceExpression name="Width">
                                    <variableReferenceExpression name="r"/>
                                  </propertyReferenceExpression>
                                </binaryOperatorExpression>
                                <primitiveExpression value="2"/>
                              </binaryOperatorExpression>
                              <binaryOperatorExpression operator="Divide">
                                <binaryOperatorExpression operator="Subtract">
                                  <propertyReferenceExpression name="Height">
                                    <variableReferenceExpression name="thumbnail"/>
                                  </propertyReferenceExpression>
                                  <propertyReferenceExpression name="Height">
                                    <variableReferenceExpression name="r"/>
                                  </propertyReferenceExpression>
                                </binaryOperatorExpression>
                                <primitiveExpression value="2"/>
                              </binaryOperatorExpression>
                            </parameters>
                          </objectCreateExpression>
                        </assignStatement>
                        <assignStatement>
                          <propertyReferenceExpression name="InterpolationMode">
                            <variableReferenceExpression name="g"/>
                          </propertyReferenceExpression>
                          <propertyReferenceExpression name="HighQualityBicubic">
                            <typeReferenceExpression type="System.Drawing.Drawing2D.InterpolationMode"/>
                          </propertyReferenceExpression>
                        </assignStatement>
                        <methodInvokeExpression methodName="DrawImage">
                          <target>
                            <variableReferenceExpression name="g"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="img"/>
                            <variableReferenceExpression name="r"/>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                      <falseStatements>
                        <assignStatement>
                          <propertyReferenceExpression name="TextRenderingHint">
                            <variableReferenceExpression name="g"/>
                          </propertyReferenceExpression>
                          <propertyReferenceExpression name="ClearTypeGridFit">
                            <typeReferenceExpression type="System.Drawing.Text.TextRenderingHint"/>
                          </propertyReferenceExpression>
                        </assignStatement>
                        <variableDeclarationStatement type="Font" name="f">
                          <init>
                            <objectCreateExpression type="Font">
                              <parameters>
                                <primitiveExpression value="Arial"/>
                                <castExpression targetType="System.Single">
                                  <primitiveExpression value="7.5" culture="en-US"/>
                                </castExpression>
                              </parameters>
                            </objectCreateExpression>
                          </init>
                        </variableDeclarationStatement>
                        <variableDeclarationStatement type="System.String" name="text">
                          <init>
                            <propertyReferenceExpression name="FileName">
                              <variableReferenceExpression name="handler"/>
                            </propertyReferenceExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <unaryOperatorExpression operator="IsNullOrEmpty">
                              <variableReferenceExpression name="text"/>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="text"/>
                              <propertyReferenceExpression name="Text">
                                <variableReferenceExpression name="handler"/>
                              </propertyReferenceExpression>
                            </assignStatement>
                          </trueStatements>
                          <falseStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="text"/>
                              <methodInvokeExpression methodName="GetExtension">
                                <target>
                                  <typeReferenceExpression type="Path"/>
                                </target>
                                <parameters>
                                  <variableReferenceExpression name="text"/>
                                </parameters>
                              </methodInvokeExpression>
                            </assignStatement>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="BooleanAnd">
                                  <methodInvokeExpression methodName="StartsWith">
                                    <target>
                                      <variableReferenceExpression name="text"/>
                                    </target>
                                    <parameters>
                                      <primitiveExpression value="."/>
                                    </parameters>
                                  </methodInvokeExpression>
                                  <binaryOperatorExpression operator="GreaterThan">
                                    <propertyReferenceExpression name="Length">
                                      <variableReferenceExpression name="text"/>
                                    </propertyReferenceExpression>
                                    <primitiveExpression value="1"/>
                                  </binaryOperatorExpression>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="text"/>
                                  <methodInvokeExpression methodName="ToUpper">
                                    <target>
                                      <methodInvokeExpression methodName="Substring">
                                        <target>
                                          <variableReferenceExpression name="text"/>
                                        </target>
                                        <parameters>
                                          <primitiveExpression value="1"/>
                                        </parameters>
                                      </methodInvokeExpression>
                                    </target>
                                  </methodInvokeExpression>
                                </assignStatement>
                                <assignStatement>
                                  <variableReferenceExpression name="f"/>
                                  <objectCreateExpression type="Font">
                                    <parameters>
                                      <primitiveExpression value="Arial"/>
                                      <castExpression targetType="System.Single">
                                        <primitiveExpression value="12"/>
                                      </castExpression>
                                      <propertyReferenceExpression name="Bold">
                                        <typeReferenceExpression type="FontStyle"/>
                                      </propertyReferenceExpression>
                                    </parameters>
                                  </objectCreateExpression>
                                </assignStatement>
                              </trueStatements>
                            </conditionStatement>
                          </falseStatements>
                        </conditionStatement>
                        <methodInvokeExpression methodName="DrawString">
                          <target>
                            <variableReferenceExpression name="g"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="text"/>
                            <variableReferenceExpression name="f"/>
                            <propertyReferenceExpression name="Black">
                              <typeReferenceExpression type="Brushes"/>
                            </propertyReferenceExpression>
                            <variableReferenceExpression name="r"/>
                          </parameters>
                        </methodInvokeExpression>
                      </falseStatements>
                    </conditionStatement>
                    <comment>produce thumbnail data</comment>
                    <variableDeclarationStatement type="MemoryStream" name="ts">
                      <init>
                        <objectCreateExpression type="MemoryStream"/>
                      </init>
                    </variableDeclarationStatement>
                    <methodInvokeExpression methodName="Save">
                      <target>
                        <variableReferenceExpression name="thumbnail"/>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="ts"/>
                        <propertyReferenceExpression name="Png">
                          <typeReferenceExpression type="ImageFormat"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="Flush">
                      <target>
                        <variableReferenceExpression name="ts"/>
                      </target>
                    </methodInvokeExpression>
                    <assignStatement>
                      <propertyReferenceExpression name="Position">
                        <variableReferenceExpression name="ts"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="0"/>
                    </assignStatement>
                    <variableDeclarationStatement type="System.Byte[]" name="td">
                      <init>
                        <arrayCreateExpression>
                          <createType type="System.Byte"/>
                          <sizeExpression>
                            <propertyReferenceExpression name="Length">
                              <variableReferenceExpression name="ts"/>
                            </propertyReferenceExpression>
                          </sizeExpression>
                        </arrayCreateExpression>
                      </init>
                    </variableDeclarationStatement>
                    <methodInvokeExpression methodName="Read">
                      <target>
                        <variableReferenceExpression name="ts"/>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="td"/>
                        <primitiveExpression value="0"/>
                        <propertyReferenceExpression name="Length">
                          <variableReferenceExpression name="td"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="Close">
                      <target>
                        <variableReferenceExpression name="ts"/>
                      </target>
                    </methodInvokeExpression>
                    <comment>Send thumbnail to the output</comment>
                    <methodInvokeExpression methodName="AddHeader">
                      <target>
                        <propertyReferenceExpression name="Response">
                          <argumentReferenceExpression name="context"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <primitiveExpression value="Content-Length"/>
                        <methodInvokeExpression methodName="ToString">
                          <target>
                            <propertyReferenceExpression name="Length">
                              <variableReferenceExpression name="td"/>
                            </propertyReferenceExpression>
                          </target>
                        </methodInvokeExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <assignStatement>
                      <propertyReferenceExpression name="ContentType">
                        <propertyReferenceExpression name="Response">
                          <argumentReferenceExpression name="context"/>
                        </propertyReferenceExpression>
                      </propertyReferenceExpression>
                      <primitiveExpression value="image/png"/>
                    </assignStatement>
                    <methodInvokeExpression methodName="Write">
                      <target>
                        <propertyReferenceExpression name="OutputStream">
                          <propertyReferenceExpression name="Response">
                            <argumentReferenceExpression name="context"/>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="td"/>
                        <primitiveExpression value="0"/>
                        <propertyReferenceExpression name="Length">
                          <variableReferenceExpression name="td"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityEquality">
                          <variableReferenceExpression name="img"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="SetCacheability">
                          <target>
                            <propertyReferenceExpression name="Cache">
                              <propertyReferenceExpression name="Response">
                                <argumentReferenceExpression name="context"/>
                              </propertyReferenceExpression>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="NoCache">
                              <typeReferenceExpression type="HttpCacheability"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                      <falseStatements>
                        <methodInvokeExpression methodName="SetCacheability">
                          <target>
                            <propertyReferenceExpression name="Cache">
                              <propertyReferenceExpression name="Response">
                                <argumentReferenceExpression name="context"/>
                              </propertyReferenceExpression>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="Public">
                              <typeReferenceExpression type="HttpCacheability"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                        <methodInvokeExpression methodName="SetExpires">
                          <target>
                            <propertyReferenceExpression name="Cache">
                              <propertyReferenceExpression name="Response">
                                <argumentReferenceExpression name="context"/>
                              </propertyReferenceExpression>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <methodInvokeExpression methodName="AddMinutes">
                              <target>
                                <propertyReferenceExpression name="Now">
                                  <typeReferenceExpression type="DateTime"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <propertyReferenceExpression name="ThumbnailCacheTimeout">
                                  <typeReferenceExpression type="Blob"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </falseStatements>
                    </conditionStatement>
                  </trueStatements>
                  <falseStatements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanAnd">
                          <binaryOperatorExpression operator="IdentityInequality">
                            <variableReferenceExpression name="img"/>
                            <primitiveExpression value="null"/>
                          </binaryOperatorExpression>
                          <unaryOperatorExpression operator="IsNullOrEmpty">
                            <variableReferenceExpression name="contentType"/>
                          </unaryOperatorExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="contentType"/>
                          <arrayIndexerExpression>
                            <target>
                              <propertyReferenceExpression name="ImageFormats"/>
                            </target>
                            <indices>
                              <propertyReferenceExpression name="Guid">
                                <propertyReferenceExpression name="RawFormat">
                                  <variableReferenceExpression name="img"/>
                                </propertyReferenceExpression>
                              </propertyReferenceExpression>
                            </indices>
                          </arrayIndexerExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="IsNullOrEmpty">
                          <variableReferenceExpression name="contentType"/>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="contentType"/>
                          <primitiveExpression value="application/octet-stream"/>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                    <variableDeclarationStatement type="System.String" name="fileName">
                      <init>
                        <propertyReferenceExpression name="FileName">
                          <variableReferenceExpression name="handler"/>
                        </propertyReferenceExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="IsNullOrEmpty">
                          <variableReferenceExpression name="fileName"/>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="fileName"/>
                          <methodInvokeExpression methodName="Format">
                            <target>
                              <typeReferenceExpression type="String"/>
                            </target>
                            <parameters>
                              <primitiveExpression value="{{0}}{{1}}.{{2}}"/>
                              <propertyReferenceExpression name="Key">
                                <variableReferenceExpression name="handler"/>
                              </propertyReferenceExpression>
                              <propertyReferenceExpression name="Reference">
                                <variableReferenceExpression name="handler"/>
                              </propertyReferenceExpression>
                              <methodInvokeExpression methodName="Substring">
                                <target>
                                  <variableReferenceExpression name="contentType"/>
                                </target>
                                <parameters>
                                  <binaryOperatorExpression operator="Add">
                                    <methodInvokeExpression methodName="IndexOf">
                                      <target>
                                        <variableReferenceExpression name="contentType"/>
                                      </target>
                                      <parameters>
                                        <primitiveExpression value="/"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                    <primitiveExpression value="1"/>
                                  </binaryOperatorExpression>
                                </parameters>
                              </methodInvokeExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                    <assignStatement>
                      <propertyReferenceExpression name="ContentType">
                        <propertyReferenceExpression name="Response">
                          <argumentReferenceExpression name="context"/>
                        </propertyReferenceExpression>
                      </propertyReferenceExpression>
                      <variableReferenceExpression name="contentType"/>
                    </assignStatement>
                    <methodInvokeExpression methodName="AddHeader">
                      <target>
                        <propertyReferenceExpression name="Response">
                          <argumentReferenceExpression name="context"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <primitiveExpression value="Content-Disposition"/>
                        <binaryOperatorExpression operator="Add">
                          <primitiveExpression value="filename="/>
                          <methodInvokeExpression methodName="UrlEncode">
                            <target>
                              <typeReferenceExpression type="HttpUtility"/>
                            </target>
                            <parameters>
                              <variableReferenceExpression name="fileName"/>
                            </parameters>
                          </methodInvokeExpression>
                        </binaryOperatorExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="AddHeader">
                      <target>
                        <propertyReferenceExpression name="Response">
                          <argumentReferenceExpression name="context"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <primitiveExpression value="Content-Length"/>
                        <methodInvokeExpression methodName="ToString">
                          <target>
                            <variableReferenceExpression name="streamLength"/>
                          </target>
                        </methodInvokeExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="ValueEquality">
                          <propertyReferenceExpression name="Length">
                            <variableReferenceExpression name="stream"/>
                          </propertyReferenceExpression>
                          <primitiveExpression value="0"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <propertyReferenceExpression name="StatusCode">
                            <propertyReferenceExpression name="Response">
                              <argumentReferenceExpression name="context"/>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                          <primitiveExpression value="404"/>
                        </assignStatement>
                        <methodReturnStatement/>
                      </trueStatements>
                    </conditionStatement>
                    <assignStatement>
                      <propertyReferenceExpression name="Position">
                        <argumentReferenceExpression name="stream"/>
                      </propertyReferenceExpression>
                      <variableReferenceExpression name="offset"/>
                    </assignStatement>
                    <assignStatement>
                      <variableReferenceExpression name="buffer"/>
                      <arrayCreateExpression>
                        <createType type="System.Byte"/>
                        <sizeExpression>
                          <binaryOperatorExpression operator="Multiply">
                            <primitiveExpression value="1024"/>
                            <primitiveExpression value="32"/>
                          </binaryOperatorExpression>
                        </sizeExpression>
                      </arrayCreateExpression>
                    </assignStatement>
                    <variableDeclarationStatement type="System.Int32" name="bytesRead">
                      <init>
                        <methodInvokeExpression methodName="Read">
                          <target>
                            <argumentReferenceExpression name="stream"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="buffer"/>
                            <primitiveExpression value="0"/>
                            <propertyReferenceExpression name="Length">
                              <variableReferenceExpression name="buffer"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <whileStatement>
                      <test>
                        <binaryOperatorExpression operator="GreaterThan">
                          <variableReferenceExpression name="bytesRead"/>
                          <primitiveExpression value="0"/>
                        </binaryOperatorExpression>
                      </test>
                      <statements>
                        <methodInvokeExpression methodName="Write">
                          <target>
                            <propertyReferenceExpression name="OutputStream">
                              <propertyReferenceExpression name="Response">
                                <argumentReferenceExpression name="context"/>
                              </propertyReferenceExpression>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="buffer"/>
                            <primitiveExpression value="0"/>
                            <variableReferenceExpression name="bytesRead"/>
                          </parameters>
                        </methodInvokeExpression>
                        <assignStatement>
                          <variableReferenceExpression name="offset"/>
                          <binaryOperatorExpression operator="Add">
                            <variableReferenceExpression name="offset"/>
                            <variableReferenceExpression name="bytesRead"/>
                          </binaryOperatorExpression>
                        </assignStatement>
                        <assignStatement>
                          <variableReferenceExpression name="bytesRead"/>
                          <methodInvokeExpression methodName="Read">
                            <target>
                              <argumentReferenceExpression name="stream"/>
                            </target>
                            <parameters>
                              <variableReferenceExpression name="buffer"/>
                              <primitiveExpression value="0"/>
                              <propertyReferenceExpression name="Length">
                                <variableReferenceExpression name="buffer"/>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                      </statements>
                    </whileStatement>
                  </falseStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method RenderUploader(HttpContext, BlobHandlerInfo, bool) -->
            <memberMethod name="RenderUploader">
              <attributes private="true" final="true"/>
              <parameters>
                <parameter type="HttpContext" name="context"/>
                <parameter type="BlobHandlerInfo" name="handler"/>
                <parameter type="System.Boolean" name="uploadSuccess"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="HtmlTextWriter" name="writer">
                  <init>
                    <objectCreateExpression type="HtmlTextWriter">
                      <parameters>
                        <propertyReferenceExpression name="Output">
                          <propertyReferenceExpression name="Response">
                            <argumentReferenceExpression name="context"/>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                      </parameters>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <methodInvokeExpression methodName="WriteLine">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <primitiveExpression>
                      <xsl:attribute name="value"><![CDATA[<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">]]></xsl:attribute>
                    </primitiveExpression>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="AddAttribute">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="xmlns"/>
                    <primitiveExpression value="http://www.w3.org/1999/xhtml"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="RenderBeginTag">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Html">
                      <typeReferenceExpression type="HtmlTextWriterTag"/>
                    </propertyReferenceExpression>
                  </parameters>
                </methodInvokeExpression>
                <comment>head</comment>
                <methodInvokeExpression methodName="RenderBeginTag">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Head">
                      <typeReferenceExpression type="HtmlTextWriterTag"/>
                    </propertyReferenceExpression>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="RenderBeginTag">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Title">
                      <typeReferenceExpression type="HtmlTextWriterTag"/>
                    </propertyReferenceExpression>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Write">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Uploader"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="RenderEndTag">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="AddAttribute">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Type">
                      <typeReferenceExpression type="HtmlTextWriterAttribute"/>
                    </propertyReferenceExpression>
                    <primitiveExpression value="text/javascript"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="RenderBeginTag">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Script">
                      <typeReferenceExpression type="HtmlTextWriterTag"/>
                    </propertyReferenceExpression>
                  </parameters>
                </methodInvokeExpression>
                <variableDeclarationStatement type="System.String" name="script">
                  <init>
                    <xsl:variable name="JavaScript" xml:space="preserve">
                      <![CDATA[ 
function ShowUploadControls() { 
    document.getElementById('UploadControlsPanel').style.display ='block'; 
    document.getElementById('StartUploadPanel').style.display = 'none';   
    document.getElementById('FileUpload').focus();      
} 
function Owner() {
    var m = window.location.href.match(/owner=(.+?)&/);
    return m ? parent.$find(m[1]) : null;
}
function StartUpload(msg) {
    if (msg && !window.confirm(msg)) return;
    if (parent && parent.window.Web) {
        var m = window.location.href.match(/&index=(\d+)$/);
        if (m) Owner()._showUploadProgress(m[1], document.forms[0]);
    }
}
function UploadSuccess(key, message) { 
    if (!Owner().get_isInserting())
        if (parent && parent.window.Web) { 
            parent.Web.DataView.showMessage(message); 
            Owner().refresh(false,null,'FIELD_NAME');
        }     
        else 
            alert('Success');
}]]></xsl:variable>
                    <primitiveExpression value="{ontime:NormalizeLineEndings($JavaScript)}"/>
                  </init>
                </variableDeclarationStatement>
                <methodInvokeExpression methodName="WriteLine">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <methodInvokeExpression methodName="Replace">
                      <target>
                        <variableReferenceExpression name="script"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="FIELD_NAME"/>
                        <methodInvokeExpression methodName="Format">
                          <target>
                            <propertyReferenceExpression name="String"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="^({{0}}|{{1}}|{{2}})?$"/>
                            <propertyReferenceExpression name="ContentTypeField">
                              <variableReferenceExpression name="handler"/>
                            </propertyReferenceExpression>
                            <propertyReferenceExpression name="FileNameField">
                              <variableReferenceExpression name="handler"/>
                            </propertyReferenceExpression>
                            <propertyReferenceExpression name="LengthField">
                              <variableReferenceExpression name="handler"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                        <!--<propertyReferenceExpression name="ControllerFieldName">
                          <variableReferenceExpression name="handler"/>
                        </propertyReferenceExpression>-->
                      </parameters>
                    </methodInvokeExpression>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="RenderEndTag">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="AddAttribute">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Type">
                      <typeReferenceExpression type="HtmlTextWriterAttribute"/>
                    </propertyReferenceExpression>
                    <primitiveExpression value="text/css"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="RenderBeginTag">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Style">
                      <typeReferenceExpression type="HtmlTextWriterTag"/>
                    </propertyReferenceExpression>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="WriteLine">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <primitiveExpression>
                      <xsl:attribute name="value">
                        <xsl:text>body{font-family:tahoma;font-size:8.5pt;margin:4px;background-color:white;}</xsl:text>
                      </xsl:attribute>
                    </primitiveExpression>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="WriteLine">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <primitiveExpression>
                      <xsl:attribute name="value">
                        <xsl:text>input{font-family:tahoma;font-size:8.5pt;}</xsl:text>
                      </xsl:attribute>
                    </primitiveExpression>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="WriteLine">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <primitiveExpression>
                      <xsl:attribute name="value">
                        <xsl:text>input.FileUpload{padding:3px}</xsl:text>
                      </xsl:attribute>
                    </primitiveExpression>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="RenderEndTag">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="RenderEndTag">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                </methodInvokeExpression>
                <comment>body</comment>
                <variableDeclarationStatement type="System.String" name="message">
                  <init>
                    <primitiveExpression value="null"/>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <argumentReferenceExpression name="uploadSuccess"/>
                  </condition>
                  <trueStatements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="GreaterThan">
                          <propertyReferenceExpression name="ContentLength">
                            <arrayIndexerExpression>
                              <target>
                                <propertyReferenceExpression name="Files">
                                  <propertyReferenceExpression name="Request">
                                    <propertyReferenceExpression name="Current">
                                      <typeReferenceExpression type="HttpContext"/>
                                    </propertyReferenceExpression>
                                  </propertyReferenceExpression>
                                </propertyReferenceExpression>
                              </target>
                              <indices>
                                <primitiveExpression value="0"/>
                              </indices>
                            </arrayIndexerExpression>
                          </propertyReferenceExpression>
                          <primitiveExpression value="0"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="message"/>
                          <methodInvokeExpression methodName="Format">
                            <target>
                              <typeReferenceExpression type="String"/>
                            </target>
                            <parameters>
                              <methodInvokeExpression methodName="Replace">
                                <target>
                                  <typeReferenceExpression type="Localizer"/>
                                </target>
                                <parameters>
                                  <primitiveExpression value="BlobUploded"/>
                                  <primitiveExpression>
                                    <xsl:attribute name="value"><![CDATA[<b>Confirmation:</b> {0} has been uploaded successfully. <b>It may take up to {1} minutes for the thumbnail to reflect the uploaded content.</b>]]></xsl:attribute>
                                  </primitiveExpression>
                                </parameters>
                              </methodInvokeExpression>
                              <methodInvokeExpression methodName="ToLower">
                                <target>
                                  <propertyReferenceExpression name="Text">
                                    <argumentReferenceExpression name="handler"/>
                                  </propertyReferenceExpression>
                                </target>
                              </methodInvokeExpression>
                              <propertyReferenceExpression name="ThumbnailCacheTimeout">
                                <typeReferenceExpression type="Blob"/>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                      </trueStatements>
                      <falseStatements>
                        <assignStatement>
                          <variableReferenceExpression name="message"/>
                          <methodInvokeExpression methodName="Format">
                            <target>
                              <typeReferenceExpression type="String"/>
                            </target>
                            <parameters>
                              <methodInvokeExpression methodName="Replace">
                                <target>
                                  <typeReferenceExpression type="Localizer"/>
                                </target>
                                <parameters>
                                  <primitiveExpression value="BlobCleared"/>
                                  <primitiveExpression>
                                    <xsl:attribute name="value"><![CDATA[<b>Confirmation:</b> {0} has been cleared.]]></xsl:attribute>
                                  </primitiveExpression>
                                </parameters>
                              </methodInvokeExpression>
                              <methodInvokeExpression methodName="ToLower">
                                <target>
                                  <propertyReferenceExpression name="Text">
                                    <argumentReferenceExpression name="handler"/>
                                  </propertyReferenceExpression>
                                </target>
                              </methodInvokeExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                      </falseStatements>
                    </conditionStatement>
                  </trueStatements>
                  <falseStatements>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="IsNotNullOrEmpty">
                          <propertyReferenceExpression name="Error">
                            <variableReferenceExpression name="handler"/>
                          </propertyReferenceExpression>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="message"/>
                          <methodInvokeExpression methodName="Format">
                            <target>
                              <typeReferenceExpression type="String"/>
                            </target>
                            <parameters>
                              <methodInvokeExpression methodName="Replace">
                                <target>
                                  <typeReferenceExpression type="Localizer"/>
                                </target>
                                <parameters>
                                  <primitiveExpression value="BlobUploadError"/>
                                  <primitiveExpression>
                                    <xsl:attribute name="value"><![CDATA[<b>Error:</b> failed to upload {0}. {1}]]></xsl:attribute>
                                  </primitiveExpression>
                                </parameters>
                              </methodInvokeExpression>
                              <methodInvokeExpression methodName="ToLower">
                                <target>
                                  <propertyReferenceExpression name="Text">
                                    <argumentReferenceExpression name="handler"/>
                                  </propertyReferenceExpression>
                                </target>
                              </methodInvokeExpression>
                              <methodInvokeExpression methodName="JavaScriptString">
                                <target>
                                  <typeReferenceExpression type="BusinessRules"/>
                                </target>
                                <parameters>
                                  <propertyReferenceExpression name="Error">
                                    <argumentReferenceExpression name="handler"/>
                                  </propertyReferenceExpression>
                                </parameters>
                              </methodInvokeExpression>
                              <!--<methodInvokeExpression methodName="Replace">
                                <target>
                                  <propertyReferenceExpression name="Error">
                                    <argumentReferenceExpression name="handler"/>
                                  </propertyReferenceExpression>
                                </target>
                                <parameters>
                                  <primitiveExpression value="'"/>
                                  <primitiveExpression value="\'"/>
                                </parameters>
                              </methodInvokeExpression>-->
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                  </falseStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="IsNotNullOrEmpty">
                      <variableReferenceExpression name="message"/>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="AddAttribute">
                      <target>
                        <variableReferenceExpression name="writer"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="onload"/>
                        <methodInvokeExpression methodName="Format">
                          <target>
                            <typeReferenceExpression type="String"/>
                          </target>
                          <parameters>
                            <primitiveExpression>
                              <xsl:attribute name="value"><![CDATA[UploadSuccess('{0}={1}', '{2}')]]></xsl:attribute>
                            </primitiveExpression>
                            <propertyReferenceExpression name="Key">
                              <argumentReferenceExpression name="handler"/>
                            </propertyReferenceExpression>
                            <methodInvokeExpression methodName="Replace">
                              <target>
                                <propertyReferenceExpression name="Value">
                                  <argumentReferenceExpression name="handler"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="u|"/>
                                <primitiveExpression value="t|"/>
                              </parameters>
                            </methodInvokeExpression>
                            <methodInvokeExpression methodName="JavaScriptString">
                              <target>
                                <typeReferenceExpression type="BusinessRules"/>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="message"/>
                              </parameters>
                            </methodInvokeExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <methodInvokeExpression methodName="RenderBeginTag">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Body">
                      <typeReferenceExpression type="HtmlTextWriterTag"/>
                    </propertyReferenceExpression>
                  </parameters>
                </methodInvokeExpression>
                <comment>form</comment>
                <methodInvokeExpression methodName="AddAttribute">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Name">
                      <typeReferenceExpression type="HtmlTextWriterAttribute"/>
                    </propertyReferenceExpression>
                    <primitiveExpression value="form1"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="AddAttribute">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="method"/>
                    <primitiveExpression value="post"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="AddAttribute">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="action"/>
                    <propertyReferenceExpression name="RawUrl">
                      <propertyReferenceExpression name="Request">
                        <argumentReferenceExpression name="context"/>
                      </propertyReferenceExpression>
                    </propertyReferenceExpression>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="AddAttribute">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Id">
                      <typeReferenceExpression type="HtmlTextWriterAttribute"/>
                    </propertyReferenceExpression>
                    <primitiveExpression value="form1"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="AddAttribute">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="enctype"/>
                    <primitiveExpression value="multipart/form-data"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="RenderBeginTag">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Form">
                      <typeReferenceExpression type="HtmlTextWriterTag"/>
                    </propertyReferenceExpression>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="RenderBeginTag">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Div">
                      <typeReferenceExpression type="HtmlTextWriterTag"/>
                    </propertyReferenceExpression>
                  </parameters>
                </methodInvokeExpression>
                <comment>begin "start upload" controls</comment>
                <methodInvokeExpression  methodName="AddAttribute">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Id">
                      <typeReferenceExpression type="HtmlTextWriterAttribute"/>
                    </propertyReferenceExpression>
                    <primitiveExpression value="StartUploadPanel"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="RenderBeginTag">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Div">
                      <typeReferenceExpression type="HtmlTextWriterTag"/>
                    </propertyReferenceExpression>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Write">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <methodInvokeExpression methodName="Replace">
                      <target>
                        <typeReferenceExpression type="Localizer"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="BlobUploadLinkPart1"/>
                        <primitiveExpression value="Click"/>
                      </parameters>
                    </methodInvokeExpression>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Write">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <primitiveExpression value=" "/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="AddAttribute">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Href">
                      <typeReferenceExpression type="HtmlTextWriterAttribute"/>
                    </propertyReferenceExpression>
                    <primitiveExpression value="#"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="AddAttribute">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Onclick">
                      <typeReferenceExpression type="HtmlTextWriterAttribute"/>
                    </propertyReferenceExpression>
                    <primitiveExpression value="ShowUploadControls();return false"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="RenderBeginTag">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="A">
                      <typeReferenceExpression type="HtmlTextWriterTag"/>
                    </propertyReferenceExpression>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Write">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <methodInvokeExpression methodName="Replace">
                      <target>
                        <typeReferenceExpression type="Localizer"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="BlobUploadLinkPart2"/>
                        <primitiveExpression value="here"/>
                      </parameters>
                    </methodInvokeExpression>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="RenderEndTag">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Write">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <primitiveExpression value=" "/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Write">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <methodInvokeExpression methodName="Replace">
                      <target>
                        <typeReferenceExpression type="Localizer"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="BlobUploadLinkPart3"/>
                        <primitiveExpression value="to upload or clear {{0}} file."/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="ToLower">
                      <target>
                        <propertyReferenceExpression name="Text">
                          <argumentReferenceExpression name="handler"/>
                        </propertyReferenceExpression>
                      </target>
                    </methodInvokeExpression>
                  </parameters>
                </methodInvokeExpression>
                <comment>end of "start upload" controls</comment>
                <methodInvokeExpression methodName="RenderEndTag">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                </methodInvokeExpression>
                <comment>begin "upload controls"</comment>
                <methodInvokeExpression methodName="AddAttribute">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Id">
                      <typeReferenceExpression type="HtmlTextWriterAttribute"/>
                    </propertyReferenceExpression>
                    <primitiveExpression value="UploadControlsPanel"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="AddAttribute">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Style">
                      <typeReferenceExpression type="HtmlTextWriterAttribute"/>
                    </propertyReferenceExpression>
                    <primitiveExpression value="display:none"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="RenderBeginTag">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Div">
                      <typeReferenceExpression type="HtmlTextWriterTag"/>
                    </propertyReferenceExpression>
                  </parameters>
                </methodInvokeExpression>
                <comment>"FileUpload" input</comment>
                <methodInvokeExpression methodName="AddAttribute">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Type">
                      <typeReferenceExpression type="HtmlTextWriterAttribute"/>
                    </propertyReferenceExpression>
                    <primitiveExpression value="File"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="AddAttribute">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Name">
                      <typeReferenceExpression type="HtmlTextWriterAttribute"/>
                    </propertyReferenceExpression>
                    <primitiveExpression value="FileUpload"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="AddAttribute">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Id">
                      <typeReferenceExpression type="HtmlTextWriterAttribute"/>
                    </propertyReferenceExpression>
                    <primitiveExpression value="FileUpload"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="AddAttribute">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Class">
                      <typeReferenceExpression type="HtmlTextWriterAttribute"/>
                    </propertyReferenceExpression>
                    <primitiveExpression value="FileUpload"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="AddAttribute">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Onchange">
                      <typeReferenceExpression type="HtmlTextWriterAttribute"/>
                    </propertyReferenceExpression>
                    <primitiveExpression value="StartUpload()"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="RenderBeginTag">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Input">
                      <typeReferenceExpression type="HtmlTextWriterTag"/>
                    </propertyReferenceExpression>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="RenderEndTag">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                </methodInvokeExpression>
                <comment>"FileClear" input</comment>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueInequality">
                      <arrayIndexerExpression>
                        <target>
                          <propertyReferenceExpression name="QueryString">
                            <propertyReferenceExpression name="Request">
                              <argumentReferenceExpression name="context"/>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                        </target>
                        <indices>
                          <propertyReferenceExpression name="Key">
                            <argumentReferenceExpression name="handler"/>
                          </propertyReferenceExpression>
                        </indices>
                      </arrayIndexerExpression>
                      <primitiveExpression value="u|"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="AddAttribute">
                      <target>
                        <variableReferenceExpression name="writer"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="Type">
                          <typeReferenceExpression type="HtmlTextWriterAttribute"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="button"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="AddAttribute">
                      <target>
                        <variableReferenceExpression name="writer"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="Id">
                          <typeReferenceExpression type="HtmlTextWriterAttribute"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="FileClear"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="AddAttribute">
                      <target>
                        <variableReferenceExpression name="writer"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="Class">
                          <typeReferenceExpression type="HtmlTextWriterAttribute"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="FileClear"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="AddAttribute">
                      <target>
                        <variableReferenceExpression name="writer"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="Onclick">
                          <typeReferenceExpression type="HtmlTextWriterAttribute"/>
                        </propertyReferenceExpression>
                        <methodInvokeExpression methodName="Format">
                          <target>
                            <typeReferenceExpression type="String"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="StartUpload('{{0}}')"/>
                            <methodInvokeExpression methodName="JavaScriptString">
                              <target>
                                <typeReferenceExpression type="BusinessRules"/>
                              </target>
                              <parameters>
                                <methodInvokeExpression methodName="Replace">
                                  <target>
                                    <typeReferenceExpression type="Localizer"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="BlobClearConfirm"/>
                                    <primitiveExpression value="Clear?"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </parameters>
                        </methodInvokeExpression>
                        <!--<primitiveExpression value="StartUpload('Clear?')"/>-->
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="AddAttribute">
                      <target>
                        <variableReferenceExpression name="writer"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="Value">
                          <typeReferenceExpression type="HtmlTextWriterAttribute"/>
                        </propertyReferenceExpression>
                        <methodInvokeExpression methodName="Replace">
                          <target>
                            <typeReferenceExpression type="Localizer"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="BlobClearText"/>
                            <primitiveExpression value="Clear"/>
                          </parameters>
                        </methodInvokeExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="RenderBeginTag">
                      <target>
                        <variableReferenceExpression name="writer"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="Input">
                          <typeReferenceExpression type="HtmlTextWriterTag"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="RenderEndTag">
                      <target>
                        <variableReferenceExpression name="writer"/>
                      </target>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <comment>end of "upload controls"</comment>
                <methodInvokeExpression methodName="RenderEndTag">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                </methodInvokeExpression>
                <comment>close "div"</comment>
                <methodInvokeExpression methodName="RenderEndTag">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                </methodInvokeExpression>
                <comment>close "form"</comment>
                <methodInvokeExpression methodName="RenderEndTag">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                </methodInvokeExpression>
                <comment>close "body"</comment>
                <methodInvokeExpression methodName="RenderEndTag">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                </methodInvokeExpression>
                <comment>close "html"</comment>
                <methodInvokeExpression methodName="RenderEndTag">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Close">
                  <target>
                    <variableReferenceExpression name="writer"/>
                  </target>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
        <!-- class BlobAdapterArguments-->
        <typeDeclaration name="BlobAdapterArguments">
          <attributes public="true"/>
          <baseTypes>
            <typeReference type="SortedDictionary">
              <typeArguments>
                <typeReference type="System.String"/>
                <typeReference type="System.String"/>
              </typeArguments>
            </typeReference>
          </baseTypes>
        </typeDeclaration>
        <!-- class BlobAdapterFactoryBase-->
        <typeDeclaration name="BlobAdapterFactoryBase">
          <attributes public="true"/>
          <members>
            <!-- field ArgumentParserRegex-->
            <memberField type="Regex" name="ArgumentParserRegex">
              <attributes public="true" static="true"/>
              <init>
                <objectCreateExpression type="Regex">
                  <parameters>
                    <primitiveExpression value="^\s*(?'ArgumentName'[\w\-]+)\s*:\s*(?'ArgumentValue'[\s\S]+?)\s*$"/>
                    <binaryOperatorExpression operator="BitwiseOr">
                      <propertyReferenceExpression name="Multiline">
                        <typeReferenceExpression type="RegexOptions"/>
                      </propertyReferenceExpression>
                      <propertyReferenceExpression name="IgnoreCase">
                        <typeReferenceExpression type="RegexOptions"/>
                      </propertyReferenceExpression>
                    </binaryOperatorExpression>
                  </parameters>
                </objectCreateExpression>
              </init>
            </memberField>
            <!-- method ParseAdapterConfig (string, string)-->
            <memberMethod returnType="BlobAdapterArguments" name="ParseAdapterConfig">
              <attributes family="true"/>
              <parameters>
                <parameter type="System.String" name="fieldName"/>
                <parameter type="System.String" name="config"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.Boolean" name="capture">
                  <init>
                    <primitiveExpression value="false"/>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="BlobAdapterArguments" name="args">
                  <init>
                    <objectCreateExpression type="BlobAdapterArguments"/>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="Match" name="m">
                  <init>
                    <methodInvokeExpression methodName="Match">
                      <target>
                        <propertyReferenceExpression name="ArgumentParserRegex"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="config"/>
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
                    <variableDeclarationStatement type="System.String" name="name">
                      <init>
                        <methodInvokeExpression methodName="ToLower">
                          <target>
                            <propertyReferenceExpression name="Value">
                              <arrayIndexerExpression>
                                <target>
                                  <propertyReferenceExpression name="Groups">
                                    <variableReferenceExpression name="m"/>
                                  </propertyReferenceExpression>
                                </target>
                                <indices>
                                  <primitiveExpression value="ArgumentName"/>
                                </indices>
                              </arrayIndexerExpression>
                            </propertyReferenceExpression>
                          </target>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="System.String" name="value">
                      <init>
                        <propertyReferenceExpression name="Value">
                          <arrayIndexerExpression>
                            <target>
                              <propertyReferenceExpression name="Groups">
                                <variableReferenceExpression name="m"/>
                              </propertyReferenceExpression>
                            </target>
                            <indices>
                              <primitiveExpression value="ArgumentValue"/>
                            </indices>
                          </arrayIndexerExpression>
                        </propertyReferenceExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <methodInvokeExpression methodName="Equals">
                          <target>
                            <argumentReferenceExpression name="name"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="field"/>
                          </parameters>
                        </methodInvokeExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="capture"/>
                          <binaryOperatorExpression operator="ValueEquality">
                            <variableReferenceExpression name="fieldName"/>
                            <variableReferenceExpression name="value"/>
                          </binaryOperatorExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                    <conditionStatement>
                      <condition>
                        <argumentReferenceExpression name="capture"/>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <arrayIndexerExpression>
                            <target>
                              <argumentReferenceExpression name="args"/>
                            </target>
                            <indices>
                              <argumentReferenceExpression name="name"/>
                            </indices>
                          </arrayIndexerExpression>
                          <argumentReferenceExpression name="value"/>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                    <assignStatement>
                      <argumentReferenceExpression name="m"/>
                      <methodInvokeExpression methodName="NextMatch">
                        <target>
                          <argumentReferenceExpression name="m"/>
                        </target>
                      </methodInvokeExpression>
                    </assignStatement>
                  </statements>
                </whileStatement>
                <methodReturnStatement>
                  <argumentReferenceExpression name="args"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method CreateFromConfig(string, string, string)-->
            <memberMethod returnType ="BlobAdapter" name="CreateFromConfig">
              <attributes family="true"/>
              <parameters>
                <parameter type="System.String" name="controller"/>
                <parameter type="System.String" name="fieldName"/>
                <parameter type="System.String" name="adapterConfig"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="Not">
                      <methodInvokeExpression methodName="Contains">
                        <target>
                          <argumentReferenceExpression name="adapterConfig"/>
                        </target>
                        <parameters>
                          <argumentReferenceExpression name="FieldName"/>
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
                <variableDeclarationStatement type="BlobAdapterArguments" name="arguments">
                  <init>
                    <methodInvokeExpression methodName="ParseAdapterConfig">
                      <parameters>
                        <argumentReferenceExpression name="fieldName"/>
                        <argumentReferenceExpression name="adapterConfig"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="Equals">
                      <target>
                        <propertyReferenceExpression name="Count">
                          <argumentReferenceExpression name="arguments"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <primitiveExpression value="0"/>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="null"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <tryStatement>
                  <statements>
                    <variableDeclarationStatement type="System.String" name="storageSystem">
                      <init>
                        <methodInvokeExpression methodName="ToLower">
                          <target>
                            <arrayIndexerExpression>
                              <target>
                                <argumentReferenceExpression name="arguments"/>
                              </target>
                              <indices>
                                <primitiveExpression value="storage-system"/>
                              </indices>
                            </arrayIndexerExpression>
                          </target>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <xsl:if test="$IsPremium='true'">
                      <conditionStatement>
                        <condition>
                          <binaryOperatorExpression operator="ValueEquality">
                            <argumentReferenceExpression name="storageSystem"/>
                            <primitiveExpression value="file"/>
                          </binaryOperatorExpression>
                        </condition>
                        <trueStatements>
                          <methodReturnStatement>
                            <objectCreateExpression type="FileSystemBlobAdapter">
                              <parameters>
                                <variableReferenceExpression name="controller"/>
                                <variableReferenceExpression name="arguments"/>
                              </parameters>
                            </objectCreateExpression>
                          </methodReturnStatement>
                        </trueStatements>
                      </conditionStatement>
                      <conditionStatement>
                        <condition>
                          <binaryOperatorExpression operator="ValueEquality">
                            <argumentReferenceExpression name="storageSystem"/>
                            <primitiveExpression value="azure"/>
                          </binaryOperatorExpression>
                        </condition>
                        <trueStatements>
                          <methodReturnStatement>
                            <objectCreateExpression type="AzureBlobAdapter">
                              <parameters>
                                <variableReferenceExpression name="controller"/>
                                <variableReferenceExpression name="arguments"/>
                              </parameters>
                            </objectCreateExpression>
                          </methodReturnStatement>
                        </trueStatements>
                      </conditionStatement>
                    </xsl:if>
                    <xsl:if test="$IsUnlimited='true'">
                      <conditionStatement>
                        <condition>
                          <binaryOperatorExpression operator="ValueEquality">
                            <argumentReferenceExpression name="storageSystem"/>
                            <primitiveExpression value="s3"/>
                          </binaryOperatorExpression>
                        </condition>
                        <trueStatements>
                          <methodReturnStatement>
                            <objectCreateExpression type="S3BlobAdapter">
                              <parameters>
                                <variableReferenceExpression name="controller"/>
                                <variableReferenceExpression name="arguments"/>
                              </parameters>
                            </objectCreateExpression>
                          </methodReturnStatement>
                        </trueStatements>
                      </conditionStatement>
                    </xsl:if>
                  </statements>
                  <catch exceptionType="Exception">
                  </catch>
                </tryStatement>
                <methodReturnStatement>
                  <primitiveExpression value="null"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method ReadConfig(string)-->
            <memberMethod returnType ="System.String" name="ReadConfig">
              <attributes family="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="controller"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="ControllerConfiguration" name="config">
                  <init>
                    <methodInvokeExpression methodName="CreateConfigurationInstance">
                      <target>
                        <propertyReferenceExpression name="DataControllerBase"/>
                      </target>
                      <parameters>
                        <typeofExpression type="BlobAdapter"/>
                        <argumentReferenceExpression name="controller"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="Trim">
                    <target>
                      <castExpression targetType="System.String">
                        <methodInvokeExpression methodName="Evaluate">
                          <target>
                            <argumentReferenceExpression name="config"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="string(/c:dataController/c:blobAdapterConfig)"/>
                          </parameters>
                        </methodInvokeExpression>
                      </castExpression>
                    </target>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method Create(string, string)-->
            <memberMethod returnType ="BlobAdapter" name="Create">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="controller"/>
                <parameter type="System.String" name="fieldName"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.String" name="adapterConfig">
                  <init>
                    <methodInvokeExpression methodName="ReadConfig">
                      <parameters>
                        <argumentReferenceExpression name="controller"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="IsNullOrEmpty">
                      <argumentReferenceExpression name="adapterConfig"/>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="null"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="BlobAdapterFactory" name="factory">
                  <init>
                    <objectCreateExpression type="BlobAdapterFactory"/>
                  </init>
                </variableDeclarationStatement>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="CreateFromConfig">
                    <target>
                      <argumentReferenceExpression name="factory"/>
                    </target>
                    <parameters>
                      <argumentReferenceExpression name="controller"/>
                      <argumentReferenceExpression name="fieldName"/>
                      <argumentReferenceExpression name="adapterConfig"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method InitializeRow(ViewPage, object[])-->
            <memberMethod name="InitializeRow">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="ViewPage" name="page"/>
                <parameter type="System.Object[]" name="row"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.String" name="adapterConfig">
                  <init>
                    <methodInvokeExpression methodName="ReadConfig">
                      <parameters>
                        <propertyReferenceExpression name="Controller">
                          <argumentReferenceExpression name="page"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="IsNullOrEmpty">
                      <argumentReferenceExpression name="adapterConfig"/>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement/>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="BlobAdapterFactory" name="factory">
                  <init>
                    <objectCreateExpression type="BlobAdapterFactory"/>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.Int32" name="blobFieldIndex">
                  <init>
                    <primitiveExpression value="0"/>
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
                    <variableDeclarationStatement type="BlobAdapter" name="ba">
                      <init>
                        <methodInvokeExpression methodName="CreateFromConfig">
                          <target>
                            <argumentReferenceExpression name="factory"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="Controller">
                              <argumentReferenceExpression name="page"/>
                            </propertyReferenceExpression>
                            <propertyReferenceExpression name="Name">
                              <argumentReferenceExpression name="field"/>
                            </propertyReferenceExpression>
                            <argumentReferenceExpression name="adapterConfig"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityInequality">
                          <argumentReferenceExpression name="ba"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="System.Object" name="pk">
                          <init>
                            <primitiveExpression value="null"/>
                          </init>
                        </variableDeclarationStatement>
                        <variableDeclarationStatement type="System.Int32" name="primaryKeyFieldIndex">
                          <init>
                            <primitiveExpression value="0"/>
                          </init>
                        </variableDeclarationStatement>
                        <foreachStatement>
                          <variable type="DataField" name="keyField"/>
                          <target>
                            <propertyReferenceExpression name="Fields">
                              <argumentReferenceExpression name="page"/>
                            </propertyReferenceExpression>
                          </target>
                          <statements>
                            <conditionStatement>
                              <condition>
                                <propertyReferenceExpression name="IsPrimaryKey">
                                  <argumentReferenceExpression name="keyField"/>
                                </propertyReferenceExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <argumentReferenceExpression name="pk"/>
                                  <arrayIndexerExpression>
                                    <target>
                                      <argumentReferenceExpression name="row"/>
                                    </target>
                                    <indices>
                                      <argumentReferenceExpression name="primaryKeyFieldIndex"/>
                                    </indices>
                                  </arrayIndexerExpression>
                                </assignStatement>
                                <breakStatement/>
                              </trueStatements>
                            </conditionStatement>
                            <incrementStatement>
                              <argumentReferenceExpression name="primaryKeyFieldIndex"/>
                            </incrementStatement>
                          </statements>
                        </foreachStatement>
                        <variableDeclarationStatement type="System.Int32" name="utilityFieldIndex">
                          <init>
                            <primitiveExpression value="0"/>
                          </init>
                        </variableDeclarationStatement>
                        <foreachStatement>
                          <variable type="DataField" name="utilityField"/>
                          <target>
                            <propertyReferenceExpression name="Fields">
                              <argumentReferenceExpression name="page"/>
                            </propertyReferenceExpression>
                          </target>
                          <statements>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="BooleanOr">
                                  <binaryOperatorExpression operator="ValueEquality">
                                    <propertyReferenceExpression name="Name">
                                      <argumentReferenceExpression name="utilityField"/>
                                    </propertyReferenceExpression>
                                    <propertyReferenceExpression name="FileNameField">
                                      <argumentReferenceExpression name="ba"/>
                                    </propertyReferenceExpression>
                                  </binaryOperatorExpression>
                                  <binaryOperatorExpression operator="BooleanOr">
                                    <binaryOperatorExpression operator="ValueEquality">
                                      <propertyReferenceExpression name="Name">
                                        <argumentReferenceExpression name="utilityField"/>
                                      </propertyReferenceExpression>
                                      <propertyReferenceExpression name="ContentTypeField">
                                        <argumentReferenceExpression name="ba"/>
                                      </propertyReferenceExpression>
                                    </binaryOperatorExpression>
                                    <binaryOperatorExpression operator="ValueEquality">
                                      <propertyReferenceExpression name="Name">
                                        <argumentReferenceExpression name="utilityField"/>
                                      </propertyReferenceExpression>
                                      <propertyReferenceExpression name="LengthField">
                                        <argumentReferenceExpression name="ba"/>
                                      </propertyReferenceExpression>
                                    </binaryOperatorExpression>
                                  </binaryOperatorExpression>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="IdentityEquality">
                                      <arrayIndexerExpression>
                                        <target>
                                          <argumentReferenceExpression name="row"/>
                                        </target>
                                        <indices>
                                          <argumentReferenceExpression name="utilityFieldIndex"/>
                                        </indices>
                                      </arrayIndexerExpression>
                                      <primitiveExpression value="null"/>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <assignStatement>
                                      <argumentReferenceExpression name="pk"/>
                                      <methodInvokeExpression methodName="Format">
                                        <target>
                                          <propertyReferenceExpression name="String"/>
                                        </target>
                                        <parameters>
                                          <primitiveExpression value="null|{{0}}"/>
                                          <argumentReferenceExpression name="pk"/>
                                        </parameters>
                                      </methodInvokeExpression>
                                    </assignStatement>
                                  </trueStatements>
                                </conditionStatement>
                                <assignStatement>
                                  <arrayIndexerExpression>
                                    <target>
                                      <argumentReferenceExpression name="row"/>
                                    </target>
                                    <indices>
                                      <argumentReferenceExpression name="blobFieldIndex"/>
                                    </indices>
                                  </arrayIndexerExpression>
                                  <argumentReferenceExpression name="pk"/>
                                </assignStatement>
                                <breakStatement/>
                              </trueStatements>
                            </conditionStatement>
                            <incrementStatement>
                              <argumentReferenceExpression name="utilityFieldIndex"/>
                            </incrementStatement>
                          </statements>
                        </foreachStatement>
                      </trueStatements>
                    </conditionStatement>
                    <incrementStatement>
                      <argumentReferenceExpression name="blobFieldIndex"/>
                    </incrementStatement>
                  </statements>
                </foreachStatement>



              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
        <!-- class BlobAdapterFactory-->
        <typeDeclaration isPartial="true" name="BlobAdapterFactory">
          <attributes public="true"/>
          <baseTypes>
            <typeReference type="BlobAdapterFactoryBase"/>
          </baseTypes>
        </typeDeclaration>
        <!-- class BlobAdapter-->
        <typeDeclaration name="BlobAdapter">
          <attributes public="true"/>
          <members>
            <!-- property Controller-->
            <memberProperty type="System.String" name="Controller">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property FieldName-->
            <memberProperty type="System.String" name="FieldName">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property Arguments-->
            <memberProperty type="BlobAdapterArguments" name="Arguments">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property PathTemplate-->
            <memberProperty type="System.String" name="PathTemplate">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property ContentTypeField-->
            <memberProperty type="System.String" name="ContentTypeField">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property LengthField-->
            <memberProperty type="System.String" name="LengthField">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- property FileNameField-->
            <memberProperty type="System.String" name="FileNameField">
              <attributes public="true" final="true"/>
            </memberProperty>
            <!-- constructor BlobAdapter(string, BlobAdapterArguments)-->
            <constructor>
              <attributes public="true"/>
              <parameters>
                <parameter type="System.String" name="controller"/>
                <parameter type="BlobAdapterArguments" name="arguments"/>
              </parameters>
              <statements>
                <assignStatement>
                  <propertyReferenceExpression name="Controller">
                    <thisReferenceExpression />
                  </propertyReferenceExpression>
                  <argumentReferenceExpression name="controller"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Arguments">
                    <thisReferenceExpression />
                  </propertyReferenceExpression>
                  <argumentReferenceExpression name="arguments"/>
                </assignStatement>
                <methodInvokeExpression methodName="Initialize"/>
              </statements>
            </constructor>
            <!-- method Initialize-->
            <memberMethod name="Initialize">
              <attributes family="true"/>
              <statements>
                <assignStatement>
                  <propertyReferenceExpression name="FieldName">
                    <thisReferenceExpression />
                  </propertyReferenceExpression>
                  <arrayIndexerExpression>
                    <target>
                      <propertyReferenceExpression name="Arguments"/>
                    </target>
                    <indices>
                      <primitiveExpression value="field"/>
                    </indices>
                  </arrayIndexerExpression>
                </assignStatement>
                <variableDeclarationStatement type="System.String" name="s">
                  <init>
                    <primitiveExpression value="null"/>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="TryGetValue">
                      <target>
                        <propertyReferenceExpression name="Arguments"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="path-template"/>
                        <directionExpression direction="Out">
                          <variableReferenceExpression name="s"/>
                        </directionExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <propertyReferenceExpression name="PathTemplate">
                        <thisReferenceExpression />
                      </propertyReferenceExpression>
                      <variableReferenceExpression name="s"/>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="TryGetValue">
                      <target>
                        <propertyReferenceExpression name="Arguments"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="content-type-field"/>
                        <directionExpression direction="Out">
                          <variableReferenceExpression name="s"/>
                        </directionExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <propertyReferenceExpression name="ContentTypeField">
                        <thisReferenceExpression />
                      </propertyReferenceExpression>
                      <variableReferenceExpression name="s"/>
                    </assignStatement>
                  </trueStatements>
                  <falseStatements>
                    <assignStatement>
                      <propertyReferenceExpression name="ContentTypeField">
                        <thisReferenceExpression />
                      </propertyReferenceExpression>
                      <binaryOperatorExpression operator="Add">
                        <propertyReferenceExpression name="FieldName"/>
                        <primitiveExpression value="ContentType"/>
                      </binaryOperatorExpression>
                    </assignStatement>
                  </falseStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="TryGetValue">
                      <target>
                        <propertyReferenceExpression name="Arguments"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="length-field"/>
                        <directionExpression direction="Out">
                          <variableReferenceExpression name="s"/>
                        </directionExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <propertyReferenceExpression name="LengthField">
                        <thisReferenceExpression />
                      </propertyReferenceExpression>
                      <variableReferenceExpression name="s"/>
                    </assignStatement>
                  </trueStatements>
                  <falseStatements>
                    <assignStatement>
                      <propertyReferenceExpression name="LengthField">
                        <thisReferenceExpression />
                      </propertyReferenceExpression>
                      <binaryOperatorExpression operator="Add">
                        <propertyReferenceExpression name="FieldName"/>
                        <primitiveExpression value="Length"/>
                      </binaryOperatorExpression>
                    </assignStatement>
                  </falseStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="TryGetValue">
                      <target>
                        <propertyReferenceExpression name="Arguments"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="file-name-field"/>
                        <directionExpression direction="Out">
                          <variableReferenceExpression name="s"/>
                        </directionExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <propertyReferenceExpression name="FileNameField">
                        <thisReferenceExpression />
                      </propertyReferenceExpression>
                      <variableReferenceExpression name="s"/>
                    </assignStatement>
                  </trueStatements>
                  <falseStatements>
                    <assignStatement>
                      <propertyReferenceExpression name="FileNameField">
                        <thisReferenceExpression />
                      </propertyReferenceExpression>
                      <binaryOperatorExpression operator="Add">
                        <propertyReferenceExpression name="FieldName"/>
                        <primitiveExpression value="FileName"/>
                      </binaryOperatorExpression>
                    </assignStatement>
                  </falseStatements>
                </conditionStatement>

              </statements>
            </memberMethod>
            <!-- method ReadBlob(string)-->
            <memberMethod returnType="Stream" name="ReadBlob">
              <attributes public="true"/>
              <parameters>
                <parameter type="System.String" name="keyValue"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <primitiveExpression value="null"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method WriteBlob(HttpPostedFile, string)-->
            <memberMethod returnType="System.Boolean" name="WriteBlob">
              <attributes public="true"/>
              <parameters>
                <parameter type="HttpPostedFile" name="file"/>
                <parameter type="System.String" name="keyValue"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <primitiveExpression value="false"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method SelectViewPageByKey(string)-->
            <memberMethod returnType="ViewPage" name="SelectViewPageByKey">
              <attributes public="true"/>
              <parameters>
                <parameter type="System.String" name="keyValue"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="ControllerConfiguration" name="config">
                  <init>
                    <methodInvokeExpression methodName="CreateConfigurationInstance">
                      <target>
                        <propertyReferenceExpression name="DataControllerBase"/>
                      </target>
                      <parameters>
                        <typeofExpression type="BlobAdapter"/>
                        <propertyReferenceExpression name="Controller">
                          <thisReferenceExpression />
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.String" name="keyField">
                  <init>
                    <castExpression targetType="System.String">
                      <methodInvokeExpression methodName="Evaluate">
                        <target>
                          <variableReferenceExpression name="config"/>
                        </target>
                        <parameters>
                          <primitiveExpression value="string(/c:dataController/c:fields/c:field[@isPrimaryKey='true']/@name)"/>
                        </parameters>
                      </methodInvokeExpression>
                    </castExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="PageRequest" name="request">
                  <init>
                    <objectCreateExpression type="PageRequest"/>
                  </init>
                </variableDeclarationStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Controller">
                    <variableReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                  <propertyReferenceExpression name="Controller"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="View">
                    <variableReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                  <methodInvokeExpression methodName="GetSelectView">
                    <target>
                      <propertyReferenceExpression name="DataControllerBase"/>
                    </target>
                    <parameters>
                      <variableReferenceExpression name="Controller"/>
                    </parameters>
                  </methodInvokeExpression>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Filter">
                    <variableReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                  <arrayCreateExpression>
                    <createType type="System.String"/>
                    <initializers>
                      <methodInvokeExpression methodName="Format">
                        <target>
                          <propertyReferenceExpression name="String"/>
                        </target>
                        <parameters>
                          <primitiveExpression value="{{0}}:={{1}}"/>
                          <variableReferenceExpression name="keyField"/>
                          <argumentReferenceExpression name="keyValue"/>
                        </parameters>
                      </methodInvokeExpression>
                    </initializers>
                  </arrayCreateExpression>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="RequiresMetaData">
                    <variableReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="true"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="PageSize">
                    <variableReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="1"/>
                </assignStatement>
                <variableDeclarationStatement type="ViewPage" name="page">
                  <init>
                    <methodInvokeExpression methodName="GetPage">
                      <target>
                        <methodInvokeExpression methodName="CreateDataController">
                          <target>
                            <propertyReferenceExpression name="ControllerFactory"/>
                          </target>
                        </methodInvokeExpression>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="Controller">
                          <variableReferenceExpression name="request"/>
                        </propertyReferenceExpression>
                        <propertyReferenceExpression name="View">
                          <variableReferenceExpression name="request"/>
                        </propertyReferenceExpression>
                        <variableReferenceExpression name="request"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>

                <methodReturnStatement>
                  <variableReferenceExpression name="page"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- field _page-->
            <memberField type="ViewPage" name="_page">
              <attributes family="true"/>
            </memberField>
            <!-- field _keyValue-->
            <memberField type="System.String" name="_keyValue">
              <attributes family="true"/>
            </memberField>
            <!-- method CopyData(Stream, Stream)-->
            <memberMethod name="CopyData">
              <attributes public="true"/>
              <parameters>
                <parameter type="Stream" name="input"/>
                <parameter type="Stream" name="output"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.Byte[]" name="buffer">
                  <init>
                    <arrayCreateExpression>
                      <createType type="System.Byte"/>
                      <sizeExpression>
                        <binaryOperatorExpression operator="Multiply">
                          <primitiveExpression value="16"/>
                          <primitiveExpression value="1024"/>
                        </binaryOperatorExpression>
                      </sizeExpression>
                    </arrayCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.Int32" name="bytesRead"/>
                <variableDeclarationStatement type="System.Boolean" name="readNext">
                  <init>
                    <primitiveExpression value="true"/>
                  </init>
                </variableDeclarationStatement>
                <whileStatement>
                  <test>
                    <variableReferenceExpression name="readNext"/>
                  </test>
                  <statements>
                    <assignStatement>
                      <variableReferenceExpression name="bytesRead"/>
                      <methodInvokeExpression methodName="Read">
                        <target>
                          <argumentReferenceExpression name="input"/>
                        </target>
                        <parameters>
                          <variableReferenceExpression name="buffer"/>
                          <primitiveExpression value="0"/>
                          <propertyReferenceExpression name="Length">
                            <variableReferenceExpression name="buffer"/>
                          </propertyReferenceExpression>
                        </parameters>
                      </methodInvokeExpression>
                    </assignStatement>
                    <methodInvokeExpression methodName="Write">
                      <target>
                        <argumentReferenceExpression name="output"/>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="buffer"/>
                        <primitiveExpression value="0"/>
                        <variableReferenceExpression name="bytesRead"/>
                      </parameters>
                    </methodInvokeExpression>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="ValueEquality">
                          <variableReferenceExpression name="bytesRead"/>
                          <primitiveExpression value="0"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="readNext"/>
                          <primitiveExpression value="false"/>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </whileStatement>

              </statements>
            </memberMethod>
            <!-- method KeyValueToPath(string)-->
            <memberMethod returnType="System.String" name="KeyValueToPath">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="System.String" name="keyValue"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.String" name="extendedPath">
                  <init>
                    <methodInvokeExpression methodName="ExtendPathTemplate">
                      <parameters>
                        <argumentReferenceExpression name="keyValue"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="StartsWith">
                      <target>
                        <variableReferenceExpression name="extendedPath"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="/"/>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="extendedPath"/>
                      <methodInvokeExpression methodName="Substring">
                        <target>
                          <variableReferenceExpression name="extendedPath"/>
                        </target>
                        <parameters>
                          <primitiveExpression value="1"/>
                        </parameters>
                      </methodInvokeExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <variableReferenceExpression name="extendedPath"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method ExtendPathTemplate(string)-->
            <memberMethod returnType="System.String" name="ExtendPathTemplate">
              <attributes public="true"/>
              <parameters>
                <parameter type="System.String" name="keyValue"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="ExtendPathTemplate">
                    <parameters>
                      <propertyReferenceExpression name="PathTemplate"/>
                      <variableReferenceExpression name="keyValue"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method ExtendPathTemplate(string, string)-->
            <memberMethod returnType="System.String" name="ExtendPathTemplate">
              <attributes public="true"/>
              <parameters>
                <parameter type="System.String" name="template"/>
                <parameter type="System.String" name="keyValue"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanOr">
                      <unaryOperatorExpression operator="IsNullOrEmpty">
                        <variableReferenceExpression name="template"/>
                      </unaryOperatorExpression>
                      <unaryOperatorExpression operator="Not">
                        <methodInvokeExpression methodName="Contains">
                          <target>
                            <variableReferenceExpression name="template"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="{{"/>
                          </parameters>
                        </methodInvokeExpression>
                      </unaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <variableReferenceExpression name="keyValue"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <assignStatement>
                  <propertyReferenceExpression name="_keyValue"/>
                  <variableReferenceExpression name="keyValue"/>
                </assignStatement>
                <variableDeclarationStatement type="System.String" name="extendedPath">
                  <init>
                    <methodInvokeExpression methodName="Replace">
                      <target>
                        <propertyReferenceExpression name="Regex"/>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="template"/>
                        <primitiveExpression value="\{{(\$?\w+)\}}"/>
                        <addressOfExpression>
                          <methodReferenceExpression methodName="DoReplaceFieldNameInTemplate"/>
                        </addressOfExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="StartsWith">
                      <target>
                        <variableReferenceExpression name="extendedPath"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="~"/>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="extendedPath"/>
                      <methodInvokeExpression methodName="Substring">
                        <target>
                          <variableReferenceExpression name="extendedPath"/>
                        </target>
                        <parameters>
                          <primitiveExpression value="1"/>
                        </parameters>
                      </methodInvokeExpression>
                    </assignStatement>
                    <conditionStatement>
                      <condition>
                        <methodInvokeExpression methodName="StartsWith">
                          <target>
                            <variableReferenceExpression name="extendedPath"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="\"/>
                          </parameters>
                        </methodInvokeExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="extendedPath"/>
                          <methodInvokeExpression methodName="Substring">
                            <target>
                              <variableReferenceExpression name="extendedPath"/>
                            </target>
                            <parameters>
                              <primitiveExpression value="1"/>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                    <assignStatement>
                      <variableReferenceExpression name="extendedPath"/>
                      <methodInvokeExpression methodName="Combine">
                        <target>
                          <propertyReferenceExpression name="Path"/>
                        </target>
                        <parameters>
                          <propertyReferenceExpression name="AppDomainAppPath">
                            <propertyReferenceExpression name="HttpRuntime"/>
                          </propertyReferenceExpression>
                          <variableReferenceExpression name="extendedPath"/>
                        </parameters>
                      </methodInvokeExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <variableReferenceExpression name="extendedPath"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method DoReplaceFieldNameInTemplate(Match)-->
            <memberMethod returnType="System.String" name="DoReplaceFieldNameInTemplate">
              <attributes family="true"/>
              <parameters>
                <parameter type="Match" name="m"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <propertyReferenceExpression name="_page">
                        <thisReferenceExpression/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <propertyReferenceExpression name="_page">
                        <thisReferenceExpression />
                      </propertyReferenceExpression>
                      <methodInvokeExpression methodName="SelectViewPageByKey">
                        <parameters>
                          <propertyReferenceExpression name="_keyValue">
                            <thisReferenceExpression/>
                          </propertyReferenceExpression>
                        </parameters>
                      </methodInvokeExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="System.Int32" name="fieldIndex">
                  <init>
                    <primitiveExpression value="0"/>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.String" name="targetFieldName">
                  <init>
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
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.String" name="fieldName">
                  <init>
                    <variableReferenceExpression name="targetFieldName"/>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.Boolean" name="requiresProcessing">
                  <init>
                    <methodInvokeExpression methodName="StartsWith">
                      <target>
                        <variableReferenceExpression name="fieldName"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="$"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <variableReferenceExpression name="requiresProcessing"/>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="fieldName"/>
                      <propertyReferenceExpression name="FileNameField">
                        <thisReferenceExpression/>
                      </propertyReferenceExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <foreachStatement>
                  <variable type="DataField" name="df"/>
                  <target>
                    <propertyReferenceExpression name="Fields">
                      <propertyReferenceExpression name="_page">
                        <thisReferenceExpression/>
                      </propertyReferenceExpression>
                    </propertyReferenceExpression>
                  </target>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="ValueEquality">
                          <propertyReferenceExpression name="Name">
                            <variableReferenceExpression name="df"/>
                          </propertyReferenceExpression>
                          <variableReferenceExpression name="fieldName"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="System.String" name="v">
                          <init>
                            <methodInvokeExpression methodName="ToString">
                              <target>
                                <propertyReferenceExpression name="Convert"/>
                              </target>
                              <parameters>
                                <arrayIndexerExpression>
                                  <target>
                                    <arrayIndexerExpression>
                                      <target>
                                        <propertyReferenceExpression name="Rows">
                                          <propertyReferenceExpression name="_page">
                                            <thisReferenceExpression/>
                                          </propertyReferenceExpression>
                                        </propertyReferenceExpression>
                                      </target>
                                      <indices>
                                        <primitiveExpression value="0"/>
                                      </indices>
                                    </arrayIndexerExpression>
                                  </target>
                                  <indices>
                                    <variableReferenceExpression name="fieldIndex"/>
                                  </indices>
                                </arrayIndexerExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>

                        <conditionStatement>
                          <condition>
                            <variableReferenceExpression name="requiresProcessing"/>
                          </condition>
                          <trueStatements>
                            <conditionStatement>
                              <condition>
                                <methodInvokeExpression methodName="Equals">
                                  <target>
                                    <variableReferenceExpression name="targetFieldName"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="$Extension"/>
                                    <propertyReferenceExpression name="OrdinalIgnoreCase">
                                      <propertyReferenceExpression name="StringComparison"/>
                                    </propertyReferenceExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </condition>
                              <trueStatements>
                                <variableDeclarationStatement type="System.String" name="extension">
                                  <init>
                                    <methodInvokeExpression methodName="GetExtension">
                                      <target>
                                        <propertyReferenceExpression name="Path"/>
                                      </target>
                                      <parameters>
                                        <variableReferenceExpression name="v"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </init>
                                </variableDeclarationStatement>
                                <conditionStatement>
                                  <condition>
                                    <methodInvokeExpression methodName="StartsWith">
                                      <target>
                                        <variableReferenceExpression name="extension"/>
                                      </target>
                                      <parameters>
                                        <primitiveExpression value="."/>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </condition>
                                  <trueStatements>
                                    <assignStatement>
                                      <variableReferenceExpression name="extension"/>
                                      <methodInvokeExpression methodName="Substring">
                                        <target>
                                          <variableReferenceExpression name="extension"/>
                                        </target>
                                        <parameters>
                                          <primitiveExpression value="1"/>
                                        </parameters>
                                      </methodInvokeExpression>
                                    </assignStatement>
                                  </trueStatements>
                                </conditionStatement>
                                <methodReturnStatement>
                                  <variableReferenceExpression name="extension"/>
                                </methodReturnStatement>
                              </trueStatements>
                            </conditionStatement>
                            <conditionStatement>
                              <condition>
                                <methodInvokeExpression methodName="Equals">
                                  <target>
                                    <variableReferenceExpression name="targetFieldName"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="$FileNameWithoutExtension"/>
                                    <propertyReferenceExpression name="OrdinalIgnoreCase">
                                      <propertyReferenceExpression name="StringComparison"/>
                                    </propertyReferenceExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </condition>
                              <trueStatements>
                                <methodReturnStatement>
                                  <methodInvokeExpression methodName="GetFileNameWithoutExtension">
                                    <target>
                                      <propertyReferenceExpression name="Path"/>
                                    </target>
                                    <parameters>
                                      <variableReferenceExpression name="v"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                </methodReturnStatement>
                              </trueStatements>
                            </conditionStatement>
                          </trueStatements>
                        </conditionStatement>

                        <methodReturnStatement>
                          <variableReferenceExpression name="v"/>
                        </methodReturnStatement>
                      </trueStatements>
                    </conditionStatement>
                    <incrementStatement>
                      <variableReferenceExpression name="fieldIndex"/>
                    </incrementStatement>
                  </statements>
                </foreachStatement>
                <methodReturnStatement>
                  <stringEmptyExpression/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method ValidateFieldValue(FieldValue)-->
            <memberMethod name="ValidateFieldValue">
              <attributes public="true"/>
              <parameters>
                <parameter type="FieldValue" name="fv"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <binaryOperatorExpression operator="ValueEquality">
                        <propertyReferenceExpression name="Name">
                          <argumentReferenceExpression name="fv"/>
                        </propertyReferenceExpression>
                        <propertyReferenceExpression name="FileNameField"/>
                      </binaryOperatorExpression>
                      <propertyReferenceExpression name="Modified">
                        <argumentReferenceExpression name="fv"/>
                      </propertyReferenceExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="System.String" name="newValue">
                      <init>
                        <methodInvokeExpression methodName="ToString">
                          <target>
                            <propertyReferenceExpression name="Convert"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="NewValue">
                              <argumentReferenceExpression name="fv"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="IsNotNullOrEmpty">
                          <variableReferenceExpression name="newValue"/>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <propertyReferenceExpression name="NewValue">
                            <argumentReferenceExpression name="fv"/>
                          </propertyReferenceExpression>
                          <methodInvokeExpression methodName="Replace">
                            <target>
                              <propertyReferenceExpression name="Regex"/>
                            </target>
                            <parameters>
                              <variableReferenceExpression name="newValue"/>
                              <primitiveExpression value="[^\w\.]"/>
                              <primitiveExpression value="-"/>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                  </trueStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method ReadContentType(string)-->
            <memberMethod returnType="System.String" name="ReadContentType">
              <attributes public="true"/>
              <parameters>
                <parameter type="System.String" name="keyValue"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="ExtendPathTemplate">
                    <parameters>
                      <methodInvokeExpression methodName="Format">
                        <target>
                          <propertyReferenceExpression name="String"/>
                        </target>
                        <parameters>
                          <primitiveExpression value="{{{{{{0}}}}}}"/>
                          <propertyReferenceExpression name="ContentTypeField"/>
                        </parameters>
                      </methodInvokeExpression>
                      <argumentReferenceExpression name="keyValue"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- property IsPublic-->
            <memberProperty type="System.Boolean" name="IsPublic">
              <attributes public="true"/>
              <getStatements>
                <methodReturnStatement>
                  <primitiveExpression value="false"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
          </members>
        </typeDeclaration>
      </types>
    </compileUnit>
  </xsl:template>
</xsl:stylesheet>
