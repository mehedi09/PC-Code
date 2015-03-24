<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="http://www.codeontime.com/2008/codedom-compiler"  xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl a"
>
  <xsl:output method="xml" indent="yes"/>

  <xsl:template match="/">
    <compileUnit namespace="{a:project/a:namespace}.Data">
      <imports>
        <namespaceImport name="System"/>
        <namespaceImport name="System.Collections.Generic"/>
        <namespaceImport name="System.ComponentModel"/>
        <namespaceImport name="System.Data"/>
        <namespaceImport name="System.Data.Common"/>
        <namespaceImport name="System.Linq"/>
        <namespaceImport name="System.Text"/>
        <namespaceImport name="System.Text.RegularExpressions"/>
        <namespaceImport name="System.Xml"/>
        <namespaceImport name="System.Xml.XPath"/>
        <namespaceImport name="System.Web"/>
        <namespaceImport name="System.Web.Caching"/>
        <namespaceImport name="System.Web.Configuration"/>
        <namespaceImport name="System.Web.Security"/>
      </imports>
      <types>
        <!-- class View -->
        <typeDeclaration name="View">
          <members>
            <!-- property Id -->
            <memberField type="System.String" name="id"/>
            <memberProperty type="System.String" name="Id">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="id"/>
                </methodReturnStatement>
              </getStatements>
              <setStatements>
                <assignStatement>
                  <fieldReferenceExpression name="id"/>
                  <propertySetValueReferenceExpression/>
                </assignStatement>
              </setStatements>
            </memberProperty>
            <!-- property Label -->
            <memberField type="System.String" name="label"/>
            <memberProperty type="System.String" name="Label">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="label"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property HeaderText -->
            <memberField type="System.String" name="headerText"/>
            <memberProperty type="System.String" name="HeaderText">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="headerText"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property Type -->
            <memberField type="System.String" name="type"/>
            <memberProperty type="System.String" name="Type">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="type"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property Group -->
            <memberField type="System.String" name="group"/>
            <memberProperty type="System.String" name="Group">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="group"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- property ShowInSelector -->
            <memberField type="System.Boolean" name="showInSelector"/>
            <memberProperty type="System.Boolean" name="ShowInSelector">
              <attributes public="true" final="true"/>
              <getStatements>
                <methodReturnStatement>
                  <fieldReferenceExpression name="showInSelector"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- constructor View() -->
            <constructor>
              <attributes public="true"/>
            </constructor>
            <!-- constructor View(XPathNavigator, XPathNavigator, IXmlNamespaceResolver) -->
            <constructor>
              <attributes public="true"/>
              <parameters>
                <parameter type="XPathNavigator" name="view"/>
                <parameter type="XPathNavigator" name="mainView"/>
                <parameter type="IXmlNamespaceResolver" name="resolver"/>
              </parameters>
              <statements>
                <assignStatement>
                  <fieldReferenceExpression name="id">
                    <thisReferenceExpression/>
                  </fieldReferenceExpression>
                  <methodInvokeExpression methodName="GetAttribute">
                    <target>
                      <argumentReferenceExpression name="view"/>
                    </target>
                    <parameters>
                      <primitiveExpression value="id"/>
                      <propertyReferenceExpression name="Empty">
                        <typeReferenceExpression type="String"/>
                      </propertyReferenceExpression>
                    </parameters>
                  </methodInvokeExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="type">
                    <thisReferenceExpression/>
                  </fieldReferenceExpression>
                  <methodInvokeExpression methodName="GetAttribute">
                    <target>
                      <argumentReferenceExpression name="view"/>
                    </target>
                    <parameters>
                      <primitiveExpression value="type"/>
                      <propertyReferenceExpression name="Empty">
                        <typeReferenceExpression type="String"/>
                      </propertyReferenceExpression>
                    </parameters>
                  </methodInvokeExpression>
                </assignStatement>
                <conditionStatement>
                  <condition>
                    <binaryOperatorExpression operator="ValueEquality">
                      <fieldReferenceExpression name="id">
                        <thisReferenceExpression/>
                      </fieldReferenceExpression>
                      <methodInvokeExpression methodName="GetAttribute">
                        <target>
                          <argumentReferenceExpression name="mainView"/>
                        </target>
                        <parameters>
                          <primitiveExpression value="virtualViewId"/>
                          <propertyReferenceExpression name="Empty">
                            <typeReferenceExpression type="String"/>
                          </propertyReferenceExpression>
                        </parameters>
                      </methodInvokeExpression>
                    </binaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <assignStatement>
                      <argumentReferenceExpression name="view"/>
                      <argumentReferenceExpression name="mainView"/>
                    </assignStatement>
                  </trueStatements>
                </conditionStatement>
                <assignStatement>
                  <fieldReferenceExpression name="label">
                    <thisReferenceExpression/>
                  </fieldReferenceExpression>
                  <methodInvokeExpression methodName="GetAttribute">
                    <target>
                      <argumentReferenceExpression name="view"/>
                    </target>
                    <parameters>
                      <primitiveExpression value="label"/>
                      <propertyReferenceExpression name="Empty">
                        <typeReferenceExpression type="String"/>
                      </propertyReferenceExpression>
                    </parameters>
                  </methodInvokeExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="headerText">
                    <thisReferenceExpression/>
                  </fieldReferenceExpression>
                  <castExpression targetType="System.String">
                    <methodInvokeExpression methodName="Evaluate">
                      <target>
                        <argumentReferenceExpression name="view"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="string(c:headerText)"/>
                        <argumentReferenceExpression name="resolver"/>
                      </parameters>
                    </methodInvokeExpression>
                  </castExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="group"/>
                  <methodInvokeExpression methodName="GetAttribute">
                    <target>
                      <argumentReferenceExpression name="view"/>
                    </target>
                    <parameters>
                      <primitiveExpression value="group"/>
                      <propertyReferenceExpression name="Empty">
                        <typeReferenceExpression type="String"/>
                      </propertyReferenceExpression>
                    </parameters>
                  </methodInvokeExpression>
                </assignStatement>
                <assignStatement>
                  <fieldReferenceExpression name="showInSelector"/>
                  <binaryOperatorExpression operator="ValueInequality">
                    <methodInvokeExpression methodName="GetAttribute">
                      <target>
                        <argumentReferenceExpression name="view"/>
                      </target>
                      <parameters>
                        <primitiveExpression value="showInSelector"/>
                        <propertyReferenceExpression name="Empty">
                          <typeReferenceExpression type="String"/>
                        </propertyReferenceExpression>
                      </parameters>
                    </methodInvokeExpression>
                    <primitiveExpression value="false" convertTo="String"/>
                  </binaryOperatorExpression>
                </assignStatement>
              </statements>
            </constructor>
          </members>
        </typeDeclaration>
      </types>
    </compileUnit>
  </xsl:template>
</xsl:stylesheet>
