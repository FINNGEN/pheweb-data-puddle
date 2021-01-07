#!/bin/bash -x
#sudo su - pheweb -c /home/mutaamba/Work/pheweb-data-puddle/build.sh 

source "${BASH_SOURCE%/*}/.envrc"
sudo rm -rf ${DESTINATION} ; sudo mkdir ${DESTINATION} ; sudo chown ${USER}:${USER} ${DESTINATION}

BUCKET="gs://r6_data_green/pheweb/78157cf4-d56f-431a-99fb-3b2bae4e494b_out"
RELEASE=6
SUBDOMAIN=bstaging
MOUNT=/mnt/nfs_dev

case $key in
    -b|--bucket)
    BUCKET="$2"; shift; shift
    ;;
    -r|--release)
    RELEASE="$2"; shift; shift
    ;;
    -s|--subdomain)
    SUBDOMAIN="$2"; shift; shift
    ;;
    -m|--mount)
    MOUNT="$2"; shift; shift
    ;;
    --default)
    DEFAULT=YES
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac

[ -n "${BUCKET}" ] || { echo 'missing BUCKET' ; exit 1; }
[ -n "${RELEASE}" ] || { echo 'missing RELEASE' ; exit 1; }
[ -n "${SUBDOMAIN}" ] || { echo 'missing SUBDOMAIN=' ; exit 1; }
[ -n "${MOUNT}" ] || { echo 'missing MOUNT' ; exit 1; }

(gsutil ls "${BUCKET}" &> /dev/null) ||  { echo "not found bucket '${BUCKET}'" ; exit 1; }
(command -v helm &> /dev/null) || { echo 'missing helm' ; exit 1; }

echo "DESTINATION : ${DESTINATION}"
echo "BUCKET : ${BUCKET}"
echo "MOUNT : ${MOUNT}"

export DESTINATION="${MOUNT}/pheweb/${SUBDOMAIN}"
export ANNOTATIONS_DIR=${MOUNT}/annotations

(test ! -f ${DESTINATION}/config.py ) && (cat roles/data_puddle/templates/config.py | envsubst > ${DESTINATION}/config.py )
(cat roles/data_puddle/templates/config.py | envsubst > ${DESTINATION}/config.py )

(test ! -f ${DESTINATION}/pheno-list.json ) && (gsutil -mq cp -r ${BUCKET}/* ${DESTINATION} )
(test ! -d ${DESTINATION}/content) && ( cp -r roles/data_puddle/files/content ${DESTINATION} )
mkdir -p ${DESTINATION}/cache

(test ! -f ${DESTINATION}/cache/genes-b38-v25.bed ) && (gsutil -mq cp ${BUCKET}/generated-by-pheweb/genes-b38-v25.bed  ${DESTINATION}/cache/genes-b38-v25.bed )
(test ! -f ${DESTINATION}/cache/gene_aliases_b38.marisa_trie ) && (gsutil -mq cp ${BUCKET}/generated-by-pheweb/gene_aliases_b38.marisa_trie  ${DESTINATION}/cache/gene_aliases_b38.marisa_trie )
(ls ${DESTINATION}/generated-by-pheweb/*.tbi > /dev/null 2>&1 ) && (gsutil -mq cp ${BUCKET}/*.tbi  ${DESTINATION}/cache/gene_aliases_b38.marisa_trie )

(test ! -f ${DESTINATION}/oauth.conf ) && (gcloud beta secrets versions access latest --secret=${SUBDOMAIN}_oauth > ${DESTINATION}/oauth.conf )
(test ! -f ${DESTINATION}/mysql.conf) && (gcloud beta secrets versions access latest --secret=${SUBDOMAIN}_mysql > ${DESTINATION}/mysql.conf )

if helm ls | grep bstaging > /dev/null  ; then COMMAND=upgrade ; else  COMMAND=install ; fi

helm ${COMMAND} ${SUBDOMAIN} ./chart --set pheweb.subdomain=${SUBDOMAIN} --set pheweb.mount=${MOUNT}
