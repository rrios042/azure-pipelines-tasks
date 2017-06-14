[CmdletBinding()]
param()

# Arrange.
. $PSScriptRoot\..\..\..\..\Tests\lib\Initialize-Test.ps1
$module = Microsoft.PowerShell.Core\Import-Module $PSScriptRoot\.. -PassThru
$global:retriesAttempted = 0
$action = {
    $global:retriesAttempted++
    throw [System.IO.FileNotFoundException] "File not found error!"
}

Register-Mock Set-UserAgent
Unregister-Mock Start-Sleep
Register-Mock Start-Sleep {}

# Act/Assert.
$actionResult = & $module Invoke-ActionWithRetries -Action $action -ContinueOnError
Assert-IsNullOrEmpty $actionResult "Result should be null"
