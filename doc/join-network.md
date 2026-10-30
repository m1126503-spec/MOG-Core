# Подключение к сети MOG

MOG is not discovered automatically. Until DNS seeds are published, every node needs `addnode=` in `mog.conf`.

Сеть не находится сама. Пока нет DNS-сидов, в `mog.conf` обязательно нужен `addnode` с адресом уже запущенной ноды.

## Что уже есть

| | |
|---|---|
| Порт | `9766` (тестнет `19766`) |
| Конфиг | `~/.mog/mog.conf` |
| Пример | [share/examples/mog.conf](../share/examples/mog.conf) |
| Программы | `mogd` (нода), `mog-cli` (команды) |
| Генезис | текст `MOG Chain Genesis - 2026-10-28`; корень Меркла `98e63749…7a7e76` |

CI после сборки запускает `contrib/mog-genesis-check.sh`. Скрипт поднимает `mogd` на main, testnet и regtest и ждёт строку `nBestHeight = 0`. Если генезис не подключается, сборка красная.

Первые 1000 блоков (высоты 0–999) считаются алгоритмом X16R. С блока 1000 включается KAWPOW. Время блока на это больше не влияет: старая дата Raven (май 2020) больше не переключает алгоритм.

## Собрать ноду с кошельком

Проверка на GitHub собирает ноду без кошелька. Чтобы майнить и пользоваться адресами, соберите так:

```sh
./autogen.sh
./configure --without-gui --without-miniupnpc
make -C src -j"$(nproc)"
```

Зависимости на Ubuntu 22.04: `build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev libboost-all-dev libdb5.3++-dev libzmq3-dev`.

## Запустить первую ноду

```sh
mkdir -p ~/.mog
cp share/examples/mog.conf ~/.mog/mog.conf
# поставьте свой rpcpassword
./src/mogd -printtoconsole
```

Откройте входящий TCP `9766`. Одной ноды достаточно, чтобы появился первый блок.

Майнер встроен в `mogd` и работает на X16R, пока высота меньше 1000. Нужна сборка с кошельком. В `mog.conf` можно раскомментировать `gen=1`, либо при запущенной ноде:

```sh
./src/mog-cli getnewaddress
contrib/mog-miner.sh 1
./src/mog-cli getblockcount
```

`contrib/mog-miner.sh` вызывает `setgenerate`. `getblockcount` должен стать `1` или больше. С блока 1000 тот же майнер переключается на KAWPOW и крутит `nNonce64`, а не обычный nonce.

## Подключить других людей

Им нужен тот же бинарник и ваш белый IP. В их `~/.mog/mog.conf`:

```
addnode=ВАШ.ПУБЛИЧНЫЙ.IP
```

Проверка с их стороны:

```sh
./src/mog-cli getconnectioncount
./src/mog-cli getblockcount
```

`getconnectioncount` должен быть не меньше 1, а высота блоков — как у первой ноды.

Две ноды на одной машине, если внешнего сервера ещё нет:

```sh
mkdir -p /tmp/mog-peer
./src/mogd -datadir=/tmp/mog-peer -port=9767 -addnode=127.0.0.1:9766 -printtoconsole
```

## Чего ещё нет

Публичных сидов, готовых релизов под Windows и проводника блоков. Пока люди ходят только через `addnode`. Когда несколько нод будут стабильно онлайн, их адреса можно вписать в `vSeeds` в `src/chainparams.cpp`.
