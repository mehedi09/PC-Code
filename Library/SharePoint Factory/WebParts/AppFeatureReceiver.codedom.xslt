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
        <namespaceImport name="System.Linq"/>
        <namespaceImport name="System.Text"/>
        <namespaceImport name="Microsoft.SharePoint"/>
        <namespaceImport name="Microsoft.SharePoint.Administration"/>
      </imports>
      <types>

        <!-- class AppFeatureReceiver -->
        <typeDeclaration name="AppFeatureReceiver" isPartial="true">
          <baseTypes>
            <typeReference type="AppFeatureReceiverBase"/>
          </baseTypes>
        </typeDeclaration>

        <!-- class AppWebPartBase -->
        <typeDeclaration name="AppFeatureReceiverBase">
          <baseTypes>
            <typeReference type="SPFeatureReceiver"/>
          </baseTypes>
          <members>
            <!-- const AppConnectionStringModificationName -->
            <memberField type="System.String" name="AppConnectionStringModificationName">
              <attributes public="true"/>
              <init>
                <primitiveExpression>
                  <xsl:attribute name="value">
                    <xsl:text disable-output-escaping="yes"><![CDATA[add[@name="]]></xsl:text>
                    <xsl:value-of select="$Namespace"/>
                    <xsl:text><![CDATA["][@connectionString="]]></xsl:text>
                    <xsl:value-of select="/a:project/a:connectionString"/>
                    <xsl:text><![CDATA["][@providerName="]]></xsl:text>
                    <xsl:value-of select="/a:project/a:providerName"/>
                    <xsl:text disable-output-escaping="yes"><![CDATA["]]]></xsl:text>
                  </xsl:attribute>
                </primitiveExpression>
              </init>
            </memberField>
            <!-- const AppConnectionString -->
            <memberField type="System.String" name="AppConnectionString">
              <attributes public="true"/>
              <init>
                <primitiveExpression>
                  <xsl:attribute name="value">
                    <xsl:text disable-output-escaping="yes"><![CDATA[<add name="]]></xsl:text>
                    <xsl:value-of select="$Namespace"/>
                    <xsl:text><![CDATA[" connectionString="]]></xsl:text>
                    <xsl:value-of select="/a:project/a:connectionString"/>
                    <xsl:text><![CDATA[" providerName="]]></xsl:text>
                    <xsl:value-of select="/a:project/a:providerName"/>
                    <xsl:text disable-output-escaping="yes"><![CDATA[" />]]></xsl:text>
                  </xsl:attribute>
                </primitiveExpression>
              </init>
            </memberField>
            <!-- property ModificationOwnerName -->
            <memberProperty type="System.String" name="ModificationOwnerName">
              <attributes public="true"/>
              <getStatements>
                <methodReturnStatement>
                  <primitiveExpression value="{$Namespace} Web App"/>
                </methodReturnStatement>
              </getStatements>
            </memberProperty>
            <!-- method FeatureActivated(SPFeatureReceiverProperties) -->
            <memberMethod name="FeatureActivated">
              <attributes public="true" override="true"/>
              <parameters>
                <parameter type="SPFeatureReceiverProperties" name="properties"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="SPWebService" name="service">
                  <init>
                    <propertyReferenceExpression name="ContentService">
                      <typeReferenceExpression type="SPWebService"/>
                    </propertyReferenceExpression>
                  </init>
                </variableDeclarationStatement>
                <comment>make sure that "connectionStrings" node exists in configuration</comment>
                <variableDeclarationStatement type="SPWebConfigModification" name="modification">
                  <init>
                    <objectCreateExpression type="SPWebConfigModification"/>
                  </init>
                </variableDeclarationStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Path">
                    <variableReferenceExpression name="modification"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="configuration"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Name">
                    <variableReferenceExpression name="modification"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="connectionStrings"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Sequence">
                    <variableReferenceExpression name="modification"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="0"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Owner">
                    <variableReferenceExpression name="modification"/>
                  </propertyReferenceExpression>
                  <propertyReferenceExpression name="ModificationOwnerName"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Type">
                    <variableReferenceExpression name="modification"/>
                  </propertyReferenceExpression>
                  <propertyReferenceExpression name="EnsureChildNode">
                    <typeReferenceExpression type="SPWebConfigModification.SPWebConfigModificationType"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Value">
                    <variableReferenceExpression name="modification"/>
                  </propertyReferenceExpression>
                  <primitiveExpression>
                    <xsl:attribute name="value">
                      <xsl:text disable-output-escaping="yes"><![CDATA[<connectionStrings/>]]></xsl:text>
                    </xsl:attribute>
                  </primitiveExpression>
                </assignStatement>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="Not">
                      <methodInvokeExpression methodName="Contains">
                        <target>
                          <propertyReferenceExpression name="WebConfigModifications">
                            <variableReferenceExpression name="service"/>
                          </propertyReferenceExpression>
                        </target>
                        <parameters>
                          <variableReferenceExpression name="modification"/>
                        </parameters>
                      </methodInvokeExpression>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <propertyReferenceExpression name="WebConfigModifications">
                          <variableReferenceExpression name="service"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="modification"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="Update">
                      <target>
                        <variableReferenceExpression name="service"/>
                      </target>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="ApplyWebConfigModifications">
                      <target>
                        <variableReferenceExpression name="service"/>
                      </target>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
                <comment>add application connection string to web.config</comment>
                <assignStatement>
                  <variableReferenceExpression name="modification"/>
                  <objectCreateExpression type="SPWebConfigModification"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Path">
                    <variableReferenceExpression name="modification"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="configuration/connectionStrings"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Name">
                    <variableReferenceExpression name="modification"/>
                  </propertyReferenceExpression>
                  <propertyReferenceExpression name="AppConnectionStringModificationName"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Sequence">
                    <variableReferenceExpression name="modification"/>
                  </propertyReferenceExpression>
                  <primitiveExpression value="0"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Owner">
                    <variableReferenceExpression name="modification"/>
                  </propertyReferenceExpression>
                  <propertyReferenceExpression name="ModificationOwnerName"/>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Type">
                    <variableReferenceExpression name="modification"/>
                  </propertyReferenceExpression>
                  <propertyReferenceExpression name="EnsureChildNode">
                    <typeReferenceExpression type="SPWebConfigModification.SPWebConfigModificationType"/>
                  </propertyReferenceExpression>
                </assignStatement>
                <assignStatement>
                  <propertyReferenceExpression name="Value">
                    <variableReferenceExpression name="modification"/>
                  </propertyReferenceExpression>
                  <propertyReferenceExpression name="AppConnectionString"/>
                </assignStatement>
                <conditionStatement>
                  <condition>
                    <unaryOperatorExpression operator="Not">
                      <methodInvokeExpression methodName="Contains">
                        <target>
                          <propertyReferenceExpression name="WebConfigModifications">
                            <variableReferenceExpression name="service"/>
                          </propertyReferenceExpression>
                        </target>
                        <parameters>
                          <variableReferenceExpression name="modification"/>
                        </parameters>
                      </methodInvokeExpression>
                    </unaryOperatorExpression>
                  </condition>
                  <trueStatements>
                    <methodInvokeExpression methodName="Add">
                      <target>
                        <propertyReferenceExpression name="WebConfigModifications">
                          <variableReferenceExpression name="service"/>
                        </propertyReferenceExpression>
                      </target>
                      <parameters>
                        <variableReferenceExpression name="modification"/>
                      </parameters>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="Update">
                      <target>
                        <variableReferenceExpression name="service"/>
                      </target>
                    </methodInvokeExpression>
                    <methodInvokeExpression methodName="ApplyWebConfigModifications">
                      <target>
                        <variableReferenceExpression name="service"/>
                      </target>
                    </methodInvokeExpression>
                  </trueStatements>
                </conditionStatement>
              </statements>
            </memberMethod>
            <!-- method FeatureDeactivating(SPFeatureReceiverProperties) -->
            <memberMethod name="FeatureDeactivating">
              <attributes public="true" override="true"/>
              <parameters>
                <parameter type="SPFeatureReceiverProperties" name="properties"/>
              </parameters>
              <statements>
                <variableDeclarationStatement type="SPWebService" name="service">
                  <init>
                    <propertyReferenceExpression name="ContentService">
                      <typeReferenceExpression type="SPWebService"/>
                    </propertyReferenceExpression>
                  </init>
                </variableDeclarationStatement>
                <foreachStatement>
                  <variable type="SPWebConfigModification" name="modification"/>
                  <target>
                    <propertyReferenceExpression name="WebConfigModifications">
                      <variableReferenceExpression name="service"/>
                    </propertyReferenceExpression>
                  </target>
                  <statements>
                    <conditionStatement>
                      <condition>
                        <binaryOperatorExpression operator="BooleanAnd">
                          <binaryOperatorExpression operator="ValueEquality">
                            <propertyReferenceExpression name="Name">
                              <variableReferenceExpression name="modification"/>
                            </propertyReferenceExpression>
                            <propertyReferenceExpression name="AppConnectionStringModificationName"/>
                          </binaryOperatorExpression>
                          <binaryOperatorExpression operator="ValueEquality">
                            <propertyReferenceExpression name="Owner">
                              <variableReferenceExpression name="modification"/>
                            </propertyReferenceExpression>
                            <propertyReferenceExpression name="ModificationOwnerName"/>
                          </binaryOperatorExpression>
                        </binaryOperatorExpression>
                      </condition>
                      <trueStatements>
                        <tryStatement>
                          <statements>
                            <methodInvokeExpression methodName="Remove">
                              <target>
                                <propertyReferenceExpression name="WebConfigModifications">
                                  <variableReferenceExpression name="service"/>
                                </propertyReferenceExpression>
                              </target>
                              <parameters>
                                <variableReferenceExpression name="modification"/>
                              </parameters>
                            </methodInvokeExpression>
                            <methodInvokeExpression methodName="Update">
                              <target>
                                <variableReferenceExpression name="service"/>
                              </target>
                            </methodInvokeExpression>
                            <methodInvokeExpression methodName="ApplyWebConfigModifications">
                              <target>
                                <variableReferenceExpression name="service"/>
                              </target>
                            </methodInvokeExpression>
                          </statements>
                          <catch exceptionType="Exception"/>
                        </tryStatement>
                        <breakStatement/>
                      </trueStatements>
                    </conditionStatement>
                  </statements>
                </foreachStatement>
                <!-- remove the web part from the gallary-->
                <usingStatement>
                  <variable type="SPSite" name="site">
                    <init>
                      <castExpression targetType="SPSite">
                        <propertyReferenceExpression name="Parent">
                          <propertyReferenceExpression name="Feature">
                            <variableReferenceExpression name="properties"/>
                          </propertyReferenceExpression>
                        </propertyReferenceExpression>
                      </castExpression>
                    </init>
                  </variable>
                  <statements>
                    <usingStatement>
                      <variable type="SPWeb" name="web">
                        <init>
                          <propertyReferenceExpression name="RootWeb">
                            <variableReferenceExpression name="site"/>
                          </propertyReferenceExpression>
                        </init>
                      </variable>
                      <statements>
                        <variableDeclarationStatement type="SPList" name="list">
                          <init>
                            <arrayIndexerExpression>
                              <target>
                                <propertyReferenceExpression name="Lists">
                                  <variableReferenceExpression name="web"/>
                                </propertyReferenceExpression>
                              </target>
                              <indices>
                                <primitiveExpression value="Web Part Gallery"/>
                              </indices>
                            </arrayIndexerExpression>
                          </init>
                        </variableDeclarationStatement>
                        <foreachStatement>
                          <variable type="SPListItem" name="part"/>
                          <target>
                            <propertyReferenceExpression name="Items">
                              <variableReferenceExpression name="list"/>
                            </propertyReferenceExpression>
                          </target>
                          <statements>
                            <conditionStatement>
                              <condition>
                                <methodInvokeExpression methodName="Equals">
                                  <target>
                                    <propertyReferenceExpression name="Name">
                                      <variableReferenceExpression name="part"/>
                                    </propertyReferenceExpression>
                                  </target>
                                  <parameters>
                                    <primitiveExpression value="{$Namespace}_AppWebPart.webpart"/>
                                    <propertyReferenceExpression name="CurrentCultureIgnoreCase">
                                      <typeReferenceExpression type="StringComparison"/>
                                    </propertyReferenceExpression>
                                  </parameters>
                                </methodInvokeExpression>
                              </condition>
                              <trueStatements>
                                <methodInvokeExpression methodName="Delete">
                                  <target>
                                    <variableReferenceExpression name="part"/>
                                  </target>
                                </methodInvokeExpression>
                                <breakStatement/>
                              </trueStatements>
                            </conditionStatement>
                          </statements>
                        </foreachStatement>
                      </statements>
                    </usingStatement>
                  </statements>
                </usingStatement>
              </statements>
            </memberMethod>
          </members>
        </typeDeclaration>
      </types>
    </compileUnit>
  </xsl:template>
</xsl:stylesheet>
