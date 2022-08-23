$script = New-Object Net.WebClient

$script.DownloadString("https://chocolatey.org/install.ps1")

Invoke-WebRequest https://chocolatey.org/install.ps1 -UseBasicParsing | Invoke-Expression

choco install -y python3

refreshenv

pip3 install chardet