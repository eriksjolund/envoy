#!/bin/bash -e

export NAME=double-proxy
export MANUAL=true
export DELAY=5

# shellcheck source=examples/verify-common.sh
. "$(dirname "${BASH_SOURCE[0]}")/../verify-common.sh"

mkdir -p certs

run_log "Create a cert authority"
openssl genrsa -out certs/ca.key 4096
openssl req -batch -x509 -new -nodes -key certs/ca.key -sha256 -days 1024 -out certs/ca.crt

run_log "Create a domain key"
openssl genrsa -out certs/example.com.key 2048

generate_csr_and_crt() {
  run_log "Generate signing request for the proxy $1"
  openssl req -new -sha256 \
	-key certs/example.com.key \
	-subj "/C=US/ST=CA/O=MyExample, Inc./CN=$1" \
	-out certs/$1.csr

  run_log "Generate certificates for the proxy $1"
  openssl x509 -req \
	-in certs/$1.csr \
	-CA certs/ca.crt \
	-CAkey certs/ca.key \
	-CAcreateserial \
	-extfile <(printf "subjectAltName=DNS:$1") \
	-out certs/$1.crt \
	-days 500 \
	-sha256
}

generate_csr_and_crt proxy-postgres-frontend-1.example.com
generate_csr_and_crt proxy-postgres-frontend-2.example.com
generate_csr_and_crt proxy-postgres-backend-1.example.com
generate_csr_and_crt proxy-postgres-backend-2.example.com

bring_up_example

run_log "Test app/db connection"
responds_with \
    "Connected to Postgres, version: PostgreSQL" \
    http://localhost:10000
