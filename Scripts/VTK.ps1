$text = Get-Content C:\temp\hml.txt

#######TEST IF SAFE##########
$hash = [System.Collections.ArrayList]@()

#$regex = ‘([a-zA-Z]{3,})://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)*?’
$list = Get-Content \\batessmart\it\softlib\bot\vtotal.txt

#GET URLS from TEST
foreach ($line in $text){

$link = ( (Select-String '([a-zA-Z]{3,})://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)*?' -Input $line).Matches.Value)
if($link -like '*http*'){
$hash.Add("$Link")

}


}
$fullink = $hash | select -Unique

#Check if Link is Safe




$vt = @()

foreach($links in $fullink)
{

$VTrest = Get-VTURLReport -Scan $links

$list | foreach {

 $site = $_

$result = $VTrest.scans.$site.result
$url = $VTrest.url

$item = [PSCustomObject] @{
    'Scan Site' = $site
    Result = $result  
    Url = $url
    
}
$vt +=$item

}


}
$exclude = "unrated site","clean site"



$exclude = "unrated site","clean site"

$endresult = $vt | where {$_.Result -notin $exclude}








