#!/bin/sh
# Start mogd just far enough to construct chain parameters.
# A wrong genesis hash aborts inside SelectParams() before "MOG version" is logged.
set -eu

MOGD=${MOGD:-./src/mogd}

if [ ! -x "$MOGD" ]; then
    echo "mogd not found at $MOGD" >&2
    exit 1
fi

check_net() {
    name=$1
    shift
    dir=$(mktemp -d)
    "$MOGD" -datadir="$dir" -printtoconsole -listen=0 -dnsseed=0 "$@" >"$dir/console.log" 2>&1 &
    pid=$!
    i=0
    while [ "$i" -lt 40 ]; do
        if grep -q "MOG version" "$dir/console.log" "$dir/debug.log" 2>/dev/null; then
            kill "$pid" 2>/dev/null || true
            wait "$pid" 2>/dev/null || true
            echo "$name: genesis accepted"
            return 0
        fi
        if ! kill -0 "$pid" 2>/dev/null; then
            echo "$name: mogd exited before loading chain parameters" >&2
            cat "$dir/console.log" >&2 || true
            return 1
        fi
        i=$((i + 1))
        sleep 1
    done
    echo "$name: timed out waiting for startup" >&2
    cat "$dir/console.log" >&2 || true
    kill "$pid" 2>/dev/null || true
    wait "$pid" 2>/dev/null || true
    return 1
}

check_net main
check_net testnet -testnet
check_net regtest -regtest
