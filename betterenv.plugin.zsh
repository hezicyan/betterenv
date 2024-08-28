# Filename of the betterenv file to look for
: "${ZSH_BETTERENV_FILE:=.env}"

# Path to the file containing allowed paths
: "${ZSH_BETTERENV_ALLOWED_LIST:=${ZSH_CACHE_DIR:-$ZSH/cache}/betterenv-allowed.list}"
: "${ZSH_BETTERENV_DISALLOWED_LIST:=${ZSH_CACHE_DIR:-$ZSH/cache}/betterenv-disallowed.list}"

source_env() {
  local curdir="${PWD:A}"
  local curenv

  # find the first ancestor directory with a .env file
  while true; do
    if [[ "$curdir" == "/" ]]; then
      curenv="${curdir}${ZSH_BETTERENV_FILE}"
    else
      curenv="${curdir}/${ZSH_BETTERENV_FILE}"
    fi
    [[ ! -f "$curenv" ]] || break
    [[ "$curdir" != "/" && "$curdir" != "$HOME" ]] || return
    curdir=$(dirname "$curdir")
  done

  # make sure there is an (dis-)allowed file
  touch "$ZSH_BETTERENV_ALLOWED_LIST"
  touch "$ZSH_BETTERENV_DISALLOWED_LIST"

  # early return if disallowed
  if command grep -Fx -q "$curenv" "$ZSH_BETTERENV_DISALLOWED_LIST" &>/dev/null; then
    return
  fi

  if ! command grep -Fx -q "$curenv" "$ZSH_BETTERENV_ALLOWED_LIST" &>/dev/null; then
    # get cursor column and print new line before prompt if not at line beginning
    local column
    echo -ne "\e[6n" >/dev/tty
    read -t 1 -rsdR column </dev/tty
    column="${column##*\[*;}"
    [[ $column = 1 ]] || echo

    # print same-line prompt and output newline character if necessary
    echo -n "betterenv: found '$curenv'. Source it? ([Y]es/[n]o/[a]lways/n[e]ver) "
    local confirmation
    read -rk 1 confirmation
    [[ $confirmation == $'\n' ]] || echo

    # check input
    case "$confirmation" in
    [nN])
      return
      ;;
    [aA])
      echo "$curenv" >>"$ZSH_BETTERENV_ALLOWED_LIST"
      ;;
    [eE])
      echo "$curenv" >>"$ZSH_BETTERENV_DISALLOWED_LIST"
      return
      ;;
    *)
      # interpret anything else as a yes
      ;;
    esac
  fi

  # report if there are syntax errors in .env file
  if ! zsh -fn "$curenv"; then
    echo "betterenv: error when sourcing '$curenv'" >&2
    return 1
  fi

  setopt localoptions allexport
  source "$curenv"
}

autoload -U add-zsh-hook
add-zsh-hook chpwd source_env

source_env
