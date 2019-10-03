TEMPLATE = app

QT += qml quick

SOURCES += main.cpp

RESOURCES += qml.qrc

# Qt 5.5 https://forum.qt.io/topic/56353/qt-5-5-opengl-link-errors/2
LIBS += -lopengl32 -lglu32

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

ios{
    LIBS += -L$$OUT_PWD/../spineqmlplugin/ -lspineplugin
    LIBS += -L$$OUT_PWD/../spine-c/ -lspine-c
    INCLUDEPATH += $$PWD/../spineqmlplugin/
}
else{
    spine_folder.source = $$OUT_PWD/../spineqmlplugin/Spine
    spine_folder.target = .
    DEPLOYMENTFOLDERS += spine_folder
}

# Default rules for deployment.
include(deployment.pri)
qtcAddDeployment()

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
OTHER_FILES += \
    android/AndroidManifest.xml

