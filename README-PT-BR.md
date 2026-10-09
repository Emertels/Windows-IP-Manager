# Gerenciador de IP e Rede do Windows

**Versão:** 1.0.0  
**Idiomas da interface:** PT-BR, inglês, espanhol, francês, alemão, italiano, japonês, coreano, chinês simplificado e russo. O idioma acompanha a cultura de interface do Windows; idiomas não compatíveis usam PT-BR.

## O que faz

Menu interativo para consultar e gerenciar adaptadores, configurações IP e operações de endereço MAC.

## Arquivos

Windows-IP-Manager.ps1
Session-Header.ps1
Ip-UI-Catalog.json

## Como usar

1. Baixe ou clone o repositório completo.
2. Execute `Windows-IP-Manager.ps1` no Windows PowerShell. O script carrega `Session-Header.ps1` e `Ip-UI-Catalog.json` da mesma pasta. Aceite o UAC quando solicitado.

## Requisitos

Windows 10 ou Windows 11 e Windows PowerShell 5.1. Alterações de adaptador e endereço IP exigem privilégios de administrador; winget não é necessário.

## Segurança e limitações

O projeto não deve apagar dados pessoais, credenciais ou conteúdo fora dos caminhos definidos pela ferramenta. A disponibilidade de comandos e recursos depende da edição e versão do Windows. Revise CHANGELOG.md antes de atualizar.

## Desenvolvimento

Consulte AGENTS-PT-BR.md e AGENTS-EN.md. O idioma padrão da interface é detectado pela cultura do Windows; quando ela não for compatível, use PT-BR como fallback.

## Idiomas, finalidade e dicas

Os menus, prompts, etapas, confirmações e mensagens de operação estão disponíveis nos dez idiomas. Mantenha `Ip-UI-Catalog.json` e `Session-Header.ps1` na mesma pasta do script principal; ambos fazem parte do programa.

Antes de definir IP manual, confirme endereço, máscara, gateway e DNS. Valores errados podem desconectar o PC; faça alterações localmente ou tenha acesso alternativo. O programa valida a máscara e todos os DNS digitados; se o adaptador não confirmar o MAC solicitado, tenta restaurar o valor anterior.

### Idiomas disponíveis / Available languages

| Idioma | Código | Indicação |
|---|---|---|
| Português (Brasil) | pt-BR | Brasil |
| Inglês | en | Sistemas em inglês |
| Espanhol | es | Sistemas em espanhol |
| Francês | fr | Sistemas em francês |
| Alemão | de | Sistemas em alemão |
| Italiano | it | Sistemas em italiano |
| Japonês | ja | Sistemas em japonês |
| Coreano | ko | Sistemas em coreano |
| Chinês simplificado | zh-CN | Sistemas em chinês simplificado |
| Russo | ru | Sistemas em russo |









## Sobre Emerson Teles

Emerson Teles (Emertels) desenvolve ferramentas para Windows, automação, emulação e localização de software. Veja os projetos e acompanhe os canais oficiais:

- [Site oficial](https://emertels.github.io) · [GitHub](https://github.com/Emertels) · [Discord](https://emertels.github.io/discord)
- [YouTube](https://www.youtube.com/@emersonteles2379) · [X](https://x.com/emertels) · [Telegram](https://t.me/apksmodsandroid) · [Ko-fi](https://ko-fi.com/emertels)

### Outros projetos

- [AI-Chat-Vault](https://github.com/Emertels/AI-Chat-Vault) — backup portátil e recuperação de conversas locais de ferramentas de IA.
- [Suite-Emuladores](https://github.com/Emertels/Suite-Emuladores) — gerenciamento de download e atualização de emuladores e frontends no Windows.
- [Microsoft-Photos-Fix](https://github.com/Emertels/Microsoft-Photos-Fix) — correção de inicialização e papel de parede do app Fotos do Windows.
- [PSBBN-Translator](https://github.com/Emertels/PSBBN-Translator) — localização do PSBBN Definitive Project em 40 idiomas.
- [GPU-Tweak-III-Traducao-PTBR](https://github.com/Emertels/GPU-Tweak-III-Traducao-PTBR), [Cursor-Traducao-PTBR](https://github.com/Emertels/Cursor-Traducao-PTBR), [CodexRouter-Traducao-PTBR](https://github.com/Emertels/CodexRouter-Traducao-PTBR), [Antigravity-Traducao-PTBR](https://github.com/Emertels/Antigravity-Traducao-PTBR) e [ZCode-Traducao-PTBR](https://github.com/Emertels/ZCode-Traducao-PTBR) — projetos de localização para PT-BR.
- [Silent-Hill-Homecoming-Traducao-PTBR](https://github.com/Emertels/Silent-Hill-Homecoming-Traducao-PTBR) — tradução e revisão para PC.


