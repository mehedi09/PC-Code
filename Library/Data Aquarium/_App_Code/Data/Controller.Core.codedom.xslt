﻿<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.codeontime.com/2008/codedom-compiler"  xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl a"
>
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="IsPremium"/>
  <xsl:param name="IsUnlimited"/>
  <xsl:param name="Auditing" select="a:project/a:features/a:ease/a:auditing"/>
  <!-- $Mobile parameter must be set to "false" for DNN and SharePoint -->
  <xsl:param name="Mobile" select="'true'"/>
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
        <xsl:if test="$IsUnlimited='true'">
          <namespaceImport name="System.Security.Cryptography"/>
        </xsl:if>
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
        <namespaceImport name="{$Namespace}.Services"/>
      </imports>
      <types>
        <!-- Controller -->
        <typeDeclaration name="Controller" isPartial="true">
          <baseTypes>
            <typeReference type="DataControllerBase"/>
          </baseTypes>
        </typeDeclaration>
        <!-- DataControllerBase -->
        <typeDeclaration name="DataControllerBase" isPartial="true">
          <baseTypes>
            <typeReference type="System.Object"/>
            <typeReference type="IDataController"/>
            <typeReference type="IAutoCompleteManager"/>
            <typeReference type="IDataEngine"/>
            <typeReference type="IBusinessObject"/>
          </baseTypes>
          <members>
            <memberField type="System.Int32" name="MaximumDistinctValues">
              <attributes public="true" const="true"/>
              <init>
                <primitiveExpression value="200"/>
              </init>
            </memberField>
            <!-- constructor DataControllerBase() -->
            <constructor>
              <attributes public="true"/>
              <statements>
                <methodInvokeExpression methodName="Initialize"/>
              </statements>
            </constructor>
            <!-- method Initialize() -->
            <memberMethod name="Initialize">
              <attributes family="true"/>
              <statements>
                <methodInvokeExpression methodName="Initialize">
                  <target>
                    <typeReferenceExpression type="CultureManager"/>
                  </target>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- type constructor DataControllerBase () -->
            <typeConstructor>
              <statements>
                <comment>initialize type map</comment>
                <assignStatement>
                  <fieldReferenceExpression name="typeMap"/>
                  <objectCreateExpression type="SortedDictionary">
                    <typeArguments>
                      <typeReference type="System.String"/>
                      <typeReference type="Type"/>
                    </typeArguments>
                  </objectCreateExpression>
                </assignStatement>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="typeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="AnsiString"/>
                    <typeofExpression type="System.String"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="typeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Binary"/>
                    <typeofExpression type="System.Byte[]"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="typeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Byte"/>
                    <typeofExpression type="System.Byte"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="typeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Boolean"/>
                    <typeofExpression type="System.Boolean"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="typeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Currency"/>
                    <typeofExpression type="System.Decimal"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="typeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Date"/>
                    <typeofExpression type="DateTime"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="typeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="DateTime"/>
                    <typeofExpression type="DateTime"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="typeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Decimal"/>
                    <typeofExpression type="System.Decimal"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="typeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Double"/>
                    <typeofExpression type="System.Double"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="typeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Guid"/>
                    <typeofExpression type="Guid"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="typeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Int16"/>
                    <typeofExpression type="System.Int16"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="typeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Int32"/>
                    <typeofExpression type="System.Int32"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="typeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Int64"/>
                    <typeofExpression type="System.Int64"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="typeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Object"/>
                    <typeofExpression type="System.Object"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="typeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="SByte"/>
                    <typeofExpression type="System.SByte"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="typeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Single"/>
                    <typeofExpression type="System.Single"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="typeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="String"/>
                    <typeofExpression type="System.String"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="typeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Time"/>
                    <typeofExpression type="TimeSpan"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="typeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="TimeSpan"/>
                    <typeofExpression type="DateTime"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="typeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="UInt16"/>
                    <typeofExpression type="System.UInt16"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="typeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="UInt32"/>
                    <typeofExpression type="System.UInt32"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="typeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="UInt64"/>
                    <typeofExpression type="System.UInt64"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="typeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="VarNumeric"/>
                    <typeofExpression type="System.Object"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="typeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="AnsiStringFixedLength"/>
                    <typeofExpression type="System.String"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="typeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="StringFixedLength"/>
                    <typeofExpression type="System.String"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="typeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Xml"/>
                    <typeofExpression type="System.String"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="typeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="DateTime2"/>
                    <typeofExpression type="DateTime"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="typeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="DateTimeOffset"/>
                    <typeofExpression type="DateTimeOffset"/>
                  </parameters>
                </methodInvokeExpression>
                <comment>initialize rowset type map</comment>
                <assignStatement>
                  <fieldReferenceExpression name="rowsetTypeMap"/>
                  <objectCreateExpression type="SortedDictionary">
                    <typeArguments>
                      <typeReference type="System.String"/>
                      <typeReference type="System.String"/>
                    </typeArguments>
                  </objectCreateExpression>
                </assignStatement>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="rowsetTypeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="AnsiString"/>
                    <primitiveExpression value="string"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="rowsetTypeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Binary"/>
                    <primitiveExpression value="bin.base64"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="rowsetTypeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Byte"/>
                    <primitiveExpression value="u1"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="rowsetTypeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Boolean"/>
                    <primitiveExpression value="boolean"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="rowsetTypeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Currency"/>
                    <primitiveExpression value="float"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="rowsetTypeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Date"/>
                    <primitiveExpression value="date"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="rowsetTypeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="DateTime"/>
                    <primitiveExpression value="dateTime"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="rowsetTypeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Decimal"/>
                    <primitiveExpression value="float"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="rowsetTypeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Double"/>
                    <primitiveExpression value="float"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="rowsetTypeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Guid"/>
                    <primitiveExpression value="uuid"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="rowsetTypeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Int16"/>
                    <primitiveExpression value="i2"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="rowsetTypeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Int32"/>
                    <primitiveExpression value="i4"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="rowsetTypeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Int64"/>
                    <primitiveExpression value="i8"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="rowsetTypeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Object"/>
                    <primitiveExpression value="string"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="rowsetTypeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="SByte"/>
                    <primitiveExpression value="i1"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="rowsetTypeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Single"/>
                    <primitiveExpression value="float"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="rowsetTypeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="String"/>
                    <primitiveExpression value="string"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="rowsetTypeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Time"/>
                    <primitiveExpression value="time"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="rowsetTypeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="UInt16"/>
                    <primitiveExpression value="u2"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="rowsetTypeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="UInt32"/>
                    <primitiveExpression value="u4"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="rowsetTypeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="UIn64"/>
                    <primitiveExpression value="u8"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="rowsetTypeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="VarNumeric"/>
                    <primitiveExpression value="float"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="rowsetTypeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="AnsiStringFixedLength"/>
                    <primitiveExpression value="string"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="rowsetTypeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="StringFixedLength"/>
                    <primitiveExpression value="string"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="rowsetTypeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="Xml"/>
                    <primitiveExpression value="string"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="rowsetTypeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="DateTime2"/>
                    <primitiveExpression value="dateTime"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="rowsetTypeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="DateTimeOffset"/>
                    <primitiveExpression value="dateTime.tz"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <fieldReferenceExpression name="rowsetTypeMap"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="TimeSpan"/>
                    <primitiveExpression value="time"/>
                  </parameters>
                </methodInvokeExpression>
                <comment>initialize the special converters</comment>
                <assignStatement>
                  <propertyReferenceExpression name="SpecialConverters"/>
                  <arrayCreateExpression>
                    <createType type="SpecialConversionFunction"/>
                    <sizeExpression>
                      <propertyReferenceExpression name="Length">
                        <propertyReferenceExpression name="SpecialConversionTypes"/>
                      </propertyReferenceExpression>
                    </sizeExpression>
                  </arrayCreateExpression>
                </assignStatement>
                <assignStatement>
                  <arrayIndexerExpression>
                    <target>
                      <propertyReferenceExpression name="SpecialConverters"/>
                    </target>
                    <indices>
                      <primitiveExpression value="0"/>
                    </indices>
                  </arrayIndexerExpression>
                  <addressOfExpression>
                    <methodReferenceExpression methodName="ConvertToGuid"/>
                  </addressOfExpression>
                </assignStatement>
                <assignStatement>
                  <arrayIndexerExpression>
                    <target>
                      <propertyReferenceExpression name="SpecialConverters"/>
                    </target>
                    <indices>
                      <primitiveExpression value="1"/>
                    </indices>
                  </arrayIndexerExpression>
                  <addressOfExpression>
                    <methodReferenceExpression methodName="ConvertToDateTimeOffset"/>
                  </addressOfExpression>
                </assignStatement>
                <assignStatement>
                  <arrayIndexerExpression>
                    <target>
                      <propertyReferenceExpression name="SpecialConverters"/>
                    </target>
                    <indices>
                      <primitiveExpression value="2"/>
                    </indices>
                  </arrayIndexerExpression>
                  <addressOfExpression>
                    <methodReferenceExpression methodName="ConvertToTimeSpan"/>
                  </addressOfExpression>
                </assignStatement>
              </statements>
            </typeConstructor>
            <!-- method StringIsNull(string) -->
            <memberMethod returnType="System.Boolean" name="StringIsNull">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="s"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <binaryOperatorExpression operator="BooleanOr">
                    <binaryOperatorExpression operator="ValueEquality">
                      <argumentReferenceExpression name="s"/>
                      <primitiveExpression value="null" convertTo="String"/>
                    </binaryOperatorExpression>
                    <binaryOperatorExpression operator="ValueEquality">
                      <argumentReferenceExpression name="s"/>
                      <primitiveExpression value="%js%null"/>
                    </binaryOperatorExpression>
                  </binaryOperatorExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method ConvertToType(Type, object) -->
            <typeDelegate type="System.Object" name="SpecialConversionFunction">
              <attributes public="true"/>
              <parameters>
                <parameter type="System.Object" name="o"/>
              </parameters>
            </typeDelegate>
            <memberField type="Type[]" name="SpecialConversionTypes">
              <attributes public="true" static="true"/>
              <init>
                <arrayCreateExpression>
                  <createType type="Type"/>
                  <initializers>
                    <typeofExpression type="System.Guid"/>
                    <typeofExpression type="System.DateTimeOffset"/>
                    <typeofExpression type="System.TimeSpan"/>
                  </initializers>
                </arrayCreateExpression>
              </init>
            </memberField>
            <memberField type="SpecialConversionFunction[]" name="SpecialConverters">
              <attributes public="true" static="true"/>
            </memberField>
            <memberMethod returnType="System.Object" name="ConvertToGuid">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.Object" name="o"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <objectCreateExpression type="Guid">
                    <parameters>
                      <methodInvokeExpression methodName="ToString">
                        <target>
                          <typeReferenceExpression type="Convert"/>
                        </target>
                        <parameters>
                          <argumentReferenceExpression name="o"/>
                        </parameters>
                      </methodInvokeExpression>
                    </parameters>
                  </objectCreateExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <memberMethod returnType="System.Object" name="ConvertToDateTimeOffset">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.Object" name="o"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="Parse">
                    <target>
                      <typeReferenceExpression type="System.DateTimeOffset"/>
                    </target>
                    <parameters>
                      <methodInvokeExpression methodName="ToString">
                        <target>
                          <typeReferenceExpression type="Convert"/>
                        </target>
                        <parameters>
                          <argumentReferenceExpression name="o"/>
                        </parameters>
                      </methodInvokeExpression>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <memberMethod returnType="System.Object" name="ConvertToTimeSpan">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.Object" name="o"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="Parse">
                    <target>
                      <typeReferenceExpression type="System.TimeSpan"/>
                    </target>
                    <parameters>
                      <methodInvokeExpression methodName="ToString">
                        <target>
                          <typeReferenceExpression type="Convert"/>
                        </target>
                        <parameters>
                          <argumentReferenceExpression name="o"/>
                        </parameters>
                      </methodInvokeExpression>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <memberMethod returnType="System.Object" name="ConvertToType">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="Type" name="targetType"/>
                <parameter type="System.Object" name="o"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <propertyReferenceExpression name="IsGenericType">
                      <argumentReferenceExpression name="targetType"/>
                    </propertyReferenceExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <argumentReferenceExpression name="targetType"/>
                      <propertyReferenceExpression name="PropertyType">
                        <methodInvokeExpression methodName="GetProperty">
                          <target>
                            <argumentReferenceExpression name="targetType"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="Value"/>
                          </parameters>
                        </methodInvokeExpression>
                      </propertyReferenceExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanOr">
                      <binaryOperatorExpression operator="IdentityEquality">
                        <argumentReferenceExpression name="o"/>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                      <methodInvokeExpression methodName="Equals">
                        <target>
                          <methodInvokeExpression methodName="GetType">
                            <target>
                              <argumentReferenceExpression name="o"/>
                            </target>
                          </methodInvokeExpression>
                        </target>
                        <parameters>
                          <argumentReferenceExpression name="targetType"/>
                        </parameters>
                      </methodInvokeExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <argumentReferenceExpression name="o"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
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
                        <propertyReferenceExpression name="SpecialConversionTypes"/>
                      </propertyReferenceExpression>
                    </binaryOperatorExpression>
                  </test>
                  <increment>
                    <variableReferenceExpression name="i"/>
                  </increment>
                  <statements>
                    <variableDeclarationStatement type="Type" name="t">
                      <init>
                        <arrayIndexerExpression>
                          <target>
                            <propertyReferenceExpression name="SpecialConversionTypes"/>
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
                          <variableReferenceExpression name="t"/>
                          <argumentReferenceExpression name="targetType"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodReturnStatement>
                          <delegateInvokeExpression>
                            <target>
                              <arrayIndexerExpression>
                                <target>
                                  <propertyReferenceExpression name="SpecialConverters"/>
                                </target>
                                <indices>
                                  <variableReferenceExpression name="i"/>
                                </indices>
                              </arrayIndexerExpression>
                            </target>
                            <parameters>
                              <argumentReferenceExpression name="o"/>
                            </parameters>
                          </delegateInvokeExpression>
                        </methodReturnStatement>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </forStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IsTypeOf">
                      <argumentReferenceExpression name="o"/>
                      <typeReferenceExpression type="IConvertible"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <argumentReferenceExpression name="o"/>
                      <methodInvokeExpression methodName="ChangeType">
                        <target>
                          <typeReferenceExpression type="Convert"/>
                        </target>
                        <parameters>
                          <argumentReferenceExpression name="o"/>
                          <variableReferenceExpression name="targetType"/>
                        </parameters>
                      </methodInvokeExpression>
                    </assignStatement>
                  </trueStatements>
                  <falseStatements>
                    <!--  if (targetType.Equals(typeof(String)) && o != null)
                o = Convert.ToString(o);-->
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanAnd">
                          <methodInvokeExpression methodName="Equals">
                            <target>
                              <argumentReferenceExpression name="targetType"/>
                            </target>
                            <parameters>
                              <typeofExpression type="System.String"/>
                            </parameters>
                          </methodInvokeExpression>
                          <binaryOperatorExpression operator="IdentityInequality">
                            <argumentReferenceExpression name="o"/>
                            <primitiveExpression value="null"/>
                          </binaryOperatorExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <argumentReferenceExpression name="o"/>
                          <methodInvokeExpression methodName="ToString">
                            <target>
                              <argumentReferenceExpression name="o"/>
                            </target>
                          </methodInvokeExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                  </falseStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <argumentReferenceExpression name="o"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method ValueToString(object) -->
            <memberMethod returnType="System.String" name="ValueToString">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.Object" name="o"/>
              </parameters>
              <statements>
                <comment>#pragma warning disable 0618</comment>
                <variableDeclarationStatement type="System.Web.Script.Serialization.JavaScriptSerializer" name="serializer">
                  <init>
                    <objectCreateExpression type="System.Web.Script.Serialization.JavaScriptSerializer"/>
                  </init>
                </variableDeclarationStatement>
                <comment>#pragma warning restore 0618</comment>
                <methodReturnStatement>
                  <binaryOperatorExpression operator="Add">
                    <primitiveExpression value="%js%"/>
                    <methodInvokeExpression methodName="Serialize">
                      <target>
                        <variableReferenceExpression name="serializer"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="o"/>
                      </parameters>
                    </methodInvokeExpression>
                  </binaryOperatorExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method StringToValue(string) -->
            <memberMethod returnType="System.Object" name="StringToValue">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="s"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="StringToValue">
                    <parameters>
                      <primitiveExpression value="null"/>
                      <argumentReferenceExpression name="s"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method StringToValue(DataField, string) -->
            <memberMethod returnType="System.Object" name="StringToValue">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="DataField" name="field"/>
                <parameter type="System.String" name="s"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <unaryOperatorExpression operator="IsNotNullOrEmpty">
                        <argumentReferenceExpression name="s"/>
                      </unaryOperatorExpression>
                      <methodInvokeExpression methodName="StartsWith">
                        <target>
                          <argumentReferenceExpression name="s"/>
                        </target>
                        <parameters>
                          <primitiveExpression value="%js%"/>
                        </parameters>
                      </methodInvokeExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <comment>#pragma warning disable 0618</comment>
                    <variableDeclarationStatement type="System.Web.Script.Serialization.JavaScriptSerializer" name="serializer">
                      <init>
                        <objectCreateExpression type="System.Web.Script.Serialization.JavaScriptSerializer"/>
                      </init>
                    </variableDeclarationStatement>
                    <comment>#pragma warning restore 0618</comment>
                    <variableDeclarationStatement type="System.Object" name="v">
                      <init>
                        <methodInvokeExpression methodName="Deserialize">
                          <typeArguments>
                            <typeReference type="System.Object"/>
                          </typeArguments>
                          <target>
                            <variableReferenceExpression name="serializer"/>
                          </target>
                          <parameters>
                            <methodInvokeExpression methodName="Substring">
                              <target>
                                <argumentReferenceExpression name="s"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="4"/>
                              </parameters>
                            </methodInvokeExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanOr">
                          <unaryOperatorExpression operator="Not">
                            <binaryOperatorExpression operator="IsTypeOf">
                              <variableReferenceExpression name="v"/>
                              <typeReferenceExpression type="System.String"/>
                            </binaryOperatorExpression>
                          </unaryOperatorExpression>
                          <binaryOperatorExpression operator="BooleanOr">
                            <binaryOperatorExpression operator="IdentityEquality">
                              <argumentReferenceExpression name="field"/>
                              <primitiveExpression value="null"/>
                            </binaryOperatorExpression>
                            <binaryOperatorExpression operator="ValueEquality">
                              <propertyReferenceExpression name="Type">
                                <argumentReferenceExpression name="field"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="String"/>
                            </binaryOperatorExpression>
                          </binaryOperatorExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodReturnStatement>
                          <variableReferenceExpression name="v"/>
                        </methodReturnStatement>
                      </trueStatements>
                    </conditionStatement>
                    <assignStatement>
                      <argumentReferenceExpression name="s"/>
                      <castExpression targetType="System.String">
                        <variableReferenceExpression name="v"/>
                      </castExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <argumentReferenceExpression name="field"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <methodInvokeExpression methodName="ConvertFromString">
                        <target>
                          <methodInvokeExpression methodName="GetConverter">
                            <target>
                              <typeReferenceExpression type="TypeDescriptor"/>
                            </target>
                            <parameters>
                              <arrayIndexerExpression>
                                <target>
                                  <propertyReferenceExpression name="TypeMap">
                                    <typeReferenceExpression type="Controller"/>
                                  </propertyReferenceExpression>
                                </target>
                                <indices>
                                  <propertyReferenceExpression name="Type">
                                    <argumentReferenceExpression name="field"/>
                                  </propertyReferenceExpression>
                                </indices>
                              </arrayIndexerExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </target>
                        <parameters>
                          <argumentReferenceExpression name="s"/>
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
            <!-- method ConvertObjectToValue(object) -->
            <memberField type="System.String[]" name="SpecialTypes">
              <attributes static="true" public="true"/>
              <init>
                <arrayCreateExpression>
                  <createType type="System.String"/>
                  <initializers>
                    <primitiveExpression value="System.DateTimeOffset"/>
                    <primitiveExpression value="System.TimeSpan"/>
                    <primitiveExpression value="Microsoft.SqlServer.Types.SqlGeography"/>
                    <primitiveExpression value="Microsoft.SqlServer.Types.SqlHierarchyId"/>
                  </initializers>
                </arrayCreateExpression>
              </init>
            </memberField>
            <memberMethod returnType="System.Object" name="ConvertObjectToValue">
              <attributes static="true" public="true"/>
              <parameters>
                <parameter type="System.Object" name="o"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="Contains">
                      <target>
                        <propertyReferenceExpression name="SpecialTypes"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="FullName">
                          <methodInvokeExpression methodName="GetType">
                            <target>
                              <argumentReferenceExpression name="o"/>
                            </target>
                          </methodInvokeExpression>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <methodInvokeExpression methodName="ToString">
                        <target>
                          <argumentReferenceExpression name="o"/>
                        </target>
                      </methodInvokeExpression>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <argumentReferenceExpression name="o"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method EnsureJsonCompatibility(object) -->
            <memberMethod returnType="System.Object" name="EnsureJsonCompatibility">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.Object" name="o"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <argumentReferenceExpression name="o"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IsTypeOf">
                          <argumentReferenceExpression name="o"/>
                          <typeReferenceExpression type="List">
                            <typeArguments>
                              <typeReference type="System.Object[]"/>
                            </typeArguments>
                          </typeReferenceExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <foreachStatement>
                          <variable type="System.Object[]" name="values"/>
                          <target>
                            <castExpression targetType="List">
                              <typeArguments>
                                <typeReference type="System.Object[]"/>
                              </typeArguments>
                              <argumentReferenceExpression name="o"/>
                            </castExpression>
                          </target>
                          <statements>
                            <methodInvokeExpression methodName="EnsureJsonCompatibility">
                              <parameters>
                                <variableReferenceExpression name="values"/>
                              </parameters>
                            </methodInvokeExpression>
                          </statements>
                        </foreachStatement>
                      </trueStatements>
                      <falseStatements>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="BooleanAnd">
                              <binaryOperatorExpression operator="IsTypeOf">
                                <argumentReferenceExpression name="o"/>
                                <typeReferenceExpression type="Array"/>
                              </binaryOperatorExpression>
                              <binaryOperatorExpression operator="IdentityEquality">
                                <methodInvokeExpression methodName="GetElementType">
                                  <target>
                                    <methodInvokeExpression methodName="GetType">
                                      <target>
                                        <variableReferenceExpression name="o"/>
                                      </target>
                                    </methodInvokeExpression>
                                  </target>
                                </methodInvokeExpression>
                                <typeofExpression type="System.Object"/>
                              </binaryOperatorExpression>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <variableDeclarationStatement type="System.Object[]" name="row">
                              <init>
                                <castExpression targetType="System.Object[]">
                                  <argumentReferenceExpression name="o"/>
                                </castExpression>
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
                                  <propertyReferenceExpression name="Length">
                                    <variableReferenceExpression name="row"/>
                                  </propertyReferenceExpression>
                                </binaryOperatorExpression>
                              </test>
                              <increment>
                                <variableReferenceExpression name="i"/>
                              </increment>
                              <statements>
                                <assignStatement>
                                  <arrayIndexerExpression>
                                    <target>
                                      <variableReferenceExpression name="row"/>
                                    </target>
                                    <indices>
                                      <variableReferenceExpression name="i"/>
                                    </indices>
                                  </arrayIndexerExpression>
                                  <methodInvokeExpression methodName="EnsureJsonCompatibility">
                                    <parameters>
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
                              </statements>
                            </forStatement>
                          </trueStatements>
                          <falseStatements>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="IsTypeOf">
                                  <argumentReferenceExpression name="o"/>
                                  <typeReferenceExpression type="DateTime"/>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <methodReturnStatement>
                                  <methodInvokeExpression methodName="ToString">
                                    <target>
                                      <castExpression targetType="DateTime">
                                        <argumentReferenceExpression name="o"/>
                                      </castExpression>
                                    </target>
                                    <parameters>
                                      <primitiveExpression value="yyyy-MM-ddTHH\:mm\:ss.fffZ"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                </methodReturnStatement>
                              </trueStatements>
                            </conditionStatement>
                          </falseStatements>
                        </conditionStatement>
                      </falseStatements>
                    </conditionStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <argumentReferenceExpression name="o"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method CreateBusinessRules() -->
            <memberMethod returnType="BusinessRules" name="CreateBusinessRules">
              <attributes family="true" final="true"/>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="Create">
                    <target>
                      <typeReferenceExpression type="BusinessRules"/>
                    </target>
                    <parameters>
                      <fieldReferenceExpression name="config"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- field serverRules-->
            <memberField type="BusinessRules" name="serverRules">
              <attributes private="true"/>
            </memberField>
            <!-- method InitBusinessRules(PageRequest, ViewPage) -->
            <memberMethod returnType="BusinessRules" name="InitBusinessRules">
              <attributes family="true"/>
              <parameters>
                <parameter type="PageRequest" name="request"/>
                <parameter type="ViewPage" name="page"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="BusinessRules" name="rules">
                  <init>
                    <methodInvokeExpression methodName="CreateBusinessRules">
                      <target>
                        <fieldReferenceExpression name="config"/>
                      </target>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <assignStatement>
                  <fieldReferenceExpression name="serverRules"/>
                  <variableReferenceExpression name="rules"/>
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
                <assignStatement>
                  <propertyReferenceExpression name="Page">
                    <fieldReferenceExpression name="serverRules"/>
                  </propertyReferenceExpression>
                  <variableReferenceExpression name="page"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="RequiresRowCount">
                    <fieldReferenceExpression name="serverRules"/>
                  </propertyReferenceExpression>
                  <binaryOperatorExpression operator="BooleanAnd">
                    <propertyReferenceExpression name="RequiresRowCount">
                      <argumentReferenceExpression name="page"/>
                    </propertyReferenceExpression>
                    <unaryOperatorExpression operator="Not">
                      <binaryOperatorExpression operator="BooleanOr">
                        <propertyReferenceExpression name="Inserting">
                          <argumentReferenceExpression name="request"/>
                        </propertyReferenceExpression>
                        <propertyReferenceExpression name="DoesNotRequireData">
                          <argumentReferenceExpression name="request"/>
                        </propertyReferenceExpression>
                      </binaryOperatorExpression>
                    </unaryOperatorExpression>
                  </binaryOperatorExpression>
                </assignStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <variableReferenceExpression name="rules"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <!--<assignStatement>
                      <propertyReferenceExpression name="Page">
                        <variableReferenceExpression name="rules"/>
                      </propertyReferenceExpression>
                      <variableReferenceExpression name="page"/>
                    </assignStatement>-->
                    <methodInvokeExpression methodName="BeforeSelect">
                      <target>
                        <variableReferenceExpression name="rules"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="request"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                  <falseStatements>
                    <methodInvokeExpression methodName="ExecuteServerRules">
                      <target>
                        <fieldReferenceExpression name="serverRules"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="request"/>
                        <propertyReferenceExpression name="Before">
                          <typeReferenceExpression type="ActionPhase"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </falseStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <variableReferenceExpression name="rules"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method GetPageList(PageRequeest[]) -->
            <memberMethod returnType="ViewPage[]" name="GetPageList">
              <attributes public="true"/>
              <parameters>
                <parameter type="PageRequest[]" name="requests"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="List" name="result">
                  <typeArguments>
                    <typeReference type="ViewPage"/>
                  </typeArguments>
                  <init>
                    <objectCreateExpression type="List">
                      <typeArguments>
                        <typeReference type="ViewPage"/>
                      </typeArguments>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <foreachStatement>
                  <variable type="PageRequest" name="r"/>
                  <target>
                    <argumentReferenceExpression name="requests"/>
                  </target>
                  <statements>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <variableReferenceExpression name="result"/>
                      </target>
                      <parameters>
                        <methodInvokeExpression methodName="GetPage">
                          <target>
                            <castExpression targetType="IDataController">
                              <thisReferenceExpression/>
                            </castExpression>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="Controller">
                              <argumentReferenceExpression name="r"/>
                            </propertyReferenceExpression>
                            <propertyReferenceExpression name="View">
                              <argumentReferenceExpression name="r"/>
                            </propertyReferenceExpression>
                            <argumentReferenceExpression name="r"/>
                          </parameters>
                        </methodInvokeExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </statements>
                </foreachStatement>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="ToArray">
                    <target>
                      <variableReferenceExpression name="result"/>
                    </target>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method IDataController.GetPage(string, string, PageRequest)-->
            <memberMethod returnType="ViewPage" name="GetPage" privateImplementationType="IDataController">
              <attributes/>
              <parameters>
                <parameter type="System.String" name="controller"/>
                <parameter type="System.String" name="view"/>
                <parameter type="PageRequest" name="request"/>
              </parameters>
              <statements>
                <methodInvokeExpression methodName="SelectView">
                  <parameters>
                    <argumentReferenceExpression name="controller"/>
                    <argumentReferenceExpression name="view"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="AssignContext">
                  <target>
                    <argumentReferenceExpression name="request"/>
                  </target>
                  <parameters>
                    <argumentReferenceExpression name="controller"/>
                    <fieldReferenceExpression name="viewId">
                      <thisReferenceExpression/>
                    </fieldReferenceExpression>
                    <fieldReferenceExpression name="config"/>
                  </parameters>
                </methodInvokeExpression>
                <variableDeclarationStatement type="ViewPage" name="page">
                  <init>
                    <objectCreateExpression type="ViewPage">
                      <parameters>
                        <argumentReferenceExpression name="request"/>
                      </parameters>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <propertyReferenceExpression name="PlugIn">
                        <fieldReferenceExpression name="config"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="PreProcessPageRequest">
                      <target>
                        <propertyReferenceExpression name="PlugIn">
                          <fieldReferenceExpression name="config"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="request"/>
                        <variableReferenceExpression name="page"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <methodInvokeExpression methodName="AssignDynamicExpressions">
                  <target>
                    <fieldReferenceExpression name="config"/>
                  </target>
                  <parameters>
                    <variableReferenceExpression name="page"/>
                  </parameters>
                </methodInvokeExpression>
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
                      <argumentReferenceExpression name="request"/>
                    </propertyReferenceExpression>
                    <propertyReferenceExpression name="View">
                      <argumentReferenceExpression name="request"/>
                    </propertyReferenceExpression>
                    <propertyReferenceExpression name="LookupContextController">
                      <argumentReferenceExpression name="request"/>
                    </propertyReferenceExpression>
                    <propertyReferenceExpression name="LookupContextView">
                      <argumentReferenceExpression name="request"/>
                    </propertyReferenceExpression>
                    <propertyReferenceExpression name="LookupContextFieldName">
                      <argumentReferenceExpression name="request"/>
                    </propertyReferenceExpression>
                  </parameters>
                </methodInvokeExpression>
                <variableDeclarationStatement type="BusinessRules" name="rules">
                  <init>
                    <methodInvokeExpression methodName="InitBusinessRules">
                      <parameters>
                        <argumentReferenceExpression name="request"/>
                        <variableReferenceExpression name="page"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <usingStatement>
                  <variable type="DbConnection" name="connection">
                    <init>
                      <methodInvokeExpression methodName="CreateConnection"/>
                    </init>
                  </variable>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <propertyReferenceExpression name="RequiresRowCount">
                          <fieldReferenceExpression name="serverRules"/>
                        </propertyReferenceExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="DbCommand" name="countCommand">
                          <init>
                            <methodInvokeExpression methodName="CreateCommand">
                              <parameters>
                                <variableReferenceExpression name="connection"/>
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <methodInvokeExpression methodName="ConfigureCommand">
                          <parameters>
                            <variableReferenceExpression name="countCommand"/>
                            <variableReferenceExpression name="page"/>
                            <propertyReferenceExpression name="SelectCount">
                              <typeReferenceExpression type="CommandConfigurationType"/>
                            </propertyReferenceExpression>
                            <primitiveExpression value="null"/>
                          </parameters>
                        </methodInvokeExpression>
                        <conditionStatement>
                          <condition>
                            <propertyReferenceExpression name="EnableResultSet">
                              <fieldReferenceExpression name="serverRules"/>
                            </propertyReferenceExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="TotalRowCount">
                                <variableReferenceExpression name="page"/>
                              </propertyReferenceExpression>
                              <propertyReferenceExpression name="ResultSetSize">
                                <fieldReferenceExpression name="serverRules"/>
                              </propertyReferenceExpression>
                            </assignStatement>
                          </trueStatements>
                          <falseStatements>
                            <conditionStatement>
                              <condition>
                                <methodInvokeExpression methodName="YieldsSingleRow">
                                  <parameters>
                                    <variableReferenceExpression name="countCommand"/>
                                  </parameters>
                                </methodInvokeExpression>
                                <!--<binaryOperatorExpression operator="ValueEquality">
															<methodInvokeExpression methodName="IndexOf">
																<target>
																	<propertyReferenceExpression name="CommandText">
																		<variableReferenceExpression name="countCommand"/>
																	</propertyReferenceExpression>
																</target>
																<parameters>
																	<primitiveExpression value="count(*)"/>
																</parameters>
															</methodInvokeExpression>
															<primitiveExpression value="-1"/>
														</binaryOperatorExpression>-->
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <propertyReferenceExpression name="TotalRowCount">
                                    <variableReferenceExpression name="page"/>
                                  </propertyReferenceExpression>
                                  <primitiveExpression value="1"/>
                                </assignStatement>
                              </trueStatements>
                              <falseStatements>
                                <assignStatement>
                                  <propertyReferenceExpression name="TotalRowCount">
                                    <variableReferenceExpression name="page"/>
                                  </propertyReferenceExpression>
                                  <methodInvokeExpression methodName="ToInt32">
                                    <target>
                                      <typeReferenceExpression type="Convert"/>
                                    </target>
                                    <parameters>
                                      <methodInvokeExpression methodName="ExecuteScalar">
                                        <target>
                                          <variableReferenceExpression name="countCommand"/>
                                        </target>
                                      </methodInvokeExpression>
                                    </parameters>
                                  </methodInvokeExpression>
                                </assignStatement>
                              </falseStatements>
                            </conditionStatement>
                          </falseStatements>
                        </conditionStatement>
                        <conditionStatement>
                          <condition>
                            <propertyReferenceExpression name="RequiresAggregates">
                              <variableReferenceExpression name="page"/>
                            </propertyReferenceExpression>
                          </condition>
                          <trueStatements>
                            <variableDeclarationStatement type="DbCommand" name="aggregateCommand">
                              <init>
                                <methodInvokeExpression methodName="CreateCommand">
                                  <parameters>
                                    <variableReferenceExpression name="connection"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </init>
                            </variableDeclarationStatement>
                            <methodInvokeExpression methodName="ConfigureCommand">
                              <parameters>
                                <variableReferenceExpression name="aggregateCommand"/>
                                <variableReferenceExpression name="page"/>
                                <propertyReferenceExpression name="SelectAggregates">
                                  <typeReferenceExpression type="CommandConfigurationType"/>
                                </propertyReferenceExpression>
                                <primitiveExpression value="null"/>
                              </parameters>
                            </methodInvokeExpression>
                            <variableDeclarationStatement type="DbDataReader" name="reader">
                              <init>
                                <methodInvokeExpression methodName="ExecuteReader">
                                  <target>
                                    <variableReferenceExpression name="aggregateCommand"/>
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
                                <variableDeclarationStatement type="System.Object[]" name="aggregates">
                                  <init>
                                    <arrayCreateExpression>
                                      <createType type="System.Object"/>
                                      <sizeExpression>
                                        <propertyReferenceExpression name="Count">
                                          <propertyReferenceExpression name="Fields">
                                            <variableReferenceExpression name="page"/>
                                          </propertyReferenceExpression>
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
                                      <propertyReferenceExpression name="Length">
                                        <variableReferenceExpression name="aggregates"/>
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
                                        <variableDeclarationStatement type="System.Object" name="v">
                                          <init>
                                            <arrayIndexerExpression>
                                              <target>
                                                <variableReferenceExpression name="reader"/>
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
                                                    <propertyReferenceExpression name="FormatOnClient">
                                                      <variableReferenceExpression name="field"/>
                                                    </propertyReferenceExpression>
                                                  </unaryOperatorExpression>
                                                  <unaryOperatorExpression operator="IsNotNullOrEmpty">
                                                    <propertyReferenceExpression name="DataFormatString">
                                                      <variableReferenceExpression name="field"/>
                                                    </propertyReferenceExpression>
                                                  </unaryOperatorExpression>
                                                </binaryOperatorExpression>
                                              </condition>
                                              <trueStatements>
                                                <assignStatement>
                                                  <variableReferenceExpression name="v"/>
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
                                            </conditionStatement>
                                            <assignStatement>
                                              <arrayIndexerExpression>
                                                <target>
                                                  <variableReferenceExpression name="aggregates"/>
                                                </target>
                                                <indices>
                                                  <variableReferenceExpression name="i"/>
                                                </indices>
                                              </arrayIndexerExpression>
                                              <variableReferenceExpression name="v"/>
                                            </assignStatement>
                                          </trueStatements>
                                        </conditionStatement>
                                      </trueStatements>
                                    </conditionStatement>
                                  </statements>
                                </forStatement>
                                <assignStatement>
                                  <propertyReferenceExpression name="Aggregates">
                                    <variableReferenceExpression name="page"/>
                                  </propertyReferenceExpression>
                                  <variableReferenceExpression name="aggregates"/>
                                </assignStatement>
                              </trueStatements>
                            </conditionStatement>
                            <methodInvokeExpression methodName="Close">
                              <target>
                                <variableReferenceExpression name="reader"/>
                              </target>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
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
                    <conditionStatement>
                      <condition>
                        <propertyReferenceExpression name="RequiresMetaData">
                          <variableReferenceExpression name="page"/>
                        </propertyReferenceExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="PopulatePageCategories">
                          <parameters>
                            <variableReferenceExpression name="page"/>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                    <methodInvokeExpression methodName="SyncRequestedPage">
                      <parameters>
                        <argumentReferenceExpression name="request"/>
                        <variableReferenceExpression name="page"/>
                        <variableReferenceExpression name="connection"/>
                      </parameters>
                    </methodInvokeExpression>
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
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanAnd">
                          <binaryOperatorExpression operator="GreaterThan">
                            <propertyReferenceExpression name="PageSize">
                              <variableReferenceExpression name="page"/>
                            </propertyReferenceExpression>
                            <primitiveExpression value="0"/>
                          </binaryOperatorExpression>
                          <unaryOperatorExpression operator="Not">
                            <binaryOperatorExpression operator="BooleanOr">
                              <propertyReferenceExpression name="Inserting">
                                <argumentReferenceExpression name="request"/>
                              </propertyReferenceExpression>
                              <propertyReferenceExpression name="DoesNotRequireData">
                                <argumentReferenceExpression name="request"/>
                              </propertyReferenceExpression>
                            </binaryOperatorExpression>
                          </unaryOperatorExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="EnsureSystemPageFields">
                          <parameters>
                            <argumentReferenceExpression name="request"/>
                            <variableReferenceExpression name="page"/>
                            <variableReferenceExpression name="selectCommand"/>
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
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="IdentityEquality">
                                  <variableReferenceExpression name="selectCommand"/>
                                  <primitiveExpression value="null"/>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="reader"/>
                                  <methodInvokeExpression methodName="ExecuteVirtualReader">
                                    <parameters>
                                      <argumentReferenceExpression name="request"/>
                                      <variableReferenceExpression name="page"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                </assignStatement>
                              </trueStatements>
                              <falseStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="reader"/>
                                  <methodInvokeExpression methodName="ExecuteReader">
                                    <target>
                                      <typeReferenceExpression type="TransactionManager"/>
                                    </target>
                                    <parameters>
                                      <argumentReferenceExpression name="request"/>
                                      <variableReferenceExpression name="page"/>
                                      <variableReferenceExpression name="selectCommand"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                </assignStatement>
                              </falseStatements>
                            </conditionStatement>
                          </trueStatements>
                        </conditionStatement>
                        <whileStatement>
                          <test>
                            <methodInvokeExpression methodName="SkipNext">
                              <target>
                                <variableReferenceExpression name="page"/>
                              </target>
                            </methodInvokeExpression>
                          </test>
                          <statements>
                            <methodInvokeExpression methodName="Read">
                              <target>
                                <variableReferenceExpression name="reader"/>
                              </target>
                            </methodInvokeExpression>
                          </statements>
                        </whileStatement>
                        <whileStatement>
                          <test>
                            <binaryOperatorExpression operator="BooleanAnd">
                              <methodInvokeExpression methodName="ReadNext">
                                <target>
                                  <variableReferenceExpression name="page"/>
                                </target>
                              </methodInvokeExpression>
                              <methodInvokeExpression methodName="Read">
                                <target>
                                  <variableReferenceExpression name="reader"/>
                                </target>
                              </methodInvokeExpression>
                            </binaryOperatorExpression>
                          </test>
                          <statements>
                            <variableDeclarationStatement type="System.Object[]" name="values">
                              <init>
                                <arrayCreateExpression>
                                  <createType type="System.Object"/>
                                  <sizeExpression>
                                    <propertyReferenceExpression name="Count">
                                      <propertyReferenceExpression name="Fields">
                                        <variableReferenceExpression name="page"/>
                                      </propertyReferenceExpression>
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
                                  <propertyReferenceExpression name="Length">
                                    <variableReferenceExpression name="values"/>
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
                                <variableDeclarationStatement type="System.Object" name="v">
                                  <init>
                                    <arrayIndexerExpression>
                                      <target>
                                        <variableReferenceExpression name="reader"/>
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
                                        <propertyReferenceExpression name="IsMirror">
                                          <variableReferenceExpression name="field"/>
                                        </propertyReferenceExpression>
                                      </condition>
                                      <trueStatements>
                                        <assignStatement>
                                          <variableReferenceExpression name="v"/>
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
                                        <conditionStatement>
                                          <condition>
                                            <binaryOperatorExpression operator="BooleanAnd">
                                              <binaryOperatorExpression operator="ValueEquality">
                                                <propertyReferenceExpression name="Type">
                                                  <variableReferenceExpression name="field"/>
                                                </propertyReferenceExpression>
                                                <primitiveExpression value="Guid"/>
                                              </binaryOperatorExpression>
                                              <binaryOperatorExpression operator="IdentityEquality">
                                                <methodInvokeExpression methodName="GetType">
                                                  <target>
                                                    <variableReferenceExpression name="v"/>
                                                  </target>
                                                </methodInvokeExpression>
                                                <typeofExpression type="System.Byte[]"/>
                                              </binaryOperatorExpression>
                                            </binaryOperatorExpression>
                                          </condition>
                                          <trueStatements>
                                            <assignStatement>
                                              <variableReferenceExpression name="v"/>
                                              <objectCreateExpression type="Guid">
                                                <parameters>
                                                  <castExpression targetType="System.Byte[]">
                                                    <variableReferenceExpression name="v"/>
                                                  </castExpression>
                                                </parameters>
                                              </objectCreateExpression>
                                            </assignStatement>
                                          </trueStatements>
                                          <falseStatements>
                                            <assignStatement>
                                              <variableReferenceExpression name="v"/>
                                              <methodInvokeExpression methodName="ConvertObjectToValue">
                                                <parameters>
                                                  <variableReferenceExpression name="v"/>
                                                </parameters>
                                              </methodInvokeExpression>
                                            </assignStatement>
                                          </falseStatements>
                                        </conditionStatement>
                                      </falseStatements>
                                    </conditionStatement>
                                    <assignStatement>
                                      <arrayIndexerExpression>
                                        <target>
                                          <variableReferenceExpression name="values"/>
                                        </target>
                                        <indices>
                                          <variableReferenceExpression name="i"/>
                                        </indices>
                                      </arrayIndexerExpression>
                                      <variableReferenceExpression name="v"/>
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
                                          <propertyReferenceExpression name="SourceFields">
                                            <variableReferenceExpression name="field"/>
                                          </propertyReferenceExpression>
                                        </parameters>
                                      </methodInvokeExpression>
                                    </unaryOperatorExpression>
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
                                      <methodInvokeExpression methodName="CreateValueFromSourceFields">
                                        <parameters>
                                          <variableReferenceExpression name="field"/>
                                          <variableReferenceExpression name="reader"/>
                                        </parameters>
                                      </methodInvokeExpression>
                                    </assignStatement>
                                  </trueStatements>
                                </conditionStatement>
                              </statements>
                            </forStatement>
                            <conditionStatement>
                              <condition>
                                <propertyReferenceExpression name="RequiresPivot">
                                  <variableReferenceExpression name="page"/>
                                </propertyReferenceExpression>
                              </condition>
                              <trueStatements>
                                <methodInvokeExpression methodName="AddPivotValues">
                                  <target>
                                    <variableReferenceExpression name="page"/>
                                  </target>
                                  <parameters>
                                    <variableReferenceExpression name="values"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </trueStatements>
                              <falseStatements>
                                <methodInvokeExpression methodName="Add">
                                  <target>
                                    <propertyReferenceExpression name="Rows">
                                      <variableReferenceExpression name="page"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <parameters>
                                    <variableReferenceExpression name="values"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </falseStatements>
                            </conditionStatement>
                          </statements>
                        </whileStatement>
                        <methodInvokeExpression methodName="Close">
                          <target>
                            <variableReferenceExpression name="reader"/>
                          </target>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                    <xsl:if test="$IsPremium='true'">
                      <conditionStatement>
                        <condition>
                          <binaryOperatorExpression operator="BooleanAnd">
                            <propertyReferenceExpression name="RequiresFirstLetters">
                              <argumentReferenceExpression name="request"/>
                            </propertyReferenceExpression>
                            <binaryOperatorExpression operator="ValueInequality">
                              <fieldReferenceExpression name="viewType">
                                <thisReferenceExpression/>
                              </fieldReferenceExpression>
                              <primitiveExpression value="Form"/>
                            </binaryOperatorExpression>
                          </binaryOperatorExpression>
                        </condition>
                        <trueStatements>
                          <conditionStatement>
                            <condition>
                              <unaryOperatorExpression operator="Not">
                                <propertyReferenceExpression name="RequiresRowCount">
                                  <variableReferenceExpression name="page"/>
                                </propertyReferenceExpression>
                              </unaryOperatorExpression>
                            </condition>
                            <trueStatements>
                              <assignStatement>
                                <propertyReferenceExpression name="FirstLetters">
                                  <variableReferenceExpression name="page"/>
                                </propertyReferenceExpression>
                                <propertyReferenceExpression name="Empty">
                                  <typeReferenceExpression type="String"/>
                                </propertyReferenceExpression>
                              </assignStatement>
                            </trueStatements>
                            <falseStatements>
                              <variableDeclarationStatement type="DbCommand" name="firstLettersCommand">
                                <init>
                                  <methodInvokeExpression methodName="CreateCommand">
                                    <parameters>
                                      <variableReferenceExpression name="connection"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                </init>
                              </variableDeclarationStatement>
                              <variableDeclarationStatement type="System.String[]" name="oldFilter">
                                <init>
                                  <propertyReferenceExpression name="Filter">
                                    <variableReferenceExpression name="page"/>
                                  </propertyReferenceExpression>
                                </init>
                              </variableDeclarationStatement>
                              <methodInvokeExpression methodName="ConfigureCommand">
                                <parameters>
                                  <variableReferenceExpression name="firstLettersCommand"/>
                                  <variableReferenceExpression name="page"/>
                                  <propertyReferenceExpression name="SelectFirstLetters">
                                    <typeReferenceExpression type="CommandConfigurationType"/>
                                  </propertyReferenceExpression>
                                  <primitiveExpression value="null"/>
                                </parameters>
                              </methodInvokeExpression>
                              <assignStatement>
                                <propertyReferenceExpression name="Filter">
                                  <variableReferenceExpression name="page"/>
                                </propertyReferenceExpression>
                                <variableReferenceExpression name="oldFilter"/>
                              </assignStatement>
                              <conditionStatement>
                                <condition>
                                  <unaryOperatorExpression operator="IsNotNullOrEmpty">
                                    <propertyReferenceExpression name="FirstLetters">
                                      <variableReferenceExpression name="page"/>
                                    </propertyReferenceExpression>
                                  </unaryOperatorExpression>
                                </condition>
                                <trueStatements>
                                  <variableDeclarationStatement type="DbDataReader" name="reader">
                                    <init>
                                      <methodInvokeExpression methodName="ExecuteReader">
                                        <target>
                                          <variableReferenceExpression name="firstLettersCommand"/>
                                        </target>
                                      </methodInvokeExpression>
                                    </init>
                                  </variableDeclarationStatement>
                                  <variableDeclarationStatement type="StringBuilder" name="firstLetters">
                                    <init>
                                      <objectCreateExpression type="StringBuilder">
                                        <parameters>
                                          <propertyReferenceExpression name="FirstLetters">
                                            <variableReferenceExpression name="page"/>
                                          </propertyReferenceExpression>
                                        </parameters>
                                      </objectCreateExpression>
                                    </init>
                                  </variableDeclarationStatement>
                                  <whileStatement>
                                    <test>
                                      <methodInvokeExpression methodName="Read">
                                        <target>
                                          <variableReferenceExpression name="reader"/>
                                        </target>
                                      </methodInvokeExpression>
                                    </test>
                                    <statements>
                                      <methodInvokeExpression methodName="Append">
                                        <target>
                                          <variableReferenceExpression name="firstLetters"/>
                                        </target>
                                        <parameters>
                                          <primitiveExpression value=","/>
                                        </parameters>
                                      </methodInvokeExpression>
                                      <variableDeclarationStatement type="System.String" name="letter">
                                        <init>
                                          <methodInvokeExpression methodName="ToString">
                                            <target>
                                              <typeReferenceExpression type="Convert"/>
                                            </target>
                                            <parameters>
                                              <arrayIndexerExpression>
                                                <target>
                                                  <variableReferenceExpression name="reader"/>
                                                </target>
                                                <indices>
                                                  <primitiveExpression value="0"/>
                                                </indices>
                                              </arrayIndexerExpression>
                                            </parameters>
                                          </methodInvokeExpression>
                                        </init>
                                      </variableDeclarationStatement>
                                      <conditionStatement>
                                        <condition>
                                          <unaryOperatorExpression operator="IsNotNullOrEmpty">
                                            <variableReferenceExpression name="letter"/>
                                          </unaryOperatorExpression>
                                        </condition>
                                        <trueStatements>
                                          <methodInvokeExpression methodName="Append">
                                            <target>
                                              <variableReferenceExpression name="firstLetters"/>
                                            </target>
                                            <parameters>
                                              <variableReferenceExpression name="letter"/>
                                            </parameters>
                                          </methodInvokeExpression>
                                        </trueStatements>
                                      </conditionStatement>
                                    </statements>
                                  </whileStatement>
                                  <methodInvokeExpression methodName="Close">
                                    <target>
                                      <variableReferenceExpression name="reader"/>
                                    </target>
                                  </methodInvokeExpression>
                                  <assignStatement>
                                    <propertyReferenceExpression name="FirstLetters">
                                      <variableReferenceExpression name="page"/>
                                    </propertyReferenceExpression>
                                    <methodInvokeExpression methodName="ToString">
                                      <target>
                                        <variableReferenceExpression name="firstLetters"/>
                                      </target>
                                    </methodInvokeExpression>
                                  </assignStatement>
                                </trueStatements>
                              </conditionStatement>
                            </falseStatements>
                          </conditionStatement>
                        </trueStatements>
                      </conditionStatement>
                    </xsl:if>
                  </statements>
                </usingStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <propertyReferenceExpression name="PlugIn">
                        <fieldReferenceExpression name="config"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="ProcessPageRequest">
                      <target>
                        <propertyReferenceExpression name="PlugIn">
                          <fieldReferenceExpression name="config"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="request"/>
                        <variableReferenceExpression name="page"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <propertyReferenceExpression name="Inserting">
                      <argumentReferenceExpression name="request"/>
                    </propertyReferenceExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <propertyReferenceExpression name="NewRow">
                        <variableReferenceExpression name="page"/>
                      </propertyReferenceExpression>
                      <arrayCreateExpression>
                        <createType type="System.Object"/>
                        <sizeExpression>
                          <propertyReferenceExpression name="Count">
                            <propertyReferenceExpression name="Fields">
                              <variableReferenceExpression name="page"/>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                        </sizeExpression>
                      </arrayCreateExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <propertyReferenceExpression name="Inserting">
                      <argumentReferenceExpression name="request"/>
                    </propertyReferenceExpression>
                  </condition>
                  <trueStatements>
                    <conditionStatement>
                      <condition>
                        <methodInvokeExpression methodName="SupportsCommand">
                          <target>
                            <fieldReferenceExpression name="serverRules"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="Sql|Code"/>
                            <primitiveExpression value="New"/>
                          </parameters>
                        </methodInvokeExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="ExecuteServerRules">
                          <target>
                            <fieldReferenceExpression name="serverRules"/>
                          </target>
                          <parameters>
                            <argumentReferenceExpression name="request"/>
                            <propertyReferenceExpression name="Execute">
                              <typeReferenceExpression type="ActionPhase"/>
                            </propertyReferenceExpression>
                            <primitiveExpression value="New"/>
                            <propertyReferenceExpression name="NewRow">
                              <variableReferenceExpression name="page"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                  </trueStatements>
                  <falseStatements>
                    <conditionStatement>
                      <condition>
                        <methodInvokeExpression methodName="SupportsCommand">
                          <target>
                            <fieldReferenceExpression name="serverRules"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="Sql|Code"/>
                            <primitiveExpression value="Select"/>
                          </parameters>
                        </methodInvokeExpression>
                      </condition>
                      <trueStatements>
                        <foreachStatement>
                          <variable type="System.Object[]" name="row"/>
                          <target>
                            <propertyReferenceExpression name="Rows">
                              <variableReferenceExpression name="page"/>
                            </propertyReferenceExpression>
                          </target>
                          <statements>
                            <methodInvokeExpression methodName="ExecuteServerRules">
                              <target>
                                <fieldReferenceExpression name="serverRules"/>
                              </target>
                              <parameters>
                                <argumentReferenceExpression name="request"/>
                                <propertyReferenceExpression name="Execute">
                                  <typeReferenceExpression type="ActionPhase"/>
                                </propertyReferenceExpression>
                                <primitiveExpression value="Select"/>
                                <variableReferenceExpression name="row"/>
                              </parameters>
                            </methodInvokeExpression>
                          </statements>
                        </foreachStatement>
                      </trueStatements>
                    </conditionStatement>
                  </falseStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <variableReferenceExpression name="rules"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="IRowHandler" name="rowHandler">
                      <init>
                        <variableReferenceExpression name="rules"/>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <propertyReferenceExpression name="Inserting">
                          <argumentReferenceExpression name="request"/>
                        </propertyReferenceExpression>
                      </condition>
                      <trueStatements>
                        <conditionStatement>
                          <condition>
                            <methodInvokeExpression methodName="SupportsNewRow">
                              <target>
                                <variableReferenceExpression name="rowHandler"/>
                              </target>
                              <parameters>
                                <argumentReferenceExpression name="request"/>
                              </parameters>
                            </methodInvokeExpression>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="NewRow">
                              <target>
                                <variableReferenceExpression name="rowHandler"/>
                              </target>
                              <parameters>
                                <argumentReferenceExpression name="request"/>
                                <variableReferenceExpression name="page"/>
                                <propertyReferenceExpression name="NewRow">
                                  <variableReferenceExpression name="page"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>
                      </trueStatements>
                      <falseStatements>
                        <conditionStatement>
                          <condition>
                            <methodInvokeExpression methodName="SupportsPrepareRow">
                              <target>
                                <variableReferenceExpression name="rowHandler"/>
                              </target>
                              <parameters>
                                <argumentReferenceExpression name="request"/>
                              </parameters>
                            </methodInvokeExpression>
                          </condition>
                          <trueStatements>
                            <foreachStatement>
                              <variable type="System.Object[]" name="row"/>
                              <target>
                                <propertyReferenceExpression name="Rows">
                                  <variableReferenceExpression name="page"/>
                                </propertyReferenceExpression>
                              </target>
                              <statements>
                                <methodInvokeExpression methodName="PrepareRow">
                                  <target>
                                    <variableReferenceExpression name="rowHandler"/>
                                  </target>
                                  <parameters>
                                    <argumentReferenceExpression name="request"/>
                                    <variableReferenceExpression name="page"/>
                                    <variableReferenceExpression name="row"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </statements>
                            </foreachStatement>
                          </trueStatements>
                        </conditionStatement>
                      </falseStatements>
                    </conditionStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityInequality">
                          <variableReferenceExpression name="rules"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="ProcessPageRequest">
                          <target>
                            <variableReferenceExpression name="rules"/>
                          </target>
                          <parameters>
                            <argumentReferenceExpression name="request"/>
                            <variableReferenceExpression name="page"/>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                  </trueStatements>
                </conditionStatement>
                <assignStatement>
                  <variableReferenceExpression name="page"/>
                  <methodInvokeExpression methodName="ToResult">
                    <target>
                      <variableReferenceExpression name="page"/>
                    </target>
                    <parameters>
                      <fieldReferenceExpression name="config"/>
                      <fieldReferenceExpression name="view"/>
                    </parameters>
                  </methodInvokeExpression>
                </assignStatement>
                <xsl:if test="$IsUnlimited='true' and (contains($Auditing, 'Modified') or contains($Auditing, 'Created'))">
                  <methodInvokeExpression methodName="Process">
                    <target>
                      <typeReferenceExpression type="{$Namespace}.Security.EventTracker"/>
                    </target>
                    <parameters>
                      <argumentReferenceExpression name="page"/>
                      <variableReferenceExpression name="request"/>
                    </parameters>
                  </methodInvokeExpression>
                </xsl:if>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <variableReferenceExpression name="rules"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="AfterSelect">
                      <target>
                        <variableReferenceExpression name="rules"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="request"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                  <falseStatements>
                    <methodInvokeExpression methodName="ExecuteServerRules">
                      <target>
                        <fieldReferenceExpression name="serverRules"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="request"/>
                        <propertyReferenceExpression name="After">
                          <typeReferenceExpression type="ActionPhase"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </falseStatements>
                </conditionStatement>
                <methodInvokeExpression methodName="Merge">
                  <target>
                    <propertyReferenceExpression name="Result">
                      <fieldReferenceExpression name="serverRules"/>
                    </propertyReferenceExpression>
                  </target>
                  <parameters>
                    <variableReferenceExpression name="page"/>
                  </parameters>
                </methodInvokeExpression>
                <methodReturnStatement>
                  <variableReferenceExpression name="page"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method IDataController.GetListOfValues(string, string,DistinctValueRequest)-->
            <memberMethod returnType="System.Object[]" name="GetListOfValues" privateImplementationType="IDataController">
              <attributes/>
              <parameters>
                <parameter type="System.String" name="controller"/>
                <parameter type="System.String" name="view"/>
                <parameter type="DistinctValueRequest" name="request"/>
              </parameters>
              <statements>
                <methodInvokeExpression methodName="SelectView">
                  <parameters>
                    <argumentReferenceExpression name="controller"/>
                    <argumentReferenceExpression name="view"/>
                  </parameters>
                </methodInvokeExpression>
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
                    <argumentReferenceExpression name="controller"/>
                    <argumentReferenceExpression name="view"/>
                    <propertyReferenceExpression name="LookupContextController">
                      <argumentReferenceExpression name="request"/>
                    </propertyReferenceExpression>
                    <propertyReferenceExpression name="LookupContextView">
                      <argumentReferenceExpression name="request"/>
                    </propertyReferenceExpression>
                    <propertyReferenceExpression name="LookupContextFieldName">
                      <argumentReferenceExpression name="request"/>
                    </propertyReferenceExpression>
                  </parameters>
                </methodInvokeExpression>
                <variableDeclarationStatement type="List" name="distinctValues">
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
                <variableDeclarationStatement type="BusinessRules" name="rules">
                  <init>
                    <methodInvokeExpression methodName="CreateBusinessRules">
                      <target>
                        <fieldReferenceExpression name="config"/>
                      </target>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <assignStatement>
                  <fieldReferenceExpression name="serverRules"/>
                  <variableReferenceExpression name="rules"/>
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
                <assignStatement>
                  <propertyReferenceExpression name="Page">
                    <fieldReferenceExpression name="serverRules"/>
                  </propertyReferenceExpression>
                  <variableReferenceExpression name="page"/>
                </assignStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <variableReferenceExpression name="rules"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="BeforeSelect">
                      <target>
                        <variableReferenceExpression name="rules"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="request"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                  <falseStatements>
                    <methodInvokeExpression methodName="ExecuteServerRules">
                      <target>
                        <fieldReferenceExpression name="serverRules"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="request"/>
                        <propertyReferenceExpression name="Before">
                          <typeReferenceExpression type="ActionPhase"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </falseStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <propertyReferenceExpression name="EnableResultSet">
                      <fieldReferenceExpression name="serverRules"/>
                    </propertyReferenceExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="IDataReader" name="reader">
                      <init>
                        <methodInvokeExpression methodName="ExecuteResultSetReader">
                          <parameters>
                            <variableReferenceExpression name="page"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="SortedDictionary" name="uniqueValues">
                      <typeArguments>
                        <typeReference type="System.Object"/>
                        <typeReference type="System.Object"/>
                      </typeArguments>
                      <init>
                        <objectCreateExpression type="SortedDictionary">
                          <typeArguments>
                            <typeReference type="System.Object"/>
                            <typeReference type="System.Object"/>
                          </typeArguments>
                        </objectCreateExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="System.Boolean" name="hasNull">
                      <init>
                        <primitiveExpression value="false"/>
                      </init>
                    </variableDeclarationStatement>
                    <whileStatement>
                      <test>
                        <methodInvokeExpression methodName="Read">
                          <target>
                            <variableReferenceExpression name="reader"/>
                          </target>
                        </methodInvokeExpression>
                      </test>
                      <statements>
                        <variableDeclarationStatement type="System.Object" name="v">
                          <init>
                            <arrayIndexerExpression>
                              <target>
                                <variableReferenceExpression name="reader"/>
                              </target>
                              <indices>
                                <propertyReferenceExpression name="FieldName">
                                  <variableReferenceExpression name="request"/>
                                </propertyReferenceExpression>
                              </indices>
                            </arrayIndexerExpression>
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
                                <variableReferenceExpression name="v"/>
                              </parameters>
                            </methodInvokeExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="hasNull"/>
                              <primitiveExpression value="true"/>
                            </assignStatement>
                          </trueStatements>
                          <falseStatements>
                            <assignStatement>
                              <arrayIndexerExpression>
                                <target>
                                  <variableReferenceExpression name="uniqueValues"/>
                                </target>
                                <indices>
                                  <variableReferenceExpression name="v"/>
                                </indices>
                              </arrayIndexerExpression>
                              <variableReferenceExpression name="v"/>
                            </assignStatement>
                          </falseStatements>
                        </conditionStatement>
                      </statements>
                    </whileStatement>
                    <conditionStatement>
                      <condition>
                        <variableReferenceExpression name="hasNull"/>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <variableReferenceExpression name="distinctValues"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="null"/>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                    <foreachStatement>
                      <variable type="System.Object" name="v"/>
                      <target>
                        <propertyReferenceExpression name="Keys">
                          <variableReferenceExpression name="uniqueValues"/>
                        </propertyReferenceExpression>
                      </target>
                      <statements>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="LessThan">
                              <propertyReferenceExpression name="Count">
                                <variableReferenceExpression name="distinctValues"/>
                              </propertyReferenceExpression>
                              <propertyReferenceExpression name="PageSize">
                                <variableReferenceExpression name="page"/>
                              </propertyReferenceExpression>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <variableReferenceExpression name="distinctValues"/>
                              </target>
                              <parameters>
                                <methodInvokeExpression methodName="ConvertObjectToValue">
                                  <parameters>
                                    <variableReferenceExpression name="v"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                          <falseStatements>
                            <breakStatement/>
                          </falseStatements>
                        </conditionStatement>
                      </statements>
                    </foreachStatement>
                  </trueStatements>
                  <falseStatements>
                    <usingStatement>
                      <variable type="DbConnection" name="connection">
                        <init>
                          <methodInvokeExpression methodName="CreateConnection"/>
                        </init>
                      </variable>
                      <statements>
                        <variableDeclarationStatement type="DbCommand" name="command">
                          <init>
                            <methodInvokeExpression methodName="CreateCommand">
                              <parameters>
                                <variableReferenceExpression name="connection"/>
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <methodInvokeExpression methodName="ConfigureCommand">
                          <parameters>
                            <variableReferenceExpression name="command"/>
                            <variableReferenceExpression name="page"/>
                            <propertyReferenceExpression name="SelectDistinct">
                              <typeReferenceExpression type="CommandConfigurationType"/>
                            </propertyReferenceExpression>
                            <primitiveExpression value="null"/>
                          </parameters>
                        </methodInvokeExpression>
                        <variableDeclarationStatement type="DbDataReader" name="reader">
                          <init>
                            <methodInvokeExpression methodName="ExecuteReader">
                              <target>
                                <variableReferenceExpression name="command"/>
                              </target>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <whileStatement>
                          <test>
                            <binaryOperatorExpression operator="BooleanAnd">
                              <methodInvokeExpression methodName="Read">
                                <target>
                                  <variableReferenceExpression name="reader"/>
                                </target>
                              </methodInvokeExpression>
                              <binaryOperatorExpression operator="LessThan">
                                <propertyReferenceExpression name="Count">
                                  <variableReferenceExpression name="distinctValues"/>
                                </propertyReferenceExpression>
                                <propertyReferenceExpression name="PageSize">
                                  <argumentReferenceExpression name="page"/>
                                </propertyReferenceExpression>
                              </binaryOperatorExpression>
                            </binaryOperatorExpression>
                          </test>
                          <statements>
                            <variableDeclarationStatement type="System.Object" name="v">
                              <init>
                                <methodInvokeExpression methodName="GetValue">
                                  <target>
                                    <variableReferenceExpression name="reader"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="0"/>
                                  </parameters>
                                </methodInvokeExpression>
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
                                <assignStatement>
                                  <variableReferenceExpression name="v"/>
                                  <methodInvokeExpression methodName="ConvertObjectToValue">
                                    <parameters>
                                      <variableReferenceExpression name="v"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                </assignStatement>
                                <!--<conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="IsTypeOf">
                                  <variableReferenceExpression name="v"/>
                                  <typeReferenceExpression type="TimeSpan"/>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="v"/>
                                  <methodInvokeExpression methodName="ToString">
                                    <target>
                                      <variableReferenceExpression name="v"/>
                                    </target>
                                  </methodInvokeExpression>
                                </assignStatement>
                              </trueStatements>
                            </conditionStatement>-->
                              </trueStatements>
                            </conditionStatement>
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <variableReferenceExpression name="distinctValues"/>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="v"/>
                              </parameters>
                            </methodInvokeExpression>
                          </statements>
                        </whileStatement>
                        <methodInvokeExpression methodName="Close">
                          <target>
                            <variableReferenceExpression name="reader"/>
                          </target>
                        </methodInvokeExpression>
                      </statements>
                    </usingStatement>
                  </falseStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <variableReferenceExpression name="rules"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="AfterSelect">
                      <target>
                        <variableReferenceExpression name="rules"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="request"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                  <falseStatements>
                    <methodInvokeExpression methodName="ExecuteServerRules">
                      <target>
                        <fieldReferenceExpression name="serverRules"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="request"/>
                        <propertyReferenceExpression name="After">
                          <typeReferenceExpression type="ActionPhase"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </falseStatements>
                </conditionStatement>
                <variableDeclarationStatement type="System.Object[]" name="result">
                  <init>
                    <methodInvokeExpression methodName="ToArray">
                      <target>
                        <variableReferenceExpression name="distinctValues"/>
                      </target>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <methodInvokeExpression methodName="EnsureJsonCompatibility">
                  <parameters>
                    <variableReferenceExpression name="result"/>
                  </parameters>
                </methodInvokeExpression>
                <methodReturnStatement>
                  <variableReferenceExpression name="result"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method IDataController.Execute(string, string, ActionArgs) -->
            <memberMethod returnType="ActionResult" name="Execute" privateImplementationType="IDataController">
              <attributes/>
              <parameters>
                <parameter type="System.String" name="controller"/>
                <parameter type="System.String" name="view"/>
                <parameter type="ActionArgs" name="args"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="ActionResult" name="result">
                  <init>
                    <objectCreateExpression type="ActionResult"/>
                  </init>
                </variableDeclarationStatement>
                <!--
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="ExecuteWithPivot">
                      <parameters>
                        <argumentReferenceExpression name="controller"/>
                        <argumentReferenceExpression name="view"/>
                        <argumentReferenceExpression name="args"/>
                        <variableReferenceExpression name="result"/>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <variableReferenceExpression name="result"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>-->
                <methodInvokeExpression methodName="SelectView">
                  <parameters>
                    <argumentReferenceExpression name="controller"/>
                    <argumentReferenceExpression name="view"/>
                  </parameters>
                </methodInvokeExpression>
                <tryStatement>
                  <statements>
                    <!--<methodInvokeExpression methodName="ValidateArguments">
                      <parameters>
                        <argumentReferenceExpression name="args"/>
                      </parameters>
                    </methodInvokeExpression>-->
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
                    <variableDeclarationStatement type="IActionHandler" name="handler">
                      <init>
                        <castExpression targetType="IActionHandler">
                          <fieldReferenceExpression name="serverRules"/>
                        </castExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityInequality">
                          <propertyReferenceExpression name="PlugIn">
                            <fieldReferenceExpression name="config"/>
                          </propertyReferenceExpression>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="PreProcessArguments">
                          <target>
                            <propertyReferenceExpression name="PlugIn">
                              <fieldReferenceExpression name="config"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <argumentReferenceExpression name="args"/>
                            <variableReferenceExpression name="result"/>
                            <methodInvokeExpression methodName="CreateViewPage"/>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="ValueInequality">
                          <propertyReferenceExpression name="SqlCommandType">
                            <argumentReferenceExpression name="args"/>
                          </propertyReferenceExpression>
                          <propertyReferenceExpression name="None">
                            <typeReferenceExpression type="CommandConfigurationType"/>
                          </propertyReferenceExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <usingStatement>
                          <variable type="DbConnection" name="connection">
                            <init>
                              <methodInvokeExpression methodName="CreateConnection"/>
                            </init>
                          </variable>
                          <statements>
                            <xsl:if test="$IsUnlimited='true' and (contains($Auditing, 'Modified') or contains($Auditing, 'Created'))">
                              <methodInvokeExpression methodName="Process">
                                <target>
                                  <typeReferenceExpression type="{$Namespace}.Security.EventTracker"/>
                                </target>
                                <parameters>
                                  <argumentReferenceExpression name="args"/>
                                  <fieldReferenceExpression name="_config"/>
                                </parameters>
                              </methodInvokeExpression>
                            </xsl:if>
                            <variableDeclarationStatement type="DbCommand" name="command">
                              <init>
                                <methodInvokeExpression methodName="CreateCommand">
                                  <parameters>
                                    <variableReferenceExpression name="connection"/>
                                    <argumentReferenceExpression name="args"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </init>
                            </variableDeclarationStatement>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="BooleanAnd">
                                  <binaryOperatorExpression operator="IdentityInequality">
                                    <propertyReferenceExpression name="SelectedValues">
                                      <argumentReferenceExpression name="args"/>
                                    </propertyReferenceExpression>
                                    <primitiveExpression value="null"/>
                                  </binaryOperatorExpression>
                                  <binaryOperatorExpression operator="BooleanOr">
                                    <binaryOperatorExpression operator="BooleanAnd">
                                      <binaryOperatorExpression operator="ValueEquality">
                                        <propertyReferenceExpression name="LastCommandName">
                                          <argumentReferenceExpression name="args"/>
                                        </propertyReferenceExpression>
                                        <primitiveExpression value="BatchEdit"/>
                                      </binaryOperatorExpression>
                                      <binaryOperatorExpression operator="ValueEquality">
                                        <propertyReferenceExpression name="CommandName">
                                          <argumentReferenceExpression name="args"/>
                                        </propertyReferenceExpression>
                                        <primitiveExpression value="Update"/>
                                      </binaryOperatorExpression>
                                    </binaryOperatorExpression>
                                    <binaryOperatorExpression operator="BooleanAnd">
                                      <binaryOperatorExpression operator="ValueEquality">
                                        <propertyReferenceExpression name="CommandName">
                                          <argumentReferenceExpression name="args"/>
                                        </propertyReferenceExpression>
                                        <primitiveExpression value="Delete"/>
                                      </binaryOperatorExpression>
                                      <binaryOperatorExpression operator="GreaterThan">
                                        <propertyReferenceExpression name="Length">
                                          <propertyReferenceExpression name="SelectedValues">
                                            <argumentReferenceExpression name="args"/>
                                          </propertyReferenceExpression>
                                        </propertyReferenceExpression>
                                        <primitiveExpression value="1"/>
                                      </binaryOperatorExpression>
                                    </binaryOperatorExpression>
                                  </binaryOperatorExpression>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <variableDeclarationStatement type="ViewPage" name="page">
                                  <init>
                                    <methodInvokeExpression methodName="CreateViewPage"/>
                                  </init>
                                </variableDeclarationStatement>
                                <methodInvokeExpression methodName="PopulatePageFields">
                                  <parameters>
                                    <variableReferenceExpression name="page"/>
                                  </parameters>
                                </methodInvokeExpression>
                                <variableDeclarationStatement type="System.String" name="originalCommandText">
                                  <init>
                                    <propertyReferenceExpression name="CommandText">
                                      <variableReferenceExpression name="command"/>
                                    </propertyReferenceExpression>
                                  </init>
                                </variableDeclarationStatement>
                                <foreachStatement>
                                  <variable type="System.String" name="sv"/>
                                  <target>
                                    <propertyReferenceExpression name="SelectedValues">
                                      <argumentReferenceExpression name="args"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <statements>
                                    <assignStatement>
                                      <propertyReferenceExpression name="Canceled">
                                        <variableReferenceExpression name="result"/>
                                      </propertyReferenceExpression>
                                      <primitiveExpression value="false"/>
                                    </assignStatement>
                                    <methodInvokeExpression methodName="ClearBlackAndWhiteLists">
                                      <target>
                                        <fieldReferenceExpression name="serverRules"/>
                                      </target>
                                    </methodInvokeExpression>
                                    <variableDeclarationStatement type="System.String[]" name="key">
                                      <init>
                                        <methodInvokeExpression methodName="Split">
                                          <target>
                                            <variableReferenceExpression name="sv"/>
                                          </target>
                                          <parameters>
                                            <primitiveExpression value="," convertTo="Char"/>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </init>
                                    </variableDeclarationStatement>
                                    <variableDeclarationStatement type="System.Int32" name="keyIndex">
                                      <init>
                                        <primitiveExpression value="0"/>
                                      </init>
                                    </variableDeclarationStatement>
                                    <foreachStatement>
                                      <variable type="FieldValue" name="v"/>
                                      <target>
                                        <propertyReferenceExpression name="Values">
                                          <argumentReferenceExpression name="args"/>
                                        </propertyReferenceExpression>
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
                                        <conditionStatement>
                                          <condition>
                                            <binaryOperatorExpression operator="IdentityInequality">
                                              <variableReferenceExpression name="field"/>
                                              <primitiveExpression value="null"/>
                                            </binaryOperatorExpression>
                                          </condition>
                                          <trueStatements>
                                            <conditionStatement>
                                              <condition>
                                                <unaryOperatorExpression operator="Not">
                                                  <propertyReferenceExpression name="IsPrimaryKey">
                                                    <variableReferenceExpression name="field"/>
                                                  </propertyReferenceExpression>
                                                </unaryOperatorExpression>
                                              </condition>
                                              <trueStatements>
                                                <assignStatement>
                                                  <propertyReferenceExpression name="Modified">
                                                    <variableReferenceExpression name="v"/>
                                                  </propertyReferenceExpression>
                                                  <primitiveExpression value="true"/>
                                                </assignStatement>
                                              </trueStatements>
                                              <falseStatements>
                                                <conditionStatement>
                                                  <condition>
                                                    <binaryOperatorExpression operator="ValueEquality">
                                                      <propertyReferenceExpression name="Name">
                                                        <variableReferenceExpression name="v"/>
                                                      </propertyReferenceExpression>
                                                      <propertyReferenceExpression name="Name">
                                                        <variableReferenceExpression name="field"/>
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
                                                          <variableReferenceExpression name="key"/>
                                                        </target>
                                                        <indices>
                                                          <variableReferenceExpression name="keyIndex"/>
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
                                                      <variableReferenceExpression name="keyIndex"/>
                                                      <binaryOperatorExpression operator="Add">
                                                        <variableReferenceExpression name="keyIndex"/>
                                                        <primitiveExpression value="1"/>
                                                      </binaryOperatorExpression>
                                                    </assignStatement>
                                                  </trueStatements>
                                                </conditionStatement>
                                              </falseStatements>
                                            </conditionStatement>
                                          </trueStatements>
                                        </conditionStatement>
                                      </statements>
                                    </foreachStatement>
                                    <methodInvokeExpression methodName="ExecutePreActionCommands">
                                      <parameters>
                                        <argumentReferenceExpression name="args"/>
                                        <variableReferenceExpression name="result"/>
                                        <variableReferenceExpression name="connection"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                    <conditionStatement>
                                      <condition>
                                        <binaryOperatorExpression operator="IdentityInequality">
                                          <variableReferenceExpression name="handler"/>
                                          <primitiveExpression value="null"/>
                                        </binaryOperatorExpression>
                                      </condition>
                                      <trueStatements>
                                        <methodInvokeExpression methodName="BeforeSqlAction">
                                          <target>
                                            <variableReferenceExpression name="handler"/>
                                          </target>
                                          <parameters>
                                            <argumentReferenceExpression name="args"/>
                                            <variableReferenceExpression name="result"/>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </trueStatements>
                                      <falseStatements>
                                        <methodInvokeExpression methodName="ExecuteServerRules">
                                          <target>
                                            <fieldReferenceExpression name="serverRules"/>
                                          </target>
                                          <parameters>
                                            <argumentReferenceExpression name="args"/>
                                            <argumentReferenceExpression name="result"/>
                                            <propertyReferenceExpression name="Before">
                                              <typeReferenceExpression type="ActionPhase"/>
                                            </propertyReferenceExpression>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </falseStatements>
                                    </conditionStatement>
                                    <conditionStatement>
                                      <condition>
                                        <binaryOperatorExpression operator="BooleanAnd">
                                          <binaryOperatorExpression operator="ValueEquality">
                                            <propertyReferenceExpression name="Count">
                                              <propertyReferenceExpression name="Errors">
                                                <variableReferenceExpression name="result"/>
                                              </propertyReferenceExpression>
                                            </propertyReferenceExpression>
                                            <primitiveExpression value="0"/>
                                          </binaryOperatorExpression>
                                          <unaryOperatorExpression operator="Not">
                                            <propertyReferenceExpression name="Canceled">
                                              <variableReferenceExpression name="result"/>
                                            </propertyReferenceExpression>
                                          </unaryOperatorExpression>
                                        </binaryOperatorExpression>
                                      </condition>
                                      <trueStatements>
                                        <methodInvokeExpression methodName="ConfigureCommand">
                                          <parameters>
                                            <variableReferenceExpression name="command"/>
                                            <primitiveExpression value="null"/>
                                            <propertyReferenceExpression name="SqlCommandType">
                                              <variableReferenceExpression name="args"/>
                                            </propertyReferenceExpression>
                                            <propertyReferenceExpression name="Values">
                                              <argumentReferenceExpression name="args"/>
                                            </propertyReferenceExpression>
                                          </parameters>
                                        </methodInvokeExpression>
                                        <assignStatement>
                                          <propertyReferenceExpression name="RowsAffected">
                                            <argumentReferenceExpression name="result"/>
                                          </propertyReferenceExpression>
                                          <binaryOperatorExpression operator="Add">
                                            <propertyReferenceExpression name="RowsAffected">
                                              <variableReferenceExpression name="result"/>
                                            </propertyReferenceExpression>
                                            <methodInvokeExpression methodName="ExecuteNonQuery">
                                              <target>
                                                <typeReferenceExpression type="TransactionManager"/>
                                              </target>
                                              <parameters>
                                                <variableReferenceExpression name="command"/>
                                              </parameters>
                                            </methodInvokeExpression>
                                          </binaryOperatorExpression>
                                        </assignStatement>
                                        <conditionStatement>
                                          <condition>
                                            <binaryOperatorExpression operator="IdentityInequality">
                                              <variableReferenceExpression name="handler"/>
                                              <primitiveExpression value="null"/>
                                            </binaryOperatorExpression>
                                          </condition>
                                          <trueStatements>
                                            <methodInvokeExpression methodName="AfterSqlAction">
                                              <target>
                                                <variableReferenceExpression name="handler"/>
                                              </target>
                                              <parameters>
                                                <argumentReferenceExpression name="args"/>
                                                <variableReferenceExpression name="result"/>
                                              </parameters>
                                            </methodInvokeExpression>
                                          </trueStatements>
                                          <falseStatements>
                                            <methodInvokeExpression methodName="ExecuteServerRules">
                                              <target>
                                                <fieldReferenceExpression name="serverRules"/>
                                              </target>
                                              <parameters>
                                                <argumentReferenceExpression name="args"/>
                                                <argumentReferenceExpression name="result"/>
                                                <propertyReferenceExpression name="After">
                                                  <typeReferenceExpression type="ActionPhase"/>
                                                </propertyReferenceExpression>
                                              </parameters>
                                            </methodInvokeExpression>
                                          </falseStatements>
                                        </conditionStatement>
                                        <assignStatement>
                                          <propertyReferenceExpression name="CommandText">
                                            <variableReferenceExpression name="command"/>
                                          </propertyReferenceExpression>
                                          <variableReferenceExpression name="originalCommandText"/>
                                        </assignStatement>
                                        <methodInvokeExpression methodName="Clear">
                                          <target>
                                            <propertyReferenceExpression name="Parameters">
                                              <variableReferenceExpression name="command"/>
                                            </propertyReferenceExpression>
                                          </target>
                                        </methodInvokeExpression>
                                        <conditionStatement>
                                          <condition>
                                            <binaryOperatorExpression operator="IdentityInequality">
                                              <propertyReferenceExpression name="PlugIn">
                                                <fieldReferenceExpression name="config"/>
                                              </propertyReferenceExpression>
                                              <primitiveExpression value="null"/>
                                            </binaryOperatorExpression>
                                          </condition>
                                          <trueStatements>
                                            <methodInvokeExpression methodName="ProcessArguments">
                                              <target>
                                                <propertyReferenceExpression name="PlugIn">
                                                  <fieldReferenceExpression name="config"/>
                                                </propertyReferenceExpression>
                                              </target>
                                              <parameters>
                                                <argumentReferenceExpression name="args"/>
                                                <variableReferenceExpression name="result"/>
                                                <variableReferenceExpression name="page"/>
                                              </parameters>
                                            </methodInvokeExpression>
                                          </trueStatements>
                                        </conditionStatement>
                                      </trueStatements>
                                    </conditionStatement>
                                  </statements>
                                </foreachStatement>
                              </trueStatements>
                              <falseStatements>
                                <methodInvokeExpression methodName="ExecutePreActionCommands">
                                  <parameters>
                                    <argumentReferenceExpression name="args"/>
                                    <variableReferenceExpression name="result"/>
                                    <variableReferenceExpression name="connection"/>
                                  </parameters>
                                </methodInvokeExpression>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="IdentityInequality">
                                      <variableReferenceExpression name="handler"/>
                                      <primitiveExpression value="null"/>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <methodInvokeExpression methodName="BeforeSqlAction">
                                      <target>
                                        <variableReferenceExpression name="handler"/>
                                      </target>
                                      <parameters>
                                        <argumentReferenceExpression name="args"/>
                                        <variableReferenceExpression name="result"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </trueStatements>
                                  <falseStatements>
                                    <methodInvokeExpression methodName="ExecuteServerRules">
                                      <target>
                                        <fieldReferenceExpression name="serverRules"/>
                                      </target>
                                      <parameters>
                                        <argumentReferenceExpression name="args"/>
                                        <argumentReferenceExpression name="result"/>
                                        <propertyReferenceExpression name="Before">
                                          <typeReferenceExpression type="ActionPhase"/>
                                        </propertyReferenceExpression>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </falseStatements>
                                </conditionStatement>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="BooleanAnd">
                                      <binaryOperatorExpression operator="ValueEquality">
                                        <propertyReferenceExpression name="Count">
                                          <propertyReferenceExpression name="Errors">
                                            <variableReferenceExpression name="result"/>
                                          </propertyReferenceExpression>
                                        </propertyReferenceExpression>
                                        <primitiveExpression value="0"/>
                                      </binaryOperatorExpression>
                                      <unaryOperatorExpression operator="Not">
                                        <propertyReferenceExpression name="Canceled">
                                          <variableReferenceExpression name="result"/>
                                        </propertyReferenceExpression>
                                      </unaryOperatorExpression>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <xsl:choose>
                                      <xsl:when test="$EnableTransactions='true'">
                                        <usingStatement>
                                          <variable type="SinglePhaseTransactionScope" name="scope">
                                            <init>
                                              <objectCreateExpression type="SinglePhaseTransactionScope"/>
                                            </init>
                                          </variable>
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
                                                <methodInvokeExpression methodName="Enlist">
                                                  <target>
                                                    <variableReferenceExpression name="scope"/>
                                                  </target>
                                                  <parameters>
                                                    <variableReferenceExpression name="command"/>
                                                  </parameters>
                                                </methodInvokeExpression>
                                              </trueStatements>
                                            </conditionStatement>
                                            <xsl:call-template name="ExecuteCommand"/>
                                            <methodInvokeExpression methodName="Complete">
                                              <target>
                                                <typeReferenceExpression type="TransactionManager"/>
                                              </target>
                                              <parameters>
                                                <argumentReferenceExpression name="args"/>
                                                <variableReferenceExpression name="result"/>
                                                <methodInvokeExpression methodName="CreateViewPage"/>
                                              </parameters>
                                            </methodInvokeExpression>
                                            <methodInvokeExpression methodName="Complete">
                                              <target>
                                                <variableReferenceExpression name="scope"/>
                                              </target>
                                            </methodInvokeExpression>
                                          </statements>
                                        </usingStatement>
                                      </xsl:when>
                                      <xsl:otherwise>
                                        <xsl:call-template name="ExecuteCommand"/>
                                      </xsl:otherwise>
                                    </xsl:choose>
                                  </trueStatements>
                                </conditionStatement>
                              </falseStatements>
                            </conditionStatement>
                          </statements>
                        </usingStatement>
                      </trueStatements>
                      <falseStatements>
                        <conditionStatement>
                          <condition>
                            <methodInvokeExpression methodName="StartsWith">
                              <target>
                                <propertyReferenceExpression name="CommandName">
                                  <argumentReferenceExpression name="args"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <primitiveExpression value="Export"/>
                              </parameters>
                            </methodInvokeExpression>
                          </condition>
                          <trueStatements>
                            <methodInvokeExpression methodName="ExecuteDataExport">
                              <parameters>
                                <argumentReferenceExpression name="args"/>
                                <argumentReferenceExpression name="result"/>
                              </parameters>
                            </methodInvokeExpression>
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
                                    <primitiveExpression value="PopulateDynamicLookups"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </condition>
                              <trueStatements>
                                <methodInvokeExpression methodName="PopulateDynamicLookups">
                                  <parameters>
                                    <argumentReferenceExpression name="args"/>
                                    <argumentReferenceExpression name="result"/>
                                  </parameters>
                                </methodInvokeExpression>
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
                                        <primitiveExpression value="ProcessImportFile"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </condition>
                                  <trueStatements>
                                    <methodInvokeExpression methodName="Execute">
                                      <target>
                                        <typeReferenceExpression type="ImportProcessor"/>
                                      </target>
                                      <parameters>
                                        <argumentReferenceExpression name="args"/>
                                      </parameters>
                                    </methodInvokeExpression>
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
                                            <primitiveExpression value="Execute"/>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </condition>
                                      <trueStatements>
                                        <usingStatement>
                                          <variable type="DbConnection" name="connection">
                                            <init>
                                              <methodInvokeExpression methodName="CreateConnection"/>
                                            </init>
                                          </variable>
                                          <statements>
                                            <variableDeclarationStatement type="DbCommand" name="command">
                                              <init>
                                                <methodInvokeExpression methodName="CreateCommand">
                                                  <parameters>
                                                    <variableReferenceExpression name="connection"/>
                                                    <argumentReferenceExpression name="args"/>
                                                  </parameters>
                                                </methodInvokeExpression>
                                              </init>
                                            </variableDeclarationStatement>
                                            <methodInvokeExpression methodName="ExecuteNonQuery">
                                              <target>
                                                <typeReferenceExpression type="TransactionManager"/>
                                              </target>
                                              <parameters>
                                                <variableReferenceExpression name="command"/>
                                              </parameters>
                                            </methodInvokeExpression>
                                          </statements>
                                        </usingStatement>
                                      </trueStatements>
                                      <falseStatements>
                                        <!--<conditionStatement>
                                          <condition>
                                            <binaryOperatorExpression operator="ValueEquality">
                                              <propertyReferenceExpression name="Length">
                                                <propertyReferenceExpression name="SelectedValues">
                                                  <argumentReferenceExpression name="args"/>
                                                </propertyReferenceExpression>
                                              </propertyReferenceExpression>
                                              <primitiveExpression value="0"/>
                                            </binaryOperatorExpression>
                                          </condition>
                                          <trueStatements>
                                            <methodInvokeExpression methodName="ExecuteAction">
                                              <target>
                                                <variableReferenceExpression name="handler"/>
                                              </target>
                                              <parameters>
                                                <argumentReferenceExpression name="args"/>
                                                <argumentReferenceExpression name="result"/>
                                              </parameters>
                                            </methodInvokeExpression>
                                          </trueStatements>
                                        </conditionStatement>-->
                                        <methodInvokeExpression methodName="ProcessSpecialActions">
                                          <target>
                                            <fieldReferenceExpression name="serverRules"/>
                                          </target>
                                          <parameters>
                                            <argumentReferenceExpression name="args"/>
                                            <argumentReferenceExpression name="result"/>
                                          </parameters>
                                        </methodInvokeExpression>
                                        <!--<conditionStatement>
                                          <condition>
                                            <binaryOperatorExpression operator="IdentityInequality">
                                              <variableReferenceExpression name="handler"/>
                                              <primitiveExpression value="null"/>
                                            </binaryOperatorExpression>
                                          </condition>
                                          <trueStatements>
                                            <methodInvokeExpression methodName="ExecuteAction">
                                              <target>
                                                <variableReferenceExpression name="handler"/>
                                              </target>
                                              <parameters>
                                                <argumentReferenceExpression name="args"/>
                                                <variableReferenceExpression name="result"/>
                                              </parameters>
                                            </methodInvokeExpression>
                                            <methodInvokeExpression methodName="ProcessSpecialActions">
                                              <target>
                                                <castExpression targetType="BusinessRules">
                                                  <variableReferenceExpression name="handler"/>
                                                </castExpression>
                                              </target>
                                              <parameters>
                                                <argumentReferenceExpression name="args"/>
                                                <variableReferenceExpression name="result"/>
                                              </parameters>
                                            </methodInvokeExpression>
                                          </trueStatements>
                                          <falseStatements>
                                            <methodInvokeExpression methodName="ProcessSpecialActions">
                                              <target>
                                                <methodInvokeExpression methodName="CreateBusinessRules" />
                                              </target>
                                              <parameters>
                                                <argumentReferenceExpression name="args"/>
                                                <variableReferenceExpression name="result"/>
                                              </parameters>
                                            </methodInvokeExpression>
                                          </falseStatements>
                                        </conditionStatement>-->
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
                  <catch exceptionType="Exception" localName="ex">
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IsTypeOf">
                          <variableReferenceExpression name="ex"/>
                          <typeReferenceExpression type="System.Reflection.TargetInvocationException"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="ex"/>
                          <propertyReferenceExpression name="InnerException">
                            <variableReferenceExpression name="ex"/>
                          </propertyReferenceExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                    <methodInvokeExpression methodName="HandleException">
                      <parameters>
                        <variableReferenceExpression name="ex"/>
                        <argumentReferenceExpression name="args"/>
                        <argumentReferenceExpression name="result"/>
                      </parameters>
                    </methodInvokeExpression>
                  </catch>
                </tryStatement>
                <methodInvokeExpression methodName="EnsureJsonCompatibility">
                  <target>
                    <variableReferenceExpression name="result"/>
                  </target>
                </methodInvokeExpression>
                <methodReturnStatement>
                  <variableReferenceExpression name="result"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method SupportsLimitInSelect(DbCommand) -->
            <memberMethod returnType="System.Boolean" name="SupportsLimitInSelect">
              <attributes private="true"/>
              <parameters>
                <parameter type="System.Object" name="command"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="Contains">
                    <target>
                      <methodInvokeExpression methodName="ToString">
                        <target>
                          <argumentReferenceExpression name="command"/>
                        </target>
                      </methodInvokeExpression>
                    </target>
                    <parameters>
                      <primitiveExpression value="MySql"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method SupportsSkipInSelect(DbCommand) -->
            <memberMethod returnType="System.Boolean" name="SupportsSkipInSelect">
              <attributes private="true"/>
              <parameters>
                <parameter type="System.Object" name="command"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="Contains">
                    <target>
                      <methodInvokeExpression methodName="ToString">
                        <target>
                          <argumentReferenceExpression name="command"/>
                        </target>
                      </methodInvokeExpression>
                    </target>
                    <parameters>
                      <primitiveExpression value="Firebird"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method SyncRequestedPage(PageRequest, ViewPage, DbConnection -->
            <memberMethod name="SyncRequestedPage">
              <attributes family="true"/>
              <parameters>
                <parameter type="PageRequest" name="request"/>
                <parameter type="ViewPage" name="page"/>
                <parameter type="DbConnection" name="connection"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanOr">
                      <binaryOperatorExpression operator="BooleanOr">
                        <binaryOperatorExpression operator="IdentityEquality">
                          <propertyReferenceExpression name="SyncKey">
                            <argumentReferenceExpression name="request"/>
                          </propertyReferenceExpression>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                        <binaryOperatorExpression operator="ValueEquality">
                          <propertyReferenceExpression name="Length">
                            <propertyReferenceExpression name="SyncKey">
                              <argumentReferenceExpression name="request"/>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                          <primitiveExpression value="0"/>
                        </binaryOperatorExpression>
                      </binaryOperatorExpression>
                      <binaryOperatorExpression operator="LessThan">
                        <propertyReferenceExpression name="PageSize">
                          <argumentReferenceExpression name="page"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="0"/>
                      </binaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement/>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="List" name="keyFields">
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
                        <propertyReferenceExpression name="IsPrimaryKey">
                          <variableReferenceExpression name="field"/>
                        </propertyReferenceExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <variableReferenceExpression name="keyFields"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="field"/>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
                <!--<variableDeclarationStatement type="Dictionary" name="keyFields">
                  <typeArguments>
                    <typeReference type="System.Int32"/>
                    <typeReference type="DataField"/>
                  </typeArguments>
                  <init>
                    <objectCreateExpression type="Dictionary">
                      <typeArguments>
                        <typeReference type="System.Int32"/>
                        <typeReference type="DataField"/>
                      </typeArguments>
                    </objectCreateExpression>
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
                    <conditionStatement>
                      <condition>
                        <propertyReferenceExpression name="IsPrimaryKey">
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
                        </propertyReferenceExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <variableReferenceExpression name="keyFields"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="i"/>
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
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </forStatement>-->
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <binaryOperatorExpression operator="GreaterThan">
                        <propertyReferenceExpression name="Count">
                          <variableReferenceExpression name="keyFields"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="0"/>
                      </binaryOperatorExpression>
                      <binaryOperatorExpression operator="ValueEquality">
                        <propertyReferenceExpression name="Count">
                          <variableReferenceExpression name="keyFields"/>
                        </propertyReferenceExpression>
                        <propertyReferenceExpression name="Length">
                          <propertyReferenceExpression name="SyncKey">
                            <argumentReferenceExpression name="request"/>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                      </binaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="DbCommand" name="syncCommand">
                      <init>
                        <methodInvokeExpression methodName="CreateCommand">
                          <parameters>
                            <argumentReferenceExpression name="connection"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <methodInvokeExpression methodName="ConfigureCommand">
                      <parameters>
                        <variableReferenceExpression name="syncCommand"/>
                        <argumentReferenceExpression name="page"/>
                        <propertyReferenceExpression name="Sync">
                          <typeReferenceExpression type="CommandConfigurationType"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="null"/>
                      </parameters>
                    </methodInvokeExpression>
                    <variableDeclarationStatement type="System.Boolean" name="useSkip">
                      <init>
                        <binaryOperatorExpression operator="BooleanOr">
                          <propertyReferenceExpression name="EnableResultSet">
                            <fieldReferenceExpression name="serverRules"/>
                          </propertyReferenceExpression>
                          <methodInvokeExpression methodName="SupportsSkipInSelect">
                            <parameters>
                              <variableReferenceExpression name="syncCommand"/>
                            </parameters>
                          </methodInvokeExpression>
                        </binaryOperatorExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="Not">
                          <variableReferenceExpression name="useSkip"/>
                        </unaryOperatorExpression>
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
                                <variableReferenceExpression name="keyFields"/>
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
                                    <variableReferenceExpression name="keyFields"/>
                                  </target>
                                  <indices>
                                    <variableReferenceExpression name="i"/>
                                  </indices>
                                </arrayIndexerExpression>
                              </init>
                            </variableDeclarationStatement>
                            <!--<variableDeclarationStatement type="DataField" name="field">
                          <init>
                            <methodInvokeExpression methodName="ElementAt">
                              <typeArguments>
                                <typeReference type="DataField"/>
                              </typeArguments>
                              <target>
                                <propertyReferenceExpression name="Values">
                                  <variableReferenceExpression name="keyFields"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="i"/>
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>-->
                            <variableDeclarationStatement type="DbParameter" name="p">
                              <init>
                                <methodInvokeExpression methodName="CreateParameter">
                                  <target>
                                    <variableReferenceExpression name="syncCommand"/>
                                  </target>
                                </methodInvokeExpression>
                              </init>
                            </variableDeclarationStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="ParameterName">
                                <variableReferenceExpression name="p"/>
                              </propertyReferenceExpression>
                              <stringFormatExpression format="{{0}}PrimaryKey_{{1}}">
                                <fieldReferenceExpression name="parameterMarker"/>
                                <propertyReferenceExpression name="Name">
                                  <variableReferenceExpression name="field"/>
                                </propertyReferenceExpression>
                              </stringFormatExpression>
                            </assignStatement>
                            <methodInvokeExpression methodName="AssignParameterValue">
                              <parameters>
                                <variableReferenceExpression name="p"/>
                                <propertyReferenceExpression name="Type">
                                  <variableReferenceExpression name="field"/>
                                </propertyReferenceExpression>
                                <arrayIndexerExpression>
                                  <target>
                                    <propertyReferenceExpression name="SyncKey">
                                      <argumentReferenceExpression name="request"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <indices>
                                    <variableReferenceExpression name="i"/>
                                  </indices>
                                </arrayIndexerExpression>
                              </parameters>
                            </methodInvokeExpression>
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <propertyReferenceExpression name="Parameters">
                                  <variableReferenceExpression name="syncCommand"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="p"/>
                              </parameters>
                            </methodInvokeExpression>
                          </statements>
                        </forStatement>
                      </trueStatements>
                    </conditionStatement>
                    <variableDeclarationStatement type="DbDataReader" name="reader"/>
                    <conditionStatement>
                      <condition>
                        <propertyReferenceExpression name="EnableResultSet">
                          <fieldReferenceExpression name="serverRules"/>
                        </propertyReferenceExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="reader"/>
                          <methodInvokeExpression methodName="ExecuteResultSetReader">
                            <parameters>
                              <argumentReferenceExpression name="page"/>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                      </trueStatements>
                      <falseStatements>
                        <assignStatement>
                          <variableReferenceExpression name="reader"/>
                          <methodInvokeExpression methodName="ExecuteReader">
                            <target>
                              <variableReferenceExpression name="syncCommand"/>
                            </target>
                          </methodInvokeExpression>
                        </assignStatement>
                      </falseStatements>
                    </conditionStatement>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="Not">
                          <variableReferenceExpression name="useSkip"/>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <conditionStatement>
                          <condition>
                            <methodInvokeExpression methodName="Read">
                              <target>
                                <variableReferenceExpression name="reader"/>
                              </target>
                            </methodInvokeExpression>
                          </condition>
                          <trueStatements>
                            <variableDeclarationStatement type="System.Int64" name="rowIndex">
                              <init>
                                <convertExpression to="Int64">
                                  <arrayIndexerExpression>
                                    <target>
                                      <variableReferenceExpression name="reader"/>
                                    </target>
                                    <indices>
                                      <primitiveExpression value="0"/>
                                    </indices>
                                  </arrayIndexerExpression>
                                </convertExpression>
                              </init>
                            </variableDeclarationStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="PageIndex">
                                <argumentReferenceExpression name="page"/>
                              </propertyReferenceExpression>
                              <convertExpression to="Int32">
                                <methodInvokeExpression methodName="Floor">
                                  <target>
                                    <typeReferenceExpression type="Math"/>
                                  </target>
                                  <parameters>
                                    <binaryOperatorExpression operator="Divide">
                                      <convertExpression to="Double">
                                        <binaryOperatorExpression operator="Subtract">
                                          <variableReferenceExpression name="rowIndex"/>
                                          <primitiveExpression value="1"/>
                                        </binaryOperatorExpression>
                                      </convertExpression>
                                      <convertExpression to="Double">
                                        <propertyReferenceExpression name="PageSize">
                                          <argumentReferenceExpression name="page"/>
                                        </propertyReferenceExpression>
                                      </convertExpression>
                                    </binaryOperatorExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </convertExpression>
                            </assignStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="PageOffset">
                                <argumentReferenceExpression name="page"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="0"/>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                      </trueStatements>
                      <falseStatements>
                        <variableDeclarationStatement type="System.Int64" name="rowIndex">
                          <init>
                            <primitiveExpression value="1"/>
                          </init>
                        </variableDeclarationStatement>
                        <variableDeclarationStatement type="List" name="keyFieldIndexes">
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
                        <foreachStatement>
                          <variable type="DataField" name="pkField"/>
                          <target>
                            <variableReferenceExpression name="keyFields"/>
                          </target>
                          <statements>
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <variableReferenceExpression name="keyFieldIndexes"/>
                              </target>
                              <parameters>
                                <methodInvokeExpression methodName="GetOrdinal">
                                  <target>
                                    <variableReferenceExpression name="reader"/>
                                  </target>
                                  <parameters>
                                    <propertyReferenceExpression name="Name">
                                      <variableReferenceExpression name="pkField"/>
                                    </propertyReferenceExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </statements>
                        </foreachStatement>
                        <whileStatement>
                          <test>
                            <methodInvokeExpression methodName="Read">
                              <target>
                                <variableReferenceExpression name="reader"/>
                              </target>
                            </methodInvokeExpression>
                          </test>
                          <statements>
                            <variableDeclarationStatement type="System.Int32" name="matchCount">
                              <init>
                                <primitiveExpression value="0"/>
                              </init>
                            </variableDeclarationStatement>
                            <foreachStatement>
                              <variable type="System.Int32" name="primaryKeyFieldIndex"/>
                              <target>
                                <variableReferenceExpression name="keyFieldIndexes"/>
                              </target>
                              <statements>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="ValueEquality">
                                      <convertExpression to="String">
                                        <arrayIndexerExpression>
                                          <target>
                                            <variableReferenceExpression name="reader"/>
                                          </target>
                                          <indices>
                                            <variableReferenceExpression name="primaryKeyFieldIndex"/>
                                          </indices>
                                        </arrayIndexerExpression>
                                      </convertExpression>
                                      <convertExpression to="String">
                                        <arrayIndexerExpression>
                                          <target>
                                            <propertyReferenceExpression name="SyncKey">
                                              <argumentReferenceExpression name="request"/>
                                            </propertyReferenceExpression>
                                          </target>
                                          <indices>
                                            <variableReferenceExpression name="matchCount"/>
                                          </indices>
                                        </arrayIndexerExpression>
                                      </convertExpression>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <assignStatement>
                                      <variableReferenceExpression name="matchCount"/>
                                      <binaryOperatorExpression operator="Add">
                                        <variableReferenceExpression name="matchCount"/>
                                        <primitiveExpression value="1"/>
                                      </binaryOperatorExpression>
                                    </assignStatement>
                                  </trueStatements>
                                  <falseStatements>
                                    <breakStatement/>
                                  </falseStatements>
                                </conditionStatement>
                              </statements>
                            </foreachStatement>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="ValueEquality">
                                  <variableReferenceExpression name="matchCount"/>
                                  <propertyReferenceExpression name="Count">
                                    <variableReferenceExpression name="keyFieldIndexes"/>
                                  </propertyReferenceExpression>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <propertyReferenceExpression name="PageIndex">
                                    <argumentReferenceExpression name="page"/>
                                  </propertyReferenceExpression>
                                  <convertExpression to="Int32">
                                    <methodInvokeExpression methodName="Floor">
                                      <target>
                                        <typeReferenceExpression type="Math"/>
                                      </target>
                                      <parameters>
                                        <binaryOperatorExpression operator="Divide">
                                          <convertExpression to="Double">
                                            <binaryOperatorExpression operator="Subtract">
                                              <variableReferenceExpression name="rowIndex"/>
                                              <primitiveExpression value="1"/>
                                            </binaryOperatorExpression>
                                          </convertExpression>
                                          <convertExpression to="Double">
                                            <propertyReferenceExpression name="PageSize">
                                              <argumentReferenceExpression name="page"/>
                                            </propertyReferenceExpression>
                                          </convertExpression>
                                        </binaryOperatorExpression>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </convertExpression>
                                </assignStatement>
                                <assignStatement>
                                  <propertyReferenceExpression name="PageOffset">
                                    <argumentReferenceExpression name="page"/>
                                  </propertyReferenceExpression>
                                  <primitiveExpression value="0"/>
                                </assignStatement>
                                <methodInvokeExpression methodName="ResetSkipCount">
                                  <target>
                                    <argumentReferenceExpression name="page"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="false"/>
                                  </parameters>
                                </methodInvokeExpression>
                                <breakStatement/>
                              </trueStatements>
                              <falseStatements>
                                <incrementStatement>
                                  <variableReferenceExpression name="rowIndex"/>
                                </incrementStatement>
                              </falseStatements>
                            </conditionStatement>
                          </statements>
                        </whileStatement>
                      </falseStatements>
                    </conditionStatement>
                    <methodInvokeExpression methodName="Close">
                      <target>
                        <variableReferenceExpression name="reader"/>
                      </target>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method HandleException(Exception, ActionArgs, ActionResult) -->
            <memberMethod name="HandleException">
              <attributes family="true"/>
              <parameters>
                <parameter type="Exception" name="ex"/>
                <parameter type="ActionArgs" name="args"/>
                <parameter type="ActionResult" name="result"/>
              </parameters>
              <statements>
                <whileStatement>
                  <test>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <variableReferenceExpression name="ex"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </test>
                  <statements>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <propertyReferenceExpression name="Errors">
                          <variableReferenceExpression name="result"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="Message">
                          <variableReferenceExpression name="ex"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <assignStatement>
                      <variableReferenceExpression name="ex"/>
                      <propertyReferenceExpression name="InnerException">
                        <variableReferenceExpression name="ex"/>
                      </propertyReferenceExpression>
                    </assignStatement>
                  </statements>
                </whileStatement>
              </statements>
            </memberMethod>
            <!-- method IDataEngine.ExecuteReader(PageRequest) -->
            <memberMethod returnType="DbDataReader" name="ExecuteReader" privateImplementationType="IDataEngine">
              <attributes/>
              <parameters>
                <parameter type="PageRequest" name="request"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="ViewPage" name="page">
                  <init>
                    <objectCreateExpression type="ViewPage">
                      <parameters>
                        <argumentReferenceExpression name="request"/>
                      </parameters>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <fieldReferenceExpression name="config"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <fieldReferenceExpression name="config"/>
                      <methodInvokeExpression methodName="CreateConfiguration">
                        <parameters>
                          <propertyReferenceExpression name="Controller">
                            <argumentReferenceExpression name="request"/>
                          </propertyReferenceExpression>
                        </parameters>
                      </methodInvokeExpression>
                    </assignStatement>
                    <methodInvokeExpression methodName="SelectView">
                      <parameters>
                        <propertyReferenceExpression name="Controller">
                          <argumentReferenceExpression name="request"/>
                        </propertyReferenceExpression>
                        <propertyReferenceExpression name="View">
                          <argumentReferenceExpression name="request"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
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
                      <argumentReferenceExpression name="request"/>
                    </propertyReferenceExpression>
                    <propertyReferenceExpression name="View">
                      <argumentReferenceExpression name="request"/>
                    </propertyReferenceExpression>
                    <primitiveExpression value="null"/>
                    <primitiveExpression value="null"/>
                    <primitiveExpression value="null"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="InitBusinessRules">
                  <parameters>
                    <argumentReferenceExpression name="request"/>
                    <variableReferenceExpression name="page"/>
                  </parameters>
                </methodInvokeExpression>
                <variableDeclarationStatement type="DbConnection" name="connection">
                  <init>
                    <methodInvokeExpression methodName="CreateConnection"/>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="DbCommand" name="selectCommand">
                  <init>
                    <methodInvokeExpression methodName="CreateCommand">
                      <parameters>
                        <variableReferenceExpression name="connection"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
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
                <methodReturnStatement>
                  <methodInvokeExpression methodName="ExecuteReader">
                    <target>
                      <variableReferenceExpression name="selectCommand"/>
                    </target>
                    <parameters>
                      <propertyReferenceExpression name="CloseConnection">
                        <typeReferenceExpression type="CommandBehavior"/>
                      </propertyReferenceExpression>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method IAutoCompleteManager.GetCompletionList(string, int, string) -->
            <memberMethod returnType="System.String[]" name="GetCompletionList" privateImplementationType="IAutoCompleteManager">
              <attributes/>
              <parameters>
                <parameter type="System.String" name="prefixText"/>
                <parameter type="System.Int32" name="count"/>
                <parameter type="System.String" name="contextKey"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <argumentReferenceExpression name="contextKey"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="null"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="System.String[]" name="arguments">
                  <init>
                    <methodInvokeExpression methodName="Split">
                      <target>
                        <argumentReferenceExpression name="contextKey"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="," convertTo="Char"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueInequality">
                      <propertyReferenceExpression name="Length">
                        <variableReferenceExpression name="arguments"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="3"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="null"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="DistinctValueRequest" name="request">
                  <init>
                    <objectCreateExpression type="DistinctValueRequest"/>
                  </init>
                </variableDeclarationStatement>
                <assignStatement>
                  <propertyReferenceExpression name="FieldName">
                    <variableReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                  <arrayIndexerExpression>
                    <target>
                      <variableReferenceExpression name="arguments"/>
                    </target>
                    <indices>
                      <primitiveExpression value="2"/>
                    </indices>
                  </arrayIndexerExpression>
                </assignStatement>
                <variableDeclarationStatement type="System.String" name="filter">
                  <init>
                    <binaryOperatorExpression operator="Add">
                      <propertyReferenceExpression name="FieldName">
                        <variableReferenceExpression name="request"/>
                      </propertyReferenceExpression>
                      <primitiveExpression value=":"/>
                    </binaryOperatorExpression>
                  </init>
                </variableDeclarationStatement>
                <foreachStatement>
                  <variable type="System.String" name="s"/>
                  <target>
                    <methodInvokeExpression methodName="Split">
                      <target>
                        <argumentReferenceExpression name="prefixText"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="," convertTo="Char"/>
                        <primitiveExpression value=";" convertTo="Char"/>
                      </parameters>
                    </methodInvokeExpression>
                  </target>
                  <statements>
                    <variableDeclarationStatement type="System.String" name="query">
                      <init>
                        <methodInvokeExpression methodName="ConvertSampleToQuery">
                          <target>
                            <typeReferenceExpression type="Controller"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="s"/>
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
                              <variableReferenceExpression name="query"/>
                            </parameters>
                          </methodInvokeExpression>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="filter"/>
                          <binaryOperatorExpression operator="Add">
                            <variableReferenceExpression name="filter"/>
                            <variableReferenceExpression name="query"/>
                          </binaryOperatorExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Filter">
                    <variableReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                  <arrayCreateExpression>
                    <createType type="System.String"/>
                    <initializers>
                      <variableReferenceExpression name="filter"/>
                    </initializers>
                  </arrayCreateExpression>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="AllowFieldInFilter">
                    <variableReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="true"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="MaximumValueCount">
                    <variableReferenceExpression name="request"/>
                  </propertyReferenceExpression>
                  <argumentReferenceExpression name="count"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Controller">
                    <variableReferenceExpression name="request"/>
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
                <assignStatement>
                  <propertyReferenceExpression name="View">
                    <variableReferenceExpression name="request"/>
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
                <variableDeclarationStatement type="System.Object[]" name="list">
                  <init>
                    <methodInvokeExpression methodName="GetListOfValues">
                      <target>
                        <methodInvokeExpression methodName="CreateDataController">
                          <target>
                            <typeReferenceExpression type="ControllerFactory"/>
                          </target>
                        </methodInvokeExpression>
                      </target>
                      <parameters>
                        <arrayIndexerExpression>
                          <target>
                            <variableReferenceExpression name="arguments"/>
                          </target>
                          <indices>
                            <primitiveExpression value="0"/>
                          </indices>
                        </arrayIndexerExpression>
                        <arrayIndexerExpression>
                          <target>
                            <variableReferenceExpression name="arguments"/>
                          </target>
                          <indices>
                            <primitiveExpression value="1"/>
                          </indices>
                        </arrayIndexerExpression>
                        <variableReferenceExpression name="request"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="List" name="result">
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
                  <variable type="System.Object" name="o"/>
                  <target>
                    <variableReferenceExpression name="list"/>
                  </target>
                  <statements>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <variableReferenceExpression name="result"/>
                      </target>
                      <parameters>
                        <methodInvokeExpression methodName="ToString">
                          <target>
                            <typeReferenceExpression type="Convert"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="o"/>
                          </parameters>
                        </methodInvokeExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </statements>
                </foreachStatement>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="ToArray">
                    <target>
                      <variableReferenceExpression name="result"/>
                    </target>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method IBusinessObject.AssignFilter(string, BusinessObjectParameters) -->
            <memberMethod name="AssignFilter" privateImplementationType="IBusinessObject">
              <attributes public="true"/>
              <parameters>
                <parameter type="System.String" name="filter"/>
                <parameter type="BusinessObjectParameters" name="parameters"/>
              </parameters>
              <statements>
                <assignStatement>
                  <fieldReferenceExpression name="viewFilter"/>
                  <argumentReferenceExpression name="filter"/>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="parameters"/>
                  <argumentReferenceExpression name="parameters"/>
                </assignStatement>
              </statements>
            </memberMethod>
            <!-- member GetSelectView(string controller) -->
            <memberMethod returnType="System.String" name="GetSelectView">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="controller"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="ControllerUtilities" name="c">
                  <init>
                    <objectCreateExpression type="ControllerUtilities"/>
                  </init>
                </variableDeclarationStatement>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="GetActionView">
                    <target>
                      <variableReferenceExpression name="c"/>
                    </target>
                    <parameters>
                      <argumentReferenceExpression name="controller"/>
                      <primitiveExpression value="editForm1"/>
                      <primitiveExpression value="Select"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- member GetUpdateView(string controller) -->
            <memberMethod returnType="System.String" name="GetUpdateView">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="controller"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="ControllerUtilities" name="c">
                  <init>
                    <objectCreateExpression type="ControllerUtilities"/>
                  </init>
                </variableDeclarationStatement>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="GetActionView">
                    <target>
                      <variableReferenceExpression name="c"/>
                    </target>
                    <parameters>
                      <argumentReferenceExpression name="controller"/>
                      <primitiveExpression value="editForm1"/>
                      <primitiveExpression value="Update"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- member GetInsertView(string controller) -->
            <memberMethod returnType="System.String" name="GetInsertView">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="controller"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="ControllerUtilities" name="c">
                  <init>
                    <objectCreateExpression type="ControllerUtilities"/>
                  </init>
                </variableDeclarationStatement>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="GetActionView">
                    <target>
                      <variableReferenceExpression name="c"/>
                    </target>
                    <parameters>
                      <argumentReferenceExpression name="controller"/>
                      <primitiveExpression value="createForm1"/>
                      <primitiveExpression value="Insert"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- member GetDeleteView(string controller) -->
            <memberMethod returnType="System.String" name="GetDeleteView">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="controller"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="ControllerUtilities" name="c">
                  <init>
                    <objectCreateExpression type="ControllerUtilities"/>
                  </init>
                </variableDeclarationStatement>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="GetActionView">
                    <target>
                      <variableReferenceExpression name="c"/>
                    </target>
                    <parameters>
                      <argumentReferenceExpression name="controller"/>
                      <primitiveExpression value="editForm1"/>
                      <primitiveExpression value="Delete"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- property DefaultDataControllerStream -->
            <memberField type="Stream" name="DefaultDataControllerStream">
              <attributes public="true" static="true"/>
              <init>
                <objectCreateExpression type="MemoryStream"/>
              </init>
            </memberField>
            <!-- method GetDataControllerStream(Stream) -->
            <memberMethod returnType="Stream" name="GetDataControllerStream">
              <attributes public="true"/>
              <parameters>
                <parameter type="System.String" name="controller"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <primitiveExpression value="null"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method ExecuteVirtualReader(PageRequest, ViewPage) -->
            <memberMethod returnType="DbDataReader" name="ExecuteVirtualReader">
              <attributes family="true"/>
              <parameters>
                <parameter type="PageRequest" name="request"/>
                <parameter type="ViewPage" name="page"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="DataTable" name="table">
                  <init>
                    <objectCreateExpression type="DataTable"/>
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
                        <typeofExpression type="System.Int32"/>
                      </parameters>
                    </methodInvokeExpression>
                  </statements>
                </foreachStatement>
                <variableDeclarationStatement type="DataRow" name="r">
                  <init>
                    <methodInvokeExpression methodName="NewRow">
                      <target>
                        <variableReferenceExpression name="table"/>
                      </target>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="ContainsField">
                      <target>
                        <argumentReferenceExpression name="page"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="PrimaryKey"/>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <arrayIndexerExpression>
                        <target>
                          <variableReferenceExpression name="r"/>
                        </target>
                        <indices>
                          <primitiveExpression value="PrimaryKey"/>
                        </indices>
                      </arrayIndexerExpression>
                      <primitiveExpression value="1"/>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <propertyReferenceExpression name="Rows">
                      <variableReferenceExpression name="table"/>
                    </propertyReferenceExpression>
                  </target>
                  <parameters>
                    <variableReferenceExpression name="r"/>
                  </parameters>
                </methodInvokeExpression>
                <methodReturnStatement>
                  <objectCreateExpression type="DataTableReader">
                    <parameters>
                      <variableReferenceExpression name="table"/>
                    </parameters>
                  </objectCreateExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- property HierarchyOrganizationFieldName -->
            <memberProperty type="System.String" name="HierarchyOrganizationFieldName">
              <attributes family="true"/>
              <getStatements>
                <methodReturnStatement>
                  <primitiveExpression value="HierarchyOrganization__"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- method GetRequestedViewType(ViewPage) -->
            <memberMethod returnType="System.String" name="GetRequestedViewType">
              <attributes family="true" />
              <parameters>
                <parameter type="ViewPage" name="page"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.String" name="viewType">
                  <init>
                    <propertyReferenceExpression name="ViewType">
                      <argumentReferenceExpression name="page"/>
                    </propertyReferenceExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="IsNullOrEmpty">
                      <variableReferenceExpression name="viewType"/>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="viewType"/>
                      <methodInvokeExpression methodName="GetAttribute">
                        <target>
                          <fieldReferenceExpression name="view"/>
                        </target>
                        <parameters>
                          <primitiveExpression value="type"/>
                          <stringEmptyExpression/>
                        </parameters>
                      </methodInvokeExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <variableReferenceExpression name="viewType"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method EnsureSystemPageFields(PageReuqest, ViewPage, DbCommand) -->
            <memberMethod name="EnsureSystemPageFields">
              <attributes family="true"/>
              <parameters>
                <parameter type="PageRequest" name="request"/>
                <parameter type="ViewPage" name="page"/>
                <parameter type="DbCommand" name="command"/>
              </parameters>
              <statements>
                <xsl:if test="$IsPremium='true'">
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
                      <methodReturnStatement/>
                    </trueStatements>
                  </conditionStatement>
                  <variableDeclarationStatement type="System.Boolean" name="requiresHierarchyOrganization">
                    <init>
                      <primitiveExpression value="false"/>
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
                            <variableReferenceExpression name="requiresHierarchyOrganization"/>
                            <primitiveExpression value="true"/>
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
                                <variableReferenceExpression name="requiresHierarchyOrganization"/>
                                <primitiveExpression value="false"/>
                              </assignStatement>
                              <breakStatement/>
                            </trueStatements>
                          </conditionStatement>
                        </falseStatements>
                      </conditionStatement>
                    </statements>
                  </foreachStatement>
                  <conditionStatement>
                    <condition>
                      <variableReferenceExpression name="requiresHierarchyOrganization"/>
                    </condition>
                    <trueStatements>
                      <variableDeclarationStatement type="DataField" name="field">
                        <init>
                          <objectCreateExpression type="DataField"/>
                        </init>
                      </variableDeclarationStatement>
                      <assignStatement>
                        <propertyReferenceExpression name="Name">
                          <variableReferenceExpression name="field"/>
                        </propertyReferenceExpression>
                        <propertyReferenceExpression name="HierarchyOrganizationFieldName"/>
                      </assignStatement>
                      <assignStatement>
                        <propertyReferenceExpression name="Type">
                          <variableReferenceExpression name="field"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="String"/>
                      </assignStatement>
                      <assignStatement>
                        <propertyReferenceExpression name="Tag">
                          <variableReferenceExpression name="field"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="hierarchy-organization"/>
                      </assignStatement>
                      <assignStatement>
                        <propertyReferenceExpression name="Len">
                          <variableReferenceExpression name="field"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="255"/>
                      </assignStatement>
                      <assignStatement>
                        <propertyReferenceExpression name="Columns">
                          <variableReferenceExpression name="field"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="20"/>
                      </assignStatement>
                      <assignStatement>
                        <propertyReferenceExpression name="Hidden">
                          <variableReferenceExpression name="field"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="true"/>
                      </assignStatement>
                      <assignStatement>
                        <propertyReferenceExpression name="ReadOnly">
                          <variableReferenceExpression name="field"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="true"/>
                      </assignStatement>
                      <methodInvokeExpression methodName="Add">
                        <target>
                          <propertyReferenceExpression name="Fields">
                            <argumentReferenceExpression name="page"/>
                          </propertyReferenceExpression>
                        </target>
                        <parameters>
                          <variableReferenceExpression name="field"/>
                        </parameters>
                      </methodInvokeExpression>
                    </trueStatements>
                  </conditionStatement>
                </xsl:if>
              </statements>
            </memberMethod>
            <!-- method RequiresHierarchy(ViewPage) -->
            <memberMethod returnType="System.Boolean" name="RequiresHierarchy">
              <attributes family="true"/>
              <parameters>
                <parameter type="ViewPage" name="page"/>
              </parameters>
              <statements>
                <xsl:if test="$IsPremium='true'">
                  <conditionStatement>
                    <condition>
                      <binaryOperatorExpression operator="ValueInequality">
                        <methodInvokeExpression methodName="GetRequestedViewType">
                          <parameters>
                            <argumentReferenceExpression name="page"/>
                          </parameters>
                        </methodInvokeExpression>
                        <primitiveExpression value="DataSheet"/>
                      </binaryOperatorExpression>
                    </condition>
                    <trueStatements>
                      <methodReturnStatement>
                        <primitiveExpression value="false"/>
                      </methodReturnStatement>
                    </trueStatements>
                  </conditionStatement>
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
                          <conditionStatement>
                            <condition>
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
                    </statements>
                  </foreachStatement>
                </xsl:if>
                <methodReturnStatement>
                  <primitiveExpression value="false"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method DatabaseEngineIs(DbCommand, params string[] -->
            <memberMethod returnType="System.Boolean" name="DatabaseEngineIs">
              <attributes family="true"/>
              <parameters>
                <parameter type="DbCommand" name="command"/>
                <parameter type="params System.String[]" name="flavors"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="DatabaseEngineIs">
                    <parameters>
                      <propertyReferenceExpression name="FullName">
                        <methodInvokeExpression methodName="GetType">
                          <target>
                            <argumentReferenceExpression name="command"/>
                          </target>
                        </methodInvokeExpression>
                      </propertyReferenceExpression>
                      <argumentReferenceExpression name="flavors"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method DatabaseEngineIs(string, params string[] -->
            <memberMethod returnType="System.Boolean" name="DatabaseEngineIs">
              <attributes family="true"/>
              <parameters>
                <parameter type="System.String" name="typeName"/>
                <parameter type="params System.String[]" name="flavors"/>
              </parameters>
              <statements>
                <foreachStatement>
                  <variable type="System.String" name="s"/>
                  <target>
                    <argumentReferenceExpression name="flavors"/>
                  </target>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <methodInvokeExpression methodName="Contains">
                          <target>
                            <argumentReferenceExpression name="typeName"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="s"/>
                          </parameters>
                        </methodInvokeExpression>
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
              </statements>
            </memberMethod>
            <!-- method ValidateViewAccess(string, string, string) -->
            <memberMethod returnType="System.Boolean" name="ValidateViewAccess">
              <attributes family="true"/>
              <parameters>
                <parameter type="System.String" name="controller"/>
                <parameter type="System.String" name="view"/>
                <parameter type="System.String" name="access"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.Boolean" name="allow">
                  <init>
                    <primitiveExpression value="true"/>
                  </init>
                </variableDeclarationStatement>
                <xsl:if test="$MembershipEnabled='true' or $CustomSecurity='true' or $ActiveDirectory='true'">
                  <variableDeclarationStatement type="System.String" name="executionFilePath">
                    <init>
                      <propertyReferenceExpression name="AppRelativeCurrentExecutionFilePath">
                        <propertyReferenceExpression name="Request">
                          <propertyReferenceExpression name="Current">
                            <typeReferenceExpression type="HttpContext"/>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                      </propertyReferenceExpression>
                    </init>
                  </variableDeclarationStatement>
                  <conditionStatement>
                    <condition>
                      <binaryOperatorExpression operator="BooleanAnd">
                        <binaryOperatorExpression operator="BooleanAnd">
                          <unaryOperatorExpression operator="Not">
                            <methodInvokeExpression methodName="StartsWith">
                              <target>
                                <variableReferenceExpression name="executionFilePath"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="~/appservices/"/>
                                <propertyReferenceExpression name="OrdinalIgnoreCase">
                                  <typeReferenceExpression type="StringComparison"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </unaryOperatorExpression>
                          <unaryOperatorExpression operator="Not">
                            <methodInvokeExpression methodName="Equals">
                              <target>
                                <variableReferenceExpression name="executionFilePath"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="~/blob.ashx"/>
                                <propertyReferenceExpression name="OrdinalIgnoreCase">
                                  <typeReferenceExpression type="StringComparison"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </unaryOperatorExpression>
                        </binaryOperatorExpression>
                        <unaryOperatorExpression operator="Not">
                          <methodInvokeExpression methodName="Equals">
                            <target>
                              <variableReferenceExpression name="executionFilePath"/>
                            </target>
                            <parameters>
                              <primitiveExpression value="~/charthost.aspx"/>
                              <propertyReferenceExpression name="OrdinalIgnoreCase">
                                <typeReferenceExpression type="StringComparison"/>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </unaryOperatorExpression>
                      </binaryOperatorExpression>
                    </condition>
                    <trueStatements>
                      <conditionStatement>
                        <condition>
                          <binaryOperatorExpression operator="BooleanAnd">
                            <unaryOperatorExpression operator="Not">
                              <propertyReferenceExpression name="IsAuthenticated">
                                <propertyReferenceExpression name="Identity">
                                  <propertyReferenceExpression name="User">
                                    <propertyReferenceExpression name="Current">
                                      <typeReferenceExpression type="HttpContext"/>
                                    </propertyReferenceExpression>
                                  </propertyReferenceExpression>
                                </propertyReferenceExpression>
                              </propertyReferenceExpression>
                            </unaryOperatorExpression>
                            <unaryOperatorExpression operator="Not">
                              <methodInvokeExpression methodName="StartsWith">
                                <target>
                                  <argumentReferenceExpression name="controller"/>
                                </target>
                                <parameters>
                                  <primitiveExpression value="aspnet_"/>
                                </parameters>
                              </methodInvokeExpression>
                            </unaryOperatorExpression>
                          </binaryOperatorExpression>
                        </condition>
                        <trueStatements>
                          <assignStatement>
                            <variableReferenceExpression name="allow"/>
                            <binaryOperatorExpression operator="ValueEquality">
                              <argumentReferenceExpression name="access"/>
                              <primitiveExpression value="Public"/>
                            </binaryOperatorExpression>
                          </assignStatement>
                        </trueStatements>
                      </conditionStatement>
                    </trueStatements>
                  </conditionStatement>
                </xsl:if>
                <methodReturnStatement>
                  <variableReferenceExpression name="allow"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- field resultSetParameters -->
            <memberField type="DbParameterCollection" name="resultSetParameters"/>
            <!-- method ExecuteResultSetReader(ViewPage) -->
            <memberMethod returnType="DbDataReader" name="ExecuteResultSetReader">
              <attributes final="true"/>
              <parameters>
                <parameter type="ViewPage" name="page"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <propertyReferenceExpression name="ResultSet">
                        <fieldReferenceExpression name="serverRules"/>
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
                <variableDeclarationStatement type="SelectClauseDictionary" name="expressions">
                  <init>
                    <objectCreateExpression type="SelectClauseDictionary"/>
                  </init>
                </variableDeclarationStatement>
                <foreachStatement>
                  <variable type="DataColumn" name="c"/>
                  <target>
                    <propertyReferenceExpression name="Columns">
                      <propertyReferenceExpression name="ResultSet">
                        <fieldReferenceExpression name="serverRules"/>
                      </propertyReferenceExpression>
                    </propertyReferenceExpression>
                  </target>
                  <statements>
                    <assignStatement>
                      <arrayIndexerExpression>
                        <target>
                          <variableReferenceExpression name="expressions"/>
                        </target>
                        <indices>
                          <propertyReferenceExpression name="ColumnName">
                            <variableReferenceExpression name="c"/>
                          </propertyReferenceExpression>
                        </indices>
                      </arrayIndexerExpression>
                      <propertyReferenceExpression name="ColumnName">
                        <variableReferenceExpression name="c"/>
                      </propertyReferenceExpression>
                    </assignStatement>
                  </statements>
                </foreachStatement>
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
                    <methodInvokeExpression methodName="PopulatePageFields">
                      <parameters>
                        <argumentReferenceExpression name="page"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="EnsurePageFields">
                      <parameters>
                        <argumentReferenceExpression name="page"/>
                        <primitiveExpression value="null"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="DataView" name="resultView">
                  <init>
                    <objectCreateExpression type="DataView">
                      <parameters>
                        <propertyReferenceExpression name="ResultSet">
                          <fieldReferenceExpression name="serverRules"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Sort">
                    <variableReferenceExpression name="resultView"/>
                  </propertyReferenceExpression>
                  <propertyReferenceExpression name="SortExpression">
                    <argumentReferenceExpression name="page"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <usingStatement>
                  <variable type="DbConnection" name="connection">
                    <init>
                      <methodInvokeExpression methodName="CreateConnection">
                        <parameters>
                          <primitiveExpression value="false"/>
                        </parameters>
                      </methodInvokeExpression>
                    </init>
                  </variable>
                  <statements>
                    <variableDeclarationStatement type="DbCommand" name="command">
                      <init>
                        <methodInvokeExpression methodName="CreateCommand">
                          <target>
                            <variableReferenceExpression name="connection"/>
                          </target>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="StringBuilder" name="sb">
                      <init>
                        <objectCreateExpression type="StringBuilder"/>
                      </init>
                    </variableDeclarationStatement>
                    <assignStatement>
                      <fieldReferenceExpression name="resultSetParameters"/>
                      <propertyReferenceExpression name="Parameters">
                        <variableReferenceExpression name="command"/>
                      </propertyReferenceExpression>
                    </assignStatement>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <variableReferenceExpression name="expressions"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="_DataView_RowFilter_"/>
                        <primitiveExpression value="true" convertTo="String"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="AppendFilterExpressionsToWhere">
                      <parameters>
                        <variableReferenceExpression name="sb"/>
                        <argumentReferenceExpression name="page"/>
                        <variableReferenceExpression name="command"/>
                        <variableReferenceExpression name="expressions"/>
                        <stringEmptyExpression/>
                      </parameters>
                    </methodInvokeExpression>
                    <variableDeclarationStatement type="System.String" name="filter">
                      <init>
                        <methodInvokeExpression methodName="ToString">
                          <target>
                            <variableReferenceExpression name="sb"/>
                          </target>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <methodInvokeExpression methodName="StartsWith">
                          <target>
                            <variableReferenceExpression name="filter"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="where"/>
                          </parameters>
                        </methodInvokeExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="filter"/>
                          <methodInvokeExpression methodName="Substring">
                            <target>
                              <variableReferenceExpression name="filter"/>
                            </target>
                            <parameters>
                              <primitiveExpression value="5"/>
                            </parameters>
                          </methodInvokeExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                    <assignStatement>
                      <variableReferenceExpression name="filter"/>
                      <methodInvokeExpression methodName="Replace">
                        <target>
                          <typeReferenceExpression type="Regex"/>
                        </target>
                        <parameters>
                          <variableReferenceExpression name="filter"/>
                          <binaryOperatorExpression operator="Add">
                            <methodInvokeExpression methodName="Escape">
                              <target>
                                <typeReferenceExpression type="Regex"/>
                              </target>
                              <parameters>
                                <fieldReferenceExpression name="parameterMarker"/>
                              </parameters>
                            </methodInvokeExpression>
                            <primitiveExpression value="\w+"/>
                          </binaryOperatorExpression>
                          <addressOfExpression>
                            <methodReferenceExpression methodName="DoReplaceResultSetParameter"/>
                          </addressOfExpression>
                        </parameters>
                      </methodInvokeExpression>
                    </assignStatement>
                    <assignStatement>
                      <propertyReferenceExpression name="RowFilter">
                        <variableReferenceExpression name="resultView"/>
                      </propertyReferenceExpression>
                      <variableReferenceExpression name="filter"/>
                    </assignStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="GreaterThan">
                          <propertyReferenceExpression name="PageSize">
                            <argumentReferenceExpression name="page"/>
                          </propertyReferenceExpression>
                          <primitiveExpression value="0"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <propertyReferenceExpression name="TotalRowCount">
                            <variableReferenceExpression name="page"/>
                          </propertyReferenceExpression>
                          <propertyReferenceExpression name="Count">
                            <variableReferenceExpression name="resultView"/>
                          </propertyReferenceExpression>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </usingStatement>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="RequiresPreFetching">
                      <parameters>
                        <argumentReferenceExpression name="page"/>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="ResetSkipCount">
                      <target>
                        <argumentReferenceExpression name="page"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="true"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="CreateDataReader">
                    <target>
                      <methodInvokeExpression methodName="ToTable">
                        <target>
                          <variableReferenceExpression name="resultView"/>
                        </target>
                      </methodInvokeExpression>
                    </target>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method DoReplaceResultSetParameter(Match) -->
            <memberMethod returnType="System.String" name="DoReplaceResultSetParameter">
              <attributes family="true"/>
              <parameters>
                <parameter type="Match" name="m"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="DbParameter" name="p">
                  <init>
                    <arrayIndexerExpression>
                      <target>
                        <fieldReferenceExpression name="resultSetParameters"/>
                      </target>
                      <indices>
                        <propertyReferenceExpression name="Value">
                          <argumentReferenceExpression  name="m"/>
                        </propertyReferenceExpression>
                      </indices>
                    </arrayIndexerExpression>
                  </init>
                </variableDeclarationStatement>
                <methodReturnStatement>
                  <stringFormatExpression format="'{{0}}'">
                    <methodInvokeExpression methodName="Replace">
                      <target>
                        <methodInvokeExpression methodName="ToString">
                          <target>
                            <propertyReferenceExpression name="Value">
                              <variableReferenceExpression name="p"/>
                            </propertyReferenceExpression>
                          </target>
                        </methodInvokeExpression>
                      </target>
                      <parameters>
                        <primitiveExpression value="'"/>
                        <primitiveExpression value="''"/>
                      </parameters>
                    </methodInvokeExpression>
                  </stringFormatExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method RequiresPreFetching(ViewPage) -->
            <memberMethod returnType="System.Boolean" name="RequiresPreFetching">
              <attributes final="true"/>
              <parameters>
                <parameter type="ViewPage" name="page"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.String" name="viewType">
                  <init>
                    <propertyReferenceExpression name="ViewType">
                      <argumentReferenceExpression name="page"/>
                    </propertyReferenceExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="IsNullOrEmpty">
                      <variableReferenceExpression name="viewType"/>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="viewType"/>
                      <methodInvokeExpression methodName="GetAttribute">
                        <target>
                          <fieldReferenceExpression name="view"/>
                        </target>
                        <parameters>
                          <primitiveExpression value="type"/>
                          <stringEmptyExpression/>
                        </parameters>
                      </methodInvokeExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <binaryOperatorExpression operator="BooleanAnd">
                    <binaryOperatorExpression operator="ValueInequality">
                      <propertyReferenceExpression name="PageSize">
                        <argumentReferenceExpression name="page"/>
                      </propertyReferenceExpression>
                      <propertyReferenceExpression name="MaxValue">
                        <typeReferenceExpression type="Int32"/>
                      </propertyReferenceExpression>
                    </binaryOperatorExpression>
                    <methodInvokeExpression methodName="SupportsCaching">
                      <target>
                        <objectCreateExpression type="ControllerUtilities"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="page"/>
                        <variableReferenceExpression name="viewType"/>
                      </parameters>
                    </methodInvokeExpression>
                  </binaryOperatorExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>

        <!-- type ControllerUtilities -->
        <typeDeclaration name="ControllerUtilities" isPartial="true">
          <baseTypes>
            <typeReference type="ControllerUtilitiesBase"/>
          </baseTypes>
        </typeDeclaration>

        <!-- type ControllerUtilitiesBase -->
        <typeDeclaration name="ControllerUtilitiesBase">
          <members>
            <!-- property UtcOffsetInMinutes -->
            <!--<memberProperty type="System.Double" name="UtcOffsetInMinutes">
              <attributes public="true" static="true"/>
              <getStatements>
                <methodReturnStatement>
                  <propertyReferenceExpression name="TotalMinutes">
                    <methodInvokeExpression methodName="GetUtcOffset">
                      <target>
                        <propertyReferenceExpression name="CurrentTimeZone">
                          <typeReferenceExpression type="TimeZone"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="Now">
                          <typeReferenceExpression type="DateTime"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </propertyReferenceExpression>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>-->
            <!-- method GetActionView(string string, string) -->
            <memberMethod returnType="System.String" name="GetActionView">
              <attributes public="true"/>
              <parameters>
                <parameter type="System.String" name="controller"/>
                <parameter type="System.String" name="view"/>
                <parameter type="System.String" name="action"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <argumentReferenceExpression name="view"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method UserIsInRole(params string[])-->
            <memberMethod returnType="System.Boolean" name="UserIsInRole">
              <attributes public="true"/>
              <parameters>
                <parameter type="params System.String[]" name="roles"/>
              </parameters>
              <statements>
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
                      <primitiveExpression value="true"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="System.Int32" name="count">
                  <init>
                    <primitiveExpression value="0"/>
                  </init>
                </variableDeclarationStatement>
                <foreachStatement>
                  <variable type="System.String" name="r"/>
                  <target>
                    <argumentReferenceExpression name="roles"/>
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
                              <argumentReferenceExpression name="r"/>
                            </parameters>
                          </methodInvokeExpression>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <foreachStatement>
                          <variable type="System.String" name="role"/>
                          <target>
                            <methodInvokeExpression methodName="Split">
                              <target>
                                <argumentReferenceExpression name="r"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="," convertTo="Char"/>
                              </parameters>
                            </methodInvokeExpression>
                          </target>
                          <statements>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="BooleanAnd">
                                  <unaryOperatorExpression operator="IsNotNullOrEmpty">
                                    <argumentReferenceExpression name="role"/>
                                  </unaryOperatorExpression>
                                  <methodInvokeExpression methodName="IsInRole">
                                    <target>
                                      <propertyReferenceExpression name="User">
                                        <propertyReferenceExpression name="Current">
                                          <typeReferenceExpression type="HttpContext"/>
                                        </propertyReferenceExpression>
                                      </propertyReferenceExpression>
                                    </target>
                                    <parameters>
                                      <methodInvokeExpression methodName="Trim">
                                        <target>
                                          <argumentReferenceExpression name="role"/>
                                        </target>
                                      </methodInvokeExpression>
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
                            <assignStatement>
                              <variableReferenceExpression name="count"/>
                              <binaryOperatorExpression operator="Add">
                                <variableReferenceExpression name="count"/>
                                <primitiveExpression value="1"/>
                              </binaryOperatorExpression>
                            </assignStatement>
                          </statements>
                        </foreachStatement>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
                <methodReturnStatement>
                  <binaryOperatorExpression operator="ValueEquality">
                    <variableReferenceExpression name="count"/>
                    <primitiveExpression value="0"/>
                  </binaryOperatorExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- property SupportsScrollingInDataSheet -->
            <memberProperty type="System.Boolean" name="SupportsScrollingInDataSheet">
              <attributes public="true"/>
              <getStatements>
                <xsl:choose>
                  <xsl:when test="$IsPremium='true'">
                    <methodReturnStatement>
                      <primitiveExpression value="false"/>
                    </methodReturnStatement>
                  </xsl:when>
                  <xsl:otherwise>
                    <methodReturnStatement>
                      <primitiveExpression value="false"/>
                    </methodReturnStatement>
                  </xsl:otherwise>
                </xsl:choose>
              </getStatements>
            </memberProperty>
            <!-- property SupportsLastEnteredValues(string)  -->
            <memberMethod returnType="System.Boolean" name="SupportsLastEnteredValues">
              <attributes public="true"/>
              <parameters>
                <parameter type="System.String" name="controller"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <primitiveExpression value="false"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method SupportsCaching(ViewPage) -->
            <memberMethod returnType="System.Boolean" name="SupportsCaching">
              <attributes public="true"/>
              <parameters>
                <parameter type="ViewPage" name="page"/>
                <parameter type="System.String" name="viewType"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <argumentReferenceExpression name="viewType"/>
                      <primitiveExpression value="DataSheet"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <xsl:choose>
                      <xsl:when test="$Mobile='true'">
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="BooleanAnd">
                              <unaryOperatorExpression operator="Not">
                                <propertyReferenceExpression name="SupportsScrollingInDataSheet"/>
                              </unaryOperatorExpression>
                              <unaryOperatorExpression operator="Not">
                                <propertyReferenceExpression name="IsMobileClient">
                                  <typeReferenceExpression type="ApplicationServices"/>
                                </propertyReferenceExpression>
                              </unaryOperatorExpression>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="SupportsCaching">
                                <argumentReferenceExpression name="page"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="false"/>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                      </xsl:when>
                      <xsl:otherwise>
                        <conditionStatement>
                          <condition>
                            <unaryOperatorExpression operator="Not">
                              <propertyReferenceExpression name="SupportsScrollingInDataSheet"/>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <propertyReferenceExpression name="SupportsCaching">
                                <argumentReferenceExpression name="page"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="false"/>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                      </xsl:otherwise>
                    </xsl:choose>
                  </trueStatements>
                  <falseStatements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="ValueEquality">
                          <argumentReferenceExpression name="viewType"/>
                          <primitiveExpression value="Grid"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <xsl:choose>
                          <xsl:when test="$Mobile='true'">
                            <conditionStatement>
                              <condition>
                                <unaryOperatorExpression operator="Not">
                                  <propertyReferenceExpression name="IsMobileClient">
                                    <typeReferenceExpression type="ApplicationServices"/>
                                  </propertyReferenceExpression>
                                </unaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <propertyReferenceExpression name="SupportsCaching">
                                    <argumentReferenceExpression name="page"/>
                                  </propertyReferenceExpression>
                                  <primitiveExpression value="false"/>
                                </assignStatement>
                              </trueStatements>
                            </conditionStatement>
                          </xsl:when>
                          <xsl:otherwise>
                            <assignStatement>
                              <propertyReferenceExpression name="SupportsCaching">
                                <argumentReferenceExpression name="page"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="false"/>
                            </assignStatement>
                          </xsl:otherwise>
                        </xsl:choose>
                      </trueStatements>
                      <falseStatements>
                        <assignStatement>
                          <propertyReferenceExpression name="SupportsCaching">
                            <argumentReferenceExpression name="page"/>
                          </propertyReferenceExpression>
                          <primitiveExpression value="false"/>
                        </assignStatement>
                      </falseStatements>
                    </conditionStatement>
                  </falseStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <propertyReferenceExpression name="SupportsCaching">
                    <argumentReferenceExpression name="page"/>
                  </propertyReferenceExpression>
                </methodReturnStatement>
                <!--<xsl:choose>
                  <xsl:when test="$IsPremium='true'">
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanAnd">
                          <unaryOperatorExpression operator="Not">
                            <propertyReferenceExpression name="SupportsScrollingInDataSheet"/>
                          </unaryOperatorExpression>
                          <unaryOperatorExpression operator="Not">
                            <propertyReferenceExpression name="IsMobileClient">
                              <typeReferenceExpression type="ApplicationServices"/>
                            </propertyReferenceExpression>
                          </unaryOperatorExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <propertyReferenceExpression name="SupportsCaching">
                            <argumentReferenceExpression name="page"/>
                          </propertyReferenceExpression>
                          <primitiveExpression value="false"/>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                    <methodReturnStatement>
                      <propertyReferenceExpression name="SupportsCaching">
                        <argumentReferenceExpression name="page"/>
                      </propertyReferenceExpression>
                    </methodReturnStatement>
                  </xsl:when>
                  <xsl:otherwise>
                    <methodReturnStatement>
                      <primitiveExpression value="false"/>
                    </methodReturnStatement>
                  </xsl:otherwise>
                </xsl:choose>-->
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
        <!-- type ControllerFactory -->
        <typeDeclaration name="ControllerFactory">
          <members>
            <!-- method CreateDataController -->
            <memberMethod returnType="IDataController" name="CreateDataController">
              <attributes public="true" static="true"/>
              <statements>
                <methodReturnStatement>
                  <objectCreateExpression type="Controller"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method AutoCompleteManager -->
            <memberMethod returnType="IAutoCompleteManager" name="CreateAutoCompleteManager">
              <attributes public="true" static="true"/>
              <statements>
                <methodReturnStatement>
                  <objectCreateExpression type="Controller"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method CreateDataEngine -->
            <memberMethod returnType="IDataEngine" name="CreateDataEngine">
              <attributes public="true" static="true"/>
              <statements>
                <methodReturnStatement>
                  <objectCreateExpression type="Controller"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method GetDataControllerStream(Stream) -->
            <memberMethod returnType="Stream" name="GetDataControllerStream">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="controller"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="GetDataControllerStream">
                    <target>
                      <objectCreateExpression type="Controller"/>
                    </target>
                    <parameters>
                      <argumentReferenceExpression name="controller"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
        <!-- class StringEncryptor -->
        <typeDeclaration name="StringEncryptor" isPartial="true">
          <baseTypes>
            <typeReference type="StringEncryptorBase"/>
          </baseTypes>
        </typeDeclaration>
        <!-- class StringEncryptorBase -->
        <typeDeclaration name="StringEncryptorBase">
          <members>
            <xsl:if test="$IsUnlimited='true'">
              <!-- property Key -->
              <memberProperty type="System.Byte[]" name="Key">
                <attributes public="true"/>
                <getStatements>
                  <methodReturnStatement>
                    <arrayCreateExpression>
                      <createType type="System.Byte"/>
                      <initializers>
                        <primitiveExpression value="253"/>
                        <primitiveExpression value="124"/>
                        <primitiveExpression value="8"/>
                        <primitiveExpression value="201"/>
                        <primitiveExpression value="31"/>
                        <primitiveExpression value="27"/>
                        <primitiveExpression value="89"/>
                        <primitiveExpression value="189"/>
                        <primitiveExpression value="251"/>
                        <primitiveExpression value="47"/>
                        <primitiveExpression value="198"/>
                        <primitiveExpression value="241"/>
                        <primitiveExpression value="38"/>
                        <primitiveExpression value="78"/>
                        <primitiveExpression value="198"/>
                        <primitiveExpression value="193"/>
                        <primitiveExpression value="18"/>
                        <primitiveExpression value="179"/>
                        <primitiveExpression value="209"/>
                        <primitiveExpression value="220"/>
                        <primitiveExpression value="34"/>
                        <primitiveExpression value="84"/>
                        <primitiveExpression value="178"/>
                        <primitiveExpression value="99"/>
                        <primitiveExpression value="193"/>
                        <primitiveExpression value="84"/>
                        <primitiveExpression value="64"/>
                        <primitiveExpression value="15"/>
                        <primitiveExpression value="188"/>
                        <primitiveExpression value="98"/>
                        <primitiveExpression value="101"/>
                        <primitiveExpression value="153"/>
                      </initializers>
                    </arrayCreateExpression>
                  </methodReturnStatement>
                </getStatements>
              </memberProperty>
              <!-- property IV -->
              <memberProperty type="System.Byte[]" name="IV">
                <attributes public="true"/>
                <getStatements>
                  <methodReturnStatement>
                    <arrayCreateExpression>
                      <createType type="System.Byte"/>
                      <initializers>
                        <primitiveExpression value="87"/>
                        <primitiveExpression value="84"/>
                        <primitiveExpression value="163"/>
                        <primitiveExpression value="98"/>
                        <primitiveExpression value="205"/>
                        <primitiveExpression value="255"/>
                        <primitiveExpression value="139"/>
                        <primitiveExpression value="173"/>
                        <primitiveExpression value="16"/>
                        <primitiveExpression value="88"/>
                        <primitiveExpression value="88"/>
                        <primitiveExpression value="254"/>
                        <primitiveExpression value="133"/>
                        <primitiveExpression value="176"/>
                        <primitiveExpression value="55"/>
                        <primitiveExpression value="112"/>
                      </initializers>
                    </arrayCreateExpression>
                  </methodReturnStatement>
                </getStatements>
              </memberProperty>
            </xsl:if>
            <!-- method Encrypt(string) -->
            <memberMethod returnType="System.String" name="Encrypt">
              <attributes public="true"/>
              <parameters>
                <parameter type="System.String" name="s"/>
              </parameters>
              <statements>
                <xsl:choose>
                  <xsl:when test="$IsUnlimited='true'">
                    <variableDeclarationStatement type="System.Byte[]" name="plainText">
                      <init>
                        <methodInvokeExpression methodName="GetBytes">
                          <target>
                            <propertyReferenceExpression name="Default">
                              <typeReferenceExpression type="Encoding"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <stringFormatExpression format="{{0}}$${{1}}">
                              <argumentReferenceExpression name="s"/>
                              <methodInvokeExpression methodName="GetHashCode">
                                <target>
                                  <argumentReferenceExpression name="s"/>
                                </target>
                              </methodInvokeExpression>
                            </stringFormatExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="System.Byte[]" name="cipherText"/>
                    <usingStatement>
                      <variable type="MemoryStream" name="output">
                        <init>
                          <objectCreateExpression type="MemoryStream"/>
                        </init>
                      </variable>
                      <statements>
                        <usingStatement>
                          <variable type="Stream" name="cOutput">
                            <init>
                              <objectCreateExpression type="CryptoStream">
                                <parameters>
                                  <variableReferenceExpression name="output"/>
                                  <methodInvokeExpression methodName="CreateEncryptor">
                                    <target>
                                      <methodInvokeExpression methodName="Create">
                                        <target>
                                          <typeReferenceExpression type="Aes"/>
                                        </target>
                                      </methodInvokeExpression>
                                    </target>
                                    <parameters>
                                      <propertyReferenceExpression name="Key"/>
                                      <propertyReferenceExpression name="IV"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                  <propertyReferenceExpression name="Write">
                                    <typeReferenceExpression type="CryptoStreamMode"/>
                                  </propertyReferenceExpression>
                                </parameters>
                              </objectCreateExpression>
                            </init>
                          </variable>
                          <statements>
                            <methodInvokeExpression methodName="Write">
                              <target>
                                <typeReferenceExpression type="cOutput"/>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="plainText"/>
                                <primitiveExpression value="0"/>
                                <propertyReferenceExpression name="Length">
                                  <variableReferenceExpression name="plainText"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </statements>
                        </usingStatement>
                        <assignStatement>
                          <variableReferenceExpression name="cipherText"/>
                          <methodInvokeExpression methodName="ToArray">
                            <target>
                              <variableReferenceExpression name="output"/>
                            </target>
                          </methodInvokeExpression>
                        </assignStatement>
                      </statements>
                    </usingStatement>
                    <methodReturnStatement>
                      <methodInvokeExpression methodName="ToBase64String">
                        <target>
                          <typeReferenceExpression type="Convert"/>
                        </target>
                        <parameters>
                          <variableReferenceExpression name="cipherText"/>
                        </parameters>
                      </methodInvokeExpression>
                    </methodReturnStatement>
                  </xsl:when>
                  <xsl:otherwise>
                    <methodReturnStatement>
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
                              <argumentReferenceExpression name="s"/>
                            </parameters>
                          </methodInvokeExpression>
                        </parameters>
                      </methodInvokeExpression>
                    </methodReturnStatement>
                  </xsl:otherwise>
                </xsl:choose>
              </statements>
            </memberMethod>
            <!-- method Decrypt(string) -->
            <memberMethod returnType="System.String" name="Decrypt">
              <attributes public="true"/>
              <parameters>
                <parameter type="System.String" name="s"/>
              </parameters>
              <statements>
                <xsl:choose>
                  <xsl:when test="$IsUnlimited='true'">
                    <variableDeclarationStatement type="System.Byte[]" name="cipherText">
                      <init>
                        <methodInvokeExpression methodName="FromBase64String">
                          <target>
                            <typeReferenceExpression type="Convert"/>
                          </target>
                          <parameters>
                            <argumentReferenceExpression name="s"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="System.Byte[]" name="plainText"/>
                    <usingStatement>
                      <variable type="MemoryStream" name="output">
                        <init>
                          <objectCreateExpression type="MemoryStream"/>
                        </init>
                      </variable>
                      <statements>
                        <usingStatement>
                          <variable type="Stream" name="cOutput">
                            <init>
                              <objectCreateExpression type="CryptoStream">
                                <parameters>
                                  <variableReferenceExpression name="output"/>
                                  <methodInvokeExpression methodName="CreateDecryptor">
                                    <target>
                                      <methodInvokeExpression methodName="Create">
                                        <target>
                                          <typeReferenceExpression type="Aes"/>
                                        </target>
                                      </methodInvokeExpression>
                                    </target>
                                    <parameters>
                                      <propertyReferenceExpression name="Key"/>
                                      <propertyReferenceExpression name="IV"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                  <propertyReferenceExpression name="Write">
                                    <typeReferenceExpression type="CryptoStreamMode"/>
                                  </propertyReferenceExpression>
                                </parameters>
                              </objectCreateExpression>
                            </init>
                          </variable>
                          <statements>
                            <methodInvokeExpression methodName="Write">
                              <target>
                                <variableReferenceExpression name="cOutput"/>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="cipherText"/>
                                <primitiveExpression value="0"/>
                                <propertyReferenceExpression name="Length">
                                  <variableReferenceExpression name="cipherText"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </statements>
                        </usingStatement>
                        <assignStatement>
                          <variableReferenceExpression name="plainText"/>
                          <methodInvokeExpression methodName="ToArray">
                            <target>
                              <variableReferenceExpression name="output"/>
                            </target>
                          </methodInvokeExpression>
                        </assignStatement>
                      </statements>
                    </usingStatement>
                    <variableDeclarationStatement type="System.String" name="plain">
                      <init>
                        <methodInvokeExpression methodName="GetString">
                          <target>
                            <propertyReferenceExpression name="Default">
                              <typeReferenceExpression type="Encoding"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="plainText"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="System.String[]" name="parts">
                      <init>
                        <methodInvokeExpression methodName="Split">
                          <target>
                            <variableReferenceExpression name="plain"/>
                          </target>
                          <parameters>
                            <arrayCreateExpression>
                              <createType type="System.String"/>
                              <initializers>
                                <primitiveExpression value="$$"/>
                              </initializers>
                            </arrayCreateExpression>
                            <propertyReferenceExpression name="None">
                              <typeReferenceExpression type="StringSplitOptions"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanOr">
                          <binaryOperatorExpression operator="ValueInequality">
                            <propertyReferenceExpression name="Length">
                              <variableReferenceExpression name="parts"/>
                            </propertyReferenceExpression>
                            <primitiveExpression value="2"/>
                          </binaryOperatorExpression>
                          <binaryOperatorExpression operator="ValueInequality">
                            <methodInvokeExpression methodName="GetHashCode">
                              <target>
                                <arrayIndexerExpression>
                                  <target>
                                    <variableReferenceExpression name="parts"/>
                                  </target>
                                  <indices>
                                    <primitiveExpression value="0"/>
                                  </indices>
                                </arrayIndexerExpression>
                              </target>
                            </methodInvokeExpression>
                            <methodInvokeExpression methodName="ToInt32">
                              <target>
                                <typeReferenceExpression type="Convert"/>
                              </target>
                              <parameters>
                                <arrayIndexerExpression>
                                  <target>
                                    <variableReferenceExpression name="parts"/>
                                  </target>
                                  <indices>
                                    <primitiveExpression value="1"/>
                                  </indices>
                                </arrayIndexerExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </binaryOperatorExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <throwExceptionStatement>
                          <objectCreateExpression type="Exception">
                            <parameters>
                              <primitiveExpression value="Attempt to alter the hashed URL."/>
                            </parameters>
                          </objectCreateExpression>
                        </throwExceptionStatement>
                      </trueStatements>
                    </conditionStatement>
                    <methodReturnStatement>
                      <arrayIndexerExpression>
                        <target>
                          <variableReferenceExpression name="parts"/>
                        </target>
                        <indices>
                          <primitiveExpression value="0"/>
                        </indices>
                      </arrayIndexerExpression>
                    </methodReturnStatement>
                  </xsl:when>
                  <xsl:otherwise>
                    <methodReturnStatement>
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
                              <argumentReferenceExpression name="s"/>
                            </parameters>
                          </methodInvokeExpression>
                        </parameters>
                      </methodInvokeExpression>
                    </methodReturnStatement>
                  </xsl:otherwise>
                </xsl:choose>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
      </types>
    </compileUnit>
  </xsl:template>

  <xsl:template name="ExecuteCommand">
    <conditionStatement>
      <condition>
        <methodInvokeExpression methodName="ConfigureCommand">
          <parameters>
            <variableReferenceExpression name="command"/>
            <primitiveExpression value="null"/>
            <propertyReferenceExpression name="SqlCommandType">
              <variableReferenceExpression name="args"/>
            </propertyReferenceExpression>
            <propertyReferenceExpression name="Values">
              <variableReferenceExpression name="args"/>
            </propertyReferenceExpression>
          </parameters>
        </methodInvokeExpression>
      </condition>
      <trueStatements>
        <assignStatement>
          <propertyReferenceExpression name="RowsAffected">
            <variableReferenceExpression name="result"/>
          </propertyReferenceExpression>
          <methodInvokeExpression methodName="ExecuteNonQuery">
            <target>
              <typeReferenceExpression type="TransactionManager"/>
            </target>
            <parameters>
              <argumentReferenceExpression name="args"/>
              <variableReferenceExpression name="result"/>
              <methodInvokeExpression methodName="CreateViewPage"/>
              <variableReferenceExpression name="command"/>
            </parameters>
          </methodInvokeExpression>
        </assignStatement>
        <conditionStatement>
          <condition>
            <binaryOperatorExpression operator="ValueEquality">
              <propertyReferenceExpression name="RowsAffected">
                <variableReferenceExpression name="result"/>
              </propertyReferenceExpression>
              <primitiveExpression value="0"/>
            </binaryOperatorExpression>
          </condition>
          <trueStatements>
            <assignStatement>
              <propertyReferenceExpression name="RowNotFound">
                <variableReferenceExpression name="result"/>
              </propertyReferenceExpression>
              <primitiveExpression value="true"/>
            </assignStatement>
            <methodInvokeExpression methodName="Add">
              <target>
                <propertyReferenceExpression name="Errors">
                  <variableReferenceExpression name="result"/>
                </propertyReferenceExpression>
              </target>
              <parameters>
                <methodInvokeExpression methodName="Replace">
                  <target>
                    <typeReferenceExpression type="Localizer"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="RecordChangedByAnotherUser"/>
                    <primitiveExpression value="The record has been changed by another user."/>
                  </parameters>
                </methodInvokeExpression>
              </parameters>
            </methodInvokeExpression>
          </trueStatements>
          <falseStatements>
            <methodInvokeExpression methodName="ExecutePostActionCommands">
              <parameters>
                <argumentReferenceExpression name="args"/>
                <variableReferenceExpression name="result"/>
                <variableReferenceExpression name="connection"/>
              </parameters>
            </methodInvokeExpression>
          </falseStatements>
        </conditionStatement>
      </trueStatements>
    </conditionStatement>
    <conditionStatement>
      <condition>
        <binaryOperatorExpression operator="IdentityInequality">
          <variableReferenceExpression name="handler"/>
          <primitiveExpression value="null"/>
        </binaryOperatorExpression>
      </condition>
      <trueStatements>
        <methodInvokeExpression methodName="AfterSqlAction">
          <target>
            <variableReferenceExpression name="handler"/>
          </target>
          <parameters>
            <argumentReferenceExpression name="args"/>
            <variableReferenceExpression name="result"/>
          </parameters>
        </methodInvokeExpression>
      </trueStatements>
      <falseStatements>
        <methodInvokeExpression methodName="ExecuteServerRules">
          <target>
            <fieldReferenceExpression name="serverRules"/>
          </target>
          <parameters>
            <argumentReferenceExpression name="args"/>
            <argumentReferenceExpression name="result"/>
            <propertyReferenceExpression name="After">
              <typeReferenceExpression type="ActionPhase"/>
            </propertyReferenceExpression>
          </parameters>
        </methodInvokeExpression>
      </falseStatements>
    </conditionStatement>
    <conditionStatement>
      <condition>
        <binaryOperatorExpression operator="IdentityInequality">
          <propertyReferenceExpression name="PlugIn">
            <fieldReferenceExpression name="config"/>
          </propertyReferenceExpression>
          <primitiveExpression value="null"/>
        </binaryOperatorExpression>
      </condition>
      <trueStatements>
        <methodInvokeExpression methodName="ProcessArguments">
          <target>
            <propertyReferenceExpression name="PlugIn">
              <fieldReferenceExpression name="config"/>
            </propertyReferenceExpression>
          </target>
          <parameters>
            <argumentReferenceExpression name="args"/>
            <variableReferenceExpression name="result"/>
            <methodInvokeExpression methodName="CreateViewPage"/>
          </parameters>
        </methodInvokeExpression>
      </trueStatements>
    </conditionStatement>
  </xsl:template>
</xsl:stylesheet>
