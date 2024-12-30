# Funzione per configurare il servizio BAM come avvio automatico
function Revert-Configure-BAM {
    Write-Host "Configurazione del servizio BAM per l'avvio automatico..." -ForegroundColor Yellow
    try {
        # Usa il comando SC per configurare il servizio BAM come avvio automatico
        $configService = Start-Process -FilePath "sc.exe" -ArgumentList "config", "bam", "start=auto" -PassThru -Wait
        if ($configService.ExitCode -eq 0) {
            Write-Host "Servizio BAM configurato per l'avvio automatico." -ForegroundColor Green
        } else {
            Write-Host "Errore durante la configurazione del servizio BAM. Codice di uscita: $($configService.ExitCode)" -ForegroundColor Red
        }
    } catch {
        Write-Host "Errore durante la configurazione del servizio BAM: $_" -ForegroundColor Red
    }
}

# Funzione per avviare il servizio BAM
function Revert-Start-BAM {
    Write-Host "Avvio del servizio BAM..." -ForegroundColor Yellow
    try {
        $startService = Start-Process -FilePath "sc.exe" -ArgumentList "start", "bam" -PassThru -Wait
        if ($startService.ExitCode -eq 0) {
            Write-Host "Servizio BAM avviato con successo." -ForegroundColor Green
        } else {
            Write-Host "Errore durante l'avvio del servizio BAM. Codice di uscita: $($startService.ExitCode)" -ForegroundColor Red
        }
    } catch {
        Write-Host "Errore durante l'avvio del servizio BAM: $_" -ForegroundColor Red
    }
}

# Funzione per ripristinare il possesso del file DiagTrack.dll
function Revert-TakeOwnership-DiagTrackDLL {
    Write-Host "Ripristinando il possesso del file DiagTrack.dll..." -ForegroundColor Yellow
    try {
        # Ripristina il possesso del file
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

# Funzione per ripristinare i permessi del file DiagTrack.dll
function Revert-Permissions-DiagTrackDLL {
    Write-Host "Ripristinando i permessi del file DiagTrack.dll..." -ForegroundColor Yellow
    try {
        # Ripristina i permessi al file
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

# Funzione per avviare il listener DiagTrack-Listener
function Revert-Start-DiagTrackListener {
    Write-Host "Avvio del listener DiagTrack-Listener..." -ForegroundColor Yellow
    try {
        # Usa il comando logman per avviare il listener
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

# Funzione per creare il listener DiagTrack-Listener
function Revert-Create-DiagTrackListener {
    Write-Host "Creazione del listener DiagTrack-Listener..." -ForegroundColor Yellow
    try {
        # Usa il comando logman per creare il listener
        $createListener = Start-Process -FilePath "logman" -ArgumentList "create", "trace", "DiagTrack-Listener", "-p", "Microsoft-Windows-DiagTrack", "-o", "DiagTrack-Log" -PassThru -Wait
        if ($createListener.ExitCode -eq 0) {
            Write-Host "Listener DiagTrack-Listener creato con successo." -ForegroundColor Green
        } else {
            Write-Host "Errore durante la creazione del listener DiagTrack-Listener. Codice di uscita: $($createListener.ExitCode)" -ForegroundColor Red
        }
    } catch {
        Write-Host "Errore durante la creazione del listener DiagTrack-Listener: $_" -ForegroundColor Red
    }
}

# Funzione per configurare il servizio DiagTrack come avvio automatico
function Revert-Configure-DiagTrack {
    Write-Host "Configurazione del servizio DiagTrack per l'avvio automatico..." -ForegroundColor Yellow
    try {
        # Usa il comando SC per configurare il servizio come avvio automatico
        $configService = Start-Process -FilePath "sc.exe" -ArgumentList "config", "diagtrack", "start=auto" -PassThru -Wait
        if ($configService.ExitCode -eq 0) {
            Write-Host "Servizio DiagTrack configurato per l'avvio automatico." -ForegroundColor Green
        } else {
            Write-Host "Errore durante la configurazione del servizio DiagTrack. Codice di uscita: $($configService.ExitCode)" -ForegroundColor Red
        }
    } catch {
        Write-Host "Errore durante la configurazione del servizio DiagTrack: $_" -ForegroundColor Red
    }
}

# Funzione per avviare il servizio DiagTrack
function Revert-Start-DiagTrack {
    Write-Host "Avvio del servizio DiagTrack..." -ForegroundColor Yellow
    try {
        $startService = Start-Process -FilePath "sc.exe" -ArgumentList "start", "diagtrack" -PassThru -Wait
        if ($startService.ExitCode -eq 0) {
            Write-Host "Servizio DiagTrack avviato con successo." -ForegroundColor Green
        } else {
            Write-Host "Errore durante l'avvio del servizio DiagTrack. Codice di uscita: $($startService.ExitCode)" -ForegroundColor Red
        }
    } catch {
        Write-Host "Errore durante l'avvio del servizio DiagTrack: $_" -ForegroundColor Red
    }
}

# Esegui le operazioni in sequenza
Revert-TakeOwnership-DiagTrackDLL
Revert-Permissions-DiagTrackDLL
Revert-Start-DiagTrackListener
Revert-Create-DiagTrackListener
Revert-Configure-DiagTrack
Revert-Start-DiagTrack
Revert-Configure-BAM
Revert-Start-BAM
