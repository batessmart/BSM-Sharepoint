$UserCred = "administrator@batessmart.onmicrosoft.com"
$PWordCred = ConvertTo-SecureString -String "12Eagle;" -AsPlainText -Force
$Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $UserCred, $PWordCred


#Config Variables
$SiteURL = "https://batessmart.sharepoint.com/sites/INSITE"
$ListName ="Staff Directory"
 
#Get Credentials to connect

 
Try {
    #Connect to PNP Online
    Connect-PnPOnline -Url $SiteURL -Credentials $Cred
     
    #Get All List Items in Batch
    $ListItems = Get-PnPListItem -List $ListName
 
    #Loop through List Items and Delete
    ForEach ($Item in $ListItems)
    {
        Remove-PnPListItem -List $ListName -Identity $Item.Id -Force
    }
}
catch {
    write-host "Error: $($_.Exception.Message)" -foregroundcolor Red
}


#Read more: http://www.sharepointdiary.com/2015/10/delete-all-list-items-in-sharepoint-online-using-powershell.html#ixzz5lugtoYek

Connect-PnPOnline -Url $SiteURL -Credentials $Cred


$OU = "OU=7Staff,OU=Melbourne - 1 Nicholson St,DC=batessmart,DC=com",`
"OU=10Staff,OU=Melbourne - 1 Nicholson St,DC=batessmart,DC=com",`
"OU=7Staff,OU=Sydney - 243 Liverpool St,DC=batessmart,DC=com",`
"OU=10Staff,OU=Sydney - 243 Liverpool St,DC=batessmart,DC=com"

$exclu =  @("Sydney Liverpool","Newforma Upload","Reception Temp","Batessmart Librarian","Sydney Generic","BSM Automation","Bates Smart Reception")

$users = $OU | foreach {Get-ADUser -Filter * -Properties Office,OfficePhone -SearchBase $_} | where {$_.office -ne $null} | where {$_.name -notin $exclu }|
 select Name,samaccountname,@{name='Email';expression={$_.userprincipalname}},OfficePhone,Office 

 foreach($values in $Users )
 {

$id = Add-PnPListItem -List "Staff Directory" -ContentType $values.ContentType`
 -Values @{
 "Staff" = $values.Name; 
 "Office" =$values.office; 
 "Code" = $values.samaccountname;

 
 }
 Set-PnPListItem -List "Staff Directory" `
-Identity $id.Id `
-Values @{
 "Phone" = $value.OfficePhone;
 "Position" = $values.description;

 }
}