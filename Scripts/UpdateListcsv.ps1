.SYNOPSIS
This is a simple Powershell script to upload csv files to a SharePoint Online list - line by line.
.DESCRIPTION
To connect to SharePoint Online the script requires a username/password the url to the SharePoint site and the list title.
To extract the csv files you musst provide the folder location and if the csv contains a header.
Lastly the script needs a mapping to map the content of the csv file to the SharePoint list.
.EXAMPLE
The csv header is used to map the entries to the SharePoint list.
The mapping is provided in PowerShell string array notation, no quotes, separated by comma - in this case the SharePoint list has the fields Counter, Title, Datum, Uhrzeit1, Uhrzeit2, Uhrzeit3, Uhrzeit4 and Anzahl - they appear in that order in the csv.
In this order the columns are read from the csv and the csv should not have more or less columns than mapped to the SharePoint list:
.\csv2list.ps1 -folder C:\Users\Max\Desktop\csv -username maximilian.melcher@melcher.it -password xxx -url https://melcherit.sharepoint.com -list csv -mapping Counter,Title,Datum,Uhrzeit1,Uhrzeit2,Uhrzeit3,Uhrzeit4,Anzahl
.EXAMPLE
CSV has a header and must be skipped:
.\csv2list.ps1 -folder C:\Users\Max\Desktop\csv -username maximilian.melcher@melcher.it -password xxx -url https://melcherit.sharepoint.com -list csv -mapping Counter,Title,Datum,Uhrzeit1,Uhrzeit2,Uhrzeit3,Uhrzeit4,Anzahl -skipFirstRow
.EXAMPLE
CSV should be deleted afterwards
.\csv2list.ps1 -folder C:\Users\Max\Desktop\csv -username maximilian.melcher@melcher.it -password xxx -url https://melcherit.sharepoint.com -list csv -mapping Counter,Title,Datum,Uhrzeit1,Uhrzeit2,Uhrzeit3,Uhrzeit4,Anzahl -delete
.NOTES
Currently I only tried to upload plain text - if you want more sophisticated field types, that should be easily doable.
.LINK
https://melcher.it
#&gt;


Param(
[Parameter(Mandatory=$True,HelpMessage="Username to connect to SharePoint Online")]
[string]$username,
[Parameter(Mandatory=$True,HelpMessage="Password to connect to SharePoint Online")]
[string]$password,
[Parameter(Mandatory=$True,HelpMessage="The folder where the csv files are stored")]
[string]$folder,
[Parameter(Mandatory=$True,HelpMessage="The mapping of the csv to the SharePoint list - in PowerShell string array notation, e.g ColumnA, ColumnB")]
[String[]]$mapping,
[Parameter(Mandatory=$True,HelpMessage="The Url of the SharePoint site")]
[string]$url,
[Parameter(Mandatory=$True,HelpMessage="The List title")]
[string]$listtitle,
[Parameter(HelpMessage="Flag if the csv files should be uploaded after processing")]
[switch]$delete,
[Parameter(HelpMessage="Flag if the csv files have a header that should be skipped")]
[switch]$skipFirstRow
)

#CSOM installation required!

Add-Type -Path "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\microsoft shared\Web Server Extensions\15\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"

#check if the folder exists

if (![System.IO.Directory]::Exists($folder))
{
  write-host -ForegroundColor Red "Folder $folder does not exist"
  return
}

#check if there are files

if ((Get-ChildItem $folder | Measure-Object).Count -eq 0)
{
  write-host -ForegroundColor Red "No csv files in folder"
  return
}

#get the files

$files = Get-ChildItem -File $folder

#connect to sharepoint online

$secure = ConvertTo-SecureString $password -AsPlainText -Force

$context = New-Object Microsoft.SharePoint.Client.ClientContext($url)
$credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($username, $secure)
$context.Credentials = $credentials
$context.ExecuteQuery()

Write-Host -ForegroundColor green "Connected to SPO"

#get the list

$list = $context.Web.Lists.GetByTitle($listtitle)
$context.Load($list)
$context.Load($list.Fields)
$context.ExecuteQuery()

Write-Host -ForegroundColor green "List loaded"

#get the list fields

$fields = $list.Fields | ? {!$_.Hidden} | select -ExpandProperty StaticName
Write-Host -ForegroundColor Yellow "Fields: "
$fields | foreach{ Write-Host "`t $_"}

foreach ($h in $mapping)
{
  if ($fields -notcontains $h)
  {
    Write-Host -ForegroundColor Red "Mapping incorrect - Field $h is not available in the SharePoint list"
    return
  }
}

#now iterate over the files

foreach ($file in $files)
{
  write-host -ForegroundColor Yellow "Reading file $file" -NoNewline

  #get the csv

  $lines = Import-Csv -LiteralPath $file.FullName -Header $mapping -Delimiter ";"
  write-host -ForegroundColor Yellow " ($(($lines | Measure-Object).count) lines):"

  $i = 0
  #iterate over

  foreach ($line in $lines)
  {
    #skipping the header row if there is one

    if ($i -eq 0 -and $skipFirstRow)
    {
      write-host -ForegroundColor Yellow "skipping first row"
      $i++
      continue
    }

    #preparing the item

    $create = New-Object Microsoft.SharePoint.Client.ListItemCreationInformation
    $item = $List.AddItem($create)

    foreach ($col in ($line | Get-Member | ? {$_.MemberType -eq "NoteProperty"} | select Name))
    {
      #using the header to specify the column name

      $item[$col.Name] = $line | Select -ExpandProperty $col.Name
    }
    $item.Update()
    $context.ExecuteQuery()
    $i++

    if ($i%100 -eq 0)
    {
      write-host -ForegroundColor yellow "`t$i"
    }
  }
  write-host -ForegroundColor Green "file $file done"

  #deleting the item if specified

  if ($delete)
  {
    Remove-Item $file.FullName
  }
}
