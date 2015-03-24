<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:codedom="http://www.codeontime.com/2008/codedom-compiler"
    xmlns:app="urn:schemas-codeontime-com:data-aquarium-application"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"  xmlns:c="urn:schemas-codeontime-com:data-aquarium"
    xmlns:asp="urn:asp.net" xmlns:aquarium="urn:data-aquarium"
    xmlns:cot="urn:codeontime:template-script"
    xmlns:factory="urn:codeontime:app-factory" exclude-result-prefixes="app factory msxml" xmlns:msxml="urn:schemas-microsoft-com:xslt">
  <xsl:output method="html" indent="yes" encoding="utf-8"/>
  <xsl:param name="Namespace"/>

  <msxml:script language="C#" implements-prefix ="cot">
    <![CDATA[
  public string RemoveTokens(string s)  
  {
    return Regex.Replace(s, @"\^\w+\^([\s\S]*?)\^\w+\^", "$1").Replace("|", "/");
  }
  ]]>
  </msxml:script>

  <xsl:template match="/">
    <table>
      <tr>
        <td valign="top" style="padding-right:8px;">
          <asp:ListBox ID="PageList" runat="server" Rows="15" AutoPostBack="true" OnSelectedIndexChanged="PageList_SelectedIndexChanged">
            <xsl:for-each select="/app:application/app:pages/app:page">
              <asp:ListItem Text="{cot:RemoveTokens(@path)}" Value="Name={@name};Title={@title};Path={@path};Description:{@description};Style={@style};About={app:about};" />
            </xsl:for-each>
          </asp:ListBox>
        </td>
        <td valign="top" style="width: 400px; border: solid 1px silver; padding: 8px;background-color:white;">
          <asp:Label ID="PageAbout" runat="server" />
        </td>
      </tr>
    </table>
  </xsl:template>

</xsl:stylesheet>
