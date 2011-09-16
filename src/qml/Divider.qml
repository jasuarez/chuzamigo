import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import "file:///usr/lib/qt4/imports/com/meego/UIConstants.js" as UIConstants
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
        color: 'darkorange'
        anchors.verticalCenter: parent.verticalCenter
    }

    Text {
        id: dividerText
        color: 'darkorange'
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
