<#
================================================================================
  GERENCIADOR DE IP E REDE WINDOWS
  Versão do Release: 1.0.0 (base funcional v2.0)
  Execução: Requer privilégios de Administrador
================================================================================
#>

# Força codificação UTF-8 no console para acentuação correta
. "$PSScriptRoot\Session-Header.ps1"
$script:IpUiCatalog = @(Get-Content -LiteralPath "$PSScriptRoot\Ip-UI-Catalog.json" -Raw -Encoding UTF8 | ConvertFrom-Json)

function Convert-IpUiText([string]$Text) {
    if ($script:AppLanguage -eq 'pt-BR' -or [string]::IsNullOrEmpty($Text)) { return $Text }
    foreach ($entry in ($script:IpUiCatalog | Sort-Object { $_.source.Length } -Descending)) {
        $translated = [string]$entry.($script:AppLanguage)
        if (-not [string]::IsNullOrWhiteSpace($translated) -and $Text.Contains([string]$entry.source)) {
            $Text = $Text.Replace([string]$entry.source, $translated)
        }
    }
    return $Text
}

# Localiza as mensagens de saída e entrada sem alterar comandos nem dados de rede.
function Write-Host {
    [CmdletBinding()]
    param(
        [Parameter(Position=0)] [object[]]$Object,
        [string]$Separator = ' ',
        [switch]$NoNewline,
        [ConsoleColor]$ForegroundColor,
        [ConsoleColor]$BackgroundColor
    )
    $translatedObjects = foreach ($item in $Object) {
        if ($item -is [string]) { Convert-IpUiText $item } else { $item }
    }
    $forward = @{}
    if ($PSBoundParameters.ContainsKey('Object')) { $forward.Object = @($translatedObjects) }
    if ($PSBoundParameters.ContainsKey('Separator')) { $forward.Separator = $Separator }
    if ($PSBoundParameters.ContainsKey('NoNewline')) { $forward.NoNewline = $true }
    if ($PSBoundParameters.ContainsKey('ForegroundColor')) { $forward.ForegroundColor = $ForegroundColor }
    if ($PSBoundParameters.ContainsKey('BackgroundColor')) { $forward.BackgroundColor = $BackgroundColor }
    Microsoft.PowerShell.Utility\Write-Host @forward
}

function Read-Host {
    [CmdletBinding()]
    param(
        [Parameter(Position=0)] [string]$Prompt,
        [switch]$AsSecureString
    )
    $forward = @{}
    if ($PSBoundParameters.ContainsKey('Prompt')) { $forward.Prompt = Convert-IpUiText $Prompt }
    if ($PSBoundParameters.ContainsKey('AsSecureString')) { $forward.AsSecureString = $true }
    Microsoft.PowerShell.Utility\Read-Host @forward
}

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$script:SessionStartedAt = Get-Date
$OutputEncoding = [System.Text.Encoding]::UTF8

# Força elevação de privilégios como Administrador
if (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host ""
    Write-Host "  [!] Solicitando permissão de Administrador..." -ForegroundColor Yellow
    try {
        Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    }
    catch {
        Write-Host "  [X] Falha ao elevar privilégios. Execute o PowerShell como Administrador." -ForegroundColor Red
        Pause
    }
    exit
}

$Host.UI.RawUI.WindowTitle = "Windows IP and Network Manager v1.0.0"

