<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.codeontime.com/2008/codedom-compiler"  xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" 
    xmlns:ontime="urn:schemas-codeontime-com:xslt"
 	  exclude-result-prefixes="msxsl a ontime"
>
	<xsl:output method="xml" indent="yes"/>
	<xsl:param name="Namespace"/>
	<xsl:param name="ProjectPath"/>
	<xsl:param name="MembershipEnabled" select="'false'"/>
	<xsl:param name="Theme" select="'Aquarium'"/>

	<msxsl:script language="CSharp" implements-prefix="ontime">
		<![CDATA[
        public string ReplaceThemeProjectName(string projectPath, string projectNamespace)
        {
					foreach (string filename in System.IO.Directory.GetFiles(System.IO.Path.Combine(projectPath, projectNamespace + "\\Theme"), "*.css"))
					{
						string theme = System.IO.File.ReadAllText(filename);
						System.IO.File.WriteAllText(filename,
							System.Text.RegularExpressions.Regex.Replace(theme, @"DAF\.", projectNamespace + "."));
				  }
					return String.Empty;
        }
		]]>
	</msxsl:script>

	<xsl:variable name="Dummy" select="ontime:ReplaceThemeProjectName($ProjectPath, $Namespace)"/>

	<xsl:template match="fileSystem">
		<compileUnit>
			<imports>
				<namespaceImport name="System.Reflection"/>
				<namespaceImport name="System.Runtime.CompilerServices"/>
				<namespaceImport name="System.Runtime.InteropServices"/>
				<namespaceImport name="System.Web.UI"/>
			</imports>
			<types>
				<!-- class SqlStatement -->
				<typeDeclaration name="Assembly">
					<customAttributes>
						<customAttribute type="AssemblyTitle">
							<arguments>
								<primitiveExpression value="{$Namespace}"/>
							</arguments>
						</customAttribute>
						<customAttribute type="AssemblyDescription">
							<arguments>
								<primitiveExpression value="Data Aquarium Framework application library"/>
							</arguments>
						</customAttribute>
						<customAttribute type="AssemblyCompany">
							<arguments>
								<primitiveExpression value="{$Namespace}"/>
							</arguments>
						</customAttribute>
						<customAttribute type="AssemblyProduct">
							<arguments>
								<primitiveExpression value="{$Namespace} Aquarium in the Box"/>
							</arguments>
						</customAttribute>
						<customAttribute type="AssemblyCopyright">
							<arguments>
								<primitiveExpression value="Copyright © {$Namespace} 2010"/>
							</arguments>
						</customAttribute>
						<customAttribute type="ComVisible">
							<arguments>
								<primitiveExpression value="false"/>
							</arguments>
						</customAttribute>
						<customAttribute type="AssemblyVersion">
							<arguments>
								<primitiveExpression value="1.0.*" convertTo="String"/>
							</arguments>
						</customAttribute>
						<customAttribute type="AssemblyFileVersion">
							<arguments>
								<primitiveExpression value="1.0.0.0" convertTo="String"/>
							</arguments>
						</customAttribute>
						<customAttribute type="WebResource">
							<arguments>
								<primitiveExpression value="{$Namespace}.Scripts.Web.DataView.js"/>
								<primitiveExpression value="text/javascript"/>
							</arguments>
						</customAttribute>
						<customAttribute type="WebResource">
							<arguments>
								<primitiveExpression value="{$Namespace}.Scripts.Web.DataViewResources.js"/>
								<primitiveExpression value="text/javascript"/>
							</arguments>
						</customAttribute>
						<customAttribute type="WebResource">
							<arguments>
								<primitiveExpression value="{$Namespace}.Scripts.Web.Menu.js"/>
								<primitiveExpression value="text/javascript"/>
							</arguments>
						</customAttribute>
						<xsl:if test="$MembershipEnabled='true'">
							<customAttribute type="WebResource">
								<arguments>
									<primitiveExpression value="{$Namespace}.Scripts.Web.MembershipResources.js"/>
									<primitiveExpression value="text/javascript"/>
								</arguments>
							</customAttribute>
							<customAttribute type="WebResource">
								<arguments>
									<primitiveExpression value="{$Namespace}.Scripts.Web.Membership.js"/>
									<primitiveExpression value="text/javascript"/>
								</arguments>
							</customAttribute>
							<customAttribute type="WebResource">
								<arguments>
									<primitiveExpression value="{$Namespace}.Scripts.Web.MembershipManager.js"/>
									<primitiveExpression value="text/javascript"/>
								</arguments>
							</customAttribute>
							<!--<customAttribute name="WebResource">
								<arguments>
									<primitiveExpression value="{$Namespace}.Theme.Membership.css"/>
									<primitiveExpression value="text/css"/>
									<attributeArgument name="PerformSubstitution">
										<primitiveExpression value="true"/>
									</attributeArgument>
								</arguments>
							</customAttribute>-->
						</xsl:if>
						<customAttribute name="WebResource">
							<arguments>
								<primitiveExpression value="{$Namespace}.Theme.{$Theme}.css"/>
								<primitiveExpression value="text/css"/>
								<attributeArgument name="PerformSubstitution">
									<primitiveExpression value="true"/>
								</attributeArgument>
							</arguments>
						</customAttribute>
						<xsl:for-each select="file[not(contains(@name, '.css'))]">
							<customAttribute name="WebResource">
								<arguments>
									<primitiveExpression value="{$Namespace}.Theme.{@name}"/>
									<primitiveExpression value="image/{substring-after(@name,'.')}"/>
								</arguments>
							</customAttribute>
						</xsl:for-each>
					</customAttributes>
				</typeDeclaration>
			</types>
		</compileUnit>
	</xsl:template>

</xsl:stylesheet>
