#include "controller.h"

#include <QApplication>
#include <QDeclarativeView>
#include <MDeclarativeCache>

Q_DECL_EXPORT int main(int argc, char *argv[])
{
    QApplication *app = MDeclarativeCache::qApplication(argc, argv);
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