# Menus de entrada localizados; o fluxo numerado original é preservado.
$script:IpMenu = @{
 'pt-BR' = @('GERENCIADOR DE IP E REDE WINDOWS','Forçar novo IP (alterar MAC + DHCP automático)','Gera um MAC novo para o roteador atribuir outro IP','Renovar IP via DHCP','Libera e renova a concessão; limpa DNS/ARP','Configurar IPv4 manual/automático','A: IP estático | B: IP e DNS automáticos','Visualizar informações de rede e adaptadores','IPs, gateways, DNS, MAC e status','Gerenciador de endereço MAC','Gerar, informar manualmente ou restaurar MAC','Teste de conectividade e diagnóstico','Testa gateway, Internet e resolução DNS','Reparo completo da pilha de rede','Limpa DNS/ARP e redefine Winsock/TCP/IP','Sair','Escolha uma opção','Opção inválida. Escolha uma opção do menu.','CONFIGURAR IPv4','Digitar IP estático definitivo','Ativar DHCP (IP e DNS automáticos)','Voltar ao menu principal','Escolha')
 en = @('WINDOWS IP AND NETWORK MANAGER','Force a new IP (change MAC + automatic DHCP)','Creates a new MAC so the router can assign another IP','Renew IP through DHCP','Releases and renews the lease; clears DNS/ARP','Configure IPv4 manually/automatically','A: static IP | B: automatic IP and DNS','View network and adapter information','IPs, gateways, DNS, MAC, and status','MAC address manager','Generate, enter, or restore a MAC address','Connectivity test and diagnostics','Tests gateway, Internet, and DNS resolution','Full network stack repair','Clears DNS/ARP and resets Winsock/TCP/IP','Exit','Choose an option','Invalid option. Choose an item from the menu.','CONFIGURE IPv4','Enter a permanent static IP','Enable DHCP (automatic IP and DNS)','Return to main menu','Choose')
 es = @('ADMINISTRADOR DE IP Y RED DE WINDOWS','Forzar una nueva IP (cambiar MAC + DHCP automático)','Crea una MAC nueva para que el router asigne otra IP','Renovar IP mediante DHCP','Libera y renueva la concesión; limpia DNS/ARP','Configurar IPv4 manual/automáticamente','A: IP estática | B: IP y DNS automáticos','Ver información de red y adaptadores','IPs, puertas de enlace, DNS, MAC y estado','Administrador de direcciones MAC','Generar, introducir o restaurar una MAC','Prueba de conectividad y diagnóstico','Prueba la puerta de enlace, Internet y DNS','Reparación completa de la red','Limpia DNS/ARP y restablece Winsock/TCP/IP','Salir','Elija una opción','Opción no válida. Elija una opción del menú.','CONFIGURAR IPv4','Introducir una IP estática permanente','Activar DHCP (IP y DNS automáticos)','Volver al menú principal','Elegir')
 fr = @('GESTIONNAIRE IP ET RÉSEAU WINDOWS','Forcer une nouvelle IP (changer MAC + DHCP automatique)','Crée une MAC pour que le routeur attribue une autre IP','Renouveler lʼIP via DHCP','Libère et renouvelle le bail ; vide DNS/ARP','Configurer IPv4 manuellement/automatiquement','A : IP fixe | B : IP et DNS automatiques','Afficher les informations réseau et adaptateurs','IPs, passerelles, DNS, MAC et état','Gestionnaire dʼadresse MAC','Générer, saisir ou restaurer une adresse MAC','Test de connectivité et diagnostic','Teste la passerelle, Internet et le DNS','Réparation complète de la pile réseau','Vide DNS/ARP et réinitialise Winsock/TCP/IP','Quitter','Choisissez une option','Option invalide. Choisissez une option du menu.','CONFIGURER IPv4','Saisir une IP fixe permanente','Activer DHCP (IP et DNS automatiques)','Retour au menu principal','Choisir')
 de = @('WINDOWS-IP- UND NETZWERKVERWALTUNG','Neue IP erzwingen (MAC ändern + automatisches DHCP)','Erstellt eine MAC, damit der Router eine neue IP vergibt','IP über DHCP erneuern','Gibt die Lease frei und erneuert sie; leert DNS/ARP','IPv4 manuell/automatisch konfigurieren','A: feste IP | B: automatische IP und DNS','Netzwerk- und Adapterinformationen anzeigen','IPs, Gateways, DNS, MAC und Status','MAC-Adressverwaltung','MAC-Adresse erzeugen, eingeben oder wiederherstellen','Verbindungstest und Diagnose','Prüft Gateway, Internet und DNS-Auflösung','Vollständige Reparatur des Netzwerkstapels','Leert DNS/ARP und setzt Winsock/TCP/IP zurück','Beenden','Option auswählen','Ungültige Option. Menüoption auswählen.','IPv4 KONFIGURIEREN','Feste IP dauerhaft eingeben','DHCP aktivieren (automatische IP und DNS)','Zum Hauptmenü zurückkehren','Auswählen')
 it = @('GESTIONE IP E RETE WINDOWS','Forza un nuovo IP (cambia MAC + DHCP automatico)','Crea una nuova MAC per ottenere un altro IP dal router','Rinnova IP tramite DHCP','Rilascia e rinnova il lease; svuota DNS/ARP','Configura IPv4 manualmente/automaticamente','A: IP statico | B: IP e DNS automatici','Visualizza informazioni di rete e adattatori','IP, gateway, DNS, MAC e stato','Gestione indirizzo MAC','Genera, inserisci o ripristina un indirizzo MAC','Test di connettività e diagnosi','Verifica gateway, Internet e risoluzione DNS','Riparazione completa dello stack di rete','Svuota DNS/ARP e reimposta Winsock/TCP/IP','Esci','Scegli unʼopzione','Opzione non valida. Scegli una voce del menu.','CONFIGURA IPv4','Inserisci un IP statico permanente','Attiva DHCP (IP e DNS automatici)','Torna al menu principale','Scegli')
 ja = @('Windows IP とネットワーク管理','新しい IP を強制 (MAC 変更 + DHCP)','ルーターから別の IP を取得するため MAC を変更します','DHCP で IP を更新','リースを更新し DNS/ARP を消去します','IPv4 を手動/自動で設定','A: 固定 IP | B: IP と DNS を自動取得','ネットワークとアダプター情報を表示','IP、ゲートウェイ、DNS、MAC、状態','MAC アドレス管理','MAC の生成、入力、復元','接続テストと診断','ゲートウェイ、インターネット、DNS を確認','ネットワークスタックを修復','DNS/ARP を消去し Winsock/TCP/IP をリセット','終了','項目を選択','無効な項目です。メニューから選択してください。','IPv4 の設定','固定 IP を入力','DHCP を有効化 (IP と DNS を自動取得)','メインメニューに戻る','選択')
 ko = @('Windows IP 및 네트워크 관리자','새 IP 강제 (MAC 변경 + DHCP)','라우터에서 새 IP를 받도록 MAC 주소를 변경합니다','DHCP로 IP 갱신','임대를 갱신하고 DNS/ARP를 지웁니다','IPv4 수동/자동 구성','A: 고정 IP | B: IP 및 DNS 자동','네트워크 및 어댑터 정보 보기','IP, 게이트웨이, DNS, MAC 및 상태','MAC 주소 관리자','MAC 주소 생성, 입력 또는 복원','연결 테스트 및 진단','게이트웨이, 인터넷, DNS 확인','전체 네트워크 스택 복구','DNS/ARP 삭제 및 Winsock/TCP/IP 재설정','종료','옵션 선택','잘못된 옵션입니다. 메뉴에서 선택하세요.','IPv4 구성','고정 IP 입력','DHCP 사용 (IP 및 DNS 자동)','주 메뉴로 돌아가기','선택')
 'zh-CN' = @('Windows IP 与网络管理器','强制获取新 IP（更改 MAC + 自动 DHCP）','更改 MAC，让路由器分配另一个 IP','通过 DHCP 续订 IP','释放并续订租约；清除 DNS/ARP','手动/自动配置 IPv4','A：静态 IP | B：自动获取 IP 和 DNS','查看网络和适配器信息','IP、网关、DNS、MAC 和状态','MAC 地址管理器','生成、输入或还原 MAC 地址','连接测试与诊断','测试网关、互联网和 DNS 解析','完整修复网络协议栈','清除 DNS/ARP 并重置 Winsock/TCP/IP','退出','请选择一个选项','选项无效，请从菜单中选择。','配置 IPv4','输入固定静态 IP','启用 DHCP（自动获取 IP 和 DNS）','返回主菜单','选择')
 ru = @('УПРАВЛЕНИЕ IP И СЕТЬЮ WINDOWS','Получить новый IP (сменить MAC + DHCP)','Сменяет MAC, чтобы роутер выдал другой IP','Обновить IP через DHCP','Освобождает и обновляет аренду; очищает DNS/ARP','Настроить IPv4 вручную/автоматически','A: статический IP | B: автоматические IP и DNS','Показать сведения о сети и адаптерах','IP, шлюзы, DNS, MAC и состояние','Управление MAC-адресом','Создать, ввести или восстановить MAC','Проверка подключения и диагностика','Проверяет шлюз, Интернет и DNS','Полное восстановление сетевого стека','Очищает DNS/ARP и сбрасывает Winsock/TCP/IP','Выход','Выберите пункт','Недопустимый пункт. Выберите пункт меню.','НАСТРОЙКА IPv4','Ввести постоянный статический IP','Включить DHCP (автоматические IP и DNS)','Вернуться в главное меню','Выбрать')
}
$script:IpMenuText = $script:IpMenu[$script:AppLanguage]
$script:IpPrompt = @{
 'pt-BR' = @('Escolha o número do adaptador','Opção inválida. Digite um número de 1 a {0}.','Digite o endereço IP [{0}]','Digite o endereço IP (ex.: 192.168.1.100)','IP inválido. Tente novamente.','Máscara de sub-rede ou prefixo CIDR [255.255.255.0 ou 24]','Máscara/prefixo inválido.','Digite o gateway padrão [{0}]','Digite o gateway padrão (ou deixe vazio)','Gateway inválido. Digite um IP válido ou deixe vazio.','Servidores DNS separados por vírgula [1.1.1.1, 8.8.8.8]','DNS inválido. Informe endereços IPv4 válidos separados por vírgula.','Deseja aplicar estas configurações permanentemente?','Deseja remover o IP estático e ativar DHCP automático?','Confirmar alteração e reiniciar o adaptador?','Deseja executar o reparo completo da rede agora?','Pressione Enter para voltar ao menu anterior.','Nenhum adaptador de rede ativo foi encontrado.')
 en = @('Choose the adapter number','Invalid choice. Enter a number from 1 to {0}.','Enter the IP address [{0}]','Enter the IP address (e.g. 192.168.1.100)','Invalid IP address. Try again.','Subnet mask or CIDR prefix [255.255.255.0 or 24]','Invalid mask/prefix.','Enter the default gateway [{0}]','Enter the default gateway (or leave blank)','Invalid gateway. Enter a valid IP or leave blank.','DNS servers separated by commas [1.1.1.1, 8.8.8.8]','Invalid DNS. Enter valid IPv4 addresses separated by commas.','Apply these settings permanently?','Remove the static IP and enable automatic DHCP?','Confirm the change and restart the adapter?','Run the full network repair now?','Press Enter to return to the previous menu.','No active network adapter was found.')
 es = @('Elija el número del adaptador','Opción no válida. Introduzca un número del 1 al {0}.','Introduzca la dirección IP [{0}]','Introduzca la dirección IP (ej.: 192.168.1.100)','Dirección IP no válida. Inténtelo de nuevo.','Máscara de subred o prefijo CIDR [255.255.255.0 o 24]','Máscara/prefijo no válido.','Introduzca la puerta de enlace [{0}]','Introduzca la puerta de enlace (o déjela vacía)','Puerta de enlace no válida. Introduzca una IP válida o déjela vacía.','Servidores DNS separados por comas [1.1.1.1, 8.8.8.8]','DNS no válido. Introduzca direcciones IPv4 válidas separadas por comas.','¿Aplicar esta configuración permanentemente?','¿Quitar la IP estática y activar DHCP automático?','¿Confirmar el cambio y reiniciar el adaptador?','¿Ejecutar ahora la reparación completa de red?','Pulse Enter para volver al menú anterior.','No se encontraron adaptadores de red activos.')
 fr = @('Choisissez le numéro de lʼadaptateur','Option invalide. Saisissez un nombre de 1 à {0}.','Saisissez lʼadresse IP [{0}]','Saisissez lʼadresse IP (ex. : 192.168.1.100)','Adresse IP invalide. Réessayez.','Masque de sous-réseau ou préfixe CIDR [255.255.255.0 ou 24]','Masque/préfixe invalide.','Saisissez la passerelle par défaut [{0}]','Saisissez la passerelle (ou laissez vide)','Passerelle invalide. Saisissez une IP valide ou laissez vide.','Serveurs DNS séparés par des virgules [1.1.1.1, 8.8.8.8]','DNS invalide. Saisissez des adresses IPv4 valides séparées par des virgules.','Appliquer définitivement ces paramètres ?','Supprimer lʼIP fixe et activer DHCP automatique ?','Confirmer la modification et redémarrer lʼadaptateur ?','Lancer la réparation complète du réseau maintenant ?','Appuyez sur Entrée pour revenir au menu précédent.','Aucun adaptateur réseau actif trouvé.')
 de = @('Adapter-Nummer auswählen','Ungültige Auswahl. Zahl von 1 bis {0} eingeben.','IP-Adresse eingeben [{0}]','IP-Adresse eingeben (z. B. 192.168.1.100)','Ungültige IP-Adresse. Erneut versuchen.','Subnetzmaske oder CIDR-Präfix [255.255.255.0 oder 24]','Ungültige Maske/Präfix.','Standardgateway eingeben [{0}]','Standardgateway eingeben (oder leer lassen)','Ungültiges Gateway. Gültige IP eingeben oder leer lassen.','DNS-Server durch Kommas getrennt [1.1.1.1, 8.8.8.8]','Ungültiges DNS. Gültige IPv4-Adressen durch Kommas getrennt eingeben.','Diese Einstellungen dauerhaft anwenden?','Statische IP entfernen und automatisches DHCP aktivieren?','Änderung bestätigen und Adapter neu starten?','Vollständige Netzwerkreparatur jetzt ausführen?','Eingabetaste drücken, um zum vorherigen Menü zurückzukehren.','Kein aktiver Netzwerkadapter gefunden.')
 it = @('Scegli il numero dellʼadattatore','Scelta non valida. Inserisci un numero da 1 a {0}.','Inserisci lʼindirizzo IP [{0}]','Inserisci lʼindirizzo IP (es.: 192.168.1.100)','Indirizzo IP non valido. Riprova.','Maschera di sottorete o prefisso CIDR [255.255.255.0 o 24]','Maschera/prefisso non valido.','Inserisci il gateway predefinito [{0}]','Inserisci il gateway (oppure lascia vuoto)','Gateway non valido. Inserisci un IP valido o lascia vuoto.','Server DNS separati da virgole [1.1.1.1, 8.8.8.8]','DNS non valido. Inserisci indirizzi IPv4 validi separati da virgole.','Applicare queste impostazioni in modo permanente?','Rimuovere lʼIP statico e attivare DHCP automatico?','Confermare la modifica e riavviare lʼadattatore?','Eseguire ora la riparazione completa della rete?','Premi Invio per tornare al menu precedente.','Nessun adattatore di rete attivo trovato.')
 ja = @('アダプター番号を選択','選択が無効です。1 から {0} の番号を入力してください。','IP アドレスを入力 [{0}]','IP アドレスを入力 (例: 192.168.1.100)','IP アドレスが無効です。再入力してください。','サブネット マスクまたは CIDR プレフィックス [255.255.255.0 または 24]','マスク/プレフィックスが無効です。','デフォルト ゲートウェイを入力 [{0}]','デフォルト ゲートウェイを入力 (空欄可)','ゲートウェイが無効です。有効な IP を入力するか空欄にしてください。','カンマ区切りの DNS サーバー [1.1.1.1, 8.8.8.8]','DNS が無効です。有効な IPv4 アドレスをカンマ区切りで入力してください。','設定を恒久的に適用しますか？','固定 IP を削除して DHCP を有効にしますか？','変更を確定してアダプターを再起動しますか？','ネットワークを完全に修復しますか？','Enter キーを押して前のメニューに戻ります。','アクティブなネットワーク アダプターが見つかりません。')
 ko = @('어댑터 번호 선택','잘못된 선택입니다. 1에서 {0} 사이의 번호를 입력하세요.','IP 주소 입력 [{0}]','IP 주소 입력 (예: 192.168.1.100)','잘못된 IP 주소입니다. 다시 입력하세요.','서브넷 마스크 또는 CIDR 접두사 [255.255.255.0 또는 24]','잘못된 마스크/접두사입니다.','기본 게이트웨이 입력 [{0}]','기본 게이트웨이 입력 (비워 둘 수 있음)','잘못된 게이트웨이입니다. 올바른 IP를 입력하거나 비워 두세요.','쉼표로 구분된 DNS 서버 [1.1.1.1, 8.8.8.8]','잘못된 DNS입니다. 쉼표로 구분된 올바른 IPv4 주소를 입력하세요.','이 설정을 영구적으로 적용할까요?','고정 IP를 제거하고 자동 DHCP를 사용하도록 설정할까요?','변경을 확인하고 어댑터를 다시 시작할까요?','지금 전체 네트워크 복구를 실행할까요?','Enter 키를 눌러 이전 메뉴로 돌아가세요.','활성 네트워크 어댑터를 찾을 수 없습니다.')
 'zh-CN' = @('选择适配器编号','选项无效，请输入 1 到 {0} 之间的数字。','输入 IP 地址 [{0}]','输入 IP 地址（例如：192.168.1.100）','IP 地址无效，请重试。','子网掩码或 CIDR 前缀 [255.255.255.0 或 24]','掩码/前缀无效。','输入默认网关 [{0}]','输入默认网关（可留空）','网关无效。请输入有效 IP 或留空。','以逗号分隔的 DNS 服务器 [1.1.1.1, 8.8.8.8]','DNS 无效，请输入以逗号分隔的有效 IPv4 地址。','要永久应用这些设置吗？','要删除静态 IP 并启用自动 DHCP 吗？','确认更改并重新启动适配器吗？','现在执行完整网络修复吗？','按 Enter 返回上一级菜单。','未找到活动网络适配器。')
 ru = @('Выберите номер адаптера','Неверный выбор. Введите число от 1 до {0}.','Введите IP-адрес [{0}]','Введите IP-адрес (например, 192.168.1.100)','Неверный IP-адрес. Повторите попытку.','Маска подсети или префикс CIDR [255.255.255.0 или 24]','Неверная маска/префикс.','Введите основной шлюз [{0}]','Введите основной шлюз (или оставьте поле пустым)','Неверный шлюз. Введите правильный IP или оставьте поле пустым.','DNS-серверы через запятую [1.1.1.1, 8.8.8.8]','Неверный DNS. Введите корректные IPv4-адреса через запятую.','Применить настройки постоянно?','Удалить статический IP и включить автоматический DHCP?','Подтвердить изменение и перезапустить адаптер?','Выполнить полное восстановление сети сейчас?','Нажмите Enter, чтобы вернуться в предыдущее меню.','Активные сетевые адаптеры не найдены.')
}
$script:IpPromptText = $script:IpPrompt[$script:AppLanguage]
$script:IpYesToken = switch ($script:AppLanguage) { en {'Y'} de {'J'} fr {'O'} ja {'Y'} ko {'Y'} 'zh-CN' {'Y'} ru {'Д'} default {'S'} }
$script:IpNoToken = if ($script:AppLanguage -eq 'ru') { 'Н' } else { 'N' }

