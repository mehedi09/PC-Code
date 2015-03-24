<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.codeontime.com/2008/codedom-compiler"  xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl a"
>
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="IsUnlimited"/>

  <xsl:template match="/">
    <compileUnit namespace="{a:project/a:namespace}.Services">
      <imports>
        <namespaceImport name="System"/>
        <namespaceImport name="System.Collections.Generic"/>
        <namespaceImport name="System.Linq"/>
        <namespaceImport name="System.Text.RegularExpressions"/>
        <namespaceImport name="System.Web"/>
        <namespaceImport name="System.Web.Routing"/>
        <namespaceImport name="{a:project/a:namespace}.Data"/>
        <namespaceImport name="{a:project/a:namespace}.Security"/>
      </imports>
      <types>
        <!-- class EnterpriseApplicationServices -->
        <typeDeclaration name="EnterpriseApplicationServices" isPartial="true">
          <baseTypes>
            <typeReference type="EnterpriseApplicationServicesBase"/>
          </baseTypes>
          <members>
          </members>
        </typeDeclaration>
        <!-- class EnterpriseApplicationServicesBase -->
        <typeDeclaration name="EnterpriseApplicationServicesBase">
          <baseTypes>
            <typeReference type="ApplicationServicesBase"/>
          </baseTypes>
          <members>
            <!-- property AppServicesRegex -->
            <memberField type="Regex" name="AppServicesRegex">
              <attributes public="true" static="true"/>
              <init>
                <objectCreateExpression type="Regex">
                  <parameters>
                    <primitiveExpression value="/appservices/(?'Controller'.+?)(/|$)"/>
                    <propertyReferenceExpression name="IgnoreCase">
                      <typeReferenceExpression type="RegexOptions"/>
                    </propertyReferenceExpression>
                  </parameters>
                </objectCreateExpression>
              </init>
            </memberField>
            <!-- property DynamicResourceRegex -->
            <memberField type="Regex" name="DynamicResourceRegex">
              <attributes public="true" static="true"/>
              <init>
                <objectCreateExpression type="Regex">
                  <parameters>
                    <primitiveExpression value="(\.js$|^_(invoke|authenticate)$)"/>
                    <propertyReferenceExpression name="IgnoreCase">
                      <typeReferenceExpression type="RegexOptions"/>
                    </propertyReferenceExpression>
                  </parameters>
                </objectCreateExpression>
              </init>
            </memberField>
            <!-- property DynamicWebResourceRegex -->
            <memberField type="Regex" name="DynamicWebResourceRegex">
              <attributes public="true" static="true"/>
              <init>
                <objectCreateExpression type="Regex">
                  <parameters>
                    <primitiveExpression value="\.(js|css)$"/>
                    <propertyReferenceExpression name="IgnoreCase">
                      <typeReferenceExpression type="RegexOptions"/>
                    </propertyReferenceExpression>
                  </parameters>
                </objectCreateExpression>
              </init>
            </memberField>
            <!-- method RegisterServices() -->
            <memberMethod name="RegisterServices">
              <attributes public="true" override="true"/>
              <statements>
                <methodInvokeExpression methodName="RegisterREST"/>
                <methodInvokeExpression methodName="RegisterServices">
                  <target>
                    <baseReferenceExpression/>
                  </target>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- method RegisterREST() -->
            <memberMethod name="RegisterREST">
              <attributes public="true"/>
              <statements>
                <variableDeclarationStatement type="RouteCollection" name="routes">
                  <init>
                    <propertyReferenceExpression name="Routes">
                      <propertyReferenceExpression name="RouteTable"/>
                    </propertyReferenceExpression>
                  </init>
                </variableDeclarationStatement>
                <assignStatement>
                  <propertyReferenceExpression name="RouteExistingFiles">
                    <variableReferenceExpression name="routes"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="true"/>
                </assignStatement>
                <methodInvokeExpression methodName="Map">
                  <target>
                    <typeReferenceExpression type="GenericRoute"/>
                  </target>
                  <parameters>
                    <variableReferenceExpression name="routes"/>
                    <objectCreateExpression type="RepresentationalStateTransfer"/>
                    <primitiveExpression value="appservices/{{Controller}}/{{Segment1}}/{{Segment2}}/{{Segment3}}/{{Segment4}}"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Map">
                  <target>
                    <typeReferenceExpression type="GenericRoute"/>
                  </target>
                  <parameters>
                    <variableReferenceExpression name="routes"/>
                    <objectCreateExpression type="RepresentationalStateTransfer"/>
                    <primitiveExpression value="appservices/{{Controller}}/{{Segment1}}/{{Segment2}}/{{Segment3}}"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Map">
                  <target>
                    <typeReferenceExpression type="GenericRoute"/>
                  </target>
                  <parameters>
                    <variableReferenceExpression name="routes"/>
                    <objectCreateExpression type="RepresentationalStateTransfer"/>
                    <primitiveExpression value="appservices/{{Controller}}/{{Segment1}}/{{Segment2}}"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Map">
                  <target>
                    <typeReferenceExpression type="GenericRoute"/>
                  </target>
                  <parameters>
                    <variableReferenceExpression name="routes"/>
                    <objectCreateExpression type="RepresentationalStateTransfer"/>
                    <primitiveExpression value="appservices/{{Controller}}/{{Segment1}}"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="Map">
                  <target>
                    <typeReferenceExpression type="GenericRoute"/>
                  </target>
                  <parameters>
                    <variableReferenceExpression name="routes"/>
                    <objectCreateExpression type="RepresentationalStateTransfer"/>
                    <primitiveExpression value="appservices/{{Controller}}"/>
                  </parameters>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- method RequiresAuthentication(HttpRequest) -->
            <memberMethod returnType="System.Boolean" name="RequiresAuthentication">
              <attributes public="true" override="true"/>
              <parameters>
                <parameter type="HttpRequest" name="request"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.Boolean" name="result">
                  <init>
                    <methodInvokeExpression methodName="RequiresAuthentication">
                      <target>
                        <baseReferenceExpression/>
                      </target>
                      <parameters>
                        <argumentReferenceExpression name="request"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <variableReferenceExpression name="result"/>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement>
                      <primitiveExpression value="true"/>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="Match" name="m">
                  <init>
                    <methodInvokeExpression methodName="Match">
                      <target>
                        <propertyReferenceExpression name="AppServicesRegex"/>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="Path">
                          <variableReferenceExpression name="request"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <propertyReferenceExpression name="Success">
                      <variableReferenceExpression name="m"/>
                    </propertyReferenceExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="ControllerConfiguration" name="config">
                      <init>
                        <primitiveExpression value="null"/>
                      </init>
                    </variableDeclarationStatement>
                    <tryStatement>
                      <statements>
                        <variableDeclarationStatement type="System.String" name="controllerName">
                          <init>
                            <propertyReferenceExpression name="Value">
                              <arrayIndexerExpression>
                                <target>
                                  <propertyReferenceExpression name="Groups">
                                    <variableReferenceExpression name="m"/>
                                  </propertyReferenceExpression>
                                </target>
                                <indices>
                                  <primitiveExpression value="Controller"/>
                                </indices>
                              </arrayIndexerExpression>
                            </propertyReferenceExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <unaryOperatorExpression operator="Not">
                              <methodInvokeExpression methodName="IsMatch">
                                <target>
                                  <propertyReferenceExpression name="DynamicResourceRegex"/>
                                </target>
                                <parameters>
                                  <variableReferenceExpression name="controllerName"/>
                                </parameters>
                              </methodInvokeExpression>
                            </unaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <assignStatement>
                              <variableReferenceExpression name="config"/>
                              <methodInvokeExpression methodName="CreateConfigurationInstance">
                                <target>
                                  <typeReferenceExpression type="DataControllerBase"/>
                                </target>
                                <parameters>
                                  <methodInvokeExpression methodName="GetType"/>
                                  <variableReferenceExpression name="controllerName"/>
                                </parameters>
                              </methodInvokeExpression>
                            </assignStatement>
                          </trueStatements>
                        </conditionStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="ValueEquality">
                              <variableReferenceExpression name="controllerName"/>
                              <primitiveExpression value="_authenticate"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <methodReturnStatement>
                              <primitiveExpression value="false"/>
                            </methodReturnStatement>
                          </trueStatements>
                        </conditionStatement>
                      </statements>
                      <catch exceptionType="Exception">
                      </catch>
                    </tryStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityEquality">
                          <variableReferenceExpression name="config"/>
                          <primitiveExpression value="null"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodReturnStatement>
                          <unaryOperatorExpression operator="Not">
                            <methodInvokeExpression methodName="IsMatch">
                              <target>
                                <propertyReferenceExpression name="DynamicWebResourceRegex"/>
                              </target>
                              <parameters>
                                <propertyReferenceExpression name="Path">
                                  <variableReferenceExpression name="request"/>
                                </propertyReferenceExpression>
                              </parameters>
                            </methodInvokeExpression>
                          </unaryOperatorExpression>
                        </methodReturnStatement>
                      </trueStatements>
                    </conditionStatement>
                    <methodReturnStatement>
                      <methodInvokeExpression methodName="RequiresRESTAuthentication">
                        <parameters>
                          <argumentReferenceExpression name="request"/>
                          <variableReferenceExpression name="config"/>
                        </parameters>
                      </methodInvokeExpression>
                    </methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <primitiveExpression value="false"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method RequiresAuthentication(HttpRequest, ControllerConfiguration) -->
            <memberMethod returnType="System.Boolean" name="RequiresRESTAuthentication">
              <attributes public="true"/>
              <parameters>
                <parameter type="HttpRequest" name="request"/>
                <parameter type="ControllerConfiguration" name="config"/>
              </parameters>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="RequiresAuthentication">
                    <target>
                      <typeReferenceExpression type="UriRestConfig"/>
                    </target>
                    <parameters>
                      <argumentReferenceExpression name="request"/>
                      <argumentReferenceExpression name="config"/>
                    </parameters>
                  </methodInvokeExpression>
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
      </types>
    </compileUnit>
  </xsl:template>
</xsl:stylesheet>
