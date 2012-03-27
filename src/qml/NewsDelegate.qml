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
import 'MNM.js' as MNM

Item {
    id: newsDelegate
    anchors {
        left: parent.left
        right: parent.right
        leftMargin: UIConstants.DEFAULT_MARGIN
        rightMargin: UIConstants.DEFAULT_MARGIN
    }
    height: content.height + 2 * UIConstants.PADDING_MEDIUM
    clip: true

    property bool showDetails: false
    property int votedStatus: MNM.VOTE_AVAILABLE
    signal vote(string linkId)
    signal clicked()
    signal pressAndHold()

    Column {
        id: content
        y: UIConstants.PADDING_MEDIUM
        width: parent.width
        spacing: UIConstants.PADDING_MEDIUM

        Row {
            width: parent.width
            height: childrenRect.height
            spacing: UIConstants.PADDING_LARGE

            Item {
                height: votesColumn.height
                width: votesColumn.width

                Column {
                    id: votesColumn
                    width: votesUpperArea.width
                    height: votesUpperArea.height + votesLowerArea.height
                    spacing: UIConstants.PADDING_SMALL

                    Item {
                        id: votesUpperArea

                        height: votesUpperColumn.height + UIConstants.PADDING_SMALL * 2
                        width: votesUpperColumn.width + UIConstants.PADDING_SMALL * 2

                        Rectangle {
                            anchors.fill: parent
                            color: MNM.BORDER_COLOR
                            radius: 10
                        }

                        Column {
                            id: votesUpperColumn
                            anchors.centerIn: parent

                            Label {
                                platformStyle: LabelStyle {
                                    fontPixelSize: model.mnm_votes < 1000 ?
                                                        UIConstants.FONT_DEFAULT :
                                                        UIConstants.FONT_LSMALL
                                }
                                text: model.mnm_votes +
                                      (votedStatus == MNM.VOTE_DONE ? 1 : 0)
                                anchors.horizontalCenter: parent.horizontalCenter
                                color: 'white'
                            }

                            Label {
                                platformStyle: LabelStyle {
                                    fontPixelSize: UIConstants.FONT_XXSMALL
                                    fontFamily: "Nokia Pure Text Light"
                                }
                                text: qsTr('shakes')
                                color: 'white'
                            }
                        }
                    }

                    Item {
                        id: votesLowerArea

                        height: shakeItText.height + UIConstants.PADDING_SMALL * 2
                        width: parent.width

                        Rectangle {
                            anchors.fill: parent
                            color: 'transparent'
                            radius: 5
                            border.width: 1
                            border.color: MNM.BORDER_COLOR
                        }

                        Label {
                            id: shakeItText
                            y: UIConstants.PADDING_SMALL
                            platformStyle: LabelStyle {
                                fontPixelSize: UIConstants.FONT_XXSMALL
                            }
                            text: if (votedStatus == MNM.VOTE_DONE) {
                                      qsTr('cool')
                                  } else if (votedStatus == MNM.VOTE_AVAILABLE) {
                                      qsTr('vote')
                                  } else if (votedStatus == MNM.VOTE_WAITING) {
                                      '...'
                                  } else {
                                      qsTr('error')
                                  }
                            anchors.horizontalCenter: parent.horizontalCenter
                            color: MNM.BORDER_COLOR
                        }
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (votedStatus == MNM.VOTE_AVAILABLE) {
                            newsDelegate.vote(model.mnm_link_id)
                        }
                    }
                }
            }

            Column {
                id: entryColumn
                width: parent.width - votesUpperArea.width
                spacing: UIConstants.PADDING_SMALL

                Item {
                    id: summaryItem
                    width: parent.width
                    height: summaryColumn.height

                    BorderImage {
                        anchors.fill: parent
                        visible: summaryItemMouseArea.pressed
                        source: 'image://theme/meegotouch-list-fullwidth-background-pressed-vertical-center'
                    }

                    Column {
                        id: summaryColumn
                        width: parent.width

                        Label {
                            id: titleText
                            platformStyle: LabelStyle {
                                fontPixelSize: UIConstants.FONT_SLARGE
                            }
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: model.title
                            color: 'darkblue'
                        }

                        Label {
                            platformStyle: LabelStyle {
                                fontPixelSize: UIConstants.FONT_XXSMALL
                                fontFamily: 'Nokia Pure Text Light'
                            }
                            width: parent.width
                            elide: Text.ElideRight
                            text: model.mnm_url
                        }
                    }

                    MouseArea {
                        id: summaryItemMouseArea
                        anchors.fill: summaryColumn
                        onClicked: newsDelegate.clicked()
                        onPressAndHold: newsDelegate.pressAndHold()
                    }
                }

                Item {
                    id: detailsItem
                    height: childrenRect.height
                    width: childrenRect.width

                    BorderImage {
                        anchors.fill: parent
                        visible: detailsItemMouseArea.pressed
                        source: 'image://theme/meegotouch-list-fullwidth-background-pressed-vertical-center'
                    }

                    MoreIndicator {
                        id: moreIndicator
                        anchors.left: parent.left
                        rotation: showDetails? -90 : 90

                        Behavior on rotation {
                            NumberAnimation { duration: 200 }
                        }
                    }

                    Label {
                        id: commentsText
                        platformStyle: LabelStyle {
                            fontPixelSize: UIConstants.FONT_XXSMALL
                            fontFamily: 'Nokia Pure Text Light'
                        }
                        anchors {
                            left: moreIndicator.right
                            leftMargin: UIConstants.PADDING_LARGE
                            verticalCenter: moreIndicator.verticalCenter
                        }
                        text: qsTr('%Ln comment(s)', '', model.mnm_comments)
                        color: MNM.BORDER_COLOR
                    }

                    Label {
                        platformStyle: LabelStyle {
                            fontPixelSize: UIConstants.FONT_XXSMALL
                            fontFamily: 'Nokia Pure Text Light'
                        }
                        anchors {
                            left: commentsText.right
                            leftMargin: UIConstants.PADDING_LARGE
                            verticalCenter: moreIndicator.verticalCenter
                        }
                        text: qsTr('By %1').arg(model.mnm_user)
                        color: UIConstants.COLOR_BUTTON_DISABLED_FOREGROUND
                    }

                    MouseArea {
                        id: detailsItemMouseArea
                        anchors.fill: parent
                        onClicked: showDetails = !showDetails
                    }
                }
            }
        }

        Item {
            id: extendedContent
            height: showDetails ?
                        extendedContentColumn.height + UIConstants.PADDING_LARGE * 2 :
                        0
            width: parent.width
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
                x: UIConstants.PADDING_MEDIUM
                y: UIConstants.PADDING_LARGE
                id: extendedContentColumn
                width: parent.width - UIConstants.PADDING_MEDIUM * 2

                Label {
                    platformStyle: LabelStyle {
                        fontPixelSize: UIConstants.FONT_SMALL
                    }
                    width: parent.width
                    wrapMode: Text.Wrap
                    text: model.description
                }

                Item {
                    width: parent.width
                    height: childrenRect.height

                    Label {
                        platformStyle: LabelStyle {
                            fontPixelSize: UIConstants.FONT_XSMALL
                        }
                        anchors.left: parent.left
                        text: 'karma: ' + model.mnm_karma
                        color: MNM.BORDER_COLOR
                    }

                    Label {
                        platformStyle: LabelStyle {
                            fontPixelSize: UIConstants.FONT_XSMALL
                        }
                        anchors.right: parent.right
                        text: Qt.formatDateTime(MNM.getDate(model.pubDate))
                        color: MNM.BORDER_COLOR
                    }
                }
            }
        }
    }
}
