#!/bin/ash
set -e

# Check if our environment variable has been passed.
if [ -z "${DOMAIN}" ]
then
  echo "DOMAIN has not been set."
  exit 1
else
  sed -i.bak "s/\$DOMAIN/${DOMAIN}/g" /opt/nginx/conf/nginx.conf
fi

exec /opt/nginx/sbin/nginx "-g" "daemon off;"