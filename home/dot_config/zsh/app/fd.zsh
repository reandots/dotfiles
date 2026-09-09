# Искать скрытые файлы
alias fd='command fd --hidden --exclude .git'

# Исключить скрытые файла
alias fdnh='command fd --no-hidden --exclude .git'

# Только директории, в том числе скрытые
alias fdd='command fd --hidden --type d --exclude .git'

# Только файлы, в том числе скрытые
alias fdf='command fd --hidden --type f --exclude .git'

# Только исполняемые файлы, в том числе скрытые
alias fdx='command fd --hidden --type x --exclude .git'

# Поиск во всех файлах без любых ограничений
alias fdall='command fd --unrestricted'

# Поиск от /, включая скрытые и игнорируемые файлы, кроме каталогов ниже.
# Шаблон необязателен; -x/-X передаются fd без дополнительных операндов.
fdroot() {
    command fd \
        --unrestricted \
        --search-path / \
        --exclude '/proc' \
        --exclude '/sys' \
        --exclude '/dev' \
        --exclude '/run' \
        --exclude '/mnt' \
        --exclude '/nix' \
        --exclude '/var/run' \
        "$@"
}
