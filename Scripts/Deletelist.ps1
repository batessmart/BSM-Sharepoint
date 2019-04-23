elete All List Items in Bulk in SharePoint Online using PowerShell:
Here is the script to delete all list items in SharePoint online Office 365 using client side object model (CSOM) with PowerShell. 
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
   
#Variables for Processing
$SiteUrl = "https://crescent.sharepoint.com/"
$ListName="Projects"
 
$UserName="admin@crescent.com
$Password ="Password goes here"
  
#Setup Credentials to connect
$Credentials = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($UserName,(ConvertTo-SecureString $Password -AsPlainText -Force))
  
#Set up the context
$Context = New-Object Microsoft.SharePoint.Client.ClientContext($SiteUrl) 
$Context.Credentials = $credentials
   
#Get the List
$List = $Context.web.Lists.GetByTitle($ListName)
$ListItems = $List.GetItems([Microsoft.SharePoint.Client.CamlQuery]::CreateAllItemsQuery()) 
$Context.Load($ListItems)
$Context.ExecuteQuery()       
 
write-host "Total Number of List Items found:"$ListItems.Count
 
    #sharepoint online powershell delete all list items
    if ($ListItems.Count -gt 0)
    {
        #Loop through each item and delete
        For ($i = $ListItems.Count-1; $i -ge 0; $i--)
        {
            $ListItems[$i].DeleteObject()
        } 
        $Context.ExecuteQuery()
         
        Write-Host "All List Items deleted Successfully!"
    }
This PowerShell script deletes all items from SharePoint Online list. Please note, these items are not moved to the Recycle Bin but deleted permanently! This PowerShell script could be quite helpful when dealing with deleting bulk items from a huge list.

PowerShell to Delete All Items from Large Lists in SharePoint Online
When you have a SharePoint Online list or library with larger number of items (>5000), You may face "The attempted operation is prohibited because it exceeds the list view threshold enforced by the administrator." error. So, to mitigate this issue, lets delete list items in batch. Here is my PowerShell script to delete list items in batch.
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
24
25
26
27
28
29
30
31
32
33
34
35
36
37
38
39
40
41
42
43
44
45
46
47
48
49
50
51
52
#Load SharePoint CSOM Assemblies
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.dll"
Add-Type -Path "C:\Program Files\Common Files\Microsoft Shared\Web Server Extensions\16\ISAPI\Microsoft.SharePoint.Client.Runtime.dll"
    
#Config Parameters
$SiteURL= "https://crescent.sharepoint.com/"
$ListName="Projects"
$BatchSize = 500
  
#Setup Credentials to connect
$Cred = Get-Credential
$Cred = New-Object Microsoft.SharePoint.Client.SharePointOnlineCredentials($Cred.UserName,$Cred.Password)
  
Try {
    #Setup the context
    $Ctx = New-Object Microsoft.SharePoint.Client.ClientContext($SiteURL)
    $Ctx.Credentials = $Cred
  
    #Get the web and List
    $Web=$Ctx.Web
    $List=$web.Lists.GetByTitle($ListName)
    $Ctx.Load($List)
    $Ctx.ExecuteQuery()
    Write-host "Total Number of Items Found in the List:"$List.ItemCount
 
    Do {  
        #Get all items from the list
        $Query = New-Object Microsoft.SharePoint.Client.CamlQuery
        $Query.ViewXml = "<View><RowLimit>$BatchSize</RowLimit></View>"
        $ListItems = $List.GetItems($Query)
        $Ctx.Load($ListItems)
        $Ctx.ExecuteQuery()
         
        #Exit from Loop if No items found
        If($ListItems.count -eq 0) { Break; }
 
        Write-host Deleting $($ListItems.count) Items from the List...
 
        #Loop through each item and delete
        ForEach($Item in $ListItems)
        {
            $List.GetItemById($Item.Id).DeleteObject()
        } 
        $Ctx.ExecuteQuery()
 
    } While ($True)
 
    Write-host -f Green "All Items Deleted!"
}
Catch {
    write-host -f Red "Error Deleting List Items!" $_.Exception.Message
}
This script deletes all list items in SharePoint Online using PowerShell.

SharePoint Online PnP PowerShell to Delete All List Items 
1
2
3
4
5
6
7
8
9
10
11
12
13
14
15
16
17
18
19
20
21
22
23
#Config Variables
$SiteURL = "https://crescenttech.sharepoint.com/sites/marketing"
$ListName ="Records"
 
#Get Credentials to connect
$Cred = Get-Credential
 
Try {
    #Connect to PNP Online
    Connect-PnPOnline -Url $SiteURL -Credentials $Cred
     
    #Get All List Items in Batch
    $ListItems = Get-PnPListItem -List $ListName -PageSize 1000
 
    #Loop through List Items and Delete
    ForEach ($Item in $ListItems)
    {
        Remove-PnPListItem -List $ListName -Identity $Item.Id -Force
    }
}
catch {
    write-host "Error: $($_.Exception.Message)" -foregroundcolor Red
}


#Read more: http://www.sharepointdiary.com/2015/10/delete-all-list-items-in-sharepoint-online-using-powershell.html#ixzz5luiz10Ce
