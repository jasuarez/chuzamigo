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

import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.1
import 'constants.js' as UIConstants
import "MNM.js" as MNM

Item {
    id: newsDelegate
    anchors.left: parent.left
    anchors.right: parent.right
    anchors {
        leftMargin: UIConstants.DEFAULT_MARGIN
        rightMargin: UIConstants.DEFAULT_MARGIN
    }
    height: expanded || !useExpander ?
                actualSize :
                Math.min(actualSize, collapsedSize)

    Behavior on height {
        NumberAnimation { duration: 200 }
    }

    property bool useExpander: false
    property int actualSize: contentColumn.height + UIConstants.PADDING_LARGE * 2
    property int collapsedSize: 160
    property bool expanded: false

    Rectangle {
        anchors.fill: parent
        anchors.margins: UIConstants.PADDING_SMALL
        color: MNM.BUBBLE_COLOR
        radius: 10
    }

    Item {
        id: contentWrapper
        clip: true
        width: parent.width
        height: parent.height - UIConstants.DEFAULT_MARGIN

        Column {
            x: UIConstants.PADDING_LARGE
            y: UIConstants.PADDING_LARGE
            id: contentColumn
            width: parent.width - UIConstants.PADDING_LARGE * 2

            Item {
                width: parent.width
                height: childrenRect.height

                Label {
                    anchors.left: parent.left
                    platformStyle: LabelStyle {
                        fontPixelSize: UIConstants.FONT_XSMALL
                    }
                    color: MNM.BORDER_COLOR
                    text: qsTr('#%1 | karma: %2 | By %3').arg(model.mnm_order).arg(model.mnm_karma).arg(model.mnm_user)
                }

                Label {
                    anchors.right: parent.right
                    platformStyle: LabelStyle {
                        fontPixelSize: UIConstants.FONT_XSMALL
                    }
                    text: Qt.formatDateTime(MNM.getDate(model.pubDate))
                    color: MNM.BORDER_COLOR
                }
            }

            Label {
                y: UIConstants.PADDING_MEDIUM
                platformStyle: LabelStyle {
                    fontPixelSize: UIConstants.FONT_SMALL
                }
                width: parent.width
                wrapMode: Text.Wrap
                text: MNM.cleanUpComments(model.description)
                onLinkActivated: {
                    // Internal links start with '/'
                    if (MNM.startsWith(link, '/')) {
                        var commentNumber = parseInt(link.substr(1), 10)
                        // Make sure the internal link is to another comment
                        if (commentNumber) {
                            // Chuza comments start from #1 (since #0 is the entry itself)
                            var referredComment = commentNumber - 1
                            commentsList.positionViewAtIndex(referredComment, ListView.Beginning)
                        }
                    } else {
                        Qt.openUrlExternally(link)
                    }
                }
            }
        }
    }

    Item {
        height: UIConstants.FIELD_DEFAULT_HEIGHT
        width: parent.width
        visible: (actualSize > collapsedSize) && useExpander
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: UIConstants.PADDING_SMALL
        }

        Rectangle {
            width: parent.width - UIConstants.DEFAULT_MARGIN
            height: moreIndicator.height
            anchors.bottom: parent.bottom
            color: MNM.BUBBLE_COLOR
            opacity: 0.95
        }

        MouseArea {
            anchors.fill: parent
            onClicked: expanded = !expanded
        }

        MoreIndicator {
            id: moreIndicator
            anchors.centerIn: parent
            rotation: expanded ? -90 : 90

            Behavior on rotation {
                NumberAnimation { duration: 200 }
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        anchors.margins: UIConstants.PADDING_SMALL
        color: 'transparent'
        radius: 10
        border.width: 2
        border.color: MNM.BORDER_COLOR
    }
}
