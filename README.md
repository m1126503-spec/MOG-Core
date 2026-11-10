MOG Core
========

[![Build](https://github.com/m1126503-spec/MOG-Core/actions/workflows/cmake-single-platform.yml/badge.svg)](https://github.com/m1126503-spec/MOG-Core/actions/workflows/cmake-single-platform.yml)

MOG Core — экспериментальная нода и кошелёк. Сеть принимает переводы монет и пользовательские активы (токены).

| | |
|---|---|
| Порт | `9766` (тестнет `19766`) |
| Алгоритм | X16R на блоках 0–999, KAWPOW с высоты 1000 |
| Генезис | `MOG Chain Genesis - 2026-10-28` |
| Программы | `mogd` (нода), `mog-cli` (команды) |

Готовых файлов для скачивания пока нет. Нода собирается из исходников.

Документация
-------------

- [Подключение к сети](doc/join-network.md) — конфиг, запуск, майнер, `addnode`
- [Пример mog.conf](share/examples/mog.conf)
- [Сборка на Ubuntu](doc/build-ubuntu.md)
- [Сборка на Windows](doc/build-windows.md)

Публичного адреса первой ноды ещё нет. Пока его не опубликуют, сосед нужен явный `addnode`.

Лицензия
-------

MIT. См. [COPYING](COPYING).
