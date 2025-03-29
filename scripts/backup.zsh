backup() {
  # Exibe as instruções de uso
  local help_text="Uso: simple-backup [-h|--help] [-d|--destination DESTINO]
Cria um arquivo de backup dos diretórios e arquivos especificados.

Opções:
  -h, --help           exibe esta mensagem de ajuda
  -d, --destination    especifica o destino do arquivo de backup"
  
  if [[ $1 == 'help' || $1 == "-h" || $1 == "--help" ]]; then
    echo "$help_text"
    return 0
  fi

  # Diretórios e arquivos a serem copiados
  local backup_dirs=(
    "$HOME/Documents/"
    "$HOME/Downloads/"
    "$HOME/Videos/"
    "$HOME/Pictures/"
    "$HOME/Appium/"
    "$HOME/Eduardo/"
    "$HOME/Projects/"
    "$HOME/Work/"
    "$HOME/ROMS/"
    "$HOME/exercism/"
    "$HOME/config-files/"
    "$HOME/wireguard-keys/"
    "$HOME/.ssh/"
    "$HOME/.local/"
    "$HOME/.config/"
    "$HOME/.tmux/"
    "$HOME/.zshrc"
    "$HOME/.p10k.zsh"
    "$HOME/.tmux.conf"
    "/usr/local/bin"
    "/opt/"
  )

  # Destino padrão
  local dest="/media/SSD240"

  # Verifica se foi passado um destino
  if [[ $1 == "-d" || $1 == "--destination" ]]; then
    dest="$2"
  fi

  # Nome do arquivo de backup
  local now=$(date +"%d_%m_%Y")
  local filename="simple_backup_${now}.tar.gz"
  local backup_file="${dest}/${filename}"

  echo "O arquivo de backup será criado em: ${backup_file}"
  echo "Para mudar o destino, use o parâmetro -d ou --destination."

  # Confirmação
  print -n "Você tem certeza que deseja continuar? (y/N) "
  read confirm
  if [[ ! "$confirm" =~ ^(y|yes|s|sim)$ ]]; then
    echo "Execução cancelada."
    return 1
  fi

  # Cria o backup
  echo "Criando arquivo de backup..."
  tar -Pzcvf "$backup_file" "${backup_dirs[@]}"

  echo "✅ Arquivo de backup criado com sucesso em: ${backup_file}"
}

