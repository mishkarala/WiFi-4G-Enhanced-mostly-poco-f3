SKIPMOUNT=false
PROPFILE=true
POSTFSDATA=true
LATESTARTSERVICE=true

REPLACE=""

on_install() {

  ui_print " "
  ui_print " Installing WiFi Enhance v4"
  ui_print " "

  unzip -o "$ZIPFILE" -d $MODPATH >&2

  ui_print "- Android SDK: $(getprop ro.build.version.sdk)"
  ui_print "- Device: $(getprop ro.product.device)"
  ui_print "- SOC: $(getprop ro.soc.model)"
  ui_print "- Kernel: $(uname -r)"

  ui_print " "
  ui_print "- Adaptive network engine installed"
  ui_print " "
}

set_permissions() {
  set_perm_recursive $MODPATH 0 0 0755 0644
  set_perm $MODPATH/service.sh 0 0 0755
  set_perm $MODPATH/post-fs-data.sh 0 0 0755
}