import QtQuick
import QtQuick.Controls
import QtQuick.Effects

Item {
    id: spinnerContainer
    width: Math.max(spinner.width, spinnerText.width)
    height: spinner.height + 5 + spinnerText.height

    Behavior on opacity {
        NumberAnimation {
            duration: 150
        }
    }
    Behavior on visible {
        ParallelAnimation {
            NumberAnimation {
                target: spinnerText
                property: "anchors.topMargin"
                from: -spinner.height
                to: 5
                duration: 300
                easing.type: Easing.OutQuart
            }
            NumberAnimation {
                target: spinnerEffect
                property: "opacity"
                from: 0.0
                to: 1.0
                duration: 200
            }
        }
    }

    Image {
        id: spinner
        source: Config.getIcon("spinner.svg")
        width: 30
        height: width
        sourceSize.width: width
        sourceSize.height: height
        visible: false
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
    }

    MultiEffect {
        id: spinnerEffect
        source: spinner
        anchors.fill: spinner
        colorization: 1
        colorizationColor: "#ffaab4"
        opacity: 1.0
        antialiasing: true
    }

    RotationAnimation {
        target: spinnerEffect
        running: spinnerContainer.visible
        from: 0
        to: 360
        loops: Animation.Infinite
        duration: 1200
    }

    Text {
        id: spinnerText
        text: "Logging in"
        color: "#ffaab4"
        font.pixelSize: 14
        font.weight: 600
        font.family: "Supermercado"

        anchors {
            top: spinner.bottom
            topMargin: 5
            horizontalCenter: parent.horizontalCenter
        }

        SequentialAnimation on scale {
            id: spinnerTextAnimation
            running: true
            loops: Animation.Infinite
            NumberAnimation {
                from: 1.0
                to: 1.05
                duration: 900
                easing.type: Easing.InOutQuad
            }
            NumberAnimation {
                from: 1.05
                to: 1.0
                duration: 900
                easing.type: Easing.InOutQuad
            }
        }
    }

    Component.onDestruction: {
        if (spinnerTextAnimation) {
            spinnerTextAnimation.running = false;
            spinnerTextAnimation.stop();
        }
    }
}