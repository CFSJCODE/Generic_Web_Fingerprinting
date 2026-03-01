<#
.SYNOPSIS
    Coleta informações de diagnóstico e identificação de um dispositivo em rede via API REST.

.DESCRIPTION
    Este script realiza uma requisição HTTP GET para o endpoint /setup/eureka_info.
    Foi projetado para ser modular e flexível, permitindo a inserção dinâmica do endereço IP e da porta.
    Ideal para auditorias rápidas de infraestrutura de TI e levantamento de ativos (como hardwares IoT ou dispositivos de streaming).

.PARAMETER IPAddress
    Endereço IPv4 do dispositivo alvo na rede local ou roteada.

.PARAMETER Port
    Porta de comunicação do serviço REST do dispositivo. O valor padrão é definido como 8008.

.EXAMPLE
    .\Generic_Web_Fingerprinting.ps1 -IPAddress "192.168.0.114"

.EXAMPLE
    .\Generic_Web_Fingerprinting.ps1 -IPAddress "10.0.0.50" -Port 8080
#>

[CmdletBinding()]
param (
    [Parameter(Mandatory=$true, HelpMessage="Forneça o endereço IPv4 válido do dispositivo.")]
    [ValidatePattern('^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$')]
    [string]$IPAddress,

    [Parameter(Mandatory=$false, HelpMessage="Forneça a porta de comunicação do serviço.")]
    [ValidateRange(1, 65535)]
    [int]$Port = 8008
)

# Construção semântica da URI baseada nos parâmetros de entrada
$Uri = "http://${IPAddress}:${Port}/setup/eureka_info"

try {
    Write-Verbose "Iniciando requisição HTTP GET para o endpoint: $Uri"
    
    # Executa a chamada REST. A flag -ErrorAction Stop garante que falhas de rede sejam capturadas pelo bloco catch.
    $response = Invoke-RestMethod -Uri $Uri -Method Get -ErrorAction Stop
    
    # Filtra e projeta os atributos de interesse do payload JSON retornado
    $response | Select-Object name, model_name, mac_address, build_version
}
catch {
    # Tratamento formal de anomalias de conexão ou resolução de requisição
    Write-Error "Falha na comunicação com o ativo em $Uri. Detalhes técnicos da exceção: $($_.Exception.Message)"
}
