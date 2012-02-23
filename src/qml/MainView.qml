/**************************************************************************
 *    Meneamigo
 *    Copyright (C) 2011 Simon Pena <spena@igalia.com>
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
    property real contentYPos: list.visibleArea.yPosition *
                               Math.max(list.height, list.contentHeight)
    property bool firstLoad: true
    property bool showListHeader: false
    property string baseKey: ''
    property variant votesMap: ({})

    function onLoadingFinished() {
        firstLoad = false
        showListHeader = false
    }

    Component.onCompleted: {
        categoriesModel.get(0).name = qsTr('Frontpage')
        categoriesModel.get(1).name = qsTr('Pending')
        asyncWorker.sendMessage({ method: MNM.METHOD_AUTH, url: MNM.BASE_URL })
    }

    WorkerScript {
        id: asyncWorker
        source: 'workerscript.js'

        onMessage: {
            parseResponse(messageObject)
        }
    }

    function parseResponse(messageObject) {
        var method = messageObject.method
        var response = messageObject.response

        if (method == MNM.METHOD_AUTH) {
            var pattern = 'base_key='
            var keyFirstIndex = response.indexOf('base_key="')
            var keyLastIndex = response.substr(keyFirstIndex + pattern.length + 1).indexOf('"')

            baseKey = response.substr(keyFirstIndex + pattern.length + 1, keyLastIndex)
        } else if (method == MNM.METHOD_VOTE) {
            var responseJSON = response.match(/{.*}/)
            var parsedResponse = JSON.parse(responseJSON)

            // TODO: This is inefficient according to
            // http://doc.qt.nokia.com/4.7-snapshot/qml-variant.html
            var tempMap = votesMap

            if (parsedResponse.error) {
                tempMap[messageObject.id] = MNM.VOTE_ERROR
            } else if (parsedResponse.vote_description){
                tempMap[messageObject.id] = MNM.VOTE_DONE
            }
            votesMap = tempMap
        }
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
                text: qsTr('About')
                onClicked: appWindow.pageStack.push(aboutView)
            }
        }
    }
    tools: ToolBarLayout {
        id: commonTools

        TumblerButton {
            anchors.horizontalCenter: parent.horizontalCenter
            text: qsTr(categorySelectionDialog.model.get(categorySelectionDialog.selectedIndex).name)
            onClicked: categorySelectionDialog.open()
        }

        ToolIcon {
            iconId: 'toolbar-view-menu'
            onClicked: (mainMenu.status == DialogStatus.Closed) ?
                           mainMenu.open() : mainMenu.close()
        }
    }

    Header {
        id: header
        onClicked: list.positionViewAtBeginning()
    }

    ListModel {
        id: categoriesModel
        ListElement { name: 'Frontpage' }
        ListElement { name: 'Pending' }
    }

    SelectionDialog {
        id: categorySelectionDialog
        titleText: qsTr('Category')
        selectedIndex: 0

        model: categoriesModel
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
        delegate: NewsDelegate {
            votedStatus: votesMap[model.mnm_link_id] ?
                             votesMap[model.mnm_link_id] :
                             MNM.VOTE_AVAILABLE
            onVote: {
                if (!votesMap[linkId]) {
                    var tempMap = votesMap
                    var voteUrl = MNM.getAnonymousVotingURL(baseKey, linkId)

                    tempMap[linkId] = MNM.VOTE_WAITING
                    votesMap = tempMap
                    asyncWorker.sendMessage({ method: MNM.METHOD_VOTE, url: voteUrl, id: linkId })
                }
            }
        }
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

    Column {
        id: listModelError
        anchors.centerIn: parent
        anchors.margins: UIConstants.DEFAULT_MARGIN
        visible: list.model.status == XmlListModel.Error
        spacing: UIConstants.PADDING_SMALL

        Text {
            id: listModelErrorText
            font.pixelSize: UIConstants.FONT_XLARGE
            font.family: UIConstants.FONT_FAMILY
            color: UIConstants.COLOR_BUTTON_DISABLED_FOREGROUND
            text: qsTr('Error while accessing Meneame')
        }

        Button {
            text: qsTr('Try again')
            anchors.horizontalCenter: listModelErrorText.horizontalCenter
            onClicked: {
                firstLoad = true
                list.model.reload()
            }
        }
    }

    ScrollDecorator {
        flickableItem: list
    }
}
