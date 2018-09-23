CUR_PATH := device/mediatek/common/keymapping

PRODUCT_COPY_FILES += \
	$(CUR_PATH)/keymapping.sh:system/xbin/keymapping.sh \
	$(CUR_PATH)/keymapping.properties:system/xbin/keymapping.properties \
	$(CUR_PATH)/softwin_config.properties:system/xbin/softwin_config.properties \
        $(CUR_PATH)/Vendor_0001_Product_0001.idc:system/usr/idc/Vendor_0001_Product_0001.idc

