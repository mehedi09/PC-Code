﻿<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.codeontime.com/2008/codedom-compiler"  xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    xmlns:c="urn:schemas-codeontime-com:data-aquarium"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    exclude-result-prefixes="msxsl a c"
>
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="Namespace"/>
  <xsl:param name="SelectMethod" select="'Select'"/>
  <xsl:param name="SelectSingleMethod" select="'SelectSingle'"/>
  <xsl:param name="InsertMethod" select="'Insert'"/>
  <xsl:param name="UpdateMethod" select="'Update'"/>
  <xsl:param name="DeleteMethod" select="'Delete'"/>

  <xsl:include href="Shared.codedom.xslt"/>

  <xsl:template match="c:dataController">
    <xsl:variable name="ObjectName" select="@name"/>
    <xsl:variable name="QualifiedName" select="concat($Namespace, '.Data.Objects.', @name)" />

    <xsl:variable name="SortParameterName">
      <xsl:choose>
        <xsl:when test="c:fields/c:field[@name='Sort' or @name='sort']">
          <xsl:text>sort2</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>sort</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <compileUnit namespace="{$Namespace}.Data.Objects">
      <imports>
        <namespaceImport name="System"/>
        <namespaceImport name="System.Data"/>
        <namespaceImport name="System.Collections.Generic"/>
        <namespaceImport name="System.Linq"/>
      </imports>
      <types>
        <!-- class BusinessObject -->
        <typeDeclaration name="{@name}" isPartial="true">
          <customAttributes>
            <customAttribute name="System.ComponentModel.DataObject">
              <arguments>
                <primitiveExpression value="false"/>
              </arguments>
            </customAttribute>
          </customAttributes>
          <members>
            <xsl:for-each select="c:fields/c:field">
              <memberField name="{@name}">
                <xsl:call-template name="RenderFieldType"/>
                <customAttributes>
                  <customAttribute name="System.Diagnostics.DebuggerBrowsable">
                    <arguments>
                      <propertyReferenceExpression name="Never">
                        <typeReferenceExpression type="System.Diagnostics.DebuggerBrowsableState"/>
                      </propertyReferenceExpression>
                    </arguments>
                  </customAttribute>
                </customAttributes>
              </memberField>
              <memberProperty>
                <xsl:attribute name="name">
                  <xsl:call-template name="GeneratePropertyName"/>
                </xsl:attribute>
                <xsl:call-template name="RenderFieldType"/>
                <attributes public="true" final="true"/>
                <customAttributes>
                  <customAttribute name="System.ComponentModel.DataObjectField">
                    <arguments>
                      <primitiveExpression>
                        <xsl:attribute name="value">
                          <xsl:choose>
                            <xsl:when test="@isPrimaryKey='true'">
                              <xsl:text>true</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:text>false</xsl:text>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:attribute>
                      </primitiveExpression>
                      <primitiveExpression>
                        <xsl:attribute name="value">
                          <xsl:choose>
                            <xsl:when test="@isPrimaryKey='true' and @readOnly='true'">
                              <xsl:text>true</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:text>false</xsl:text>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:attribute>
                      </primitiveExpression>
                      <primitiveExpression>
                        <xsl:attribute name="value">
                          <xsl:choose>
                            <xsl:when test="not(@allowNulls='false')">
                              <xsl:text>true</xsl:text>
                            </xsl:when>
                            <xsl:otherwise>
                              <xsl:text>false</xsl:text>
                            </xsl:otherwise>
                          </xsl:choose>
                        </xsl:attribute>
                      </primitiveExpression>
                    </arguments>
                  </customAttribute>
                </customAttributes>
                <getStatements>
                  <methodReturnStatement>
                    <fieldReferenceExpression name="{@name}"/>
                  </methodReturnStatement>
                </getStatements>
                <setStatements>
                  <assignStatement>
                    <fieldReferenceExpression name="{@name}"/>
                    <propertySetValueReferenceExpression/>
                  </assignStatement>
                </setStatements>
              </memberProperty>
            </xsl:for-each>
            <!-- constructor -->
            <constructor>
              <attributes public="true"/>
            </constructor>
            <!-- method Select(filter fields) -->
            <memberMethod returnType="List" name="{$SelectMethod}">
              <typeArguments>
                <typeReference type="{$QualifiedName}"/>
              </typeArguments>
              <attributes public="true" static="true"/>
              <parameters>
                <xsl:call-template name="RenderFilterParameters"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="{$SelectMethod}">
                    <target>
                      <objectCreateExpression type="{@name}Factory"/>
                    </target>
                    <parameters>
                      <xsl:call-template name="RenderFilterArguments"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method Select(BusinessObjectType qbe) -->
            <memberMethod returnType="List" name="{$SelectMethod}">
              <typeArguments>
                <typeReference type="{$QualifiedName}"/>
              </typeArguments>
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="{$QualifiedName}" name="qbe"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="{$SelectMethod}">
                    <target>
                      <objectCreateExpression type="{@name}Factory"/>
                    </target>
                    <parameters>
                      <argumentReferenceExpression name="qbe"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method Select(string, string, string, BusinessObjectParameters) -->
            <memberMethod returnType="List" name="{$SelectMethod}">
              <typeArguments>
                <typeReference type="{$QualifiedName}"/>
              </typeArguments>
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="filter"/>
                <parameter type="System.String" name="sort"/>
                <parameter type="System.String" name="dataView"/>
                <parameter type="BusinessObjectParameters" name="parameters"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="{$SelectMethod}">
                    <target>
                      <objectCreateExpression type="{@name}Factory"/>
                    </target>
                    <parameters>
                      <argumentReferenceExpression name="filter"/>
                      <argumentReferenceExpression name="sort"/>
                      <argumentReferenceExpression name="dataView"/>
                      <argumentReferenceExpression name="parameters"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method Select(string, string, string, params FieldValue[]) -->
            <memberMethod returnType="List" name="{$SelectMethod}">
              <typeArguments>
                <typeReference type="{$QualifiedName}"/>
              </typeArguments>
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="filter"/>
                <parameter type="System.String" name="sort"/>
                <parameter type="System.String" name="dataView"/>
                <parameter type="params FieldValue[]" name="parameters"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="{$SelectMethod}">
                    <target>
                      <objectCreateExpression type="{@name}Factory"/>
                    </target>
                    <parameters>
                      <argumentReferenceExpression name="filter"/>
                      <argumentReferenceExpression name="sort"/>
                      <argumentReferenceExpression name="dataView"/>
                      <objectCreateExpression type="BusinessObjectParameters">
                        <parameters>
                          <argumentReferenceExpression name="parameters"/>
                        </parameters>
                      </objectCreateExpression>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method Select(string, string, BusinessObjectParameters) -->
            <memberMethod returnType="List" name="{$SelectMethod}">
              <typeArguments>
                <typeReference type="{$QualifiedName}"/>
              </typeArguments>
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="filter"/>
                <parameter type="System.String" name="sort"/>
                <parameter type="BusinessObjectParameters" name="parameters"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="{$SelectMethod}">
                    <target>
                      <objectCreateExpression type="{@name}Factory"/>
                    </target>
                    <parameters>
                      <argumentReferenceExpression name="filter"/>
                      <argumentReferenceExpression name="sort"/>
                      <propertyReferenceExpression name="SelectView">
                        <typeReferenceExpression type="{@name}Factory"/>
                      </propertyReferenceExpression>
                      <argumentReferenceExpression name="parameters"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method Select(string, string, params FieldValue[]) -->
            <memberMethod returnType="List" name="{$SelectMethod}">
              <typeArguments>
                <typeReference type="{$QualifiedName}"/>
              </typeArguments>
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="filter"/>
                <parameter type="System.String" name="sort"/>
                <parameter type="params FieldValue[]" name="parameters"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="{$SelectMethod}">
                    <target>
                      <objectCreateExpression type="{@name}Factory"/>
                    </target>
                    <parameters>
                      <argumentReferenceExpression name="filter"/>
                      <argumentReferenceExpression name="sort"/>
                      <propertyReferenceExpression name="SelectView">
                        <typeReferenceExpression type="{@name}Factory"/>
                      </propertyReferenceExpression>
                      <objectCreateExpression type="BusinessObjectParameters">
                        <parameters>
                          <argumentReferenceExpression name="parameters"/>
                        </parameters>
                      </objectCreateExpression>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method Select(string, BusinessObjectParameters) -->
            <memberMethod returnType="List" name="{$SelectMethod}">
              <typeArguments>
                <typeReference type="{$QualifiedName}"/>
              </typeArguments>
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="filter"/>
                <parameter type="BusinessObjectParameters" name="parameters"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="{$SelectMethod}">
                    <target>
                      <objectCreateExpression type="{@name}Factory"/>
                    </target>
                    <parameters>
                      <argumentReferenceExpression name="filter"/>
                      <primitiveExpression value="null"/>
                      <propertyReferenceExpression name="SelectView">
                        <typeReferenceExpression type="{@name}Factory"/>
                      </propertyReferenceExpression>
                      <argumentReferenceExpression name="parameters"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method Select(string, params FieldValue[]) -->
            <memberMethod returnType="List" name="{$SelectMethod}">
              <typeArguments>
                <typeReference type="{$QualifiedName}"/>
              </typeArguments>
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="filter"/>
                <parameter type="params FieldValue[]" name="parameters"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="{$SelectMethod}">
                    <target>
                      <objectCreateExpression type="{@name}Factory"/>
                    </target>
                    <parameters>
                      <argumentReferenceExpression name="filter"/>
                      <primitiveExpression value="null"/>
                      <propertyReferenceExpression name="SelectView">
                        <typeReferenceExpression type="{@name}Factory"/>
                      </propertyReferenceExpression>
                      <objectCreateExpression type="BusinessObjectParameters">
                        <parameters>
                          <argumentReferenceExpression name="parameters"/>
                        </parameters>
                      </objectCreateExpression>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method SelectSingle(string, BusinessObjectParameters) -->
            <memberMethod returnType="{$QualifiedName}" name="{$SelectSingleMethod}">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="filter"/>
                <parameter type="BusinessObjectParameters" name="parameters"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="{$SelectSingleMethod}">
                    <target>
                      <objectCreateExpression type="{@name}Factory"/>
                    </target>
                    <parameters>
                      <argumentReferenceExpression name="filter"/>
                      <argumentReferenceExpression name="parameters"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method SelectSingle(string, params FieldValue[]) -->
            <memberMethod returnType="{$QualifiedName}" name="{$SelectSingleMethod}">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="filter"/>
                <parameter type="params FieldValue[]" name="parameters"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="{$SelectSingleMethod}">
                    <target>
                      <objectCreateExpression type="{@name}Factory"/>
                    </target>
                    <parameters>
                      <argumentReferenceExpression name="filter"/>
                      <objectCreateExpression type="BusinessObjectParameters">
                        <parameters>
                          <argumentReferenceExpression name="parameters"/>
                        </parameters>
                      </objectCreateExpression>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method SelectSingle(primary key fields)-->
            <xsl:if test="c:fields/c:field[@isPrimaryKey='true']">
              <memberMethod returnType="{$Namespace}.Data.Objects.{@name}" name="{$SelectSingleMethod}">
                <attributes public="true" static="true"/>
                <parameters>
                  <xsl:for-each select="c:fields/c:field[@isPrimaryKey='true']">
                    <parameter name="{@name}">
                      <xsl:call-template name="RenderFieldType"/>
                    </parameter>
                  </xsl:for-each>
                </parameters>
                <statements>
                  <methodReturnStatement>
                    <methodInvokeExpression methodName="{$SelectSingleMethod}">
                      <target>
                        <objectCreateExpression type="{@name}Factory"/>
                      </target>
                      <parameters>
                        <xsl:for-each select="c:fields/c:field[@isPrimaryKey='true']">
                          <argumentReferenceExpression name="{@name}"/>
                        </xsl:for-each>
                      </parameters>
                    </methodInvokeExpression>
                  </methodReturnStatement>
                </statements>
              </memberMethod>
              <!-- method Insert() -->
              <memberMethod returnType="System.Int32" name="{$InsertMethod}">
                <attributes public="true" final="true"/>
                <statements>
                  <methodReturnStatement>
                    <methodInvokeExpression methodName="{$InsertMethod}">
                      <target>
                        <objectCreateExpression type="{@name}Factory"/>
                      </target>
                      <parameters>
                        <thisReferenceExpression/>
                      </parameters>
                    </methodInvokeExpression>
                  </methodReturnStatement>
                </statements>
              </memberMethod>
              <!-- method Update() -->
              <memberMethod returnType="System.Int32" name="{$UpdateMethod}">
                <attributes public="true" final="true"/>
                <statements>
                  <methodReturnStatement>
                    <methodInvokeExpression methodName="{$UpdateMethod}">
                      <target>
                        <objectCreateExpression type="{@name}Factory"/>
                      </target>
                      <parameters>
                        <thisReferenceExpression/>
                      </parameters>
                    </methodInvokeExpression>
                  </methodReturnStatement>
                </statements>
              </memberMethod>
              <!-- method Delete() -->
              <memberMethod returnType="System.Int32" name="{$DeleteMethod}">
                <attributes public="true" final="true"/>
                <statements>
                  <methodReturnStatement>
                    <methodInvokeExpression methodName="{$DeleteMethod}">
                      <target>
                        <objectCreateExpression type="{@name}Factory"/>
                      </target>
                      <parameters>
                        <thisReferenceExpression/>
                      </parameters>
                    </methodInvokeExpression>
                  </methodReturnStatement>
                </statements>
              </memberMethod>
            </xsl:if>
            <memberMethod returnType="System.String" name="ToString">
              <attributes public="true" override="true"/>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="Format">
                    <target>
                      <typeReferenceExpression type="String"/>
                    </target>
                    <parameters>
                      <primitiveExpression>
                        <xsl:attribute name="value">
                          <xsl:for-each select="c:fields/c:field[@isPrimaryKey='true']">
                            <xsl:if test="position()>1">
                              <xsl:text>; </xsl:text>
                            </xsl:if>
                            <xsl:value-of select="@name"/>
                            <xsl:text>: {</xsl:text>
                            <xsl:value-of select="position() - 1"/>
                            <xsl:text>}</xsl:text>
                          </xsl:for-each>
                        </xsl:attribute>
                      </primitiveExpression>
                      <xsl:for-each select="c:fields/c:field[@isPrimaryKey='true']">
                        <propertyReferenceExpression>
                          <xsl:attribute name="name">
                            <xsl:value-of select="@name"/>
                            <xsl:if test="@name=$ObjectName">
                              <xsl:text>_</xsl:text>
                            </xsl:if>
                          </xsl:attribute>
                          <thisReferenceExpression/>
                        </propertyReferenceExpression>
                      </xsl:for-each>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
        <!-- class ObjectFactory -->
        <typeDeclaration name="{@name}Factory" isPartial="true">
          <customAttributes>
            <customAttribute name="System.ComponentModel.DataObject">
              <arguments>
                <primitiveExpression value="true"/>
              </arguments>
            </customAttribute>
          </customAttributes>
          <members>
            <memberMethod returnType="{@name}Factory" name="Create">
              <attributes static="true" public="true"/>
              <statements>
                <methodReturnStatement>
                  <objectCreateExpression type="{@name}Factory"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- constructor -->
            <constructor>
              <attributes public="true"/>
            </constructor>
            <!-- property SelectView -->
            <memberProperty type="System.String" name="SelectView">
              <attributes public="true" static="true"/>
              <getStatements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="GetSelectView">
                    <target>
                      <typeReferenceExpression type="Controller"/>
                    </target>
                    <parameters>
                      <primitiveExpression value="{@name}"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property InsertView -->
            <memberProperty type="System.String" name="InsertView">
              <attributes public="true" static="true"/>
              <getStatements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="GetInsertView">
                    <target>
                      <typeReferenceExpression type="Controller"/>
                    </target>
                    <parameters>
                      <primitiveExpression value="{@name}"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property UpdateView -->
            <memberProperty type="System.String" name="UpdateView">
              <attributes public="true" static="true"/>
              <getStatements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="GetUpdateView">
                    <target>
                      <typeReferenceExpression type="Controller"/>
                    </target>
                    <parameters>
                      <primitiveExpression value="{@name}"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property DeleteView -->
            <memberProperty type="System.String" name="DeleteView">
              <attributes public="true" static="true"/>
              <getStatements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="GetDeleteView">
                    <target>
                      <typeReferenceExpression type="Controller"/>
                    </target>
                    <parameters>
                      <primitiveExpression value="{@name}"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- method CreateRequest(..., string, int, int) -->
            <memberMethod returnType="PageRequest" name="CreateRequest">
              <attributes family="true"/>
              <parameters>
                <xsl:call-template name="RenderFilterParameters"/>
                <parameter type="System.String" name="{$SortParameterName}"/>
                <parameter type="System.Int32" name="maximumRows"/>
                <parameter type="System.Int32" name="startRowIndex"/>
              </parameters>
              <statements>
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
                <xsl:for-each select="c:fields/c:field">
                  <xsl:variable name="AllowFilter">
                    <xsl:call-template name="GetAllowFilter"/>
                  </xsl:variable>
                  <xsl:if test="$AllowFilter='true'">
                    <xsl:variable name="IsReferenceType">
                      <xsl:call-template name="GetIsReferenceType"/>
                    </xsl:variable>
                    <xsl:choose>
                      <xsl:when test="$IsReferenceType='true' and @type='String' and not(@isPrimaryKey='true')">
                        <conditionStatement>
                          <condition>
                            <unaryOperatorExpression operator="Not">
                              <methodInvokeExpression methodName="IsNullOrEmpty">
                                <target>
                                  <typeReferenceExpression type="String"/>
                                </target>
                                <parameters>
                                  <argumentReferenceExpression name="{@name}"/>
                                </parameters>
                              </methodInvokeExpression>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <variableReferenceExpression name="filter"/>
                              </target>
                              <parameters>
                                <binaryOperatorExpression operator="Add">
                                  <primitiveExpression value="{@name}:*"/>
                                  <argumentReferenceExpression name="{@name}"/>
                                </binaryOperatorExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>
                      </xsl:when>
                      <xsl:when test="$IsReferenceType='true'">
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="IdentityInequality">
                              <argumentReferenceExpression name="{@name}"/>
                              <primitiveExpression value="null"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <variableReferenceExpression name="filter"/>
                              </target>
                              <parameters>
                                <binaryOperatorExpression operator="Add">
                                  <primitiveExpression value="{@name}:="/>
                                  <argumentReferenceExpression name="{@name}"/>
                                </binaryOperatorExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>
                      </xsl:when>
                      <xsl:otherwise>
                        <conditionStatement>
                          <condition>
                            <propertyReferenceExpression name="HasValue">
                              <argumentReferenceExpression name="{@name}"/>
                            </propertyReferenceExpression>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <variableReferenceExpression name="filter"/>
                              </target>
                              <parameters>
                                <binaryOperatorExpression operator="Add">
                                  <primitiveExpression value="{@name}:="/>
                                  <methodInvokeExpression methodName="ToString">
                                    <target>
                                      <propertyReferenceExpression name="Value">
                                        <argumentReferenceExpression name="{@name}"/>
                                      </propertyReferenceExpression>
                                    </target>
                                  </methodInvokeExpression>
                                  <!--<xsl:choose>
                                    <xsl:when test="@type='Guid'">
                                      <methodInvokeExpression methodName="ToString">
                                        <target>
                                          <propertyReferenceExpression name="Value">
                                            <argumentReferenceExpression name="{@name}"/>
                                          </propertyReferenceExpression>
                                        </target>
                                      </methodInvokeExpression>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <propertyReferenceExpression name="Value">
                                        <argumentReferenceExpression name="{@name}"/>
                                      </propertyReferenceExpression>
                                    </xsl:otherwise>
                                  </xsl:choose>-->
                                </binaryOperatorExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:if>
                </xsl:for-each>
                <methodReturnStatement>
                  <objectCreateExpression type="PageRequest">
                    <parameters>
                      <binaryOperatorExpression operator="Divide">
                        <argumentReferenceExpression name="startRowIndex"/>
                        <argumentReferenceExpression name="maximumRows"/>
                      </binaryOperatorExpression>
                      <argumentReferenceExpression name="maximumRows"/>
                      <argumentReferenceExpression name="{$SortParameterName}"/>
                      <methodInvokeExpression methodName="ToArray">
                        <target>
                          <variableReferenceExpression name="filter"/>
                        </target>
                      </methodInvokeExpression>
                    </parameters>
                  </objectCreateExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method Select -->
            <memberMethod returnType="List" name="{$SelectMethod}">
              <typeArguments>
                <typeReference type="{$QualifiedName}"/>
              </typeArguments>
              <attributes public="true" final="true"/>
              <customAttributes>
                <customAttribute name="System.ComponentModel.DataObjectMethod">
                  <arguments>
                    <propertyReferenceExpression name="Select">
                      <typeReferenceExpression type="System.ComponentModel.DataObjectMethodType"/>
                    </propertyReferenceExpression>
                  </arguments>
                </customAttribute>
              </customAttributes>
              <parameters>
                <xsl:call-template name="RenderFilterParameters"/>
                <parameter type="System.String" name="{$SortParameterName}"/>
                <parameter type="System.Int32" name="maximumRows"/>
                <parameter type="System.Int32" name="startRowIndex"/>
                <parameter type="System.String" name="dataView"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="PageRequest" name="request">
                  <init>
                    <methodInvokeExpression methodName="CreateRequest">
                      <parameters>
                        <xsl:call-template name="RenderFilterArguments"/>
                        <argumentReferenceExpression name="{$SortParameterName}"/>
                        <argumentReferenceExpression name="maximumRows"/>
                        <argumentReferenceExpression name="startRowIndex"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <assignStatement>
                  <propertyReferenceExpression name="RequiresMetaData">
                    <variableReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="true"/>
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
                        <primitiveExpression value="{@name}"/>
                        <argumentReferenceExpression name="dataView"/>
                        <variableReferenceExpression name="request"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="ToList">
                    <typeArguments>
                      <typeReference type="{$QualifiedName}"/>
                    </typeArguments>
                    <target>
                      <variableReferenceExpression name="page"/>
                    </target>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method Select(BusinessObjectType qbe) -->
            <memberMethod returnType="List" name="{$SelectMethod}">
              <typeArguments>
                <typeReference type="{$QualifiedName}"/>
              </typeArguments>
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="{$QualifiedName}" name="qbe"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="{$SelectMethod}">
                    <parameters>
                      <xsl:call-template name="RenderFilterArguments">
                        <xsl:with-param name="Container" select="'qbe'"/>
                      </xsl:call-template>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method SelectCount -->
            <memberMethod returnType="System.Int32" name="{$SelectMethod}Count">
              <attributes public="true" final="true"/>
              <parameters>
                <xsl:call-template name="RenderFilterParameters"/>
                <parameter type="System.String" name="{$SortParameterName}"/>
                <parameter type="System.Int32" name="maximumRows"/>
                <parameter type="System.Int32" name="startRowIndex"/>
                <parameter type="System.String" name="dataView"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="PageRequest" name="request">
                  <init>
                    <methodInvokeExpression methodName="CreateRequest">
                      <parameters>
                        <xsl:call-template name="RenderFilterArguments"/>
                        <argumentReferenceExpression name="{$SortParameterName}"/>
                        <primitiveExpression value="-1"/>
                        <argumentReferenceExpression name="startRowIndex"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <assignStatement>
                  <propertyReferenceExpression name="RequiresMetaData">
                    <variableReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="false"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="RequiresRowCount">
                    <variableReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="true"/>
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
                        <primitiveExpression value="{@name}"/>
                        <argumentReferenceExpression name="dataView"/>
                        <variableReferenceExpression name="request"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <methodReturnStatement>
                  <propertyReferenceExpression name="TotalRowCount">
                    <variableReferenceExpression name="page"/>
                  </propertyReferenceExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method Select -->
            <memberMethod returnType="List" name="{$SelectMethod}">
              <typeArguments>
                <typeReference type="{$QualifiedName}"/>
              </typeArguments>
              <attributes public="true" final="true"/>
              <customAttributes>
                <customAttribute name="System.ComponentModel.DataObjectMethod">
                  <arguments>
                    <propertyReferenceExpression name="Select">
                      <typeReferenceExpression type="System.ComponentModel.DataObjectMethodType"/>
                    </propertyReferenceExpression>
                    <primitiveExpression value="true"/>
                  </arguments>
                </customAttribute>
              </customAttributes>
              <parameters>
                <xsl:call-template name="RenderFilterParameters"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="{$SelectMethod}">
                    <parameters>
                      <xsl:call-template name="RenderFilterArguments"/>
                      <primitiveExpression value="null"/>
                      <propertyReferenceExpression name="MaxValue">
                        <typeReferenceExpression type="Int32"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="0"/>
                      <propertyReferenceExpression name="SelectView"/>
                      <!--<propertyReferenceExpression name="Empty">
												<typeReferenceExpression type="String"/>
											</propertyReferenceExpression>-->
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method SelectSingle(primary key fields) -->
            <xsl:if test="c:fields/c:field[@isPrimaryKey='true']">
              <memberMethod returnType="{$QualifiedName}" name="{$SelectSingleMethod}">
                <attributes public="true" final="true"/>
                <parameters>
                  <xsl:for-each select="c:fields/c:field[@isPrimaryKey='true']">
                    <parameter name="{@name}">
                      <xsl:call-template name="RenderFieldType"/>
                    </parameter>
                  </xsl:for-each>
                </parameters>
                <statements>
                  <xsl:variable name="Fields" select="c:fields/c:field"/>
                  <xsl:variable name="CriteriaFields">
                    <xsl:for-each select="$Fields">
                      <xsl:variable name="AllowFilter">
                        <xsl:call-template name="GetAllowFilter"/>
                      </xsl:variable>
                      <xsl:if test="$AllowFilter='true'">
                        <xsl:text>x</xsl:text>
                      </xsl:if>
                    </xsl:for-each>
                  </xsl:variable>
                  <xsl:if test="string-length($CriteriaFields) &lt;= 4">
                    <xsl:for-each select="$Fields[not(@isPrimaryKey='true')]">
                      <xsl:variable name="AllowFilter">
                        <xsl:call-template name="GetAllowFilter"/>
                      </xsl:variable>
                      <xsl:if test="$AllowFilter='true'">
                        <variableDeclarationStatement name="empty{@name}">
                          <xsl:call-template name="RenderFieldType"/>
                          <init>
                            <primitiveExpression value="null"/>
                          </init>
                        </variableDeclarationStatement>
                      </xsl:if>
                    </xsl:for-each>
                  </xsl:if>
                  <variableDeclarationStatement type="List" name="list">
                    <typeArguments>
                      <typeReference type="{$QualifiedName}"/>
                    </typeArguments>
                    <init>
                      <methodInvokeExpression methodName="{$SelectMethod}">
                        <parameters>
                          <xsl:for-each select="$Fields">
                            <xsl:variable name="AllowFilter">
                              <xsl:call-template name="GetAllowFilter"/>
                            </xsl:variable>
                            <xsl:if test="$AllowFilter='true'">
                              <xsl:choose>
                                <xsl:when test="@isPrimaryKey='true'">
                                  <argumentReferenceExpression name="{@name}"/>
                                </xsl:when>
                                <xsl:otherwise>
                                  <xsl:choose>
                                    <xsl:when test="string-length($CriteriaFields) &lt;= 4">
                                      <variableReferenceExpression name="empty{@name}"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                      <primitiveExpression value="null"/>
                                    </xsl:otherwise>
                                  </xsl:choose>
                                </xsl:otherwise>
                              </xsl:choose>
                            </xsl:if>
                          </xsl:for-each>
                        </parameters>
                      </methodInvokeExpression>
                    </init>
                  </variableDeclarationStatement>
                  <conditionStatement>
                    <condition>
                      <binaryOperatorExpression operator="ValueEquality">
                        <propertyReferenceExpression name="Count">
                          <variableReferenceExpression name="list"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="0"/>
                      </binaryOperatorExpression>
                    </condition>
                    <trueStatements>
                      <methodReturnStatement>
                        <primitiveExpression value="null"/>
                      </methodReturnStatement>
                    </trueStatements>
                  </conditionStatement>
                  <methodReturnStatement>
                    <arrayIndexerExpression>
                      <target>
                        <variableReferenceExpression name="list"/>
                      </target>
                      <indices>
                        <primitiveExpression value="0"/>
                      </indices>
                    </arrayIndexerExpression>
                  </methodReturnStatement>
                </statements>
              </memberMethod>
            </xsl:if>
            <!-- method Select(string, string, string, BusinessObjectParameters) -->
            <memberMethod returnType="List" name="{$SelectMethod}">
              <typeArguments>
                <typeReference type="{$QualifiedName}"/>
              </typeArguments>
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="System.String" name="filter"/>
                <parameter type="System.String" name="sort"/>
                <parameter type="System.String" name="dataView"/>
                <parameter type="BusinessObjectParameters" name="parameters"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="PageRequest" name="request">
                  <init>
                    <objectCreateExpression type="PageRequest">
                      <parameters>
                        <primitiveExpression value="0"/>
                        <propertyReferenceExpression name="MaxValue">
                          <typeReferenceExpression type="Int32"/>
                        </propertyReferenceExpression>
                        <argumentReferenceExpression name="sort"/>
                        <arrayCreateExpression>
                          <createType type="System.String"/>
                        </arrayCreateExpression>
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
                <variableDeclarationStatement type="IDataController" name="c">
                  <init>
                    <methodInvokeExpression methodName="CreateDataController">
                      <target>
                        <typeReferenceExpression type="ControllerFactory"/>
                      </target>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="IBusinessObject" name="bo">
                  <init>
                    <castExpression targetType="IBusinessObject">
                      <variableReferenceExpression name="c"/>
                    </castExpression>
                  </init>
                </variableDeclarationStatement>
                <methodInvokeExpression methodName="AssignFilter">
                  <target>
                    <variableReferenceExpression name="bo"/>
                  </target>
                  <parameters>
                    <argumentReferenceExpression name="filter"/>
                    <argumentReferenceExpression name="parameters"/>
                  </parameters>
                </methodInvokeExpression>
                <variableDeclarationStatement type="ViewPage" name="page">
                  <init>
                    <methodInvokeExpression methodName="GetPage">
                      <target>
                        <variableReferenceExpression name="c"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="{$ObjectName}"/>
                        <argumentReferenceExpression name="dataView"/>
                        <variableReferenceExpression name="request"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="ToList">
                    <typeArguments>
                      <typeReference type="{$QualifiedName}"/>
                    </typeArguments>
                    <target>
                      <variableReferenceExpression name="page"/>
                    </target>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method Select(string, string, BusinessObjectParameters) -->
            <memberMethod returnType="List" name="{$SelectSingleMethod}">
              <typeArguments>
                <typeReference type="{$QualifiedName}"/>
              </typeArguments>
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="System.String" name="filter"/>
                <parameter type="System.String" name="sort"/>
                <parameter type="BusinessObjectParameters" name="parameters"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="{$SelectMethod}">
                    <parameters>
                      <argumentReferenceExpression name="filter"/>
                      <argumentReferenceExpression name="sort"/>
                      <propertyReferenceExpression name="SelectView"/>
                      <argumentReferenceExpression name="parameters"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method Select(string, BusinessObjectParameters) -->
            <memberMethod returnType="List" name="{$SelectMethod}">
              <typeArguments>
                <typeReference type="{$QualifiedName}"/>
              </typeArguments>
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="System.String" name="filter"/>
                <parameter type="BusinessObjectParameters" name="parameters"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="{$SelectMethod}">
                    <parameters>
                      <argumentReferenceExpression name="filter"/>
                      <primitiveExpression value="null"/>
                      <propertyReferenceExpression name="SelectView"/>
                      <argumentReferenceExpression name="parameters"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method SelectSingle(string, BusinessObjectParameters) -->
            <memberMethod returnType="{$QualifiedName}" name="{$SelectSingleMethod}">
              <attributes public="true" final="true"/>
              <parameters>
                <parameter type="System.String" name="filter"/>
                <parameter type="BusinessObjectParameters" name="parameters"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="List" name="list">
                  <typeArguments>
                    <typeReference type="{$QualifiedName}"/>
                  </typeArguments>
                  <init>
                    <methodInvokeExpression methodName="{$SelectMethod}">
                      <parameters>
                        <argumentReferenceExpression name="filter"/>
                        <argumentReferenceExpression name="parameters"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="GreaterThan">
                      <propertyReferenceExpression name="Count">
                        <variableReferenceExpression name="list"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="0"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <arrayIndexerExpression>
                        <target>
                          <variableReferenceExpression name="list"/>
                        </target>
                        <indices>
                          <primitiveExpression value="0"/>
                        </indices>
                      </arrayIndexerExpression>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <primitiveExpression value="null"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <xsl:if test="c:fields/c:field[@isPrimaryKey='true']">
              <!-- method CreateFieldValues(Object, Object) -->
              <memberMethod returnType="FieldValue[]" name="CreateFieldValues">
                <attributes family="true"/>
                <parameters>
                  <parameter type="{$QualifiedName}" name="the{@name}"/>
                  <parameter type="{$QualifiedName}" name="original_{@name}"/>
                </parameters>
                <statements>
                  <variableDeclarationStatement type="List" name="values">
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
                  <xsl:for-each select="c:fields/c:field">
                    <xsl:variable name="PropertyName">
                      <xsl:call-template name="GeneratePropertyName"/>
                    </xsl:variable>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <variableReferenceExpression name="values"/>
                      </target>
                      <parameters>
                        <objectCreateExpression type="FieldValue">
                          <parameters>
                            <primitiveExpression value="{@name}"/>
                            <propertyReferenceExpression name="{$PropertyName}">
                              <argumentReferenceExpression name="original_{$ObjectName}"/>
                            </propertyReferenceExpression>
                            <propertyReferenceExpression name="{$PropertyName}">
                              <argumentReferenceExpression name="the{$ObjectName}"/>
                            </propertyReferenceExpression>
                            <xsl:if test="@readOnly='true'">
                              <primitiveExpression value="true"/>
                            </xsl:if>
                          </parameters>
                        </objectCreateExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </xsl:for-each>
                  <methodReturnStatement>
                    <methodInvokeExpression methodName="ToArray">
                      <target>
                        <variableReferenceExpression name="values"/>
                      </target>
                    </methodInvokeExpression>
                  </methodReturnStatement>
                </statements>
              </memberMethod>
              <!-- method ExecuteAction(object, object, string, string) -->
              <memberMethod returnType="System.Int32" name="ExecuteAction">
                <attributes family="true"/>
                <parameters>
                  <parameter type="{$QualifiedName}" name="the{@name}"/>
                  <parameter type="{$QualifiedName}" name="original_{@name}"/>
                  <parameter type="System.String" name="lastCommandName"/>
                  <parameter type="System.String" name="commandName"/>
                  <parameter type="System.String" name="dataView"/>
                </parameters>
                <statements>
                  <variableDeclarationStatement type="ActionArgs" name="args">
                    <init>
                      <objectCreateExpression type="ActionArgs"/>
                    </init>
                  </variableDeclarationStatement>
                  <assignStatement>
                    <propertyReferenceExpression name="Controller">
                      <variableReferenceExpression name="args"/>
                    </propertyReferenceExpression>
                    <primitiveExpression value="{@name}"/>
                  </assignStatement>
                  <assignStatement>
                    <propertyReferenceExpression name="View">
                      <variableReferenceExpression name="args"/>
                    </propertyReferenceExpression>
                    <argumentReferenceExpression name="dataView"/>
                  </assignStatement>
                  <assignStatement>
                    <propertyReferenceExpression name="Values">
                      <variableReferenceExpression name="args"/>
                    </propertyReferenceExpression>
                    <methodInvokeExpression methodName="CreateFieldValues">
                      <parameters>
                        <argumentReferenceExpression name="the{@name}"/>
                        <argumentReferenceExpression name="original_{@name}"/>
                      </parameters>
                    </methodInvokeExpression>
                  </assignStatement>
                  <assignStatement>
                    <propertyReferenceExpression name="LastCommandName">
                      <variableReferenceExpression name="args"/>
                    </propertyReferenceExpression>
                    <argumentReferenceExpression name="lastCommandName"/>
                  </assignStatement>
                  <assignStatement>
                    <propertyReferenceExpression name="CommandName">
                      <variableReferenceExpression name="args"/>
                    </propertyReferenceExpression>
                    <argumentReferenceExpression name="commandName"/>
                  </assignStatement>
                  <variableDeclarationStatement type="ActionResult" name="result">
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
                          <primitiveExpression value="{@name}"/>
                          <argumentReferenceExpression name="dataView"/>
                          <variableReferenceExpression name="args"/>
                        </parameters>
                      </methodInvokeExpression>
                    </init>
                  </variableDeclarationStatement>
                  <methodInvokeExpression methodName="RaiseExceptionIfErrors">
                    <target>
                      <variableReferenceExpression name="result"/>
                    </target>
                  </methodInvokeExpression>
                  <methodInvokeExpression methodName="AssignTo">
                    <target>
                      <variableReferenceExpression name="result"/>
                    </target>
                    <parameters>
                      <argumentReferenceExpression name="the{@name}"/>
                    </parameters>
                  </methodInvokeExpression>
                  <methodReturnStatement>
                    <propertyReferenceExpression name="RowsAffected">
                      <variableReferenceExpression name="result"/>
                    </propertyReferenceExpression>
                  </methodReturnStatement>
                </statements>
              </memberMethod>
              <xsl:if test="c:fields/c:field[@isPrimaryKey='true']">
                <!-- method Update(Object, Object) -->
                <memberMethod returnType="System.Int32" name="{$UpdateMethod}">
                  <attributes public="true"/>
                  <customAttributes>
                    <customAttribute name="System.ComponentModel.DataObjectMethod">
                      <arguments>
                        <propertyReferenceExpression name="Update">
                          <typeReferenceExpression type="System.ComponentModel.DataObjectMethodType"/>
                        </propertyReferenceExpression>
                      </arguments>
                    </customAttribute>
                  </customAttributes>
                  <parameters>
                    <parameter type="{$QualifiedName}" name="the{@name}"/>
                    <parameter type="{$QualifiedName}" name="original_{@name}"/>
                  </parameters>
                  <statements>
                    <methodReturnStatement>
                      <methodInvokeExpression methodName="ExecuteAction">
                        <parameters>
                          <argumentReferenceExpression name="the{@name}"/>
                          <argumentReferenceExpression name="original_{@name}"/>
                          <primitiveExpression value="Edit"/>
                          <primitiveExpression value="Update"/>
                          <propertyReferenceExpression name="UpdateView"/>
                        </parameters>
                      </methodInvokeExpression>
                    </methodReturnStatement>
                  </statements>
                </memberMethod>
                <!-- method Update(Object) -->
                <memberMethod returnType="System.Int32" name="{$UpdateMethod}">
                  <attributes public="true"/>
                  <customAttributes>
                    <customAttribute name="System.ComponentModel.DataObjectMethod">
                      <arguments>
                        <propertyReferenceExpression name="Update">
                          <typeReferenceExpression type="System.ComponentModel.DataObjectMethodType"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="true"/>
                      </arguments>
                    </customAttribute>
                  </customAttributes>
                  <parameters>
                    <parameter type="{$QualifiedName}" name="the{@name}"/>
                  </parameters>
                  <statements>
                    <methodReturnStatement>
                      <methodInvokeExpression methodName="{$UpdateMethod}">
                        <parameters>
                          <argumentReferenceExpression name="the{@name}"/>
                          <methodInvokeExpression methodName="{$SelectSingleMethod}">
                            <parameters>
                              <xsl:for-each select="c:fields/c:field[@isPrimaryKey='true']">
                                <propertyReferenceExpression>
                                  <xsl:attribute name="name">
                                    <xsl:value-of select="@name"/>
                                    <xsl:if test="@name=$ObjectName">
                                      <xsl:text>_</xsl:text>
                                    </xsl:if>
                                  </xsl:attribute>
                                  <argumentReferenceExpression name="the{$ObjectName}"/>
                                </propertyReferenceExpression>
                              </xsl:for-each>
                            </parameters>
                          </methodInvokeExpression>
                        </parameters>
                      </methodInvokeExpression>
                    </methodReturnStatement>
                  </statements>
                </memberMethod>
                <!-- int Insert(Object) -->
                <memberMethod returnType="System.Int32" name="{$InsertMethod}">
                  <attributes public="true"/>
                  <customAttributes>
                    <customAttribute name="System.ComponentModel.DataObjectMethod">
                      <arguments>
                        <propertyReferenceExpression name="Insert">
                          <typeReferenceExpression type="System.ComponentModel.DataObjectMethodType"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="true"/>
                      </arguments>
                    </customAttribute>
                  </customAttributes>
                  <parameters>
                    <parameter type="{$QualifiedName}" name="the{@name}"/>
                  </parameters>
                  <statements>
                    <methodReturnStatement>
                      <methodInvokeExpression methodName="ExecuteAction">
                        <parameters>
                          <argumentReferenceExpression name="the{@name}"/>
                          <objectCreateExpression type="{@name}"/>
                          <primitiveExpression value="New"/>
                          <primitiveExpression value="Insert"/>
                          <propertyReferenceExpression name="InsertView"/>
                        </parameters>
                      </methodInvokeExpression>
                    </methodReturnStatement>
                  </statements>
                </memberMethod>
                <!-- int Delete(Object) -->
                <memberMethod returnType="System.Int32" name="{$DeleteMethod}">
                  <attributes public="true"/>
                  <customAttributes>
                    <customAttribute name="System.ComponentModel.DataObjectMethod">
                      <arguments>
                        <propertyReferenceExpression name="Delete">
                          <typeReferenceExpression type="System.ComponentModel.DataObjectMethodType"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="true"/>
                      </arguments>
                    </customAttribute>
                  </customAttributes>
                  <parameters>
                    <parameter type="{$QualifiedName}" name="the{@name}"/>
                  </parameters>
                  <statements>
                    <methodReturnStatement>
                      <methodInvokeExpression methodName="ExecuteAction">
                        <parameters>
                          <argumentReferenceExpression name="the{@name}"/>
                          <argumentReferenceExpression name="the{@name}"/>
                          <primitiveExpression value="Select"/>
                          <primitiveExpression value="Delete"/>
                          <propertyReferenceExpression name="DeleteView"/>
                        </parameters>
                      </methodInvokeExpression>
                    </methodReturnStatement>
                  </statements>
                </memberMethod>
              </xsl:if>
            </xsl:if>
          </members>
        </typeDeclaration>
      </types>
    </compileUnit>
  </xsl:template>

</xsl:stylesheet>
