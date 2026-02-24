#!/usr/bin/env bash
#
# Reverse DNS lookup for list of IP addresses
# Safer version with input validation and optional custom resolver
#
# Usage:
#   ./resolve_ips_safe.sh input.txt                 → uses system default resolver
#   ./resolve_ips_safe.sh input.txt 8.8.8.8         → uses Google's public DNS
#   ./resolve_ips_safe.sh input.txt 1.1.1.1         → uses Cloudflare
#
# Output (CSV on stdout):
# IP,resolved_dns_name
# 1.2.3.4,example.com
# 5.6.7.8,NOTRESOLVED
#

set -u
set -e
set -o pipefail

readonly INPUT_FILE="${1:-}"
readonly CUSTOM_DNS="${2:-}"           # optional second argument

# ──────────────────────────────────────────────────────────────────────────────
#  Basic argument & file checks
# ──────────────────────────────────────────────────────────────────────────────

if [[ -z "$INPUT_FILE" ]]; then
    echo "Error: missing input file" >&2
    echo "Usage: $0 ip_list.txt [dns_server]" >&2
    exit 1
fi

if [[ ! -f "$INPUT_FILE" ]]; then
    echo "Error: file not found or not a regular file: $INPUT_FILE" >&2
    exit 1
fi

if [[ ! -r "$INPUT_FILE" ]]; then
    echo "Error: cannot read file: $INPUT_FILE" >&2
    exit 1
fi

# Optional DNS server validation (very basic)
if [[ -n "$CUSTOM_DNS" ]]; then
    if [[ ! "$CUSTOM_DNS" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]] &&
       [[ ! "$CUSTOM_DNS" =~ ^[0-9a-fA-F:]+$ ]]; then
        echo "Error: second argument does not look like a valid IP address: $CUSTOM_DNS" >&2
        exit 1
    fi
fi

# ──────────────────────────────────────────────────────────────────────────────
#  Output CSV header
# ──────────────────────────────────────────────────────────────────────────────

echo "IP,resolved_dns_name"

# ──────────────────────────────────────────────────────────────────────────────
#  Process each line
# ──────────────────────────────────────────────────────────────────────────────

while IFS= read -r line || [[ -n "$line" ]]; do
    # Remove leading/trailing whitespace
    ip="${line#"${line%%[![:space:]]*}"}"
    ip="${ip%"${ip##*[![:space:]]}"}"

    # Skip empty lines and pure comment lines
    [[ -z "$ip" ]] && continue
    [[ "$ip" =~ ^[[:space:]]*# ]] && continue

    # Very strict IPv4 validation
    if [[ ! "$ip" =~ ^([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})\.([0-9]{1,3})$ ]]; then
        echo "${ip},INVALID_IP_FORMAT"
        continue
    fi

    # Check each octet is 0–255
    for octet in "${BASH_REMATCH[@]:1:4}"; do
        if (( octet < 0 || octet > 255 )); then
            echo "${ip},INVALID_IP_OCTET"
            continue 2
        fi
    done

    # Prepare dig/host command
    if command -v dig >/dev/null 2>&1; then
        cmd=(dig +short +timeout=4 +tries=2 -x "$ip")
        [[ -n "$CUSTOM_DNS" ]] && cmd+=("@${CUSTOM_DNS}")
    elif command -v host >/dev/null 2>&1; then
        cmd=(host -W 4 -R 2 "$ip")
        [[ -n "$CUSTOM_DNS" ]] && cmd+=("${CUSTOM_DNS}")
    else
        echo "${ip},NO_DNS_TOOL_AVAILABLE" >&2
        continue
    fi

    # Run lookup and clean result
    name=$("${cmd[@]}" 2>/dev/null | head -n 1 | sed 's/\.$//; s/.*pointer //')

    if [[ -n "$name" ]]; then
        # Very basic protection against weird output (replace comma → semicolon)
        name="${name//,/\;}"
        echo "${ip},${name}"
    else
        echo "${ip},NOTRESOLVED"
    fi

done < "$INPUT_FILE"
