#!/bin/sh
# Turn on the built-in CPU miner of a running mogd that was built with a wallet.
# Blocks 0 through 999 are X16R. Block 1000 and later are KAWPOW.
# Usage: contrib/mog-miner.sh [threads]
set -eu
threads=${1:-1}
if [ -x ./src/mog-cli ]; then
    cli=./src/mog-cli
else
    cli=${MOG_CLI:-mog-cli}
fi
exec "$cli" setgenerate true "$threads"
