<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:a="urn:schemas-codeontime-com:data-aquarium-project"
    xmlns:msxsl="urn:schemas-microsoft-com:xslt"
    xmlns:ontime="urn:schemas-codeontime-com:xslt"
 	  exclude-result-prefixes="msxsl a ontime"
>
  <xsl:output method="text" indent="yes"/>
  <xsl:param name="Namespace"/>

  <xsl:template match="/">
    <xsl:text>#Load SharePoint Snapin
Add-PSSnapin Microsoft.SharePoint.PowerShell

$SolutionPackageName = "</xsl:text>
    <xsl:value-of select="$Namespace"/>
    <xsl:text>.wsp"
$FeatureName = "WebParts_</xsl:text>
    <xsl:value-of select="$Namespace"/>
    <xsl:text>"

$WebApp = Get-SPWebApplication -Identity $Args[0]

$Solution = Get-SPSolution | where-object {$_.Name -eq $SolutionPackageName}
if ($Solution -ne $null) {
    echo "Disabling Feature..."
    Disable-SPFeature -Identity $FeatureName -Url $Args[0] -Confirm:$false
    echo "Done."

    echo "Uninstalling Feature..."
    UnInstall-SPFeature -Identity $FeatureName -force -Confirm:$false
    echo "Done."

    echo "Uninstalling Solution..."
    UnInstall-SPSolution -Identity $SolutionPackageName -Local -WebApplication $WebApp -Confirm:$false
    do {
        Start-Sleep -s 1
        $Solution = Get-SPSolution -Identity $SolutionPackageName
    } while ($Solution.Deployed -eq $true)
    echo "Done."

    echo "Removing solution..."
    Remove-SPSolution -Identity $SolutionPackageName  -force -Confirm:$false
    echo ("Solution '" + $SolutionPackageName + "' has been retracted.")
}
else {
    echo ("Solution '" + $SolutionPackageName + "' has not been detected.")
}</xsl:text>
  </xsl:template>
</xsl:stylesheet>
