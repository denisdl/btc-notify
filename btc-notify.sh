#!/bin/sh -u
#
# O `btc-notify` busca o JSON da API de dados do Mercado Bitcoin, 
# faz o parse dos dados e envia uma notificação no desktop com a 
# última cotação do Bitcoin negociado nesta exchange e seu timestamp.
# 
# Sugestões de uso
# 
# Insira um *alias* em seu ~/.zshrc ou ~/.bashrc:
# alias btc-notify="/home/denis/concatenum/btc-notify/btc-notify.sh > /dev/null 2>&1 & disown"
# 
# Insira uma chamada em seu crontab (neste exemplo a notificação será acionada uma vez a cada dez minutos):
# 01,11,21,31,41,51 * * * * /home/denis/concatenum/btc-notify/btc-notify.sh
#
# Para enviar a notificação no Slack, configure 
# duas variáveis de ambiente em seu ~/.zshrc ou ~/.bashrc:
# BTC_NOTIFY_APP="slack"
# BTC_NOTIFY_SLACK_HEBHOOK="URL do webhook Slack"
#
# Para criar sua URL do webhook Slack, veja em https://api.slack.com/incoming-webhooks
#
# Dependências: jq (https://stedolan.github.io/jq/)
# Desenvolvido e testado no Ubuntu 16.04
#
# v1.1.0
#
# denis@concatenum.com
# --------------------

# variáveis de ambiente para o notify-send funcionar a partir do cron
# https://askubuntu.com/questions/298608/notify-send-doesnt-work-from-crontab
user=$(whoami)
pid=$(pgrep -u $user gnome-session | head -n 1)
dbus=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$pid/environ | sed 's/DBUS_SESSION_BUS_ADDRESS=//' )
export DBUS_SESSION_BUS_ADDRESS=$dbus
export HOME=/home/$user
export DISPLAY=:0

BTC_TICKER=$(curl -s https://www.mercadobitcoin.net/api/BTC/ticker/)
BTC_TIME=$(date -d @$(echo $BTC_TICKER | jq '.[].date' --raw-output; ))
BTC_LAST="1 BTC = `(echo $BTC_TICKER | jq '.[].last' --raw-output)` BRL"

if [ "$BTC_NOTIFY_APP" = "slack" ]
then
  curl -q -X POST --data-urlencode 'payload={"username": "btc-notify", "text": "'"$BTC_TIME\n$BTC_LAST"'", "icon_emoji": ":moneybag:"}' $BTC_NOTIFY_SLACK_HEBHOOK
else
  /usr/bin/notify-send "$(echo $BTC_TIME)" "$(echo $BTC_LAST)" \
  -t 3000 --icon="/usr/share/icons/gnome/32x32/status/user-available.png"
fi