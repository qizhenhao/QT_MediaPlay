pragma Singleton
import QtQuick

QtObject {
    enum Theme{
        Light,
        Dark
    }

    property int activeTheme: Config.Theme.Dark

    readonly property bool isMobileTarght: Qt.platform.os === "android" || Qt.platform.os === "ios"
    readonly property color mainColor: activeTheme? "#09102B" : "#FFFFFF"
    readonly property color secondColor: !activeTheme? "#09102B" : "#FFFFFF"

    function iconSource(fileName, addSuffix = true){
        return `qrc:/qt/qml/MediaControls/icons/${fileName}${activeTheme === Config.Theme.Dark && addSuffix?"_Dark.svg":".svg"}`
    }
}
