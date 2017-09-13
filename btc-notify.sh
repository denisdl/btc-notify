#!/bin/sh
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
# Dependências: jq (https://stedolan.github.io/jq/)
# Desenvolvido e testado no Ubuntu 16.04
#
# v1.0.0
#
# denis@concatenum.com

BTC_TICKER=$(curl -s https://www.mercadobitcoin.net/api/BTC/ticker/)
BTC_TIME=$(echo $BTC_TICKER | jq '.[].date' --raw-output; )
BTC_LAST="1 BTC = `(echo $BTC_TICKER | jq '.[].last' --raw-output)` BRL"

/usr/bin/notify-send "$(date -d @$BTC_TIME)" "$(echo $BTC_LAST)" -t 3000 --icon="/usr/share/icons/gnome/32x32/status/user-available.png"