# Impede que o script feche se o usuário pressionar Ctrl+C (ex: para copiar texto)
try {
    [Console]::TreatControlCAsInput = $true
} catch { }

try {
    [Console]::add_CancelKeyPress([System.ConsoleCancelEventHandler]{
        param($s, $e)
        $e.Cancel = $true
    })
} catch { }

# ==============================================================================
# FUNÇÕES AUXILIARES E UTILITÁRIOS DE REDE
# ==============================================================================

function Write-Header {
    param([string]$Title)
    Clear-Host
    Write-Host $Title.ToUpper() -ForegroundColor Cyan
    Write-Host "================================================================" -ForegroundColor DarkCyan
}

function Pause-Menu {
    param([string]$Message = $script:IpPromptText[16])
    Write-Host ""
    Write-Host "  $Message" -ForegroundColor DarkGray
    
    try {
        [Console]::TreatControlCAsInput = $true
    } catch { }

    while ($true) {
        try {
            $key = [System.Console]::ReadKey($true)
            if ($key.Key -eq [System.ConsoleKey]::Enter) {
                break
            }
        }
        catch {
            Start-Sleep -Milliseconds 100
        }
    }
}

function Test-IsValidIPv4([string]$ip) {
    if ([string]::IsNullOrWhiteSpace($ip)) { return $false }
    $ip = $ip.Trim()
    $pattern = '^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'
    if ($ip -notmatch $pattern) { return $false }
    
    # Valida se não é endereço de loopback ou multicast como IP de host
    $octets = $ip.Split('.')
    if ([int]$octets[0] -eq 0 -or [int]$octets[0] -ge 224) { return $false }
    return $true
}

function Convert-SubnetMaskToPrefix([string]$mask) {
    $mask = $mask.Trim()
    if ($mask.StartsWith("/")) { $mask = $mask.Substring(1) }
    
    # Se já for um número de prefixo CIDR (1 a 32)
    if ($mask -match '^\d+$' -and [int]$mask -ge 1 -and [int]$mask -le 32) {
        return [int]$mask
    }

    # Conversão de máscara decimal pontuada para prefixo CIDR
    try {
        $ip = [System.Net.IPAddress]::Parse($mask)
        $bytes = $ip.GetAddressBytes()
        $binaryStr = ($bytes | ForEach-Object { [Convert]::ToString($_, 2).PadLeft(8, '0') }) -join ''
        
        # Validação: uma máscara válida tem sequência de 1s seguidos apenas por 0s
        if ($binaryStr -match '^1*0*$') {
            return ($binaryStr -replace '0', '').Length
        }
    }
    catch { }

    return 0 # Sinaliza entrada inválida para que o menu solicite novamente.
}

function Convert-PrefixToSubnetMask([int]$prefix) {
    if ($prefix -lt 1 -or $prefix -gt 32) { $prefix = 24 }
    $binaryStr = ('1' * $prefix).PadRight(32, '0')
    $octets = @()
    for ($i = 0; $i -lt 32; $i += 8) {
        $octets += [Convert]::ToByte($binaryStr.Substring($i, 8), 2)
    }
    return ($octets -join '.')
}

