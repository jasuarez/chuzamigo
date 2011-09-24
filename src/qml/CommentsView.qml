import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import "file:///usr/lib/qt4/imports/com/meego/UIConstants.js" as UIConstants
import "MNM.js" as MNM

Page {
    Menu {
        id: commentsMenu
        MenuLayout {
            MenuItem {
                id: launchEntry
                text: 'Ver noticia original'
                onClicked: Qt.openUrlExternally(currentEntry.mnm_url)
            }
        }
    }
    tools: ToolBarLayout {
        ToolIcon {
            iconId: 'toolbar-back'
            onClicked: pageStack.pop()
        }
        ToolIcon {
            iconId: 'toolbar-share'
            onClicked: {
                controller.share(currentEntry.title, currentEntry.mnm_url, currentEntry.description)
            }
        }
        ToolIcon {
            iconId: 'toolbar-view-menu'
            onClicked: (commentsMenu.status == DialogStatus.Closed) ?
                           commentsMenu.open() : commentsMenu.close()
        }
    }

    Header { id: header }

    property variant currentEntry
    property real contentYPos: commentsList.visibleArea.yPosition *
                               Math.max(commentsList.height, commentsList.contentHeight)
    property bool firstLoad: true
    property bool showListHeader: false
    property bool showDetails: false

    function onLoadingFinished() {
        firstLoad = false
        showListHeader = false
    }

    Item {
        id: content
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        Column {
            id: currentEntrySummary
            y: UIConstants.PADDING_MEDIUM
            anchors.left: parent.left
            anchors.right: parent.right
            anchors {
                leftMargin: UIConstants.DEFAULT_MARGIN
                rightMargin: UIConstants.DEFAULT_MARGIN
            }

            Text {
                font.pixelSize: UIConstants.FONT_SLARGE
                font.family: UIConstants.FONT_FAMILY
                width: parent.width
                wrapMode: Text.WordWrap
                text: currentEntry.title
                color: 'darkblue'
            }

            Text {
                font.pixelSize: UIConstants.FONT_XXSMALL
                font.family: "Nokia Pure Text Light"
                width: parent.width
                elide: Text.ElideRight
                text: currentEntry.mnm_url
            }
        }

        MouseArea {
            anchors.fill: currentEntrySummary
            onClicked: showDetails = !showDetails
        }

        Item {
            id: extendedContent
            height: showDetails ?
                        extendedContentColumn.height + UIConstants.PADDING_LARGE * 2 :
                        0
            anchors {
                top: currentEntrySummary.bottom
                left: parent.left
                right: parent.right
            }
            anchors {
                topMargin: height > 0 ? UIConstants.PADDING_LARGE : 0
                leftMargin: UIConstants.DEFAULT_MARGIN
                rightMargin: UIConstants.DEFAULT_MARGIN
            }
            opacity: showDetails ? 1 : 0

            Behavior on height {
                NumberAnimation { duration: 200 }
            }

            Behavior on opacity {
                NumberAnimation { duration: 200 }
            }

            Rectangle {
                anchors.fill: parent
                color: '#f8dcc0'
                radius: 10
                border.width: 2
                border.color: 'darkorange'
            }

            Column {
                x: UIConstants.PADDING_MEDIUM
                y: UIConstants.PADDING_LARGE
                id: extendedContentColumn
                width: parent.width - UIConstants.PADDING_MEDIUM * 2

                Text {
                    font.pixelSize: UIConstants.FONT_SMALL
                    font.family: UIConstants.FONT_FAMILY
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: currentEntry.description
                }

                Text {
                    font.pixelSize: UIConstants.FONT_XSMALL
                    font.family: UIConstants.FONT_FAMILY
                    text: 'karma: ' + currentEntry.mnm_karma + ' | ' +
                          Qt.formatDateTime(MNM.getDate(currentEntry.pubDate))
                    color: 'darkorange'
                }
            }
        }

        CommentsModel {
            id: entryComments
            source: MNM.RSS_COMMENTS + currentEntry.mnm_link_id
            onStatusChanged: {
                if (status == XmlListModel.Ready ||
                        status == XmlListModel.Error) {
                    onLoadingFinished()
                }
            }
        }

        Divider {
            id: divider
            anchors.top: extendedContent.bottom
            text: commentsList.model.count + ' comentarios'
        }

        ListView {
            id: commentsList
            anchors {
                top: divider.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            clip: true
            delegate: CommentsDelegate { }
            model: entryComments
            opacity: entryComments.status == XmlListModel.Ready ? 1 : 0.5
            header: RefreshHeader {
                id: refreshHeader
                showHeader: showListHeader
                loading: commentsList.model.status == XmlListModel.Loading
                yPosition: contentYPos

                onClicked: {
                    commentsList.model.reload()
                }
            }

            onFlickStarted: {
                showDetails = false
            }

            Connections {
                target: commentsList.visibleArea
                onYPositionChanged: {
                    if (contentYPos < 0 &&
                            !showListHeader &&
                            (commentsList.moving && !commentsList.flicking)) {
                        showListHeader = true
                        listTimer.start()
                    }
                }
            }

            Timer {
                id: listTimer
                interval: 3000
                onTriggered: {
                    if (commentsList.model.status != XmlListModel.Loading) {
                        onLoadingFinished()
                    }
                }
            }
        }

        BusyIndicator {
            anchors.centerIn: parent
            visible: firstLoad && entryComments.status == XmlListModel.Loading
            running: visible
            platformStyle: BusyIndicatorStyle { size: 'large' }
        }

        ScrollDecorator {
            flickableItem: commentsList
        }
    }
}
