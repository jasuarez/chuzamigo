import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import "file:///usr/lib/qt4/imports/com/meego/UIConstants.js" as UIConstants
import "MNM.js" as MNM

Item {
    id: newsDelegate
    anchors.left: parent.left
    anchors.right: parent.right
    anchors {
        leftMargin: UIConstants.DEFAULT_MARGIN
        rightMargin: UIConstants.DEFAULT_MARGIN
    }
    height: content.height + 2 * UIConstants.PADDING_MEDIUM

    property bool showDetails: false
    property int votedStatus: MNM.VOTE_AVAILABLE
    signal vote(string linkId)

    Component {
        id: commentsView
        CommentsView { }
    }

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
                            color: 'darkorange'
                            radius: 10
                        }

                        Column {
                            id: votesUpperColumn
                            anchors.centerIn: parent

                            Text {
                                font.pixelSize: model.mnm_votes < 1000 ?
                                                    UIConstants.FONT_DEFAULT :
                                                    UIConstants.FONT_LSMALL
                                font.family: UIConstants.FONT_FAMILY
                                text: model.mnm_votes +
                                      (votedStatus == MNM.VOTE_DONE ? 1 : 0)
                                anchors.horizontalCenter: parent.horizontalCenter
                                color: 'white'
                            }

                            Text {
                                font.pixelSize: UIConstants.FONT_XXSMALL
                                font.family: "Nokia Pure Text Light"
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
                            border.color: 'darkorange'
                        }

                        Text {
                            id: shakeItText
                            y: UIConstants.PADDING_SMALL
                            font.pixelSize: UIConstants.FONT_XXSMALL
                            font.family: UIConstants.FONT_FAMILY
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
                            color: 'darkorange'
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
                        source: 'image://theme/meegotouch-list-background-pressed-vertical-center'
                    }

                    Column {
                        id: summaryColumn
                        width: parent.width

                        Text {
                            id: titleText
                            font.pixelSize: UIConstants.FONT_SLARGE
                            font.family: UIConstants.FONT_FAMILY
                            width: parent.width
                            wrapMode: Text.WordWrap
                            text: model.title
                            color: 'darkblue'
                        }

                        Text {
                            font.pixelSize: UIConstants.FONT_XXSMALL
                            font.family: "Nokia Pure Text Light"
                            width: parent.width
                            elide: Text.ElideRight
                            text: model.mnm_url
                        }
                    }

                    MouseArea {
                        id: summaryItemMouseArea
                        anchors.fill: summaryColumn
                        onClicked: appWindow.pageStack.push(commentsView,
                                                           { currentEntry: model })
                    }
                }

                Item {
                    id: detailsItem
                    height: childrenRect.height
                    width: childrenRect.width

                    BorderImage {
                        anchors.fill: parent
                        visible: detailsItemMouseArea.pressed
                        source: 'image://theme/meegotouch-list-background-pressed-vertical-center'
                    }

                    Image {
                        id: detailsImage
                        source: 'qrc:/resources/icon-view-details.png'
                    }

                    Item {
                        id: commentsArea
                        anchors.left: detailsImage.right
                        anchors.leftMargin: UIConstants.PADDING_LARGE
                        width: childrenRect.width
                        height: childrenRect.height

                        Image {
                            id: commentsIcon
                            source: 'qrc:/resources/icon-view-comments.png'
                        }

                        Text {
                            id: commentsText
                            anchors.left: commentsIcon.right
                            anchors.leftMargin: UIConstants.PADDING_LARGE
                            font.pixelSize: UIConstants.FONT_XXSMALL
                            font.family: "Nokia Pure Text Light"
                            text: qsTr('%Ln comment(s)', '', model.mnm_comments)
                            color: 'orange'
                        }
                    }

                    Text {
                        anchors.left: commentsArea.right
                        anchors.leftMargin: UIConstants.PADDING_LARGE
                        font.pixelSize: UIConstants.FONT_XXSMALL
                        font.family: "Nokia Pure Text Light"
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
                color: '#f8dcc0'
                radius: 10
                border.width: 2
                border.color: 'darkorange'
            }

            Column {
                x: UIConstants.PADDING_MEDIUM
                y: UIConstants.PADDING_LARGE
                id: extendedContentColumn
                width: parent.width - UIConstants.PADDING_MEDIUM * 2

                Text {
                    font.pixelSize: UIConstants.FONT_SMALL
                    font.family: UIConstants.FONT_FAMILY
                    width: parent.width
                    wrapMode: Text.Wrap
                    text: model.description
                }

                Item {
                    width: parent.width
                    height: childrenRect.height

                    Text {
                        anchors.left: parent.left
                        font.pixelSize: UIConstants.FONT_XSMALL
                        font.family: UIConstants.FONT_FAMILY
                        text: 'karma: ' + model.mnm_karma
                        color: 'darkorange'
                    }

                    Text {
                        anchors.right: parent.right
                        font.pixelSize: UIConstants.FONT_XSMALL
                        font.family: UIConstants.FONT_FAMILY
                        text: Qt.formatDateTime(MNM.getDate(model.pubDate))
                        color: 'darkorange'
                    }
                }
            }
        }
    }
}
