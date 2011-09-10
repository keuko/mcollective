#!/bin/bash

TARARCHIVE=$1
CURDIR=$(pwd)

if [ -z ${TARARCHIVE} ]; then
	echo "Please supply filename to mcollective archive"
	exit 1
fi

if [ ! -f ${TARARCHIVE} ]; then
	echo "Could not find ${TARARCHIVE}"
	exit 1
fi

TEMP_DIR=$(mktemp -d)

MC_VERSION=$(echo ${TARARCHIVE} | sed -e 's@.*-@@' -e 's@.tgz@@')

echo "Found Mcollective Version ${MC_VERSION}"

tar xvfz ${TARARCHIVE} -C ${TEMP_DIR}/

# strip included vendor stuff
rm -rf ${TEMP_DIR}/mcollective-${MC_VERSION}/lib/mcollective/vendor/json
rm -rf ${TEMP_DIR}/mcollective-${MC_VERSION}/lib/mcollective/vendor/systemu
rm -rf ${TEMP_DIR}/mcollective-${MC_VERSION}/lib/mcollective/vendor/load_json.rb
rm -rf ${TEMP_DIR}/mcollective-${MC_VERSION}/lib/mcollective/vendor/load_systemu.rb

# strip included stuff to build ActiveMQ rpm package
rm -rf ${TEMP_DIR}/mcollective-${MC_VERSION}/ext/activemq/wlcg-patch.tgz
rm -rf ${TEMP_DIR}/mcollective-${MC_VERSION}/ext/activemq/apache-activemq.spec

cd ${TEMP_DIR}
tar cvz mcollective-${MC_VERSION} -f ${CURDIR}/mcollective_${MC_VERSION}+dfsg.orig.tar.gz
cd ${CURDIR}
rm -rf ${TEMP_DIR}
