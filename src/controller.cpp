/**************************************************************************
 *   Chuzamigo
 *   Copyright (C) 2013 Juan A. Suarez Romero <jasuarez@igalia.com>
 *   Copyright (C) 2011 - 2012 Simon Pena <spena@igalia.com>
 *
 *   This program is free software: you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation, either version 3 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 **************************************************************************/

#include "controller.h"

#include <QDeclarativeContext>
#ifndef QT_SIMULATOR
    #include <maemo-meegotouch-interfaces/shareuiinterface.h>
    #include <MDataUri>
#endif

static const QString STORE_DBUS_IFACE("com.nokia.OviStoreClient");

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
#ifdef QT_SIMULATOR
    Q_UNUSED(title)
    Q_UNUSED(url)
    Q_UNUSED(description)
#else
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
#endif
}

void Controller::openStoreClient(const QString& url) const
{
    // Based on
    // https://gitorious.org/n9-apps-client/n9-apps-client/blobs/master/daemon/notificationhandler.cpp#line178
#ifdef QT_SIMULATOR
    Q_UNUSED(url)
#else
    QDBusInterface dbusInterface(STORE_DBUS_IFACE,
                                 "/",
                                 STORE_DBUS_IFACE,
                                 QDBusConnection::sessionBus());

    QStringList callParams;
    callParams << url;

    dbusInterface.asyncCall("LaunchWithLink", QVariant::fromValue(callParams));
#endif
}
