import QtQuick
import QtQuick.VirtualKeyboard
import QtQuick.VirtualKeyboard.Settings

InputPanel {
    id: inputPanel

    width: Math.min(loginScreen && loginScreen.width ? loginScreen.width / 2 : 800, 600)
    active: Qt.inputMethod.visible
    visible: loginScreen && loginScreen.showKeyboard && loginScreen.state !== "selectingUser" && loginScreen.state !== "authenticating"
    opacity: visible ? 1.0 : 0.0

    Component.onCompleted: {
        VirtualKeyboardSettings.styleName = "vkeyboardStyle";
        VirtualKeyboardSettings.layout = "symbols";
    }

    property point loginLayoutPosition: loginContainer && loginLayout ? loginContainer.mapToGlobal(loginLayout.x, loginLayout.y) : Qt.point(0, 0)
    property bool vKeyboardMoved: false

    x: (parent.width - inputPanel.width) / 2
    y: parent.height - inputPanel.height - 100
    Behavior on y {
        NumberAnimation {
            duration: 150
        }
    }
    Behavior on x {
        NumberAnimation {
            duration: 150
        }
    }
    Behavior on opacity {
        NumberAnimation {
            duration: 250
        }
    }

    MouseArea {
        id: vKeyboardDragArea
        property point initialPosition: Qt.point(-1, -1)
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: loginScreen && loginScreen.userNeedsPassword ? Qt.ArrowCursor : Qt.ForbiddenCursor
        drag.target: inputPanel
        acceptedButtons: loginScreen && loginScreen.userNeedsPassword ? Qt.MiddleButton : Qt.MiddleButton
        onPressed: function (event) {
            cursorShape = Qt.ClosedHandCursor;
            initialPosition = Qt.point(event.x, event.y);
        }
        onReleased: function (event) {
            cursorShape = loginScreen && loginScreen.userNeedsPassword ? Qt.ArrowCursor : Qt.ForbiddenCursor;
            if (initialPosition !== Qt.point(event.x, event.y) && !inputPanel.vKeyboardMoved) {
                inputPanel.vKeyboardMoved = true;
            }
        }
    }
}