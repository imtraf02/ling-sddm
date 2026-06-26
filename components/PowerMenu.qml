import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ColumnLayout {
    id: selector
    width: 100
    spacing: 2

    signal close

    KeyNavigation.up: shutdownButton
    KeyNavigation.down: suspendButton

    IconButton {
        id: suspendButton

        preferredWidth: Layout.preferredWidth
        Layout.preferredHeight: 30
        Layout.preferredWidth: 100

        focus: selector.visible
        width: Layout.preferredWidth
        enabled: sddm.canSuspend
        icon: Config.getIcon("power-suspend.svg")
        contentColor: "#ffaab4"
        activeContentColor: "#000000"
        fontFamily: "system"
        backgroundColor: "transparent"
        activeBackgroundColor: "#ffaab4"
        activeBackgroundOpacity: 1.0
        iconSize: 16
        fontSize: 11
        onClicked: {
            selector.close();
            sddm.suspend();
        }
        label: "Suspend"

        KeyNavigation.up: shutdownButton
        KeyNavigation.down: rebootButton
    }

    IconButton {
        id: rebootButton

        preferredWidth: Layout.preferredWidth
        Layout.preferredHeight: 30
        Layout.preferredWidth: 100

        focus: selector.visible
        width: Layout.preferredWidth
        enabled: sddm.canReboot
        icon: Config.getIcon("power-reboot.svg")
        contentColor: "#ffaab4"
        activeContentColor: "#000000"
        fontFamily: "system"
        backgroundColor: "transparent"
        activeBackgroundColor: "#ffaab4"
        activeBackgroundOpacity: 1.0
        iconSize: 16
        fontSize: 11
        onClicked: {
            selector.close();
            sddm.reboot();
        }
        label: "Reboot"

        KeyNavigation.up: suspendButton
        KeyNavigation.down: shutdownButton
    }

    IconButton {
        id: shutdownButton

        preferredWidth: Layout.preferredWidth
        Layout.preferredHeight: 30
        Layout.preferredWidth: 100

        focus: selector.visible
        width: Layout.preferredWidth
        enabled: sddm.canPowerOff
        icon: Config.getIcon("power.svg")
        contentColor: "#ffaab4"
        activeContentColor: "#000000"
        fontFamily: "system"
        backgroundColor: "transparent"
        activeBackgroundColor: "#ffaab4"
        activeBackgroundOpacity: 1.0
        iconSize: 16
        fontSize: 11
        onClicked: {
            selector.close();
            sddm.powerOff();
        }
        label: "Shutdown"

        KeyNavigation.up: rebootButton
        KeyNavigation.down: suspendButton
    }

    Keys.onPressed: function (event) {
        if (event.key == Qt.Key_Return || event.key == Qt.Key_Enter || event.key === Qt.Key_Space) {
            selector.close();
        } else if (event.key === Qt.Key_CapsLock) {
            root.capsLockOn = !root.capsLockOn;
        }
    }
}