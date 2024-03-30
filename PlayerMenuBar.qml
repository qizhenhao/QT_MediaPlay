import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Dialogs
import Config

Item {
    id:root
    implicitHeight: menuBar.height

    signal fileOpened(path : url)
    property alias openFileMenu: fileDialog
    property alias openUrlPopup: urlPopup

    FileDialog{
        id:fileDialog
        title:qsTr("请选择文件")
        onAccepted: root.fileOpened(fileDialog.selectedFile)
    }

    UrlPopup{
        id:urlPopup
        onPathChanged:root.fileOpened(urlPopup.path)
    }

    MenuBar{
        id:menuBar
        visible: !Config.isMobileTarget
        leftPadding: 10
        topPadding: 10

        palette.base: Config.mainColor
        palette.text: Config.secondColor
        palette.highlightedText: "#41CD52"
        palette.window: "transparent"
        palette.highlight: Config.mainColor
        Menu {
            title: qsTr("_&选择文件")
            palette.text: "#ffffff"
            palette.window: "#ffffff"
            palette.highlightedText: "#41CD52"

            MenuItem {
                text: qsTr("打开文件")
                onTriggered: fileDialog.open()
            }
            MenuItem {
                text: qsTr("填写url")
                onTriggered: urlPopup.open()
            }
        }

    }
}
