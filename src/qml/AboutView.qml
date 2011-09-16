import QtQuick 1.1
import com.nokia.meego 1.0
import "file:///usr/lib/qt4/imports/com/meego/UIConstants.js" as UIConstants

Page {
    property string license: '<i>This program is free software: you can redistribute it and/or modify ' +
        'it under the terms of the GNU General Public License as published by ' +
        'the Free Software Foundation, either version 3 of the License, or ' +
        '(at your option) any later version.<br /><br />' +

        'This package is distributed in the hope that it will be useful, ' +
        'but WITHOUT ANY WARRANTY; without even the implied warranty of ' +
        'MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the ' +
        'GNU General Public License for more details.<br /><br />' +

        'You should have received a copy of the GNU General Public License ' +
        'along with this program. If not, see ' +
        '<a href="http://www.gnu.org/licenses">http://www.gnu.org/licenses</a></i><br /><br />'

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

        contentHeight: aboutImage.height +
                       aboutVersion.height +
                       aboutCopyright.height +
                       aboutContact.height +
                       aboutMeneameDisclaimer.height +
                       aboutLicense.height +
                       UIConstants.DEFAULT_MARGIN * 2

        Image {
            id: aboutImage
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            source: 'qrc:/resources/meneamigo.svg'
        }

        Text {
            id: aboutVersion
            text: 'Meneamigo 0.1'
            anchors.top: aboutImage.bottom
            anchors.topMargin: UIConstants.DEFAULT_MARGIN
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: UIConstants.FONT_XLARGE
            color: !theme.inverted ?
                       UIConstants.COLOR_FOREGROUND :
                       UIConstants.COLOR_INVERTED_FOREGROUND
        }

        Text {
            id: aboutCopyright
            text: 'Copyright © 2011 Simon Pena'
            anchors.top: aboutVersion.bottom
            anchors.topMargin: UIConstants.DEFAULT_MARGIN
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: UIConstants.FONT_XLARGE
            color: !theme.inverted ?
                       UIConstants.COLOR_FOREGROUND :
                       UIConstants.COLOR_INVERTED_FOREGROUND
        }

        Text {
            id: aboutContact
            anchors.top: aboutCopyright.bottom
            anchors.topMargin: UIConstants.DEFAULT_MARGIN
            anchors.horizontalCenter: parent.horizontalCenter
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
            anchors.top: aboutContact.bottom
            anchors.topMargin: UIConstants.DEFAULT_MARGIN
            font.pixelSize: UIConstants.FONT_LSMALL
            color: !theme.inverted ?
                       UIConstants.COLOR_FOREGROUND :
                       UIConstants.COLOR_INVERTED_FOREGROUND
            width: parent.width
            wrapMode: Text.WordWrap
            text: 'Esta aplicación usa <a href="http://meneame.net/">Menéame</a> pero no está afiliado ni certificado por ellos.'
            onLinkActivated: Qt.openUrlExternally(link)
        }

        Text {
            id: aboutLicense
            anchors.top: aboutMeneameDisclaimer.bottom
            anchors.topMargin: UIConstants.DEFAULT_MARGIN
            font.pixelSize: UIConstants.FONT_LSMALL
            color: !theme.inverted ?
                       UIConstants.COLOR_FOREGROUND :
                       UIConstants.COLOR_INVERTED_FOREGROUND
            width: parent.width
            wrapMode: Text.WordWrap
            text: license
            onLinkActivated: Qt.openUrlExternally(link)
        }
    }

    ScrollDecorator {
        flickableItem: flick
        anchors.rightMargin: -UIConstants.DEFAULT_MARGIN
    }
}
