<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
		xmlns="http://schemas.microsoft.com/developer/msbuild/2003"
    xmlns:ontime="urn:schemas-codeontime-com:xslt"
	  exclude-result-prefixes="msxsl ontime"
>
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="ProjectGuid"/>
  <xsl:param name="ProjectName"/>
  <xsl:param name="ProjectExtension"/>
  <xsl:param name="CodedomProviderName"/>
  <xsl:param name="Reference1"/>
  <xsl:param name="Reference1Guid"/>
  <xsl:param name="Reference2"/>
  <xsl:param name="Reference2Guid"/>
  <xsl:param name="ReportsEnabled" select="'false'"/>
  <xsl:param name="TargetFramework"/>
  <xsl:param name="IsClassLibrary" select="'false'"/>
  <xsl:param name="IsPremium"/>
  <xsl:param name="MembershipProviderName"/>
  <xsl:param name="HostPath"/>
  <xsl:param name="VisualStudioBuildTargets"/>
  <xsl:param name="Namespace"/>
  <xsl:param name="FeatureId"/>
  <xsl:param name="AppWebPartId" />
  <xsl:param name="PackageId"/>
  <xsl:param name="LayoutsProjectItemId"/>
  <xsl:param name="ControlTemplatesProjectItemId"/>
  <xsl:param name="VisualStudio2012"/>
  <xsl:param name="VisualStudio2013"/>

  <msxsl:script language="CSharp" implements-prefix="ontime">
    <![CDATA[
        public string Guid()
        {
					return System.Guid.NewGuid().ToString().ToUpper();
        }
        public bool EndsWith(string s, string ending){
          return s.EndsWith(ending);
        }
        public string TrimExtension(string s){
          return s.Substring(0, s.LastIndexOf("."));
        }
        public string GetVisualStudioBuildTargetVersion(string targets, string version) 
        {
            Match m = Regex.Match(targets, String.Format(@"{0}=(.+?);", Regex.Escape(version)));
            return m.Groups[1].Value;
        }        
		]]>
  </msxsl:script>

  <xsl:template match="fileSystem">
    <Project>
      <xsl:attribute name="ToolsVersion">
        <xsl:text>4.0</xsl:text>
      </xsl:attribute>
      <xsl:attribute name="DefaultTargets">
        <xsl:text>Build</xsl:text>
      </xsl:attribute>
      <xsl:if test="$VisualStudio2012!='' or $VisualStudio2013!=''">
        <Import Project="$(MSBuildExtensionsPath)\$(MSBuildToolsVersion)\Microsoft.Common.props" Condition="Exists('$(MSBuildExtensionsPath)\$(MSBuildToolsVersion)\Microsoft.Common.props')" />
      </xsl:if>
      <PropertyGroup>
        <Configuration Condition=" '$(Configuration)' == '' ">Debug</Configuration>
        <Platform Condition=" '$(Platform)' == '' ">AnyCPU</Platform>
        <SchemaVersion>2.0</SchemaVersion>
        <ProjectGuid>
          <xsl:choose>
            <xsl:when test="$ProjectGuid!=''">
              <xsl:value-of select="$ProjectGuid"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat('{', ontime:Guid(), '}')"/>
            </xsl:otherwise>
          </xsl:choose>
        </ProjectGuid>
        <xsl:choose>
          <xsl:when test="$ProjectName='WebParts'">
            <xsl:choose>
              <xsl:when test="$CodedomProviderName='CSharp'">
                <ProjectTypeGuids>{BB1F664B-9266-4fd6-B973-E1E44974B511};{14822709-B5A1-4724-98CA-57A101D1B079};{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}</ProjectTypeGuids>
              </xsl:when>
              <xsl:otherwise>
                <ProjectTypeGuids>{BB1F664B-9266-4fd6-B973-E1E44974B511};{D59BE175-2ED0-4C54-BE3D-CDAA9F3214C8};{F184B08F-C81C-45F6-A57F-5ABD9991F28F}</ProjectTypeGuids>
              </xsl:otherwise>
            </xsl:choose>
            <SandboxedSolution>False</SandboxedSolution>
            <ActiveDeploymentConfiguration>Default</ActiveDeploymentConfiguration>
          </xsl:when>
          <xsl:otherwise>
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
          </xsl:otherwise>
        </xsl:choose>
        <OutputType>Library</OutputType>
        <xsl:if test="$CodedomProviderName='CSharp'">
          <AppDesignerFolder>Properties</AppDesignerFolder>
        </xsl:if>
        <RootNamespace>
          <xsl:if test="$IsClassLibrary!='true'">
            <xsl:value-of select="$Reference1"/>
            <xsl:text>.</xsl:text>
          </xsl:if>
          <xsl:value-of select="$ProjectName"/>
        </RootNamespace>
        <AssemblyName>
          <xsl:if test="$IsClassLibrary!='true'">
            <xsl:value-of select="$Reference1"/>
            <xsl:text>.</xsl:text>
          </xsl:if>
          <xsl:value-of select="$ProjectName"/>
        </AssemblyName>
        <TargetFrameworkVersion>
          <xsl:text>v</xsl:text>
          <xsl:value-of select="$TargetFramework"/>
        </TargetFrameworkVersion>
        <FileAlignment>512</FileAlignment>
        <xsl:if test="$CodedomProviderName='VisualBasic'">
          <OptionExplicit>On</OptionExplicit>
          <OptionCompare>Binary</OptionCompare>
          <OptionStrict>Off</OptionStrict>
          <OptionInfer>On</OptionInfer>
          <OldToolsVersion>4.0</OldToolsVersion>
          <UseIISExpress>false</UseIISExpress>
        </xsl:if>
        <xsl:if test="file[@extension='.vspscc']">
          <SccProjectName>SAK</SccProjectName>
          <SccLocalPath>SAK</SccLocalPath>
          <SccAuxPath>SAK</SccAuxPath>
          <SccProvider>SAK</SccProvider>
        </xsl:if>
      </PropertyGroup>
      <xsl:if test="$ProjectName!='WebApp'">
        <xsl:comment>
          <xsl:value-of select="$ProjectName"/>
        </xsl:comment>
        <PropertyGroup>
          <SignAssembly>true</SignAssembly>
        </PropertyGroup>
        <PropertyGroup>
          <xsl:choose>
            <xsl:when test="$IsClassLibrary='true'">
              <AssemblyOriginatorKeyFile>key.snk</AssemblyOriginatorKeyFile>
            </xsl:when>
            <xsl:otherwise>
              <AssemblyOriginatorKeyFile>
                <xsl:text>..\</xsl:text>
                <xsl:value-of select="$Reference1"/>
                <xsl:text>\key.snk</xsl:text>
              </AssemblyOriginatorKeyFile>
            </xsl:otherwise>
          </xsl:choose>
        </PropertyGroup>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="$CodedomProviderName='VisualBasic'">
          <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Debug|AnyCPU' ">
            <DebugSymbols>true</DebugSymbols>
            <DebugType>full</DebugType>
            <DefineDebug>true</DefineDebug>
            <DefineTrace>true</DefineTrace>
            <OutputPath>
              <xsl:choose>
                <xsl:when test="$Reference1 and $ProjectName!='WebParts'">
                  <xsl:text>bin\</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>bin\Debug\</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </OutputPath>
            <NoWarn>42016,41999,42017,42018,42019,42032,42036,42020,42021,42022</NoWarn>
            <UseVSHostingProcess>false</UseVSHostingProcess>
          </PropertyGroup>
          <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Release|AnyCPU' ">
            <DebugType>pdbonly</DebugType>
            <DefineDebug>false</DefineDebug>
            <DefineTrace>true</DefineTrace>
            <Optimize>true</Optimize>
            <OutputPath>
              <xsl:choose>
                <xsl:when test="$Reference1 and $ProjectName!='WebParts'">
                  <xsl:text>bin\</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>bin\Release\</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </OutputPath>
            <NoWarn>42016,41999,42017,42018,42019,42032,42036,42020,42021,42022</NoWarn>
            <UseVSHostingProcess>false</UseVSHostingProcess>
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
                <xsl:when test="$Reference1 and $ProjectName!='WebParts'">
                  <xsl:text>bin\</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>bin\Debug\</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </OutputPath>
            <DefineConstants>DEBUG;TRACE</DefineConstants>
            <ErrorReport>prompt</ErrorReport>
            <WarningLevel>4</WarningLevel>
            <UseVSHostingProcess>false</UseVSHostingProcess>
          </PropertyGroup>
          <PropertyGroup Condition=" '$(Configuration)|$(Platform)' == 'Release|AnyCPU' ">
            <DebugType>pdbonly</DebugType>
            <Optimize>true</Optimize>
            <OutputPath>
              <xsl:choose>
                <xsl:when test="$Reference1 and $ProjectName!='WebParts'">
                  <xsl:text>bin\</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>bin\Release\</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </OutputPath>
            <DefineConstants>TRACE</DefineConstants>
            <ErrorReport>prompt</ErrorReport>
            <WarningLevel>4</WarningLevel>
            <UseVSHostingProcess>false</UseVSHostingProcess>
          </PropertyGroup>
        </xsl:otherwise>
      </xsl:choose>
      <ItemGroup>
        <!--<Reference Include="AjaxControlToolkit, Version=3.0.30930.28736, Culture=neutral, PublicKeyToken=28f01b0e84b6d53e, processorArchitecture=MSIL">
          <SpecificVersion>False</SpecificVersion>
          <HintPath>..\AjaxControlToolkit\AjaxControlToolkit.dll</HintPath>
        </Reference>-->
        <Reference Include="AjaxControlToolkit">
          <HintPath>..\AjaxControlToolkit\AjaxControlToolkit.dll</HintPath>
        </Reference>
        <xsl:if test="contains($MembershipProviderName,'SQLAnywhere')">
          <Reference Include="iAnywhere.Web.Security, Version=12.0.1.3152, Culture=neutral, processorArchitecture=MSIL">
            <SpecificVersion>False</SpecificVersion>
          </Reference>
        </xsl:if>
        <xsl:if test="$ReportsEnabled='true'">
          <xsl:choose>
            <xsl:when test="$TargetFramework='3.5'">
              <Reference Include="Microsoft.ReportViewer.Common, Version=9.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a, processorArchitecture=MSIL" />
              <Reference Include="Microsoft.ReportViewer.WebForms, Version=9.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a, processorArchitecture=MSIL" />
            </xsl:when>
            <xsl:when test="$TargetFramework='4.0'">
              <!--<Reference Include="Microsoft.ReportViewer.Common, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a, processorArchitecture=MSIL" />
              <Reference Include="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a, processorArchitecture=MSIL" />-->
              <Reference Include="Microsoft.ReportViewer.Common, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a, processorArchitecture=MSIL">
                <!--<xsl:if test="$ProjectName='WebApp'">
                  <Private>True</Private>
                </xsl:if>-->
              </Reference>
              <!--<xsl:if test="$ProjectName='WebApp'">
                <Reference Include="Microsoft.ReportViewer.DataVisualization, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a, processorArchitecture=MSIL">
                  <Private>True</Private>
                </Reference>
                <Reference Include="Microsoft.ReportViewer.ProcessingObjectModel, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a, processorArchitecture=MSIL">
                  <Private>True</Private>
                </Reference>
              </xsl:if>-->
              <Reference Include="Microsoft.ReportViewer.WebForms, Version=10.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a, processorArchitecture=MSIL">
                <!--<xsl:if test="$ProjectName='WebApp'">
                  <Private>True</Private>
                </xsl:if>-->
              </Reference>
            </xsl:when>
          </xsl:choose>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="$TargetFramework='3.5'">
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
            <xsl:if test="$ProjectName='WebParts'">
              <Reference Include="Microsoft.SharePoint"/>
              <Reference Include="Microsoft.SharePoint.Security"/>
            </xsl:if>
          </xsl:when>
          <xsl:when test="$TargetFramework='4.0'">
            <Reference Include="System" />
            <Reference Include="System.configuration" />
            <Reference Include="System.Core" />
            <Reference Include="System.Data" />
            <Reference Include="System.Data.DataSetExtensions" />
            <Reference Include="System.Design" />
            <Reference Include="System.Web.ApplicationServices" />
            <Reference Include="System.Web.Extensions" />
            <Reference Include="System.Transactions" />
            <Reference Include="System.Web.Services" />
            <Reference Include="System.XML" />
            <Reference Include="System.Xml.Linq" />
            <Reference Include="System.Drawing" />
            <Reference Include="System.Web" />
            <Reference Include="System.Web.DataVisualization" />
          </xsl:when>
        </xsl:choose>
      </ItemGroup>
      <xsl:if test="$Reference1">
        <ItemGroup>
          <ProjectReference Include="..\{$Reference1}\{$Reference1}.{$ProjectExtension}">
            <Project>
              <xsl:value-of select="$Reference1Guid"/>
            </Project>
            <Name>
              <xsl:value-of select="$Reference1"/>
            </Name>
          </ProjectReference>
        </ItemGroup>
      </xsl:if>
      <xsl:if test="$Reference2">
        <ItemGroup>
          <ProjectReference Include="..\{$Reference2}\{$Reference2}.{$ProjectExtension}">
            <Project>
              <xsl:value-of select="$Reference2Guid"/>
            </Project>
            <Name>
              <xsl:value-of select="$Reference2"/>
            </Name>
          </ProjectReference>
        </ItemGroup>
      </xsl:if>
      <ItemGroup>
        <xsl:choose>
          <xsl:when test="$IsClassLibrary = 'true'">
            <None Include="key.snk"/>
          </xsl:when>
          <xsl:when test="$ProjectName='WebParts'">
            <None Include="..\{$Reference1}\key.snk">
              <Link>key.snk</Link>
            </None>
          </xsl:when>
        </xsl:choose>
      </ItemGroup>
      <!-- SharePoint Project files -->
      <xsl:if test="$ProjectName='WebParts'">
        <ItemGroup>
          <None Include="Features\{$Namespace}\{$Namespace}.feature">
            <FeatureId>
              <xsl:text>{</xsl:text>
              <xsl:value-of select="$FeatureId"/>
              <xsl:text>}</xsl:text>
            </FeatureId>
          </None>
          <None Include="Features\{$Namespace}\{$Namespace}.Template.xml">
            <DependentUpon>
              <xsl:value-of select="$Namespace"/>
              <xsl:text>.feature</xsl:text>
            </DependentUpon>
          </None>
          <None Include="Layouts\SharePointProjectItem.spdata">
            <SharePointProjectItemId>
              <xsl:text>{</xsl:text>
              <xsl:value-of select="$LayoutsProjectItemId"/>
              <xsl:text>}</xsl:text>
            </SharePointProjectItemId>
          </None>
          <None Include="ControlTemplates\SharePointProjectItem.spdata">
            <SharePointProjectItemId>
              <xsl:text>{</xsl:text>
              <xsl:value-of select="$ControlTemplatesProjectItemId"/>
              <xsl:text>}</xsl:text>
            </SharePointProjectItemId>
          </None>
          <Folder Include="ControlTemplates\{$Namespace}\" />
          <None Include="Package\Package.package">
            <PackageId>
              <xsl:text>{</xsl:text>
              <xsl:value-of select="$PackageId"/>
              <xsl:text>}</xsl:text>
            </PackageId>
          </None>
          <None Include="Package\Package.Template.xml">
            <DependentUpon>Package.package</DependentUpon>
          </None>
          <None Include="AppWebPart\SharePointProjectItem.spdata">
            <SharePointProjectItemId>
              <xsl:text>{</xsl:text>
              <xsl:value-of select="$AppWebPartId"/>
              <xsl:text>}</xsl:text>
            </SharePointProjectItemId>
          </None>
          <None Include="AppWebPart\AppWebPart.webpart" />
          <None Include="AppWebPart\Elements.xml" />
          <xsl:choose>
            <xsl:when test="$CodedomProviderName='CSharp'">
              <Compile Include="AppWebPart\AppWebPart.cs" />
              <Compile Include="AppFeatureReceiver.cs" />
            </xsl:when>
            <xsl:otherwise>
              <Compile Include="AppWebPart\AppWebPart.vb" />
              <Compile Include="AppFeatureReceiver.vb" />
            </xsl:otherwise>
          </xsl:choose>
        </ItemGroup>
      </xsl:if>
      <xsl:if test="$IsClassLibrary!='true'">
        <xsl:variable name="ContentFiles" select="//file[(contains(@name, '.asmx') or contains(@name, '.aspx') or contains(@name, '.config') or 
                      contains(@name, '.asax') or contains(@name, '.master') or contains(@name, '.ascx') or contains(@name, '.txt') or 
                      @extension='.ashx') and not(starts-with(@path, 'bin\') or starts-with(@path,'obj\')
                       or starts-with(@path,'pkg\') or starts-with(@path,'pkgobj\')
                      )]"/>
        <xsl:if test="$ContentFiles">
          <ItemGroup>
            <xsl:for-each select="$ContentFiles[not(ontime:EndsWith(@name, '.vb') or ontime:EndsWith(@name, '.cs'))]">
              <Content Include="{@path}">
                <xsl:if test="ontime:EndsWith(@name, '.txt')">
                  <CopyToOutputDirectory>PreserveNewest</CopyToOutputDirectory>
                </xsl:if>
              </Content>
            </xsl:for-each>
          </ItemGroup>
          <ItemGroup>
            <xsl:for-each select="$ContentFiles[ontime:EndsWith(@name, '.vb') or ontime:EndsWith(@name, '.cs')]">
              <xsl:variable name="DependentUpon" select="ontime:TrimExtension(@name)"/>
              <Compile Include="{@path}">
                <DependentUpon>
                  <xsl:choose>
                    <xsl:when test="ontime:EndsWith($DependentUpon, '.designer')">
                      <xsl:value-of select="ontime:TrimExtension($DependentUpon)"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="$DependentUpon"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </DependentUpon>
                <SubType>ASPXCodebehind</SubType>
              </Compile>
            </xsl:for-each>
          </ItemGroup>
        </xsl:if>
      </xsl:if>
      <xsl:variable name="DataFiles" select="folder[@name='Data']//file"/>
      <xsl:if test="$DataFiles">
        <ItemGroup>
          <xsl:for-each select="$DataFiles">
            <Compile Include="{@path}" />
          </xsl:for-each>
        </ItemGroup>
      </xsl:if>
      <xsl:variable name="RulesFiles" select="folder[@name='Rules']//file"/>
      <xsl:if test="$RulesFiles">
        <ItemGroup>
          <xsl:for-each select="$RulesFiles">
            <Compile Include="{@path}" />
          </xsl:for-each>
        </ItemGroup>
      </xsl:if>
      <xsl:variable name="WebFiles" select="folder[@name='Web']/file"/>
      <xsl:if test="$WebFiles">
        <ItemGroup>
          <xsl:for-each select="$WebFiles">
            <Compile Include="{@path}" />
          </xsl:for-each>
        </ItemGroup>
      </xsl:if>
      <xsl:variable name="SecurityFiles" select="folder[@name='Security']/file"/>
      <xsl:if test="$SecurityFiles">
        <ItemGroup>
          <xsl:for-each select="$SecurityFiles">
            <Compile Include="{@path}" />
          </xsl:for-each>
        </ItemGroup>
      </xsl:if>
      <xsl:variable name="ServicesFiles" select="folder[@name='Services']/file"/>
      <xsl:if test="$ServicesFiles">
        <ItemGroup>
          <xsl:for-each select="$ServicesFiles">
            <Compile Include="{@path}" />
          </xsl:for-each>
        </ItemGroup>
      </xsl:if>
      <xsl:variable name="AssemblyInfoFiles" select="//file[contains(@name, 'AssemblyInfo') and not(contains(@name,'codedom.xml'))]"/>
      <xsl:if test="$AssemblyInfoFiles">
        <ItemGroup>
          <xsl:for-each select="$AssemblyInfoFiles">
            <Compile Include="{@path}" />
          </xsl:for-each>
        </ItemGroup>
      </xsl:if>
      <xsl:variable name="XsdFiles" select="//file[contains(@name, '.xsd')]"/>
      <xsl:variable name="ControllerFiles" select="folder[@name='Controllers']/file[not(contains(@name, '.xsd'))]"/>
      <xsl:if test="$XsdFiles or $ControllerFiles">
        <ItemGroup>
          <xsl:for-each select="$XsdFiles">
            <None Include="{@path}" />
          </xsl:for-each>
          <xsl:for-each select="$ControllerFiles">
            <EmbeddedResource Include="{@path}" />
          </xsl:for-each>
        </ItemGroup>
      </xsl:if>
      <xsl:variable name="HandlersFiles" select="folder[@name='Handlers']/file"/>
      <xsl:if test="$HandlersFiles">
        <ItemGroup>
          <xsl:for-each select="$HandlersFiles">
            <Compile Include="{@path}" />
          </xsl:for-each>
        </ItemGroup>
      </xsl:if>
      <xsl:variable name="ScriptsFiles" select="folder[@name='Scripts']/file"/>
      <xsl:if test="$ScriptsFiles">
        <ItemGroup>
          <xsl:for-each select="$ScriptsFiles">
            <EmbeddedResource Include="{@path}" />
          </xsl:for-each>
        </ItemGroup>
      </xsl:if>
      <xsl:variable name="ThemeFiles" select="folder[@name='Theme']/file"/>
      <xsl:if test="$ThemeFiles">
        <ItemGroup>
          <xsl:for-each select="$ThemeFiles">
            <EmbeddedResource Include="{@path}" />
          </xsl:for-each>
        </ItemGroup>
      </xsl:if>
      <xsl:variable name="AppThemesFiles" select="//folder[@name='App_Themes']//file"/>
      <xsl:if test="$AppThemesFiles">
        <ItemGroup>
          <xsl:for-each select="$AppThemesFiles">
            <Content Include="{@path}" />
          </xsl:for-each>
        </ItemGroup>
      </xsl:if>
      <xsl:if test="$ReportsEnabled='true' and $ProjectName != 'WebParts'">
        <ItemGroup>
          <!--<EmbeddedResource Include="Reports\Template.xslt" />-->
          <xsl:for-each select="folder[@name='Reports']/file">
            <EmbeddedResource Include="{@path}" />
          </xsl:for-each>
        </ItemGroup>
      </xsl:if>
      <xsl:variable name="SiteMapFiles" select="//file[@name='Web.Sitemap']"/>
      <xsl:if test="$SiteMapFiles">
        <ItemGroup>
          <Content Include="Web.Sitemap" />
        </ItemGroup>
      </xsl:if>
      <xsl:variable name="ResourcesLocalizationFiles" select="file[starts-with(@name, 'Resources.')]"/>
      <xsl:if test="$ResourcesLocalizationFiles">
        <ItemGroup>
          <xsl:for-each select="$ResourcesLocalizationFiles">
            <EmbeddedResource Include="{@path}" />
          </xsl:for-each>
        </ItemGroup>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="$ProjectName='WebParts'">
          <PropertyGroup>
            <TokenReplacementFileExtensions>ashx</TokenReplacementFileExtensions>
          </PropertyGroup>
          <Import Project="$(MSBuildToolsPath)\Microsoft.{$CodedomProviderName}.targets"/>
          <xsl:choose>
            <xsl:when test="$VisualStudio2013!=''">
              <PropertyGroup>
                <VSToolsPath Condition="'$(VSToolsPath)' == ''">$(MSBuildExtensionsPath32)\Microsoft\VisualStudio\v12.0</VSToolsPath>
                <MSBuildFrameworkToolsPath Condition="'$(MSBuildFrameworkToolsPath)' == ''">$(MSBuildBinPath)</MSBuildFrameworkToolsPath>
              </PropertyGroup>
              <Import Project="$(VSToolsPath)\SharePointTools\Microsoft.VisualStudio.SharePoint.targets" Condition="'$(VSToolsPath)' != ''" />
            </xsl:when>
            <xsl:when test="$VisualStudio2012!=''">
              <PropertyGroup>
                <VSToolsPath Condition="'$(VSToolsPath)' == ''">$(MSBuildExtensionsPath32)\Microsoft\VisualStudio\v11.0</VSToolsPath>
              </PropertyGroup>
              <Import Project="$(VSToolsPath)\WebApplications\Microsoft.WebApplication.targets" Condition="'$(VSToolsPath)' != ''" />
            </xsl:when>
            <xsl:otherwise>
              <Import Project="$(MSBuildExtensionsPath32)\Microsoft\VisualStudio\v10.0\WebApplications\Microsoft.WebApplication.targets" />
            </xsl:otherwise>
          </xsl:choose>
          <!-- 
          <Import Project="$(MSBuildExtensionsPath32)\Microsoft\VisualStudio\v10.0\WebApplications\Microsoft.WebApplication.targets" />
          <ProjectExtensions>
            <VisualStudio>
              <FlavorProperties GUID="{{349c5851-65df-11da-9384-00065b846f21}}">
                <WebProjectProperties>
                  <UseIIS>False</UseIIS>
                  <AutoAssignPort>True</AutoAssignPort>
                  <DevelopmentServerPort>3276</DevelopmentServerPort>
                  <DevelopmentServerVPath>/</DevelopmentServerVPath>
                  <IISUrl>
                  </IISUrl>
                  <NTLMAuthentication>False</NTLMAuthentication>
                  <UseCustomServer>False</UseCustomServer>
                  <CustomServerUrl>
                  </CustomServerUrl>
                  <SaveServerSettingsInUserFile>False</SaveServerSettingsInUserFile>
                </WebProjectProperties>
              </FlavorProperties>
            </VisualStudio>
          </ProjectExtensions>-->
        </xsl:when>
        <xsl:otherwise>
          <Import Project="$(MSBuildBinPath)\Microsoft.{$CodedomProviderName}.targets" />
          <xsl:if test="$IsClassLibrary='false'">
            <xsl:choose>
              <xsl:when test="$VisualStudio2013!=''">
                <PropertyGroup>
                  <VSToolsPath Condition="'$(VSToolsPath)' == ''">$(MSBuildExtensionsPath32)\Microsoft\VisualStudio\v12.0</VSToolsPath>
                </PropertyGroup>
                <Import Project="$(VSToolsPath)\WebApplications\Microsoft.WebApplication.targets" Condition="'$(VSToolsPath)' != ''" />
              </xsl:when>
              <xsl:when test="$VisualStudio2012!=''">
                <PropertyGroup>
                  <VSToolsPath Condition="'$(VSToolsPath)' == ''">$(MSBuildExtensionsPath32)\Microsoft\VisualStudio\v11.0</VSToolsPath>
                </PropertyGroup>
                <Import Project="$(VSToolsPath)\WebApplications\Microsoft.WebApplication.targets" Condition="'$(VSToolsPath)' != ''" />
              </xsl:when>
              <xsl:otherwise>
                <Import Project="$(MSBuildExtensionsPath32)\Microsoft\VisualStudio\v10.0\WebApplications\Microsoft.WebApplication.targets" />
              </xsl:otherwise>
            </xsl:choose>
            <ProjectExtensions>
              <VisualStudio>
                <FlavorProperties GUID="{{349c5851-65df-11da-9384-00065b846f21}}">
                  <WebProjectProperties>
                    <xsl:choose>
                      <xsl:when test="$VisualStudio2013 != ''">
                        <UseIIS>True</UseIIS>
                      </xsl:when>
                      <xsl:otherwise>
                        <UseIIS>False</UseIIS>
                      </xsl:otherwise>
                    </xsl:choose>
                    <AutoAssignPort>True</AutoAssignPort>
                    <DevelopmentServerVPath>/</DevelopmentServerVPath>
                    <IISUrl>
                    </IISUrl>
                    <UseCustomServer>False</UseCustomServer>
                    <CustomServerUrl>
                    </CustomServerUrl>
                    <SaveServerSettingsInUserFile>False</SaveServerSettingsInUserFile>
                  </WebProjectProperties>
                </FlavorProperties>
              </VisualStudio>
            </ProjectExtensions>
          </xsl:if>
          <!--<xsl:if test="$TargetFramework='3.5' and $IsClassLibrary='false'">
            <xsl:choose>
              <xsl:when test="$VisualStudio2013!=''">
                <Import Project="$(VSToolsPath)\WebApplications\Microsoft.WebApplication.targets" Condition="'$(VSToolsPath)' != ''" />
                <Import Project="$(MSBuildExtensionsPath32)\Microsoft\VisualStudio\v12.0\WebApplications\Microsoft.WebApplication.targets" Condition="false" />
              </xsl:when>
              <xsl:when test="$VisualStudio2012!=''">
                <Import Project="$(VSToolsPath)\WebApplications\Microsoft.WebApplication.targets" Condition="'$(VSToolsPath)' != ''" />
                <Import Project="$(MSBuildExtensionsPath32)\Microsoft\VisualStudio\v11.0\WebApplications\Microsoft.WebApplication.targets" Condition="false" />
              </xsl:when>
              <xsl:otherwise>
                <Import Project="$(MSBuildExtensionsPath32)\Microsoft\VisualStudio\v10.0\WebApplications\Microsoft.WebApplication.targets" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>-->
        </xsl:otherwise>
      </xsl:choose>
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
