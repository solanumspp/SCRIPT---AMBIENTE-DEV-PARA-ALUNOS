# Script de Instalação para Ambiente de Desenvolvimento
# Para executar como Administrador no Windows

# Verificar se está sendo executado como Administrador
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Este script precisa ser executado como Administrador!" -ForegroundColor Red
    Write-Host "Por favor, execute o PowerShell como Administrador e tente novamente." -ForegroundColor Yellow
    pause
    exit
}

# Configurações
$InstallDir = "C:\InstaladoresDev"
$ChocolateyPath = "$env:ProgramData\chocolatey\bin"

# Criar diretório para downloads
if (-not (Test-Path $InstallDir)) {
    New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
}

# Configuração do script
$ErrorActionPreference = "Stop"

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "INSTALADOR DE AMBIENTE DE DESENVOLVIMENTO" -ForegroundColor Cyan
Write-Host "Para alunos" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host ""

# Função para verificar se um comando existe
function Test-Command($cmdname) {
    return [bool](Get-Command -Name $cmdname -ErrorAction SilentlyContinue)
}

# Função para instalar via Chocolatey
function Install-ChocoPackage($packageName, $packageArgs = "") {
    Write-Host "Instalando $packageName..." -ForegroundColor Yellow
    try {
        choco install $packageName -y --force $packageArgs
        if ($LASTEXITCODE -ne 0) {
            Write-Host "Aviso: Chocolatey retornou código $LASTEXITCODE para $packageName" -ForegroundColor Yellow
        }
        Write-Host "$packageName instalado com sucesso!" -ForegroundColor Green
    }
    catch {
        Write-Host "Erro ao instalar $($packageName): $_" -ForegroundColor Red
    }
}

# 1. INSTALAR CHOCOLATEY (gerenciador de pacotes para Windows)
Write-Host "1. Verificando Chocolatey..." -ForegroundColor Cyan
if (-not (Test-Command "choco")) {
    Write-Host "Instalando Chocolatey..." -ForegroundColor Yellow
    try {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
        
        # Atualizar PATH
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
        
        Write-Host "Chocolatey instalado com sucesso!" -ForegroundColor Green
    }
    catch {
        Write-Host "Erro na instalação do Chocolatey: $_" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host "Chocolatey já está instalado." -ForegroundColor Green
}

# Atualizar Chocolatey
Write-Host "Atualizando Chocolatey..." -ForegroundColor Yellow
choco upgrade chocolatey -y

Write-Host ""

# 2. INSTALAR DOCKER DESKTOP
Write-Host "2. Instalando Docker Desktop..." -ForegroundColor Cyan
$dockerCheck = Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -like "*Docker*"}
if ($dockerCheck) {
    Write-Host "Docker Desktop já está instalado." -ForegroundColor Green
} else {
    Write-Host "Fazendo download do Docker Desktop..." -ForegroundColor Yellow
    
    # URL oficial do Docker Desktop para Windows
    $dockerUrl = "https://desktop.docker.com/win/main/amd64/Docker%20Desktop%20Installer.exe"
    $dockerInstaller = "$InstallDir\DockerDesktopInstaller.exe"
    
    try {
        Invoke-WebRequest -Uri $dockerUrl -OutFile $dockerInstaller
        Write-Host "Executando instalação do Docker Desktop..." -ForegroundColor Yellow
        
        # Instalar Docker Desktop
        Start-Process -Wait -FilePath $dockerInstaller -ArgumentList "install --quiet --accept-license"
        
        Write-Host "Docker Desktop instalado! Reinicie o computador após a conclusão de todas as instalações." -ForegroundColor Green
        
        # Docker Compose já vem incluído no Docker Desktop
    }
    catch {
        Write-Host "Erro ao instalar Docker Desktop: $_" -ForegroundColor Red
        Write-Host "Tentando instalar via Chocolatey como alternativa..." -ForegroundColor Yellow
        Install-ChocoPackage "docker-desktop"
    }
}

Write-Host ""

