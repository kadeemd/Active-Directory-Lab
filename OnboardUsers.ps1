# ==============================================================================
# Script Name: Automated-Onboarding.ps1
# Author: Kadeem Donovan
# Date: June 2026
#
# DESIGN & SECURITY ARCHITECTURE NOTE:
# This script applies a temporary initial password ('Bootcamp2026!') to allow 
# account creation. However, in compliance with enterprise security best practices,
# password complexity requirements are centrally enforced via Active Directory Group 
# Policy Objects (GPOs), NOT hardcoded here. 
#
# By enforcing 'ChangePasswordAtLogon = $true', this script triggers a secure handshake:
# the temporary credential is burned immediately upon initial workstation login, 
# forcing the user to create a private password complying with our GPO complexity rules.
# ==============================================================================

Import-Module ActiveDirectory

# Define the source file containing employees
$CSVFile = "C:\LabFiles\employees.csv"
$Users = Import-Csv -Path $CSVFile

# Loop through each row in the CSV spreadsheet one-by-one
foreach ($User in $Users) {
    
    # Word blender: Take first initial + full last name, force to lowercase
    $Username = ($User.FirstName.Substring(0,1) + $User.LastName).ToLower()
    
    # Dynamic Pathing: Target the exact department OU matching the CSV data
    $TargetOU = "OU=$($User.Department),OU=Users,OU=London-Office,DC=kadtech,DC=local"
    
    # Convert temporary baseline string into an encrypted system-accepted Secure String
    $SecurePassword = ConvertTo-SecureString "Bootcamp2026!" -AsPlainText -Force
    
    # Map all collected user attributes into a neat checklist parameter configuration
    $UserParams = @{
        SamAccountName        = $Username
        UserPrincipalName     = "$Username@kadtech.local"
        Path                  = $TargetOU
        AccountPassword       = $SecurePassword
        ChangePasswordAtLogon = $true   # Bridges script creation with centralized GPO rules
        Enabled               = $true
    }
    
    # Physically execute the account creation in the database
    New-ADUser @UserParams
    
    # Automatically nest the user into their respective department RBAC security group
    Add-ADGroupMember -Identity "g_LON_$($User.Department)_Staff" -Members $Username
}