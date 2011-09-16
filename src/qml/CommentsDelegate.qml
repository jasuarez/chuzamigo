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
        width: parent.width - UIConstants.PADDING_MEDIUM * 2

        Text {
            y: UIConstants.PADDING_MEDIUM
            font.pixelSize: UIConstants.FONT_SMALL
            font.family: UIConstants.FONT_FAMILY
            width: parent.width
            wrapMode: Text.WordWrap
            text: MNM.sanitizeText(model.description)
        }

        Text {
            font.pixelSize: UIConstants.FONT_XSMALL
            font.family: UIConstants.FONT_FAMILY
            text: '#' + model.mnm_order +  ' | ' + model.mnm_karma + ' karma | Por ' + model.mnm_user
            color: 'orange'
        }
    }
}
