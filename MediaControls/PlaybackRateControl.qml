import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Layouts
import Config

Item {
    id:root
    property alias playbackRate: slider.value

    Layout.minimumWidth: 100
    Layout.maximumWidth: 200
    RowLayout{
        anchors.fill: root
        spacing: 10
        Image{
            source: Config.iconSource("Rate_Icon")
        }
        CustomSlider{
            id:slider
            Layout.fillWidth: true
            snapMode: slider.SnapOnRelease
            from:0.5
            to:2.5
            stepSize: 0.5
            value: 1.0
        }
        Label{
            text:slider.value.toFixed(1)+"x"
            color: "#41CD52"
        }
    }
}
