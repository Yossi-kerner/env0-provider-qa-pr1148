#!/bin/bash
# Builds terraform-provider-env0 at QA_PROVIDER_REF and points terraform at it via dev_overrides.
set -euo pipefail
REF=${QA_PROVIDER_REF:?set QA_PROVIDER_REF}
case "$(uname -m)" in x86_64) GOARCH=amd64 ;; aarch64|arm64) GOARCH=arm64 ;; *) echo "unknown arch $(uname -m)"; exit 1 ;; esac
WORK="$PWD/.qa-build"
mkdir -p "$WORK/bin"
curl -fsSL "https://go.dev/dl/go1.26.8.linux-$GOARCH.tar.gz" | tar -C "$WORK" -xz
git clone --quiet https://github.com/env0/terraform-provider-env0 "$WORK/src"
git -C "$WORK/src" checkout --quiet "$REF"
(cd "$WORK/src" && GOCACHE="$WORK/cache" GOPATH="$WORK/gopath" GOFLAGS=-mod=mod "$WORK/go/bin/go" build -o "$WORK/bin/terraform-provider-env0" .)
cat > "$WORK/tfrc" <<TFRC
provider_installation {
  dev_overrides { "env0/env0" = "$WORK/bin" }
  direct {}
}
TFRC
echo "TF_CLI_CONFIG_FILE=$WORK/tfrc" >> "$ENV0_ENV"
echo "QA: built terraform-provider-env0 at $(git -C "$WORK/src" rev-parse HEAD) for linux/$GOARCH"
