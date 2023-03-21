#!/bin/bash

create_user_cert(){
    USER=$1
    CERTS_PATH=/etc/kubernetes/pki/users/${USER}
    echo "Creating certificates for user ${USER}"
    mkdir -p ${CERTS_PATH}
    openssl genrsa -out ${CERTS_PATH}/${USER}.key 2048
    openssl req -new -key ${CERTS_PATH}/${USER}.key -subj "/CN=${USER}" -out ${CERTS_PATH}/${USER}.csr
    openssl x509 -req -in ${CERTS_PATH}/${USER}.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -CAcreateserial -out ${CERTS_PATH}/${USER}.crt
}


if [[ $# -eq 0 ]] ; then
    echo "No arguments supplied. Username(s) must be supplied. If multiple separate by space."
    exit 1
fi

for user in "$@"
do
    create_user_cert $user
done
