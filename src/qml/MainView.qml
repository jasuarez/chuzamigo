import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import "file:///usr/lib/qt4/imports/com/meego/UIConstants.js" as UIConstants
import "MNM.js" as MNM

Page {
    property real contentYPos: list.visibleArea.yPosition *
                               Math.max(list.height, list.contentHeight)
    property bool firstLoad: true
    property bool showListHeader: false

    function onLoadingFinished() {
        firstLoad = false
        showListHeader = false
    }

    Component {
        id: aboutView
        AboutView { }
    }

    Menu {
        id: mainMenu
        MenuLayout {
            MenuItem {
                id: aboutEntry
                text: 'Acerca de'
                onClicked: appWindow.pageStack.push(aboutView)
            }
        }
    }
    tools: ToolBarLayout {
        id: commonTools

        TumblerButton {
            anchors.horizontalCenter: parent.horizontalCenter
            text: categorySelectionDialog.model.get(categorySelectionDialog.selectedIndex).name
            onClicked: categorySelectionDialog.open()
        }

        ToolIcon {
            iconId: 'toolbar-view-menu'
            onClicked: (mainMenu.status == DialogStatus.Closed) ?
                           mainMenu.open() : mainMenu.close()
        }
    }

    Header { id: header }

    SelectionDialog {
        id: categorySelectionDialog
        titleText: 'Categoría'
        selectedIndex: 0

        model: ListModel {
            ListElement { name: 'Portada' }
            ListElement { name: 'Pendientes' }
        }
    }

    NewsModel {
        id: publishedNews
        source: MNM.RSS_PUBLISHED
        onStatusChanged: {
            if (status == XmlListModel.Ready ||
                    status == XmlListModel.Error) {
                onLoadingFinished()
            }
        }
    }

    NewsModel {
        id: pendingNews
        source: MNM.RSS_PENDING
        onStatusChanged: {
            if (status == XmlListModel.Ready ||
                    status == XmlListModel.Error) {
                onLoadingFinished()
            }
        }
    }

    ListView {
        id: list
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        clip: true
        model: categorySelectionDialog.selectedIndex === 0 ? publishedNews : pendingNews
        delegate: NewsDelegate { }
        opacity: list.model.status == XmlListModel.Ready ? 1 : 0.5
        header: RefreshHeader {
            id: refreshHeader
            showHeader: showListHeader
            loading: list.model.status == XmlListModel.Loading
            yPosition: contentYPos

            onClicked: {
                list.model.reload()
            }
        }

        Connections {
            target: list.visibleArea
            onYPositionChanged: {
                if (contentYPos < 0 &&
                        !showListHeader &&
                        (list.moving && !list.flicking)) {
                    showListHeader = true
                    listTimer.start()
                }
            }
        }

        Timer {
            id: listTimer
            interval: MNM.REFRESH_HEADER_TIMEOUT
            onTriggered: {
                if (list.model.status != XmlListModel.Loading) {
                    onLoadingFinished()
                }
            }
        }

    }

    BusyIndicator {
        anchors.centerIn: parent
        visible: firstLoad && list.model.status == XmlListModel.Loading
        running: visible
        platformStyle: BusyIndicatorStyle { size: 'large' }
    }

    ScrollDecorator {
        flickableItem: list
    }
}
