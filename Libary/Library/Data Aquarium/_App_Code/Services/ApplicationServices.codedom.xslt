<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.codeontime.com/2008/codedom-compiler"  xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" xmlns:codeontime="urn:schemas-codeontime-com:ease"  exclude-result-prefixes="msxsl a codeontime"
>
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="TargetFramework" select="a:project/@targetFramework"/>
  <xsl:param name="ScriptOnly" select="a:project/a:features/a:framework/@scriptOnly"/>
  <xsl:param name="IsUnlimited"/>
  <xsl:param name="Mobile"/>
  <xsl:param name="ProjectId"/>

  <msxsl:script language="C#" implements-prefix="codeontime">
    <![CDATA[
    public string OptionValue(string map, string optionName, string defaultValue) { 
        map = "\r\n" + map;
        Match m = Regex.Match(map, @"$\s*option\s+(?'Name'.+?)\s*=\s*(?'Value'.+?)\s*(?:$)", RegexOptions.IgnoreCase | RegexOptions.Multiline);
        while (m.Success) {
           string name = Regex.Replace(m.Groups["Name"].Value, @"\s+", String.Empty);
           if (name.Equals(optionName, StringComparison.CurrentCultureIgnoreCase))
              return m.Groups["Value"].Value;
           m = m.NextMatch();
        }
        return defaultValue;
    } 
    ]]>
  </msxsl:script>


  <xsl:variable name="Namespace" select="a:project/a:namespace"/>

  <xsl:template match="/">
    <compileUnit namespace="{$Namespace}.Services">
      <imports>
        <namespaceImport name="System"/>
        <namespaceImport name="System.Collections.Generic"/>
        <namespaceImport name="System.IO"/>
        <namespaceImport name="System.Linq"/>
        <namespaceImport name="System.Text"/>
        <namespaceImport name="System.Text.RegularExpressions"/>
        <namespaceImport name="System.Web"/>
        <namespaceImport name="System.Web.UI"/>
        <namespaceImport name="System.Web.UI.HtmlControls"/>
        <namespaceImport name="System.Web.Security"/>
        <namespaceImport name="{$Namespace}.Data"/>
        <xsl:if test="$TargetFramework != '3.5'">
          <namespaceImport name="System.Web.Routing"/>
          <namespaceImport name="System.Drawing"/>
          <namespaceImport name="System.Drawing.Imaging"/>
        </xsl:if>
      </imports>
      <types>
        <!-- class ApplicationServices -->
        <typeDeclaration name="ApplicationServices" isPartial="true">
          <baseTypes>
            <xsl:choose>
              <xsl:when test="$IsUnlimited='true' and $TargetFramework != '3.5'">
                <typeReference type="EnterpriseApplicationServices"/>
              </xsl:when>
              <xsl:otherwise>
                <typeReference type="ApplicationServicesBase"/>
              </xsl:otherwise>
            </xsl:choose>
          </baseTypes>
          <members>
            <!-- method Initialize-->
            <memberMethod name="Initialize">
              <attributes static="true" public="true"/>
              <statements>
                <variableDeclarationStatement type="ApplicationServices" name="services">
                  <init>
                    <objectCreateExpression type="ApplicationServices"/>
                  </init>
                </variableDeclarationStatement>
                <methodInvokeExpression methodName="RegisterServices">
                  <target>
                    <variableReferenceExpression name="services"/>
                  </target>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- method Login(username, password, createPersistentCookie)-->
            <memberMethod returnType="System.Boolean" name="Login">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="System.String" name="username"/>
                <parameter type="System.String" name="password"/>
                <parameter type="System.Boolean" name="createPersistentCookie"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="ApplicationServices" name="services">
                  <init>
                    <objectCreateExpression type="ApplicationServices"/>
                  </init>
                </variableDeclarationStatement>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="UserLogin">
                    <target>
                      <variableReferenceExpression name="services"/>
                    </target>
                    <parameters>
                      <argumentReferenceExpression name="username"/>
                      <argumentReferenceExpression name="password"/>
                      <argumentReferenceExpression name="createPersistentCookie"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method Logout()-->
            <memberMethod name="Logout">
              <attributes public="true" static="true"/>
              <statements>
                <variableDeclarationStatement type="ApplicationServices" name="services">
                  <init>
                    <objectCreateExpression type="ApplicationServices"/>
                  </init>
                </variableDeclarationStatement>
                <methodInvokeExpression methodName="UserLogout">
                  <target>
                    <variableReferenceExpression name="services"/>
                  </target>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- method Roles()-->
            <memberMethod returnType="System.String[]" name="Roles">
              <attributes public="true" static="true"/>
              <statements>
                <variableDeclarationStatement type="ApplicationServices" name="services">
                  <init>
                    <objectCreateExpression type="ApplicationServices"/>
                  </init>
                </variableDeclarationStatement>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="UserRoles">
                    <target>
                      <variableReferenceExpression name="services"/>
                    </target>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
        <!-- class ApplicationServicesBase -->
        <typeDeclaration name="ApplicationServicesBase">
          <attributes public="true"/>
          <members>
            <memberField type="System.Boolean" name="EnableMobileClient">
              <attributes public="true" static="true"/>
              <init>
                <primitiveExpression value="true"/>
              </init>
            </memberField>
            <!-- property EnableMinifiedCss -->
            <memberField type="System.Boolean" name="enableMinifiedCss">
              <attributes static="true" private="true"/>
            </memberField>
            <memberProperty type="System.Boolean" name="EnableMinifiedCss">
              <attributes public="true" static="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="enableMinifiedCss"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="enableMinifiedCss"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>

            <xsl:if test="$IsUnlimited='true' and not($ProjectId='Mobile Factory') and a:project/@userInterface='Desktop'">
              <memberField type="Regex" name="MobileAgentBRegex">
                <attributes public="true" static="true"/>
                <init>
                  <objectCreateExpression type="Regex">
                    <parameters>
                      <primitiveExpression>
                        <xsl:attribute name="value"><![CDATA[(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino|android|ipad|playbook|silk]]></xsl:attribute>
                      </primitiveExpression>
                      <binaryOperatorExpression operator="BitwiseOr">
                        <propertyReferenceExpression name="IgnoreCase">
                          <typeReferenceExpression type="RegexOptions"/>
                        </propertyReferenceExpression>
                        <propertyReferenceExpression name="Multiline">
                          <typeReferenceExpression type="RegexOptions"/>
                        </propertyReferenceExpression>
                      </binaryOperatorExpression>
                    </parameters>
                  </objectCreateExpression>
                </init>
              </memberField>
              <memberField type="Regex" name="MobileAgentVRegex">
                <attributes public="true" static="true"/>
                <init>
                  <objectCreateExpression type="Regex">
                    <parameters>
                      <primitiveExpression>
                        <xsl:attribute name="value"><![CDATA[1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-]]></xsl:attribute>
                      </primitiveExpression>
                      <binaryOperatorExpression operator="BitwiseOr">
                        <propertyReferenceExpression name="IgnoreCase">
                          <typeReferenceExpression type="RegexOptions"/>
                        </propertyReferenceExpression>
                        <propertyReferenceExpression name="Multiline">
                          <typeReferenceExpression type="RegexOptions"/>
                        </propertyReferenceExpression>
                      </binaryOperatorExpression>
                    </parameters>
                  </objectCreateExpression>
                </init>
              </memberField>
            </xsl:if>
            <!-- method GetNavigateUrl()-->
            <memberMethod returnType="System.String" name="GetNavigateUrl">
              <attributes public="true"/>
              <statements>
                <methodReturnStatement>
                  <primitiveExpression value="null"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method VerifyUrl() -->
            <memberMethod name="VerifyUrl">
              <attributes static="true" public="true"/>
              <statements>
                <variableDeclarationStatement type="ApplicationServices" name="services">
                  <init>
                    <objectCreateExpression type="ApplicationServices"/>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.String" name="navigateUrl">
                  <init>
                    <methodInvokeExpression methodName="GetNavigateUrl">
                      <target>
                        <variableReferenceExpression name="services"/>
                      </target>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="IsNotNullOrEmpty">
                      <variableReferenceExpression name="navigateUrl"/>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="HttpContext" name="current">
                      <init>
                        <propertyReferenceExpression name="Current">
                          <typeReferenceExpression type="HttpContext"/>
                        </propertyReferenceExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="Not">
                          <methodInvokeExpression methodName="Equals">
                            <target>
                              <methodInvokeExpression methodName="ToAbsolute">
                                <target>
                                  <typeReferenceExpression type="VirtualPathUtility"/>
                                </target>
                                <parameters>
                                  <variableReferenceExpression name="navigateUrl"/>
                                </parameters>
                              </methodInvokeExpression>
                            </target>
                            <parameters>
                              <propertyReferenceExpression name="RawUrl">
                                <propertyReferenceExpression name="Request">
                                  <variableReferenceExpression name="current"/>
                                </propertyReferenceExpression>
                              </propertyReferenceExpression>
                              <propertyReferenceExpression name="CurrentCultureIgnoreCase">
                                <typeReferenceExpression type="StringComparison"/>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="Redirect">
                          <target>
                            <propertyReferenceExpression name="Response">
                              <variableReferenceExpression name="current"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="navigateUrl"/>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                  </trueStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method RegisterServices() -->
            <memberMethod name="RegisterServices">
              <attributes public="true"/>
              <statements>
                <methodInvokeExpression methodName="CreateStandardMembershipAccounts"/>
                <xsl:if test="$TargetFramework != '3.5'">
                  <methodInvokeExpression methodName="Map">
                    <target>
                      <typeReferenceExpression type="GenericRoute"/>
                    </target>
                    <parameters>
                      <propertyReferenceExpression name="Routes">
                        <typeReferenceExpression type="RouteTable"/>
                      </propertyReferenceExpression>
                      <objectCreateExpression type="PlaceholderHandler"/>
                      <primitiveExpression value="placeholder/{{FileName}}"/>
                    </parameters>
                  </methodInvokeExpression>
                </xsl:if>
              </statements>
            </memberMethod>
            <!-- method CreateStandardMembershipAccounts() -->
            <memberMethod name="CreateStandardMembershipAccounts">
              <attributes public="true"/>
              <statements>
                <xsl:if test="a:project/a:membership[@enabled='true' or @customSecurity='true' and codeontime:OptionValue(a:config, 'CreateStandardUserAccounts', 'true') != 'false']">
                  <comment>Create a separate code file with a definition of the partial class ApplicationServices overriding</comment>
                  <comment>this method to prevent automatic registration of 'admin' and 'user'. Do not change this file directly.</comment>
                  <methodInvokeExpression methodName="RegisterStandardMembershipAccounts"/>
                </xsl:if>
              </statements>
            </memberMethod>
            <!-- method RequiresAuthentication(HttpRequest) -->
            <memberMethod returnType="System.Boolean" name="RequiresAuthentication">
              <attributes public="true"/>
              <parameters>
                <parameter type="HttpRequest" name="request"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="EndsWith">
                    <target>
                      <propertyReferenceExpression name="Path">
                        <argumentReferenceExpression name="request"/>
                      </propertyReferenceExpression>
                    </target>
                    <parameters>
                      <primitiveExpression value="Export.ashx"/>
                      <propertyReferenceExpression name="CurrentCultureIgnoreCase">
                        <typeReferenceExpression type="StringComparison"/>
                      </propertyReferenceExpression>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method AuthenticateRequest(HttpContext context) -->
            <memberMethod returnType="System.Boolean" name="AuthenticateRequest">
              <attributes public="true"/>
              <parameters>
                <parameter type="HttpContext" name="context"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <primitiveExpression value="false"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method UserLogin(username password, createPersistentCookie)-->
            <memberMethod returnType="System.Boolean" name="UserLogin">
              <attributes public="true"/>
              <parameters>
                <parameter type="System.String" name="username"/>
                <parameter type="System.String" name="password"/>
                <parameter type="System.Boolean" name="createPersistentCookie"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <methodInvokeExpression methodName="ValidateUser">
                      <target>
                        <typeReferenceExpression type="Membership"/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="username"/>
                        <argumentReferenceExpression name="password"/>
                      </parameters>
                    </methodInvokeExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="SetAuthCookie">
                      <target>
                        <typeReferenceExpression type="FormsAuthentication"/>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="username"/>
                        <variableReferenceExpression name="createPersistentCookie"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodReturnStatement>
                      <primitiveExpression value="true"/>
                    </methodReturnStatement>
                  </trueStatements>
                  <falseStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="false"/>
                    </methodReturnStatement>
                  </falseStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method UserLogout()-->
            <memberMethod name="UserLogout">
              <attributes public="true"/>
              <statements>
                <methodInvokeExpression methodName="SignOut">
                  <target>
                    <typeReferenceExpression type="FormsAuthentication"/>
                  </target>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- method UserRoles()-->
            <memberMethod returnType="System.String[]" name="UserRoles">
              <attributes public="true"/>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="GetRolesForUser">
                    <target>
                      <typeReferenceExpression type="Roles"/>
                    </target>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- property Realm -->
            <memberProperty type="System.String" name="Realm">
              <attributes public="true"/>
              <getStatements>
                <methodReturnStatement>
                  <primitiveExpression value="{$Namespace} Application Services"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- method RegisterStandardMembershipAccounts() -->
            <memberMethod name="RegisterStandardMembershipAccounts">
              <attributes public="true" static="true"/>
              <statements>
                <variableDeclarationStatement type="MembershipUser" name="admin">
                  <init>
                    <methodInvokeExpression methodName="GetUser">
                      <target>
                        <typeReferenceExpression type="Membership"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="admin"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <binaryOperatorExpression operator="IdentityInequality">
                        <variableReferenceExpression name="admin"/>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                      <propertyReferenceExpression name="IsLockedOut">
                        <variableReferenceExpression name="admin"/>
                      </propertyReferenceExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="UnlockUser">
                      <target>
                        <variableReferenceExpression name="admin"/>
                      </target>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="MembershipUser" name="user">
                  <init>
                    <methodInvokeExpression methodName="GetUser">
                      <target>
                        <typeReferenceExpression type="Membership"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="user"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <binaryOperatorExpression operator="IdentityInequality">
                        <variableReferenceExpression name="user"/>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                      <propertyReferenceExpression name="IsLockedOut">
                        <variableReferenceExpression name="user"/>
                      </propertyReferenceExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="UnlockUser">
                      <target>
                        <variableReferenceExpression name="user"/>
                      </target>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <methodInvokeExpression methodName="GetUser">
                        <target>
                          <typeReferenceExpression type="Membership"/>
                        </target>
                        <parameters>
                          <primitiveExpression value="admin"/>
                        </parameters>
                      </methodInvokeExpression>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="MembershipCreateStatus" name="status"/>
                    <assignStatement>
                      <variableReferenceExpression name="admin"/>
                      <methodInvokeExpression methodName="CreateUser">
                        <target>
                          <typeReferenceExpression type="Membership"/>
                        </target>
                        <parameters>
                          <primitiveExpression value="admin"/>
                          <primitiveExpression value="admin123%"/>
                          <primitiveExpression value="admin@{$Namespace}.com"/>
                          <primitiveExpression value="ASP.NET"/>
                          <primitiveExpression value="Code OnTime"/>
                          <primitiveExpression value="true"/>
                          <directionExpression direction="Out">
                            <variableReferenceExpression name="status"/>
                          </directionExpression>
                        </parameters>
                      </methodInvokeExpression>
                    </assignStatement>
                    <assignStatement>
                      <variableReferenceExpression name="user"/>
                      <methodInvokeExpression methodName="CreateUser">
                        <target>
                          <typeReferenceExpression type="Membership"/>
                        </target>
                        <parameters>
                          <primitiveExpression value="user"/>
                          <primitiveExpression value="user123%"/>
                          <primitiveExpression value="user@{$Namespace}.com"/>
                          <primitiveExpression value="ASP.NET"/>
                          <primitiveExpression value="Code OnTime"/>
                          <primitiveExpression value="true"/>
                          <directionExpression direction="Out">
                            <variableReferenceExpression name="status"/>
                          </directionExpression>
                        </parameters>
                      </methodInvokeExpression>
                    </assignStatement>
                    <methodInvokeExpression methodName="CreateRole">
                      <target>
                        <typeReferenceExpression type="Roles"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="Administrators"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="CreateRole">
                      <target>
                        <typeReferenceExpression type="Roles"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="Users"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="AddUserToRole">
                      <target>
                        <typeReferenceExpression type="Roles"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="UserName">
                          <variableReferenceExpression name="admin"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="Users"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="AddUserToRole">
                      <target>
                        <typeReferenceExpression type="Roles"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="UserName">
                          <variableReferenceExpression name="user"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="Users"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="AddUserToRole">
                      <target>
                        <typeReferenceExpression type="Roles"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="UserName">
                          <variableReferenceExpression name="admin"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="Administrators"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- property IsMobileClient -->
            <xsl:choose>
              <xsl:when test="$IsUnlimited='true' and not($ProjectId='Mobile Factory') and $TargetFramework='4.5'">
                <!--<memberField type="Regex" name="MobileAgentBRegex">
                  <attributes public="true" static="true"/>
                  <init>
                    <objectCreateExpression type="Regex">
                      <parameters>
                        <primitiveExpression>
                          <xsl:attribute name="value"><![CDATA[(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows (ce|phone)|xda|xiino|android|ipad|playbook|silk]]></xsl:attribute>
                        </primitiveExpression>
                        <binaryOperatorExpression operator="BitwiseOr">
                          <propertyReferenceExpression name="IgnoreCase">
                            <typeReferenceExpression type="RegexOptions"/>
                          </propertyReferenceExpression>
                          <propertyReferenceExpression name="Multiline">
                            <typeReferenceExpression type="RegexOptions"/>
                          </propertyReferenceExpression>
                        </binaryOperatorExpression>
                      </parameters>
                    </objectCreateExpression>
                  </init>
                </memberField>
                <memberField type="Regex" name="MobileAgentVRegex">
                  <attributes public="true" static="true"/>
                  <init>
                    <objectCreateExpression type="Regex">
                      <parameters>
                        <primitiveExpression>
                          <xsl:attribute name="value"><![CDATA[1207|6310|6590|3gso|4thp|50[1-6]i|770s|802s|a wa|abac|ac(er|oo|s\-)|ai(ko|rn)|al(av|ca|co)|amoi|an(ex|ny|yw)|aptu|ar(ch|go)|as(te|us)|attw|au(di|\-m|r |s )|avan|be(ck|ll|nq)|bi(lb|rd)|bl(ac|az)|br(e|v)w|bumb|bw\-(n|u)|c55\/|capi|ccwa|cdm\-|cell|chtm|cldc|cmd\-|co(mp|nd)|craw|da(it|ll|ng)|dbte|dc\-s|devi|dica|dmob|do(c|p)o|ds(12|\-d)|el(49|ai)|em(l2|ul)|er(ic|k0)|esl8|ez([4-7]0|os|wa|ze)|fetc|fly(\-|_)|g1 u|g560|gene|gf\-5|g\-mo|go(\.w|od)|gr(ad|un)|haie|hcit|hd\-(m|p|t)|hei\-|hi(pt|ta)|hp( i|ip)|hs\-c|ht(c(\-| |_|a|g|p|s|t)|tp)|hu(aw|tc)|i\-(20|go|ma)|i230|iac( |\-|\/)|ibro|idea|ig01|ikom|im1k|inno|ipaq|iris|ja(t|v)a|jbro|jemu|jigs|kddi|keji|kgt( |\/)|klon|kpt |kwc\-|kyo(c|k)|le(no|xi)|lg( g|\/(k|l|u)|50|54|\-[a-w])|libw|lynx|m1\-w|m3ga|m50\/|ma(te|ui|xo)|mc(01|21|ca)|m\-cr|me(rc|ri)|mi(o8|oa|ts)|mmef|mo(01|02|bi|de|do|t(\-| |o|v)|zz)|mt(50|p1|v )|mwbp|mywa|n10[0-2]|n20[2-3]|n30(0|2)|n50(0|2|5)|n7(0(0|1)|10)|ne((c|m)\-|on|tf|wf|wg|wt)|nok(6|i)|nzph|o2im|op(ti|wv)|oran|owg1|p800|pan(a|d|t)|pdxg|pg(13|\-([1-8]|c))|phil|pire|pl(ay|uc)|pn\-2|po(ck|rt|se)|prox|psio|pt\-g|qa\-a|qc(07|12|21|32|60|\-[2-7]|i\-)|qtek|r380|r600|raks|rim9|ro(ve|zo)|s55\/|sa(ge|ma|mm|ms|ny|va)|sc(01|h\-|oo|p\-)|sdk\/|se(c(\-|0|1)|47|mc|nd|ri)|sgh\-|shar|sie(\-|m)|sk\-0|sl(45|id)|sm(al|ar|b3|it|t5)|so(ft|ny)|sp(01|h\-|v\-|v )|sy(01|mb)|t2(18|50)|t6(00|10|18)|ta(gt|lk)|tcl\-|tdg\-|tel(i|m)|tim\-|t\-mo|to(pl|sh)|ts(70|m\-|m3|m5)|tx\-9|up(\.b|g1|si)|utst|v400|v750|veri|vi(rg|te)|vk(40|5[0-3]|\-v)|vm40|voda|vulc|vx(52|53|60|61|70|80|81|83|85|98)|w3c(\-| )|webc|whit|wi(g |nc|nw)|wmlb|wonu|x700|yas\-|your|zeto|zte\-]]></xsl:attribute>
                        </primitiveExpression>
                        <binaryOperatorExpression operator="BitwiseOr">
                          <propertyReferenceExpression name="IgnoreCase">
                            <typeReferenceExpression type="RegexOptions"/>
                          </propertyReferenceExpression>
                          <propertyReferenceExpression name="Multiline">
                            <typeReferenceExpression type="RegexOptions"/>
                          </propertyReferenceExpression>
                        </binaryOperatorExpression>
                      </parameters>
                    </objectCreateExpression>
                  </init>
                </memberField>-->
                <!-- method ClientIsMobile() -->
                <memberMethod returnType="System.Boolean" name="ClientIsMobile">
                  <attributes public="true" static="true"/>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="Not">
                          <propertyReferenceExpression name="EnableMobileClient"/>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodReturnStatement>
                          <primitiveExpression value="false"/>
                        </methodReturnStatement>
                      </trueStatements>
                    </conditionStatement>
                    <variableDeclarationStatement type="HttpRequest" name="request">
                      <init>
                        <propertyReferenceExpression name="Request">
                          <propertyReferenceExpression name="Current">
                            <typeReferenceExpression type="HttpContext"/>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                      </init>
                    </variableDeclarationStatement>
                    <variableDeclarationStatement type="HttpCookie" name="mobileCookie">
                      <init>
                        <arrayIndexerExpression>
                          <target>
                            <propertyReferenceExpression name="Cookies">
                              <variableReferenceExpression name="request"/>
                            </propertyReferenceExpression>
                          </target>
                          <indices>
                            <primitiveExpression value="appfactorytouchui"/>
                          </indices>
                        </arrayIndexerExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityInequality">
                          <variableReferenceExpression name="mobileCookie"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodReturnStatement>
                          <binaryOperatorExpression operator="ValueEquality">
                            <propertyReferenceExpression name="Value">
                              <variableReferenceExpression name="mobileCookie"/>
                            </propertyReferenceExpression>
                            <primitiveExpression value="true" convertTo="String"/>
                          </binaryOperatorExpression>
                        </methodReturnStatement>
                      </trueStatements>
                    </conditionStatement>
                    <xsl:choose>
                      <xsl:when test=" a:project/@userInterface='TouchUI'">
                        <methodReturnStatement>
                          <primitiveExpression value="true"/>
                        </methodReturnStatement>
                      </xsl:when>
                      <xsl:otherwise>
                        <variableDeclarationStatement type="System.String" name="u">
                          <init>
                            <arrayIndexerExpression>
                              <target>
                                <propertyReferenceExpression name="ServerVariables">
                                  <variableReferenceExpression name="request"/>
                                </propertyReferenceExpression>
                              </target>
                              <indices>
                                <primitiveExpression value="HTTP_USER_AGENT"/>
                              </indices>
                            </arrayIndexerExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <unaryOperatorExpression operator="IsNullOrEmpty">
                              <variableReferenceExpression name="u"/>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <methodReturnStatement>
                              <primitiveExpression value="false"/>
                            </methodReturnStatement>
                          </trueStatements>
                        </conditionStatement>
                        <methodReturnStatement>
                          <binaryOperatorExpression operator="BooleanOr">
                            <methodInvokeExpression methodName="IsMatch">
                              <target>
                                <propertyReferenceExpression name="MobileAgentBRegex"/>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="u"/>
                              </parameters>
                            </methodInvokeExpression>
                            <methodInvokeExpression methodName="IsMatch">
                              <target>
                                <propertyReferenceExpression name="MobileAgentVRegex"/>
                              </target>
                              <parameters>
                                <methodInvokeExpression methodName="Substring">
                                  <target>
                                    <variableReferenceExpression name="u"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="0"/>
                                    <primitiveExpression value="4"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </binaryOperatorExpression>
                        </methodReturnStatement>
                      </xsl:otherwise>
                    </xsl:choose>
                    <!--<methodReturnStatement>
                      <binaryOperatorExpression operator="BooleanOr">
                        <methodInvokeExpression methodName="IsMatch">
                          <target>
                            <propertyReferenceExpression name="MobileAgentBRegex"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="u"/>
                          </parameters>
                        </methodInvokeExpression>
                        <methodInvokeExpression methodName="IsMatch">
                          <target>
                            <propertyReferenceExpression name="MobileAgentVRegex"/>
                          </target>
                          <parameters>
                            <methodInvokeExpression methodName="Substring">
                              <target>
                                <variableReferenceExpression name="u"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="0"/>
                                <primitiveExpression value="4"/>
                              </parameters>
                            </methodInvokeExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </binaryOperatorExpression>
                    </methodReturnStatement>-->
                  </statements>
                </memberMethod>
                <!-- property IsMobileClient-->
                <memberProperty type="System.Boolean" name="IsMobileClient">
                  <attributes public="true" static="true"/>
                  <getStatements>
                    <variableDeclarationStatement type="System.Object" name="isMobile">
                      <init>
                        <arrayIndexerExpression>
                          <target>
                            <propertyReferenceExpression name="Items">
                              <propertyReferenceExpression name="Current">
                                <typeReferenceExpression type="HttpContext"/>
                              </propertyReferenceExpression>
                            </propertyReferenceExpression>
                          </target>
                          <indices>
                            <primitiveExpression value="ApplicationServices_IsMobileClient"/>
                          </indices>
                        </arrayIndexerExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityEquality">
                          <variableReferenceExpression name="isMobile"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <variableReferenceExpression name="isMobile"/>
                          <methodInvokeExpression methodName="ClientIsMobile"/>
                        </assignStatement>
                        <assignStatement>
                          <arrayIndexerExpression>
                            <target>
                              <propertyReferenceExpression name="Items">
                                <propertyReferenceExpression name="Current">
                                  <typeReferenceExpression type="HttpContext"/>
                                </propertyReferenceExpression>
                              </propertyReferenceExpression>
                            </target>
                            <indices>
                              <primitiveExpression value="ApplicationServices_IsMobileClient"/>
                            </indices>
                          </arrayIndexerExpression>
                          <variableReferenceExpression name="isMobile"/>
                        </assignStatement>
                      </trueStatements>
                    </conditionStatement>
                    <methodReturnStatement>
                      <castExpression targetType="System.Boolean">
                        <variableReferenceExpression name="isMobile"/>
                      </castExpression>
                    </methodReturnStatement>
                  </getStatements>
                </memberProperty>
              </xsl:when>
              <xsl:when test="$ProjectId='Mobile Factory' or a:project/@userInterface='TouchUI'">
                <memberProperty type="System.Boolean" name="IsMobileClient">
                  <attributes public="true" static="true"/>
                  <getStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="true"/>
                    </methodReturnStatement>
                  </getStatements>
                </memberProperty>
              </xsl:when>
              <xsl:otherwise>
                <memberProperty type="System.Boolean" name="IsMobileClient">
                  <attributes public="true" static="true"/>
                  <getStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="false"/>
                    </methodReturnStatement>
                  </getStatements>
                </memberProperty>
              </xsl:otherwise>
            </xsl:choose>
            <!-- method RegisterCssLinks(Page) -->
            <memberMethod name="RegisterCssLinks">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="Page" name="p"/>
              </parameters>
              <statements>
                <xsl:choose>
                  <xsl:when test="$IsUnlimited='true' or a:project/@userInterface='Desktop'">
                    <foreachStatement>
                      <variable type="Control" name="c"/>
                      <target>
                        <propertyReferenceExpression name="Controls">
                          <propertyReferenceExpression name="Header">
                            <argumentReferenceExpression name="p"/>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                      </target>
                      <statements>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="IsTypeOf">
                              <variableReferenceExpression name="c"/>
                              <typeReferenceExpression type="HtmlLink"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <variableDeclarationStatement type="HtmlLink" name="l">
                              <init>
                                <castExpression targetType="HtmlLink">
                                  <variableReferenceExpression name="c"/>
                                </castExpression>
                              </init>
                            </variableDeclarationStatement>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="ValueEquality">
                                  <propertyReferenceExpression name="ID">
                                    <variableReferenceExpression name="l"/>
                                  </propertyReferenceExpression>
                                  <primitiveExpression value="{a:project/a:namespace}Theme"/>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <methodReturnStatement/>
                              </trueStatements>
                            </conditionStatement>
                            <conditionStatement>
                              <condition>
                                <methodInvokeExpression methodName="Contains">
                                  <target>
                                    <propertyReferenceExpression name="Href">
                                      <variableReferenceExpression name="l"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="_Theme_{a:project/a:theme/@name}.css"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <propertyReferenceExpression name="ID">
                                    <variableReferenceExpression name="l"/>
                                  </propertyReferenceExpression>
                                  <primitiveExpression value="{a:project/a:namespace}Theme"/>
                                </assignStatement>
                                <xsl:choose>
                                  <xsl:when test="$Mobile='true'">
                                    <conditionStatement>
                                      <condition>
                                        <propertyReferenceExpression name="IsMobileClient">
                                          <typeReferenceExpression type="ApplicationServices"/>
                                        </propertyReferenceExpression>
                                      </condition>
                                      <trueStatements>
                                        <variableDeclarationStatement type="System.String" name="jqmCss">
                                          <init>
                                            <stringFormatExpression format="jquery.mobile-{{0}}.min.css">
                                              <propertyReferenceExpression name="JqmVersion">
                                                <typeReferenceExpression type="ApplicationServices"/>
                                              </propertyReferenceExpression>
                                            </stringFormatExpression>
                                          </init>
                                        </variableDeclarationStatement>
                                        <assignStatement>
                                          <propertyReferenceExpression name="Href">
                                            <variableReferenceExpression name="l"/>
                                          </propertyReferenceExpression>
                                          <binaryOperatorExpression operator="Add">
                                            <primitiveExpression value="~/touch/"/>
                                            <variableReferenceExpression name="jqmCss"/>
                                          </binaryOperatorExpression>
                                        </assignStatement>
                                        <variableDeclarationStatement type="HtmlMeta" name="meta">
                                          <init>
                                            <objectCreateExpression type="HtmlMeta"/>
                                          </init>
                                        </variableDeclarationStatement>
                                        <assignStatement>
                                          <arrayIndexerExpression>
                                            <target>
                                              <propertyReferenceExpression name="Attributes">
                                                <variableReferenceExpression name="meta"/>
                                              </propertyReferenceExpression>
                                            </target>
                                            <indices>
                                              <primitiveExpression value="name"/>
                                            </indices>
                                          </arrayIndexerExpression>
                                          <primitiveExpression value="viewport"/>
                                        </assignStatement>
                                        <assignStatement>
                                          <arrayIndexerExpression>
                                            <target>
                                              <propertyReferenceExpression name="Attributes">
                                                <variableReferenceExpression name="meta"/>
                                              </propertyReferenceExpression>
                                            </target>
                                            <indices>
                                              <primitiveExpression value="content"/>
                                            </indices>
                                          </arrayIndexerExpression>
                                          <primitiveExpression value="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
                                        </assignStatement>
                                        <methodInvokeExpression methodName="AddAt">
                                          <target>
                                            <propertyReferenceExpression name="Controls">
                                              <propertyReferenceExpression name="Header">
                                                <argumentReferenceExpression name="p"/>
                                              </propertyReferenceExpression>
                                            </propertyReferenceExpression>
                                          </target>
                                          <parameters>
                                            <primitiveExpression value="0"/>
                                            <variableReferenceExpression name="meta"/>
                                          </parameters>
                                        </methodInvokeExpression>
                                        <variableDeclarationStatement type="System.Boolean" name="allowCompression">
                                          <init>
                                            <primitiveExpression>
                                              <xsl:attribute name="value">
                                                <xsl:choose>
                                                  <xsl:when test="$IsUnlimited='true'">
                                                    <xsl:text>true</xsl:text>
                                                  </xsl:when>
                                                  <xsl:otherwise>
                                                    <xsl:text>false</xsl:text>
                                                  </xsl:otherwise>
                                                </xsl:choose>
                                              </xsl:attribute>
                                            </primitiveExpression>
                                          </init>
                                        </variableDeclarationStatement>
                                        <conditionStatement>
                                          <condition>
                                            <binaryOperatorExpression operator="BooleanAnd">
                                              <propertyReferenceExpression name="EnableMinifiedCss">
                                                <typeReferenceExpression type="ApplicationServices"/>
                                              </propertyReferenceExpression>
                                              <variableReferenceExpression name="allowCompression"/>
                                            </binaryOperatorExpression>
                                          </condition>
                                          <trueStatements>
                                            <assignStatement>
                                              <propertyReferenceExpression name="Href">
                                                <variableReferenceExpression name="l"/>
                                              </propertyReferenceExpression>
                                              <methodInvokeExpression methodName="Format">
                                                <target>
                                                  <typeReferenceExpression type="System.String"/>
                                                </target>
                                                <parameters>
                                                  <primitiveExpression value="~/appservices/stylesheet-{{0}}.min.css"/>
                                                  <propertyReferenceExpression name="Version">
                                                    <typeReferenceExpression type="ApplicationServices"/>
                                                  </propertyReferenceExpression>
                                                </parameters>
                                              </methodInvokeExpression>
                                            </assignStatement>
                                          </trueStatements>
                                          <falseStatements>
                                            <foreachStatement>
                                              <variable type="System.String" name="stylesheet"/>
                                              <target>
                                                <methodInvokeExpression methodName="TouchUIStylesheets">
                                                  <target>
                                                    <typeReferenceExpression type="ApplicationServices"/>
                                                  </target>
                                                </methodInvokeExpression>
                                              </target>
                                              <statements>
                                                <conditionStatement>
                                                  <condition>
                                                    <unaryOperatorExpression operator="Not">
                                                      <methodInvokeExpression methodName="StartsWith">
                                                        <target>
                                                          <variableReferenceExpression name="stylesheet"/>
                                                        </target>
                                                        <parameters>
                                                          <primitiveExpression value="jquery.mobile"/>
                                                        </parameters>
                                                      </methodInvokeExpression>
                                                    </unaryOperatorExpression>
                                                  </condition>
                                                  <trueStatements>
                                                    <variableDeclarationStatement type="HtmlLink" name="cssLink">
                                                      <init>
                                                        <objectCreateExpression type="HtmlLink"/>
                                                      </init>
                                                    </variableDeclarationStatement>
                                                    <assignStatement>
                                                      <propertyReferenceExpression name="Href">
                                                        <variableReferenceExpression name="cssLink"/>
                                                      </propertyReferenceExpression>
                                                      <stringFormatExpression format="~/touch/{{0}}?{{1}}">
                                                        <variableReferenceExpression name="stylesheet"/>
                                                        <propertyReferenceExpression name="Version">
                                                          <typeReferenceExpression type="ApplicationServices"/>
                                                        </propertyReferenceExpression>
                                                      </stringFormatExpression>
                                                    </assignStatement>
                                                    <assignStatement>
                                                      <arrayIndexerExpression>
                                                        <target>
                                                          <propertyReferenceExpression name="Attributes">
                                                            <variableReferenceExpression name="cssLink"/>
                                                          </propertyReferenceExpression>
                                                        </target>
                                                        <indices>
                                                          <primitiveExpression value="type"/>
                                                        </indices>
                                                      </arrayIndexerExpression>
                                                      <primitiveExpression value="text/css"/>
                                                    </assignStatement>
                                                    <assignStatement>
                                                      <arrayIndexerExpression>
                                                        <target>
                                                          <propertyReferenceExpression name="Attributes">
                                                            <variableReferenceExpression name="cssLink"/>
                                                          </propertyReferenceExpression>
                                                        </target>
                                                        <indices>
                                                          <primitiveExpression value="rel"/>
                                                        </indices>
                                                      </arrayIndexerExpression>
                                                      <primitiveExpression value="stylesheet"/>
                                                    </assignStatement>
                                                    <methodInvokeExpression methodName="Add">
                                                      <target>
                                                        <propertyReferenceExpression name="Controls">
                                                          <propertyReferenceExpression name="Header">
                                                            <variableReferenceExpression name="p"/>
                                                          </propertyReferenceExpression>
                                                        </propertyReferenceExpression>
                                                      </target>
                                                      <parameters>
                                                        <variableReferenceExpression name="cssLink"/>
                                                      </parameters>
                                                    </methodInvokeExpression>
                                                  </trueStatements>
                                                </conditionStatement>
                                              </statements>
                                            </foreachStatement>
                                          </falseStatements>
                                        </conditionStatement>
                                        <variableDeclarationStatement type="List" name="removeList">
                                          <typeArguments>
                                            <typeReference type="Control"/>
                                          </typeArguments>
                                          <init>
                                            <objectCreateExpression type="List">
                                              <typeArguments>
                                                <typeReference type="Control"/>
                                              </typeArguments>
                                            </objectCreateExpression>
                                          </init>
                                        </variableDeclarationStatement>
                                        <foreachStatement>
                                          <variable type="Control" name="c2"/>
                                          <target>
                                            <propertyReferenceExpression name="Controls">
                                              <propertyReferenceExpression name="Header">
                                                <variableReferenceExpression name="p"/>
                                              </propertyReferenceExpression>
                                            </propertyReferenceExpression>
                                          </target>
                                          <statements>
                                            <conditionStatement>
                                              <condition>
                                                <binaryOperatorExpression operator="IsTypeOf">
                                                  <variableReferenceExpression name="c2"/>
                                                  <typeReferenceExpression type="HtmlLink"/>
                                                </binaryOperatorExpression>
                                              </condition>
                                              <trueStatements>
                                                <assignStatement>
                                                  <variableReferenceExpression name="l"/>
                                                  <castExpression targetType="HtmlLink">
                                                    <variableReferenceExpression name="c2"/>
                                                  </castExpression>
                                                </assignStatement>
                                                <conditionStatement>
                                                  <condition>
                                                    <methodInvokeExpression methodName="Contains">
                                                      <target>
                                                        <propertyReferenceExpression name="Href">
                                                          <variableReferenceExpression name="l"/>
                                                        </propertyReferenceExpression>
                                                      </target>
                                                      <parameters>
                                                        <primitiveExpression value="App_Themes/"/>
                                                      </parameters>
                                                    </methodInvokeExpression>
                                                  </condition>
                                                  <trueStatements>
                                                    <methodInvokeExpression methodName="Add">
                                                      <target>
                                                        <variableReferenceExpression name="removeList"/>
                                                      </target>
                                                      <parameters>
                                                        <variableReferenceExpression name="l"/>
                                                      </parameters>
                                                    </methodInvokeExpression>
                                                  </trueStatements>
                                                </conditionStatement>
                                              </trueStatements>
                                            </conditionStatement>
                                          </statements>
                                        </foreachStatement>
                                        <foreachStatement>
                                          <variable type="Control" name="c2"/>
                                          <target>
                                            <variableReferenceExpression name="removeList"/>
                                          </target>
                                          <statements>
                                            <methodInvokeExpression methodName="Remove">
                                              <target>
                                                <propertyReferenceExpression name="Controls">
                                                  <propertyReferenceExpression name="Header">
                                                    <variableReferenceExpression name="p"/>
                                                  </propertyReferenceExpression>
                                                </propertyReferenceExpression>
                                              </target>
                                              <parameters>
                                                <variableReferenceExpression name="c2"/>
                                              </parameters>
                                            </methodInvokeExpression>
                                          </statements>
                                        </foreachStatement>
                                        <methodReturnStatement/>
                                      </trueStatements>
                                      <falseStatements>
                                        <conditionStatement>
                                          <condition>
                                            <unaryOperatorExpression operator="Not">
                                              <methodInvokeExpression methodName="Contains">
                                                <target>
                                                  <propertyReferenceExpression name="Href">
                                                    <variableReferenceExpression name="l"/>
                                                  </propertyReferenceExpression>
                                                </target>
                                                <parameters>
                                                  <primitiveExpression value="?"/>
                                                </parameters>
                                              </methodInvokeExpression>
                                            </unaryOperatorExpression>
                                          </condition>
                                          <trueStatements>
                                            <assignStatement>
                                              <propertyReferenceExpression name="Href">
                                                <variableReferenceExpression name="l"/>
                                              </propertyReferenceExpression>
                                              <binaryOperatorExpression operator="Add">
                                                <propertyReferenceExpression name="Href">
                                                  <variableReferenceExpression name="l"/>
                                                </propertyReferenceExpression>
                                                <stringFormatExpression format="?{{0}}">
                                                  <propertyReferenceExpression name="Version">
                                                    <typeReferenceExpression type="ApplicationServices"/>
                                                  </propertyReferenceExpression>
                                                </stringFormatExpression>
                                                <!--<primitiveExpression value="?{$AppVersion}"/>-->
                                              </binaryOperatorExpression>
                                            </assignStatement>
                                          </trueStatements>
                                        </conditionStatement>
                                      </falseStatements>
                                    </conditionStatement>
                                  </xsl:when>
                                  <xsl:otherwise>
                                    <conditionStatement>
                                      <condition>
                                        <unaryOperatorExpression operator="Not">
                                          <methodInvokeExpression methodName="Contains">
                                            <target>
                                              <propertyReferenceExpression name="Href">
                                                <variableReferenceExpression name="l"/>
                                              </propertyReferenceExpression>
                                            </target>
                                            <parameters>
                                              <primitiveExpression value="?"/>
                                            </parameters>
                                          </methodInvokeExpression>
                                        </unaryOperatorExpression>
                                      </condition>
                                      <trueStatements>
                                        <assignStatement>
                                          <propertyReferenceExpression name="Href">
                                            <variableReferenceExpression name="l"/>
                                          </propertyReferenceExpression>
                                          <binaryOperatorExpression operator="Add">
                                            <propertyReferenceExpression name="Href">
                                              <variableReferenceExpression name="l"/>
                                            </propertyReferenceExpression>
                                            <stringFormatExpression format="?{{0}}">
                                              <propertyReferenceExpression name="Version">
                                                <typeReferenceExpression type="ApplicationServices"/>
                                              </propertyReferenceExpression>
                                            </stringFormatExpression>
                                          </binaryOperatorExpression>
                                        </assignStatement>
                                      </trueStatements>
                                    </conditionStatement>
                                  </xsl:otherwise>
                                </xsl:choose>
                                <methodReturnStatement/>
                              </trueStatements>
                            </conditionStatement>
                          </trueStatements>
                        </conditionStatement>
                      </statements>
                    </foreachStatement>
                  </xsl:when>
                  <xsl:otherwise>
                    <conditionStatement>
                      <condition>
                        <propertyReferenceExpression name="IsMobileClient">
                          <typeReferenceExpression type="ApplicationServices"/>
                        </propertyReferenceExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="HtmlLink" name="l">
                          <init>
                            <objectCreateExpression type="HtmlLink"/>
                          </init>
                        </variableDeclarationStatement>
                        <assignStatement>
                          <propertyReferenceExpression name="ID">
                            <variableReferenceExpression name="l"/>
                          </propertyReferenceExpression>
                          <primitiveExpression value="{a:project/a:namespace}Theme"/>
                        </assignStatement>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <propertyReferenceExpression name="Attributes">
                              <variableReferenceExpression name="l"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <primitiveExpression value="type"/>
                            <primitiveExpression value="text/css"/>
                          </parameters>
                        </methodInvokeExpression>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <propertyReferenceExpression name="Attributes">
                              <variableReferenceExpression name="l"/>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <primitiveExpression value="rel"/>
                            <primitiveExpression value="stylesheet"/>
                          </parameters>
                        </methodInvokeExpression>
                        <variableDeclarationStatement type="System.String" name="jqmCss">
                          <init>
                            <stringFormatExpression format="jquery.mobile-{{0}}.min.css">
                              <propertyReferenceExpression name="JqmVersion">
                                <typeReferenceExpression type="ApplicationServices"/>
                              </propertyReferenceExpression>
                            </stringFormatExpression>
                          </init>
                        </variableDeclarationStatement>
                        <assignStatement>
                          <propertyReferenceExpression name="Href">
                            <variableReferenceExpression name="l"/>
                          </propertyReferenceExpression>
                          <binaryOperatorExpression operator="Add">
                            <primitiveExpression value="~/touch/"/>
                            <variableReferenceExpression name="jqmCss"/>
                          </binaryOperatorExpression>
                        </assignStatement>
                        <variableDeclarationStatement type="HtmlMeta" name="meta">
                          <init>
                            <objectCreateExpression type="HtmlMeta"/>
                          </init>
                        </variableDeclarationStatement>
                        <assignStatement>
                          <arrayIndexerExpression>
                            <target>
                              <propertyReferenceExpression name="Attributes">
                                <variableReferenceExpression name="meta"/>
                              </propertyReferenceExpression>
                            </target>
                            <indices>
                              <primitiveExpression value="name"/>
                            </indices>
                          </arrayIndexerExpression>
                          <primitiveExpression value="viewport"/>
                        </assignStatement>
                        <assignStatement>
                          <arrayIndexerExpression>
                            <target>
                              <propertyReferenceExpression name="Attributes">
                                <variableReferenceExpression name="meta"/>
                              </propertyReferenceExpression>
                            </target>
                            <indices>
                              <primitiveExpression value="content"/>
                            </indices>
                          </arrayIndexerExpression>
                          <primitiveExpression value="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/>
                        </assignStatement>
                        <methodInvokeExpression methodName="AddAt">
                          <target>
                            <propertyReferenceExpression name="Controls">
                              <propertyReferenceExpression name="Header">
                                <argumentReferenceExpression name="p"/>
                              </propertyReferenceExpression>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <primitiveExpression value="0"/>
                            <variableReferenceExpression name="meta"/>
                          </parameters>
                        </methodInvokeExpression>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <propertyReferenceExpression name="Controls">
                              <propertyReferenceExpression name="Header">
                                <argumentReferenceExpression name="p"/>
                              </propertyReferenceExpression>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <castExpression targetType="Control">
                              <variableReferenceExpression name="l"/>
                            </castExpression>
                          </parameters>
                        </methodInvokeExpression>
                        <comment>enumerate custom css files</comment>
                        <variableDeclarationStatement type="System.String" name="mobilePath">
                          <init>
                            <methodInvokeExpression methodName="GetDirectoryName">
                              <target>
                                <typeReferenceExpression type="Path"/>
                              </target>
                              <parameters>
                                <methodInvokeExpression methodName="MapPath">
                                  <target>
                                    <propertyReferenceExpression name="Server">
                                      <argumentReferenceExpression name="p"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="~/touch/"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <variableDeclarationStatement type="SortedDictionary" name="cssFiles">
                          <typeArguments>
                            <typeReference type="System.String"/>
                            <typeReference type="System.String"/>
                          </typeArguments>
                          <init>
                            <objectCreateExpression type="SortedDictionary">
                              <typeArguments>
                                <typeReference type="System.String"/>
                                <typeReference type="System.String"/>
                              </typeArguments>
                            </objectCreateExpression>
                          </init>
                        </variableDeclarationStatement>
                        <variableDeclarationStatement type="List" name="minifiedCssFiles">
                          <typeArguments>
                            <typeReference type="System.String"/>
                          </typeArguments>
                          <init>
                            <objectCreateExpression type="List">
                              <typeArguments>
                                <typeReference type="System.String"/>
                              </typeArguments>
                            </objectCreateExpression>
                          </init>
                        </variableDeclarationStatement>
                        <foreachStatement>
                          <variable type="System.String" name="css"/>
                          <target>
                            <methodInvokeExpression methodName="GetFiles">
                              <target>
                                <typeReferenceExpression type="Directory"/>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="mobilePath"/>
                                <primitiveExpression value="*.css"/>
                              </parameters>
                            </methodInvokeExpression>
                          </target>
                          <statements>
                            <conditionStatement>
                              <condition>
                                <unaryOperatorExpression operator="Not">
                                  <methodInvokeExpression methodName="Contains">
                                    <target>
                                      <variableReferenceExpression name="css"/>
                                    </target>
                                    <parameters>
                                      <primitiveExpression value="jquery.mobile"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                </unaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <arrayIndexerExpression>
                                    <target>
                                      <variableReferenceExpression name="cssFiles"/>
                                    </target>
                                    <indices>
                                      <variableReferenceExpression name="css"/>
                                    </indices>
                                  </arrayIndexerExpression>
                                  <variableReferenceExpression name="css"/>
                                </assignStatement>
                                <conditionStatement>
                                  <condition>
                                    <methodInvokeExpression methodName="EndsWith">
                                      <target>
                                        <variableReferenceExpression name="css"/>
                                      </target>
                                      <parameters>
                                        <primitiveExpression value=".min.css"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </condition>
                                  <trueStatements>
                                    <conditionStatement>
                                      <condition>
                                        <propertyReferenceExpression name="EnableMinifiedCss"/>
                                      </condition>
                                      <trueStatements>
                                        <methodInvokeExpression methodName="Add">
                                          <target>
                                            <variableReferenceExpression name="minifiedCssFiles"/>
                                          </target>
                                          <parameters>
                                            <binaryOperatorExpression operator="Add">
                                              <methodInvokeExpression methodName="Substring">
                                                <target>
                                                  <variableReferenceExpression name="css"/>
                                                </target>
                                                <parameters>
                                                  <primitiveExpression value="0"/>
                                                  <binaryOperatorExpression operator="Subtract">
                                                    <propertyReferenceExpression name="Length">
                                                      <variableReferenceExpression name="css"/>
                                                    </propertyReferenceExpression>
                                                    <primitiveExpression value="7"/>
                                                  </binaryOperatorExpression>
                                                </parameters>
                                              </methodInvokeExpression>
                                              <primitiveExpression value="css"/>
                                            </binaryOperatorExpression>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </trueStatements>
                                      <falseStatements>
                                        <methodInvokeExpression methodName="Remove">
                                          <target>
                                            <variableReferenceExpression name="cssFiles"/>
                                          </target>
                                          <parameters>
                                            <variableReferenceExpression name="css"/>
                                          </parameters>
                                        </methodInvokeExpression>
                                      </falseStatements>
                                    </conditionStatement>
                                  </trueStatements>
                                </conditionStatement>
                              </trueStatements>
                            </conditionStatement>
                          </statements>
                        </foreachStatement>
                        <foreachStatement>
                          <variable type="System.String" name="css"/>
                          <target>
                            <variableReferenceExpression name="minifiedCssFiles"/>
                          </target>
                          <statements>
                            <methodInvokeExpression methodName="Remove">
                              <target>
                                <variableReferenceExpression name="cssFiles"/>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="css"/>
                              </parameters>
                            </methodInvokeExpression>
                          </statements>
                        </foreachStatement>

                        <foreachStatement>
                          <variable type="System.String" name="fileName"/>
                          <target>
                            <propertyReferenceExpression name="Keys">
                              <variableReferenceExpression name="cssFiles"/>
                            </propertyReferenceExpression>
                          </target>
                          <statements>
                            <variableDeclarationStatement type="System.String" name="cssFile">
                              <init>
                                <methodInvokeExpression methodName="GetFileName">
                                  <target>
                                    <typeReferenceExpression type="Path"/>
                                  </target>
                                  <parameters>
                                    <variableReferenceExpression name="fileName"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </init>
                            </variableDeclarationStatement>
                            <variableDeclarationStatement type="HtmlLink" name="cssLink">
                              <init>
                                <objectCreateExpression type="HtmlLink"/>
                              </init>
                            </variableDeclarationStatement>
                            <assignStatement>
                              <propertyReferenceExpression name="Href">
                                <variableReferenceExpression name="cssLink"/>
                              </propertyReferenceExpression>
                              <stringFormatExpression format="~/touch/{{0}}?{{1}}">
                                <variableReferenceExpression name="cssFile"/>
                                <propertyReferenceExpression name="Version">
                                  <typeReferenceExpression type="ApplicationServices"/>
                                </propertyReferenceExpression>
                              </stringFormatExpression>
                            </assignStatement>
                            <assignStatement>
                              <arrayIndexerExpression>
                                <target>
                                  <propertyReferenceExpression name="Attributes">
                                    <variableReferenceExpression name="cssLink"/>
                                  </propertyReferenceExpression>
                                </target>
                                <indices>
                                  <primitiveExpression value="type"/>
                                </indices>
                              </arrayIndexerExpression>
                              <primitiveExpression value="text/css"/>
                            </assignStatement>
                            <assignStatement>
                              <arrayIndexerExpression>
                                <target>
                                  <propertyReferenceExpression name="Attributes">
                                    <variableReferenceExpression name="cssLink"/>
                                  </propertyReferenceExpression>
                                </target>
                                <indices>
                                  <primitiveExpression value="rel"/>
                                </indices>
                              </arrayIndexerExpression>
                              <primitiveExpression value="stylesheet"/>
                            </assignStatement>
                            <methodInvokeExpression methodName="Add">
                              <target>
                                <propertyReferenceExpression name="Controls">
                                  <propertyReferenceExpression name="Header">
                                    <argumentReferenceExpression name="p"/>
                                  </propertyReferenceExpression>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="cssLink"/>
                              </parameters>
                            </methodInvokeExpression>
                          </statements>
                        </foreachStatement>
                        <variableDeclarationStatement type="List" name="removeList">
                          <typeArguments>
                            <typeReference type="Control"/>
                          </typeArguments>
                          <init>
                            <objectCreateExpression type="List">
                              <typeArguments>
                                <typeReference type="Control"/>
                              </typeArguments>
                            </objectCreateExpression>
                          </init>
                        </variableDeclarationStatement>
                        <foreachStatement>
                          <variable type="Control" name="c2"/>
                          <target>
                            <propertyReferenceExpression name="Controls">
                              <propertyReferenceExpression name="Header">
                                <variableReferenceExpression name="p"/>
                              </propertyReferenceExpression>
                            </propertyReferenceExpression>
                          </target>
                          <statements>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="IsTypeOf">
                                  <variableReferenceExpression name="c2"/>
                                  <typeReferenceExpression type="HtmlLink"/>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="l"/>
                                  <castExpression targetType="HtmlLink">
                                    <variableReferenceExpression name="c2"/>
                                  </castExpression>
                                </assignStatement>
                                <conditionStatement>
                                  <condition>
                                    <methodInvokeExpression methodName="Contains">
                                      <target>
                                        <propertyReferenceExpression name="Href">
                                          <variableReferenceExpression name="l"/>
                                        </propertyReferenceExpression>
                                      </target>
                                      <parameters>
                                        <primitiveExpression value="App_Themes/"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </condition>
                                  <trueStatements>
                                    <methodInvokeExpression methodName="Add">
                                      <target>
                                        <variableReferenceExpression name="removeList"/>
                                      </target>
                                      <parameters>
                                        <variableReferenceExpression name="l"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </trueStatements>
                                </conditionStatement>
                              </trueStatements>
                            </conditionStatement>
                          </statements>
                        </foreachStatement>
                        <foreachStatement>
                          <variable type="Control" name="c2"/>
                          <target>
                            <variableReferenceExpression name="removeList"/>
                          </target>
                          <statements>
                            <methodInvokeExpression methodName="Remove">
                              <target>
                                <propertyReferenceExpression name="Controls">
                                  <propertyReferenceExpression name="Header">
                                    <variableReferenceExpression name="p"/>
                                  </propertyReferenceExpression>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="c2"/>
                              </parameters>
                            </methodInvokeExpression>
                          </statements>
                        </foreachStatement>
                      </trueStatements>
                    </conditionStatement>
                  </xsl:otherwise>
                </xsl:choose>
              </statements>
            </memberMethod>
            <!-- method AllowTouchUIStylesheet(String) -->
            <memberMethod returnType="System.Boolean" name="AllowTouchUIStylesheet">
              <attributes family="true"/>
              <parameters>
                <parameter type="System.String" name="name"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <primitiveExpression value="true"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method TouchUIStylesheets-->
            <memberMethod returnType="List" name="TouchUIStylesheets">
              <typeArguments>
                <typeReference type="System.String"/>
              </typeArguments>
              <attributes static="true" public="true"/>
              <statements>
                <variableDeclarationStatement type="ApplicationServices" name="services">
                  <init>
                    <objectCreateExpression type="ApplicationServices"/>
                  </init>
                </variableDeclarationStatement>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="EnumerateTouchUIStylesheets">
                    <target>
                      <variableReferenceExpression name="services"/>
                    </target>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method EnumerateTouchUIStylesheets() -->
            <memberMethod returnType="List" name="EnumerateTouchUIStylesheets">
              <typeArguments>
                <typeReference type="System.String"/>
              </typeArguments>
              <attributes public="true" />
              <statements>
                <variableDeclarationStatement type="List" name="stylesheets">
                  <typeArguments>
                    <typeReference type="System.String"/>
                  </typeArguments>
                  <init>
                    <objectCreateExpression type="List">
                      <typeArguments>
                        <typeReference type="System.String"/>
                      </typeArguments>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <variableReferenceExpression name="stylesheets"/>
                  </target>
                  <parameters>
                    <methodInvokeExpression methodName="Format">
                      <target>
                        <typeReferenceExpression type="System.String"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="jquery.mobile-{{0}}.min.css"/>
                        <propertyReferenceExpression name="JqmVersion">
                          <typeReferenceExpression type="ApplicationServices"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </parameters>
                </methodInvokeExpression>
                <comment>enumerate custom css files</comment>
                <variableDeclarationStatement type="System.String" name="mobilePath">
                  <init>
                    <methodInvokeExpression methodName="GetDirectoryName">
                      <target>
                        <typeReferenceExpression type="Path"/>
                      </target>
                      <parameters>
                        <methodInvokeExpression methodName="MapPath">
                          <target>
                            <propertyReferenceExpression name="Server">
                              <propertyReferenceExpression name="Current">
                                <typeReferenceExpression type="HttpContext"/>
                              </propertyReferenceExpression>
                            </propertyReferenceExpression>
                          </target>
                          <parameters>
                            <primitiveExpression value="~/touch/"/>
                          </parameters>
                        </methodInvokeExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="SortedDictionary" name="cssFiles">
                  <typeArguments>
                    <typeReference type="System.String"/>
                    <typeReference type="System.String"/>
                  </typeArguments>
                  <init>
                    <objectCreateExpression type="SortedDictionary">
                      <typeArguments>
                        <typeReference type="System.String"/>
                        <typeReference type="System.String"/>
                      </typeArguments>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="List" name="minifiedCssFiles">
                  <typeArguments>
                    <typeReference type="System.String"/>
                  </typeArguments>
                  <init>
                    <objectCreateExpression type="List">
                      <typeArguments>
                        <typeReference type="System.String"/>
                      </typeArguments>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <foreachStatement>
                  <variable type="System.String" name="css"/>
                  <target>
                    <methodInvokeExpression methodName="GetFiles">
                      <target>
                        <typeReferenceExpression type="Directory"/>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="mobilePath"/>
                        <primitiveExpression value="*.css"/>
                      </parameters>
                    </methodInvokeExpression>
                  </target>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <unaryOperatorExpression operator="Not">
                          <methodInvokeExpression methodName="Contains">
                            <target>
                              <variableReferenceExpression name="css"/>
                            </target>
                            <parameters>
                              <primitiveExpression value="jquery.mobile"/>
                            </parameters>
                          </methodInvokeExpression>
                        </unaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <assignStatement>
                          <arrayIndexerExpression>
                            <target>
                              <variableReferenceExpression name="cssFiles"/>
                            </target>
                            <indices>
                              <variableReferenceExpression name="css"/>
                            </indices>
                          </arrayIndexerExpression>
                          <variableReferenceExpression name="css"/>
                        </assignStatement>
                        <conditionStatement>
                          <condition>
                            <methodInvokeExpression methodName="EndsWith">
                              <target>
                                <variableReferenceExpression name="css"/>
                              </target>
                              <parameters>
                                <primitiveExpression value=".min.css"/>
                              </parameters>
                            </methodInvokeExpression>
                          </condition>
                          <trueStatements>
                            <conditionStatement>
                              <condition>
                                <propertyReferenceExpression name="EnableMinifiedCss"/>
                              </condition>
                              <trueStatements>
                                <methodInvokeExpression methodName="Add">
                                  <target>
                                    <variableReferenceExpression name="minifiedCssFiles"/>
                                  </target>
                                  <parameters>
                                    <binaryOperatorExpression operator="Add">
                                      <methodInvokeExpression methodName="Substring">
                                        <target>
                                          <variableReferenceExpression name="css"/>
                                        </target>
                                        <parameters>
                                          <primitiveExpression value="0"/>
                                          <binaryOperatorExpression operator="Subtract">
                                            <propertyReferenceExpression name="Length">
                                              <variableReferenceExpression name="css"/>
                                            </propertyReferenceExpression>
                                            <primitiveExpression value="7"/>
                                          </binaryOperatorExpression>
                                        </parameters>
                                      </methodInvokeExpression>
                                      <primitiveExpression value="css"/>
                                    </binaryOperatorExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </trueStatements>
                              <falseStatements>
                                <methodInvokeExpression methodName="Remove">
                                  <target>
                                    <variableReferenceExpression name="cssFiles"/>
                                  </target>
                                  <parameters>
                                    <variableReferenceExpression name="css"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </falseStatements>
                            </conditionStatement>
                          </trueStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
                <foreachStatement>
                  <variable type="System.String" name="css"/>
                  <target>
                    <variableReferenceExpression name="minifiedCssFiles"/>
                  </target>
                  <statements>
                    <methodInvokeExpression methodName="Remove">
                      <target>
                        <variableReferenceExpression name="cssFiles"/>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="css"/>
                      </parameters>
                    </methodInvokeExpression>
                  </statements>
                </foreachStatement>
                <foreachStatement>
                  <variable type="System.String" name="fileName"/>
                  <target>
                    <propertyReferenceExpression name="Keys">
                      <variableReferenceExpression name="cssFiles"/>
                    </propertyReferenceExpression>
                  </target>
                  <statements>
                    <variableDeclarationStatement type="System.String" name="cssFile">
                      <init>
                        <methodInvokeExpression methodName="GetFileName">
                          <target>
                            <typeReferenceExpression type="Path"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="fileName"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <methodInvokeExpression methodName="AllowTouchUIStylesheet">
                          <parameters>
                            <variableReferenceExpression name="fileName"/>
                          </parameters>
                        </methodInvokeExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <variableReferenceExpression name="stylesheets"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="cssFile"/>
                          </parameters>
                        </methodInvokeExpression>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
                <methodReturnStatement>
                  <variableReferenceExpression name="stylesheets"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- field CssUrlRegex -->
            <memberField type="Regex" name="CssUrlRegex">
              <attributes private="true" static="true"/>
              <init>
                <objectCreateExpression type="Regex">
                  <parameters>
                    <primitiveExpression>
                      <xsl:attribute name="value"><![CDATA[(?'Header'\burl\s*\(\s*(\&quot;|\')?)(?'Name'\w+)(?'Symbol'\S)]]></xsl:attribute>
                    </primitiveExpression>
                  </parameters>
                </objectCreateExpression>
              </init>
            </memberField>
            <!-- method DoReplaceCssUrl(Match) -->
            <memberMethod returnType="System.String" name="DoReplaceCssUrl">
              <attributes private="true" static="true"/>
              <parameters>
                <parameter type="Match" name="m"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.String" name="header">
                  <init>
                    <propertyReferenceExpression name="Value">
                      <arrayIndexerExpression>
                        <target>
                          <propertyReferenceExpression name="Groups">
                            <argumentReferenceExpression name="m"/>
                          </propertyReferenceExpression>
                        </target>
                        <indices>
                          <primitiveExpression value="Header"/>
                        </indices>
                      </arrayIndexerExpression>
                    </propertyReferenceExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.String" name="name">
                  <init>
                    <propertyReferenceExpression name="Value">
                      <arrayIndexerExpression>
                        <target>
                          <propertyReferenceExpression name="Groups">
                            <argumentReferenceExpression name="m"/>
                          </propertyReferenceExpression>
                        </target>
                        <indices>
                          <primitiveExpression value="Name"/>
                        </indices>
                      </arrayIndexerExpression>
                    </propertyReferenceExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.String" name="symbol">
                  <init>
                    <propertyReferenceExpression name="Value">
                      <arrayIndexerExpression>
                        <target>
                          <propertyReferenceExpression name="Groups">
                            <argumentReferenceExpression name="m"/>
                          </propertyReferenceExpression>
                        </target>
                        <indices>
                          <primitiveExpression value="Symbol"/>
                        </indices>
                      </arrayIndexerExpression>
                    </propertyReferenceExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <binaryOperatorExpression operator="ValueEquality">
                        <variableReferenceExpression name="name"/>
                        <primitiveExpression value="data"/>
                      </binaryOperatorExpression>
                      <binaryOperatorExpression operator="ValueEquality">
                        <variableReferenceExpression name="symbol"/>
                        <primitiveExpression value=":"/>
                      </binaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <propertyReferenceExpression name="Value">
                        <argumentReferenceExpression name="m"/>
                      </propertyReferenceExpression>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <binaryOperatorExpression operator="Add">
                    <variableReferenceExpression name="header"/>
                    <binaryOperatorExpression operator="Add">
                      <primitiveExpression value="../touch/"/>
                      <binaryOperatorExpression operator="Add">
                        <variableReferenceExpression name="name"/>
                        <variableReferenceExpression name="symbol"/>
                      </binaryOperatorExpression>
                    </binaryOperatorExpression>
                  </binaryOperatorExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method CombineTouchUIStylesheets(HttpContext)-->
            <memberMethod returnType="System.String" name="CombineTouchUIStylesheets">
              <attributes public="true" static="true"/>
              <parameters>
                <parameter type="HttpContext" name="context"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="HttpResponse" name="response">
                  <init>
                    <propertyReferenceExpression name="Response">
                      <argumentReferenceExpression name="context"/>
                    </propertyReferenceExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="HttpCachePolicy" name="cache">
                  <init>
                    <propertyReferenceExpression name="Cache">
                      <variableReferenceExpression name="response"/>
                    </propertyReferenceExpression>
                  </init>
                </variableDeclarationStatement>
                <methodInvokeExpression methodName="SetCacheability">
                  <target>
                    <variableReferenceExpression name="cache"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Public">
                      <typeReferenceExpression type="HttpCacheability"/>
                    </propertyReferenceExpression>
                  </parameters>
                </methodInvokeExpression>
                <!--<assignStatement>
                  <arrayIndexerExpression>
                    <target>
                      <propertyReferenceExpression name="VaryByParams">
                        <variableReferenceExpression name="cache"/>
                      </propertyReferenceExpression>
                    </target>
                    <indices>
                      <primitiveExpression value="_mobile"/>
                    </indices>
                  </arrayIndexerExpression>
                  <primitiveExpression value="true"/>
                </assignStatement>-->
                <assignStatement>
                  <arrayIndexerExpression>
                    <target>
                      <propertyReferenceExpression name="VaryByHeaders">
                        <variableReferenceExpression name="cache"/>
                      </propertyReferenceExpression>
                    </target>
                    <indices>
                      <primitiveExpression value="User-Agent"/>
                    </indices>
                  </arrayIndexerExpression>
                  <primitiveExpression value="true"/>
                </assignStatement>
                <methodInvokeExpression methodName="SetOmitVaryStar">
                  <target>
                    <variableReferenceExpression name="cache"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="true"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="SetExpires">
                  <target>
                    <variableReferenceExpression name="cache"/>
                  </target>
                  <parameters>
                    <methodInvokeExpression methodName="AddDays">
                      <target>
                        <propertyReferenceExpression name="Now">
                          <typeReferenceExpression type="DateTime"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <primitiveExpression value="365"/>
                      </parameters>
                    </methodInvokeExpression>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="SetValidUntilExpires">
                  <target>
                    <variableReferenceExpression name="cache"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="true"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="SetLastModifiedFromFileDependencies">
                  <target>
                    <variableReferenceExpression name="cache"/>
                  </target>
                </methodInvokeExpression>
                <comment>combine scripts</comment>
                <variableDeclarationStatement type="StringBuilder" name="sb">
                  <init>
                    <objectCreateExpression type="StringBuilder"/>
                  </init>
                </variableDeclarationStatement>
                <foreachStatement>
                  <variable type="System.String" name="stylesheet"/>
                  <target>
                    <methodInvokeExpression methodName="TouchUIStylesheets">
                      <target>
                        <typeReferenceExpression type="ApplicationServices"/>
                      </target>
                    </methodInvokeExpression>
                  </target>
                  <statements>
                    <variableDeclarationStatement type="System.String" name="data">
                      <init>
                        <methodInvokeExpression methodName="ReadAllText">
                          <target>
                            <typeReferenceExpression type="File"/>
                          </target>
                          <parameters>
                            <methodInvokeExpression methodName="MapPath">
                              <target>
                                <propertyReferenceExpression name="Server">
                                  <propertyReferenceExpression name="Current">
                                    <typeReferenceExpression type="HttpContext"/>
                                  </propertyReferenceExpression>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <binaryOperatorExpression operator="Add">
                                  <primitiveExpression value="~/touch/"/>
                                  <variableReferenceExpression name="stylesheet"/>
                                </binaryOperatorExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <assignStatement>
                      <variableReferenceExpression name="data"/>
                      <methodInvokeExpression methodName="Replace">
                        <target>
                          <fieldReferenceExpression name="CssUrlRegex"/>
                        </target>
                        <parameters>
                          <variableReferenceExpression name="data"/>
                          <addressOfExpression>
                            <methodReferenceExpression methodName="DoReplaceCssUrl"/>
                          </addressOfExpression>
                        </parameters>
                      </methodInvokeExpression>
                    </assignStatement>
                    <methodInvokeExpression methodName="AppendLine">
                      <target>
                        <variableReferenceExpression name="sb"/>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="data"/>
                      </parameters>
                    </methodInvokeExpression>
                  </statements>
                </foreachStatement>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="ToString">
                    <target>
                      <variableReferenceExpression name="sb"/>
                    </target>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
        <!-- class ApplicationSiteMapProvider -->
        <typeDeclaration isPartial="true" name="ApplicationSiteMapProvider">
          <attributes public="true"/>
          <baseTypes>
            <typeReference type="ApplicationSiteMapProviderBase"/>
          </baseTypes>
        </typeDeclaration>
        <!-- class ApplicationSiteMapProviderBase -->
        <typeDeclaration name="ApplicationSiteMapProviderBase">
          <attributes public="true"/>
          <baseTypes>
            <typeReference type="System.Web.XmlSiteMapProvider"/>
          </baseTypes>
          <members>
            <!-- IsAccessibleToUser(HttpContext, SiteMapNode) -->
            <memberMethod returnType="System.Boolean" name="IsAccessibleToUser">
              <attributes public="true" override="true"/>
              <parameters>
                <parameter type="HttpContext" name="context"/>
                <parameter type="SiteMapNode" name="node"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.String" name="device">
                  <init>
                    <arrayIndexerExpression>
                      <target>
                        <argumentReferenceExpression name="node"/>
                      </target>
                      <indices>
                        <primitiveExpression value="Device"/>
                      </indices>
                    </arrayIndexerExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <binaryOperatorExpression operator="BooleanOr">
                        <binaryOperatorExpression operator="ValueEquality">
                          <variableReferenceExpression name="device"/>
                          <primitiveExpression value="Mobile"/>
                        </binaryOperatorExpression>
                        <binaryOperatorExpression operator="ValueEquality">
                          <variableReferenceExpression name="device"/>
                          <primitiveExpression value="Touch UI"/>
                        </binaryOperatorExpression>
                      </binaryOperatorExpression>
                      <unaryOperatorExpression operator="Not">
                        <propertyReferenceExpression name="IsMobileClient">
                          <typeReferenceExpression type="ApplicationServices"/>
                        </propertyReferenceExpression>
                      </unaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="false"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <binaryOperatorExpression operator="ValueEquality">
                        <variableReferenceExpression name="device"/>
                        <primitiveExpression value="Desktop"/>
                      </binaryOperatorExpression>
                      <propertyReferenceExpression name="IsMobileClient">
                        <typeReferenceExpression type="ApplicationServices"/>
                      </propertyReferenceExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="false"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="IsAccessibleToUser">
                    <target>
                      <baseReferenceExpression/>
                    </target>
                    <parameters>
                      <argumentReferenceExpression name="context"/>
                      <argumentReferenceExpression name="node"/>
                    </parameters>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
        <xsl:if test="$TargetFramework != '3.5' and not($ProjectId='Sharepoint Factory') and not($ProjectId='DotNetNuke Factory')">
          <!-- class PlaceholderHandler -->
          <typeDeclaration isPartial="true" name="PlaceholderHandler">
            <attributes public="true"/>
            <baseTypes>
              <typeReference type="PlaceholderHandlerBase"/>
            </baseTypes>
          </typeDeclaration>
          <!-- class PlaceholderHandlerBase -->
          <typeDeclaration name="PlaceholderHandlerBase">
            <baseTypes>
              <typeReference type="System.Object"/>
              <typeReference type="IHttpHandler" />
            </baseTypes>
            <members>
              <!-- property IsReusable -->
              <memberProperty type="System.Boolean" privateImplementationType="IHttpHandler" name="IsReusable">
                <attributes family="true"/>
                <getStatements>
                  <methodReturnStatement>
                    <primitiveExpression value="true"/>
                  </methodReturnStatement>
                </getStatements>
              </memberProperty>
              <!-- field ImageSizeRegex -->
              <memberField type="Regex" name="ImageSizeRegex">
                <attributes private="true" static="true"/>
                <init>
                  <objectCreateExpression type="Regex">
                    <parameters>
                      <primitiveExpression value="((?'background'[a-zA-Z0-9]+?)-((?'textcolor'[a-zA-Z0-9]+?)-)?)?(?'width'[0-9]+?)(x(?'height'[0-9]*))?\.[a-zA-Z][a-zA-Z][a-zA-Z]"/>
                    </parameters>
                  </objectCreateExpression>
                </init>
              </memberField>
              <!-- method ProcessRequest-->
              <memberMethod privateImplementationType="IHttpHandler" name="ProcessRequest">
                <attributes family="true"/>
                <parameters>
                  <parameter type="HttpContext" name="context"/>
                </parameters>
                <statements>
                  <comment>Get file name</comment>
                  <variableDeclarationStatement type="RouteValueDictionary" name="routeValues">
                    <init>
                      <propertyReferenceExpression name="Values">
                        <propertyReferenceExpression name="RouteData">
                          <propertyReferenceExpression name="RequestContext">
                            <propertyReferenceExpression name="Request">
                              <argumentReferenceExpression name="context"/>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                      </propertyReferenceExpression>
                    </init>
                  </variableDeclarationStatement>
                  <variableDeclarationStatement type="System.String" name="fileName">
                    <init>
                      <castExpression targetType="System.String">
                        <arrayIndexerExpression>
                          <target>
                            <variableReferenceExpression name="routeValues"/>
                          </target>
                          <indices>
                            <primitiveExpression value="FileName"/>
                          </indices>
                        </arrayIndexerExpression>
                      </castExpression>
                    </init>
                  </variableDeclarationStatement>
                  <comment>Get extension</comment>
                  <variableDeclarationStatement type="System.String" name="ext">
                    <init>
                      <methodInvokeExpression methodName="GetExtension">
                        <target>
                          <typeReferenceExpression type="Path"/>
                        </target>
                        <parameters>
                          <variableReferenceExpression name="fileName"/>
                        </parameters>
                      </methodInvokeExpression>
                    </init>
                  </variableDeclarationStatement>
                  <variableDeclarationStatement type="ImageFormat" name="format">
                    <init>
                      <propertyReferenceExpression name="Png">
                        <typeReferenceExpression type="ImageFormat"/>
                      </propertyReferenceExpression>
                    </init>
                  </variableDeclarationStatement>
                  <variableDeclarationStatement type="System.String" name="contentType">
                    <init>
                      <primitiveExpression value="image/png"/>
                    </init>
                  </variableDeclarationStatement>
                  <conditionStatement>
                    <condition>
                      <binaryOperatorExpression operator="ValueEquality">
                        <variableReferenceExpression name="ext"/>
                        <primitiveExpression value=".jpg"/>
                      </binaryOperatorExpression>
                    </condition>
                    <trueStatements>
                      <assignStatement>
                        <variableReferenceExpression name="format"/>
                        <propertyReferenceExpression name="Jpeg">
                          <typeReferenceExpression type="ImageFormat"/>
                        </propertyReferenceExpression>
                      </assignStatement>
                      <assignStatement>
                        <variableReferenceExpression name="contentType"/>
                        <primitiveExpression value="image/jpg"/>
                      </assignStatement>
                    </trueStatements>
                    <falseStatements>
                      <conditionStatement>
                        <condition>
                          <binaryOperatorExpression operator="ValueEquality">
                            <variableReferenceExpression name="ext"/>
                            <primitiveExpression value=".gif"/>
                          </binaryOperatorExpression>
                        </condition>
                        <trueStatements>
                          <assignStatement>
                            <variableReferenceExpression name="format"/>
                            <propertyReferenceExpression name="Gif">
                              <typeReferenceExpression type="ImageFormat"/>
                            </propertyReferenceExpression>
                          </assignStatement>
                          <assignStatement>
                            <variableReferenceExpression name="contentType"/>
                            <primitiveExpression value="image/jpg"/>
                          </assignStatement>
                        </trueStatements>
                      </conditionStatement>
                    </falseStatements>
                  </conditionStatement>
                  <comment>get width and height</comment>
                  <variableDeclarationStatement type="Match" name="regexMatch">
                    <init>
                      <arrayIndexerExpression>
                        <target>
                          <methodInvokeExpression methodName="Matches">
                            <target>
                              <fieldReferenceExpression name="ImageSizeRegex"/>
                            </target>
                            <parameters>
                              <variableReferenceExpression name="fileName"/>
                            </parameters>
                          </methodInvokeExpression>
                        </target>
                        <indices>
                          <primitiveExpression value="0"/>
                        </indices>
                      </arrayIndexerExpression>
                    </init>
                  </variableDeclarationStatement>
                  <variableDeclarationStatement type="Capture" name="widthCapture">
                    <init>
                      <arrayIndexerExpression>
                        <target>
                          <propertyReferenceExpression name="Groups">
                            <variableReferenceExpression name="regexMatch"/>
                          </propertyReferenceExpression>
                        </target>
                        <indices>
                          <primitiveExpression value="width"/>
                        </indices>
                      </arrayIndexerExpression>
                    </init>
                  </variableDeclarationStatement>
                  <variableDeclarationStatement type="System.Int32" name="width">
                    <init>
                      <primitiveExpression value="500"/>
                    </init>
                  </variableDeclarationStatement>
                  <conditionStatement>
                    <condition>
                      <binaryOperatorExpression operator="ValueInequality">
                        <propertyReferenceExpression name="Length">
                          <variableReferenceExpression name="widthCapture"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="0"/>
                      </binaryOperatorExpression>
                    </condition>
                    <trueStatements>
                      <assignStatement>
                        <variableReferenceExpression name="width"/>
                        <methodInvokeExpression methodName="ToInt32">
                          <target>
                            <typeReferenceExpression type="Convert"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="Value">
                              <variableReferenceExpression name="widthCapture"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </assignStatement>
                    </trueStatements>
                  </conditionStatement>
                  <conditionStatement>
                    <condition>
                      <binaryOperatorExpression operator="ValueEquality">
                        <variableReferenceExpression name="width"/>
                        <primitiveExpression value="0"/>
                      </binaryOperatorExpression>
                    </condition>
                    <trueStatements>
                      <assignStatement>
                        <variableReferenceExpression name="width"/>
                        <primitiveExpression value="500"/>
                      </assignStatement>
                    </trueStatements>
                  </conditionStatement>
                  <conditionStatement>
                    <condition>
                      <binaryOperatorExpression operator="GreaterThan">
                        <variableReferenceExpression name="width"/>
                        <primitiveExpression value="4096"/>
                      </binaryOperatorExpression>
                    </condition>
                    <trueStatements>
                      <assignStatement>
                        <variableReferenceExpression name="width"/>
                        <primitiveExpression value="4096"/>
                      </assignStatement>
                    </trueStatements>
                  </conditionStatement>
                  <variableDeclarationStatement type="Capture" name="heightCapture">
                    <init>
                      <arrayIndexerExpression>
                        <target>
                          <propertyReferenceExpression name="Groups">
                            <variableReferenceExpression name="regexMatch"/>
                          </propertyReferenceExpression>
                        </target>
                        <indices>
                          <primitiveExpression value="height"/>
                        </indices>
                      </arrayIndexerExpression>
                    </init>
                  </variableDeclarationStatement>
                  <variableDeclarationStatement type="System.Int32" name="height">
                    <init>
                      <variableReferenceExpression name="width"/>
                    </init>
                  </variableDeclarationStatement>
                  <conditionStatement>
                    <condition>
                      <binaryOperatorExpression operator="ValueInequality">
                        <propertyReferenceExpression name="Length">
                          <variableReferenceExpression name="heightCapture"/>
                        </propertyReferenceExpression>
                        <primitiveExpression value="0"/>
                      </binaryOperatorExpression>
                    </condition>
                    <trueStatements>
                      <assignStatement>
                        <variableReferenceExpression name="height"/>
                        <methodInvokeExpression methodName="ToInt32">
                          <target>
                            <typeReferenceExpression type="Convert"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="Value">
                              <variableReferenceExpression name="heightCapture"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </assignStatement>
                    </trueStatements>
                  </conditionStatement>
                  <conditionStatement>
                    <condition>
                      <binaryOperatorExpression operator="ValueEquality">
                        <variableReferenceExpression name="height"/>
                        <primitiveExpression value="0"/>
                      </binaryOperatorExpression>
                    </condition>
                    <trueStatements>
                      <assignStatement>
                        <variableReferenceExpression name="height"/>
                        <primitiveExpression value="500"/>
                      </assignStatement>
                    </trueStatements>
                  </conditionStatement>
                  <conditionStatement>
                    <condition>
                      <binaryOperatorExpression operator="GreaterThan">
                        <variableReferenceExpression name="height"/>
                        <primitiveExpression value="4096"/>
                      </binaryOperatorExpression>
                    </condition>
                    <trueStatements>
                      <assignStatement>
                        <variableReferenceExpression name="height"/>
                        <primitiveExpression value="4096"/>
                      </assignStatement>
                    </trueStatements>
                  </conditionStatement>
                  <comment>Get background and text colors</comment>
                  <variableDeclarationStatement type="Color" name="background">
                    <init>
                      <methodInvokeExpression methodName="GetColor">
                        <parameters>
                          <arrayIndexerExpression>
                            <target>
                              <propertyReferenceExpression name="Groups">
                                <variableReferenceExpression name="regexMatch"/>
                              </propertyReferenceExpression>
                            </target>
                            <indices>
                              <primitiveExpression value="background"/>
                            </indices>
                          </arrayIndexerExpression>
                          <propertyReferenceExpression name="LightGray">
                            <typeReferenceExpression type="Color"/>
                          </propertyReferenceExpression>
                        </parameters>
                      </methodInvokeExpression>
                    </init>
                  </variableDeclarationStatement>
                  <variableDeclarationStatement type="Color" name="textColor">
                    <init>
                      <methodInvokeExpression methodName="GetColor">
                        <parameters>
                          <arrayIndexerExpression>
                            <target>
                              <propertyReferenceExpression name="Groups">
                                <variableReferenceExpression name="regexMatch"/>
                              </propertyReferenceExpression>
                            </target>
                            <indices>
                              <primitiveExpression value="textcolor"/>
                            </indices>
                          </arrayIndexerExpression>
                          <propertyReferenceExpression name="Black">
                            <typeReferenceExpression type="Color"/>
                          </propertyReferenceExpression>
                        </parameters>
                      </methodInvokeExpression>
                    </init>
                  </variableDeclarationStatement>
                  <variableDeclarationStatement type="System.Int32" name="fontSize">
                    <init>
                      <binaryOperatorExpression operator="Divide">
                        <binaryOperatorExpression operator="Add">
                          <variableReferenceExpression name="width"/>
                          <variableReferenceExpression name="height"/>
                        </binaryOperatorExpression>
                        <primitiveExpression value="50"/>
                      </binaryOperatorExpression>
                    </init>
                  </variableDeclarationStatement>
                  <conditionStatement>
                    <condition>
                      <binaryOperatorExpression operator="LessThan">
                        <variableReferenceExpression name="fontSize"/>
                        <primitiveExpression value="10"/>
                      </binaryOperatorExpression>
                    </condition>
                    <trueStatements>
                      <assignStatement>
                        <variableReferenceExpression name="fontSize"/>
                        <primitiveExpression value="10"/>
                      </assignStatement>
                    </trueStatements>
                  </conditionStatement>
                  <variableDeclarationStatement type="Font" name="font">
                    <init>
                      <objectCreateExpression type="Font">
                        <parameters>
                          <propertyReferenceExpression name="GenericSansSerif">
                            <typeReferenceExpression type="FontFamily"/>
                          </propertyReferenceExpression>
                          <variableReferenceExpression name="fontSize"/>
                        </parameters>
                      </objectCreateExpression>
                    </init>
                  </variableDeclarationStatement>
                  <comment>Get text</comment>
                  <variableDeclarationStatement type="System.String" name="text">
                    <init>
                      <arrayIndexerExpression>
                        <target>
                          <propertyReferenceExpression name="QueryString">
                            <propertyReferenceExpression name="Request">
                              <argumentReferenceExpression name="context"/>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                        </target>
                        <indices>
                          <primitiveExpression value="text"/>
                        </indices>
                      </arrayIndexerExpression>
                    </init>
                  </variableDeclarationStatement>
                  <conditionStatement>
                    <condition>
                      <unaryOperatorExpression operator="IsNullOrEmpty">
                        <variableReferenceExpression name="text"/>
                      </unaryOperatorExpression>
                    </condition>
                    <trueStatements>
                      <assignStatement>
                        <variableReferenceExpression name="text"/>
                        <methodInvokeExpression methodName="Format">
                          <target>
                            <typeReferenceExpression type="System.String"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="{{0}} x {{1}}"/>
                            <variableReferenceExpression name="width"/>
                            <variableReferenceExpression name="height"/>
                          </parameters>
                        </methodInvokeExpression>
                      </assignStatement>
                    </trueStatements>
                  </conditionStatement>
                  <comment>Get position for text</comment>
                  <variableDeclarationStatement type="SizeF" name="textSize"/>
                  <usingStatement>
                    <variable type="Image" name="img">
                      <init>
                        <objectCreateExpression type="Bitmap">
                          <parameters>
                            <primitiveExpression value="1"/>
                            <primitiveExpression value="1"/>
                          </parameters>
                        </objectCreateExpression>
                      </init>
                    </variable>
                    <statements>
                      <variableDeclarationStatement type="Graphics" name="textDrawing">
                        <init>
                          <methodInvokeExpression methodName="FromImage">
                            <target>
                              <typeReferenceExpression type="Graphics"/>
                            </target>
                            <parameters>
                              <variableReferenceExpression name="img"/>
                            </parameters>
                          </methodInvokeExpression>
                        </init>
                      </variableDeclarationStatement>
                      <assignStatement>
                        <variableReferenceExpression name="textSize"/>
                        <methodInvokeExpression methodName="MeasureString">
                          <target>
                            <variableReferenceExpression name="textDrawing"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="text"/>
                            <variableReferenceExpression name="font"/>
                          </parameters>
                        </methodInvokeExpression>
                      </assignStatement>
                    </statements>
                  </usingStatement>
                  <comment>Draw the image</comment>
                  <usingStatement>
                    <variable type="Image" name="image">
                      <init>
                        <objectCreateExpression type="Bitmap">
                          <parameters>
                            <variableReferenceExpression name="width"/>
                            <variableReferenceExpression name="height"/>
                          </parameters>
                        </objectCreateExpression>
                      </init>
                    </variable>
                    <statements>
                      <variableDeclarationStatement type="Graphics" name="drawing">
                        <init>
                          <methodInvokeExpression methodName="FromImage">
                            <target>
                              <typeReferenceExpression type="Graphics"/>
                            </target>
                            <parameters>
                              <variableReferenceExpression name="image"/>
                            </parameters>
                          </methodInvokeExpression>
                        </init>
                      </variableDeclarationStatement>
                      <methodInvokeExpression methodName="Clear">
                        <target>
                          <variableReferenceExpression name="drawing"/>
                        </target>
                        <parameters>
                          <variableReferenceExpression name="background"/>
                        </parameters>
                      </methodInvokeExpression>
                      <usingStatement>
                        <variable type="Brush" name="textBrush">
                          <init>
                            <objectCreateExpression type="SolidBrush">
                              <parameters>
                                <variableReferenceExpression name="textColor"/>
                              </parameters>
                            </objectCreateExpression>
                          </init>
                        </variable>
                        <statements>
                          <methodInvokeExpression methodName="DrawString">
                            <target>
                              <variableReferenceExpression name="drawing"/>
                            </target>
                            <parameters>
                              <variableReferenceExpression name="text"/>
                              <variableReferenceExpression name="font"/>
                              <variableReferenceExpression name="textBrush"/>
                              <binaryOperatorExpression operator="Divide">
                                <binaryOperatorExpression operator="Subtract">
                                  <variableReferenceExpression name="width"/>
                                  <propertyReferenceExpression name="Width">
                                    <variableReferenceExpression name="textSize"/>
                                  </propertyReferenceExpression>
                                </binaryOperatorExpression>
                                <primitiveExpression value="2"/>
                              </binaryOperatorExpression>
                              <binaryOperatorExpression operator="Divide">
                                <binaryOperatorExpression operator="Subtract">
                                  <variableReferenceExpression name="height"/>
                                  <propertyReferenceExpression name="Height">
                                    <variableReferenceExpression name="textSize"/>
                                  </propertyReferenceExpression>
                                </binaryOperatorExpression>
                                <primitiveExpression value="2"/>
                              </binaryOperatorExpression>
                            </parameters>
                          </methodInvokeExpression>
                        </statements>
                      </usingStatement>
                      <methodInvokeExpression methodName="Save">
                        <target>
                          <variableReferenceExpression name="drawing"/>
                        </target>
                      </methodInvokeExpression>
                      <methodInvokeExpression methodName="Dispose">
                        <target>
                          <variableReferenceExpression name="drawing"/>
                        </target>
                      </methodInvokeExpression>
                      <comment>Return image</comment>
                      <usingStatement>
                        <variable type="MemoryStream" name="stream">
                          <init>
                            <objectCreateExpression type="MemoryStream"/>
                          </init>
                        </variable>
                        <statements>
                          <methodInvokeExpression methodName="Save">
                            <target>
                              <variableReferenceExpression name="image"/>
                            </target>
                            <parameters>
                              <variableReferenceExpression name="stream"/>
                              <variableReferenceExpression name="format"/>
                            </parameters>
                          </methodInvokeExpression>
                          <variableDeclarationStatement type="HttpCachePolicy" name="cache">
                            <init>
                              <propertyReferenceExpression name="Cache">
                                <propertyReferenceExpression name="Response">
                                  <argumentReferenceExpression name="context"/>
                                </propertyReferenceExpression>
                              </propertyReferenceExpression>
                            </init>
                          </variableDeclarationStatement>
                          <methodInvokeExpression methodName="SetCacheability">
                            <target>
                              <variableReferenceExpression name="cache"/>
                            </target>
                            <parameters>
                              <propertyReferenceExpression name="Public">
                                <typeReferenceExpression type="HttpCacheability"/>
                              </propertyReferenceExpression>
                            </parameters>
                          </methodInvokeExpression>
                          <methodInvokeExpression methodName="SetOmitVaryStar">
                            <target>
                              <variableReferenceExpression name="cache"/>
                            </target>
                            <parameters>
                              <primitiveExpression value="true"/>
                            </parameters>
                          </methodInvokeExpression>
                          <methodInvokeExpression methodName="SetExpires">
                            <target>
                              <variableReferenceExpression name="cache"/>
                            </target>
                            <parameters>
                              <methodInvokeExpression methodName="AddDays">
                                <target>
                                  <propertyReferenceExpression name="Now">
                                    <typeReferenceExpression type="DateTime"/>
                                  </propertyReferenceExpression>
                                </target>
                                <parameters>
                                  <primitiveExpression value="365"/>
                                </parameters>
                              </methodInvokeExpression>
                            </parameters>
                          </methodInvokeExpression>
                          <methodInvokeExpression methodName="SetValidUntilExpires">
                            <target>
                              <variableReferenceExpression name="cache"/>
                            </target>
                            <parameters>
                              <primitiveExpression value="true"/>
                            </parameters>
                          </methodInvokeExpression>
                          <methodInvokeExpression methodName="SetLastModifiedFromFileDependencies">
                            <target>
                              <variableReferenceExpression name="cache"/>
                            </target>
                          </methodInvokeExpression>
                          <assignStatement>
                            <propertyReferenceExpression name="ContentType">
                              <propertyReferenceExpression name="Response">
                                <argumentReferenceExpression name="context"/>
                              </propertyReferenceExpression>
                            </propertyReferenceExpression>
                            <variableReferenceExpression name="contentType"/>
                          </assignStatement>
                          <methodInvokeExpression methodName="AddHeader">
                            <target>
                              <propertyReferenceExpression name="Response">
                                <argumentReferenceExpression name="context"/>
                              </propertyReferenceExpression>
                            </target>
                            <parameters>
                              <primitiveExpression value="Content-Length"/>
                              <methodInvokeExpression methodName="ToString">
                                <target>
                                  <typeReferenceExpression type="Convert"/>
                                </target>
                                <parameters>
                                  <propertyReferenceExpression name="Length">
                                    <variableReferenceExpression name="stream"/>
                                  </propertyReferenceExpression>
                                </parameters>
                              </methodInvokeExpression>
                            </parameters>
                          </methodInvokeExpression>
                          <methodInvokeExpression methodName="AddHeader">
                            <target>
                              <propertyReferenceExpression name="Response">
                                <argumentReferenceExpression name="context"/>
                              </propertyReferenceExpression>
                            </target>
                            <parameters>
                              <primitiveExpression value="File-Name"/>
                              <variableReferenceExpression name="fileName"/>
                            </parameters>
                          </methodInvokeExpression>
                          <methodInvokeExpression methodName="BinaryWrite">
                            <target>
                              <propertyReferenceExpression name="Response">
                                <argumentReferenceExpression name="context"/>
                              </propertyReferenceExpression>
                            </target>
                            <parameters>
                              <methodInvokeExpression methodName="ToArray">
                                <target>
                                  <variableReferenceExpression name="stream"/>
                                </target>
                              </methodInvokeExpression>
                            </parameters>
                          </methodInvokeExpression>
                          <methodInvokeExpression methodName="Flush">
                            <target>
                              <propertyReferenceExpression name="OutputStream">
                                <propertyReferenceExpression name="Response">
                                  <argumentReferenceExpression name="context"/>
                                </propertyReferenceExpression>
                              </propertyReferenceExpression>
                            </target>
                          </methodInvokeExpression>
                        </statements>
                      </usingStatement>
                    </statements>
                  </usingStatement>
                </statements>
              </memberMethod>
              <!-- method GetColor -->
              <memberMethod returnType="Color" name="GetColor">
                <attributes private="true" static="true"/>
                <parameters>
                  <parameter type="Capture" name="colorName"/>
                  <parameter type="Color" name="defaultColor"/>
                </parameters>
                <statements>
                  <tryStatement>
                    <statements>
                      <conditionStatement>
                        <condition>
                          <binaryOperatorExpression operator="GreaterThan">
                            <propertyReferenceExpression name="Length">
                              <argumentReferenceExpression name="colorName"/>
                            </propertyReferenceExpression>
                            <primitiveExpression value="0"/>
                          </binaryOperatorExpression>
                        </condition>
                        <trueStatements>
                          <variableDeclarationStatement type="System.String" name="s">
                            <init>
                              <propertyReferenceExpression name="Value">
                                <argumentReferenceExpression name="colorName"/>
                              </propertyReferenceExpression>
                            </init>
                          </variableDeclarationStatement>
                          <conditionStatement>
                            <condition>
                              <methodInvokeExpression methodName="IsMatch">
                                <target>
                                  <typeReferenceExpression type="Regex"/>
                                </target>
                                <parameters>
                                  <variableReferenceExpression name="s"/>
                                  <primitiveExpression value="^[0-9abcdef]{{3,6}}$"/>
                                </parameters>
                              </methodInvokeExpression>
                            </condition>
                            <trueStatements>
                              <assignStatement>
                                <variableReferenceExpression name="s"/>
                                <binaryOperatorExpression operator="Add">
                                  <primitiveExpression value="#"/>
                                  <variableReferenceExpression name="s"/>
                                </binaryOperatorExpression>
                              </assignStatement>
                            </trueStatements>
                          </conditionStatement>

                          <methodReturnStatement>
                            <methodInvokeExpression methodName="FromHtml">
                              <target>
                                <typeReferenceExpression type="ColorTranslator"/>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="s"/>
                              </parameters>
                            </methodInvokeExpression>
                          </methodReturnStatement>
                        </trueStatements>
                      </conditionStatement>
                    </statements>
                    <catch exceptionType="Exception"></catch>
                  </tryStatement>
                  <methodReturnStatement>
                    <argumentReferenceExpression name="defaultColor"/>
                  </methodReturnStatement>
                </statements>
              </memberMethod>
            </members>
          </typeDeclaration>
          <!-- class GenericRoute -->
          <typeDeclaration name="GenericRoute">
            <baseTypes>
              <typeReference type="System.Object"/>
              <typeReference type="IRouteHandler"/>
            </baseTypes>
            <members>
              <memberField type="IHttpHandler" name="handler"/>
              <!-- constructor -->
              <constructor>
                <attributes public="true"/>
                <parameters>
                  <parameter type="IHttpHandler" name="handler"/>
                </parameters>
                <statements>
                  <assignStatement>
                    <fieldReferenceExpression name="handler"/>
                    <argumentReferenceExpression name="handler"/>
                  </assignStatement>
                </statements>
              </constructor>
              <!-- method IRouteHandler.GetHttpHandler(RequestContext) -->
              <memberMethod returnType="IHttpHandler" name="GetHttpHandler" privateImplementationType="IRouteHandler">
                <attributes public="true" final="true"/>
                <parameters>
                  <parameter type="RequestContext" name="context"/>
                </parameters>
                <statements>
                  <methodReturnStatement>
                    <fieldReferenceExpression name="handler"/>
                  </methodReturnStatement>
                </statements>
              </memberMethod>
              <!-- method Map(RouteCollection, IHttpHandler, string) -->
              <memberMethod name="Map">
                <attributes public="true" static="true"/>
                <parameters>
                  <parameter type="RouteCollection" name="routes"/>
                  <parameter type="IHttpHandler" name="handler"/>
                  <parameter type="System.String" name="url"/>
                </parameters>
                <statements>
                  <variableDeclarationStatement type="Route" name="r">
                    <init>
                      <objectCreateExpression type="Route">
                        <parameters>
                          <argumentReferenceExpression name="url"/>
                          <objectCreateExpression type="GenericRoute">
                            <parameters>
                              <argumentReferenceExpression name="handler"/>
                            </parameters>
                          </objectCreateExpression>
                        </parameters>
                      </objectCreateExpression>
                    </init>
                  </variableDeclarationStatement>
                  <assignStatement>
                    <propertyReferenceExpression name="Defaults">
                      <variableReferenceExpression name="r"/>
                    </propertyReferenceExpression>
                    <objectCreateExpression type="RouteValueDictionary"/>
                  </assignStatement>
                  <assignStatement>
                    <propertyReferenceExpression name="Constraints">
                      <variableReferenceExpression name="r"/>
                    </propertyReferenceExpression>
                    <objectCreateExpression type="RouteValueDictionary"/>
                  </assignStatement>
                  <methodInvokeExpression methodName="Add">
                    <target>
                      <argumentReferenceExpression name="routes"/>
                    </target>
                    <parameters>
                      <variableReferenceExpression name="r"/>
                    </parameters>
                  </methodInvokeExpression>
                </statements>
              </memberMethod>
            </members>
          </typeDeclaration>
        </xsl:if>
      </types>
    </compileUnit>
  </xsl:template>
</xsl:stylesheet>
