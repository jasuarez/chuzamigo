import QtQuick 1.1
import com.nokia.meego 1.0
import com.nokia.extras 1.0
import "file:///usr/lib/qt4/imports/com/meego/UIConstants.js" as UIConstants

Item {
    id: refreshHeader
    height: showHeader ?
                headerHeight :
                0
    width: parent.width
    x: UIConstants.DEFAULT_MARGIN
    y: yPosition < 0 ?
        -height :
        -yPosition - height
    opacity: showHeader ? 1 : 0

    Behavior on height {
        NumberAnimation { from: headerHeight; duration: 200 }
    }

    signal clicked
    property bool loading: false
    property real yPosition
    property bool showHeader: false
    property real headerHeight: (appWindow.inPortrait ?
                                     UIConstants.LIST_ITEM_HEIGHT_DEFAULT :
                                     UIConstants.LIST_ITEM_HEIGHT_SMALL)
    property variant lastUpdate: new Date

    BorderImage {
        id: background
        anchors.fill: parent
        anchors.leftMargin: -UIConstants.DEFAULT_MARGIN
        anchors.rightMargin: -UIConstants.DEFAULT_MARGIN
        visible: refreshHeaderMouseArea.pressed
        source: 'image://theme/meegotouch-list-background-pressed-vertical-center'
    }

    Item {
        id: refreshHeaderImage
        anchors.verticalCenter: parent.verticalCenter
        width: refreshHeaderIcon.width
        height: refreshHeaderIcon.height

        Image {
            id: refreshHeaderIcon
            source: 'qrc:/resources/icon-refresh.png'
            visible: !loading
        }

        BusyIndicator {
            visible: loading
            running: loading
            anchors.centerIn: parent
            platformStyle: BusyIndicatorStyle { size: 'medium' }
        }
    }

    Column {
        anchors.verticalCenter: refreshHeaderImage.verticalCenter
        anchors.left: refreshHeaderImage.right
        anchors.leftMargin: UIConstants.DEFAULT_MARGIN

        Text {
            id: refreshHeaderText
            font.pixelSize: UIConstants.FONT_LARGE
            font.family: "Nokia Pure Text Light"
            color: UIConstants.COLOR_BUTTON_DISABLED_FOREGROUND
            text: loading ? 'Actualizando' : 'Pulsa para actualizar'
        }

        Text {
            id: refreshHeaderLastUpdate
            font.pixelSize: UIConstants.FONT_XXSMALL
            font.family: "Nokia Pure Text Light"
            color: UIConstants.COLOR_BUTTON_DISABLED_FOREGROUND
            text: 'Última actualización: ' + Qt.formatDateTime(lastUpdate)
        }
    }

    MouseArea {
        id: refreshHeaderMouseArea
        anchors.fill: parent
        onClicked: {
            parent.clicked()
            lastUpdate = new Date
        }
    }
}
