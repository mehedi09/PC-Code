<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.codeontime.com/2008/codedom-compiler"  xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl a"
>
	<xsl:output method="xml" indent="yes"/>
  <xsl:param name="Namespace"/>

	<xsl:template match="/">

		<compileUnit namespace="{$Namespace}.WebApp">
			<imports>
				<namespaceImport name="System"/>
				<namespaceImport name="System.Collections.Generic"/>
				<namespaceImport name="System.Web.Configuration"/>
				<namespaceImport name="System.Data"/>
				<namespaceImport name="System.Linq"/>
				<namespaceImport name="System.Text"/>
				<namespaceImport name="System.Web"/>
				<namespaceImport name="System.Web.Security"/>
				<namespaceImport name="System.Web.UI"/>
				<namespaceImport name="System.Web.UI.HtmlControls"/>
				<namespaceImport name="System.Web.UI.WebControls"/>
				<namespaceImport name="System.Web.UI.WebControls.WebParts"/>
				<namespaceImport name="System.Xml.Linq"/>
        <namespaceImport name="{$Namespace}.Data"/>
			</imports>
			<types>
				<!-- class Start -->
				<typeDeclaration name="Start" isPartial="true">
					<baseTypes>
						<typeReference type="System.Web.UI.Page"/>
					</baseTypes>
					<members>
            <!-- property PageHost -->
            <memberProperty type="Host" name="PageHost">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <castExpression targetType="Host">
                    <propertyReferenceExpression name="Master">
                      <thisReferenceExpression/>
                    </propertyReferenceExpression>
                  </castExpression>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- method OnInit(object, EventArgs) -->
            <memberMethod name="OnInit">
              <attributes family="true" override="true"/>
              <parameters>
                <parameter type="EventArgs" name="e"/>
              </parameters>
              <statements>
                <methodInvokeExpression methodName="OnInit">
                  <target>
                    <baseReferenceExpression/>
                  </target>
                  <parameters>
                    <argumentReferenceExpression name="e"/>
                  </parameters>
                </methodInvokeExpression>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="Not">
                      <propertyReferenceExpression name="IsInAsyncPostBack">
                        <methodInvokeExpression methodName="GetCurrent">
                          <target>
                            <typeReferenceExpression type="ScriptManager"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="Page"/>
                          </parameters>
                        </methodInvokeExpression>
                      </propertyReferenceExpression>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="Control" name="pageControl">
                      <init>
                        <methodInvokeExpression methodName="LoadPageControl">
                          <target>
                            <typeReferenceExpression type="{$Namespace}.Web.ControlBase"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="PagePlaceholder"/>
                            <propertyReferenceExpression name="CurrentPage">
                              <propertyReferenceExpression name="PageHost"/>
                            </propertyReferenceExpression>
                            <primitiveExpression value="true"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <assignStatement>
                      <propertyReferenceExpression name="SettingsMode">
                        <propertyReferenceExpression name="PageHost"/>
                      </propertyReferenceExpression>
                      <binaryOperatorExpression operator="IdentityEquality">
                        <variableReferenceExpression name="pageControl"/>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method Page_Load(object, EventArgs) -->
						<memberMethod name="Page_Load">
							<attributes family="true" final="true"/>
							<parameters>
								<parameter type="System.Object" name="sender"/>
								<parameter type="EventArgs" name="e"/>
							</parameters>
						</memberMethod>
					</members>
				</typeDeclaration>
			</types>
		</compileUnit>
	</xsl:template>
</xsl:stylesheet>
