import QtQuick
import QtQuick.Controls.Fusion

Slider{
    id:slider

    property alias backgroundColor: backgroundRec.color
    property alias backgroundOpacity: backgroundRec.opacity

    background: Rectangle{
        id:backgroundRec
        implicitHeight: 8
        implicitWidth: 120
        width: slider.availableWidth
        height: implicitHeight
        y:slider.topPadding+slider.availableHeight/2-height/2//x,y 我认为没必要做padding结合
        x:slider.leftPadding
        radius: 10
        color: "#41CD52"
        opacity: 0.2
        border.color: "#41CD52"
        border.width: 1
    }
    handle: Rectangle{
        x:slider.leftPadding+slider.visualPosition*(slider.availableWidth-width)
        y:slider.topPadding+slider.availableHeight/2-height/2
        implicitHeight: 8
        implicitWidth: 8
        color: "transparent"
    }
    Rectangle{
        width: slider.visualPosition * slider.availableWidth
        x:slider.leftPadding
        y:slider.topPadding
        height: 8
        color: "#41CD52"
        radius: 10
    }
}
