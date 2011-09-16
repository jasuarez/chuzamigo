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
                id: votesArea

                height: votesColumn.height + UIConstants.PADDING_SMALL * 2
                width: votesColumn.width + UIConstants.PADDING_SMALL * 2

                Rectangle {
                    anchors.fill: parent
                    color: 'darkorange'
                    radius: 10
                }

                Column {
                    id: votesColumn
                    anchors.centerIn: parent

                    Text {
                        font.pixelSize: model.mnm_votes < 1000 ?
                                            UIConstants.FONT_DEFAULT :
                                            UIConstants.FONT_LSMALL
                        font.family: UIConstants.FONT_FAMILY
                        text: model.mnm_votes
                        anchors.horizontalCenter: parent.horizontalCenter
                        color: 'white'
                    }

                    Text {
                        font.pixelSize: UIConstants.FONT_XXSMALL
                        font.family: "Nokia Pure Text Light"
                        text: 'meneos'
                        color: 'white'
                    }
                }
            }

            Column {
                id: entryColumn
                width: parent.width - votesArea.width
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
                            text: model.mnm_comments + ' comentarios'
                            color: 'orange'
                        }
                    }

                    Text {
                        anchors.left: commentsArea.right
                        anchors.leftMargin: UIConstants.PADDING_LARGE
                        font.pixelSize: UIConstants.FONT_XXSMALL
                        font.family: "Nokia Pure Text Light"
                        text: 'Por ' + model.mnm_user
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
                    wrapMode: Text.WordWrap
                    text: model.description
                }

                Text {
                    font.pixelSize: UIConstants.FONT_XSMALL
                    font.family: UIConstants.FONT_FAMILY
                    text: 'karma: ' + model.mnm_karma + ' | ' +
                          Qt.formatDateTime(MNM.getDate(model.pubDate))
                    color: 'darkorange'
                }
            }
        }
    }
}
