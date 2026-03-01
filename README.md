# Generic Web Fingerprinting

Uma ferramenta em PowerShell desenvolvida para a extração genérica de cabeçalhos HTTP (Banner Grabbing) e auditoria de infraestruturas de TI. O script automatiza a coleta de metadados de servidores, auxiliando no mapeamento da superfície de ataque e na identificação de ativos na rede.

## 📌 Fundamentação Técnica

O **Banner Grabbing** (ou *OS/Service Fingerprinting*) é uma técnica passiva/ativa de engenharia de redes utilizada para coletar informações sobre um sistema computacional na rede e os serviços operando em suas portas abertas. 

Este script utiliza o cmdlet `Invoke-WebRequest` do PowerShell para enviar requisições HTTP(S) padronizadas à raiz de um serviço alvo. O diferencial técnico desta implementação reside na sua resiliência: através de um bloco `try/catch` estruturado, o script é capaz de capturar e exibir os cabeçalhos do servidor mesmo quando o alvo retorna códigos de erro de protocolo (como `401 Unauthorized` ou `403 Forbidden`). Muitas vezes, servidores mal configurados ou APIs restritas vazam arquiteturas de backend (ex: `Server`, `X-Powered-By`) nestas respostas de erro, o que é valioso para a análise de infraestrutura.

## ⚙️ Pré-requisitos do Sistema

- **Sistema Operacional:** Windows 10/11 ou Windows Server.
- **Interpretador:** PowerShell 5.1 ou superior (também compatível com PowerShell Core).
- **Permissões:** Privilégios adequados para execução de scripts. Caso a política de execução bloqueie o script, execute o seguinte comando em uma janela do PowerShell como Administrador para liberar a execução na sessão atual:

```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
```

## 🚀 Como Utilizar (Guia de Operação)

O script foi projetado para aceitar parâmetros via linha de comando, permitindo maior flexibilidade na auditoria de múltiplos alvos.

1. Faça o download ou clone este repositório.
2. Abra o **PowerShell** como Administrador.
3. Navegue até o diretório onde o script está localizado:

```powershell
cd C:\caminho\para\o\script
```

4. Configure a política de execução para a sessão atual (execute apenas uma vez):

```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
```

5. Quando solicitado, confirme digitando `A` (Sim para Todos) ou `S` (Sim).

6. Execute o script passando os parâmetros `-IPAddress` e `-Port` via linha de comando:

```powershell
.\Generic_Web_Fingerprinting.ps1 -IPAddress "ENDEREÇO IP DO HOST NO FORMATO 192.168.0.1" -Port "EXEMPLO: 8008"
```

**Exemplo de saída esperada:**

```powershell
name      model_name mac_address       build_version
----      ---------- -----------       -------------
Nest Mini            D4:F5:47:05:E5:16 510748
```

## 🔬 Estudo de Caso Prático: Descoberta de Dispositivos IoT (Google Nest Mini)

O script mostra grande utilidade em processos de auditoria de redes locais e identificação de *Shadow IT* ou dispositivos não documentados (IoT).

**Cenário de Análise:**
Durante uma varredura de rotina em uma rede local (WLAN) utilizando ferramentas de mapeamento e análise de pacotes (como WiFiman e Fing), foi identificado um host com o IP `192.168.0.114` sem hostname evidente.

**Procedimento Tático:**

1. **Port Scanning:** Uma varredura de portas no host revelou que a porta `8008` (frequentemente associada a serviços web alternativos ou APIs de configuração) estava com o status *listening*.
2. **Execução do Script:** O endereço IP `192.168.0.114` e a porta `8008` foram inseridos no script `Generic_Web_Fingerprinting.ps1` via Bloco de Notas.
3. **Análise de Metadados:** Ao executar o script, a extração dos cabeçalhos HTTP (*Banner Grabbing*) revelou assinaturas estruturais nos *headers* que permitiram identificar inequivocamente o dispositivo como um **Google Nest Mini**. Dispositivos do ecossistema Google Cast/Nest frequentemente expõem APIs HTTP na porta 8008 para comunicação interna da rede.

## ⚠️ Aviso Legal

Este script foi desenvolvido para fins de auditoria de segurança corporativa, administração de redes e engenharia de sistemas. Utilize-o de forma ética e somente em infraestruturas e dispositivos dos quais você possui autorização expressa para analisar.
