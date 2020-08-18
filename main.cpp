#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>

#include <timeline.h>
#include <timeline_player.h>
#include <vprocess.h>
#include <QIcon>

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    //Set appProps
    app.setOrganizationName("Kiarash");
    app.setOrganizationDomain("Kiarash.com");
    app.setApplicationName("VideoEditor");

    //Style
    QQuickStyle::setStyle("Fusion");

    //Icon
    //**later

    QQmlApplicationEngine engine;

    // Model Extraction
    TVideo_Model tVideo_Model;
    TAudio_Model tAudio_Model;
    TimeLine timeLine(&tVideo_Model, &tAudio_Model);
    TimeLine_Player TL_Player(tVideo_Model);
    VProcess vProcess(&timeLine);
    engine.rootContext()->setContextProperty("CppTimeLine", &timeLine);
    engine.rootContext()->setContextProperty("TL_Player", &TL_Player);
    engine.rootContext()->setContextProperty("VProcess", &vProcess);

    const QUrl url(QStringLiteral("qrc:/FrontEnd/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
