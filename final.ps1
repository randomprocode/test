Set-ExecutionPolicy Bypass -Scope Process -Force
Add-Type -AssemblyName "System.Windows.Forms"

# Funzione per aprire il dialogo di selezione file
function Show-OpenFileDialog($filter, $title) {
    $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $openFileDialog.Filter = $filter
    $openFileDialog.Title = $title
    $openFileDialog.ShowDialog() | Out-Null
    return $openFileDialog.FileName
}

# Funzione per bypassare ADS
function Bypass-ADS {
    Write-Host "Bypassing ADS..." -ForegroundColor Green
    Remove-Item -Path "C:\Users\ASUS\AppData\Roaming\.minecraft\resourcepacks\Violus.zip"
}

# Funzione per bypassare il registro
function Bypass-Registry {
    Write-Host "Bypassing startup..." -ForegroundColor Green
    New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "ZoomIt" -Value "C:\Users\ASUS\Desktop\SysinternalsSuite\ZoomIt64.exe" -PropertyType String -Force
    New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "Chrome" -Value "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Google Chrome.lnk --autostart --minimized" -PropertyType String -Force
}

# Funzione per pulire il registro
function Clean-Registry {
    Write-Host "Bypassing registry..." -ForegroundColor Green
    Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\bam\State\UserSettings\S-1-5-21-712418282-1354718922-2415260833-1001" -Name "*Violus.zip:Zone.Identifier*" -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\bam\State\UserSettings\S-1-5-21-712418282-1354718922-2415260833-1001" -Name "*forfiles*"  -ErrorAction SilentlyContinue
    Remove-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\FeatureUsage\AppSwitched" -Name "{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\forfiles.exe" -ErrorAction SilentlyContinue
}

# Funzione per pulire tracce extra
function Clean-ExtraTraces {
    Write-Host "Cleaning extra traces..." -ForegroundColor Green
    Remove-Item -Path "C:\Windows\System32\diagtrack*" -Force -ErrorAction SilentlyContinue
}

# Funzione per aggiungere la texture pack
# Funzione per aggiungere il texture pack senza eliminare la cartella
function Add-Traces {
    Write-Host "Adding texture pack..." -ForegroundColor Green
    $folderPath = Show-OpenFileDialog "Cartelle (*.*)|*" "Seleziona la cartella da spostare"
    
    if (-not $folderPath) {
        Write-Host "No folder selected. Exiting..." -ForegroundColor Red
        return
    }

    $destDir = "$env:APPDATA\.minecraft\resourcepacks"
    if (-not (Test-Path -Path $destDir)) {
        New-Item -ItemType Directory -Path $destDir | Out-Null
    }

    $folderName = [System.IO.Path]::GetFileName($folderPath)
    $destFolderPath = Join-Path -Path $destDir -ChildPath $folderName

    Move-Item -Path $folderPath -Destination $destFolderPath -Force
    Write-Host "Folder moved to: $destFolderPath" -ForegroundColor Green
}


# Funzione principale per eseguire tutti i comandi
function Execute-Commands {
    Write-Host "Executing all commands..." -ForegroundColor Yellow
    Bypass-ADS    
    Bypass-Registry
    Clean-Registry
    Clean-ExtraTraces
    Add-Traces
    Write-Host "All commands executed successfully!" -ForegroundColor Green
}

# Esegui le operazioni principali
Execute-Commands



# Funzioni per configurare e gestire DiagTrack e BAM

function Revert-Configure-BAM {
    Write-Host "Configurazione del servizio BAM per l'avvio automatico..." -ForegroundColor Yellow
    try {
        # Esegui il comando con privilegi elevati
        $configService = Start-Process -FilePath "sc.exe" -ArgumentList "config", "bam", "start=auto" -PassThru -Wait -Verb RunAs
        if ($configService.ExitCode -eq 0) {
            Write-Host "Servizio BAM configurato per l'avvio automatico." -ForegroundColor Green
        } else {
            Write-Host "Errore durante la configurazione del servizio BAM. Codice di uscita: $($configService.ExitCode)" -ForegroundColor Red
        }
    } catch {
        Write-Host "Errore durante la configurazione del servizio BAM: $_" -ForegroundColor Red
    }
}

function Revert-Start-BAM {
    Write-Host "Avvio del servizio BAM..." -ForegroundColor Yellow
    try {
        # Esegui il comando con privilegi elevati
        $startService = Start-Process -FilePath "sc.exe" -ArgumentList "start", "bam" -PassThru -Wait -Verb RunAs
        if ($startService.ExitCode -eq 0) {
            Write-Host "Servizio BAM avviato con successo." -ForegroundColor Green
        } else {
            Write-Host "Errore durante l'avvio del servizio BAM. Codice di uscita: $($startService.ExitCode)" -ForegroundColor Red
        }
    } catch {
        Write-Host "Errore durante l'avvio del servizio BAM: $_" -ForegroundColor Red
    }
}

function Revert-Configure-DiagTrack {
    Write-Host "Configurazione del servizio DiagTrack per l'avvio automatico..." -ForegroundColor Yellow
    try {
        # Esegui il comando con privilegi elevati per configurare il servizio DiagTrack
        $configService = Start-Process -FilePath "sc.exe" -ArgumentList "config", "DiagTrack", "start=auto" -PassThru -Wait -Verb RunAs
        if ($configService.ExitCode -eq 0) {
            Write-Host "Servizio DiagTrack configurato per l'avvio automatico." -ForegroundColor Green
        } else {
            Write-Host "Errore durante la configurazione del servizio DiagTrack. Codice di uscita: $($configService.ExitCode)" -ForegroundColor Red
        }
    } catch {
        Write-Host "Errore durante la configurazione del servizio DiagTrack: $_" -ForegroundColor Red
    }
}

function Revert-Start-DiagTrack {
    Write-Host "Avvio del servizio DiagTrack..." -ForegroundColor Yellow
    try {
        # Esegui il comando con privilegi elevati per avviare il servizio DiagTrack
        $startService = Start-Process -FilePath "sc.exe" -ArgumentList "start", "DiagTrack" -PassThru -Wait -Verb RunAs
        if ($startService.ExitCode -eq 0) {
            Write-Host "Servizio DiagTrack avviato con successo." -ForegroundColor Green
        } else {
            Write-Host "Errore durante l'avvio del servizio DiagTrack. Codice di uscita: $($startService.ExitCode)" -ForegroundColor Red
        }
    } catch {
        Write-Host "Errore durante l'avvio del servizio DiagTrack: $_" -ForegroundColor Red
    }
}


function Revert-TakeOwnership-DiagTrackDLL {
    Write-Host "Ripristinando il possesso del file DiagTrack.dll..." -ForegroundColor Yellow
    try {
        $takeown = Start-Process -FilePath "takeown" -ArgumentList "/F", "C:\Windows\System32\DiagTrack.dll" -PassThru -Wait
        if ($takeown.ExitCode -eq 0) {
            Write-Host "Possesso del file DiagTrack.dll ripristinato con successo." -ForegroundColor Green
        } else {
            Write-Host "Errore durante il ripristino del possesso del file DiagTrack.dll. Codice di uscita: $($takeown.ExitCode)" -ForegroundColor Red
        }
    } catch {
        Write-Host "Errore durante il ripristino del possesso del file DiagTrack.dll: $_" -ForegroundColor Red
    }
}

function Revert-Permissions-DiagTrackDLL {
    Write-Host "Ripristinando i permessi del file DiagTrack.dll..." -ForegroundColor Yellow
    try {
        $icacls = Start-Process -FilePath "icacls" -ArgumentList "C:\Windows\System32\DiagTrack.dll", "/remove:d", "Everyone" -PassThru -Wait
        if ($icacls.ExitCode -eq 0) {
            Write-Host "Permessi ripristinati con successo al file DiagTrack.dll." -ForegroundColor Green
        } else {
            Write-Host "Errore durante il ripristino dei permessi al file DiagTrack.dll. Codice di uscita: $($icacls.ExitCode)" -ForegroundColor Red
        }
    } catch {
        Write-Host "Errore durante il ripristino dei permessi al file DiagTrack.dll: $_" -ForegroundColor Red
    }
}

function Revert-Start-DiagTrackListener {
    Write-Host "Avvio del listener DiagTrack-Listener..." -ForegroundColor Yellow
    try {
        $startListener = Start-Process -FilePath "logman" -ArgumentList "start", "DiagTrack-Listener", "-ets" -PassThru -Wait
        if ($startListener.ExitCode -eq 0) {
            Write-Host "Listener DiagTrack-Listener avviato con successo." -ForegroundColor Green
        } else {
            Write-Host "Errore durante l'avvio del listener DiagTrack-Listener. Codice di uscita: $($startListener.ExitCode)" -ForegroundColor Red
        }
    } catch {
        Write-Host "Errore durante l'avvio del listener DiagTrack-Listener: $_" -ForegroundColor Red
    }
}

function Revert-Create-DiagTrackListener {
    Write-Host "Creazione del listener DiagTrack-Listener..." -ForegroundColor Yellow
    try {
        $createListener = Start-Process -FilePath "logman" -ArgumentList "create", "trace", "DiagTrack-Listener", "-p", "Microsoft-Windows-Diagnostics-Performance", "-o", "C:\Windows\System32\DiagTrack-Listener.etl", "-ets" -PassThru -Wait
        if ($createListener.ExitCode -eq 0) {
            Write-Host "Listener DiagTrack-Listener creato con successo." -ForegroundColor Green
        } else {
            Write-Host "Errore durante la creazione del listener DiagTrack-Listener. Codice di uscita: $($createListener.ExitCode)" -ForegroundColor Red
        }
    } catch {
        Write-Host "Errore durante la creazione del listener DiagTrack-Listener: $_" -ForegroundColor Red
    }
}

# Avvia i comandi relativi al servizio DiagTrack

Revert-TakeOwnership-DiagTrackDLL
Revert-Permissions-DiagTrackDLL
Revert-Start-DiagTrackListener
Revert-Create-DiagTrackListener
Revert-Configure-DiagTrack
Revert-Start-DiagTrack

# Attendere 10 secondi
Start-Sleep -Seconds 10

Revert-Configure-BAM
Revert-Start-BAM
