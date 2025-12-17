#! /bin/bash

/app/bootstrap.sh

LLDAP_ADMIN_PASSWORD=$(cat ${LLDAP_ADMIN_PASSWORD_FILE})

function set_password() {
  USER=$1
  NEW_PASSWORD=$2
  /app/lldap_set_password --base-url ${LLDAP_URL} \
                          --admin-username admin \
                          --admin-password ${LLDAP_ADMIN_PASSWORD} \
                          --username ${USER} \
                          --password ${NEW_PASSWORD}
}

AUTHELIA_PASSWORD=$(cat ${SERVICE_PASSWORD_AUTHELIA_FILE})
set_password authelia ${AUTHELIA_PASSWORD}
