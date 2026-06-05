# Active-Directory-Lab
“An isolated enterprise-grade Windows Server 2022 Active Directory lab featuring network segmentation, DHCP/DNS deployment, and PowerShell onboarding automation.”

This project was created to demonstrate my deployment, structure, and automation of an Active Directory Domain Services environment name kadtech.local. It was built inside a virtual sandbox using VirtualBox, and showcases automated employee onboarding via PowerShell, Group Policy security baselines, and core infrastructure network services (DHCP & DNS).

System Architechture & Network Design
The entire infrastructure runs on an internal, private virtual network subnet (192.168.10.0/24) to keep the identity databse isolated.

Machine configuration

Domain Controller:WIN-SVGCOOKFC1H
IP Address Static 192.168.10.10
DNS Server: 192.168.10.10

Workstation: WINDOWS11CLIENT
Operating System: Windows 11 Pro (Domain-Joined to kadtech.local)
Network Handling: Received its IP network configurations dynamically from the Domain Controller.

Core Implementations

The direcory environment uses a geographic root structure with hyphenated naming conventions to keep assets organised.

<img width="422" height="365" alt="image" src="https://github.com/user-attachments/assets/cef6a93f-8385-4bff-b00e-79bd47b6842a" />



Core Network Services
The Domain Controller handles dynamic IP assignments for endpoints on the internal switch:
DHCP Scope Range: 192.168.10.50 to 192.168.10.100
<img width="941" height="442" alt="image" src="https://github.com/user-attachments/assets/913b04ad-9918-4225-bace-bd447064a49c" />

DNS Server Option: Points directly to 192.168.10.10 for domain resolution. I used 127.0.0.1 within my DNS settings as it is a loopback address.
<img width="402" height="452" alt="image" src="https://github.com/user-attachments/assets/d1eda8d6-b1f4-45c6-9303-63453435dcf2" />



Identity Lifecycle Automation via PowerShell

The follwoing onboarding script automatically creates corporate employee roster for my environment using the employee.csv file. It converts names into standardized lowercase username format, places the accounts in their respective department Organizational Units, and assigns them to Role-Based Access Control (RBAC) groups.
<img width="730" height="551" alt="image" src="https://github.com/user-attachments/assets/a507fd5d-03d1-4d06-8001-946674219b55" />



Security Baseline Group Policies (GPOs)

Applied a baseline security policy accross the domain structure:
Account lockout Threshold: Accounts are locked for 30 minutes after 5 consecutive invalid ligin attempts to protect against brute-force attacks.

Interactive Logon Banner: Enforces a mandatory legal text notice before users log in.


Role-Based Access Control (RBAC) File Share
Storage Location: Configured a data directory path at C:\CompanyShares\SalesData
Access Mapping: Users in the Sales security group have modification rights and Group Policy maps this folder automatically to their workstation as the s:\ Drive upon logging in.

Testing & Verification

Password Security Verifcation: Logging in as an automated user (jbrown) requires inputting the temporary credential, where Windows immediately enforces the requirement to change the password before gaining access to the desktop.

Access Control Verification: The S:\ drive maps successfully users inside the Sales Organizational Unit, while users outside the Sales OU (such as IT) are not able to access the network share.

