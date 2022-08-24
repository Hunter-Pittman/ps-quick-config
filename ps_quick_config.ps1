
$timestamp = Get-Date -Format o | ForEach-Object { $_ -replace ":", "." }


function Python-Check {
    # Need to add pip check for chardet
    $Check = ((gp HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\*).DisplayName -Match "Python").Length -gt 0

    if ($Check) {
        Write-Host "Python is installed..."
    } else {
        Write-Error "Python is not installed!"

        exit 1
    }
}

function Wesng-Check {
    $OutputFilename = "systeminfo_" + $timestamp + ".txt"

    systeminfo.exe > $outputfilename

    if ((Test-Path "./definitions.zip") -eq $False) {
        Write-Host "Updating defintions..."
        python ./wesng-master/wes.py --update
    }

    # Creating temp file feels clunky. Need to figure way around that
    python ./wesng-master/wes.py -e $OutputFilename > "wesng_temp.txt"

    $WesngResult =  Get-Content ./wesng_temp.txt | Select-String -Pattern "[-] Done. No vulnerabilities found" -SimpleMatch
    
    if ($WesngResult.ToString() -eq "[-] Done. No vulnerabilities found") {
        Write-Host "No exploits!"
    } else {
        $WesngResult =  Get-Content ./wesng_temp.txt | Select-String -Pattern "[!] Found Vulnernbilities!" -SimpleMatch
        if ($WesngResult.ToString() -eq "[!] Found Vulnernbilities!") {
            Write-Warning "Exploits found!"
        } else {
            Write-Error "An unkown error occured! Check wesng output for more details"
        }
    }

}

function Network-Check {
    $NetworkInfo = Get-NetIPAddress

    foreach ($Adapter in $NetworkInfo) {
        if ($Adapter.AddressFamily -eq "IPv4") {
            Write-Host $Adapter.InterfaceAlias
        } else {
            continue
        }
    }

}

# Function will handle enabling all needed extra windows logging
function Enable-Logging {

}

# If the machine is a domain controller do some config checks and change as needed. Maybe want a seperate module
function ADDoamin-Config {

}

# Monitors the list of domain admins
function Admin-Poll {

}

# Configures local admin
function LocalAdmin-Config {

}




function main {
    Python-Check
    Wesng-Check
    Network-Check
}

main