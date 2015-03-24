<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.codeontime.com/2008/codedom-compiler"  xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl a"
>
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="Namespace" select="a:project/a:namespace"/>

  <xsl:template match="/">
    <compileUnit namespace="{$Namespace}.Security">
      <imports>
        <namespaceImport name="System"/>
        <namespaceImport name="System.Collections.Generic"/>
        <namespaceImport name="System.Configuration"/>
        <namespaceImport name="System.Security.Permissions"/>
        <namespaceImport name="System.Security.Principal"/>
        <namespaceImport name="System.Text"/>
        <namespaceImport name="System.Web"/>
        <namespaceImport name="System.Web.Security"/>
        <namespaceImport name="{$Namespace}.Services"/>
      </imports>
      <types>
        <!-- class ExportAuthenticationModule -->
        <typeDeclaration name="ExportAuthenticationModule" isPartial="true">
          <customAttributes>
            <customAttribute name="AspNetHostingPermission">
              <arguments>
                <propertyReferenceExpression name="LinkDemand">
                  <typeReferenceExpression type="SecurityAction"/>
                </propertyReferenceExpression>
                <attributeArgument name="Level">
                  <propertyReferenceExpression name="Minimal">
                    <typeReferenceExpression type="AspNetHostingPermissionLevel"/>
                  </propertyReferenceExpression>
                </attributeArgument>
              </arguments>
            </customAttribute>
          </customAttributes>
          <baseTypes>
            <typeReference type="ExportAuthenticationModuleBase"/>
          </baseTypes>
        </typeDeclaration>
        <!-- class ExportAuthenticationModule -->
        <typeDeclaration name="ExportAuthenticationModuleBase">
          <baseTypes>
            <typeReference type="System.Object"/>
            <typeReference type="IHttpModule"/>
          </baseTypes>
          <members>
            <!-- method IHttpModule.Init(HttpApplication)-->
            <memberMethod name="Init" privateImplementationType="IHttpModule">
              <attributes/>
              <parameters>
                <parameter type="HttpApplication" name="context"/>
              </parameters>
              <statements>
                <attachEventStatement>
                  <event name="AuthenticateRequest">
                    <argumentReferenceExpression name="context"/>
                  </event>
                  <listener>
                    <delegateCreateExpression type="EventHandler" methodName="contextAuthenticateRequest"/>
                  </listener>
                </attachEventStatement>
                <attachEventStatement>
                  <event name="EndRequest">
                    <argumentReferenceExpression name="context"/>
                  </event>
                  <listener>
                    <delegateCreateExpression type="EventHandler" methodName="contextEndRequest"/>
                  </listener>
                </attachEventStatement>
              </statements>
            </memberMethod>
            <!-- method IHttpModule.Disose()-->
            <memberMethod name="Dispose" privateImplementationType="IHttpModule">
              <attributes/>
            </memberMethod>
            <!-- method contextEndRequest(object sender, EventArgs e)-->
            <memberMethod name="contextEndRequest">
              <attributes private="true"/>
              <parameters>
                <parameter type="System.Object" name="sender"/>
                <parameter type="EventArgs" name="e"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="HttpApplication" name="app">
                  <init>
                    <castExpression targetType="HttpApplication">
                      <argumentReferenceExpression name="sender"/>
                    </castExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <propertyReferenceExpression name="StatusCode">
                        <propertyReferenceExpression name="Response">
                          <variableReferenceExpression name="app"/>
                        </propertyReferenceExpression>
                      </propertyReferenceExpression>
                      <primitiveExpression value="401"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="RequestAuthentication">
                      <parameters>
                        <variableReferenceExpression name="app"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method contextAuthenticateRequest(object sender, EventArgs e)-->
            <memberMethod name="contextAuthenticateRequest" >
              <attributes private="true"/>
              <parameters>
                <parameter type="System.Object" name="sender"/>
                <parameter type="EventArgs" name="e"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="HttpApplication" name="app">
                  <init>
                    <castExpression targetType="HttpApplication">
                      <argumentReferenceExpression name="sender"/>
                    </castExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="ApplicationServices" name="appServices">
                  <init>
                    <objectCreateExpression type="ApplicationServices"/>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="Not">
                      <methodInvokeExpression methodName="RequiresAuthentication">
                        <target>
                          <variableReferenceExpression name="appServices"/>
                        </target>
                        <parameters>
                          <propertyReferenceExpression name="Request">
                            <propertyReferenceExpression name="Context">
                              <variableReferenceExpression name="app"/>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                        </parameters>
                      </methodInvokeExpression>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement/>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="AuthenticateRequest">
                      <target>
                        <variableReferenceExpression name="appServices"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="Context">
                          <variableReferenceExpression name="app"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement/>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="HttpCookie" name="c">
                  <init>
                    <arrayIndexerExpression>
                      <target>
                        <propertyReferenceExpression name="Cookies">
                          <propertyReferenceExpression name="Request">
                            <variableReferenceExpression name="app"/>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                      </target>
                      <indices>
                        <propertyReferenceExpression name="FormsCookieName">
                          <typeReferenceExpression type="FormsAuthentication"/>
                        </propertyReferenceExpression>
                      </indices>
                    </arrayIndexerExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <variableReferenceExpression name="c"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="FormsAuthenticationTicket" name="t">
                      <init>
                        <methodInvokeExpression methodName="Decrypt">
                          <target>
                            <typeReferenceExpression type="FormsAuthentication"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="Value">
                              <variableReferenceExpression name="c"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="IsNotNullOrEmpty">
                          <propertyReferenceExpression name="Name">
                            <variableReferenceExpression name="t"/>
                          </propertyReferenceExpression>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodReturnStatement/>
                      </trueStatements>
                    </conditionStatement>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="System.String" name="authorization">
                  <init>
                    <arrayIndexerExpression>
                      <target>
                        <propertyReferenceExpression name="Headers">
                          <propertyReferenceExpression name="Request">
                            <variableReferenceExpression name="app"/>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                      </target>
                      <indices>
                        <primitiveExpression value="Authorization"/>
                      </indices>
                    </arrayIndexerExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="IsNullOrEmpty">
                      <variableReferenceExpression name="authorization"/>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="RequestAuthentication">
                      <parameters>
                        <variableReferenceExpression name="app"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                  <falseStatements>
                    <conditionStatement>
                      <condition>
                        <methodInvokeExpression methodName="StartsWith">
                          <target>
                            <variableReferenceExpression name="authorization"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="Basic"/>
                            <propertyReferenceExpression name="CurrentCultureIgnoreCase">
                              <typeReferenceExpression type="StringComparison"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="ValidateUserIdentity">
                          <parameters>
                            <variableReferenceExpression name="app"/>
                            <variableReferenceExpression name="authorization"/>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                      <falseStatements>
                        <methodInvokeExpression methodName="RequestAuthentication">
                          <parameters>
                            <variableReferenceExpression name="app"/>
                          </parameters>
                        </methodInvokeExpression>
                      </falseStatements>
                    </conditionStatement>
                  </falseStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method RequestAuthenitcation(HttpApplication) -->
            <memberMethod name="RequestAuthentication">
              <attributes private ="true"/>
              <parameters>
                <parameter type="HttpApplication" name="app"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="ApplicationServices" name="appServices">
                  <init>
                    <objectCreateExpression type="ApplicationServices"/>
                  </init>
                </variableDeclarationStatement>
                <methodInvokeExpression methodName="AppendHeader">
                  <target>
                    <propertyReferenceExpression name="Response">
                      <argumentReferenceExpression name="app"/>
                    </propertyReferenceExpression>
                  </target>
                  <parameters>
                    <primitiveExpression value="WWW-Authenticate"/>
                    <!--<primitiveExpression value="Basic realm=&quot;{$Namespace} Data Export&quot;"/>-->
                    <stringFormatExpression format="Basic realm=&quot;{{0}}&quot;">
                      <propertyReferenceExpression name="Realm">
                        <variableReferenceExpression name="appServices"/>
                      </propertyReferenceExpression>
                    </stringFormatExpression>
                  </parameters>
                </methodInvokeExpression>
                <assignStatement>
                  <propertyReferenceExpression name="StatusCode">
                    <propertyReferenceExpression name="Response">
                      <argumentReferenceExpression name="app"/>
                    </propertyReferenceExpression>
                  </propertyReferenceExpression>
                  <primitiveExpression value="401"/>
                </assignStatement>
                <methodInvokeExpression methodName="CompleteRequest">
                  <target>
                    <argumentReferenceExpression name="app"/>
                  </target>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- method ValidateUserIdentity(HttpApplication, string) -->
            <memberMethod name="ValidateUserIdentity">
              <attributes private ="true"/>
              <parameters>
                <parameter type="HttpApplication" name="app"/>
                <parameter type="System.String" name="authorization"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.String[]" name="login">
                  <init>
                    <methodInvokeExpression methodName="Split">
                      <target>
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
                                <methodInvokeExpression methodName="Substring">
                                  <target>
                                    <argumentReferenceExpression name="authorization"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="6"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </target>
                      <parameters>
                        <arrayCreateExpression>
                          <createType type="System.Char"/>
                          <initializers>
                            <primitiveExpression value=":" convertTo="Char"/>
                          </initializers>
                        </arrayCreateExpression>
                        <primitiveExpression value="2"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="ValidateUser">
                      <target>
                        <typeReferenceExpression type="Membership"/>
                      </target>
                      <parameters>
                        <arrayIndexerExpression>
                          <target>
                            <variableReferenceExpression name="login"/>
                          </target>
                          <indices>
                            <primitiveExpression value="0"/>
                          </indices>
                        </arrayIndexerExpression>
                        <arrayIndexerExpression>
                          <target>
                            <variableReferenceExpression name="login"/>
                          </target>
                          <indices>
                            <primitiveExpression value="1"/>
                          </indices>
                        </arrayIndexerExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <propertyReferenceExpression name="User">
                        <propertyReferenceExpression name="Context">
                          <argumentReferenceExpression name="app"/>
                        </propertyReferenceExpression>
                      </propertyReferenceExpression>
                      <objectCreateExpression type="RolePrincipal">
                        <parameters>
                          <objectCreateExpression type="FormsIdentity">
                            <parameters>
                              <objectCreateExpression type="FormsAuthenticationTicket">
                                <parameters>
                                  <arrayIndexerExpression>
                                    <target>
                                      <variableReferenceExpression name="login"/>
                                    </target>
                                    <indices>
                                      <primitiveExpression value="0"/>
                                    </indices>
                                  </arrayIndexerExpression>
                                  <primitiveExpression value="false"/>
                                  <primitiveExpression value="10"/>
                                </parameters>
                              </objectCreateExpression>
                            </parameters>
                          </objectCreateExpression>
                        </parameters>
                      </objectCreateExpression>
                    </assignStatement>
                  </trueStatements>
                  <falseStatements>
                    <assignStatement>
                      <propertyReferenceExpression name="StatusCode">
                        <propertyReferenceExpression name="Response">
                          <argumentReferenceExpression name="app"/>
                        </propertyReferenceExpression>
                      </propertyReferenceExpression>
                      <primitiveExpression value="401"/>
                    </assignStatement>
                    <assignStatement>
                      <propertyReferenceExpression name="StatusDescription">
                        <propertyReferenceExpression name="Response">
                          <argumentReferenceExpression name="app"/>
                        </propertyReferenceExpression>
                      </propertyReferenceExpression>
                      <primitiveExpression value="Access Denied"/>
                    </assignStatement>
                    <methodInvokeExpression methodName="Write">
                      <target>
                        <propertyReferenceExpression name="Response">
                          <argumentReferenceExpression name="app"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <primitiveExpression value="Access denied. Please enter a valid user name and password."/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="CompleteRequest">
                      <target>
                        <argumentReferenceExpression name="app"/>
                      </target>
                    </methodInvokeExpression>
                  </falseStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
      </types>
    </compileUnit>
  </xsl:template>
</xsl:stylesheet>
