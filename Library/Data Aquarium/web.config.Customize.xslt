<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl" xmlns:csharp="urn:schemas-codeontime-com:csharp"
>
	<xsl:output method="xml" indent="yes"/>
	<xsl:param name="Path" select="'C:\Users\Serge Bodrov\Documents\Code OnTime\Projects\Web Site Factory\Northwind\Web.config'"/>

	<xsl:param name="UserData" select="''"/>
	<!--<xsl:param name="UserData">
    <![CDATA[
AppendChild: /configuration/appSettings

 <add key="Parameter1" value="Value1"/>

    
AppendChild: /configuration/appSettings
<add key="Parameter2" value="Value2"/>
        
        
]]></xsl:param>-->

	<msxsl:script language="C#" implements-prefix="csharp">
		<![CDATA[
    public XPathNavigator BuildWebConfig(string path, string userData) {
        // create a navigator
        XmlDocument doc =new XmlDocument();
        doc.Load(path);
        XPathNavigator nav = doc.CreateNavigator();
        // iterator through spot changes
        Match m = Regex.Match(userData.Trim() + "\n\n", @"((\s*(?'Operation'\w+):\s*(?'XPath'.+?)\s*\n)(\s*(?'Xml'[\s\S]+?)(\n\s*\n)+))", RegexOptions.Compiled);
        while (m.Success) {
            string operation = m.Groups["Operation"].Value;
            string xpath = m.Groups["XPath"].Value;
            string xml = m.Groups["Xml"].Value;
            try {
                XPathNavigator target = nav.SelectSingleNode(xpath);
                if (target != null) {
											switch (operation.ToLower()) {
												case "insertafter":
													target.InsertAfter(xml);
														break;
												case "insertbefore":
													target.InsertBefore(xml);
														break;
												case "appendchild":
													  target.AppendChild(xml);
														break;
												case "delete":
													  target.DeleteSelf();
														break;
											}
	                
/*										XPathDocument snippet = new XPathDocument(new System.IO.StringReader("<snippet>" + xml + "</snippet>"));
										XPathNodeIterator elemIterator = snippet.CreateNavigator().Select("/snippet/*");
										System.Collections.Generic.List<string> list = new System.Collections.Generic.List<string>();
										while (elemIterator.MoveNext()) 
											list.Add(elemIterator.Current.OuterXml);
											switch (operation.ToLower()) {
													case "insertafter":
															for (int i = list.Count - 1; i >= 0; i--)
																target.InsertAfter(list[i]);
															break;
													case "insertbefore":
															for (int i = 0; i < list.Count; i++)
																target.InsertBefore(list[i]);
															break;
													case "appendchild":
															for (int i = list.Count - 1; i >= 0; i--)
																target.AppendChild(list[i]);
															break;
											}*/
                }
            }
            catch (Exception) {
            }
            m = m.NextMatch();
        }
        
        
        return nav;
    }
    ]]>
	</msxsl:script>

	<xsl:template match="/">
		<xsl:copy-of select="csharp:BuildWebConfig($Path, $UserData)"/>
	</xsl:template>
</xsl:stylesheet>
