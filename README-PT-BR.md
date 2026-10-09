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

## 👨‍💻 Sobre o Autor

Desenvolvido e mantido por **Emerson Teles** (conhecido na comunidade como **Emertels**).

Entusiasta de tecnologia, informática, jogos, manutenção de sistemas e tradução/localização de softwares para Português do Brasil (PT-BR). Desenvolvedor focado em utilitários práticos, ferramentas de produtividade, automação inteligente em PowerShell e soluções completas de localização técnica que aproximam ferramentas modernas do público brasileiro.

### 🛠️ Projetos & Contribuições

- [AI-Chat-Vault](https://github.com/Emertels/AI-Chat-Vault) — Backup portátil e recuperação de conversas locais de 20+ ferramentas e assistentes de IA.
- [Antigravity — Tradução PT-BR](https://github.com/Emertels/Antigravity-Traducao-PTBR) — Localização completa do Google Antigravity Desktop para Português do Brasil.
- [Codex Router — Tradução PT-BR](https://github.com/Emertels/CodexRouter-Traducao-PTBR) — Pacote de tradução e localização do Codex Router Control Center em PT-BR.
- [Cursor AI — Tradução PT-BR](https://github.com/Emertels/Cursor-Traducao-PTBR) — Localização completa e profunda do Cursor AI para Português do Brasil.
- [GPU Tweak III — Tradução PT-BR](https://github.com/Emertels/GPU-Tweak-III-Traducao-PTBR) — Tradução em português brasileiro e instalador automatizado para ASUS GPU Tweak III.
- [Microsoft Photos Fix](https://github.com/Emertels/Microsoft-Photos-Fix) — Solução definitiva em PowerShell e C# para rota de inicialização rápida e visualização no app Fotos do Windows.
- [PSBBN-Translator](https://github.com/Emertels/PSBBN-Translator) — Suíte corporativa de tradução e localização para o PSBBN Definitive Project (PlayStation 2) em 40 idiomas.
- [Silent Hill: Homecoming — Tradução PT-BR](https://github.com/Emertels/Silent-Hill-Homecoming-Traducao-PTBR) — Tradução e revisão completa do jogo para PC em português brasileiro.
- [Suite-Emuladores](https://github.com/Emertels/Suite-Emuladores) — Suíte inteligente em PowerShell para download e atualização autônoma de 56 emuladores e frontends no Windows.
- [ZCode — Tradução PT-BR](https://github.com/Emertels/ZCode-Traducao-PTBR) — Tradução e localização completa do ZCode Desktop para Português do Brasil.

### 🌐 Conecte-se comigo & Comunidades Oficiais

<div align="left">

[![GitHub](https://img.shields.io/badge/GitHub-Emertels-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/emertels)
[![Website](https://img.shields.io/badge/Website-Emerson_Teles-0070F3?style=for-the-badge&logo=googlechrome&logoColor=white)](https://emertels.github.io)
[![Discord](https://img.shields.io/badge/Discord-Emertels%20Server-5865F2?style=for-the-badge&logo=discord&logoColor=white)](https://emertels.github.io/discord)
[![X / Twitter](https://img.shields.io/badge/X_Twitter-@emertels-000000?style=for-the-badge&logo=x&logoColor=white)](https://x.com/emertels)
[![YouTube](https://img.shields.io/badge/YouTube-Emerson_Teles-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/@emersonteles2379)
[![Telegram](https://img.shields.io/badge/Telegram-Aplicativos%20Mods-2CA5E0?style=for-the-badge&logo=telegram&logoColor=white)](https://t.me/apksmodsandroid)
[![Ko-fi](https://img.shields.io/badge/Ko--fi-Apoiar%20Projeto-FF5E5B?style=for-the-badge&logo=kofi&logoColor=white)](https://ko-fi.com/emertels)

</div>