function Get-AdapterChoice {
    param([bool]$IncludeDisconnected = $false)
    
    $rawAdapters = if ($IncludeDisconnected) { 
        Get-NetAdapter -ErrorAction SilentlyContinue | Sort-Object Name
    } else { 
        Get-NetAdapter -ErrorAction SilentlyContinue | Where-Object { $_.Status -eq 'Up' } | Sort-Object Name
    }
    
    [System.Collections.Generic.List[PSObject]]$adapters = [System.Collections.Generic.List[PSObject]]::new()
    if ($rawAdapters) {
        foreach ($item in $rawAdapters) {
            $adapters.Add($item)
        }
    }
    
    if ($adapters.Count -eq 0) {
        Write-Host ("  [!] " + $script:IpPromptText[17]) -ForegroundColor Red
        return $null
    }
    
    # Se houver apenas 1 adaptador, seleciona automaticamente sem pedir escolha
    if ($adapters.Count -eq 1) {
        $single = $adapters[0]
        Write-Host "  Adaptador detectado : $($single.Name)" -ForegroundColor Yellow
        Write-Host "  Descrição           : $($single.InterfaceDescription)" -ForegroundColor DarkGray
        Write-Host ""
        return $single
    }

    Write-Host "  Adaptadores de rede disponíveis:" -ForegroundColor Yellow
    Write-Host ""
    
    for ($i = 0; $i -lt $adapters.Count; $i++) {
        $a = $adapters[$i]
        $cfg = Get-NetIPConfiguration -InterfaceAlias $a.Name -ErrorAction SilentlyContinue
        $ip  = if ($cfg.IPv4Address) { ($cfg.IPv4Address | Select-Object -First 1).IPAddress } else { "sem IP" }
        $statusColor = if ($a.Status -eq 'Up') { "Green" } else { "DarkGray" }
        $dhcp = (Get-NetIPInterface -InterfaceAlias $a.Name -AddressFamily IPv4 -ErrorAction SilentlyContinue).Dhcp
        $dhcpTag = if ($dhcp -eq 'Enabled') { "[DHCP]" } elseif ($dhcp -eq 'Disabled') { "[ESTÁTICO]" } else { "" }

        Write-Host ("  [{0}] {1,-24} {2,-16} {3,-10}" -f ($i + 1), $a.Name, $ip, $dhcpTag) -ForegroundColor Cyan
        Write-Host ("      Desc: {0} ({1})" -f $a.InterfaceDescription, $a.Status) -ForegroundColor $statusColor
    }
    Write-Host ""
    Write-Host "  [0] Voltar ao menu anterior" -ForegroundColor DarkGray
    Write-Host ""

    do {
        $choice = Read-Host ("  " + $script:IpPromptText[0])
        if ($choice -eq "0") { return $null }
        $choiceInt = 0
        if ([int]::TryParse($choice, [ref]$choiceInt)) {
            if ($choiceInt -ge 1 -and $choiceInt -le $adapters.Count) {
                return $adapters[$choiceInt - 1]
            }
        }
        Write-Host ("  " + ($script:IpPromptText[1] -f $adapters.Count)) -ForegroundColor Red
    } while ($true)
}

function Wait-ForAdapterReady {
    param([string]$InterfaceAlias, [int]$TimeoutSeconds = 20)
    Write-Host -NoNewline "  Aguardando conexão e autenticação com a rede..." -ForegroundColor DarkGray
    $elapsed = 0
    while ($elapsed -lt $TimeoutSeconds) {
        Start-Sleep -Seconds 1
        $elapsed++
        Write-Host -NoNewline "." -ForegroundColor DarkGray
        
        $adapterObj = Get-NetAdapter -Name $InterfaceAlias -ErrorAction SilentlyContinue
        if (-not $adapterObj -or $adapterObj.Status -ne 'Up') {
            continue
        }
        
        # Verifica se obteve perfil de conexão ou se Wi-Fi conectou
        $connProfile = Get-NetConnectionProfile -InterfaceAlias $InterfaceAlias -ErrorAction SilentlyContinue
        $wlanState = (netsh wlan show interfaces 2>&1 | Select-String "State\s*:\s*connected|Estado\s*:\s*conectado")
        
        if ($connProfile -or $wlanState) {
            Write-Host " [Conectado]" -ForegroundColor Green
            Start-Sleep -Seconds 1
            return $true
        }
    }
    Write-Host " [Pronto]" -ForegroundColor Green
    return $true
}

function Test-NetworkConnectivity {
    param(
        [string]$Gateway = $null,
        [string]$Dns = "1.1.1.1",
        [string]$Domain = "google.com"
    )
    Write-Host ""
    Write-Host "  --- Diagnóstico de Conectividade ---" -ForegroundColor DarkCyan
    
    # 1. Teste de Gateway local
    if (-not [string]::IsNullOrWhiteSpace($Gateway)) {
        Write-Host -NoNewline "  - Gateway local ($Gateway): " -ForegroundColor White
        $gwPing = Test-Connection -ComputerName $Gateway -Count 1 -Quiet -ErrorAction SilentlyContinue
        if ($gwPing) {
            Write-Host "OK (Alcançável)" -ForegroundColor Green
        } else {
            Write-Host "FALHA (Sem resposta ao ping)" -ForegroundColor Yellow
        }
    }

    # 2. Teste de Ping na Internet / DNS IP
    Write-Host -NoNewline "  - Conexão Internet IP ($Dns): " -ForegroundColor White
    $dnsPing = Test-Connection -ComputerName $Dns -Count 1 -Quiet -ErrorAction SilentlyContinue
    if ($dnsPing) {
        Write-Host "OK (Online)" -ForegroundColor Green
    } else {
        Write-Host "FALHA (Sem conexão externa)" -ForegroundColor Red
    }

    # 3. Teste de Resolução de Nomes DNS
    Write-Host -NoNewline "  - Resolução DNS ($Domain): " -ForegroundColor White
    try {
        $dnsResolve = [System.Net.Dns]::GetHostAddresses($Domain)
        if ($dnsResolve) {
            Write-Host "OK ($($dnsResolve[0].IPAddressToString))" -ForegroundColor Green
        } else {
            Write-Host "FALHA" -ForegroundColor Red
        }
    }
    catch {
        Write-Host "FALHA (Não foi possível resolver nomes)" -ForegroundColor Red
    }
}

# ==============================================================================
# [1] FORÇAR NOVO IP (ALTERAR MAC + DHCP AUTOMÁTICO)
# ==============================================================================
function Invoke-ForceNewIP {
    Write-Header "Forçar Novo IP (Alterar MAC + DHCP)"

    $adapter = Get-AdapterChoice
    if (-not $adapter) { return }

    $alias  = $adapter.Name
    $desc   = $adapter.InterfaceDescription
    $oldMac = $adapter.MacAddress
    $config = Get-NetIPConfiguration -InterfaceAlias $alias -ErrorAction SilentlyContinue
    $oldIP  = if ($config.IPv4Address) { ($config.IPv4Address | Select-Object -First 1).IPAddress } else { "desconhecido" }

    Write-Host "  Adaptador : $alias" -ForegroundColor Yellow
    Write-Host "  IP Atual  : $oldIP" -ForegroundColor Green
    Write-Host "  MAC Atual : $oldMac" -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "  [i] Alterando o MAC Address para fazer o roteador atribuir" -ForegroundColor Cyan
    Write-Host "      um NOVO endereço IP automaticamente via DHCP..." -ForegroundColor Cyan
    Write-Host ""

    $regPath = Get-AdapterRegistryPath -Adapter $adapter
    if (-not $regPath) {
        Write-Host "  [X] Não foi possível localizar a chave de registro do adaptador." -ForegroundColor Red
        Pause-Menu
        return
    }

    try {
        # 1. Gerar novo MAC aleatório válido (Unicast + Locally Administered)
        $validPrefixes = @("02", "06", "0A", "0E")
        $prefix = $validPrefixes[(Get-Random -Maximum $validPrefixes.Count)]
        $hexChars = "0123456789ABCDEF"
        $rest = ""
        for ($i = 0; $i -lt 10; $i++) {
            $rest += $hexChars[(Get-Random -Maximum 16)]
        }
        $newMac = "$prefix$rest"

        Write-Host "  [1/5] Gerando novo MAC Address ($newMac)..." -ForegroundColor Cyan
        Set-ItemProperty -Path $regPath -Name "NetworkAddress" -Value $newMac -ErrorAction Stop

        Write-Host "  [2/5] Reiniciando interface de rede..." -ForegroundColor Cyan
        Restart-NetAdapter -Name $alias -Confirm:$false -ErrorAction Stop
        
        $isReady = Wait-ForAdapterReady -InterfaceAlias $alias -TimeoutSeconds 20

        Write-Host "  [3/5] Solicitando novo IP ao roteador via DHCP (Renew)..." -ForegroundColor Cyan
        & ipconfig /renew "$alias" *>$null

        # Espera ativa e inteligente pela resposta do servidor DHCP
        Write-Host -NoNewline "  [4/5] Aguardando atribuicao do novo IP pelo roteador..." -ForegroundColor Cyan
        $newIP = $null
        $updatedConfig = $null
        for ($attempt = 0; $attempt -lt 10; $attempt++) {
            Start-Sleep -Seconds 1
            Write-Host -NoNewline "." -ForegroundColor DarkGray
            $updatedConfig = Get-NetIPConfiguration -InterfaceAlias $alias -ErrorAction SilentlyContinue
            if ($updatedConfig -and $updatedConfig.IPv4Address) {
                $candidate = ($updatedConfig.IPv4Address | Select-Object -First 1).IPAddress
                if ($candidate -and $candidate -notlike "169.254*") {
                    $newIP = $candidate
                    break
                }
            }
            if ($attempt -eq 4 -and -not $newIP) {
                & ipconfig /renew "$alias" *>$null
            }
        }
        Write-Host " [OK]" -ForegroundColor Green

        Write-Host "  [5/5] Limpando caches ARP e DNS..." -ForegroundColor Cyan
        Clear-DnsClientCache -ErrorAction SilentlyContinue
        & arp -d * *>$null

        $updatedAdapter = Get-NetAdapter -Name $alias -ErrorAction SilentlyContinue
        $newGW = if ($updatedConfig.IPv4DefaultGateway) { $updatedConfig.IPv4DefaultGateway.NextHop } else { $null }

        Write-Host ""
        if ($newIP -and $newIP -ne $oldIP) {
            Write-Host "  [V] NOVO IP ATRIBUÍDO COM SUCESSO PELO ROTEADOR!" -ForegroundColor Green
            Write-Host "      IP Anterior : $oldIP" -ForegroundColor DarkGray
            Write-Host "      Novo IP     : $newIP" -ForegroundColor Green
            Write-Host "      MAC Anterior: $oldMac" -ForegroundColor DarkGray
            Write-Host "      Novo MAC    : $($updatedAdapter.MacAddress)" -ForegroundColor Green
        }
        elseif ($newIP) {
            Write-Host "  [!] O IP atribuído foi: $newIP" -ForegroundColor Yellow
            Write-Host "      MAC Atual : $($updatedAdapter.MacAddress)" -ForegroundColor Cyan
        }
        else {
            Write-Host "  [X] Não foi possível obter IP automaticamente. Verifique a conexão." -ForegroundColor Red
        }

        if ($newIP) {
            Test-NetworkConnectivity -Gateway $newGW
        }
        
        Write-Host ""
        Write-Host "  Dica: Se quiser voltar ao MAC de fábrica a qualquer momento," -ForegroundColor DarkGray
        Write-Host "  use a opção [5] -> [3] no menu principal." -ForegroundColor DarkGray
    }
    catch {
        Write-Host "  [X] Erro ao forçar novo IP: $_" -ForegroundColor Red
    }

    Pause-Menu
}

