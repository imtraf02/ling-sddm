import QtQuick
import QtQuick.Effects
import QtQuick.Controls

Rectangle {
    id: avatar
    property string shape: "square"
    property string source: ""
    property bool active: false
    property int squareRadius: (shape == "circle") ? width : 30
    property color strokeColor: "#12091c"
    property int strokeSize: 3
    property string tooltipText: ""
    property bool showTooltip: false

    signal clicked
    signal clickedOutside

    radius: squareRadius
    color: "transparent"
    antialiasing: true

    Image {
        id: faceImage
        source: {
            if (parent.source === "" || parent.source === undefined) return Config.getIcon("user-default");
            var src = parent.source.toString();
            if (src.indexOf("/usr/share/sddm/faces/") !== -1 || src.indexOf("system-user") !== -1 || src.indexOf("default.face.icon") !== -1) {
                return Config.getIcon("user-default");
            }
            return parent.source;
        }
        anchors.fill: parent
        mipmap: true
        antialiasing: true
        visible: false
        smooth: true

        fillMode: Image.PreserveAspectCrop
        horizontalAlignment: Image.AlignHCenter
        verticalAlignment: Image.AlignVCenter

        onStatusChanged: {
            if (status === Image.Error) {
                source = Config.getIcon("user-default");
                faceEffects.colorization = 1;
            }
        }

        Rectangle {
            anchors.fill: parent
            radius: avatar.squareRadius
            color: "transparent"
            border.width: avatar.strokeSize
            border.color: avatar.strokeColor
            antialiasing: true
        }
    }

    MultiEffect {
        id: faceEffects
        anchors.fill: faceImage
        source: faceImage
        antialiasing: true
        maskEnabled: true
        maskSource: faceImageMask
        maskSpreadAtMin: 1.0
        maskThresholdMax: 1.0
        maskThresholdMin: 0.5
        colorization: 0
        colorizationColor: avatar.strokeColor
    }

    Item {
        id: faceImageMask

        height: width
        layer.enabled: true
        layer.smooth: true
        visible: false
        width: faceImage.width

        Rectangle {
            height: width
            radius: avatar.squareRadius
            width: faceImage.width
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.ArrowCursor

        function isCursorInsideAvatar() {
            if (!mouseArea.containsMouse)
                return false;
            if (avatar.shape === "square")
                return true;

            var centerX = width / 2;
            var centerY = height / 2;
            var radiusX = centerX;
            var radiusY = centerY;

            var dx = (mouseArea.mouseX - centerX) / radiusX;
            var dy = (mouseArea.mouseY - centerY) / radiusY;

            return (dx * dx + dy * dy) <= 1.0;
        }

        onReleased: function (mouse) {
            var isInside = isCursorInsideAvatar();
            if (isInside) {
                avatar.clicked();
            } else {
                avatar.clickedOutside();
            }
            mouse.accepted = isInside;
        }

        function updateHover() {
            if (isCursorInsideAvatar()) {
                cursorShape = Qt.PointingHandCursor;
            } else {
                cursorShape = Qt.ArrowCursor;
            }
        }

        onMouseXChanged: updateHover()
        onMouseYChanged: updateHover()

        ToolTip {
            id: toolTipControl
            parent: mouseArea
            enabled: true
            property bool shouldShow: avatar.showTooltip || (mouseArea.isCursorInsideAvatar() && avatar.tooltipText !== "")
            visible: shouldShow
            delay: 300
            y: -height - 10
            x: (parent.width - width) / 2

            contentItem: Text {
                id: tooltipTextElement
                font.family: "system"
                font.pixelSize: 11
                text: avatar.tooltipText
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
}