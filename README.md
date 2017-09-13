## btc-notify

O `btc-notify` busca o JSON da API de dados do Mercado Bitcoin, faz o parse dos dados e envia uma notificação no desktop com a última cotação do Bitcoin negociado nesta exchange e seu timestamp.

##### Dependências

 * [jq \[https://stedolan.github.io/jq/\]](https://stedolan.github.io/jq/) para o parsing do JSON

##### Instalação

Clone este repositório ou baixe o script no local desejado:

```
wget -q https://raw.githubusercontent.com/denisdl/btc-notify/master/btc-notify.sh; chmod +x btc-notify.sh
```

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