# 3. INSTALAR VIRTUALBOX
Write-Host "3. Instalando VirtualBox..." -ForegroundColor Cyan
if (Test-Command "VBoxManage") {
    Write-Host "VirtualBox já está instalado." -ForegroundColor Green
} else {
    Install-ChocoPackage "virtualbox" "--params='/NoDesktopShortcut /NoQuickLaunch'"
}

Write-Host ""

# 4. INSTALAR POSTMAN (alternativa: Insomnia)
Write-Host "4. Instalando Postman..." -ForegroundColor Cyan
Write-Host "Escolha qual API client instalar:" -ForegroundColor Yellow
Write-Host "1. Postman (recomendado)" -ForegroundColor White
Write-Host "2. Insomnia" -ForegroundColor White
Write-Host "3. Ambos" -ForegroundColor White
Write-Host "4. Pular" -ForegroundColor White

$apiChoice = Read-Host "Digite sua escolha (1-4)"

switch ($apiChoice) {
    "1" { 
        Install-ChocoPackage "postman"
    }
    "2" { 
        Install-ChocoPackage "insomnia"
    }
    "3" { 
        Install-ChocoPackage "postman"
        Install-ChocoPackage "insomnia"
    }
    default {
        Write-Host "Pulando instalação de API client." -ForegroundColor Yellow
    }
}

Write-Host ""

# 5. INSTALAR NODE.JS (alternativa: Python)
Write-Host "5. Instalando Node.js e Python..." -ForegroundColor Cyan
Write-Host "Escolha qual linguagem instalar:" -ForegroundColor Yellow
Write-Host "1. Node.js (recomendado para web)" -ForegroundColor White
Write-Host "2. Python (recomendado para dados/IA)" -ForegroundColor White
Write-Host "3. Ambos" -ForegroundColor White
Write-Host "4. Pular" -ForegroundColor White

$langChoice = Read-Host "Digite sua escolha (1-4)"

switch ($langChoice) {
    "1" { 
        Install-ChocoPackage "nodejs" "--params='/InstallDir:C:\NodeJS'"
        # Instalar npm global packages úteis
        if (Test-Command "npm") {
            Write-Host "Instalando pacotes npm globais úteis..." -ForegroundColor Yellow
            npm install -g yarn nodemon typescript @angular/cli create-react-app express-generator
        }
    }
    "2" { 
        Install-ChocoPackage "python" "--params='/InstallDir:C:\Python'"
    }
    "3" { 
        Install-ChocoPackage "nodejs" "--params='/InstallDir:C:\NodeJS'"
        Install-ChocoPackage "python" "--params='/InstallDir:C:\Python'"
        # Instalar npm global packages úteis
        if (Test-Command "npm") {
            Write-Host "Instalando pacotes npm globais úteis..." -ForegroundColor Yellow
            npm install -g yarn nodemon typescript @angular/cli create-react-app express-generator
        }
    }
    default {
        Write-Host "Pulando instalação de linguagens." -ForegroundColor Yellow
    }
}

Write-Host ""

# 6. INSTALAR MENSAGERIA (RabbitMQ ou Kafka - Opcional)
Write-Host "6. Instalação de sistema de mensageria (Opcional)..." -ForegroundColor Cyan
Write-Host "Deseja instalar algum sistema de mensageria?" -ForegroundColor Yellow
Write-Host "1. RabbitMQ (mais simples)" -ForegroundColor White
Write-Host "2. Apache Kafka (mais escalável)" -ForegroundColor White
Write-Host "3. Ambos" -ForegroundColor White
Write-Host "4. Nenhum (pular)" -ForegroundColor White

$mqChoice = Read-Host "Digite sua escolha (1-4)"

