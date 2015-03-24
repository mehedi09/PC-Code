<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:codedom="http://www.codeontime.com/2008/codedom-compiler"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:ontime="urn:schemas-codeontime-com:xslt"
    xmlns:bo="urn:schemas-codeontime-com:business-objects"
    xmlns:asp="urn:asp.net">
  <xsl:include href="..\_System\BusinessObjectUtilities.xslt"/>
  <xsl:output method="text" indent="yes"/>
  <xsl:param name="ProviderName"/>
  <xsl:param name="ProcedureNamePrefix" />
  <xsl:variable name="ParameterMarker" select="/bo:businessObjectCollection/@parameterMarker"/>


  <xsl:template match="bo:businessObject">
    <xsl:variable name="Fields" select="bo:fields/bo:field"/>
    <xsl:variable name="ProcedureName">
      <xsl:value-of select="@nativeSchema"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="$ProcedureNamePrefix"/>
      <xsl:choose>
        <xsl:when test="starts-with(@name, concat(@nativeSchema, '_'))">
          <xsl:value-of select="substring-after(@name, concat(@nativeSchema, '_'))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="@name"/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:text>_Update</xsl:text>
    </xsl:variable>
    <xsl:text>if exists (select * from sys.objects where object_id = OBJECT_ID(N'</xsl:text>
    <xsl:value-of select="$ProcedureName"/>
    <xsl:text>') and type in (N'P', N'PC'))&#13;&#10;&#9;drop procedure </xsl:text>
    <xsl:value-of select="$ProcedureName"/>
    <xsl:text>
go

</xsl:text>
    <xsl:text>create procedure </xsl:text>
    <xsl:value-of select="$ProcedureName"/>
    <xsl:text>(</xsl:text>

    <xsl:variable name="UpdateFields" select="$Fields[not(@readOnly='true' or @onDemand='true') or @isPrimaryKey='true']"/>
    <xsl:if test="$UpdateFields">
      <xsl:for-each select="$UpdateFields">
        <xsl:text>&#13;&#10;&#9;</xsl:text>
        <xsl:value-of select="$ParameterMarker"/>
        <xsl:value-of select="@name"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="@nativeDataType"/>
        <xsl:if test="count($UpdateFields)>1 and position() != last()">
          <xsl:text>,</xsl:text>
        </xsl:if>
      </xsl:for-each>
      <xsl:text>
</xsl:text>
    </xsl:if>
    <xsl:text>)
as
set nocount on
</xsl:text>
    <xsl:call-template name="SqlHelper_GenerateUpdate">
      <xsl:with-param name="ProviderName" select="$ProviderName"/>
    </xsl:call-template>
    <xsl:text>
go

</xsl:text>
  </xsl:template>

</xsl:stylesheet>
