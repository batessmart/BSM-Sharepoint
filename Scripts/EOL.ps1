$UserCred = "administrator@batessmart.onmicrosoft.com"
$PWordCred = ConvertTo-SecureString -String "12Eagle;" -AsPlainText -Force
$Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $UserCred, $PWordCred


#Config Variables
$SiteURL = "https://batessmart.sharepoint.com/sites/INSITE"
$ListName ="Staff on Leave"
 
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
}get






#Read more: http://www.sharepointdiary.com/2015/10/delete-all-list-items-in-sharepoint-online-using-powershell.html#ixzz5lugtoYek

Connect-PnPOnline -Url $SiteURL -Credentials $Cred

$path = "C:\flow\upload\EOL.csv"
$csvs = Import-Csv $path
foreach($values in $csvs )
 {
Add-PnPListItem -List "Staff on Leave" -ContentType $values.ContentType -Values @{"Staff" = $values.Name; "Office" =$values.office; "Return" = $values.Return;  }

}