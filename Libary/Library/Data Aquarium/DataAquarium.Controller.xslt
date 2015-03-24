<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns="urn:schemas-codeontime-com:data-aquarium" xmlns:a="urn:schemas-codeontime-com:data-aquarium"
    exclude-result-prefixes="msxsl a"
>
	<xsl:output method="xml" indent="yes" cdata-section-elements="text statusBar description data rule"/>
	<xsl:param name="Namespace"/>
	<xsl:param name="AnnotationsEnabled" select="'false'"/>
	<xsl:param name="FloatingEnabled" select="'false'"/>
	<xsl:param name="NewColumnEnabled" select="'false'"/>

	<xsl:template match="a:dataController" >
		<dataController>
			<xsl:apply-templates select="@*[name()='name' or name()='conflictDetection' or name()='label' or name() ='connectionStringName']"/>
			<xsl:if test="@allowAnnotations='true' or ($AnnotationsEnabled='true' and not(@allowAnnotations='false'))">
				<xsl:attribute name="plugIn">
					<xsl:value-of select="$Namespace"/>
					<xsl:text>.Data.AnnotationPlugIn</xsl:text>
				</xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="string-length(@handler)&gt;0">
					<xsl:attribute name="handler">
						<xsl:if test="not(contains(@handler, '.'))">
							<xsl:value-of select="$Namespace"/>
							<xsl:text>.Rules.</xsl:text>
						</xsl:if>
						<xsl:value-of select="@handler"/>
					</xsl:attribute>
				</xsl:when>
				<xsl:when test="a:fields/a:field[a:codeFormula!='' or a:codeDefault!='' or string-length(a:codeValue)>0 or a:items/@targetController!=''] or .//a:dataField[a:codeFilter[.!='' and @operator!='']] or a:views/a:view[@virtualViewId!='' and a:overrideWhen!=''] or a:businessRules/a:rule[@type='Code']">
					<xsl:attribute name="handler">
						<xsl:value-of select="$Namespace"/>
						<xsl:text>.Rules.</xsl:text>
						<xsl:value-of select="@name"/>
						<xsl:text>BusinessRules</xsl:text>
					</xsl:attribute>
				</xsl:when>
			</xsl:choose>
			<xsl:apply-templates select="node()"/>
		</dataController>
	</xsl:template>

  <xsl:template match="a:codeValue"/>
  <xsl:template match="a:codeDefault"/>
  <xsl:template match="a:codeFormula"/>

	<xsl:template match="a:category">
		<category>
			<xsl:apply-templates select="@*[name()!='newColumn' and name() !='floating']"/>
			<xsl:choose>
				<xsl:when test="$FloatingEnabled='true' and not(@floating='false')">
					<xsl:attribute name="floating">
						<xsl:text>true</xsl:text>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="@floating">
						<xsl:attribute name="floating">
							<xsl:value-of select="@floating"/>
						</xsl:attribute>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="$NewColumnEnabled='true' and not(@newColumn='false') and not(preceding-sibling::a:category)">
					<xsl:attribute name="newColumn">
						<xsl:text>true</xsl:text>
					</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:if test="@newColumn">
						<xsl:attribute name="newColumn">
							<xsl:value-of select="@newColumn"/>
						</xsl:attribute>
					</xsl:if>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="a:*"/>
		</category>
	</xsl:template>

	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
