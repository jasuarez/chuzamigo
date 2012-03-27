/**************************************************************************
 *   Meneamigo
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

import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import 'constants.js' as UIConstants
import "MNM.js" as MNM

Page {
    Menu {
        id: commentsMenu
        MenuLayout {
            MenuItem {
                id: launchEntry
                text: qsTr('Open original news')
                onClicked: Qt.openUrlExternally(currentEntry.mnm_url)
            }
            MenuItem {
                id: jumpToFirst
                text: qsTr('Jump to beginning')
                onClicked: commentsList.positionViewAtBeginning()
            }
            MenuItem {
                id: jumpToLast
                text: qsTr('Jump to end')
                onClicked: commentsList.positionViewAtEnd()
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
            onClicked: (commentsMenu.status === DialogStatus.Closed) ?
                           commentsMenu.open() : commentsMenu.close()
        }
    }

    Header {
        id: header
        onClicked: commentsList.positionViewAtBeginning()
    }

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

        Item {
            id: extendedContent
            height: showDetails ?
                        extendedContentColumn.height + UIConstants.PADDING_LARGE * 2 :
                        0
            anchors {
                top: currentEntrySummary.bottom
                left: parent.left
                right: parent.right
                topMargin: UIConstants.PADDING_LARGE
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
                color: MNM.BUBBLE_COLOR
                radius: 10
                border.width: 2
                border.color: MNM.BORDER_COLOR
            }

            Column {
                id: extendedContentColumn
                x: UIConstants.PADDING_MEDIUM
                y: UIConstants.PADDING_LARGE
                width: parent.width - UIConstants.PADDING_MEDIUM * 2

                Text {
                    font.pixelSize: UIConstants.FONT_SMALL
                    font.family: UIConstants.FONT_FAMILY
                    width: parent.width
                    wrapMode: Text.WordWrap
                    text: currentEntry.description
                }

                Item {
                    width: parent.width
                    height: childrenRect.height

                    Text {
                        anchors.left: parent.left
                        font.pixelSize: UIConstants.FONT_XSMALL
                        font.family: UIConstants.FONT_FAMILY
                        text: qsTr('karma: %1 | By %2').arg(currentEntry.mnm_karma).arg(currentEntry.mnm_user)
                        color: MNM.BORDER_COLOR
                    }

                    Text {
                        anchors.right: parent.right
                        font.pixelSize: UIConstants.FONT_XSMALL
                        font.family: UIConstants.FONT_FAMILY
                        text: Qt.formatDateTime(MNM.getDate(currentEntry.pubDate))
                        color: MNM.BORDER_COLOR
                    }
                }
            }
        }

        Item {
            id: expander
            height: UIConstants.FIELD_DEFAULT_HEIGHT
            width: parent.width
            anchors {
                horizontalCenter: parent.horizontalCenter
                top: extendedContent.bottom
                topMargin: UIConstants.PADDING_SMALL
            }

            MouseArea {
                anchors.fill: parent
                onClicked: showDetails = !showDetails
            }

            MoreIndicator {
                id: moreIndicator
                anchors.centerIn: parent
                rotation: showDetails ? -90 : 90

                Behavior on rotation {
                    NumberAnimation { duration: 200 }
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
                    if (count > 0) {
                        parsedEntryComments.clear()
                        for (var i = count -1; i > 0; i --) {
                            var comment = new MNM.Comment(get(i).mnm_comment_id, get(i).mnm_link_id, get(i).mnm_order,
                                                          get(i).mnm_user, get(i).mnm_votes, get(i).mnm_karma, get(i).mnm_url,
                                                          get(i).title, get(i).link, get(i).pubDate,
                                                          get(i).dc_creator, get(i).guid, get(i).description)
                            parsedEntryComments.append(comment)
                        }
                    }
                    // FIXME: Setting a binding doesn't seem to work
                    noCommentsText.visible = (commentsList.model.count === 0)
                }
            }
        }

        ListModel {
            id: parsedEntryComments
        }

        Divider {
            id: divider
            anchors.top: expander.bottom
            text: (commentsList.model.status !== XmlListModel.Ready ?
                       qsTr('%Ln comment(s)', '', currentEntry.mnm_comments) :
                       qsTr('%Ln comment(s)', '', commentsList.model.count))
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
            model: parsedEntryComments
            opacity: entryComments.status == XmlListModel.Ready ? 1 : 0.5
            header: RefreshHeader {
                id: refreshHeader
                showHeader: showListHeader
                loading: commentsList.model.status === XmlListModel.Loading
                yPosition: contentYPos

                onClicked: {
                    entryComments.reload()
                }
            }
            footer: RefreshHeader {
                id: refreshFooter
                showHeader: true
                loading: commentsList.model.status === XmlListModel.Loading
                yPosition: 1
                onClicked: entryComments.reload()
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

            Text {
                id: noCommentsText
                font.pixelSize: UIConstants.FONT_XLARGE
                font.family: UIConstants.FONT_FAMILY
                color: UIConstants.COLOR_BUTTON_DISABLED_FOREGROUND
                anchors.centerIn: parent
                visible: false
                text: qsTr('No comments found')
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
