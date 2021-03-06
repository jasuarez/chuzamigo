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
    id: divider

    property alias text: dividerText.text

    anchors { left: parent.left; right: parent.right }
    anchors {
        leftMargin: UIConstants.DEFAULT_MARGIN
        rightMargin: UIConstants.DEFAULT_MARGIN
    }

    height: dividerText.height + UIConstants.DEFAULT_MARGIN

    Rectangle {
        id: dividerRectangle
        width: parent.width -
               dividerText.width -
               UIConstants.DEFAULT_MARGIN
        height: 1
        color: MNM.BORDER_COLOR
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        id: dividerText
        color: MNM.BORDER_COLOR
        font.pixelSize: UIConstants.FONT_XXSMALL
        font.family: "Nokia Pure Text Light"
        anchors.left: dividerRectangle.right
        anchors.leftMargin: UIConstants.DEFAULT_MARGIN
        anchors.verticalCenter: dividerRectangle.verticalCenter
        width: Math.min(2 * parent.width / 3, helperText.width)
        elide: Text.ElideRight
    }

    Text {
        id: helperText
        font.pixelSize: UIConstants.FONT_XXSMALL
        font.family: "Nokia Pure Text Light"
        text: dividerText.text
        visible: false
    }
}
