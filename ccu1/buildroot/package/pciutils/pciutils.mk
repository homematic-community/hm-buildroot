#############################################################
#
# pciutils
#
#############################################################
PCIUTILS_VER:=2.1.11
PCIUTILS_SOURCE:=pciutils-$(PCIUTILS_VER).tar.gz
PCIUTILS_SITE:=ftp://atrey.karlin.mff.cuni.cz/pub/linux/pci
PCIUTILS_DIR:=$(BUILD_DIR)/pciutils-$(PCIUTILS_VER)
PCIUTILS_CAT:=zcat

# Yet more targets...
PCIIDS_SITE:=http://pciids.sourceforge.net/
PCIIDS_SOURCE:=pci.ids.bz2
PCIIDS_CAT:=bzcat

$(DL_DIR)/$(PCIUTILS_SOURCE):
	 $(WGET) -P $(DL_DIR) $(PCIUTILS_SITE)/$(PCIUTILS_SOURCE)

$(DL_DIR)/$(PCIIDS_SOURCE):
	$(WGET) -P $(DL_DIR) $(PCIIDS_SITE)/$(PCIIDS_SOURCE)

pciutils-source: $(DL_DIR)/$(PCIUTILS_SOURCE) $(DL_DIR)/$(PCIIDS_SOURCE)

$(PCIUTILS_DIR)/.unpacked: $(DL_DIR)/$(PCIUTILS_SOURCE) $(DL_DIR)/$(PCIIDS_SOURCE)
	$(PCIUTILS_CAT) $(DL_DIR)/$(PCIUTILS_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	$(PCIIDS_CAT) $(DL_DIR)/$(PCIIDS_SOURCE) > $(PCIUTILS_DIR)/pci.id
	toolchain/patch-kernel.sh $(PCIUTILS_DIR) package/pciutils pciutils\*.patch
	touch $(PCIUTILS_DIR)/.unpacked

$(PCIUTILS_DIR)/.compiled: $(PCIUTILS_DIR)/.unpacked
	$(MAKE1) CC=$(TARGET_CC) OPT="$(TARGET_CFLAGS)" -C $(PCIUTILS_DIR)
	touch $(PCIUTILS_DIR)/.compiled

$(TARGET_DIR)/sbin/lspci: $(PCIUTILS_DIR)/.compiled
	install -c $(PCIUTILS_DIR)/lspci $(TARGET_DIR)/sbin/lspci

$(TARGET_DIR)/sbin/setpci: $(PCIUTILS_DIR)/.compiled
	install -c $(PCIUTILS_DIR)/setpci $(TARGET_DIR)/sbin/setpci

$(TARGET_DIR)/usr/share/misc/pci.ids: $(PCIUTILS_DIR)/.compiled
	install -Dc $(PCIUTILS_DIR)/pci.ids $(TARGET_DIR)/usr/share/misc/pci.ids

pciutils: uclibc $(TARGET_DIR)/sbin/setpci $(TARGET_DIR)/sbin/lspci $(TARGET_DIR)/usr/share/misc/pci.ids

pciutils-clean:
	rm $(TARGET_DIR)/sbin/lspci $(TARGET_DIR)/sbin/setpci $(TARGET_DIR)/usr/share/misc/pci.ids
	-$(MAKE) -C $(PCIUTILS_DIR) clean

pciutils-dirclean:
	rm -rf $(PCIUTILS_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_PCIUTILS)),y)
TARGETS+=pciutils
endif
