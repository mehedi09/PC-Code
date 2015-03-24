<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:codedom="http://www.codeontime.com/2008/codedom-compiler"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		xmlns:c="urn:schemas-codeontime-com:data-aquarium"
	  xmlns:asp="urn:asp.net"
		xmlns:aquarium="urn:data-aquarium"
		xmlns:act="urn:AjaxControlToolkit"
	  >
	<xsl:output method="html" indent="yes"/>
	<xsl:param name="Namespace"/>
	<xsl:param name="MembershipEnabled" select="'false'"/>

	<xsl:template match="/">
		<xsl:variable name="SelectedController">
			<xsl:for-each select="/c:dataControllerCollection/c:dataController[not(@generate='false')]">
				<xsl:sort select="count(c:fields/c:field)" data-type="number" order="descending"/>
				<xsl:if test="position()=1">
					<xsl:value-of select="@name"/>
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>

		<html xmlns="http://www.w3.org/1999/xhtml">
			<head runat="server">
				<title>Sandbox</title>

				<script runat="server">
					<xsl:call-template name="GenerateMembers"/>
				</script>

			</head>
			<body style="margin:0px;">
				<form id="form1" runat="server">
					<div style="padding:8px">
						<act:ToolkitScriptManager ID="sm1" runat="server" ScriptMode="Release" />
						<xsl:if test="$MembershipEnabled='true'">
							<aquarium:MembershipBar id="mb" runat="server"/>
							<div style="padding: 12px 0px 12px 0px">
								<div style="margin-bottom: 12px;">
									Two standard user accounts are <b title="User Name: user">user</b> / <b title="Password: user123%">
										user123%
									</b> and <b title="User Name: admin">admin</b> / <b title="Password: admin123%">
										admin123%
									</b>.
								</div>
								<span style="font-weight: bold;">Controllers</span> | <a href="Membership.aspx" title="You must be signed-in as 'admin' to access membership manager.">
									Membership
								</a>
							</div>
						</xsl:if>
						<asp:DropDownList ID="ControllerDropDown" runat="server" AutoPostBack="true" Font-Names="Tahoma"
								Style="margin-bottom: 8px" Font-Size="8.5pt">
							<xsl:for-each select="/c:dataControllerCollection/c:dataController[not(@generate='false')]">
								<asp:ListItem Text="{@name}" Value="{@name}">
									<xsl:if test="@name=$SelectedController">
										<xsl:attribute name="Selected">
											<xsl:text>true</xsl:text>
										</xsl:attribute>
									</xsl:if>
								</asp:ListItem>
							</xsl:for-each>
						</asp:DropDownList>
						<div id="Div1" runat="server">
						</div>
						<aquarium:DataViewExtender ID="Extender1" runat="server" TargetControlID="Div1" />
					</div>
				</form>
			</body>
		</html>
	</xsl:template>
	<xsl:template name="GenerateMembers">
		<memberMethod xmlns="http://www.codeontime.com/2008/codedom-compiler" name="Page_Load">
			<attributes family="true"  final="true"/>
			<parameters>
				<parameter type="System.Object" name="sender"/>
				<parameter type="EventArgs" name="e"/>
			</parameters>
			<statements>
				<assignStatement>
					<propertyReferenceExpression name="Controller">
						<propertyReferenceExpression name="Extender1"/>
					</propertyReferenceExpression>
					<propertyReferenceExpression name="SelectedValue">
						<propertyReferenceExpression name="ControllerDropDown"/>
					</propertyReferenceExpression>
				</assignStatement>
			</statements>
		</memberMethod>
	</xsl:template>

</xsl:stylesheet>
