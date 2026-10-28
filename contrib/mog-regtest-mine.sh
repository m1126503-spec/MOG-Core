#!/usr/bin/env bash

# Mine blocks on an isolated regtest node using its built-in CPU miner RPC.
set -euo pipefail

blocks="${1:-1}"
if [[ ! "$blocks" =~ ^[1-9][0-9]*$ ]]; then
    echo "Usage: $0 [positive-number-of-blocks]" >&2
    exit 2
fi

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
mog_cli="${MOG_CLI:-$repo_root/src/mog-cli}"
network_args=(-regtest)
if [[ -n "${MOG_DATADIR:-}" ]]; then
    network_args+=("-datadir=$MOG_DATADIR")
fi

if [[ ! -x "$mog_cli" ]]; then
    echo "mog-cli executable not found: $mog_cli (set MOG_CLI to its path)" >&2
    exit 1
fi

address="$("$mog_cli" "${network_args[@]}" -rpcwait getnewaddress)"
echo "Mining $blocks block(s) on regtest to $address"
"$mog_cli" "${network_args[@]}" generatetoaddress "$blocks" "$address"
