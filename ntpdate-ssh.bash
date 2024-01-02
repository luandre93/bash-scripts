#!/bin/bash
# Criação: Luandre B. Andrade
# 02/01/2024
#

# Função de conexão sshpass
function ssh_conn() {
    local user="root"
    local password="password"
    local noKey="-oStrictHostKeyChecking=no"
    sshpass -p "$password" ssh "$noKey" "$user"@"$1" "$2"
}

# Ajusta o horario dos terminais.
function ntpdate_c() {
    ssh_conn $1 "ntpdate -s 192.168.6.140"
}

function init() {
# Quantidade de terminais
    local quantidade=5
    local data=$(date +"%T")
    echo -e "[ $data ]> Inicio do ciclo."
    for ((count = 2; count <= quantidade; count++)); do
        local e=1
        local c=10
        local ip="192.168.6.14"
        local faixa="$ip$count"
            ping -c 2 "$ip$count" > /dev/null
             if [ $? -ne 0 ]; then
                echo -e "[ $data ]> ConexÃ£o com o IP - $faixa Falhou!"
             else
                echo -e "[ $data ]> $faixa Ping OK!"
                ntpdate_c $faixa
             fi
    done
    echo -e "[ $data ]> Fim do ciclo."
}

# Repete a cada 10 min.
while true
 do
   init
   sleep 600
 done
