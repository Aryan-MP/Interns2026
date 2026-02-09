 Install-WindowsFeature Web-Server -IncludeManagementTools

  Start-Service W3SVC

  "<h1>My IIS Page - Danish</h1><p>$env:COMPUTERNAME</p>" | Out-File C:\inetpub\wwwroot\index.html -Encoding utf8 -Force