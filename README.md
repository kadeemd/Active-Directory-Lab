# Active-Directory-Lab

"An isolated Windows Server 2022 Active Directory lab, featuring network segmentation, DHCP/DNS deployment, Group Policy, and PowerShell onboarding automation."

This project was created to demonstrate my deployment, structure, and automation of an Active Directory Domain Services environment named `kadtech.local`. It was built inside a virtual sandbox using VirtualBox, and showcases automated employee onboarding via PowerShell, Group Policy security baselines, and core infrastructure network services (DHCP & DNS).

---

##  System Architecture & Network Design
The entire infrastructure runs on an internal, private virtual network subnet (`192.168.10.0/24`) to keep the identity database isolated.

### Machine Configuration

* **Domain Controller:** `WIN-SVGCOOKFC1H`
  * **IP Address (Static):** `192.168.10.10`
  * **DNS Server:** `192.168.10.10`
* **Workstation:** `WINDOWS11CLIENT`
  * **Operating System:** Windows 11 Pro (Domain-Joined to `kadtech.local`)
  * **Network Handling:** Received its IP network configurations dynamically from the Domain Controller.

---

##  Core Implementations

The directory environment uses a geographic root structure with hyphenated naming conventions to keep assets organised.

<img width="422" height="365" alt="kadtechTree" src="https://github.com/user-attachments/assets/5c29333f-7873-4f6e-8d33-ac28d32e0249" />

---

##  Core Network Services

The Domain Controller handles dynamic IP assignments for endpoints on the internal switch:

* **DHCP Scope Range:** `192.168.10.50` to `192.168.10.100`

<img width="941" height="442" alt="DHCP Address Pool" src="https://github.com/user-attachments/assets/ebcd5052-14d6-4896-8408-880a08527fe5" />

* **DNS Server Configuration:** Points directly to the Domain Controller (`192.168.10.10`) for domain resolution by using the loopback address `127.0.0.1`.

<img width="402" height="452" alt="IP Configuration for Server" src="https://github.com/user-attachments/assets/ad5bfed5-970b-49af-bc5c-03b187ed256b" />

---

##  Identity Lifecycle Automation via PowerShell

To simulate identity lifecycle management within my environmant, I developed two PowerShell scripts to automate onboarding and offboarding using CSV data files.

The following onboarding script automatically creates corporate user accounts for employees within my environment using the `employee.csv` file. It converts names into a standardized lowercase username format, places the accounts in their respective department Organizational Units, and assigns them to Role-Based Access Control (RBAC) groups.

<img width="730" height="551" alt="Onboarding Script " src="https://github.com/user-attachments/assets/8c35af50-824d-40e9-8641-6ea50c0f99bf" />
<img width="736" height="476" alt="employeeCSVFile" src="https://github.com/user-attachments/assets/06cd1734-27bb-40a6-90cf-7bda36b4254a" />


The following shows me running a script named OffboardingScript.ps1, which allows me to disable user accounts and move them into a OU named Disabled Users. This script uses a CSV file named OffboardEmployees.csv.

<img width="1170" height="412" alt="OffboardScript running" src="https://github.com/user-attachments/assets/e3ff9f82-6304-4bac-80ee-bc58aeef0dac" />
<img width="752" height="557" alt="Offboarded users" src="https://github.com/user-attachments/assets/5e3a45b5-f3a7-44b3-97e1-99bc6b745ea8" />

---

##  Security Baseline Group Policies (GPOs)

Applied a baseline security policy across the domain structure:

* **Account Lockout Threshold:** Accounts are locked for 30 minutes after **5 consecutive invalid login attempts** to protect against brute-force attacks.

<img width="951" height="382" alt="GroupPolicy Lockout" src="https://github.com/user-attachments/assets/a9abf369-0728-4c12-870c-f0ab31717fb9" />

* **Interactive Logon Banner:** Enforces a mandatory legal text notice before users log in.

<img width="950" height="1027" alt="LoginMessage Policy" src="https://github.com/user-attachments/assets/3cf158bf-1944-434f-9cfa-fd3036a93496" />

### Role-Based Access Control (RBAC) File Share
* **Storage Location:** Configured a data directory path at `C:\CompanyShares\SalesData`
* **Access Mapping:** Users in the Sales security group have modification rights and Group Policy maps this folder automatically to their workstation as the **`S:\` Drive** upon logging in.

---

##  Testing & Verification

* **Password Security Verification:** Logging in as an automated user (`asmith`) requires inputting the temporary credential, where Windows immediately enforces the requirement to change the password before gaining access to the desktop.

<img width="952" height="1027" alt="PasswordchangeRequest" src="https://github.com/user-attachments/assets/259dd97b-8813-4fc4-bf9d-cb59b839c919" />

* **Access Control Verification:** The `S:\` drive maps successfully for users inside the Sales Organizational Unit, while users outside the Sales OU (such as HR) are not able to access the network share.

<img width="1161" height="1198" alt="asmithSharedDrive" src="https://github.com/user-attachments/assets/59c84894-7b01-4b2e-94b0-7dc25a1fc206" />

