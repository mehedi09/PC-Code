﻿<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"  xmlns:a="urn:schemas-codeontime-com:data-aquarium"
    xmlns="urn:schemas-codeontime-com:data-aquarium-application" xmlns:m="urn:codeontime:data-map"
    exclude-result-prefixes="msxsl a"
>
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="ProjectPath" />
  <xsl:param name="MembershipEnabled" select="'false'"/>
  <xsl:param name="CustomSecurity" select="'false'"/>
  <xsl:param name="DedicatedLogin" select="'false'"/>
  <xsl:param name="Style" select="'Tabbed'"/>
  <xsl:param name="MaxDepth" select="1"/>
  <xsl:param name="MultiSelectEnabled" select="'false'"/>
  <xsl:param name="ShowModalForms" select="'false'"/>
  <xsl:param name="SearchOnStart" select="'false'"/>
  <xsl:param name="ScriptOnly" select="'false'"/>

  <xsl:variable name="Schema" select="document(concat($ProjectPath, '\Map1.xml'))/map"/>
  <xsl:variable name="Map" select="document(concat($ProjectPath,'\Map4.xml'))"/>
  <xsl:variable name="Controllers" select="//a:dataController"/>

  <msxsl:script language="C#" implements-prefix="a">
    <![CDATA[
		public string ToLower(string s) {
			return s.ToLower();
		}
		private int _pageCount = 0;
		public int NextPageIndex() {
			int index = this._pageCount++;
			return 1000 + index * 10;
		}
		
		private int _viewCount = 1;
		public int NextViewIndex() {
			return _viewCount++;
		}
		private System.Collections.Generic.SortedDictionary<string, int> _usedControllers = new System.Collections.Generic.SortedDictionary<string, int>();
		
		public bool IsControllerAllowed(string name, bool root) {
			if (root) {
				_usedControllers.Clear();
				_viewCount = 1;
				return true;
			}
			if (_usedControllers.ContainsKey(name)) 
				return false;
			_usedControllers.Add(name, 1);
			return true;
		}
		public bool ResetViewCount() {
			this._viewCount = 2;
			_usedControllers.Clear();
			return true;
		}
		public string CleanIdentifier(XPathNodeIterator iterator)
		{
			if (iterator.MoveNext()) {
				string s = System.Text.RegularExpressions.Regex.Replace(iterator.Current.Value, @"[^\w]", "");
				double n;
				if (Double.TryParse(s, out n))
					return "n" + s;
				return s;
		  }
			return "CleanIdentifier-Error";
		}
    
	]]>
  </msxsl:script>

  <xsl:template match="/">
    <application>
      <pages>
        <page name="Home" title="^HomeTitle^Start^HomeTitle^" description="^HomeDesc^Application home page^HomeDesc^" path="^HomePath^Home^HomePath^" style="HomePage" customStyle="Wide" index="{a:NextPageIndex()}">
          <containers>
            <container id="container1" flow="NewRow"/>
            <container id="container2" flow="NewColumn"/>
          </containers>
          <controls>
            <control id="control1" name="TableOfContents" container="container1" />
            <xsl:if test="not($DedicatedLogin='true')">
              <control id="control2" name="Welcome" container="container2" />
            </xsl:if>
          </controls>
        </page>
        <xsl:apply-templates select="$Map//m:node[not(preceding::m:node/@name = @name)]"/>
        <xsl:if test="$MembershipEnabled='true'">
          <page name="Membership" title="^MembershipTitle^Membership Manager^MembershipTitle^" description="^MembershipDesc^User and role manager^MembershipDesc^" roles="Administrators" path="^MembershipPath^Membership^MembershipPath^" style="UsersPage" index="{a:NextPageIndex()}">
            <containers>
              <container id="container1"  flow="NewRow"/>
            </containers>
            <about>^MembershipAbout^This page allows to manage roles and users.^MembershipAbout^</about>
            <controls>
              <control id="control1" name="MembershipManager" container="container1" />
            </controls>
          </page>
        </xsl:if>
      </pages>
      <userControls>
        <userControl name="TableOfContents" prefix="uc" generate="Always">
          <body>
            <![CDATA[
<div class="ParaInfo">
        ^TocInstruction^Please select a page link in the table of contents below.^TocInstruction^</div>
<div class="ParaHeader">
    ^TocHeader^Site Map^TocHeader^
</div>
<asp:SiteMapDataSource ID="SiteMapDataSource1" runat="server" ShowStartingNode="false" />
<asp:TreeView ID="TreeView1" runat="server" DataSourceID="SiteMapDataSource1" CssClass="TreeView">
</asp:TreeView>

<div id="app-sitemap" data-app-role="page" data-activator="Button|^TocHeader^Site Map^TocHeader^">
]]>
            <![CDATA[
  <div data-role="content">
    <p>
      <span>^TocInstruction^Please select a page link in the table of contents below.^TocInstruction^</span>
    </p>
    <div data-app-role="sitemap"></div>
    <p>
      <br />
    </p>
  </div>
</div>]]>
          </body>
        </userControl>
        <xsl:if test="$ScriptOnly='false'">
          <userControl name="RichEditor" prefix="uc" generate="FirstTimeOnly">
            <body>
              <![CDATA[
<asp:TextBox ID="TextBox1" runat="server" Columns="50" Rows="10" Height="241px"
    Width="450px"></asp:TextBox>
<act:HtmlEditorExtender ID="Editor1" runat="server" TargetControlID="TextBox1" EnableSanitization="false">
</act:HtmlEditorExtender>]]>
            </body>
          </userControl>
        </xsl:if>
        <userControl name="Welcome" prefix="uc" generate="Always">
          <xsl:choose>
            <xsl:when test="$MembershipEnabled='true' or $CustomSecurity='true'">
              <body>
                <![CDATA[
<div style="padding-left:8px"><div class="ParaInfo">
        ^SignInInstruction^Sign in to access the protected site content.^SignInInstruction^</div>
<div class="ParaHeader">
    ^SignInHeader^Instructions^SignInHeader^
</div>
<div class="ParaText">
    ^SignInPara1^Two standard user accounts are automatically created when application is initialized
    if membership option has been selected for this application.^SignInPara1^
</div>]]><xsl:if test="$MembershipEnabled='true' ">
                  <![CDATA[
<div class="ParaText">
    ^SignInPara2^The administrative account <b>admin</b> is authorized to access all areas of the
    web site and membership manager. The standard <b>user</b> account is allowed to
    access all areas of the web site with the exception of membership manager.^SignInPara2^</div>]]>
                </xsl:if>
                <xsl:if test="$DedicatedLogin!='true'">
                  <![CDATA[
<div class="ParaText">
    ^SignInPara3^Move the mouse pointer over the link <i>Login to this web site</i> on the right-hand side
    at the top of the page and sign in with one of the accounts listed below.^SignInPara3^</div>]]>
                </xsl:if><![CDATA[
<div class="ParaText">
    <div style="border: solid 1px black; background-color: InfoBackground; padding: 8px;
        float: left;">
        ^AdminDesc^Administrative account^AdminDesc^:<br />
        <b title="User Name">admin</b> / <b title="Password">admin123%</b>
        <br />
        <br />
        ^UserDesc^Standard user account^UserDesc^:<br />
        <b title="User Name">user</b> / <b title="Password">user123%</b>
    </div>
    <div style="clear:both;margin-bottom:8px"></div>
    </div>
</div>


<div id="app-welcome" data-app-role="page" data-activator="Button|^SignInHeader^Instructions^SignInHeader^" data-activator-description="^SignInInstruction^Sign in to access the protected site content.^SignInInstruction^">
    <div data-role="content">
        <p>^SignInInstruction^Sign in to access the protected site content.^SignInInstruction^</p>
        <p>
            ^SignInPara1^Two standard user accounts are automatically created when application is initialized
    if membership option has been selected for this application.^SignInPara1^
        </p>

        <p>
            ^SignInPara2^The administrative account <b>admin</b> is authorized to access all areas of the
    web site and membership manager. The standard <b>user</b> account is allowed to
    access all areas of the web site with the exception of membership manager.^SignInPara2^
        </p>
        <p>
            ^AdminDesc^Administrative account^AdminDesc^:<br />
            <b title="User Name">admin</b> / <b title="Password">admin123%</b>
        </p>
        <p>
            ^UserDesc^Standard user account^UserDesc^:<br />
            <b title="User Name">user</b> / <b title="Password">user123%</b>
        </p>
        <p><a href="#" data-role="button" data-inline="true" data-theme="b" data-app-role="loginstatus" data-icon="lock">Login Status</a></p>

    </div>
</div>
]]>
              </body>
            </xsl:when>
            <xsl:otherwise>
              <body>
                <![CDATA[
<div style="padding-left:8px"><div class="ParaInfo">
        Select a page in a table of content.</div>
<div class="ParaHeader">
    Instructions
</div>
<div class="ParaText">
    Membership option has not been selected for this application. 
    The entire site content can be accessed without any restrictions.
</div>
]]>
              </body>
            </xsl:otherwise>
          </xsl:choose>
        </userControl>
        <xsl:if test="$MembershipEnabled='true'">
          <userControl name="MembershipManager" prefix="uc" generate="Always">
            <body>
              <![CDATA[
<aquarium:MembershipManager ID="mm" runat="server" />]]>
            </body>
          </userControl>
        </xsl:if>
        <xsl:if test="$DedicatedLogin='true'">
          <userControl name="Login" prefix="uc" generate="FirstTimeOnly">
            <body>
              <![CDATA[
<div id="LoginControl" data-app-role="page" data-activator="Button|Login" data-content-framework="bootstrap">
    <div data-role="content">
        <div class="navbar navbar-default navbar-static-top" role="navigation">
            <div class="container">
                <div class="navbar-header">
                    <span class="navbar-brand">Standalone Login Page</span>
                </div>
                <div class="navbar-collapse">
                    <div class="navbar-form navbar-right" role="form">
                        <div class="form-group">
                            <input id="login-user-name" type="text" placeholder="Username" class="form-control">
                        </div>
                        <div class="form-group">
                            <input id="login-password" type="password" placeholder="Password" class="form-control">
                        </div>
                        <button id="login-button" class="btn btn-success">Sign in</button>
                    </div>
                </div>
                <!--/.navbar-collapse -->
            </div>
        </div>
        <!-- Main jumbotron for a primary marketing message or call to action -->
        <div class="jumbotron">
            <div class="container">
                <h1><span class="glyphicon glyphicon-globe"></span>&nbsp;Hello, world!</h1>
                <p>
                    This is a template for a custom login screen. It includes a large callout called a jumbotron and three supporting content blocks. 
                    <%--Use it as a starting point to create something more unique.</p>--%>
                    Edit the "Login" control in Visual Studio to create something more unique.
                </p>

                <p><a href="http://codeontime.com/learn/user-controls/extending-pages" class="btn btn-primary btn-lg" role="button">Learn more &raquo;</a></p>
            </div>
        </div>

        <div class="container">

            <div class="row">
                <div class="col-sm-8">
                    <h2>^SignInInstruction^Sign in to access the protected site content.^SignInInstruction^</h2>
                    <p>
                        ^SignInPara1^Two standard user accounts are automatically created when application is initialized
    if membership option has been selected for this application.^SignInPara1^
                    </p>

                    <p>
                        ^SignInPara2^The administrative account <b>admin</b> is authorized to access all areas of the
    web site and membership manager. The standard <b>user</b> account is allowed to
    access all areas of the web site with the exception of membership manager.^SignInPara2^
                    </p>
                </div>
                <div class="col-sm-4">
                    <div class="panel panel-success">
                        <div class="panel-heading">
                            <span>^AdminDesc^Administrative account^AdminDesc^</span>
                        </div>
                        <div class="panel-body">
                            User Name: <b title="User Name">admin</b><br />
                            Password: <b title="Password">admin123%</b>
                        </div>
                    </div>

                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <span>^UserDesc^Standard user account^UserDesc^</span>
                        </div>
                        <div class="panel-body">
                            User Name: <b title="User Name">user</b><br />
                            Password: <b title="Password">user123%</b>
                        </div>
                    </div>
                </div>
            </div>
            <hr />
            <!-- Example row of columns -->
            <div class="row">
                <div class="col-sm-4">
                    <h2>Heading</h2>
                    <p>Donec id elit non mi porta gravida at eget metus. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Etiam porta sem malesuada magna mollis euismod. Donec sed odio dui. </p>
                    <p><a class="btn btn-default" href="#" role="button">View details &raquo;</a></p>
                </div>
                <div class="col-sm-4">
                    <h2>Heading</h2>
                    <p>Donec id elit non mi porta gravida at eget metus. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus. Etiam porta sem malesuada magna mollis euismod. Donec sed odio dui. </p>
                    <p><a class="btn btn-default" href="#" role="button">View details &raquo;</a></p>
                </div>
                <div class="col-sm-4">
                    <h2>Heading</h2>
                    <p>Donec sed odio dui. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Vestibulum id ligula porta felis euismod semper. Fusce dapibus, tellus ac cursus commodo, tortor mauris condimentum nibh, ut fermentum massa justo sit amet risus.</p>
                    <p><a class="btn btn-default" href="#" role="button">View details &raquo;</a></p>
                </div>
            </div>

            <hr>
        </div>
        <!-- /container -->
    </div>
</div>


<script type="text/javascript">
    (function () {
        var resources = Web.MembershipResources.Messages;

        function performLogin() {

            var userName = $('#login-user-name'),
                password = $('#login-password');
            if (!userName.val())
                $app.alert(resources.BlankUserName, function () {
                    userName.focus();
                });
            else if (!password.val())
                $app.alert(resources.BlankPassword, function () {
                    password.focus();
                });
            else
                $app.login(userName.val(), password.val(), true,
                    function () {
                        var returnUrl = window.location.href.match(/\?ReturnUrl=(.+)$/);
                        window.location.replace(returnUrl && decodeURIComponent(returnUrl[1]) || __baseUrl);
                    },
                    function () {
                        $app.alert(resources.InvalidUserNameAndPassword, function () {
                            userName.focus();
                        });
                    });
            return false;
        }

        // remove any other "app" pages 
        $('div.SettingsPanel div[data-app-role="page"]').remove();
        // register event handlers
        $(document)
            .on('click', '#login-button', performLogin)
            .on('keydown', '#login-user-name,#login-password', event, function () {
                if (event.which == 13) {
                    performLogin();
                    return false;
                }
            });
    })();
</script>
]]>
            </body>
          </userControl>
        </xsl:if>
      </userControls>
    </application>
  </xsl:template>

  <xsl:template match="m:node[@type='Content']" priority="10">
    <page name="{a:CleanIdentifier(@name)}" index="{a:NextPageIndex()}" title="{@label}" path="{@label}" description="Home of {@label}" style="HomePage" >
      <containers />
      <controls />
      <about>
        <xsl:text>This is a home of </xsl:text>
        <xsl:value-of select="a:ToLower(@label)"/>
        <xsl:text>.</xsl:text>
      </about>
    </page>
  </xsl:template>

  <xsl:template match="m:node">
    <xsl:variable name="Controller" select="$Controllers[@name=current()/@name]"/>
    <xsl:choose>
      <xsl:when test="$Controller[@generate='false']">
      </xsl:when>
      <xsl:when test="$Controller">
        <page name="{@name}" title="{@label}" description="View {@label}"  index="{a:NextPageIndex()}">
          <xsl:attribute name="path">
            <xsl:call-template name="RenderPath"/>
          </xsl:attribute>
          <!--<xsl:attribute name="generate">
            <xsl:text>always</xsl:text>
          </xsl:attribute>-->
          <xsl:variable name="dummy" select="a:IsControllerAllowed(@name, true())"/>
          <xsl:variable name="ViewIndex" select="a:NextViewIndex()"/>
          <xsl:variable name="ViewName" select="concat('view', $ViewIndex)"/>
          <containers>
            <container id="container1" flow="NewRow" />
            <xsl:if test="$Style='Stacked'">
              <xsl:call-template name="RenderChild">
                <xsl:with-param name="ParentControllerName" select="$Controller/@name"/>
                <xsl:with-param name="Depth" select="1"/>
                <xsl:with-param name="ParentViewName" select="$ViewName"/>
                <xsl:with-param name="Mode" select="'Container'"/>
              </xsl:call-template>
            </xsl:if>
            <xsl:if test="$Style='Classic'">
              <container id="container2" flow="NewRow" style="padding-top:8px"/>
            </xsl:if>
          </containers>
          <dataViews>
            <dataView id="{$ViewName}" controller="{@name}" view="grid1" showInSummary="true" container="container1">
              <xsl:attribute name="activator">
                <xsl:choose>
                  <xsl:when test="$Style='Tabbed'">
                    <xsl:text>Tab</xsl:text>
                  </xsl:when>
                  <xsl:when test="$Style='Inline' or $Style='Stacked'">
                    <xsl:text>SideBarTask</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>None</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <xsl:attribute name="text">
                <xsl:choose>
                  <xsl:when test="$Style='Tabbed'">
                    <xsl:value-of select="@label"/>
                  </xsl:when>
                  <xsl:when test="$Style='Inline' or $Style='Stacked'">
                    <xsl:value-of select="@label"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text></xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:attribute>
              <!--<xsl:if test="$Style='Stacked' or $Style='Classic'">
							<xsl:attribute name="pageSize">
								<xsl:text>5</xsl:text>
							</xsl:attribute>
						</xsl:if>-->
              <xsl:if test="$MultiSelectEnabled='true'">
                <xsl:attribute name="multiSelect">
                  <xsl:text>true</xsl:text>
                </xsl:attribute>
              </xsl:if>
              <xsl:if test="$ShowModalForms='true'">
                <xsl:choose>
                  <xsl:when test="$Style='Simple'">
                    <xsl:attribute name="showModalForms">
                      <xsl:text>true</xsl:text>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:variable name="ChildControllers" select="$Controllers[@name=$Schema/node[@name=$Controller/@name]/node/@name and not(@generate='false')]"/>
                    <xsl:if test="not($ChildControllers[a:IsControllerAllowed($Controller/@name, false())])">
                      <xsl:attribute name="showModalForms">
                        <xsl:text>true</xsl:text>
                      </xsl:attribute>
                    </xsl:if>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:if>
              <xsl:if test="$SearchOnStart='true'">
                <xsl:attribute name="searchOnStart">
                  <xsl:text>true</xsl:text>
                </xsl:attribute>
              </xsl:if>
            </dataView>
            <xsl:variable name="dummy2" select="a:ResetViewCount()"/>
            <xsl:choose>
              <xsl:when test="$Style!='Simple'">
                <xsl:call-template name="RenderChild">
                  <xsl:with-param name="ParentControllerName" select="$Controller/@name"/>
                  <xsl:with-param name="Depth" select="1"/>
                  <xsl:with-param name="ParentViewName" select="$ViewName"/>
                </xsl:call-template>
              </xsl:when>
            </xsl:choose>
          </dataViews>
          <controls/>
          <about>
            <xsl:text>This page allows </xsl:text>
            <xsl:value-of select="a:ToLower($Controller/@label)"/>
            <xsl:text> management.</xsl:text>
          </about>
        </page>
      </xsl:when>
      <xsl:otherwise>
        <page name="{@name}" title="{@label}" externalUrl="about:blank" index="{a:NextPageIndex()}" path="{@label}"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="RenderChild">
    <xsl:param name="ParentControllerName"/>
    <xsl:param name="Depth"/>
    <xsl:param name="ParentViewName"/>
    <xsl:param name="Mode" select="'View'"/>
    <xsl:if test="$Depth&lt;=$MaxDepth">
      <xsl:for-each select="$Schema/node[@name=$ParentControllerName]/node">
        <xsl:variable name="Controller" select="$Controllers[@name=current()/@name and not(@generate='false')]"/>
        <xsl:if test="$Controller and a:IsControllerAllowed($Controller/@name, false())">
          <xsl:variable name="ViewIndex" select="a:NextViewIndex()"/>
          <xsl:variable name="ViewName" select="concat('view', $ViewIndex)"/>
          <xsl:choose>
            <xsl:when test="$Mode='Container'">
              <container id="container{$ViewIndex}" flow="NewRow" style="padding-top:8px;"/>
            </xsl:when>
            <xsl:otherwise>
              <dataView id="{$ViewName}" controller="{$Controller/@name}" view="grid1" text="{$Controller/@label}" filterSource="{$ParentViewName}">
                <xsl:attribute name="container">
                  <xsl:text>container</xsl:text>
                  <xsl:choose>
                    <xsl:when test="$Style='Stacked'">
                      <xsl:value-of select="$ViewIndex"/>
                    </xsl:when>
                    <xsl:when test="$Style='Classic'">
                      <xsl:text>2</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>1</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="filterFields">
                  <xsl:variable name="ParentKeyFieldCount" select="count($Controllers[@name=$ParentControllerName]/a:fields/a:field[@isPrimaryKey='true'])"/>
                  <xsl:for-each select="$Controller/a:fields/a:field[a:items/@dataController=$ParentControllerName]">
                    <xsl:if test="position() &lt;= $ParentKeyFieldCount">
                      <xsl:if test="position()>1">
                        <xsl:text>,</xsl:text>
                      </xsl:if>
                      <xsl:value-of select="@name"/>
                    </xsl:if>
                  </xsl:for-each>
                </xsl:attribute>
                <xsl:attribute name="activator">
                  <xsl:choose>
                    <xsl:when test="$Style='Tabbed' or $Style='Classic'">
                      <xsl:text>Tab</xsl:text>
                    </xsl:when>
                    <xsl:when test="$Style='Inline' or $Style='Stacked'">
                      <xsl:text>SideBarTask</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:text>None</xsl:text>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:choose>
                  <xsl:when test="$Style='Tabbed' or $Style='Inline'">
                    <xsl:attribute name="autoHide">
                      <xsl:text>Self</xsl:text>
                    </xsl:attribute>
                  </xsl:when>
                  <xsl:when test="$Style='Classic' or $Style='Stacked'">
                    <xsl:attribute name="autoHide">
                      <xsl:text>Container</xsl:text>
                    </xsl:attribute>
                  </xsl:when>
                </xsl:choose>
                <xsl:if test="$Style='Stacked' or $Style='Classic'">
                  <xsl:attribute name="pageSize">
                    <xsl:text>5</xsl:text>
                  </xsl:attribute>
                </xsl:if>
                <xsl:if test="$MultiSelectEnabled='true'">
                  <xsl:attribute name="multiSelect">
                    <xsl:text>true</xsl:text>
                  </xsl:attribute>
                </xsl:if>
                <xsl:if test="$ShowModalForms='true'">
                  <xsl:attribute name="showModalForms">
                    <xsl:text>true</xsl:text>
                  </xsl:attribute>
                </xsl:if>
              </dataView>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:call-template name="RenderChild">
            <xsl:with-param name="ParentControllerName" select="@name"/>
            <xsl:with-param name="Depth" select="$Depth + 1"/>
            <xsl:with-param name="ParentViewName" select="$ViewName"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:for-each>
    </xsl:if>
  </xsl:template>

  <xsl:template name="RenderPath">
    <xsl:param name="Node" select="."/>
    <xsl:if test="$Node/parent::m:node">
      <xsl:call-template name="RenderPath">
        <xsl:with-param name="Node" select="$Node/parent::m:node"/>
      </xsl:call-template>
      <xsl:text> | </xsl:text>
    </xsl:if>
    <xsl:value-of select="$Node/@label"/>
  </xsl:template>
</xsl:stylesheet>
