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
                width: parent.width - votesColumn.width - UIConstants.PADDING_LARGE
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

                        Row {
                            height: childrenRect.height
                            width: parent.width
                            spacing: UIConstants.PADDING_LARGE

                            Label {
                                platformStyle: LabelStyle {
                                    fontPixelSize: UIConstants.FONT_XXSMALL
                                    fontFamily: 'Nokia Pure Text Light'
                                }
                                text: qsTr('%Ln comment(s)', '', model.mnm_comments)
                                color: MNM.BORDER_COLOR
                            }

                            Label {
                                platformStyle: LabelStyle {
                                    fontPixelSize: UIConstants.FONT_XXSMALL
                                    fontFamily: 'Nokia Pure Text Light'
                                }
                                text: 'karma: ' + model.mnm_karma
                                color: MNM.BORDER_COLOR
                            }

                            Label {
                                platformStyle: LabelStyle {
                                    fontPixelSize: UIConstants.FONT_XXSMALL
                                    fontFamily: 'Nokia Pure Text Light'
                                }
                                text: Qt.formatDateTime(MNM.getDate(model.pubDate))
                                color: MNM.BORDER_COLOR
                            }
                        }
                    }

                    MouseArea {
                        id: summaryItemMouseArea
                        anchors.fill: summaryColumn
                        onClicked: newsDelegate.clicked()
                        onPressAndHold: newsDelegate.pressAndHold()
                    }
                }
            }
        }        
    }
}
