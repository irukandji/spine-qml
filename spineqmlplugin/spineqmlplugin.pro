TEMPLATE = lib
TARGET = spineplugin
QT += qml quick
CONFIG += qt plugin no_keywords #since "slots" is used in spine-c source code. we have to use no_keywords to fix the compiling error
ios: CONFIG += static
!ios:TARGET = $$qtLibraryTarget($$TARGET)
uri = Spine

# Input
SOURCES += \
    spineplugin_plugin.cpp \
    texture.cpp \
    skeletonrenderer.cpp \
    rendercmdscache.cpp \
    skeletonanimationfbo.cpp \
    spineevent.cpp

HEADERS += \
    spineplugin_plugin.h \
    texture.h \
    skeletonrenderer.h \
    rendercmdscache.h \
    skeletonanimationfbo.h \
    spineevent.h

OTHER_FILES = qmldir

!android:!ios:DESTDIR = Spine

win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../spine-c/release/ -lspine-c
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../spine-c/debug/ -lspine-c
else:unix: LIBS += -L$$OUT_PWD/../spine-c/ -lspine-c

INCLUDEPATH += $$PWD/../spine-c/include/
DEPENDPATH += $$PWD/../spine-c/include/

win32-g++:CONFIG(release, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../spine-c/release/libspine-c.a
else:win32-g++:CONFIG(debug, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../spine-c/debug/libspine-c.a
else:win32:!win32-g++:CONFIG(release, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../spine-c/release/spine-c.lib
else:win32:!win32-g++:CONFIG(debug, debug|release): PRE_TARGETDEPS += $$OUT_PWD/../spine-c/debug/spine-c.lib
else:unix: PRE_TARGETDEPS += $$OUT_PWD/../spine-c/libspine-c.a

qml_folder.source = $$PWD/Spine
qml_folder.target = .
DEPLOYMENTFOLDERS += qml_folder

RESOURCES += resource.qrc

include(../example/deployment.pri)
qtcAddDeployment()

# Qt 5.5 https://forum.qt.io/topic/56353/qt-5-5-opengl-link-errors/2
LIBS += -lopengl32 -lglu32