# ==============================================================================
# [2] RENOVAR IP VIA DHCP (PADRÃO)
# ==============================================================================
function Invoke-RenewIP {
    Write-Header "Renovar IP via DHCP (Padrão)"

    $adapter = Get-AdapterChoice
    if (-not $adapter) { return }

    $alias = $adapter.Name
    $config = Get-NetIPConfiguration -InterfaceAlias $alias -ErrorAction SilentlyContinue
    $oldIP = if ($config.IPv4Address) { ($config.IPv4Address | Select-Object -First 1).IPAddress } else { "desconhecido" }

    Write-Host "  Adaptador : $alias" -ForegroundColor Yellow
    Write-Host "  IP Atual  : $oldIP" -ForegroundColor Green
    Write-Host ""

    try {
        Write-Host "  [1/5] Liberando concessão DHCP atual (Release)..." -ForegroundColor Cyan
        & ipconfig /release "$alias" *>$null
        Start-Sleep -Seconds 1

        Write-Host "  [2/5] Reiniciando interface de rede..." -ForegroundColor Cyan
        Restart-NetAdapter -Name $alias -Confirm:$false -ErrorAction Stop
        
        $isReady = Wait-ForAdapterReady -InterfaceAlias $alias -TimeoutSeconds 10

        Write-Host "  [3/5] Solicitando nova concessão DHCP (Renew)..." -ForegroundColor Cyan
        & ipconfig /renew "$alias" *>$null
        Start-Sleep -Seconds 2

        Write-Host "  [4/5] Limpando caches ARP e DNS..." -ForegroundColor Cyan
        Clear-DnsClientCache -ErrorAction SilentlyContinue
        & arp -d * *>$null

        Write-Host "  [5/5] Coletando nova configuração..." -ForegroundColor Cyan
        Start-Sleep -Seconds 1

        $newConfig = Get-NetIPConfiguration -InterfaceAlias $alias -ErrorAction SilentlyContinue
        $newIP = if ($newConfig.IPv4Address) { ($newConfig.IPv4Address | Select-Object -First 1).IPAddress } else { $null }
        $newGW = if ($newConfig.IPv4DefaultGateway) { $newConfig.IPv4DefaultGateway.NextHop } else { $null }

        Write-Host ""
        if ($newIP -and $newIP -ne $oldIP) {
            Write-Host "  [V] IP RENOVADO COM SUCESSO!" -ForegroundColor Green
            Write-Host "      IP Anterior : $oldIP" -ForegroundColor DarkGray
            Write-Host "      Novo IP     : $newIP" -ForegroundColor Green
        }
        elseif ($newIP) {
            Write-Host "  [!] O IP permaneceu o mesmo: $newIP" -ForegroundColor Yellow
            Write-Host "      O servidor DHCP da rede renovou a mesma concessão." -ForegroundColor DarkGray
            Write-Host "      Para forçar um IP diferente, use a opção [4] (Alterar MAC)." -ForegroundColor DarkGray
        }
        else {
            Write-Host "  [X] Não foi possível obter um IP do DHCP. Verifique o cabo/Wi-Fi." -ForegroundColor Red
        }

        if ($newIP) {
            Test-NetworkConnectivity -Gateway $newGW
        }
    }
    catch {
        Write-Host "  [X] Erro ao renovar IP: $_" -ForegroundColor Red
    }

    Pause-Menu
}

# ==============================================================================
# [2.A] CONFIGURAR IP ESTÁTICO DEFINITIVO
# ==============================================================================
function Invoke-SetStaticIP {
    Write-Header "Configurar IP Estático (Manual)"

    $adapter = Get-AdapterChoice
    if (-not $adapter) { return }

    $alias = $adapter.Name
    $config = Get-NetIPConfiguration -InterfaceAlias $alias -ErrorAction SilentlyContinue
    $currentIP      = if ($config.IPv4Address) { ($config.IPv4Address | Select-Object -First 1).IPAddress } else { "" }
    $currentGateway = if ($config.IPv4DefaultGateway) { $config.IPv4DefaultGateway.NextHop } else { "" }

    Write-Host "  Adaptador : $alias" -ForegroundColor Yellow
    Write-Host "  IP Atual  : $(if ($currentIP) { $currentIP } else { '(nenhum)' })" -ForegroundColor Green
    if ($currentGateway) {
        Write-Host "  Gateway   : $currentGateway" -ForegroundColor DarkGray
    }
    Write-Host ""

    # 1. Entrada do IP
    do {
        $ipPrompt = if ($currentIP) { "  " + ($script:IpPromptText[2] -f $currentIP) } else { "  " + $script:IpPromptText[3] }
        $ipInput = Read-Host $ipPrompt
        if ([string]::IsNullOrWhiteSpace($ipInput) -and $currentIP) { $ipInput = $currentIP }
        if (Test-IsValidIPv4 $ipInput) { break }
        Write-Host ("  [X] " + $script:IpPromptText[4]) -ForegroundColor Red
    } while ($true)

    # 2. Entrada da Máscara / CIDR
    do {
        $maskInput = Read-Host ("  " + $script:IpPromptText[5])
        if ([string]::IsNullOrWhiteSpace($maskInput)) { $maskInput = "255.255.255.0" }
        $prefix = Convert-SubnetMaskToPrefix $maskInput
        $decimalMask = Convert-PrefixToSubnetMask $prefix
        if ($prefix -ge 1 -and $prefix -le 32) { break }
        Write-Host ("  [X] " + $script:IpPromptText[6]) -ForegroundColor Red
    } while ($true)

    # 3. Entrada do Gateway
    do {
        $gwPrompt = if ($currentGateway) { "  " + ($script:IpPromptText[7] -f $currentGateway) } else { "  " + $script:IpPromptText[8] }
        $gwInput = Read-Host $gwPrompt
        if ([string]::IsNullOrWhiteSpace($gwInput) -and $currentGateway) { $gwInput = $currentGateway }
        $gwInput = $gwInput.Trim()
        if ([string]::IsNullOrWhiteSpace($gwInput) -or (Test-IsValidIPv4 $gwInput)) { break }
        Write-Host ("  [X] " + $script:IpPromptText[9]) -ForegroundColor Red
    } while ($true)

    # 4. Entrada dos Servidores DNS
    do {
        $dnsInput = Read-Host ("  " + $script:IpPromptText[10])
        if ([string]::IsNullOrWhiteSpace($dnsInput)) {
            $dnsServers = @('1.1.1.1', '8.8.8.8')
            break
        }
        $dnsServers = @($dnsInput -split ',' | ForEach-Object { $_.Trim() })
        $invalidDns = @($dnsServers | Where-Object { -not (Test-IsValidIPv4 $_) })
        if ($dnsServers.Count -gt 0 -and $invalidDns.Count -eq 0) { break }
        Write-Host ("  [X] " + $script:IpPromptText[11]) -ForegroundColor Red
    } while ($true)

    # Resumo
    Write-Host ""
    Write-Host "  -------------------------------------------------" -ForegroundColor DarkCyan
    Write-Host "  Confirmação das Configurações:" -ForegroundColor Cyan
    Write-Host "    Adaptador : $alias"
    Write-Host "    IP        : $ipInput (/$prefix - $decimalMask)"
    Write-Host "    Gateway   : $(if ($gwInput) { $gwInput } else { '(nenhum)' })"
    Write-Host "    DNS       : $($dnsServers -join ', ')"
    Write-Host "  -------------------------------------------------" -ForegroundColor DarkCyan
    Write-Host ""

    $confirm = Read-Host ("  " + $script:IpPromptText[12] + " ($($script:IpYesToken)/N)")
    if ($confirm.Trim().ToUpperInvariant() -ne $script:IpYesToken) {
        Write-Host "  [!] Operação cancelada pelo usuário." -ForegroundColor Yellow
        Pause-Menu
        return
    }

    Write-Host ""
    Write-Host "  Aplicando configuração definitiva..." -ForegroundColor Cyan

    $appliedSuccess = $false
    $errorMessage = ""

    # Metodo 1: PowerShell NetTCPIP (Com limpeza prévia rigorosa)
    try {
        Write-Host "  [1/4] Desativando DHCP na interface..." -ForegroundColor DarkGray
        Set-NetIPInterface -InterfaceAlias $alias -AddressFamily IPv4 -Dhcp Disabled -ErrorAction Stop

        Write-Host "  [2/4] Removendo enderecos IPv4 e rotas padrão antigas..." -ForegroundColor DarkGray
        Get-NetIPAddress -InterfaceAlias $alias -AddressFamily IPv4 -ErrorAction SilentlyContinue | Remove-NetIPAddress -Confirm:$false -ErrorAction SilentlyContinue
        Get-NetRoute -InterfaceAlias $alias -DestinationPrefix "0.0.0.0/0" -AddressFamily IPv4 -ErrorAction SilentlyContinue | Remove-NetRoute -Confirm:$false -ErrorAction SilentlyContinue

        Write-Host "  [3/4] Gravando novo IP estático ($ipInput/$prefix)..." -ForegroundColor DarkGray
        if (-not [string]::IsNullOrWhiteSpace($gwInput)) {
            New-NetIPAddress -InterfaceAlias $alias -IPAddress $ipInput -PrefixLength $prefix -DefaultGateway $gwInput -AddressFamily IPv4 -ErrorAction Stop | Out-Null
        } else {
            New-NetIPAddress -InterfaceAlias $alias -IPAddress $ipInput -PrefixLength $prefix -AddressFamily IPv4 -ErrorAction Stop | Out-Null
        }

        Write-Host "  [4/4] Configurando servidores DNS..." -ForegroundColor DarkGray
        Set-DnsClientServerAddress -InterfaceAlias $alias -ServerAddresses $dnsServers -ErrorAction Stop

        $appliedSuccess = $true
    }
    catch {
        $errorMessage = $_.Exception.Message
        Write-Host "  [!] Aviso no metodo NetTCPIP ($errorMessage). Acionando fallback netsh..." -ForegroundColor Yellow
    }

    # Metodo 2: Fallback Robusto via Netsh (Garante persistência total no Registro do Windows)
    if (-not $appliedSuccess) {
        try {
            Write-Host "  [Fallback] Configurando via subsistema Netsh..." -ForegroundColor Cyan
            if (-not [string]::IsNullOrWhiteSpace($gwInput)) {
                $res = & netsh interface ipv4 set address name="$alias" static "$ipInput" "$decimalMask" "$gwInput" 1 2>&1
            } else {
                $res = & netsh interface ipv4 set address name="$alias" static "$ipInput" "$decimalMask" 2>&1
            }

            if ($LASTEXITCODE -eq 0) {
                # Configura DNS Primário
                $pDns = $dnsServers[0]
                & netsh interface ipv4 set dnsservers name="$alias" static "$pDns" primary register=both *>$null
                if ($LASTEXITCODE -ne 0) { throw 'Netsh falhou ao configurar o DNS primário.' }
                
                # Configura DNS Secundário
                if ($dnsServers.Count -gt 1) {
                    for ($idx = 1; $idx -lt $dnsServers.Count; $idx++) {
                        $sDns = $dnsServers[$idx]
                        & netsh interface ipv4 add dnsservers name="$alias" "$sDns" index=($idx + 1) *>$null
                        if ($LASTEXITCODE -ne 0) { throw "Netsh falhou ao configurar o DNS $sDns." }
                    }
                }
                $appliedSuccess = $true
            } else {
                throw "Netsh falhou: $res"
            }
        }
        catch {
            Write-Host "  [X] Falha definitiva ao configurar IP: $_" -ForegroundColor Red
        }
    }

    # Limpeza de Caches
    Clear-DnsClientCache -ErrorAction SilentlyContinue
    & arp -d * *>$null

    Start-Sleep -Seconds 1

    # Verificação Final
    $finalCfg = Get-NetIPConfiguration -InterfaceAlias $alias -ErrorAction SilentlyContinue
    $appliedIP = if ($finalCfg.IPv4Address) { ($finalCfg.IPv4Address | Select-Object -First 1).IPAddress } else { $null }

    Write-Host ""
    if ($appliedSuccess -and $appliedIP -eq $ipInput) {
        Write-Host "  [V] IP ESTÁTICO APLICADO COM SUCESSO DE FORMA DEFINITIVA!" -ForegroundColor Green
        Write-Host "      IP Ativo  : $appliedIP" -ForegroundColor Green
        Write-Host "      Máscara   : $decimalMask (/$prefix)" -ForegroundColor DarkGray
        Write-Host "      Gateway   : $(if ($gwInput) { $gwInput } else { '(nenhum)' })" -ForegroundColor DarkGray
        Write-Host "      DNS       : $($dnsServers -join ', ')" -ForegroundColor DarkGray

        Test-NetworkConnectivity -Gateway $gwInput -Dns $dnsServers[0]
    }
    else {
        Write-Host "  [X] O IP configurado ($ipInput) difere do IP atual no adaptador ($appliedIP)." -ForegroundColor Red
        Write-Host "      Verifique se há políticas de rede ou outro serviço bloqueando." -ForegroundColor Yellow
    }

    Pause-Menu
}

