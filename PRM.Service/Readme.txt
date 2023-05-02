******************************************************************************************************
*****************************************BACKGROUND INFO**********************************************
******************************************************************************************************

Visual studio no longer compiles into automated install packages (MSI)
To register a service you can use this commandline (easiest method is via batch file)


******************************************************************************************************
*******************************FULL SERVICE INSTALLATION INSTRUCTIONS*********************************
******************************************************************************************************

Step 1: Compile PatientPortal.Service Project. Build it in Release Mode **Very Important**
	First, confirm App.config (the service's config file on the project) is pointed to the proper server & database. 
	For authentication, it should use SSPI so you can enable a user account on the service.
	Troubleshooting notes:
	If error on EO.pdf reference...Try adding EO.PDF to the Bin\Debug and Bin\Release Folders under PatientPortal.Utility.

Step 2: Uninstall Service **optional if first time setup
	Using the manual install method, I only know how to uninstall a service through the installer. 
	I don't know how it behaves to uninstall with a newer version of the service, so uninstall it using the version
	on the server is ideal. Hence, doing this near the beginning is best.

	Troubleshooting Notes:
	**Make sure you don't have the Service Panel (from Admin Tools) running at the same time you do this.
	**Install as admin (ie. use Run as Admin on the batchfile or on Cmd Prompt if doing manually)
	**Verify that the paths are accurate. 
	**The InstallUtil should be part of typical latest .net framework packages. PatientPortal.Service.Exe should be the compiled version of the service.

	Uninstall:
	"C:\Windows\Microsoft.NET\Framework\v4.0.30319\InstallUtil.exe" /u "C:\Users\jhv\Source\Workspaces\prm.careblue.com\PatientPortal.Service\bin\Debug\PatientPortal.Service.exe"
	Pause

Step 3: Server Setup - Transfer files to Server.
	EO.pdf will probably be needed on server, drop it into C:\Windows\System32
	Transfer PatientPortal.Service.exe if compilation was done elsewhere. Any local location is fine as long as you know the path.

Step 4: Install the Service
	Troubleshooting Notes:
	**Install as admin (ie. use Run as Admin on the batchfile or on Cmd Prompt if doing manually)
	**Verify that the paths are accurate. 
	**The InstallUtil should be part of typical latest .net framework packages. PatientPortal.Service.Exe should be the compiled version of the service.

	Install Batch Code:
	"C:\Windows\Microsoft.NET\Framework\v4.0.30319\InstallUtil.exe" "C:\Users\jhv\Source\Workspaces\prm.careblue.com\PatientPortal.Service\bin\Release\PatientPortal.Service.exe"
	Pause

Step 5: Configure Set User Account to Service
	The Service must run under an account that has sufficient access to the SQL Server and to the local directory so that it can create pdf files.

	Run Administration Tools and find Services.
	Scroll down to CBService
	Click on Properties and go to the Log on tab.
	Change to This account field to a local admin user (msapnar or jhv), fill in their current password.
	Apply changes and close window.
	Select CBService and Start Service.

	Refresh and ensure it is still running, if it crashed, it would probably go back to not started immediately after.

******************************************************************************************************
*******************************SHORT SERVICE INSTALLATION INSTRUCTIONS********************************
******************************************************************************************************

This will only be available if everything has previously been setup on the server.

1) Run UninstallService.bat (should prompt to elevate to admin)
2) Transfer full build to InstallScripts Folder
3) Run InstallService.bat (should prompt to elevate to admin)
4) Change account to admin account on service