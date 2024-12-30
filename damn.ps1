Add-Type -AssemblyName "System.Windows.Forms"

function Show-OpenFileDialog($filter, $title) {
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = $filter
    $openFileDialog.Title = $title
    $openFileDialog.ShowDialog() | Out-Null
    return $openFileDialog.FileName
}

function Bypass-ADS {
    Write-Host "Bypassing ADS..." -ForegroundColor Green
Remove-Item -Path “C:\Users\ASUS\AppData\Roaming\.minecraft\resourcepacks\Violus.zip"
}

function Bypass-Registry {
    Write-Host "Bypassing startup..." -ForegroundColor Green
    # Esegui i comandi per bypassare il registro (aggiungi le voci per startup)
    New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "ZoomIt" -Value "C:\Users\ASUS\Desktop\SysinternalsSuite\ZoomIt64.exe" -PropertyType String -Force
    New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "Chrome" -Value "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk --autostart --minimized" -PropertyType String -Force
}

function Clean-Registry {
    Write-Host "Bypassing registry..." -ForegroundColor Green
    # Rimuovi Zone.Identifier e Forfiles.exe dal registro
    Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\bam\State\UserSettings\S-1-5-21-712418282-1354718922-2415260833-1001" -Name "*Violus.zip:Zone.Identifier*" -ErrorAction SilentlyContinue
Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\bam\State\UserSettings\S-1-5-21-712418282-1354718922-2415260833-1001" -Name "*forfiles*"  -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FeatureUsage\AppSwitched" -Name "{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\forfiles.exe" -ErrorAction SilentlyContinue
}

function Clean-ExtraTraces {
    Write-Host "Cleaning extra traces..." -ForegroundColor Green
    # Rimuovi file DiagTrack da System32
    Remove-Item -Path "C:\Windows\System32\diagtrack*" -Force -ErrorAction SilentlyContinue
}

function Add-Traces {
    Write-Host "Adding texture pack..." -ForegroundColor Green
    # Seleziona la cartella da spostare
    $folderPath = Show-OpenFileDialog "Cartelle (*.*)|*" "Seleziona la cartella da spostare"
    
    if (-not $folderPath) {
        Write-Host "No folder selected. Exiting..." -ForegroundColor Red
        return
    }

    $destDir = "$env:APPDATA\.minecraft\resourcepacks"
    # Crea la cartella di destinazione se non esiste
    if (-not (Test-Path -Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir | Out-Null
    }

    $folderName = [System.IO.Path]::GetFileName($folderPath)
    $destFolderPath = Join-Path -Path $destDir -ChildPath $folderName

    # Sposta la cartella nel percorso di destinazione
    Move-Item -Path $folderPath -Destination $destFolderPath -Force
    Write-Host "Folder moved to: $destFolderPath" -ForegroundColor Green

    # Elimina la cartella e tutto il suo contenuto (Shift + Delete)
    try {
        Write-Host "Deleting folder permanently..." -ForegroundColor Green
        Remove-Item -Path $destFolderPath -Recurse -Force
        Write-Host "Folder deleted permanently" -ForegroundColor Green
    }
    catch {
        Write-Host "Error deleting the folder." -ForegroundColor Red
    }
}



# Funzione principale per eseguire tutti i comandi
function Execute-Commands {
    Write-Host "Executing all commands..." -ForegroundColor Yellow

    # Bypass ADS
    Bypass-ADS    

    # Bypass Registry (editing startup settings)
    Bypass-Registry

    # Cleaning Registry (cleaning traces from registry)
    Clean-Registry

    # Cleaning Extra Traces (diagtrack files)
    Clean-ExtraTraces

    # Adding Texture Pack (unzipping file)
    Add-Traces

    Write-Host "All commands executed successfully!" -ForegroundColor Green
}

# Avvia l'esecuzione dei comandi
Execute-Commands
