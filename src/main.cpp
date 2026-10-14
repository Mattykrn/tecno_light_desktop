#include "StoreController.hpp"

#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QCoreApplication::setOrganizationName(QStringLiteral("Tecno Light S.R.L."));
    QCoreApplication::setApplicationName(QStringLiteral("Tecno Light Desktop"));

    StoreController store;
    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty(QStringLiteral("store"), &store);
    engine.loadFromModule(QStringLiteral("TecnoLight"), QStringLiteral("Main"));

    if (engine.rootObjects().isEmpty()) {
        return 1;
    }
    return app.exec();
}