#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include <QStandardPaths>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QString pluginPath;
#if defined(Q_OS_UNIX)
    pluginPath = QCoreApplication::applicationDirPath()+"/../spineqmlplugin/";
#elif defined(Q_OS_WIN)
    pluginPath = QCoreApplication::applicationDirPath()+"/../../spineqmlplugin/";
#endif

    QQmlApplicationEngine engine;
    engine.addImportPath(pluginPath);

    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    return app.exec();
}
