backup() {
  emulate -L zsh

  local help_text="Uso: backup [-h|--help] [-d|--destination DESTINO]
Cria um backup compactado (zstd) dos diretórios e arquivos definidos abaixo.

Opções:
  -h, --help           exibe esta mensagem de ajuda
  -d, --destination    diretório de destino (padrão: /media/SSD240)

O que é ignorado (reproduzível): node_modules, venv/.venv, __pycache__,
caches de dev (.gradle/.next/.turbo/...) e caches de app dentro de .config
(Cache, GPUCache, Code Cache, Service Worker, Crashpad, ...). O resto do
perfil dos apps (settings, extensões, bookmarks) é mantido.

Também ignorado: estado atrelado à MÁQUINA (monitors.xml, gvfs-metadata,
estado de áudio, perfis de cor) — restaurar isso noutro computador quebra o
GNOME e é regerado sozinho no primeiro login; cofres de credencial (keyring do
GNOME, FortiClient, tokens de API) já que o .tar.zst não é criptografado; e
imagens de VM (gnome-boxes, libvirt).

ATENÇÃO: .ssh/, .aws/, wireguard-keys/ e os perfis de navegador CONTINUAM no
backup, por escolha. O arquivo gerado contém chaves privadas e sessões em
claro — trate o destino como mídia sensível.
Diretórios inexistentes são pulados automaticamente."

  # --- destino padrão + parsing de argumentos ---
  local dest="/media/SSD240"
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help) echo "$help_text"; return 0 ;;
      -d|--destination) dest="$2"; shift 2 ;;
      *) echo "Opção desconhecida: $1"; echo; echo "$help_text"; return 1 ;;
    esac
  done

  # --- pré-requisito: zstd ---
  if ! command -v zstd >/dev/null 2>&1; then
    echo "❌ zstd não encontrado. Instale com: sudo dnf install zstd"
    return 1
  fi

  # --- diretórios e arquivos candidatos ao backup ---
  local -a candidates=(
    "$HOME/Documents/"
    "$HOME/Downloads/"
    "$HOME/Videos/"
    "$HOME/Pictures/"
    "$HOME/Appium/"
    "$HOME/Eduardo/"
    "$HOME/Projects/"
    "$HOME/Work/"
    "$HOME/ROMS/"
    "$HOME/Books/"
    "$HOME/exercism/"
    "$HOME/config-files/"
    "$HOME/wireguard-keys/"
    "$HOME/.ssh/"
    "$HOME/.config/"
    "$HOME/.tmux/"
    "$HOME/.zshrc"
    "$HOME/.p10k.zsh"
    "$HOME/.tmux.conf"
    "$HOME/.aws/"
    "$HOME/.local/share/"
    "$HOME/.steam/"
    "/usr/local/bin"
    "/opt/"
  )

  # --- filtra o que existe; registra o que faltou ---
  local -a backup_dirs=() missing=()
  local p
  for p in "${candidates[@]}"; do
    if [[ -e "$p" ]]; then backup_dirs+=("$p"); else missing+=("$p"); fi
  done
  if (( ${#backup_dirs} == 0 )); then
    echo "❌ Nenhum dos caminhos existe — nada a fazer."
    return 1
  fi

  # --- padrões ignorados (não-ancorados: casam o componente em qualquer nível) ---
  local -a exclude_patterns=(
    # artefatos de dev reconstruíveis
    node_modules .venv venv __pycache__ .pytest_cache .mypy_cache
    .gradle .next .turbo
    # caches de app (Electron / Chromium / navegadores) dentro de .config
    'Cache' 'Cache_Data' 'Code Cache' 'CachedData' 'CachedExtensionVSIXs'
    'GPUCache' 'ShaderCache' 'GrShaderCache'
    'DawnCache' 'DawnGraphiteCache' 'DawnWebGPUCache'
    'component_crx_cache' 'Service Worker' 'blob_storage'
    'Crashpad' 'Crash Reports'
    # caches do Steam dentro de config/ (avatares e cache do browser interno)
    avatarcache htmlcache
    # steam: jogos instalados (steamapps), cache, logs e dumps
    steamapps appcache logs dump
    # lixeira do sistema e flatpaks (aplicativos redownloadáveis)
    Trash flatpak
    # caches de pacotes, containers e ambientes virtuais
    NuGet containers virtualenv umu
  )
  local -a exclude_args=()
  local pattern
  for pattern in "${exclude_patterns[@]}"; do exclude_args+=("--exclude=$pattern"); done

  # exclusões com caminho exato para não afetar pastas de configuração homônimas em .config/
  exclude_args+=("--exclude=$HOME/.local/share/JetBrains")
  exclude_args+=("--exclude=$HOME/.local/share/nvim")

  # --- estado de máquina/hardware: NÃO restaurável em outro computador ---
  # Aprendido na marra (2026-09-20): restaurar estes num desktop diferente deixou o
  # gvfsd-metadata girando a 100% de CPU (33 min de CPU em 42 de vida) e encheu o
  # monitors.xml com layouts de um notebook (eDP-1) inexistente aqui. Todos são
  # regerados sozinhos no primeiro login — não há nada a preservar.
  exclude_args+=("--exclude=$HOME/.config/monitors.xml")             # layout de telas por EDID/conector
  exclude_args+=("--exclude=$HOME/.local/share/gvfs-metadata")       # metadados do Nautilus por inode
  exclude_args+=("--exclude=$HOME/.local/share/recently-used.xbel")  # "recentes" com caminhos da máquina antiga
  exclude_args+=("--exclude=$HOME/.config/pulse")                    # cookie/estado de áudio da máquina
  exclude_args+=("--exclude=$HOME/.config/wireplumber")              # rotas de áudio por ID de placa
  exclude_args+=("--exclude=$HOME/.local/share/icc")                 # perfis de cor atrelados ao monitor
  exclude_args+=("--exclude=$HOME/.local/share/gnome-settings-daemon")

  # --- credenciais: o backup é um tar.zst SEM criptografia ---
  # Mantidos de propósito (decisão do Douglas): .ssh/, .aws/, wireguard-keys/ e os
  # perfis de navegador. Excluídos abaixo apenas os cofres de credencial puros e os
  # tokens de extensão de editor, que não carregam configuração de valor.
  exclude_args+=("--exclude=$HOME/.local/share/keyrings")            # cofre de senhas do GNOME
  exclude_args+=("--exclude=$HOME/.config/FortiClient")              # credenciais de VPN
  exclude_args+=("--exclude=$HOME/.config/Postman")                  # tokens de API (Postman sincroniza pela conta)
  # só o globalStorage: preserva settings.json e keybindings dos editores
  exclude_args+=("--exclude=$HOME/.config/Code/User/globalStorage")
  exclude_args+=("--exclude=$HOME/.config/Cursor/User/globalStorage")

  # --- volume: imagens de VM, recriáveis e enormes (~11 GB) ---
  # distrobox-homes fica de fora desta lista a pedido — é backupeado normalmente.
  exclude_args+=("--exclude=$HOME/.local/share/gnome-boxes")         # discos de VM
  exclude_args+=("--exclude=$HOME/.config/libvirt")                  # storage/definições libvirt

  # --- validação do destino ---
  if [[ ! -d "$dest" ]]; then echo "❌ Destino não existe: $dest"; return 1; fi
  if [[ ! -w "$dest" ]]; then echo "❌ Sem permissão de escrita em: $dest"; return 1; fi

  local now=$(date +"%d_%m_%Y")
  local backup_file="${dest}/simple_backup_${now}.tar.zst"

  # --- resumo antes de confirmar ---
  echo "Destino:  $backup_file"
  echo "Incluindo ${#backup_dirs} caminhos; ignorando caches de dev e de app."
  if (( ${#missing} )); then
    echo "Pulados (não existem):"
    printf '  - %s\n' "${missing[@]}"
  fi

  print -n "Continuar? (y/N) "
  local confirm; read confirm
  if [[ ! "${confirm:l}" =~ '^(y|yes|s|sim)$' ]]; then
    echo "Cancelado."
    return 1
  fi

  # --- cria o backup ---
  # -P mantém caminhos absolutos (necessário p/ /opt e /usr/local/bin);
  #    no restore, o tar extrai nesses caminhos absolutos — extraia com cuidado.
  echo "Criando backup (zstd multi-thread)..."
  tar -P --ignore-failed-read -I 'zstd -T0 -12' "${exclude_args[@]}" -cvf "$backup_file" "${backup_dirs[@]}"
  local rc=$?

  if (( rc == 1 )); then
    echo "⚠️  tar terminou com avisos (rc=1) — geralmente arquivo alterado durante a leitura (app aberto). O backup foi gerado."
  elif (( rc > 1 )); then
    echo "❌ tar falhou (rc=$rc). /opt e /usr/local/bin podem exigir 'sudo' para leitura completa."
    return $rc
  fi

  # --- verifica integridade (lê o arquivo inteiro) ---
  echo "Verificando integridade..."
  if tar -I zstd -tf "$backup_file" >/dev/null 2>&1; then
    echo "✅ Backup íntegro em: $backup_file ($(du -h "$backup_file" | cut -f1))"
  else
    echo "❌ Arquivo inválido/corrompido: $backup_file"
    return 1
  fi
}
