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

    width: 160
    height: 36

    TextField {
        id: textField
        anchors.fill: parent
        inputMethodHints: input.inputMethodHints
        color: "#12091c"
        enabled: input.enabled
        echoMode: input.isPassword ? TextInput.Password : TextInput.Normal
        passwordCharacter: "\u25cf"
        activeFocusOnTab: true
        selectByMouse: true
        verticalAlignment: TextField.AlignVCenter
        font.family: "system"
        font.pixelSize: 13
        background: Rectangle {
            anchors.fill: parent
            color: "#ffffff"
            opacity: 0.15
            topLeftRadius: 8
            bottomLeftRadius: 8
            topRightRadius: 8
            bottomRightRadius: 8
        }
        leftPadding: placeholderLabel.x
        rightPadding: 10
        onAccepted: input.accepted()

        Rectangle {
            anchors.fill: parent
            border.width: 2
            border.color: textField.activeFocus ? "#8012091c" : "#2512091c"
            color: "transparent"
            topLeftRadius: 8
            bottomLeftRadius: 8
            topRightRadius: input.splitBorderRadius ? 0 : 8
            bottomRightRadius: input.splitBorderRadius ? 0 : 8
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
                    width: 16
                    height: 16
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
                color: "#6012091c"
                font.pixelSize: Math.max(8, textField.font.pixelSize || 10)
                font.family: textField.font.family || "sans-serif"
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: textField.verticalAlignment
                font.italic: true
            }
        }
    }
}