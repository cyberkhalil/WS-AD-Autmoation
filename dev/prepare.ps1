try {
  Import-Module .\PowerShell-Beautifier-1.2.5\PowerShell-Beautifier.psd1
  Write-Output "Use Edit-DTWBeautifyScript for formating the script's you want.."
}
catch {
  Write-Output "error in preparing for development"
}
