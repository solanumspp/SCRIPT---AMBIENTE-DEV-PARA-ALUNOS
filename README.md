# SCRIPT---AMBIENTE-DEV-PARA-ALUNOS
UM SCRIPT COM A INSTALAÇÃO DE AMBIENTE PRÉ-CONFIGURADO PARA OS ALUNOS DE SISTEMAS DISTRIBUÍDOS

INSTALAÇÃO CONFIGURAÇÃO E TESTAGEM VIA SCRIPT

APLICAÇÕES E/OU RECURSOS NECESSÁRIOS

Docker + Docker Compose 
VirtualBox
Postman ou Insomnia
Node.js ou Python
RabbitMQ ou Apache Kafka (opcional, ambos gratuitos)

COMO USAR O SCRIPT DE INSTALÇÃO

PASSO 1. Com o powershell no modo adm navegue até a pasta onde colocou o script.

PASSO 2. Execute: powershell -ExecutionPolicy Bypass -File "C:\Dowloads\instalar-dev-tools-fix.ps1"*lembre-se de alterar o caminho ou colocar o caminho na linha de comando

PASSO 3. Acompanhe a instalação para selecionar as opções de seu interesse, você terá de escolher entre quais implementações instalar.

PASSO 4. Reinicie o sistema.
*pode haver algum erro de instalação se o seu sistema não for 'limpo' e OBS. o kafka parece estar com o link quebrado e não tem funcionado bem

PASSO 5. Cheque o que foi instalado da seguinte forma:
1º reinicie o powershell ou execute:  refreshenv (em modo adm)
2º verifique as instalações:
# Docker 
docker --version 
# Node.js 
node --version 
npm --version 
# Python 
python --version 
# Git 
git --version 
# VirtualBox 
VBoxManage --version

OBS. SE QUISER O KAFKA DE QUALQUER FORMA
baixe direto: https://kafka.apache.org/downloads

Após reiniciar, abra o Docker DesktopAceite os termos de serviçoAguarde a inicialização completa
Já está configurado! Acesse:
 http://localhost:15672
 guest
 guest
Pode precisar habilitar virtualização na BIOS/UEFI
Verifique nas Configurações do Windows: "Recursos do Windows" → "Plataforma de Hiper-V"
http://localhost:15672 (guest/guest)
Requer reinício e aceite de termos
Reinicie o computador agora
Execute refreshenv no PowerShell após reiniciar
Teste cada ferramenta:

No powershell

# Teste básico
docker 
run hello-world 
node -e "console.log('Node.js funcionando!')" 
python -c "print('Python funcionando!')"

TESTE FINAL DE INSTALAÇÃO NO POWERSHELL

EXECUTE: 

Write-Host "=== VERIFICAÇÃO RÁPIDA ===" -ForegroundColor Cyan
Write-Host ""

# Atualizar PATH
Write-Host "Atualizando variáveis de ambiente..." -ForegroundColor Yellow
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Testes
Write-Host "1. Docker: " -ForegroundColor Yellow -NoNewline
docker --version 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) { Write-Host "✅ OK" -ForegroundColor Green } else { Write-Host "❌ FALHOU" -ForegroundColor Red }

Write-Host "2. Node.js: " -ForegroundColor Yellow -NoNewline
node --version 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) { Write-Host "✅ OK" -ForegroundColor Green } else { Write-Host "❌ FALHOU" -ForegroundColor Red }

Write-Host "3. Python: " -ForegroundColor Yellow -NoNewline
python --version 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) { Write-Host "✅ OK" -ForegroundColor Green } else { Write-Host "❌ FALHOU" -ForegroundColor Red }

Write-Host "4. Git: " -ForegroundColor Yellow -NoNewline
git --version 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) { Write-Host "✅ OK" -ForegroundColor Green } else { Write-Host "❌ FALHOU" -ForegroundColor Red }

Write-Host "5. VirtualBox: " -ForegroundColor Yellow -NoNewline
VBoxManage --version 2>&1 | Out-Null
if ($LASTEXITCODE -eq 0) { Write-Host "✅ OK" -ForegroundColor Green } else { Write-Host "❌ FALHOU" -ForegroundColor Red }

Write-Host ""
Write-Host "=== TESTES ADICIONAIS ===" -ForegroundColor Cyan

# Verificar se aplicativos existem
Write-Host "Postman instalado? " -ForegroundColor Yellow -NoNewline
if (Test-Path "C:\Users\*\AppData\Local\Postman\Postman.exe") { Write-Host "✅ SIM" -ForegroundColor Green } else { Write-Host "❌ NÃO" -ForegroundColor Red }

Write-Host "7-Zip instalado? " -ForegroundColor Yellow -NoNewline
if (Test-Path "C:\Program Files\7-Zip\7z.exe") { Write-Host "✅ SIM" -ForegroundColor Green } else { Write-Host "❌ NÃO" -ForegroundColor Red }

Write-Host ""
Write-Host "=== FIM DA VERIFICAÇÃO ===" -ForegroundColor Green

RESULTADO ESPERADO:


=== VERIFICAÇÃO RÁPIDA ===

Atualizando variáveis de ambiente...
1. Docker: ✅ OK
2. Node.js: ✅ OK
3. Python: ✅ OK
4. Git: ✅ OK
5. VirtualBox: ✅ OK

=== TESTES ADICIONAIS ===
Postman instalado? ✅ SIM
7-Zip instalado? ✅ SIM

=== FIM DA VERIFICAÇÃO ===
