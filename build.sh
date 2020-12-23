#!/bin/bash -x
#sudo su - pheweb -c /home/mutaamba/Work/pheweb-data-puddle/build.sh 

source "${BASH_SOURCE%/*}/.envrc"
sudo rm -rf /mnt/nfs_dev/pheweb/staging ; sudo mkdir /mnt/nfs_dev/pheweb/staging ; sudo chown ${USER}:${USER}  /mnt/nfs_dev/pheweb/staging  

[ -n "${DESTINATION}" ] || { echo 'missing DESTINATION' ; exit 1; }
[ -n "${BUCKET}" ] || { echo 'missing BUCKET' ; exit 1; }

(test ! -f ${DESTINATION}/config.py ) && (cat roles/data_puddle/templates/config.py | envsubst > ${DESTINATION}/config.py )


(test ! -f ${DESTINATION}/pheno-list.json ) && (gsutil -mq cp -r ${BUCKET}/* ${DESTINATION} )
(test ! -d ${DESTINATION}/content) && ( cp -r roles/data_puddle/files/content ${DESTINATION} )
mkdir -p ${DESTINATION}/cache
(test ! -f ${DESTINATION}/cache/genes-b38-v25.bed ) && (cp ${DESTINATION}/generated-by-pheweb/genes-b38-v25.bed  ${DESTINATION}/cache/genes-b38-v25.bed )
(test ! -f ${DESTINATION}/cache/gene_aliases_b38.marisa_trie ) && (cp ${DESTINATION}/generated-by-pheweb/gene_aliases_b38.marisa_trie  ${DESTINATION}/cache/gene_aliases_b38.marisa_trie )
(ls ${DESTINATION}/generated-by-pheweb/*.tbi > /dev/null 2>&1 ) && touch ${DESTINATION}/generated-by-pheweb/*.tbi

(test ! -f ${DESTINATION}/oauth.conf ) && (gcloud beta secrets versions access latest --secret=${SUBDOMAIN}_oauth > ${DESTINATION}/oauth.conf )
(test ! -f ${DESTINATION}/mysql.conf) && (gcloud beta secrets versions access latest --secret=${SUBDOMAIN}_mysql > ${DESTINATION}/mysql.conf )


# /cromwell_root -> ${DESTINATION}

