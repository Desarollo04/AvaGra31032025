# Cambiar la política de ejecución solo para esta sesión
Write-Host "Estableciendo política de ejecución en Bypass..."
Set-ExecutionPolicy Bypass -Scope Process -Force
Write-Host "Política de ejecución configurada."

# Ruta donde se guardará el instalador en la carpeta de Descargas
$InstallerPath = "$env:USERPROFILE\Downloads\AvastSetup.exe"
Write-Host "La ruta de descarga es: $InstallerPath"  # Verificar la ruta

# URL oficial del instalador de Avast Free Antivirus
$AvastURL = "https://bits.avcdn.net/productfamily_ANTIVIRUS/insttype_FREE/platform_WIN/installertype_ONLINE/build_RELEASE"
Write-Host "URL del instalador: $AvastURL"  # Verificar la URL

# Descargar el instalador
Write-Host "Iniciando la descarga de Avast Free Antivirus..."
try {
    Invoke-WebRequest -Uri $AvastURL -OutFile $InstallerPath -ErrorAction Stop
    Write-Host "Instalador descargado con éxito."
} catch {
    Write-Host "Error: No se pudo descargar el instalador." -ForegroundColor Red
    Write-Host $_.Exception.Message  # Mostrar detalles del error
    Exit
}

# Verificar si el archivo existe antes de ejecutarlo
Write-Host "Verificando si el archivo existe en la ruta de Descargas..."
if (Test-Path $InstallerPath) {
    Write-Host "Instalador encontrado. Iniciando la instalación..."
    $process = Start-Process -FilePath $InstallerPath -ArgumentList "/silent /norestart" -PassThru -Wait
    Write-Host "Proceso de instalación iniciado."
    
    # Verificar si la instalación fue exitosa
    if ($process.ExitCode -eq 0) {
        Write-Host "Instalación completada con éxito." -ForegroundColor Green
    } else {
        Write-Host "Error: La instalación no se completó correctamente (Código de salida: $($process.ExitCode))." -ForegroundColor Red
    }
} else {
    Write-Host "Error: No se encontró el instalador en la ruta $InstallerPath." -ForegroundColor Red
}

# Esperar unos segundos antes de eliminar el archivo
Write-Host "Esperando unos segundos antes de eliminar el instalador..."
Start-Sleep -Seconds 5

# Eliminar el instalador después de la instalación
Write-Host "Eliminando el instalador..."
Remove-Item -Path $InstallerPath -Force
Write-Host "Instalador eliminado."
