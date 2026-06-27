import QtQuick
import QtQuick.Controls
import QtQuick.Effects
import QtQuick.Layouts

Item {
    id: iconButton

    signal clicked

    property bool active: false
    readonly property bool isActive: active || focus || mouseArea.pressed || mouseArea.containsMouse
    property string icon: ""
    property int iconSize: 16
    property color contentColor: "#12091c"
    property color activeContentColor: "#ffffff"
    property string label: ""
    property bool showLabel: true
    property string fontFamily: "system"
    property int fontWeight: 400
    property int fontSize: 11
    property color backgroundColor: "#ffffff"
    property double backgroundOpacity: 0.0
    property color activeBackgroundColor: "#12091c"
    property double activeBackgroundOpacity: 0.7
    property color glassColor1: "#4DCBA6F7"
    property color glassColor2: "#2089B4FA"
    property string tooltipText: ""
    property int borderRadius: 8
    property int borderRadiusLeft: borderRadius
    property int borderRadiusRight: borderRadius
    property int borderSize: 1
    property color borderColor: iconButton.isActive ? "#6CCBA6F7" : "#2512091c"
    property int preferredWidth: -1

    width: preferredWidth !== -1 ? preferredWidth : buttonContentRow.width
    height: 36

    Rectangle {
        id: buttonBackground
        anchors.fill: parent
        color: iconButton.isActive ? iconButton.activeBackgroundColor : iconButton.backgroundColor
        opacity: iconButton.isActive ? iconButton.activeBackgroundOpacity : iconButton.backgroundOpacity
        topLeftRadius: iconButton.borderRadiusLeft
        topRightRadius: iconButton.borderRadiusRight
        bottomLeftRadius: iconButton.borderRadiusLeft
        bottomRightRadius: iconButton.borderRadiusRight

        Behavior on opacity {
            NumberAnimation {
                duration: 250
            }
        }
    }

    Rectangle {
        id: glassOverlay
        anchors.fill: parent
        visible: iconButton.isActive
        opacity: iconButton.isActive ? 0.65 : 0
        gradient: Gradient {
            GradientStop { position: 0.0; color: iconButton.glassColor1 }
            GradientStop { position: 1.0; color: iconButton.glassColor2 }
        }
        topLeftRadius: iconButton.borderRadiusLeft
        topRightRadius: iconButton.borderRadiusRight
        bottomLeftRadius: iconButton.borderRadiusLeft
        bottomRightRadius: iconButton.borderRadiusRight

        Behavior on opacity {
            NumberAnimation {
                duration: 250
            }
        }
    }

    Rectangle {
        id: buttonBorder
        color: "transparent"
        topLeftRadius: iconButton.borderRadiusLeft
        topRightRadius: iconButton.borderRadiusRight
        bottomLeftRadius: iconButton.borderRadiusLeft
        bottomRightRadius: iconButton.borderRadiusRight
        anchors.fill: parent
        visible: iconButton.borderSize > 0 || iconButton.focus
        border {
            color: iconButton.borderColor
            width: iconButton.focus ? (iconButton.borderSize) || 2 : (iconButton.borderSize > 0 ? iconButton.borderSize : 0)
        }
    }

    RowLayout {
        id: buttonContentRow
        height: parent.height
        spacing: 0

        Rectangle {
            id: iconContainer
            color: "transparent"
            Layout.preferredWidth: parent.height
            Layout.preferredHeight: parent.height

            Image {
                id: buttonIcon
                source: iconButton.icon
                anchors.centerIn: parent
                width: iconButton.iconSize
                height: width
                sourceSize: Qt.size(width, height)
                fillMode: Image.PreserveAspectFit
                visible: false
            }

            MultiEffect {
                id: iconEffect
                source: buttonIcon
                anchors.fill: buttonIcon
                colorization: 1
                colorizationColor: iconButton.isActive ? iconButton.activeContentColor : iconButton.contentColor
                antialiasing: true
                opacity: iconButton.enabled ? 1.0 : 0.5

                Behavior on opacity {
                    NumberAnimation {
                        duration: 250
                    }
                }

                Behavior on colorizationColor {
                    ColorAnimation {
                        duration: 250
                    }
                }
            }
        }

        Text {
            id: buttonLabel
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            Layout.fillWidth: true
            elide: Text.ElideRight
            text: iconButton.label
            visible: iconButton.showLabel && text !== ""
            font.family: iconButton.fontFamily
            font.pixelSize: iconButton.fontSize
            font.weight: iconButton.fontWeight
            rightPadding: 10
            color: iconButton.isActive ? iconButton.activeContentColor : iconButton.contentColor
            opacity: iconButton.enabled ? 1.0 : 0.5
            Behavior on opacity {
                NumberAnimation {
                    duration: 250
                }
            }
            Component.onCompleted: {
                if (iconButton.preferredWidth !== -1) {
                    Layout.preferredWidth = iconButton.width - iconContainer.width;
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: parent.enabled
        onClicked: iconButton.clicked()
        cursorShape: Qt.PointingHandCursor

        ToolTip {
            id: toolTipControl
            parent: mouseArea
            enabled: true
            property bool shouldShow: mouseArea.containsMouse && iconButton.tooltipText !== "" || iconButton.focus && iconButton.tooltipText !== ""
            visible: shouldShow
            delay: 300
            y: -height - 10
            x: (parent.width - width) / 2

            contentItem: Text {
                id: tooltipTextElement
                font.family: "system"
                font.pixelSize: 11
                text: iconButton.tooltipText
                color: "#cba6f7"
            }

            background: Rectangle {
                implicitWidth: tooltipTextElement.implicitWidth + (toolTipControl.leftPadding + toolTipControl.rightPadding)
                implicitHeight: tooltipTextElement.implicitHeight + (toolTipControl.topPadding + toolTipControl.bottomPadding)
                color: "#12091c"
                opacity: 0.85
                border {
                    color: "#2512091c"
                    width: 1
                }
                radius: 5
            }
        }
    }

    Keys.onPressed: function (event) {
        if (event.key == Qt.Key_Return || event.key == Qt.Key_Enter || event.key === Qt.Key_Space) {
            iconButton.clicked();
        }
    }
}