# ==============================================================================
# [2.B] ATIVAR DHCP (IP E DNS AUTOMÁTICOS)
# ==============================================================================
function Invoke-SetDHCP {
    Write-Header "Ativar DHCP (IP e DNS Automaticos)"

    $adapter = Get-AdapterChoice
    if (-not $adapter) { return }

    $alias = $adapter.Name
    $config = Get-NetIPConfiguration -InterfaceAlias $alias -ErrorAction SilentlyContinue
    $currentIP = if ($config.IPv4Address) { ($config.IPv4Address | Select-Object -First 1).IPAddress } else { "nenhum" }

    Write-Host "  Adaptador : $alias" -ForegroundColor Yellow
    Write-Host "  IP Atual  : $currentIP" -ForegroundColor Green
    Write-Host ""

        $confirm = Read-Host ("  " + $script:IpPromptText[13] + " ($($script:IpYesToken)/N)")
    if ($confirm.Trim().ToUpperInvariant() -ne $script:IpYesToken) {
        Write-Host "  [!] Operação cancelada." -ForegroundColor Yellow
        Pause-Menu
        return
    }

    try {
        Write-Host ""
        Write-Host "  [1/5] Limpando rotas e IPs estaticos..." -ForegroundColor Cyan
        Get-NetIPAddress -InterfaceAlias $alias -AddressFamily IPv4 -ErrorAction SilentlyContinue | Remove-NetIPAddress -Confirm:$false -ErrorAction SilentlyContinue
        Get-NetRoute -InterfaceAlias $alias -DestinationPrefix "0.0.0.0/0" -AddressFamily IPv4 -ErrorAction SilentlyContinue | Remove-NetRoute -Confirm:$false -ErrorAction SilentlyContinue

        Write-Host "  [2/5] Habilitando DHCP para IP e DNS..." -ForegroundColor Cyan
        Set-NetIPInterface -InterfaceAlias $alias -AddressFamily IPv4 -Dhcp Enabled -ErrorAction SilentlyContinue
        Set-DnsClientServerAddress -InterfaceAlias $alias -ResetServerAddresses -ErrorAction SilentlyContinue

        # Fallback de garantia via netsh
        & netsh interface ipv4 set address name="$alias" source=dhcp *>$null
        & netsh interface ipv4 set dnsservers name="$alias" source=dhcp *>$null

        Write-Host "  [3/5] Reiniciando o adaptador de rede..." -ForegroundColor Cyan
        Restart-NetAdapter -Name $alias -Confirm:$false -ErrorAction Stop
        
        $isReady = Wait-ForAdapterReady -InterfaceAlias $alias -TimeoutSeconds 12

        Write-Host "  [4/5] Solicitando endereço via DHCP..." -ForegroundColor Cyan
        & ipconfig /renew "$alias" *>$null
        Start-Sleep -Seconds 2

        Write-Host "  [5/5] Verificando resultado..." -ForegroundColor Cyan
        $newConfig = Get-NetIPConfiguration -InterfaceAlias $alias -ErrorAction SilentlyContinue
        $newIP = if ($newConfig.IPv4Address) { ($newConfig.IPv4Address | Select-Object -First 1).IPAddress } else { $null }
        $newGW = if ($newConfig.IPv4DefaultGateway) { $newConfig.IPv4DefaultGateway.NextHop } else { $null }

        Write-Host ""
        if ($newIP) {
            Write-Host "  [V] DHCP ATIVADO COM SUCESSO!" -ForegroundColor Green
            Write-Host "      Novo IP Obtido : $newIP" -ForegroundColor Green
            Write-Host "      Gateway        : $(if ($newGW) { $newGW } else { '(nenhum)' })" -ForegroundColor DarkGray
            
            Test-NetworkConnectivity -Gateway $newGW
        } else {
            Write-Host "  [!] DHCP ativado, mas o IP ainda não foi atribuído pelo roteador." -ForegroundColor Yellow
            Write-Host "      Aguarde alguns segundos e consulte a opção [3]." -ForegroundColor DarkGray
        }
    }
    catch {
        Write-Host "  [X] Erro ao ativar DHCP: $_" -ForegroundColor Red
    }

    Pause-Menu
}

