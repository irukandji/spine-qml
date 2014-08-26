TEMPLATE = subdirs
CONFIG += ordered
SUBDIRS = spine-c spineqmlplugin example

spineqmlplugin.depends = spine-c
