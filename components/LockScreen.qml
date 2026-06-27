import QtQuick
import QtQuick.Layouts

Item {
    id: lockScreen
    signal loginRequested

    Rectangle {
        id: clockCard
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: 80
        width: clockLayout.implicitWidth + 60
        height: clockLayout.implicitHeight + 30
        color: "#59ffffff"
        radius: 16
        border {
            color: "#2012091c"
            width: 1
        }

        ColumnLayout {
            id: clockLayout
            anchors.centerIn: parent
            spacing: 5

            Text {
                id: time
                font.pixelSize: 90
                font.weight: 900
                font.family: "Supermercado"
                color: "#12091c"
                Layout.alignment: Qt.AlignHCenter

                function updateTime() {
                    text = new Date().toLocaleString(Qt.locale(), "hh:mm");
                }
            }

            Text {
                id: date
                font.pixelSize: 18
                font.weight: 600
                font.family: "Supermercado"
                color: "#12091c"
                Layout.alignment: Qt.AlignHCenter

                function updateDate() {
                    text = new Date().toLocaleString(Qt.locale(), "dddd, MMMM dd, yyyy");
                }
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
