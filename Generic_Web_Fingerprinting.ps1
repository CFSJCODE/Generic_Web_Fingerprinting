# ==============================================================================
# Script: Generic_Web_Fingerprinting.ps1
# Função: Extração Genérica de Cabeçalhos HTTP (Banner Grabbing)
# ==============================================================================

# 1. Parâmetros de Conexão (Substitua IP e Porta conforme o alvo)
$IpAddress = "000.000.0.0"
$Port      = "8008"
$Protocol  = "https"          # Altere para "https" se a porta exigir (ex: 443, 8443)

# 2. Montagem da URI apontando para a raiz do serviço
$EndpointUri = "${Protocol}://${IpAddress}:${Port}/"

Write-Host "[*] Iniciando Banner Grabbing genérico em ${EndpointUri}..." -ForegroundColor Cyan

try {
    # 3. Execução da requisição genérica (DisableKeepAlive para evitar conexões presas)
    $response = Invoke-WebRequest -Uri $EndpointUri -Method Get -TimeoutSec 5 -UseBasicParsing -DisableKeepAlive

    Write-Host "[+] Resposta HTTP $($response.StatusCode) recebida.`n" -ForegroundColor Green
    Write-Host "=== Cabeçalhos do Servidor (Fingerprint) ===" -ForegroundColor Yellow

    # 4. Exibição dos cabeçalhos estruturados
    $response.Headers | Format-Table -AutoSize
}
catch {
    # Tratamento avançado: Extrair cabeçalhos mesmo se houver erro HTTP (ex: 401/403)
    if ($_.Exception.Response) {
        $statusCode = $_.Exception.Response.StatusCode.value__
        Write-Host "[!] Servidor respondeu com código de erro HTTP ${statusCode}.`n" -ForegroundColor DarkYellow
        Write-Host "=== Cabeçalhos do Servidor (Extraídos do Erro) ===" -ForegroundColor Yellow
        $_.Exception.Response.Headers | Format-Table -AutoSize
    } else {
        Write-Error "Falha na comunicação (Timeout, Porta Fechada ou Protocolo Incompatível). Detalhe: $($_.Exception.Message)"
    }

}
