#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QDebug>
#include <QStandardPaths>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

#ifdef Q_OS_ANDROID
    engine.addImportPath(QLatin1String("assets:/"));
    engine.addPluginPath(QStandardPaths::standardLocations(QStandardPaths::HomeLocation).at(0) + "/../lib");
#elif defined(Q_OS_OSX)
    engine.addImportPath(QCoreApplication::applicationDirPath()+"/../Resources/");
#elif defined(Q_OS_WIN32)
    engine.addImportPath(QCoreApplication::applicationDirPath()+"/..");
#endif

    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    return app.exec();
}
