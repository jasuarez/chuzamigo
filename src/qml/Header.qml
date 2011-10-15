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
import com.nokia.extras 1.0
import "file:///usr/lib/qt4/imports/com/meego/UIConstants.js" as UIConstants

Item {
    height: headerRectangle.height
    width: parent.width

    signal clicked()

    Rectangle {
        id: headerRectangle
        width: parent.width
        height: appWindow.inPortrait ?
                    UIConstants.HEADER_DEFAULT_HEIGHT_PORTRAIT :
                    52
        // UIConstants.HEADER_DEFAULT_HEIGHT_LANDSCAPE doesn't seem to be used in the system
        color: 'darkorange'
    }

    Image {
        id: headerIcon
        x: UIConstants.DEFAULT_MARGIN
        anchors.verticalCenter: headerRectangle.verticalCenter
        source: 'qrc:/resources/icon-meneamigo.png'
    }

    Text {
        id: headerText
        anchors.top: parent.top
        anchors.topMargin: appWindow.inPortrait ?
                               UIConstants.HEADER_DEFAULT_TOP_SPACING_PORTRAIT :
                               UIConstants.HEADER_DEFAULT_TOP_SPACING_LANDSCAPE
        anchors.left: headerIcon.right
        anchors.leftMargin: UIConstants.DEFAULT_MARGIN
        font.pixelSize: UIConstants.FONT_LARGE
        font.family: UIConstants.FONT_FAMILY
        text: 'Meneamigo'
        color: 'white'
    }

    MouseArea {
        id: headerMouseArea
        anchors.fill: parent
        onClicked: parent.clicked()
    }
}
