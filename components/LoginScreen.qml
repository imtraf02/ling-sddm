import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import SddmComponents

Item {
    id: loginScreen
    signal close
    signal toggleLayoutPopup

    state: "normal"
    property bool stateChanging: false
    function safeStateChange(newState) {
        if (!stateChanging) {
            stateChanging = true;
            state = newState;
            stateChanging = false;
        }
    }
    onStateChanged: {
        if (state === "normal") {
            resetFocus();
        }
    }

    readonly property alias password: password
    readonly property alias loginButton: loginButton
    readonly property alias loginContainer: loginContainer

    property bool inputActive: password.input.activeFocus

    property bool showKeyboard: true

    property bool foundUsers: userModel.count > 0

    property int computedInputMethodHintsOnly: Qt.ImhNone

    // Login info
    property int sessionIndex: 0
    property int userIndex: 0
    property string userName: ""
    property string userRealName: ""
    property string userIcon: ""
    property bool userNeedsPassword: true

    function login() {
        var user = foundUsers ? userName : userInput.text;
        if (user && user !== "") {
            safeStateChange("authenticating");
            sddm.login(user, password.text, sessionIndex);
        } else {
            loginMessage.warn("Enter your username!", "error");
        }
    }
    Connections {
        function onLoginSucceeded() {
            loginContainer.scale = 0.0;
        }
        function onLoginFailed() {
            safeStateChange("normal");
            loginMessage.warn("Login failed", "error");
            password.text = "";
        }
        function onInformationMessage(message) {
            loginMessage.warn(message, "error");
        }
        target: sddm
    }

    Component.onDestruction: {
        if (typeof connections !== 'undefined') {
            connections.target = null;
        }
    }

    function updateCapsLock() {
        if (root.capsLockOn && loginScreen.state !== "authenticating") {
            loginMessage.warn("Caps Lock is on", "warning");
        } else {
            loginMessage.clear();
        }
    }

    function resetFocus() {
        if (!loginScreen.foundUsers) {
            userInput.input.forceActiveFocus();
        } else {
            if (loginScreen.userNeedsPassword) {
                password.input.forceActiveFocus();
            } else {
                loginButton.forceActiveFocus();
            }
        }
    }

    Item {
        id: loginContainer
        anchors.fill: parent
        scale: 0.5

        Behavior on scale {
            enabled: true
            NumberAnimation {
                duration: 200
            }
        }

        Item {
            id: loginArea
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 80
            width: childrenRect.width
            height: childrenRect.height

            ColumnLayout {
                id: loginColumn
                spacing: 10
                anchors.horizontalCenter: parent.horizontalCenter

                UserSelector {
                    id: userSelector
                    Layout.preferredWidth: 100
                    Layout.preferredHeight: 100
                    Layout.alignment: Qt.AlignHCenter
                    listUsers: loginScreen.state === "selectingUser"
                    enabled: loginScreen.state !== "authenticating"
                    visible: loginScreen.foundUsers
                    activeFocusOnTab: true
                    orientation: "vertical"
                    onOpenUserList: {
                        safeStateChange("selectingUser");
                    }
                    onCloseUserList: {
                        safeStateChange("normal");
                        loginScreen.resetFocus();
                    }
                    onUserChanged: (index, name, realName, icon, needsPassword) => {
                        if (loginScreen.foundUsers) {
                            loginScreen.userIndex = index;
                            loginScreen.userName = name;
                            loginScreen.userRealName = realName;
                            loginScreen.userIcon = icon;
                            loginScreen.userNeedsPassword = needsPassword;
                        }
                    }

                    Behavior on Layout.preferredHeight {
                        enabled: true
                        NumberAnimation {
                            duration: 200
                        }
                    }
                }

                Text {
                    id: activeUserName
                    font.family: "Supermercado"
                    font.weight: Font.Bold
                    font.pixelSize: 24
                    color: "#ffaab4"
                    text: loginScreen.userRealName || loginScreen.userName || ""
                    Layout.alignment: Qt.AlignHCenter
                    visible: loginScreen.foundUsers && (loginScreen.userRealName || loginScreen.userName)
                }

                Item {
                    id: noUsersLoginArea
                    width: 180 + 45 + 10
                    height: childrenRect.height
                    visible: !loginScreen.foundUsers

                    Text {
                        id: noUsersMessage
                        anchors.top: parent.top
                        width: parent.width
                        text: "SDDM could not find any user. Type your username below:"
                        wrapMode: Text.Wrap
                        horizontalAlignment: Text.AlignHCenter
                        color: "#ffaab4"
                        font.pixelSize: 18
                        font.family: "system"
                    }

                    Input {
                        id: userInput
                        anchors {
                            top: noUsersMessage.bottom
                            topMargin: 10
                        }
                        width: 180
                        height: 45
                        icon: Config.getIcon("user-default")
                        placeholder: "Username"
                        isPassword: false
                        inputMethodHints: loginScreen.computedInputMethodHintsOnly
                        splitBorderRadius: false
                        enabled: loginScreen.state !== "authenticating"
                        onAccepted: {
                            loginScreen.login();
                        }

                        background: Rectangle {
                            color: "transparent"
                            border.color: "#ffaab4"
                            border.width: 2
                            radius: 10
                        }
                    }
                }

                RowLayout {
                    id: loginAreaRow
                    spacing: 10
                    visible: loginScreen.state !== "authenticating" && loginScreen.foundUsers
                    Layout.alignment: Qt.AlignHCenter

                    Input {
                        id: password
                        enabled: loginScreen.state === "normal"
                        visible: loginScreen.userNeedsPassword
                        Layout.preferredWidth: 180
                        Layout.preferredHeight: 45
                        icon: Config.getIcon("password")
                        placeholder: "Password"
                        isPassword: true
                        inputMethodHints: loginScreen.computedInputMethodHintsOnly
                        splitBorderRadius: true
                        onAccepted: {
                            loginScreen.login();
                        }

                        background: Rectangle {
                            color: "transparent"
                            border.color: "#ffaab4"
                            border.width: 2
                            radius: 10
                        }
                    }

                    IconButton {
                        id: loginButton
                        Layout.preferredWidth: 45
                        Layout.preferredHeight: 45
                        visible: true
                        enabled: loginScreen.state !== "selectingUser" && loginScreen.state !== "authenticating"
                        activeFocusOnTab: true
                        icon: Config.getIcon("arrow-right")
                        label: "Login"
                        showLabel: false
                        tooltipText: "Login"
                        iconSize: 24
                        fontFamily: "system"
                        fontSize: 14
                        fontWeight: Font.Normal
                        contentColor: "#ffaab4"
                        activeContentColor: "#000000"
                        backgroundColor: "transparent"
                        backgroundOpacity: 0.0
                        activeBackgroundColor: "#ffaab4"
                        activeBackgroundOpacity: 1.0
                        borderSize: 2
                        borderColor: "#ffaab4"
                        borderRadiusLeft: password.visible ? 10 : 10
                        borderRadiusRight: 10
                        onClicked: {
                            loginScreen.login();
                        }

                        Behavior on x {
                            enabled: true
                            NumberAnimation {
                                duration: 150
                            }
                        }
                    }
                }

                Spinner {
                    id: spinner
                    visible: loginScreen.state === "authenticating"
                    opacity: visible ? 1.0 : 0.0
                    Layout.alignment: Qt.AlignHCenter
                    color: "#ffaab4"
                }

                Text {
                    id: loginMessage
                    property bool capslockWarning: false
                    font.pixelSize: 14
                    font.family: "system"
                    font.weight: Font.Normal
                    color: "#ffaab4"
                    visible: text !== "" && loginScreen.state !== "authenticating" && (capslockWarning ? loginScreen.userNeedsPassword : true)
                    opacity: visible ? 1.0 : 0.0
                    Layout.alignment: Qt.AlignHCenter

                    function warn(message, type) {
                        clear();
                        text = message;
                        color = type === "error" ? "#ffaab4" : (type === "warning" ? "#ffaab4" : "#ffaab4");
                        if (message === "Caps Lock is on")
                            capslockWarning = true;
                    }

                    function clear() {
                        text = "";
                        capslockWarning = false;
                    }

                    Behavior on opacity {
                        enabled: true
                        NumberAnimation {
                            duration: 150
                        }
                    }
                }
            }
        }
    }

    MenuArea {}
    CVKeyboard {}


    Keys.onPressed: function (event) {
        if (event.key === Qt.Key_Escape) {
            if (loginScreen.state === "authenticating") {
                event.accepted = false;
                return;
            }
            if (loginScreen.showKeyboard) {
                loginScreen.showKeyboard = false;
                event.accepted = true;
                return;
            }
            if (root.lockScreenDisplay) {
                loginScreen.close();
            }
            password.text = "";
        } else if (event.key === Qt.Key_CapsLock) {
            root.capsLockOn = !root.capsLockOn;
        }
        event.accepted = true;
    }

    MouseArea {
        id: closeUserSelectorMouseArea
        z: -1
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            if (loginScreen.state === "selectingUser") {
                safeStateChange("normal");
            }
        }
        onWheel: event => {
            if (loginScreen.state === "selectingUser") {
                if (event.angleDelta.y < 0) {
                    userSelector.nextUser();
                } else {
                    userSelector.prevUser();
                }
            }
        }
    }
}