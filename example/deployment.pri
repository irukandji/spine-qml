defineTest(qtcAddDeployment) {
    android-no-sdk {
        installPrefix = /data/user/qt

        target.path = /data/user/qt
        export(target.path)
        INSTALLS += target
    } else:android {
        installPrefix = /assets

        x86 {
            target.path = /libs/x86
        } else: armeabi-v7a {
            target.path = /libs/armeabi-v7a
        } else {
            target.path = /libs/armeabi
        }

        export(target.path)
        INSTALLS += target
    } else:win32 {
        copyCommand =
        for(deploymentfolder, DEPLOYMENTFOLDERS) {
            source = $$eval($${deploymentfolder}.source)
            source = $$replace(source, /, \\)
            sourcePathSegments = $$split(source, \\)
            target = $$OUT_PWD/$$eval($${deploymentfolder}.target)/$$last(sourcePathSegments)
            target = $$replace(target, /, \\)
            target ~= s,\\\\\\.?\\\\,\\,
            !isEqual(source,$$target) {
                !isEmpty(copyCommand):copyCommand += &&
                copyCommand += $(COPY_DIR) \"$$source\" \"$$target\"
            }
        }
        !isEmpty(copyCommand) {
            copyCommand = @echo Copying application data... && $$copyCommand
            copydeploymentfolders.commands = $$copyCommand
            first.depends = $(first) copydeploymentfolders
            export(first.depends)
            export(copydeploymentfolders.commands)
            QMAKE_EXTRA_TARGETS += first copydeploymentfolders
        }
    } else:ios {
        copyCommand =
        for(deploymentfolder, DEPLOYMENTFOLDERS) {
            source = $$eval($${deploymentfolder}.source)
            source = $$replace(source, \\\\, /)
            !CONFIG(plugin) {
                target = $CODESIGNING_FOLDER_PATH/$$eval($${deploymentfolder}.target)
            } else {
                target = $$OUT_PWD/$$eval($${deploymentfolder}.target)
            }
            target = $$replace(target, \\\\, /)
            sourcePathSegments = $$split(source, /)
            targetFullPath = $$target/$$last(sourcePathSegments)
            targetFullPath ~= s,/\\.?/,/,
            !isEqual(source,$$targetFullPath) {
                !isEmpty(copyCommand):copyCommand += &&
                copyCommand += mkdir -p \"$$target\"
                copyCommand += && cp -r \"$$source\" \"$$target\"
            }
        }
        !isEmpty(copyCommand) {
            copyCommand = echo Copying application data... && $$copyCommand
            !isEmpty(QMAKE_POST_LINK): QMAKE_POST_LINK += ";"
            QMAKE_POST_LINK += "$$copyCommand"
            export(QMAKE_POST_LINK)
        }
    } else:unix {
        copyCommand =
        for(deploymentfolder, DEPLOYMENTFOLDERS) {
            source = $$eval($${deploymentfolder}.source)
            source = $$replace(source, \\\\, /)
            macx:!CONFIG(plugin) {
                target = $$OUT_PWD/$${TARGET}.app/Contents/Resources/$$eval($${deploymentfolder}.target)
            } else {
                target = $$OUT_PWD/$$eval($${deploymentfolder}.target)
            }
            target = $$replace(target, \\\\, /)
            sourcePathSegments = $$split(source, /)
            targetFullPath = $$target/$$last(sourcePathSegments)
            targetFullPath ~= s,/\\.?/,/,
            !isEqual(source,$$targetFullPath) {
                !isEmpty(copyCommand):copyCommand += &&
                copyCommand += $(MKDIR) \"$$target\"
                copyCommand += && $(COPY_DIR) \"$$source\" \"$$target\"
            }
        }
        !isEmpty(copyCommand) {
            copyCommand = @echo Copying application data... && $$copyCommand
            copydeploymentfolders.commands = $$copyCommand
            first.depends = $(first) copydeploymentfolders
            export(first.depends)
            export(copydeploymentfolders.commands)
            QMAKE_EXTRA_TARGETS += first copydeploymentfolders
        }
        !isEmpty(target.path) {
            installPrefix = $${target.path}
        } else {
            installPrefix = /opt/$${TARGET}
        }

        isEmpty(target.path) {
            target.path = $${installPrefix}/bin
            export(target.path)
        }
        INSTALLS += target
    }

    for(deploymentfolder, DEPLOYMENTFOLDERS) {
        item = item$${deploymentfolder}
        itemfiles = $${item}.files
        $$itemfiles = $$eval($${deploymentfolder}.source)
        itempath = $${item}.path
        $$itempath = $${installPrefix}/$$eval($${deploymentfolder}.target)
        export($$itemfiles)
        export($$itempath)
        INSTALLS += $$item
    }

    export (INSTALLS)
    export (QMAKE_EXTRA_TARGETS)
}
