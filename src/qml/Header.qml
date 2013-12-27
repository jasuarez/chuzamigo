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
    width: parent.width
    height: halfSize ? headerSize / 2 : headerSize

    property int headerSize: appWindow.inPortrait ?
                                 UIConstants.HEADER_DEFAULT_HEIGHT_PORTRAIT :
                                 UIConstants.HEADER_DEFAULT_HEIGHT_LANDSCAPE

    property bool halfSize: false

    signal clicked()

    BorderImage {
        id: background
        source: !headerMouseArea.pressed ?
                    'image://theme/color4-meegotouch-view-header-fixed' :
                    'image://theme/color4-meegotouch-view-header-fixed-pressed'
        anchors.fill: parent
    }

    Image {
        id: headerIcon
        x: UIConstants.DEFAULT_MARGIN
        anchors.verticalCenter: parent.verticalCenter
        source: 'qrc:/resources/icon-chuzamigo.png'
        visible: !halfSize
    }

    Label {
        id: headerText
        anchors {
            verticalCenter: parent.verticalCenter
            left: halfSize ? parent.left : headerIcon.right
            leftMargin: UIConstants.DEFAULT_MARGIN
        }
        platformStyle: LabelStyle {
            fontPixelSize: halfSize ? UIConstants.FONT_LSMALL : UIConstants.FONT_LARGE
        }
        text: 'Chuzamigo'
        color: 'white'
    }

    MouseArea {
        id: headerMouseArea
        anchors.fill: parent
        onClicked: parent.clicked()
    }
}
