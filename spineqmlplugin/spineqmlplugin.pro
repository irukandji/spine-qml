TEMPLATE = lib
TARGET = spineplugin
QT += qml quick
CONFIG += qt plugin no_keywords #since "slots" is used in spine-c source code. we have to use no_keywords to fix the compiling error

TARGET = $$qtLibraryTarget($$TARGET)
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

DESTDIR = Spine

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

copy_qmldir.target = $$OUT_PWD/$$DESTDIR/qmldir
copy_qmldir.depends = $$_PRO_FILE_PWD_/qmldir
copy_qmldir.commands = $(COPY_FILE) \"$$replace(copy_qmldir.depends, /, $$QMAKE_DIR_SEP)\" \"$$replace(copy_qmldir.target, /, $$QMAKE_DIR_SEP)\"
QMAKE_EXTRA_TARGETS += copy_qmldir
PRE_TARGETDEPS += $$copy_qmldir.target

qmldir.files = qmldir
unix {
    installPath = $$[QT_INSTALL_QML]/$$replace(uri, \\., /)
    qmldir.path = $$installPath
    target.path = $$installPath
    INSTALLS += target qmldir
}

RESOURCES += \
    resource.qrc

