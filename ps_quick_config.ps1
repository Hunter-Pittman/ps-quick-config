
$timestamp = Get-Date -Format o | ForEach-Object { $_ -replace ":", "." }


function Python-Check {
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

    if (Test-Path "./definitions.zip" ) {
        continue
    } else {
        python ./wesng-master/wes.py --update
    }
    
    $CVEOutput = "new_" + $timestamp + ".txt"

    $OSCVEInfo = python ./wesng-master/wes.py -e $outputfilename > $CVEOutput
    Select-String $OSCVEInfo -Pattern ""
    return $OSCVEInfo
}

function main {
    Python-Check
    Wesng-Check
}

main