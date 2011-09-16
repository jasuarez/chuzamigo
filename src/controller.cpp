#include "controller.h"

#include <QDeclarativeContext>
#include <maemo-meegotouch-interfaces/shareuiinterface.h>
#include <MDataUri>

Controller::Controller(QDeclarativeContext *context) :
    QObject(),
    m_declarativeContext(context)
{
    m_declarativeContext->setContextProperty("controller", this);
}

Controller::~Controller()
{
}

void Controller::share(QString title, QString url, QString description)
{
    // See https://meego.gitorious.org/meego-sharing-framework/share-ui/blobs/master/examples/link-share/page.cpp
    // and http://forum.meego.com/showthread.php?t=3768
    MDataUri dataUri;
    dataUri.setMimeType("text/x-url");
    dataUri.setTextData(url);
    dataUri.setAttribute("title", title);
    dataUri.setAttribute("description", description);

    QStringList items;
    items << dataUri.toString();
    ShareUiInterface shareIf("com.nokia.ShareUi");
    if (shareIf.isValid()) {
        shareIf.share(items);
    } else {
        qCritical() << "Invalid interface";
    }
}
