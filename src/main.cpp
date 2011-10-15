#include "controller.h"

#include <QApplication>
#include <QDeclarativeView>
#include <MDeclarativeCache>
#include <QTranslator>
#include <QTextCodec>
#include <QLocale>

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QApplication *app = MDeclarativeCache::qApplication(argc, argv);

    // Assume that strings in source files are UTF-8
    QTextCodec::setCodecForTr(QTextCodec::codecForName("utf8"));

    QString locale(QLocale::system().name());
    QTranslator translator;

    if (translator.load("l10n/meneamigo." + locale, ":/")) {
        app->installTranslator(&translator);
    }

    QDeclarativeView *view = MDeclarativeCache::qDeclarativeView();

    QDeclarativeContext *context = view->rootContext();
    Controller *controller = new Controller(context);
 
    view->setSource(QUrl("qrc:/qml/main.qml"));
    view->showFullScreen();

    int result = app->exec();

    delete controller;
    delete view;
    delete app;

    return result;
}
