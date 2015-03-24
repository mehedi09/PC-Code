<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.codeontime.com/2008/codedom-compiler"  xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    xmlns:app="urn:schemas-codeontime-com:data-aquarium-application"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl a app"
>
  <xsl:output method="xml" indent="yes" />

  <xsl:param name="Namespace"/>

  <xsl:template match="/">
    <compileUnit namespace="{$Namespace}.WebParts">
      <imports>
        <namespaceImport name="System"/>
        <namespaceImport name="System.Collections.Generic"/>
        <namespaceImport name="System.ComponentModel"/>
        <namespaceImport name="System.Linq"/>
        <namespaceImport name="System.Text.RegularExpressions"/>
        <namespaceImport name="System.Web"/>
        <namespaceImport name="System.Web.UI"/>
        <namespaceImport name="System.Web.UI.WebControls"/>
        <namespaceImport name="System.Web.UI.WebControls.WebParts"/>
        <namespaceImport name="System.Text.RegularExpressions"/>
        <namespaceImport name="Microsoft.SharePoint"/>
        <namespaceImport name="Microsoft.SharePoint.WebControls"/>
        <namespaceImport name="{$Namespace}.Web"/>
      </imports>
      <types>

        <!-- class AppWebPart -->
        <typeDeclaration name="AppWebPart" isPartial="true">
          <customAttributes>
            <customAttribute name="ToolboxItemAttribute">
              <arguments>
                <primitiveExpression value="false"/>
              </arguments>
            </customAttribute>
          </customAttributes>
          <baseTypes>
            <typeReference type="AppWebPartBase"/>
          </baseTypes>
        </typeDeclaration>

        <!-- class AppWebPartBase -->
        <typeDeclaration name="AppWebPartBase">
          <customAttributes>
            <customAttribute name="ToolboxItemAttribute">
              <arguments>
                <primitiveExpression value="false"/>
              </arguments>
            </customAttribute>
          </customAttributes>
          <baseTypes>
            <typeReference type="WebPart"/>
          </baseTypes>
          <members>
            <!-- field ascxPath -->
            <memberField type="System.String" name="ascxPath">
              <attributes private="true" const="true"/>
              <init>
                <primitiveExpression value="~/_CONTROLTEMPLATES/{$Namespace}/AppWebPart/DefaultUserControl.ascx"/>
              </init>
            </memberField>
            <!-- constructor AppWebPartBase() -->
            <constructor>
              <attributes public="true"/>
              <baseConstructorArgs></baseConstructorArgs>
              <statements>
                <assignStatement>
                  <propertyReferenceExpression name="ChromeType"/>
                  <propertyReferenceExpression name="None">
                    <typeReferenceExpression type="PartChromeType"/>
                  </propertyReferenceExpression>
                </assignStatement>
              </statements>
            </constructor>
            <!-- method CreateChildControls -->
            <memberMethod name="CreateChildControls">
              <attributes family="true" override="true"/>
              <statements>
                <variableDeclarationStatement type="System.String" name="pageName">
                  <init>
                    <propertyReferenceExpression name="ApplicationPage"/>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="System.String" name="baseFolder">
                  <init>
                    <primitiveExpression value="Pages"/>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="IsNullOrEmpty">
                      <variableReferenceExpression name="pageName"/>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <variableReferenceExpression name="pageName"/>
                      <primitiveExpression value="DefaultUserControl"/>
                    </assignStatement>
                    <assignStatement>
                      <variableReferenceExpression name="baseFolder"/>
                      <primitiveExpression value="AppWebPart"/>
                    </assignStatement>
                  </trueStatements>
                  <falseStatements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanOr">
                          <propertyReferenceExpression name="DesignMode">
                            <thisReferenceExpression/>
                          </propertyReferenceExpression>
                          <propertyReferenceExpression name="IsDesignTime">
                            <propertyReferenceExpression name="Current">
                              <typeReferenceExpression type="SPContext"/>
                            </propertyReferenceExpression>
                          </propertyReferenceExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <methodInvokeExpression methodName="Add">
                          <target>
                            <propertyReferenceExpression name="Controls"/>
                          </target>
                          <parameters>
                            <objectCreateExpression type="LiteralControl">
                              <parameters>
                                <stringFormatExpression format="&lt;div style=&quot;height:50px;border:solid 1px silver;margin:8px;padding:8px;&quot;&gt; Logical page '{{0}}' will be rendered here at runtime.&lt;/div&gt;">
                                  <variableReferenceExpression name="pageName"/>
                                </stringFormatExpression>
                              </parameters>
                            </objectCreateExpression>
                          </parameters>
                        </methodInvokeExpression>
                        <methodReturnStatement/>
                      </trueStatements>
                    </conditionStatement>
                  </falseStatements>
                </conditionStatement>
                <variableDeclarationStatement type="System.String" name="controlPath">
                  <init>
                    <methodInvokeExpression methodName="Replace">
                      <target>
                        <methodInvokeExpression methodName="Replace">
                          <target>
                            <fieldReferenceExpression name="ascxPath"/>
                          </target>
                          <parameters>
                            <primitiveExpression value="/AppWebPart/"/>
                            <stringFormatExpression format="/{{0}}/">
                              <variableReferenceExpression name="baseFolder"/>
                            </stringFormatExpression>
                          </parameters>
                        </methodInvokeExpression>
                      </target>
                      <parameters>
                        <primitiveExpression value="/DefaultUserControl."/>
                        <stringFormatExpression format="/{{0}}.">
                          <variableReferenceExpression name="pageName"/>
                        </stringFormatExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <tryStatement>
                  <statements>
                    <variableDeclarationStatement type="Control" name="control">
                      <init>
                        <methodInvokeExpression methodName="LoadControl">
                          <target>
                            <propertyReferenceExpression name="Page"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="controlPath"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <methodInvokeExpression methodName="LoadPageControl">
                      <target>
                        <typeReferenceExpression type="ControlBase"/>
                      </target>
                      <parameters>
                        <thisReferenceExpression/>
                        <variableReferenceExpression name="pageName"/>
                        <variableReferenceExpression name="control"/>
                      </parameters>
                    </methodInvokeExpression>
                  </statements>
                  <catch exceptionType="Exception" localName="ex">
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <propertyReferenceExpression name="Controls"/>
                      </target>
                      <parameters>
                        <objectCreateExpression type="LiteralControl">
                          <parameters>
                            <propertyReferenceExpression name="Message">
                              <variableReferenceExpression name="ex"/>
                            </propertyReferenceExpression>
                          </parameters>
                        </objectCreateExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </catch>
                </tryStatement>
              </statements>
            </memberMethod>
            <!-- property ApplicatonPage-->
            <memberProperty type="System.String" name="ApplicationPage">
              <attributes public="true" final="true"/>
              <customAttributes>
                <customAttribute name="Personalizable">
                  <arguments>
                    <primitiveExpression value="true"/>
                  </arguments>
                </customAttribute>
                <customAttribute name="WebBrowsable">
                  <arguments>
                    <primitiveExpression value="false"/>
                  </arguments>
                </customAttribute>
              </customAttributes>
              <getStatements>
                <methodReturnStatement>
                  <castExpression targetType="System.String">
                    <arrayIndexerExpression>
                      <target>
                        <propertyReferenceExpression name="ViewState"/>
                      </target>
                      <indices>
                        <primitiveExpression value="ApplicationPage"/>
                      </indices>
                    </arrayIndexerExpression>
                  </castExpression>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <arrayIndexerExpression>
                    <target>
                      <propertyReferenceExpression name="ViewState"/>
                    </target>
                    <indices>
                      <primitiveExpression value="ApplicationPage"/>
                    </indices>
                  </arrayIndexerExpression>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- method CreateEditorParts -->
            <memberMethod returnType="EditorPartCollection" name="CreateEditorParts">
              <attributes public="true" override="true"/>
              <statements>
                <variableDeclarationStatement type="List" name="editors">
                  <typeArguments>
                    <typeReference type="EditorPart"/>
                  </typeArguments>
                  <init>
                    <objectCreateExpression type="List">
                      <typeArguments>
                        <typeReference type="EditorPart"/>
                      </typeArguments>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="EditorPart" name="part">
                  <init>
                    <objectCreateExpression type="AppEditorPart"/>
                  </init>
                </variableDeclarationStatement>
                <assignStatement>
                  <propertyReferenceExpression name="ID">
                    <variableReferenceExpression name="part"/>
                  </propertyReferenceExpression>
                  <binaryOperatorExpression operator="Add">
                    <propertyReferenceExpression name="ID">
                      <thisReferenceExpression/>
                    </propertyReferenceExpression>
                    <primitiveExpression value="_WebAppEditor"/>
                  </binaryOperatorExpression>
                </assignStatement>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <variableReferenceExpression name="editors"/>
                  </target>
                  <parameters>
                    <variableReferenceExpression name="part"/>
                  </parameters>
                </methodInvokeExpression>
                <variableDeclarationStatement type="EditorPartCollection" name="list">
                  <init>
                    <methodInvokeExpression methodName="CreateEditorParts">
                      <target>
                        <baseReferenceExpression/>
                      </target>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <methodReturnStatement>
                  <objectCreateExpression type="EditorPartCollection">
                    <parameters>
                      <variableReferenceExpression name="list"/>
                      <variableReferenceExpression name="editors"/>
                    </parameters>
                  </objectCreateExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
        <!-- class AppEditorPart -->
        <typeDeclaration name="AppEditorPart">
          <baseTypes>
            <typeReference type="EditorPart"/>
          </baseTypes>
          <members>
            <memberField type="AppSelector" name="selector"/>
            <!-- method CreateChildControls() -->
            <memberMethod name="CreateChildControls">
              <attributes family="true" override="true"/>
              <statements>
                <assignStatement>
                  <propertyReferenceExpression name="Title">
                    <thisReferenceExpression/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="Settings"/>
                </assignStatement>
                <methodInvokeExpression methodName="CreateChildControls">
                  <target>
                    <baseReferenceExpression/>
                  </target>
                </methodInvokeExpression>
                <assignStatement>
                  <fieldReferenceExpression name="selector"/>
                  <objectCreateExpression type="AppSelector"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="ID">
                    <fieldReferenceExpression name="selector"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="AppSelector"/>
                </assignStatement>
                <conditionStatement>
                  <condition>
                    <propertyReferenceExpression name="IsDesignTime">
                      <propertyReferenceExpression name="Current">
                        <typeReferenceExpression type="SPContext"/>
                      </propertyReferenceExpression>
                    </propertyReferenceExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <propertyReferenceExpression name="Controls"/>
                      </target>
                      <parameters>
                        <objectCreateExpression type="LiteralControl">
                          <parameters>
                            <primitiveExpression value="&lt;div style=&quot;width:90%;&quot;&gt;"/>
                          </parameters>
                        </objectCreateExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <methodInvokeExpression methodName="Add">
                  <target>
                    <propertyReferenceExpression name="Controls"/>
                  </target>
                  <parameters>
                    <fieldReferenceExpression name="selector"/>
                  </parameters>
                </methodInvokeExpression>
                <conditionStatement>
                  <condition>
                    <propertyReferenceExpression name="IsDesignTime">
                      <propertyReferenceExpression name="Current">
                        <typeReferenceExpression type="SPContext"/>
                      </propertyReferenceExpression>
                    </propertyReferenceExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <propertyReferenceExpression name="Controls"/>
                      </target>
                      <parameters>
                        <objectCreateExpression type="LiteralControl">
                          <parameters>
                            <primitiveExpression value="&lt;/div&gt;"/>
                          </parameters>
                        </objectCreateExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <assignStatement>
                  <propertyReferenceExpression name="ApplicationPage">
                    <fieldReferenceExpression name="selector"/>
                  </propertyReferenceExpression>
                  <propertyReferenceExpression name="ApplicationPage">
                    <castExpression targetType="AppWebPart">
                      <propertyReferenceExpression name="WebPartToEdit"/>
                    </castExpression>
                  </propertyReferenceExpression>
                </assignStatement>
              </statements>
            </memberMethod>
            <!-- method ApplyChanges() -->
            <memberMethod returnType="System.Boolean" name="ApplyChanges">
              <attributes public="true" override="true"/>
              <statements>
                <methodInvokeExpression methodName="EnsureChildControls"/>
                <assignStatement>
                  <propertyReferenceExpression name="ApplicationPage">
                    <castExpression targetType="AppWebPart">
                      <propertyReferenceExpression name="WebPartToEdit"/>
                    </castExpression>
                  </propertyReferenceExpression>
                  <propertyReferenceExpression name="ApplicationPage">
                    <fieldReferenceExpression name="selector"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <methodReturnStatement>
                  <primitiveExpression value="true"/>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method SyncChanges() -->
            <memberMethod name="SyncChanges">
              <attributes public="true" override="true"/>
              <statements>
                <methodInvokeExpression methodName="EnsureChildControls"/>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
      </types>
    </compileUnit>
  </xsl:template>
</xsl:stylesheet>
