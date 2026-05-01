import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import QtQuick.Controls

Item {
    id: lockScreen
    signal loginRequested

    // TODO: Support for weather info?
    ColumnLayout {
        id: timePositioner
        spacing: Config.dateMarginTop
        Text {
            id: time
            visible: Config.clockDisplay
            font.pixelSize: Config.clockFontSize * Config.generalScale
            font.weight: Config.clockFontWeight
            font.family: Config.clockFontFamily
            color: Config.clockColor
            Layout.alignment: Config.clockAlign === "left" ? Qt.AlignLeft : (Config.clockAlign === "right" ? Qt.AlignRight : Qt.AlignHCenter)

            function updateTime() {
                text = new Date().toLocaleString(Qt.locale(Config.dateLocale), Config.clockFormat);
            }
        }

        Text {
            id: date
            Layout.alignment: Config.clockAlign === "left" ? Qt.AlignLeft : (Config.clockAlign === "right" ? Qt.AlignRight : Qt.AlignHCenter)
            visible: Config.dateDisplay
            font.pixelSize: Config.dateFontSize * Config.generalScale
            font.family: Config.dateFontFamily
            font.weight: Config.dateFontWeight
            color: Config.dateColor

            function updateDate() {
                text = new Date().toLocaleString(Qt.locale(Config.dateLocale), Config.dateFormat);
            }
        }

        Timer {
            id: clockTimer
            interval: 1000
            repeat: true
            running: true
            onTriggered: {
                time.updateTime();
                date.updateDate();
            }
        }

        Component.onDestruction: {
            if (clockTimer) {
                clockTimer.stop();
            }
        }


        Component.onCompleted: {
            lockScreen.alignItem(timePositioner, Config.clockPosition);
            time.updateTime();
            date.updateDate();
        }
    }

    ColumnLayout {
        id: messagePositioner
        visible: Config.lockMessageDisplay
        spacing: Config.lockMessageSpacing
        Item {
            Layout.alignment: Config.lockMessageAlign === "left" ? Qt.AlignLeft : (Config.lockMessageAlign === "right" ? Qt.AlignRight : Qt.AlignHCenter)
            Layout.preferredWidth: Config.lockMessageIconSize
            Layout.preferredHeight: Config.lockMessageIconSize

            Image {
                id: lockIcon
                source: Config.getIcon(Config.lockMessageIcon)
                width: Config.lockMessageIconSize * Config.generalScale
                height: width
                sourceSize: Qt.size(width, height)
                fillMode: Image.PreserveAspectFit
                visible: false
            }
            MultiEffect {
                source: lockIcon
                anchors.fill: lockIcon
                colorization: Config.lockMessagePaintIcon ? 1 : 0
                colorizationColor: Config.lockMessageColor
                visible: Config.lockMessageDisplayIcon
                antialiasing: true
            }
        }

        Text {
            id: lockMessage
            Layout.alignment: Config.lockMessageAlign === "left" ? Qt.AlignLeft : (Config.lockMessageAlign === "right" ? Qt.AlignRight : Qt.AlignHCenter)
            font.pixelSize: Config.lockMessageFontSize * Config.generalScale
            font.family: Config.lockMessageFontFamily
            font.weight: Config.lockMessageFontWeight
            color: Config.lockMessageColor
            text: Config.lockMessageText
        }


        Component.onCompleted: lockScreen.alignItem(messagePositioner, Config.lockMessagePosition)
    }

    function alignItem(item, pos) {
        switch (pos) {
        case "top-left":
            item.anchors.top = lockScreen.top;
            item.anchors.topMargin = Config.lockScreenPaddingTop;
            item.anchors.left = lockScreen.left;
            item.anchors.leftMargin = Config.lockScreenPaddingLeft;
            break;
        case "top-center":
            item.anchors.top = lockScreen.top;
            item.anchors.topMargin = Config.lockScreenPaddingTop;
            item.anchors.horizontalCenter = lockScreen.horizontalCenter;
            item.anchors.horizontalCenterOffset = Config.lockScreenPaddingLeft;
            break;
        case "top-right":
            item.anchors.top = lockScreen.top;
            item.anchors.topMargin = Config.lockScreenPaddingTop;
            item.anchors.right = lockScreen.right;
            item.anchors.rightMargin = Config.lockScreenPaddingRight;
            break;
        case "center-left":
            item.anchors.verticalCenter = lockScreen.verticalCenter;
            item.anchors.verticalCenterOffset = Config.lockScreenPaddingTop;
            item.anchors.left = lockScreen.left;
            item.anchors.leftMargin = Config.lockScreenPaddingLeft;
            break;
        case "center":
            item.anchors.verticalCenter = lockScreen.verticalCenter;
            item.anchors.verticalCenterOffset = Config.lockScreenPaddingTop;
            item.anchors.horizontalCenter = lockScreen.horizontalCenter;
            item.anchors.horizontalCenterOffset = Config.lockScreenPaddingLeft;
            break;
        case "center-right":
            item.anchors.verticalCenter = lockScreen.verticalCenter;
            item.anchors.verticalCenterOffset = Config.lockScreenPaddingTop;
            item.anchors.right = lockScreen.right;
            item.anchors.rightMargin = Config.lockScreenPaddingRight;
            break;
        case "bottom-left":
            item.anchors.bottom = lockScreen.bottom;
            item.anchors.bottomMargin = Config.lockScreenPaddingBottom;
            item.anchors.left = lockScreen.left;
            item.anchors.leftMargin = Config.lockScreenPaddingLeft;
            break;
        case "bottom-center":
            item.anchors.bottom = lockScreen.bottom;
            item.anchors.bottomMargin = Config.lockScreenPaddingBottom;
            item.anchors.horizontalCenter = lockScreen.horizontalCenter;
            item.anchors.horizontalCenterOffset = Config.lockScreenPaddingLeft;
            break;
        default:
            item.anchors.bottom = lockScreen.bottom;
            item.anchors.bottomMargin = Config.lockScreenPaddingBottom;
            item.anchors.right = lockScreen.right;
            item.anchors.rightMargin = Config.lockScreenPaddingRight;
        }
    }

    MouseArea {
        id: lockScreenMouseArea
        hoverEnabled: true
        z: -1
        anchors.fill: lockScreen
        onClicked: lockScreen.loginRequested()
    }

    Keys.onPressed: function (event) {
        if (event.key === Qt.Key_CapsLock) {
            root.capsLockOn = !root.capsLockOn;
        }

        if (event.key === Qt.Key_Escape) {
            event.accepted = false;
            return;
        } else {
            lockScreen.loginRequested();
        }
        event.accepted = true;
    }
}
