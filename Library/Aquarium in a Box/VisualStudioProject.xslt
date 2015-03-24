<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		xmlns="http://schemas.microsoft.com/developer/msbuild/2003"
    xmlns:ontime="urn:schemas-codeontime-com:xslt"
	  exclude-result-prefixes="msxsl ontime"
>
	<xsl:output method="xml" indent="yes"/>
	<xsl:param name="ProjectName"/>
	<xsl:param name="ProjectExtension"/>
	<xsl:param name="CodedomProviderName"/>
	<xsl:param name="Reference1"/>
	<xsl:param name="Reference1Guid"/>
	<xsl:param name="ReportsEnabled" select="'false'"/>

	<msxsl:script language="CSharp" implements-prefix="ontime">
		<![CDATA[
        public string Guid()
        {
					return System.Guid.NewGuid().ToString().ToUpper();
        }
		]]>
	</msxsl:script>


	<xsl:template match="fileSystem">
		<Project ToolsVersion="3.5" DefaultTargets="Build">
			<PropertyGroup>
				<Configuration Condition=" '$(Configuration)' == '' ">Debug</Configuration>
				<Platform Condition=" '$(Platform)' == '' ">AnyCPU</Platform>
				<ProductVersion>9.0.30729</ProductVersion>
				<SchemaVersion>2.0</SchemaVersion>
				<ProjectGuid>
					<xsl:value-of select="concat('{', ontime:Guid(), '}')"/>
				</ProjectGuid>
				<xsl:if test="$Reference1">
					<xsl:choose>
						<xsl:when test="$CodedomProviderName='CSharp'">
							<ProjectTypeGuids>{349c5851-65df-11da-9384-00065b846f21};{fae04ec0-301f-11d3-bf4b-00c04f79efbc}</ProjectTypeGuids>
						</xsl:when>
						<xsl:otherwise>
							<ProjectTypeGuids>{349c5851-65df-11da-9384-00065b846f21};{F184B08F-C81C-45F6-A57F-5ABD9991F28F}</ProjectTypeGuids>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:if>
				<OutputType>Library</OutputType>
				<xsl:if test="$CodedomProviderName='CSharp'">
					<AppDesignerFolder>Properties</AppDesignerFolder>
				</xsl:if>
				<RootNamespace>
					<xsl:value-of select="$ProjectName"/>
				</RootNamespace>
				<AssemblyName>
					<xsl:value-of select="$ProjectName"/>
				</AssemblyName>
				<TargetFrameworkVersion>v3.5</TargetFrameworkVersion>
				<FileAlignment>512</FileAlignment>
				<xsl:if test="$CodedomProviderName='VisualBasic'">
					<OptionExplicit>On</OptionExplicit>
					<OptionCompare>Binary</OptionCompare>
					<OptionStrict>Off</OptionStrict>
					<OptionInfer>On</OptionInfer>
				</xsl:if>
			</PropertyGroup>
			<xsl:choose>
				<xsl:when test="$CodedomProviderName='VisualBasic'">
					<PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|AnyCPU' ">
						<DebugSymbols>true</DebugSymbols>
						<DebugType>full</DebugType>
						<DefineDebug>true</DefineDebug>
						<DefineTrace>true</DefineTrace>
						<OutputPath>
							<xsl:choose>
								<xsl:when test="$Reference1">
									<xsl:text>bin\</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>bin\Debug</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</OutputPath>
						<NoWarn>42016,41999,42017,42018,42019,42032,42036,42020,42021,42022</NoWarn>
					</PropertyGroup>
					<PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Release|AnyCPU' ">
						<DebugType>pdbonly</DebugType>
						<DefineDebug>false</DefineDebug>
						<DefineTrace>true</DefineTrace>
						<Optimize>true</Optimize>
						<OutputPath>
							<xsl:choose>
								<xsl:when test="$Reference1">
									<xsl:text>bin\</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>bin\release</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</OutputPath>
						<NoWarn>42016,41999,42017,42018,42019,42032,42036,42020,42021,42022</NoWarn>
					</PropertyGroup>
					<ItemGroup>
						<Import Include="Microsoft.VisualBasic" />
						<Import Include="System" />
						<Import Include="System.Collections" />
						<Import Include="System.Collections.Generic" />
						<Import Include="System.Diagnostics" />
						<Import Include="System.Web" />
						<Import Include="System.Web.UI" />
						<Import Include="System.Web.UI.WebControls" />
						<Import Include="System.Web.UI.WebControls.WebParts" />
						<Import Include="System.Web.UI.HtmlControls" />
						<Import Include="System.Linq" />
						<Import Include="System.Xml.Linq" />
					</ItemGroup>
				</xsl:when>
				<xsl:otherwise>
					<PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|AnyCPU' ">
						<DebugSymbols>true</DebugSymbols>
						<DebugType>full</DebugType>
						<Optimize>false</Optimize>
						<OutputPath>
							<xsl:choose>
								<xsl:when test="$Reference1">
									<xsl:text>bin\</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>bin\Debug</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</OutputPath>
						<DefineConstants>DEBUG;TRACE</DefineConstants>
						<ErrorReport>prompt</ErrorReport>
						<WarningLevel>4</WarningLevel>
					</PropertyGroup>
					<PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Release|AnyCPU' ">
						<DebugType>pdbonly</DebugType>
						<Optimize>true</Optimize>
						<OutputPath>
							<xsl:choose>
								<xsl:when test="$Reference1">
									<xsl:text>bin\</xsl:text>
								</xsl:when>
								<xsl:otherwise>
									<xsl:text>bin\Debug</xsl:text>
								</xsl:otherwise>
							</xsl:choose>
						</OutputPath>
						<DefineConstants>TRACE</DefineConstants>
						<ErrorReport>prompt</ErrorReport>
						<WarningLevel>4</WarningLevel>
					</PropertyGroup>
				</xsl:otherwise>
			</xsl:choose>
			<ItemGroup>
				<Reference Include="AjaxControlToolkit, Version=3.0.30930.28736, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e, processorArchitecture=MSIL">
					<SpecificVersion>False</SpecificVersion>
					<HintPath>..\AjaxControlToolkit\AjaxControlToolkit.dll</HintPath>
				</Reference>
				<xsl:if test="$ReportsEnabled='true'">
					<Reference Include="Microsoft.ReportViewer.Common, Version=9.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a, processorArchitecture=MSIL" />
					<Reference Include="Microsoft.ReportViewer.WebForms, Version=9.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a, processorArchitecture=MSIL" />
				</xsl:if>
				<Reference Include="System" />
				<Reference Include="System.configuration" />
				<Reference Include="System.Core">
					<RequiredTargetFramework>3.5</RequiredTargetFramework>
				</Reference>
				<Reference Include="System.Data" />
				<Reference Include="System.Data.DataSetExtensions">
					<RequiredTargetFramework>3.5</RequiredTargetFramework>
				</Reference>
				<Reference Include="System.Design" />
				<Reference Include="System.Web.Extensions">
					<RequiredTargetFramework>3.5</RequiredTargetFramework>
				</Reference>
        <Reference Include="System.Transactions" />
        <Reference Include="System.Web.Services" />
				<Reference Include="System.XML" />
				<Reference Include="System.Xml.Linq">
					<RequiredTargetFramework>3.5</RequiredTargetFramework>
				</Reference>
				<Reference Include="System.Drawing" />
				<Reference Include="System.Web" />
			</ItemGroup>
			<xsl:if test="$Reference1">
				<ItemGroup>
					<ProjectReference Include="..\MyCompany\{$Reference1}.{$ProjectExtension}">
						<Project>
							<xsl:value-of select="$Reference1Guid"/>
						</Project>
						<Name>
							<xsl:value-of select="$Reference1"/>
						</Name>

					</ProjectReference>
				</ItemGroup>
			</xsl:if>
			<ItemGroup>
				<xsl:for-each select="//file[contains(@name, '.asmx') or contains(@name, '.aspx') or contains(@name, '.config') or contains(@name, '.asax') or contains(@name, '.master')]">
					<Content Include="{@path}"/>
				</xsl:for-each>
			</ItemGroup>
			<ItemGroup>
				<xsl:for-each select="folder[@name='Data']//file">
					<Compile Include="{@path}" />
				</xsl:for-each>
			</ItemGroup>
			<ItemGroup>
				<xsl:for-each select="folder[@name='Web']/file">
					<Compile Include="{@path}" />
				</xsl:for-each>
			</ItemGroup>
			<ItemGroup>
				<xsl:for-each select="folder[@name='Security']/file">
					<Compile Include="{@path}" />
				</xsl:for-each>
			</ItemGroup>
			<ItemGroup>
				<xsl:for-each select="folder[@name='Services']/file">
					<Compile Include="{@path}" />
				</xsl:for-each>
			</ItemGroup>
			<ItemGroup>
				<xsl:for-each select="//file[contains(@name, 'AssemblyInfo') and not(contains(@name,'codedom.xml'))]">
					<Compile Include="{@path}" />
				</xsl:for-each>
			</ItemGroup>
			<ItemGroup>
				<xsl:for-each select="//file[contains(@name, '.xsd')]">
					<None Include="{@path}" />
				</xsl:for-each>
				<xsl:for-each select="folder[@name='Controllers']/file[not(contains(@name, '.xsd'))]">
					<EmbeddedResource Include="{@path}" />
				</xsl:for-each>
			</ItemGroup>
			<ItemGroup>
				<xsl:for-each select="folder[@name='Handlers']/file">
					<Compile Include="{@path}" />
				</xsl:for-each>
			</ItemGroup>
			<ItemGroup>
				<xsl:for-each select="folder[@name='Scripts']/file">
					<EmbeddedResource Include="{@path}" />
				</xsl:for-each>
			</ItemGroup>
			<ItemGroup>
				<xsl:for-each select="folder[@name='Theme']/file">
					<EmbeddedResource Include="{@path}" />
				</xsl:for-each>
			</ItemGroup>
			<xsl:if test="$ReportsEnabled='true'">
				<ItemGroup>
					<EmbeddedResource Include="Reports\Template.xslt" />
				</ItemGroup>
			</xsl:if>
			<Import Project="$(MSBuildBinPath)\Microsoft.{$CodedomProviderName}.targets" />
			<xsl:comment>
				<![CDATA[To modify your build process, add your task inside one of the targets below and uncomment it. 
       Other similar extension points exist, see Microsoft.Common.targets.
  <Target Name="BeforeBuild">
  </Target>
  <Target Name="AfterBuild">
  </Target>
  ]]>
			</xsl:comment>
		</Project>
	</xsl:template>
</xsl:stylesheet>
