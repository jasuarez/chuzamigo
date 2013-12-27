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

    Component.onCompleted: {
        aboutOptions.get(0).title = qsTr('Tell us what you think')
    }

    ListModel {
        id: aboutOptions
        ListElement {
            title: 'Cuéntanos tu opinión'
            action: 'openExternally'
            data: 'mailto:jasuarez@igalia.com?subject=Chuzamigo'
        }
    }

    Flickable {
        id: flick
        clip: true
        anchors.fill: parent
        anchors {
            topMargin: UIConstants.DEFAULT_MARGIN
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
                source: 'qrc:/resources/icon-about-chuzamigo.png'
            }

            Label {
                id: aboutVersion
                text: 'Chuzamigo 0.0.1'
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                platformStyle: LabelStyle {
                    fontPixelSize: UIConstants.FONT_XLARGE
                }
                color: UIConstants.COLOR_FOREGROUND
            }

            Rectangle {
                width: parent.width
                height: repeater.model.count * UIConstants.LIST_ITEM_HEIGHT_SMALL
                color: 'white'

                Column {
                    id: subcolumn
                    anchors.fill: parent
                    Repeater {
                        id: repeater
                        model: aboutOptions
                        Item {
                            height: UIConstants.LIST_ITEM_HEIGHT_SMALL
                            width: parent.width

                            BorderImage {
                                anchors.fill: parent
                                visible: mouseArea.pressed
                                source: 'image://theme/meegotouch-list-fullwidth-background-pressed-vertical-center'
                            }

                            Label {
                                anchors {
                                    left: parent.left
                                    leftMargin: UIConstants.DEFAULT_MARGIN
                                    verticalCenter: parent.verticalCenter
                                }
                                platformStyle: LabelStyle {
                                    fontPixelSize: UIConstants.FONT_SLARGE
                                }
                                text: model.title
                            }

                            MoreIndicator {
                                anchors {
                                    right: parent.right
                                    rightMargin: UIConstants.DEFAULT_MARGIN
                                    verticalCenter: parent.verticalCenter
                                }
                            }

                            Rectangle {
                                anchors.bottom: parent.bottom
                                width: parent.width
                                height: 1
                                color: UIConstants.COLOR_BUTTON_DISABLED_FOREGROUND
                                visible: index !== repeater.model.count - 1
                            }

                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                onClicked: {
                                    if (model.action === 'openStore') {
                                        controller.openStoreClient(model.data)
                                    } else if (model.action === 'openExternally') {
                                        Qt.openUrlExternally(model.data)
                                    }
                                }
                            }
                        }
                    }
                }

                BorderImage {
                    id: border
                    source: 'qrc:/resources/round-corners-shadow.png'
                    anchors.fill: parent
                    border { left: 18; top: 18; right: 18; bottom: 18 }
                }
            }

            Label {
                id: aboutCopyright
                text: 'Copyright © 2013 Juan A. Suarez Romero\nCopyright © 2011 - 2012 Simon Pena'
                width: parent.width
                horizontalAlignment: Text.AlignHCenter
                platformStyle: LabelStyle {
                    fontPixelSize: UIConstants.FONT_LSMALL
                    fontFamily: UIConstants.FONT_FAMILY_LIGHT
                }
                color: UIConstants.COLOR_FOREGROUND
            }

            Label {
                id: aboutDisclaimer
                text: qsTr('This application uses <a href="http://chuza.gl/">Chuza</a> ' +
                           'but it is not affiliated nor certified by them.')
                width: parent.width
                horizontalAlignment: Text.AlignJustify
                platformStyle: LabelStyle {
                    fontPixelSize: UIConstants.FONT_LSMALL
                    fontFamily: UIConstants.FONT_FAMILY_LIGHT
                }
                color: UIConstants.COLOR_FOREGROUND
                onLinkActivated: Qt.openUrlExternally(link)
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr('Licence')
                onClicked: licenseDialog.open()
            }
        }
    }

    QueryDialog {
        id: licenseDialog
        message: license
        acceptButtonText: 'OK'
    }

    ScrollDecorator {
        flickableItem: flick
        anchors.rightMargin: -UIConstants.DEFAULT_MARGIN
    }
}
