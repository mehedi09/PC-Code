<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:config="http://www.codeontime.com/2008/codedom-configuration"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:app="urn:schemas-codeontime-com:data-aquarium-application"
    exclude-result-prefixes="msxsl app"
>
  <xsl:param name="Namespace"/>
  <xsl:param name="Name"/>
  <xsl:output method="text" encoding="utf-8"/>
  <xsl:variable name="Provider" select="document('../../../_Config/CodeOnTime.CodeDom.xml')//config:provider[@name=parent::config:providers/@default]"/>

  <xsl:template match="/">


    <!-- <%@ Assembly Name="$SharePoint.Project.AssemblyFullName$" %> -->
    <xsl:text>&lt;%@ Assembly Name="$SharePoint.Project.AssemblyFullName$" %&gt;
</xsl:text>
    <!-- <%@ Assembly Name="Microsoft.Web.CommandUI, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> -->
    <!-- <%@ Register TagPrefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls"
    Assembly="Microsoft.SharePoint, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> -->
    <!-- <%@ Register TagPrefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> -->
    <!-- <%@ Register TagPrefix="asp" Namespace="System.Web.UI" Assembly="System.Web.Extensions, Version=3.5.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" %> -->
    <!-- <%@ Import Namespace="Microsoft.SharePoint" %> -->
    <!-- <%@ Register TagPrefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages"
    Assembly="Microsoft.SharePoint, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %> -->
    <!-- <%@ Control Language="C#" AutoEventWireup="true" CodeBehind="VisualWebPart1UserControl.ascx.cs"
    Inherits="VisualWebPartHost.VisualWebPart1.VisualWebPart1UserControl" %> -->
    <xsl:text>&lt;%@ Control Language="</xsl:text>
    <xsl:value-of select="$Provider/@language"/>
    <xsl:text>" AutoEventWireup="</xsl:text>
    <xsl:value-of select="$Provider/@autoEventWireup"/>
    <xsl:text>" CodeFile="DefaultUserControl.ascx</xsl:text>
    <xsl:value-of select="$Provider/@extension"/>
    <xsl:text>" Inherits="DefaultUserControl"  %&gt;
</xsl:text>
    <!-- <%@ Register TagPrefix="act" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit" %> --><!--
    <xsl:text>&lt;%@ Register TagPrefix="act" Namespace="AjaxControlToolkit" Assembly="AjaxControlToolkit"  %&gt;
</xsl:text>
    --><!-- <%@ Register TagPrefix="aquarium" Namespace="MyCompany.Web" Assembly="MyCompany" %> --><!--
    <xsl:text>&lt;%@ Register TagPrefix="aquarium" Namespace="</xsl:text>
    <xsl:value-of select="$Namespace"/>
    <xsl:text>.Web" Assembly="</xsl:text>
    <xsl:value-of select="$Namespace"/>
    <xsl:text>"  %&gt;
</xsl:text>-->
  </xsl:template>
</xsl:stylesheet>
