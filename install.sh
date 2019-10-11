#!/bin/bash

dpkg -l ucarp 2>/dev/null >/dev/null || apt -y install ucarp

rsync -a ssds_ha/ /usr/local/ssds_ha/

for f in vif.conf ha.cf vif_postup vif_predown  ; do
	[ -f /usr/local/ssds_ha/etc/${f} ] || cp /usr/local/ssds_ha/etc/${f}.dist /usr/local/ssds_ha/etc/${f}
done

[ -f /etc/network/interfaces.d/vif.conf ] || ln -s /usr/local/ssds_ha/etc/vif.conf /etc/network/interfaces.d/vif.conf
ln -fs /usr/local/ssds_ha/ha-state /usr/local/sbin
ln -fs /usr/local/ssds_ha/ha-sync /usr/local/sbin
ln -fs /usr/local/ssds_ha/ha-sync /etc/cron.hourly
