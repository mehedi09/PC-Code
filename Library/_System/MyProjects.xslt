<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl" xmlns:p="http://www.codeontime.com/2008/code-generator"
    extension-element-prefixes="p"
>
  <xsl:output method="html" indent="yes"/>
  <xsl:param name="Library"/>

  <xsl:template match="/">
    <div>
      <div style="padding-bottom:4px;">
        <xsl:text>
        This is the list of the projects that you have created. Click on the project name to open and generate the project one more time.
        Note that most projects will automatically backup the previous version of the source code prior to generating and overwriting the existing files.</xsl:text>
      </div>
      <table class="MyProjects" cellpadding="0" cellspacing="0">
        <tr>
          <th align="right" class="PojectNumber">#</th>
          <th align="left" class="ProjectTitle">Project Name</th>
          <!--<th class="ProjectStatus">&#160;</th>-->
          <th align="left">Type</th>
          <th align="left">Last Modified</th>
          <!--<th align="left">Actions</th>-->
        </tr>
        <xsl:for-each select="p:projects/p:project[@type!='TestBench']">
          <xsl:sort data-type="text" order="ascending" select="@name"/>
          <tr>
            <td align="right">
              <xsl:value-of select="position()"/>
              <xsl:text>.</xsl:text>
            </td>
            <td class="Title ProjectTitle" >
              <a href="#" onclick="ProjectAction('{@type}', '{@name}');return false;" title="Select &quot;{@name}&quot; project." class="{@cssClass}">
                <div>
                  <xsl:attribute name="class">
                    <xsl:value-of select="@cssClass"/>
                    <xsl:if test="@current='true'">
                      <xsl:text> Current</xsl:text>
                    </xsl:if>
                  </xsl:attribute>
                  <span class="outer">
                    <span class="inner">
                      <xsl:value-of select="@name"/>
                    </span>
                  </span>
                  <!--<xsl:text> / </xsl:text>
                <xsl:value-of select="@type"/>-->
                </div>
              </a>
            </td>
            <!--<td  class="ProjectStatus">
              <xsl:choose>
                <xsl:when test="@current='true'">
                  <span class="Check" title="This is the most recent generated project">
                    &#160;
                  </span>
                </xsl:when>
                <xsl:otherwise>&#160;</xsl:otherwise>
              </xsl:choose>
            </td>-->
            <td>
              <xsl:value-of select="@type"/>
            </td>
            <td>
              <xsl:value-of select="@modifiedInfo"/>
            </td>
            <!--<td>
              <xsl:variable name="ProjectType" select="@type"/>
              <xsl:variable name="ProjectName" select="@name"/>
              <a onclick="OpenProject('{$ProjectType}','{$ProjectName}')" href="#" title="Open &quot;{$ProjectName}&quot; in Windows Explorer to view the project source code.">
                <xsl:call-template name="AddRowHoverUnhover"/>
                <xsl:text>open</xsl:text>
              </a>
              <xsl:if test="$Library">
                <xsl:for-each select="$Library/p:project[@name=$ProjectType]/p:action">
                  <xsl:text>, </xsl:text>
                  <xsl:variable name="ToolTip">
                    <xsl:choose>
                      <xsl:when test="contains(@toolTip, '{0}')">
                        <xsl:value-of select="substring-before(@toolTip, '{0}')"/>
                        <xsl:value-of select="$ProjectName"/>
                        <xsl:value-of select="substring-after(@toolTip, '{0}')"/>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:value-of select="@toolTip"/>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:variable>
                  <a onclick="ExecuteProjectAction('{$ProjectType}','{$ProjectName}', '{@name}')" href="#" title="{$ToolTip}">
                    <xsl:call-template name="AddRowHoverUnhover"/>
                    <xsl:value-of select="@name"/>
                  </a>
                </xsl:for-each>
              </xsl:if>
            </td>-->
          </tr>
        </xsl:for-each>
      </table>
    </div>
  </xsl:template>

  <xsl:template name="AddRowHoverUnhover">
    <xsl:attribute name="onmouseover">
      <xsl:text>this.parentNode.parentNode.className = 'Highlight'</xsl:text>
    </xsl:attribute>
    <xsl:attribute name="onmouseout">
      <xsl:text>this.parentNode.parentNode.className = ''</xsl:text>
    </xsl:attribute>
  </xsl:template>
</xsl:stylesheet>
