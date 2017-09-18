#!/bin/bash
#
# O `btc-notify` busca o JSON da API de dados do Mercado Bitcoin, 
# faz o parse dos dados e envia uma notificação no desktop com a 
# última cotação do Bitcoin negociado nesta exchange e seu timestamp.
#
# Veja instruções de uso em https://github.com/denisdl/btc-notify
#
# v1.3.0
#
# denis@concatenum.com
# --------------------
#
# variáveis de ambiente para o notify-send funcionar a partir do cron
# https://askubuntu.com/questions/298608/notify-send-doesnt-work-from-crontab
user=$(whoami)
pid=$(pgrep -u $user gnome-session | head -n 1)
dbus=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$pid/environ | sed 's/DBUS_SESSION_BUS_ADDRESS=//' )
export DBUS_SESSION_BUS_ADDRESS=$dbus
export HOME=/home/$user
export DISPLAY=:0

# path deste script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# curl & parse dos dados 
BTC_TICKER=$(curl -s https://www.mercadobitcoin.net/api/BTC/ticker/)
BTC_TIME=$(date -d @$(echo $BTC_TICKER | jq '.[].date' --raw-output; ))
BTC_LAST="1 BTC = `(echo $BTC_TICKER | jq '.[].last' --raw-output)` BRL"

# envio da notificação por Slack ou notify-send
if [ "$BTC_NOTIFY_APP" = "slack" ]
then
  curl -q -X POST --data-urlencode 'payload={"username": "btc-notify", "text": "'"$BTC_TIME\n$BTC_LAST"'", "icon_emoji": ":moneybag:"}' $BTC_NOTIFY_SLACK_HEBHOOK
elif [ "$BTC_NOTIFY_APP" = "espeak" ]
then
  BTC_LAST=$(echo $BTC_LAST | cut -d\. -f1 | sed 's/BTC/Bitcoin/g')
  /usr/bin/padsp /usr/bin/espeak -vpt "$BTC_LAST" & disown
else
  /usr/bin/notify-send "$(echo $BTC_TIME)" "$(echo $BTC_LAST)" \
  -t 3000 --icon="$DIR/img/bitcoin-logo.png"
fi
