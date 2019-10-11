source /usr/local/ssds_ha/etc/ha.cf

function cmdlog {
echo "EXEC '${@}'" |logger -t ssds_ha
${@} 2>&1 |logger -t ssds_ha
}

# Récupérer l'adresse réseau de l'interface virtuelle
V4_VNET="$(echo ${V4_VIP} |cut -d"." -f1-3).0"

# Récupérer l'adresse IP de l'interface statique
STATIC_IP=$(ip addr ls ${STATIC_IF} |grep "inet " |awk '{print $2}' |cut -d"/" -f1)
if [ "${STATIC_IP}" = "" ] ; then
	while [ "${STATIC_IP}" = "" ] ; do
		STATIC_IP=$(ip addr ls ${STATIC_IF} |grep "inet " |awk '{print $2}' |cut -d"/" -f1)
		sleep 1
	done
fi

# Transformer la liste des noeuds du cluster HA
PEERS="${PEERS/,/ }"

# Transformer la liste des configurations à synchroniser
CONFS="${CONFS/,/ }"

# Extraction des adresses/CIDR
_V4_VIP=${V4_VIP}
_V6_VIP=${V6_VIP}
V4_VIP=${_V4_VIP%/*}
V6_VIP=${_V6_VIP%/*}
V4_VCIDR=${_V4_VIP#*/}
V6_VCIDR=${_V6_VIP#*/}
