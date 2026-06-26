import QtQuick
import QtQuick.Layouts

Item {
    id: lockScreen
    signal loginRequested

    ColumnLayout {
        anchors.left: parent.left
        anchors.leftMargin: 150
        anchors.verticalCenter: parent.verticalCenter
        spacing: -15

        Text {
            id: time
            font.pixelSize: 120
            font.weight: 900
            font.family: "Supermercado"
            color: "#ffaab4"

            function updateTime() {
                text = new Date().toLocaleString(Qt.locale(), "hh:mm");
            }
        }

        Text {
            id: date
            font.pixelSize: 25
            font.weight: 600
            font.family: "Supermercado"
            color: "#ffaab4"

            function updateDate() {
                text = new Date().toLocaleString(Qt.locale(), "dddd, MMMM dd, yyyy");
            }
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
        time.updateTime();
        date.updateDate();
    }

    MouseArea {
        anchors.fill: parent
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
