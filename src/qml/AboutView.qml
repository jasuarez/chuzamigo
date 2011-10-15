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
import "file:///usr/lib/qt4/imports/com/meego/UIConstants.js" as UIConstants

Page {
    property string license: 'This program is free software: you can redistribute it and/or modify ' +
        'it under the terms of the GNU General Public License as published by ' +
        'the Free Software Foundation, either version 3 of the License, or ' +
        '(at your option) any later version.<br /><br />' +

        'This package is distributed in the hope that it will be useful, ' +
        'but WITHOUT ANY WARRANTY; without even the implied warranty of ' +
        'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the ' +
        'GNU General Public License for more details.<br /><br />' +

        'You should have received a copy of the GNU General Public License ' +
        'along with this program. If not, see ' +
        '<a href="http://www.gnu.org/licenses">http://www.gnu.org/licenses</a><br /><br />'

    tools: ToolBarLayout {
        ToolIcon {
            id: backIcon
            iconId: 'toolbar-back'
            onClicked: pageStack.pop()
        }
    }

    Header { id: header }

    Flickable {
        id: flick
        clip: true
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        anchors {
            topMargin: UIConstants.PADDING_MEDIUM
            leftMargin: UIConstants.DEFAULT_MARGIN
            rightMargin: UIConstants.DEFAULT_MARGIN
        }
        contentHeight: contentColumn.height

        Column {
            id: contentColumn
            spacing: UIConstants.DEFAULT_MARGIN
            width: parent.width

            Image {
                id: aboutImage
                anchors.horizontalCenter: parent.horizontalCenter
                source: 'qrc:/resources/meneamigo.svg'
            }

            Text {
                id: aboutVersion
                text: 'Meneamigo 0.3'
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: UIConstants.FONT_FAMILY
                font.pixelSize: UIConstants.FONT_XLARGE
                color: !theme.inverted ?
                           UIConstants.COLOR_FOREGROUND :
                           UIConstants.COLOR_INVERTED_FOREGROUND
            }

            Text {
                id: aboutCopyright
                text: 'Copyright © 2011 Simon Pena'
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: UIConstants.FONT_FAMILY
                font.pixelSize: UIConstants.FONT_XLARGE
                color: !theme.inverted ?
                           UIConstants.COLOR_FOREGROUND :
                           UIConstants.COLOR_INVERTED_FOREGROUND
            }

            Text {
                id: aboutContact
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: UIConstants.FONT_FAMILY
                font.pixelSize: UIConstants.FONT_LSMALL
                color: !theme.inverted ?
                           UIConstants.COLOR_FOREGROUND :
                           UIConstants.COLOR_INVERTED_FOREGROUND
                text: '<a href="mailto:spena@igalia.com">spena@igalia.com</a> | ' +
                      '<a href="http://www.simonpena.com">simonpena.com</a>'
                onLinkActivated: Qt.openUrlExternally(link)
            }

            Text {
                id: aboutMeneameDisclaimer
                font.family: UIConstants.FONT_FAMILY
                font.pixelSize: UIConstants.FONT_LSMALL
                color: !theme.inverted ?
                           UIConstants.COLOR_FOREGROUND :
                           UIConstants.COLOR_INVERTED_FOREGROUND
                width: parent.width
                wrapMode: Text.WordWrap
                text: qsTr('This application uses <a href="http://meneame.net/">Meneame</a> but it is not affiliated nor certified by them.')
                onLinkActivated: Qt.openUrlExternally(link)
            }

            Text {
                id: aboutLicense
                font.pixelSize: UIConstants.FONT_LSMALL
                color: !theme.inverted ?
                           UIConstants.COLOR_FOREGROUND :
                           UIConstants.COLOR_INVERTED_FOREGROUND
                width: parent.width
                wrapMode: Text.WordWrap
                font.family: "Nokia Pure Text Light"
                text: license
                onLinkActivated: Qt.openUrlExternally(link)
            }
        }
        }

    ScrollDecorator {
        flickableItem: flick
        anchors.rightMargin: -UIConstants.DEFAULT_MARGIN
    }
}
