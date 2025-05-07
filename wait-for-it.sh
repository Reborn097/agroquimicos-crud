#!/usr/bin/env bash
# wait-for-it.sh by vishnubob - https://github.com/vishnubob/wait-for-it

set -e

host="$1"
shift
cmd="$@"

until nc -z ${host%:*} ${host#*:}; do
  >&2 echo "🕒 Esperando a que $host esté disponible..."
  sleep 2
done

>&2 echo "✅ $host está disponible. Iniciando la app..."
exec $cmd
