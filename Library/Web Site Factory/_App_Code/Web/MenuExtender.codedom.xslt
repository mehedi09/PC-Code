<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.codeontime.com/2008/codedom-compiler"  xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl a"
>
  <xsl:output method="xml" indent="yes"/>
  <xsl:param name="IsClassLibrary" select="'false'"/>
  <xsl:param name="ScriptOnly" select="'false'"/>
  <xsl:param name="Namespace" select="a:project/a:namespace"/>
  <xsl:param name="Theme" select="'Aquarium'"/>
  <xsl:param name="ProjectId"/>
  <xsl:param name="Mobile" />
  <xsl:variable name="MembershipEnabled" select="a:project/a:membership/@enabled='true'"/>

  <xsl:template match="/">
    <compileUnit namespace="{$Namespace}.Web">
      <imports>
        <namespaceImport name="System"/>
        <namespaceImport name="System.Data"/>
        <namespaceImport name="System.Collections.Generic"/>
        <namespaceImport name="System.ComponentModel"/>
        <namespaceImport name="System.Linq"/>
        <namespaceImport name="System.Text"/>
        <namespaceImport name="System.Web"/>
        <namespaceImport name="System.Web.UI"/>
        <namespaceImport name="System.Web.UI.HtmlControls"/>
        <namespaceImport name="System.Web.UI.WebControls"/>
        <xsl:if test="$ScriptOnly='false'">
          <namespaceImport name="AjaxControlToolkit"/>
        </xsl:if>
        <namespaceImport name="{$Namespace}.Data"/>
        <namespaceImport name="{$Namespace}.Services"/>
      </imports>
      <types>
        <!-- enum MenuHoverStyle -->
        <typeDeclaration name="MenuHoverStyle" isEnum="true">
          <members>
            <memberField name="Auto">
              <attributes public="true"/>
              <init>
                <primitiveExpression value="1"/>
              </init>
            </memberField>
            <memberField name="Click">
              <attributes public="true"/>
              <init>
                <primitiveExpression value="1"/>
              </init>
            </memberField>
            <memberField name="ClickAndStay">
              <attributes public="true"/>
              <init>
                <primitiveExpression value="1"/>
              </init>
            </memberField>
          </members>
        </typeDeclaration>
        <!-- enum MenuPresentationStyle -->
        <typeDeclaration name="MenuPresentationStyle" isEnum="true">
          <members>
            <memberField name="MultiLevel">
              <attributes public="true"/>
            </memberField>
            <memberField name="TwoLevel">
              <attributes public="true"/>
            </memberField>
            <memberField name="NavigationButton">
              <attributes public="true"/>
            </memberField>
          </members>
        </typeDeclaration>
        <!-- enum MenuOrientation -->
        <typeDeclaration name="MenuOrientation" isEnum="true">
          <members>
            <memberField name="Horizontal">
              <attributes public="true"/>
            </memberField>
          </members>
        </typeDeclaration>
        <!-- enum PopupPosition -->
        <typeDeclaration name="MenuPopupPosition" isEnum="true">
          <members>
            <memberField name="Left">
              <attributes public="true"/>
            </memberField>
            <memberField name="Right">
              <attributes public="true"/>
            </memberField>
          </members>
        </typeDeclaration>
        <!-- enum ItemDescriptionStyle -->
        <typeDeclaration name="MenuItemDescriptionStyle" isEnum="true">
          <members>
            <memberField name="None">
              <attributes public="true"/>
            </memberField>
            <memberField name="Inline">
              <attributes public="true"/>
            </memberField>
            <memberField name="ToolTip">
              <attributes public="true"/>
            </memberField>
          </members>
        </typeDeclaration>
        <!-- class MembershipBarExtender -->
        <typeDeclaration name="MenuExtender">
          <customAttributes>
            <customAttribute name="TargetControlType">
              <arguments>
                <typeofExpression type="Panel"/>
              </arguments>
            </customAttribute>
            <customAttribute name="TargetControlType">
              <arguments>
                <typeofExpression type="HtmlContainerControl"/>
              </arguments>
            </customAttribute>
            <customAttribute name="DefaultProperty">
              <arguments>
                <primitiveExpression value="TargetControlID"/>
              </arguments>
            </customAttribute>
            <!--<xsl:if test="$IsClassLibrary='true'">
              <customAttribute name="ClientCssResource">
                <arguments>
                  -->
            <!--<primitiveExpression value="{$Namespace}.Theme.Membership.css"/>-->
            <!--
                  <primitiveExpression value="{$Namespace}.Theme.{$Theme}.css"/>
                </arguments>
              </customAttribute>
            </xsl:if>-->
          </customAttributes>
          <baseTypes>
            <typeReference type="System.Web.UI.WebControls.HierarchicalDataBoundControl"/>
            <typeReference type="IExtenderControl"/>
          </baseTypes>
          <members>
            <memberField type="System.String" name="items"/>
            <memberField type="ScriptManager" name="sm"/>
            <!-- TargetControlID -->
            <memberField type="System.String" name="targetControlID"/>
            <memberProperty type="System.String" name="TargetControlID">
              <attributes public="true" final="true"/>
              <customAttributes>
                <customAttribute name="IDReferenceProperty"/>
                <customAttribute name="Category">
                  <arguments>
                    <primitiveExpression value="Behavior"/>
                  </arguments>
                </customAttribute>
                <customAttribute name="DefaultValue">
                  <arguments>
                    <primitiveExpression value=""/>
                  </arguments>
                </customAttribute>
              </customAttributes>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="targetControlID"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="targetControlID"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property Visible -->
            <memberField type="System.Boolean" name="visible"/>
            <memberProperty type="System.Boolean" name="Visible">
              <attributes public="true" override="true"/>
              <customAttributes>
                <customAttribute name="EditorBrowsable">
                  <arguments>
                    <propertyReferenceExpression name="Never">
                      <typeReferenceExpression type="EditorBrowsableState"/>
                    </propertyReferenceExpression>
                  </arguments>
                </customAttribute>
                <customAttribute name="DesignerSerializationVisibility">
                  <arguments>
                    <propertyReferenceExpression name="Hidden">
                      <typeReferenceExpression type="DesignerSerializationVisibility"/>
                    </propertyReferenceExpression>
                  </arguments>
                </customAttribute>
                <customAttribute name="Browsable">
                  <arguments>
                    <primitiveExpression value="false"/>
                  </arguments>
                </customAttribute>
              </customAttributes>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="visible"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="visible"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property HoverStyle -->
            <memberField type="MenuHoverStyle" name="hoverStyle"/>
            <memberProperty type="MenuHoverStyle" name="HoverStyle">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="hoverStyle"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="hoverStyle"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property PopupPosition -->
            <memberField type="MenuPopupPosition" name="popupPosition"/>
            <memberProperty type="MenuPopupPosition" name="PopupPosition">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="popupPosition"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="popupPosition"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property ItemDescriptionStyle -->
            <memberField type="MenuItemDescriptionStyle" name="itemDescriptionStyle"/>
            <memberProperty type="MenuItemDescriptionStyle" name="ItemDescriptionStyle">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="itemDescriptionStyle"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="itemDescriptionStyle"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property ShowSiteActions -->
            <memberField type="System.Boolean" name="showSiteActions"/>
            <memberProperty type="System.Boolean" name="ShowSiteActions">
              <attributes public="true" final="true"/>
              <customAttributes>
                <customAttribute name="System.ComponentModel.Description">
                  <arguments>
                    <primitiveExpression value="The &quot;Site Actions&quot; menu is automatically displayed."/>
                  </arguments>
                </customAttribute>
                <customAttribute name="System.ComponentModel.DefaultValue">
                  <arguments>
                    <primitiveExpression value="false"/>
                  </arguments>
                </customAttribute>
              </customAttributes>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="showSiteActions"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="showSiteActions"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property PresentationStyle -->
            <memberProperty type="MenuPresentationStyle" name="PresentationStyle">
              <attributes public="true" final="true"/>
              <customAttributes>
                <customAttribute name="System.ComponentModel.Description">
                  <arguments>
                    <primitiveExpression value="Specifies the menu presentation style."/>
                  </arguments>
                </customAttribute>
                <customAttribute name="System.ComponentModel.DefaultValue">
                  <arguments>
                    <propertyReferenceExpression name="MultiLevel">
                      <typeReferenceExpression type="MenuPresentationStyle"/>
                    </propertyReferenceExpression>
                  </arguments>
                </customAttribute>
              </customAttributes>
            </memberProperty>
            <!-- constructor -->
            <constructor>
              <attributes public="true"/>
              <baseConstructorArgs/>
              <statements>
                <assignStatement>
                  <propertyReferenceExpression name="Visible">
                    <thisReferenceExpression/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="true"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="ItemDescriptionStyle"/>
                  <propertyReferenceExpression name="ToolTip">
                    <typeReferenceExpression type="MenuItemDescriptionStyle"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="HoverStyle"/>
                  <propertyReferenceExpression name="Auto">
                    <typeReferenceExpression type="MenuHoverStyle"/>
                  </propertyReferenceExpression>
                </assignStatement>
              </statements>
            </constructor>
            <!-- method PerformDataBinding() -->
            <memberMethod name="PerformDataBinding">
              <attributes family="true" override="true"/>
              <statements>
                <methodInvokeExpression methodName="PerformDataBinding">
                  <target>
                    <baseReferenceExpression/>
                  </target>
                </methodInvokeExpression>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <unaryOperatorExpression operator="Not">
                        <propertyReferenceExpression name="IsBoundUsingDataSourceID"/>
                      </unaryOperatorExpression>
                      <binaryOperatorExpression operator="IdentityInequality">
                        <propertyReferenceExpression name="DataSource"/>
                        <primitiveExpression value="null"/>
                      </binaryOperatorExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement/>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="HierarchicalDataSourceView" name="view">
                  <init>
                    <methodInvokeExpression methodName="GetData">
                      <parameters>
                        <propertyReferenceExpression name="Empty">
                          <typeReferenceExpression type="String"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="IHierarchicalEnumerable" name="enumerable">
                  <init>
                    <methodInvokeExpression methodName="Select">
                      <target>
                        <variableReferenceExpression name="view"/>
                      </target>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <variableReferenceExpression name="enumerable"/>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <variableDeclarationStatement type="StringBuilder" name="sb">
                      <init>
                        <objectCreateExpression type="StringBuilder"/>
                      </init>
                    </variableDeclarationStatement>
                    <methodInvokeExpression methodName="RecursiveDataBindInternal">
                      <parameters>
                        <variableReferenceExpression name="enumerable"/>
                        <variableReferenceExpression name="sb"/>
                      </parameters>
                    </methodInvokeExpression>
                    <assignStatement>
                      <fieldReferenceExpression name="items"/>
                      <methodInvokeExpression methodName="ToString">
                        <target>
                          <variableReferenceExpression name="sb"/>
                        </target>
                      </methodInvokeExpression>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method RecursiveDataBindInternal(IHierarchicalEnumerable, sb) -->
            <memberMethod name="RecursiveDataBindInternal">
              <attributes private="true"/>
              <parameters>
                <parameter type="IHierarchicalEnumerable" name="enumerable"/>
                <parameter type="StringBuilder" name="sb"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="System.Boolean" name="first">
                  <init>
                    <primitiveExpression value="true"/>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityInequality">
                      <propertyReferenceExpression name="Site">
                        <thisReferenceExpression/>
                      </propertyReferenceExpression>
                      <primitiveExpression value="null"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement></methodReturnStatement>
                  </trueStatements>
                </conditionStatement>
                <foreachStatement>
                  <variable type="System.Object" name="item"/>
                  <target>
                    <argumentReferenceExpression name="enumerable"/>
                  </target>
                  <statements>
                    <variableDeclarationStatement type="IHierarchyData" name="data">
                      <init>
                        <methodInvokeExpression methodName="GetHierarchyData">
                          <target>
                            <argumentReferenceExpression name="enumerable"/>
                          </target>
                          <parameters>
                            <variableReferenceExpression name="item"/>
                          </parameters>
                        </methodInvokeExpression>
                      </init>
                    </variableDeclarationStatement>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="IdentityInequality">
                          <primitiveExpression value="null"/>
                          <variableReferenceExpression name="data"/>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <variableDeclarationStatement type="PropertyDescriptorCollection" name="props">
                          <init>
                            <methodInvokeExpression methodName="GetProperties">
                              <target>
                                <typeReferenceExpression type="TypeDescriptor"/>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="data"/>
                              </parameters>
                            </methodInvokeExpression>
                          </init>
                        </variableDeclarationStatement>
                        <conditionStatement>
                          <condition>
                            <binaryOperatorExpression operator="GreaterThan">
                              <propertyReferenceExpression name="Count">
                                <variableReferenceExpression name="props"/>
                              </propertyReferenceExpression>
                              <primitiveExpression value="0"/>
                            </binaryOperatorExpression>
                          </condition>
                          <trueStatements>
                            <variableDeclarationStatement type="System.String" name="title">
                              <init>
                                <castExpression targetType="System.String">
                                  <methodInvokeExpression  methodName="GetValue">
                                    <target>
                                      <arrayIndexerExpression>
                                        <target>
                                          <variableReferenceExpression name="props"/>
                                        </target>
                                        <indices>
                                          <primitiveExpression value="Title"/>
                                        </indices>
                                      </arrayIndexerExpression>
                                    </target>
                                    <parameters>
                                      <variableReferenceExpression name="data"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                </castExpression>
                              </init>
                            </variableDeclarationStatement>
                            <variableDeclarationStatement type="System.String" name="description">
                              <init>
                                <castExpression targetType="System.String">
                                  <methodInvokeExpression  methodName="GetValue">
                                    <target>
                                      <arrayIndexerExpression>
                                        <target>
                                          <variableReferenceExpression name="props"/>
                                        </target>
                                        <indices>
                                          <primitiveExpression value="Description"/>
                                        </indices>
                                      </arrayIndexerExpression>
                                    </target>
                                    <parameters>
                                      <variableReferenceExpression name="data"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                </castExpression>
                              </init>
                            </variableDeclarationStatement>
                            <variableDeclarationStatement type="System.String" name="url">
                              <init>
                                <castExpression targetType="System.String">
                                  <methodInvokeExpression  methodName="GetValue">
                                    <target>
                                      <arrayIndexerExpression>
                                        <target>
                                          <variableReferenceExpression name="props"/>
                                        </target>
                                        <indices>
                                          <primitiveExpression value="Url"/>
                                        </indices>
                                      </arrayIndexerExpression>
                                    </target>
                                    <parameters>
                                      <variableReferenceExpression name="data"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                </castExpression>
                              </init>
                            </variableDeclarationStatement>
                            <variableDeclarationStatement type="System.String" name="cssClass">
                              <init>
                                <primitiveExpression value="null"/>
                              </init>
                            </variableDeclarationStatement>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="IsTypeOf">
                                  <variableReferenceExpression name="item"/>
                                  <typeReferenceExpression type="SiteMapNode"/>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="cssClass"/>
                                  <arrayIndexerExpression>
                                    <target>
                                      <castExpression targetType="SiteMapNode">
                                        <variableReferenceExpression name="item"/>
                                      </castExpression>
                                    </target>
                                    <indices>
                                      <primitiveExpression value="cssClass"/>
                                    </indices>
                                  </arrayIndexerExpression>
                                </assignStatement>
                              </trueStatements>
                            </conditionStatement>
                            <conditionStatement>
                              <condition>
                                <variableReferenceExpression name="first"/>
                              </condition>
                              <trueStatements>
                                <assignStatement>
                                  <variableReferenceExpression name="first"/>
                                  <primitiveExpression value="false"/>
                                </assignStatement>
                              </trueStatements>
                              <falseStatements>
                                <methodInvokeExpression methodName="Append">
                                  <target>
                                    <argumentReferenceExpression name="sb"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value=","/>
                                  </parameters>
                                </methodInvokeExpression>
                              </falseStatements>
                            </conditionStatement>
                            <methodInvokeExpression methodName="AppendFormat">
                              <target>
                                <argumentReferenceExpression name="sb"/>
                              </target>
                              <parameters>
                                <primitiveExpression>
                                  <xsl:attribute name="value"><![CDATA[{{'title':'{0}','url':'{1}']]></xsl:attribute>
                                </primitiveExpression>
                                <methodInvokeExpression methodName="JavaScriptString">
                                  <target>
                                    <typeReferenceExpression type="BusinessRules"/>
                                  </target>
                                  <parameters>
                                    <variableReferenceExpression name="title"/>
                                  </parameters>
                                </methodInvokeExpression>
                                <methodInvokeExpression methodName="JavaScriptString">
                                  <target>
                                    <typeReferenceExpression type="BusinessRules"/>
                                  </target>
                                  <parameters>
                                    <variableReferenceExpression name="url"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </parameters>
                            </methodInvokeExpression>
                            <conditionStatement>
                              <condition>
                                <unaryOperatorExpression operator="Not">
                                  <methodInvokeExpression methodName="IsNullOrEmpty">
                                    <target>
                                      <typeReferenceExpression type="String"/>
                                    </target>
                                    <parameters>
                                      <variableReferenceExpression name="description"/>
                                    </parameters>
                                  </methodInvokeExpression>
                                </unaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <methodInvokeExpression methodName="AppendFormat">
                                  <target>
                                    <argumentReferenceExpression name="sb"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression>
                                      <xsl:attribute name="value"><![CDATA[,'description':'{0}']]></xsl:attribute>
                                    </primitiveExpression>
                                    <methodInvokeExpression methodName="JavaScriptString">
                                      <target>
                                        <typeReferenceExpression type="BusinessRules"/>
                                      </target>
                                      <parameters>
                                        <variableReferenceExpression name="description"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </trueStatements>
                            </conditionStatement>
                            <conditionStatement>
                              <condition>
                                <binaryOperatorExpression operator="ValueEquality">
                                  <variableReferenceExpression name="url"/>
                                  <propertyReferenceExpression name="RawUrl">
                                    <propertyReferenceExpression name="Request">
                                      <propertyReferenceExpression name="Page"/>
                                    </propertyReferenceExpression>
                                  </propertyReferenceExpression>
                                </binaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <methodInvokeExpression methodName="Append">
                                  <target>
                                    <argumentReferenceExpression name="sb"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value=",'selected':true"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </trueStatements>
                            </conditionStatement>
                            <conditionStatement>
                              <condition>
                                <unaryOperatorExpression operator="IsNotNullOrEmpty">
                                  <variableReferenceExpression name="cssClass"/>
                                </unaryOperatorExpression>
                              </condition>
                              <trueStatements>
                                <methodInvokeExpression methodName="AppendFormat">
                                  <target>
                                    <argumentReferenceExpression name="sb"/>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value=",'cssClass':'{{0}}'"/>
                                    <variableReferenceExpression name="cssClass"/>
                                  </parameters>
                                </methodInvokeExpression>
                              </trueStatements>
                            </conditionStatement>
                            <conditionStatement>
                              <condition>
                                <propertyReferenceExpression name="HasChildren">
                                  <variableReferenceExpression name="data"/>
                                </propertyReferenceExpression>
                              </condition>
                              <trueStatements>
                                <variableDeclarationStatement type="IHierarchicalEnumerable" name="childEnumerable">
                                  <init>
                                    <methodInvokeExpression methodName="GetChildren">
                                      <target>
                                        <variableReferenceExpression name="data"/>
                                      </target>
                                    </methodInvokeExpression>
                                  </init>
                                </variableDeclarationStatement>
                                <conditionStatement>
                                  <condition>
                                    <binaryOperatorExpression operator="IdentityInequality">
                                      <primitiveExpression value="null"/>
                                      <variableReferenceExpression name="childEnumerable"/>
                                    </binaryOperatorExpression>
                                  </condition>
                                  <trueStatements>
                                    <methodInvokeExpression methodName="Append">
                                      <target>
                                        <argumentReferenceExpression name="sb"/>
                                      </target>
                                      <parameters>
                                        <primitiveExpression value=",'children':["/>
                                      </parameters>
                                    </methodInvokeExpression>
                                    <methodInvokeExpression methodName="RecursiveDataBindInternal">
                                      <parameters>
                                        <variableReferenceExpression name="childEnumerable"/>
                                        <argumentReferenceExpression name="sb"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                    <methodInvokeExpression methodName="Append">
                                      <target>
                                        <argumentReferenceExpression name="sb"/>
                                      </target>
                                      <parameters>
                                        <primitiveExpression value="]"/>
                                      </parameters>
                                    </methodInvokeExpression>
                                  </trueStatements>
                                </conditionStatement>
                              </trueStatements>
                            </conditionStatement>
                            <methodInvokeExpression methodName="Append">
                              <target>
                                <argumentReferenceExpression name="sb"/>
                              </target>
                              <parameters>
                                <primitiveExpression value="}}"/>
                              </parameters>
                            </methodInvokeExpression>
                          </trueStatements>
                        </conditionStatement>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
              </statements>
            </memberMethod>
            <!-- method OnInit(EventArgs) -->
            <memberMethod name="OnInit">
              <attributes family="true" override="true"/>
              <parameters>
                <parameter type="EventArgs" name="e"/>
              </parameters>
              <statements>
                <methodInvokeExpression methodName="OnInit">
                  <target>
                    <baseReferenceExpression/>
                  </target>
                  <parameters>
                    <argumentReferenceExpression name="e"/>
                  </parameters>
                </methodInvokeExpression>
                <assignStatement>
                  <fieldReferenceExpression name="sm"/>
                  <methodInvokeExpression methodName="GetCurrent">
                    <target>
                      <typeReferenceExpression type="ScriptManager"/>
                    </target>
                    <parameters>
                      <propertyReferenceExpression name="Page"/>
                    </parameters>
                  </methodInvokeExpression>
                </assignStatement>
              </statements>
            </memberMethod>
            <!-- method OnLoad(EventArgs) -->
            <memberMethod name="OnLoad">
              <attributes family="true" override="true"/>
              <parameters>
                <parameter type="EventArgs" name="e"/>
              </parameters>
              <statements>
                <methodInvokeExpression methodName="OnLoad">
                  <target>
                    <baseReferenceExpression/>
                  </target>
                  <parameters>
                    <argumentReferenceExpression name="e"/>
                  </parameters>
                </methodInvokeExpression>
                <methodInvokeExpression methodName="RegisterFrameworkSettings">
                  <target>
                    <typeReferenceExpression type="AquariumExtenderBase"/>
                  </target>
                  <parameters>
                    <propertyReferenceExpression name="Page"/>
                  </parameters>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- method OnPreRender(EventArgs) -->
            <memberMethod name="OnPreRender">
              <attributes family="true" override="true"/>
              <parameters>
                <parameter type="EventArgs" name="e"/>
              </parameters>
              <statements>
                <methodInvokeExpression methodName="OnPreRender">
                  <target>
                    <baseReferenceExpression/>
                  </target>
                  <parameters>
                    <argumentReferenceExpression name="e"/>
                  </parameters>
                </methodInvokeExpression>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="IdentityEquality">
                      <primitiveExpression value="null"/>
                      <fieldReferenceExpression name="sm"/>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement/>
                  </trueStatements>
                </conditionStatement>
                <variableDeclarationStatement type="System.String" name="script">
                  <init>
                    <methodInvokeExpression methodName="Format">
                      <target>
                        <typeReferenceExpression type="String"/>
                      </target>
                      <parameters>
                        <primitiveExpression>
                          <xsl:attribute name="value"><![CDATA[Web.Menu.Nodes.{0}=[{1}];]]></xsl:attribute>
                        </primitiveExpression>
                        <propertyReferenceExpression name="ClientID">
                          <thisReferenceExpression/>
                        </propertyReferenceExpression>
                        <fieldReferenceExpression name="items"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <variableDeclarationStatement type="Control" name="target">
                  <init>
                    <methodInvokeExpression methodName="FindControl">
                      <target>
                        <propertyReferenceExpression name="Form">
                          <propertyReferenceExpression name="Page"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <propertyReferenceExpression name="TargetControlID"/>
                      </parameters>
                    </methodInvokeExpression>
                  </init>
                </variableDeclarationStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanAnd">
                      <binaryOperatorExpression operator="IdentityInequality">
                        <primitiveExpression value="null"/>
                        <variableReferenceExpression name="target"/>
                      </binaryOperatorExpression>
                      <propertyReferenceExpression name="Visible">
                        <variableReferenceExpression name="target"/>
                      </propertyReferenceExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="RegisterStartupScript">
                      <target>
                        <typeReferenceExpression type="ScriptManager"/>
                      </target>
                      <parameters>
                        <thisReferenceExpression/>
                        <typeofExpression type="MenuExtender"/>
                        <primitiveExpression value="Nodes"/>
                        <variableReferenceExpression name="script"/>
                        <primitiveExpression value="true"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <methodInvokeExpression methodName="RegisterExtenderControl">
                  <typeArguments>
                    <typeReference type="MenuExtender"/>
                  </typeArguments>
                  <target>
                    <fieldReferenceExpression name="sm"/>
                  </target>
                  <parameters>
                    <thisReferenceExpression/>
                    <variableReferenceExpression name="target"/>
                  </parameters>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- method Render(HtmlTextWriter)-->
            <memberMethod name="Render">
              <attributes family="true" override="true"/>
              <parameters>
                <parameter type="HtmlTextWriter" name="writer"/>
              </parameters>
              <statements>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="BooleanOr">
                      <binaryOperatorExpression operator="IdentityEquality">
                        <primitiveExpression value="null"/>
                        <fieldReferenceExpression name="sm"/>
                      </binaryOperatorExpression>
                      <propertyReferenceExpression name="IsInAsyncPostBack">
                        <fieldReferenceExpression name="sm"/>
                      </propertyReferenceExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodReturnStatement/>
                  </trueStatements>
                </conditionStatement>
                <methodInvokeExpression methodName="RegisterScriptDescriptors">
                  <target>
                    <fieldReferenceExpression name="sm"/>
                  </target>
                  <parameters>
                    <thisReferenceExpression/>
                  </parameters>
                </methodInvokeExpression>
              </statements>
            </memberMethod>
            <!-- method IExtenderControl.GetScriptDescriptors(Control)-->
            <memberMethod returnType="IEnumerable" name="GetScriptDescriptors" privateImplementationType="IExtenderControl">
              <typeArguments>
                <typeReference type="ScriptDescriptor"/>
              </typeArguments>
              <attributes/>
              <parameters>
                <parameter type="Control" name="targetControl"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="ScriptBehaviorDescriptor" name="descriptor">
                  <init>
                    <objectCreateExpression type="ScriptBehaviorDescriptor">
                      <parameters>
                        <primitiveExpression value="Web.Menu"/>
                        <propertyReferenceExpression name="ClientID">
                          <argumentReferenceExpression name="targetControl"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </objectCreateExpression>
                  </init>
                </variableDeclarationStatement>
                <methodInvokeExpression methodName="AddProperty">
                  <target>
                    <variableReferenceExpression name="descriptor"/>
                  </target>
                  <parameters>
                    <primitiveExpression value="id"/>
                    <propertyReferenceExpression name="ClientID">
                      <thisReferenceExpression/>
                    </propertyReferenceExpression>
                  </parameters>
                </methodInvokeExpression>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueInequality">
                      <propertyReferenceExpression name="HoverStyle"/>
                      <propertyReferenceExpression name="Auto">
                        <typeReferenceExpression type="MenuHoverStyle"/>
                      </propertyReferenceExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="AddProperty">
                      <target>
                        <variableReferenceExpression name="descriptor"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="hoverStyle"/>
                        <methodInvokeExpression methodName="ToInt32">
                          <target>
                            <typeReferenceExpression type="Convert"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="HoverStyle"/>
                          </parameters>
                        </methodInvokeExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueInequality">
                      <propertyReferenceExpression name="PopupPosition"/>
                      <propertyReferenceExpression name="Left">
                        <typeReferenceExpression type="MenuPopupPosition"/>
                      </propertyReferenceExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="AddProperty">
                      <target>
                        <variableReferenceExpression name="descriptor"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="popupPosition"/>
                        <methodInvokeExpression methodName="ToInt32">
                          <target>
                            <typeReferenceExpression type="Convert"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="PopupPosition"/>
                          </parameters>
                        </methodInvokeExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueInequality">
                      <propertyReferenceExpression name="ItemDescriptionStyle"/>
                      <propertyReferenceExpression name="ToolTip">
                        <typeReferenceExpression type="MenuItemDescriptionStyle"/>
                      </propertyReferenceExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="AddProperty">
                      <target>
                        <variableReferenceExpression name="descriptor"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="itemDescriptionStyle"/>
                        <methodInvokeExpression methodName="ToInt32">
                          <target>
                            <typeReferenceExpression type="Convert"/>
                          </target>
                          <parameters>
                            <propertyReferenceExpression name="ItemDescriptionStyle"/>
                          </parameters>
                        </methodInvokeExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <propertyReferenceExpression name="ShowSiteActions"/>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="AddProperty">
                      <target>
                        <variableReferenceExpression name="descriptor"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="showSiteActions"/>
                        <primitiveExpression value="true" convertTo="String"/>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueInequality">
                      <propertyReferenceExpression name="PresentationStyle"/>
                      <propertyReferenceExpression name="MultiLevel">
                        <typeReferenceExpression type="MenuPresentationStyle"/>
                      </propertyReferenceExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="AddProperty">
                      <target>
                        <argumentReferenceExpression name="descriptor"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="presentationStyle"/>
                        <convertExpression to="Int32">
                          <propertyReferenceExpression name="PresentationStyle"/>
                        </convertExpression>
                      </parameters>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <methodReturnStatement>
                  <arrayCreateExpression>
                    <createType type="ScriptBehaviorDescriptor"/>
                    <initializers>
                      <variableReferenceExpression name="descriptor"/>
                    </initializers>
                  </arrayCreateExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
            <!-- method IExtenderControl.GetScriptReferences() -->
            <memberMethod returnType="IEnumerable" name="GetScriptReferences" privateImplementationType="IExtenderControl">
              <typeArguments>
                <typeReference type="ScriptReference"/>
              </typeArguments>
              <attributes/>
              <statements>
                <methodReturnStatement>
                  <methodInvokeExpression methodName="StandardScripts">
                    <target>
                      <typeReferenceExpression type="AquariumExtenderBase"/>
                    </target>
                  </methodInvokeExpression>
                </methodReturnStatement>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
      </types>
    </compileUnit>
  </xsl:template>
</xsl:stylesheet>
