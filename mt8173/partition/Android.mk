ifeq ($(strip $(MTK_PLATFORM)), MT8173)

LOCAL_PATH := $(call my-dir)

PARTITION := $(LOCAL_PATH)/partition.xml
PARTITION_IMG := $(PRODUCT_OUT)/MBR
SCATTER_FILE := $(PRODUCT_OUT)/$(MTK_PLATFORM)_Android_scatter.txt

$(PARTITION_IMG) $(SCATTER_FILE): $(PARTITION)
	$(hide) MTK_IN_HOUSE_TEE_SUPPORT=$(MTK_IN_HOUSE_TEE_SUPPORT) device/mediatek/build/build/tools/partition/gen-partition.py $< $(PARTITION_IMG) $(SCATTER_FILE)

.PHONY: partition
droidcore partition: $(PARTITION_IMG) $(SCATTER_FILE)

endif
