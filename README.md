## btc-notify v1.3.0

O `btc-notify` busca o JSON da API de dados do Mercado Bitcoin, faz o parse dos dados e envia uma notificação no desktop com a última cotação do Bitcoin negociado nesta exchange e seu timestamp.

##### Dependências

 * [jq \[https://stedolan.github.io/jq/\]](https://stedolan.github.io/jq/) para o parsing do JSON
 * [espeak \[http://espeak.sourceforge.net/\](http://espeak.sourceforge.net/) (opcional) para notificação por som sintetizado text-to-speach

##### Instalação

Clone este repositório ou baixe o script no local desejado:

```
wget -q https://raw.githubusercontent.com/denisdl/btc-notify/master/btc-notify.sh
chmod +x btc-notify.sh
```

##### Configuração da notificação no Slack

Por default as notificações são feitas pelo `notify-send`. Para uso no Slack, configure duas variáveis de ambiente em seu `~/.zshrc` ou `~/.bashrc`:
```
BTC_NOTIFY_APP="slack"
BTC_NOTIFY_SLACK_HEBHOOK="URL do webhook Slack"
```
Para criar sua URL do webhook Slack, veja em [https://api.slack.com/incoming-webhook](https://api.slack.com/incoming-webhooks)

Para a notificação ser enviada pelo `notify-send`, basta substituir o conteúdo da variável `BTC_NOTIFY_APP` por "notify-send" ou removê-la.

##### Configuração da notificação no text-to-speach `espeak`

Informe "espeak" na variável de ambiente `BTC_NOTIFY_APP`. Neste formato a notificação é apenas do valor inteiro, desconsiderando os decimais.

##### Sugestões de uso

Insira um *alias* em seu `~/.zshrc` ou `~/.bashrc`:

```
alias btc-notify="/home/denis/concatenum/btc-notify/btc-notify.sh > /dev/null 2>&1 & disown"
```

Insira uma chamada em seu `crontab` (neste exemplo a notificação será acionada uma vez a cada dez minutos):
```
01,11,21,31,41,51 * * * * /home/denis/concatenum/btc-notify/btc-notify.sh
```

##### Observações
Desenvolvido e testado no Ubuntu 16.04