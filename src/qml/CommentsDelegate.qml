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

Item {
    id: newsDelegate
    anchors.left: parent.left
    anchors.right: parent.right
    anchors {
        leftMargin: UIConstants.DEFAULT_MARGIN
        rightMargin: UIConstants.DEFAULT_MARGIN
    }
    height: contentColumn.height + UIConstants.PADDING_LARGE * 2

    Rectangle {
        anchors.fill: parent
        anchors.margins: UIConstants.PADDING_SMALL
        color: MNM.BUBBLE_COLOR
        radius: 10
        border.width: 2
        border.color: MNM.BORDER_COLOR
    }

    Column {
        x: UIConstants.PADDING_LARGE
        y: UIConstants.PADDING_LARGE
        id: contentColumn
        width: parent.width - UIConstants.PADDING_LARGE * 2

        Text {
            y: UIConstants.PADDING_MEDIUM
            font.pixelSize: UIConstants.FONT_SMALL
            font.family: UIConstants.FONT_FAMILY
            width: parent.width
            wrapMode: Text.Wrap
            text: MNM.cleanUpComments(model.description)
            onLinkActivated: {
                // Internal links start with '/'
                if (MNM.startsWith(link, '/')) {
                    var commentNumber = parseInt(link.substr(1), 10)
                    // Make sure the internal link is to another comment
                    if (commentNumber) {
                        // Meneame comments start from #1 (since #0 is the entry itself)
                        var referredComment = commentsList.model.count - commentNumber
                        commentsList.positionViewAtIndex(referredComment, ListView.Beginning)
                    }
                } else {
                    Qt.openUrlExternally(link)
                }
            }
        }

        Item {
            width: parent.width
            height: childrenRect.height

            Text {
                anchors.left: parent.left
                font.pixelSize: UIConstants.FONT_XSMALL
                font.family: UIConstants.FONT_FAMILY
                color: MNM.BORDER_COLOR
                text: qsTr('#%1 | karma: %2 | By %3').arg(model.mnm_order).arg(model.mnm_karma).arg(model.mnm_user)
            }

            Text {
                anchors.right: parent.right
                font.pixelSize: UIConstants.FONT_XSMALL
                font.family: UIConstants.FONT_FAMILY
                text: Qt.formatDateTime(MNM.getDate(model.pubDate))
                color: MNM.BORDER_COLOR
            }
        }
    }
}