# ==============================================================================
# [3] INFORMAÇÕES DE REDE DETALHADAS
# ==============================================================================
function Invoke-ShowIP {
    Write-Header "Informações de Rede e Adaptadores"

    $adapters = @(Get-NetAdapter -ErrorAction SilentlyContinue | Sort-Object Name)
    if (-not $adapters -or $adapters.Count -eq 0) {
        Write-Host "  [X] Nenhum adaptador de rede encontrado no sistema." -ForegroundColor Red
        Pause-Menu
        return
    }

    foreach ($adapter in $adapters) {
        $alias   = $adapter.Name
        $config  = Get-NetIPConfiguration -InterfaceAlias $alias -ErrorAction SilentlyContinue
        $ipIface = Get-NetIPInterface -InterfaceAlias $alias -AddressFamily IPv4 -ErrorAction SilentlyContinue
        $dns     = Get-DnsClientServerAddress -InterfaceAlias $alias -AddressFamily IPv4 -ErrorAction SilentlyContinue

        $statusColor = if ($adapter.Status -eq 'Up') { "Green" } else { "DarkGray" }
        Write-Host "  ================================================================" -ForegroundColor DarkGray
        Write-Host ("  Adaptador      : {0} [{1}]" -f $alias, $adapter.Status) -ForegroundColor $statusColor
        Write-Host "  Descrição      : $($adapter.InterfaceDescription)" -ForegroundColor DarkGray
        Write-Host "  Tipo / Mídia   : $($adapter.MediaType) (Velocidade: $($adapter.LinkSpeed))" -ForegroundColor DarkGray
        Write-Host "  MAC Address    : $($adapter.MacAddress)" -ForegroundColor White

        # IPv4
        if ($config -and $config.IPv4Address) {
            $ips = ($config.IPv4Address | ForEach-Object { "$($_.IPAddress)/$($_.PrefixLength)" }) -join ', '
            Write-Host "  Endereço(s) IP : $ips" -ForegroundColor Cyan
        } else {
            Write-Host "  Endereço(s) IP : (nenhum)" -ForegroundColor DarkGray
        }

        # Gateway
        if ($config -and $config.IPv4DefaultGateway) {
            $gws = ($config.IPv4DefaultGateway | ForEach-Object { $_.NextHop }) -join ', '
            Write-Host "  Gateway Padrão : $gws" -ForegroundColor Cyan
        } else {
            Write-Host "  Gateway Padrão : (nenhum)" -ForegroundColor DarkGray
        }

        # DNS
        if ($dns -and $dns.ServerAddresses -and $dns.ServerAddresses.Count -gt 0) {
            Write-Host "  Servidores DNS : $($dns.ServerAddresses -join ', ')" -ForegroundColor Cyan
        } else {
            Write-Host "  Servidores DNS : (automático / nenhum)" -ForegroundColor DarkGray
        }

        # DHCP Status
        if ($ipIface) {
            $dhcpStatus = if ($ipIface.Dhcp -eq 'Enabled') { "Ativado (Obtido via DHCP)" } else { "Desativado (IP Estático)" }
            $dhcpColor  = if ($ipIface.Dhcp -eq 'Enabled') { "Green" } else { "Yellow" }
            Write-Host "  Modo DHCP      : $dhcpStatus" -ForegroundColor $dhcpColor
        }
        Write-Host ""
    }

    Pause-Menu
}

# ==============================================================================
# [4] GERENCIADOR DE MAC ADDRESS (SPOOFING E RESTAURAÇÃO)
# ==============================================================================
function Get-AdapterRegistryPath {
    param($Adapter)
    
    $classPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002BE10318}"
    $subKeys = @(Get-ChildItem -Path $classPath -ErrorAction SilentlyContinue | Where-Object { $_.PSChildName -match '^\d{4}$' })
    
    foreach ($k in $subKeys) {
        $props = Get-ItemProperty -Path $k.PSPath -ErrorAction SilentlyContinue
        
        # 1. Comparacao por InterfaceGuid / NetCfgInstanceId (Mais preciso)
        if ($props.NetCfgInstanceId -and $Adapter.InterfaceGuid -and ($props.NetCfgInstanceId -eq $Adapter.InterfaceGuid)) {
            return $k.PSPath
        }

        # 2. Comparacao por DriverDesc
        if ($props.DriverDesc -and ($props.DriverDesc -eq $Adapter.InterfaceDescription)) {
            return $k.PSPath
        }
    }
    return $null
}

function Invoke-ChangeMAC {
    Write-Header "Gerenciador de MAC Address"

    $adapter = Get-AdapterChoice -IncludeDisconnected $true
    if (-not $adapter) { return }

    $alias  = $adapter.Name
    $desc   = $adapter.InterfaceDescription
    $oldMac = $adapter.MacAddress

    $regPath = Get-AdapterRegistryPath -Adapter $adapter
    if (-not $regPath) {
        Write-Host "  [X] Não foi possível localizar a chave de registro do adaptador no Windows." -ForegroundColor Red
        Pause-Menu
        return
    }

    $currentCustomMac = (Get-ItemProperty -Path $regPath -Name "NetworkAddress" -ErrorAction SilentlyContinue).NetworkAddress

    Write-Host "  Adaptador      : $alias" -ForegroundColor Yellow
    Write-Host "  Descrição      : $desc" -ForegroundColor DarkGray
    Write-Host "  MAC Atual      : $oldMac" -ForegroundColor White
    if ($currentCustomMac) {
        Write-Host "  MAC Customizado: $currentCustomMac (gravado no Registro)" -ForegroundColor Magenta
    } else {
        Write-Host "  MAC de Fábrica : Padrão original ativo" -ForegroundColor Green
    }
    Write-Host ""
    Write-Host "  Escolha a ação desejada:" -ForegroundColor Cyan
    Write-Host "  [1] Gerar e aplicar MAC aleatório (Novo IP no roteador)" -ForegroundColor White
    Write-Host "  [2] Digitar MAC manualmente" -ForegroundColor White
    Write-Host "  [3] Restaurar MAC original de fábrica" -ForegroundColor Yellow
    Write-Host "  [0] Cancelar" -ForegroundColor DarkGray
    Write-Host ""

    $subOp = Read-Host "  Opção"
    $newMac = ""

    switch ($subOp) {
        "1" {
            # Prefixo com bit Local Admin (02, 06, 0A, 0E)
            $validPrefixes = @("02", "06", "0A", "0E")
            $prefix = $validPrefixes[(Get-Random -Maximum $validPrefixes.Count)]
            $hexChars = "0123456789ABCDEF"
            $rest = ""
            for ($i = 0; $i -lt 10; $i++) {
                $rest += $hexChars[(Get-Random -Maximum 16)]
            }
            $newMac = "$prefix$rest"
        }
        "2" {
            do {
                $inputMac = Read-Host "  Digite o novo MAC (12 caracteres hexadecimais, ex: 021122334455)"
                $cleanMac = $inputMac -replace '[:-]', ''
                if ($cleanMac -match '^[0-9A-Fa-f]{12}$') {
                    $newMac = $cleanMac.ToUpper()
                    break
                }
                Write-Host "  [X] Formato de MAC inválido. Deve conter 12 caracteres hexadecimais." -ForegroundColor Red
            } while ($true)
        }
        "3" {
            Write-Host ""
            Write-Host "  Restaurando MAC original de fábrica..." -ForegroundColor Cyan
            try {
                if ($currentCustomMac) {
                    Remove-ItemProperty -Path $regPath -Name "NetworkAddress" -ErrorAction Stop
                }
                Write-Host "  Reiniciando adaptador para aplicar..." -ForegroundColor DarkGray
                Restart-NetAdapter -Name $alias -Confirm:$false -ErrorAction Stop
                Wait-ForAdapterReady -InterfaceAlias $alias -TimeoutSeconds 10
                
                # Renew
                & ipconfig /renew "$alias" *>$null

                $remainingCustomMac = (Get-ItemProperty -Path $regPath -Name "NetworkAddress" -ErrorAction SilentlyContinue).NetworkAddress
                if ($remainingCustomMac) { throw "A personalização de MAC ainda esta registrada: $remainingCustomMac" }
                $updatedAdapter = Get-NetAdapter -Name $alias -ErrorAction Stop
                Write-Host ""
                Write-Host "  [V] MAC original de fábrica restaurado com sucesso!" -ForegroundColor Green
                Write-Host "      MAC Atual: $($updatedAdapter.MacAddress)" -ForegroundColor Green
            }
            catch {
                Write-Host "  [X] Erro ao restaurar MAC: $_" -ForegroundColor Red
            }
            Pause-Menu
            return
        }
        "0" { return }
        default {
            Write-Host "  Opção inválida." -ForegroundColor Red
            Pause-Menu
            return
        }
    }

    if ($newMac) {
        Write-Host ""
        Write-Host "  Novo MAC a ser aplicado: $newMac" -ForegroundColor Cyan
        $confirm = Read-Host ("  " + $script:IpPromptText[14] + " ($($script:IpYesToken)/N)")
        if ($confirm.Trim().ToUpperInvariant() -ne $script:IpYesToken) {
            Write-Host "  [!] Cancelado." -ForegroundColor Yellow
            Pause-Menu
            return
        }

        try {
            Write-Host "  [1/3] Gravando no Registro do Windows..." -ForegroundColor Cyan
            Set-ItemProperty -Path $regPath -Name "NetworkAddress" -Value $newMac -ErrorAction Stop

            Write-Host "  [2/3] Reiniciando o adaptador de rede..." -ForegroundColor Cyan
            Restart-NetAdapter -Name $alias -Confirm:$false -ErrorAction Stop
            Wait-ForAdapterReady -InterfaceAlias $alias -TimeoutSeconds 12

            Write-Host "  [3/3] Solicitando novo IP ao roteador (Renew)..." -ForegroundColor Cyan
            & ipconfig /renew "$alias" *>$null
            Start-Sleep -Seconds 2

            $updatedAdapter = Get-NetAdapter -Name $alias -ErrorAction SilentlyContinue
            if (-not $updatedAdapter) { throw "Não foi possível consultar o adaptador após a reinicialização." }
            $actualMac = ($updatedAdapter.MacAddress -replace '[:-]', '').ToUpperInvariant()
            if ($actualMac -ne $newMac.ToUpperInvariant()) {
                throw "O adaptador não confirmou o MAC solicitado. MAC informado: $newMac; MAC atual: $($updatedAdapter.MacAddress)"
            }
            $updatedConfig  = Get-NetIPConfiguration -InterfaceAlias $alias -ErrorAction SilentlyContinue
            $updatedIP      = if ($updatedConfig.IPv4Address) { ($updatedConfig.IPv4Address | Select-Object -First 1).IPAddress } else { "aguardando..." }

            Write-Host ""
            Write-Host "  [V] MAC ADDRESS ALTERADO COM SUCESSO!" -ForegroundColor Green
            Write-Host "      MAC Anterior : $oldMac" -ForegroundColor DarkGray
            Write-Host "      Novo MAC     : $($updatedAdapter.MacAddress)" -ForegroundColor Green
            Write-Host "      IP Atual     : $updatedIP" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "  Nota: Se desejar voltar ao original, basta usar a opção [3] deste menu." -ForegroundColor DarkGray
        }
        catch {
            Write-Host "  [X] Falha ao alterar MAC: $_" -ForegroundColor Red
            try {
                if ($currentCustomMac) {
                    Set-ItemProperty -Path $regPath -Name "NetworkAddress" -Value $currentCustomMac -ErrorAction Stop
                } else {
                    Remove-ItemProperty -Path $regPath -Name "NetworkAddress" -ErrorAction SilentlyContinue
                }
                Restart-NetAdapter -Name $alias -Confirm:$false -ErrorAction Stop
                Write-Host "  [!] A configuração de MAC anterior foi restaurada." -ForegroundColor Yellow
            } catch {
                Write-Host "  [!] Não foi possível restaurar automaticamente a configuração anterior: $_" -ForegroundColor Red
            }
        }
        Pause-Menu
    }
}