switch ($mqChoice) {
    "1" { 
        Write-Host "Instalando RabbitMQ..." -ForegroundColor Yellow
        
        # RabbitMQ requer Erlang
        Install-ChocoPackage "erlang"
        Install-ChocoPackage "rabbitmq"
        
        # Iniciar serviço RabbitMQ
        Write-Host "Configurando RabbitMQ..." -ForegroundColor Yellow
        try {
            # Habilitar plugin de gerenciamento
            & "C:\Program Files\RabbitMQ Server\rabbitmq_server-*\sbin\rabbitmq-plugins.bat" enable rabbitmq_management
            
            # Iniciar serviço
            Start-Service RabbitMQ
            
            Write-Host "RabbitMQ instalado e configurado!" -ForegroundColor Green
            Write-Host "Acesso web: http://localhost:15672" -ForegroundColor Cyan
            Write-Host "Usuário: guest | Senha: guest" -ForegroundColor Cyan
        }
        catch {
            Write-Host "RabbitMQ instalado, mas configuração manual pode ser necessária." -ForegroundColor Yellow
        }
    }
    "2" { 
        Write-Host "Instalando Apache Kafka..." -ForegroundColor Yellow
        
        # Kafka requer Java
        Install-ChocoPackage "openjdk"
        
        # Instalar Kafka
        Install-ChocoPackage "kafka"
        
        Write-Host "Apache Kafka instalado!" -ForegroundColor Green
        Write-Host "Nota: Kafka requer configuração manual para executar." -ForegroundColor Yellow
    }
    "3" { 
        Write-Host "Instalando ambos RabbitMQ e Kafka..." -ForegroundColor Yellow
        
        # RabbitMQ
        Install-ChocoPackage "erlang"
        Install-ChocoPackage "rabbitmq"
        
        # Kafka
        Install-ChocoPackage "openjdk"
        Install-ChocoPackage "kafka"
        
        Write-Host "Ambos instalados! Configure conforme necessário." -ForegroundColor Green
    }
    default {
        Write-Host "Pulando instalação de sistemas de mensageria." -ForegroundColor Yellow
    }
}

Write-Host ""

# 7. INSTALAR FERRAMENTAS ADICIONAIS ÚTEIS
Write-Host "7. Instalando ferramentas adicionais úteis..." -ForegroundColor Cyan

# Git
if (-not (Test-Command "git")) {
    Install-ChocoPackage "git"
} else {
    Write-Host "Git já está instalado." -ForegroundColor Green
}

# VS Code
if (-not (Test-Path "C:\Program Files\Microsoft VS Code\Code.exe")) {
    Install-ChocoPackage "vscode"
} else {
    Write-Host "VS Code já está instalado." -ForegroundColor Green
}

# 7-Zip (útil para compactação)
Install-ChocoPackage "7zip"

Write-Host ""

# VERIFICAÇÃO FINAL
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "VERIFICAÇÃO DE INSTALAÇÃO" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

function Test-Installation($name, $command) {
    if (Test-Command $command) {
        Write-Host "OK $($name): INSTALADO" -ForegroundColor Green
        return $true
    } else {
        Write-Host "X $($name): NAO INSTALADO" -ForegroundColor Red
        return $false
    }
}

Write-Host ""

$installations = @(
    @{Name="Docker"; Command="docker"},
    @{Name="VirtualBox"; Command="VBoxManage"},
    @{Name="Node.js"; Command="node"},
    @{Name="Python"; Command="python"},
    @{Name="Git"; Command="git"}
)

$successCount = 0
foreach ($item in $installations) {
    if (Test-Installation $item.Name $item.Command) {
        $successCount++
    }
}

Write-Host ""
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "RESUMO DA INSTALAÇÃO" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "Instalações concluídas: $successCount de $($installations.Count)" -ForegroundColor Yellow

if ($successCount -eq $installations.Count) {
    Write-Host "Todas as instalações principais foram concluídas com sucesso!" -ForegroundColor Green
} else {
    Write-Host "Algumas instalações podem precisar de atenção manual." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "INSTRUÇÕES IMPORTANTES:" -ForegroundColor Cyan
Write-Host "1. REINICIE o computador para que todas as configurações tenham efeito" -ForegroundColor Yellow
Write-Host "2. Após reiniciar, abra o Docker Desktop para inicializar o serviço" -ForegroundColor Yellow
Write-Host "3. Para VirtualBox: pode ser necessário habilitar virtualização na BIOS" -ForegroundColor Yellow
Write-Host "4. Para RabbitMQ: serviço inicia automaticamente, acesse http://localhost:15672" -ForegroundColor Yellow
Write-Host ""
Write-Host "Instalação concluída!" -ForegroundColor Green

# Manter janela aberta
Write-Host ""
pause
