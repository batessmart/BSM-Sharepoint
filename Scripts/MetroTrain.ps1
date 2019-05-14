$req = Invoke-RestMethod -Uri "http://timetableapi.ptv.vic.gov.au/v3/disruptions?devid=3001180&signature=A024F97B1C8CF40B8EE6823255D332C467316B37"
$dest = $req.disruptions.metro_train 

$SiteURL = "https://batessmart.sharepoint.com/sites/INSITE"
$ListName ="Metro Trains"

foreach($values in $dest )
 {

$item = Add-PnPListItem -List "Metro Trains" -ContentType $values.ContentType`
 -Values @{
 "Title" = $values.title; 
 "description" =$values.description; 
 "disruption_status" = $values.disruption_status;
 }
Set-PnPListItem -List "Metro Trains" -Identity $item.Id -ContentType $values.ContentType`
-Values @{
 "disruption_type" = $value.disruption_type;
  "last_updated" = $value.last_updated;
  "from_date" = $value.from_date;
    "to_date" = $value.to_date;
      "colour" = $value.colour;
   }

}