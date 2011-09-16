import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import "file:///usr/lib/qt4/imports/com/meego/UIConstants.js" as UIConstants

Item {
    anchors { left: parent.left; right: parent.right }
    anchors {
        leftMargin: UIConstants.DEFAULT_MARGIN
        rightMargin: UIConstants.DEFAULT_MARGIN
    }

    property string text

    height: headerText.height +
            headerDivider.height + UIConstants.DEFAULT_MARGIN

    Text {
        id: headerText
        font.pixelSize: UIConstants.FONT_SLARGE
        font.family: UIConstants.FONT_FAMILY
        width: parent.width
        color: 'darkblue'
        wrapMode: Text.WordWrap
        maximumLineCount: 1
        elide: Text.ElideRight
        text: 'Comentarios para ' + parent.text
    }

    Rectangle {
        id: headerDivider
        anchors {
            top: headerText.bottom
            left: parent.left
            right: parent.right
        }
        anchors.topMargin: UIConstants.DEFAULT_MARGIN
        height: 1
        color: 'darkorange'
    }
}
