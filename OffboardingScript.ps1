Import-Module ActiveDirectory

#Define file containing employees to be offboarded
$CSVPath = "C:\OffboardEmployees.csv"
$Users = Import-Csv -Path $CSVPath

# Display users that are within the CSV file.
Write-Host "[*] Users detected in CSV file: $($Users.Username -join ', ')" -ForegroundColor Cyan

#Loop through users within CSV file
foreach ($Row in $Users) {
	$Username = $Row.Username

	#Get user identity from active directory and produce error if user not found.
	$ADUser = Get-ADUser -Identity $Username -ErrorAction SilentlyContinue

	if (-not $ADUser) {
        Write-Host "[-] ERROR: User $Username not found in Active Directory." -ForegroundColor Red
		continue 
 	}

	#Disable the users account
	Disable-ADAccount -Identity $ADUser
	Write-Host "[+] SUCCESS: Disabled user account for $Username" -ForegroundColor Green
}
