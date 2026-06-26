import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects

Item {
    id: input

    signal accepted

    property string placeholder: ""
    property alias input: textField
    property bool isPassword: false
    property bool splitBorderRadius: false
    property alias text: textField.text
    property string icon: ""
    property bool enabled: true
    property int inputMethodHints: Qt.ImhNone

    width: 180
    height: 45

    TextField {
        id: textField
        anchors.fill: parent
        inputMethodHints: input.inputMethodHints
        color: "#ffaab4"
        enabled: input.enabled
        echoMode: input.isPassword ? TextInput.Password : TextInput.Normal
        passwordCharacter: "\u25cf"
        activeFocusOnTab: true
        selectByMouse: true
        verticalAlignment: TextField.AlignVCenter
        font.family: "system"
        font.pixelSize: 18
        background: Rectangle {
            anchors.fill: parent
            color: "#000000"
            opacity: 0.0
            topLeftRadius: 10
            bottomLeftRadius: 10
            topRightRadius: 10
            bottomRightRadius: 10
        }
        leftPadding: placeholderLabel.x
        rightPadding: 10
        onAccepted: input.accepted()

        Rectangle {
            anchors.fill: parent
            border.width: 2
            border.color: "#ffaab4"
            color: "transparent"
            topLeftRadius: 10
            bottomLeftRadius: 10
            topRightRadius: input.splitBorderRadius ? 0 : 10
            bottomRightRadius: input.splitBorderRadius ? 0 : 10
        }

        Row {
            anchors.fill: parent
            spacing: 0
            leftPadding: input.icon ? 2 : 10

            Rectangle {
                id: iconContainer
                color: "transparent"
                visible: input.icon !== ""
                height: parent.height
                width: height

                Image {
                    id: icon
                    source: input.icon
                    anchors.centerIn: parent
                    width: 24
                    height: 24
                    sourceSize: Qt.size(width, height)
                    fillMode: Image.PreserveAspectFit
                    opacity: input.enabled ? 1.0 : 0.3
                    Behavior on opacity {
                        NumberAnimation {
                            duration: 250
                        }
                    }

                    MultiEffect {
                        source: parent
                        anchors.fill: parent
                        colorization: 1
                        colorizationColor: textField.color
                    }
                }
            }

            Text {
                id: placeholderLabel
                anchors {
                    verticalCenter: parent.verticalCenter
                }
                padding: 0
                visible: textField.text.length === 0 && (!textField.preeditText || textField.preeditText.length === 0)
                text: input.placeholder
                color: textField.color
                font.pixelSize: Math.max(8, textField.font.pixelSize || 12)
                font.family: textField.font.family || "sans-serif"
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: textField.verticalAlignment
                font.italic: true
            }
        }
    }
}