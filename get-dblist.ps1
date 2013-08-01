<#
.NAME
    get-dblist.ps1
.SYNOPSIS
   Get list of files in Dropbox folder on remote machines
.DESCRIPTION
    get-dblist will enumerate and list files stored in Dropbox folders on remote machines.
.SYNTAX
    get-dblist.ps1 [-h | -host <computer name>]
.PARAMETER h
    Hostname of the target machine. Default: localhost
#>

param(
    [Parameter(Position=0)][alias("h","host")][string]$computerName = "localhost"
);

<#
Function Get-DropBox() {
<#
Returns the path to the local drop box
#>
<#  $hostFile = Join-Path (Split-Path (Get-ItemProperty HKCU:\Software\Dropbox).InstallPath) "host.db"
  $encodedPath = [System.Convert]::FromBase64String((Get-Content $hostFile)[1])
  [System.Text.Encoding]::UTF8.GetString($encodedPath)
}
#>


$hku = 2147483651  #this is the code for HKEY_USERS
$key = "S-1-5-21-1220945662-1085031214-839522115-###\Software\Dropbox"
$value = "InstallPath"

#$wmi = gwmi -list "StdRegProv" -namespace root\default -computername $computerName
$wmi = [wmiclass]"\\$computerName\root\default:stdRegProv"
$path = Split-Path -path (($wmi.GetStringValue($hku,$key,$value)).svalue) -parent
$path
$filter = "Name='$path'"
Get-WmiObject -ComputerName $computerName -Filter $filter -Class Win32_Directory #you fail at life
