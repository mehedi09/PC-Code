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
    <xsl:text>Add-PSSnapin Microsoft.SharePoint.PowerShell

$SolutionPackageName = "</xsl:text>
    <xsl:value-of select="$Namespace"/>
    <xsl:text>.wsp"
$FeatureName = "WebParts_</xsl:text>
    <xsl:value-of select="$Namespace"/>
    <xsl:text>"

$WebApp = Get-SPWebApplication -Identity $Args[0]

$Solution = Get-SPSolution | where-object {$_.Name -eq $SolutionPackageName}
if ($Solution -ne $null) {
    if ($Solution.Deployed -eq $true) {
        echo "Updating Solution..."
        $Solution = Update-SPSolution  -Identity $SolutionPackageName -LiteralPath (".\Solution Files\" + $SolutionPackageName) -Local -GACDeployment 
        echo ("Solution '" + $SolutionPackageName + "' has been updated.")
    }
    else {
        echo ("Detected existing Solution '"   + $SolutionPackageName + "'." )
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
}
else {
    echo "Adding Solution..."
    $Solution = Add-SPSolution -LiteralPath (".\Solution Files\" + $SolutionPackageName) 
    echo "Done."

    $Solution = Get-SPSolution -Identity $SolutionPackageName

    echo "Installing Solution..."
    Install-SPSolution $Solution -WebApplication $WebApp -Force -Local -GACDeployment 
    do {
        Start-Sleep -s 1
        $Solution = Get-SPSolution -Identity $SolutionPackageName
    } while ($Solution.Deployed -eq $false)
    echo "Done."

    echo "Installing Feature..."
    Install-SPFeature $FeatureName -force
    echo "Done."

    echo "Enabling Feature..."
    Enable-SPFeature -Identity $FeatureName -Url $Args[0] 
    echo ("Solution '" + $SolutionPackageName + "' has been deployed.")
}</xsl:text>
  </xsl:template>
</xsl:stylesheet>
