TEMPLATE = app

QT += qml quick

SOURCES += main.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

spine_folder.source = $$OUT_PWD/../spineqmlplugin/Spine
spine_folder.target = .
DEPLOYMENTFOLDERS += spine_folder

# Default rules for deployment.
include(deployment.pri)
qtcAddDeployment()

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
OTHER_FILES += \
    android/AndroidManifest.xml

