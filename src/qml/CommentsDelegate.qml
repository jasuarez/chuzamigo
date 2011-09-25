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
    height: contentColumn.height + UIConstants.PADDING_LARGE * 2

    Rectangle {
        anchors.fill: parent
        anchors.margins: UIConstants.PADDING_SMALL
        color: '#f8dcc0'
        radius: 10
        border.width: 2
        border.color: 'darkorange'
    }

    Column {
        x: UIConstants.PADDING_LARGE
        y: UIConstants.PADDING_LARGE
        id: contentColumn
        width: parent.width - UIConstants.PADDING_LARGE * 2

        Text {
            y: UIConstants.PADDING_MEDIUM
            font.pixelSize: UIConstants.FONT_SMALL
            font.family: UIConstants.FONT_FAMILY
            width: parent.width
            wrapMode: Text.WordWrap
            text: MNM.cleanUpComments(model.description)
            onLinkActivated: {
                // Links to comments start with '/'
                if (MNM.startsWith(link, '/')) {
                    // Meneame comments start from #1 (since #0 is the new itself)
                    var referredComment = commentsList.model.count - parseInt(link.substr(1), 10)
                    commentsList.positionViewAtIndex(referredComment, ListView.Beginning)
                } else {
                    Qt.openUrlExternally(link)
                }
            }
        }

        Item {
            width: parent.width
            height: childrenRect.height

            Text {
                anchors.left: parent.left
                font.pixelSize: UIConstants.FONT_XSMALL
                font.family: UIConstants.FONT_FAMILY
                color: 'darkorange'
                text: qsTr('#%1 | karma: %2 | By %3').arg(model.mnm_order).arg(model.mnm_karma).arg(model.mnm_user)
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
