#!/bin/bash

# Função para configurar o banco de dados no arquivo .env
configure_database() {
    echo "Configuração do banco de dados:"

    # Solicita o nome do banco de dados
    echo "Qual é o nome do banco de dados?"
    read -r db_name

    # Solicita o nome de usuário do banco de dados
    echo "Qual é o nome de usuário do banco de dados?"
    read -r db_username

    # Solicita a senha do banco de dados
    echo "Qual é a senha do banco de dados?"
    read -rs db_password

    # Substitui as configurações no arquivo .env com as credenciais fornecidas
    sed -i "s/DB_DATABASE=.*/DB_DATABASE=$db_name/" .env
    sed -i "s/DB_USERNAME=.*/DB_USERNAME=$db_username/" .env
    sed -i "s/DB_PASSWORD=.*/DB_PASSWORD=$db_password/" .env
}

# Função para executar migrações
run_migrations() {
    echo "Executando Migrações..."
    php artisan migrate
}

# Função para iniciar uma sessão no tmux
start_tmux_session() {
    local session_name="$1"
    local choice

    echo "Qual o nome da sessão?"
    read -r session_name

    tmux new-session -d -s "$session_name"

    while true; do
        echo "Você deseja iniciar os servidores apache e mysql? (S/n)"
        read -r choice

        case $choice in
        [Ss]*)
            # Inicia os servidores apache e mysql
            #sudo systemctl start apache && sudo systemctl start mysql (alias)
            tmux send-keys "dev" C-m
            ;;
        [Nn]*) break ;;
        *) echo "Opção inválida. Por favor, escolha S ou n." ;;
        esac
    done

    tmux attach-session -t "$session_name"
}

cd /home/rafael/laravel

while true; do
    echo "Qual o nome do projeto?"
    read -r project_name

    if [ -d "$project_name" ]; then
        echo "O diretório $project_name já existe. Por favor, escolha outro nome."
    else
        if /home/rafael/.config/composer/vendor/bin/laravel new "$project_name"; then
            cd "/home/rafael/laravel/$project_name"
            clear

            while true; do
                echo "Você deseja configurar um banco de dados no Mysql?"
                read -r choice
                case $choice in
                [Ss]*)
                    configure_database
                    break
                    ;;
                [Nn]*) break ;;
                *) ;;
                esac

            done

            while true; do
                echo "Rodar migrations? (S/n)"
                read -r choice

                case $choice in
                [Ss]*)
                    run_migrations
                    break
                    ;;
                [Nn]*) break ;;
                *) echo "Opção inválida. Por favor, escolha S ou n." ;;
                esac
            done

            while true; do
                echo "Você deseja iniciar uma sessão no tmux? (S/n)"
                read -r choice

                case $choice in
                [Ss]*)
                    start_tmux_session
                    break
                    ;;
                [Nn]*) break ;;
                *) echo "Opção inválida. Por favor, escolha S ou n." ;;
                esac
            done

            break
        else
            echo "A criação do projeto foi cancelada. Por favor, tente novamente."
        fi
    fi
done