# ==============================================================================
# [5] REPARO COMPLETO E RESET DA PILHA DE REDE
# ==============================================================================
function Invoke-NetworkRepair {
    Write-Header "Reparo e Reset da Pilha de Rede"

    Write-Host "  Esta ferramenta executa uma limpeza profunda e reset de:" -ForegroundColor Yellow
    Write-Host "  - Cache DNS do cliente Windows" -ForegroundColor DarkGray
    Write-Host "  - Tabela ARP" -ForegroundColor DarkGray
    Write-Host "  - Catálogo Winsock (netsh winsock reset)" -ForegroundColor DarkGray
    Write-Host "  - Pilha de protocolos TCP/IP (netsh int ip reset)" -ForegroundColor DarkGray
    Write-Host "  - Liberação e renovação de concessões DHCP" -ForegroundColor DarkGray
    Write-Host ""

    $confirm = Read-Host ("  " + $script:IpPromptText[15] + " ($($script:IpYesToken)/N)")
    if ($confirm.Trim().ToUpperInvariant() -ne $script:IpYesToken) {
        Write-Host "  [!] Operação cancelada." -ForegroundColor Yellow
        Pause-Menu
        return
    }

    Write-Host ""
    Write-Host "  Executando reparo..." -ForegroundColor Cyan

    # 1. Flush DNS
    Write-Host "  [1/6] Limpando cache DNS..." -ForegroundColor DarkGray
    Clear-DnsClientCache -ErrorAction SilentlyContinue
    & ipconfig /flushdns *>$null

    # 2. Reset ARP
    Write-Host "  [2/6] Limpando tabela ARP..." -ForegroundColor DarkGray
    & arp -d * *>$null

    # 3. Winsock Reset
    Write-Host "  [3/6] Resetando catalogo Winsock..." -ForegroundColor DarkGray
    & netsh winsock reset *>$null

    # 4. TCP/IP Reset
    Write-Host "  [4/6] Resetando pilha TCP/IP..." -ForegroundColor DarkGray
    & netsh int ip reset *>$null

    # 5. Re-register DNS
    Write-Host "  [5/6] Registrando novamente serviço DNS..." -ForegroundColor DarkGray
    & ipconfig /registerdns *>$null

    # 6. Reiniciando adaptadores ativos
    Write-Host "  [6/6] Reiniciando adaptadores e renovando DHCP..." -ForegroundColor DarkGray
    $activeAdapters = @(Get-NetAdapter -ErrorAction SilentlyContinue | Where-Object { $_.Status -eq 'Up' })
    foreach ($ad in $activeAdapters) {
        Restart-NetAdapter -Name $ad.Name -Confirm:$false -ErrorAction SilentlyContinue
    }
    Start-Sleep -Seconds 4
    & ipconfig /renew *>$null

    Write-Host ""
    Write-Host "  [V] REPARO DE REDE CONCLUÍDO!" -ForegroundColor Green
    Write-Host "  Recomenda-se reiniciar o computador se persistirem instabilidades." -ForegroundColor Yellow

    Test-NetworkConnectivity

    Pause-Menu
}

# ==============================================================================
# MENU PRINCIPAL
# ==============================================================================
function Show-MainMenu {
    $m = $script:IpMenuText
    Clear-Host
    Write-Host $m[0] -ForegroundColor Cyan
    Write-Host "================================================================" -ForegroundColor DarkCyan
    Show-AppSessionMetadata -Version '1.0.0' -Started $script:SessionStartedAt
    Write-Host ("[1] " + $m[1]) -ForegroundColor White
    Write-Host ("    " + $m[2]) -ForegroundColor DarkGray
    Write-Host ("[2] " + $m[3]) -ForegroundColor White
    Write-Host ("    " + $m[4]) -ForegroundColor DarkGray
    Write-Host ("[3] " + $m[5]) -ForegroundColor White
    Write-Host ("    [A] " + $m[19] + " (netsh)") -ForegroundColor DarkGray
    Write-Host ("    [B] " + $m[20]) -ForegroundColor DarkGray
    Write-Host ("[4] " + $m[7]) -ForegroundColor White
    Write-Host ("    " + $m[8]) -ForegroundColor DarkGray
    Write-Host ("[5] " + $m[9]) -ForegroundColor White
    Write-Host ("    " + $m[10]) -ForegroundColor DarkGray
    Write-Host ("[6] " + $m[11]) -ForegroundColor White
    Write-Host ("    " + $m[12]) -ForegroundColor DarkGray
    Write-Host ("[7] " + $m[13]) -ForegroundColor White
    Write-Host ("    " + $m[14]) -ForegroundColor DarkGray
    Write-Host ("[0] " + $m[15]) -ForegroundColor White
    Write-Host "================================================================" -ForegroundColor DarkCyan
}

# ==============================================================================
# LOOP PRINCIPAL (BLINDADO CONTRA CTRL+C)
# ==============================================================================
do {
    try {
        Show-MainMenu
        $opcao = Read-Host ("  " + $script:IpMenuText[16])

        switch ($opcao.ToUpper().Trim()) {
            "1" { Invoke-ForceNewIP }
            "2" { Invoke-RenewIP }
            "3" {
                Clear-Host
                Write-Host $script:IpMenuText[18] -ForegroundColor Cyan
                Write-Host "================================================================" -ForegroundColor DarkCyan
                Write-Host ("[A] " + $script:IpMenuText[19]) -ForegroundColor White
                Write-Host ("[B] " + $script:IpMenuText[20]) -ForegroundColor White
                Write-Host ("[0] " + $script:IpMenuText[21]) -ForegroundColor DarkGray
                $sub = Read-Host $script:IpMenuText[22]
                switch ($sub.ToUpper().Trim()) {
                    "A" { Invoke-SetStaticIP }
                    "B" { Invoke-SetDHCP }
                    "0" { }
                    default {
                        Write-Host ("  " + $script:IpMenuText[17]) -ForegroundColor Red
                        Start-Sleep -Seconds 1
                    }
                }
            }
            "A" { Invoke-SetStaticIP }
            "B" { Invoke-SetDHCP }
            "4" { Invoke-ShowIP }
            "5" { Invoke-ChangeMAC }
            "6" {
                Write-Header "Teste de Conectividade"
                Test-NetworkConnectivity
                Pause-Menu
            }
            "7" { Invoke-NetworkRepair }
            "0" {
                Write-Host ""
                Write-Host "  Encerrando Gerenciador de IP..." -ForegroundColor DarkGray
                Start-Sleep -Milliseconds 400
                exit
            }
            default {
                Write-Host ("  " + $script:IpMenuText[17]) -ForegroundColor Red
                Start-Sleep -Seconds 1
            }
        }
    }
    catch {
        # Se ocorrer interrupção por Ctrl+C, mantém o loop ativo e limpa a tela
        Write-Host ""
        Start-Sleep -Milliseconds 200
    }
} while ($true)






