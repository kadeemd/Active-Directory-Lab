Import-Module ActiveDirectory

#Define file containing employees to be offboarded
$CSVPath = "C:\OffboardEmployees.csv"
$Users = Import-Csv -Path $CSVPath

#Define target OU.
$TargetOU = "OU=Disabled Users,DC=kadtech,DC=local"

# Display users that are within the CSV file.
Write-Host "[*] Users detected in CSV file: $($Users.Username -join ', ')" -ForegroundColor Cyan

#Loop through users within CSV file
foreach ($Row in $Users) {
	$Username = $Row.Username

	#Get user identity from active directory and produce error if user not found.
	$ADUser = Get-ADUser -Identity $Username -ErrorAction SilentlyContinue
        
        #Error check if user does not exist within Active Directory.
	if (-not $ADUser) {
        Write-Host "[-] ERROR: User $Username not found in Active Directory." -ForegroundColor Red
		continue 
 	}

	#Disable the users account
	Disable-ADAccount -Identity $ADUser
	Write-Host "[+] SUCCESS: Disabled user account for $Username" -ForegroundColor Green

	#Move disabled accounts into Disabled Users OU.
        try{
	  Move-ADObject -Identity $ADUser.DistinguishedName -TargetPath $TargetOU
          Write-Host "Successfully moved: $($Username)" -ForegroundColor Green
	 }
        
        #Error check if users failed to be moved into new OU.
        catch {
        Write-Host "[-] ERROR: Failed to move $Username. Error: $_" -ForegroundColor Red
        }
}
