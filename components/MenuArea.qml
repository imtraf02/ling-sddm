import QtQuick
import QtQuick.Controls

Item {
    id: menuArea
    anchors.fill: parent

    Component {
        id: sessionMenuComponent

        IconButton {
            id: sessionButton
            property bool showLabel: true
            preferredWidth: showLabel ? 100 : 36
            height: 36
            iconSize: 16
            fontSize: 10
            enabled: loginScreen.state === "normal" || popup.visible
            active: popup.visible
            contentColor: "#12091c"
            activeContentColor: "#ffffff"
            borderRadius: 6
            borderSize: 1
            borderColor: active || focus ? "#6CCBA6F7" : "#2512091c"
            backgroundColor: "#ffffff"
            backgroundOpacity: 0.15
            activeBackgroundColor: "#12091c"
            activeBackgroundOpacity: 0.7
            fontFamily: "system"
            activeFocusOnTab: true
            focus: false
            onClicked: {
                if (loginScreen.isSelectingUser) {
                    loginScreen.isSelectingUser = false;
                } else {
                    popup.open();
                }
            }
            tooltipText: "Change session"

            Popup {
                id: popup
                parent: sessionButton
                padding: 5
                background: Rectangle {
                    color: "#ffffff"
                    opacity: 0.65
                    radius: 6

                    Rectangle {
                        anchors.fill: parent
                        visible: true
                        radius: parent.radius
                        color: "transparent"
                        border {
                            color: "#2012091c"
                            width: 1
                        }
                    }
                }
                dim: true
                Overlay.modal: Rectangle {
                    color: "transparent"
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: function (event) {
                            popup.close();
                            event.accepted = true;
                        }
                    }
                }

                onOpened: loginScreen.safeStateChange("popup")
                onClosed: loginScreen.safeStateChange("normal")

                modal: true
                popupType: Popup.Item
                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
                focus: visible

                SessionSelector {
                    focus: popup.focus
                    onSessionChanged: function (newSessionIndex, sessionIcon, sessionLabel) {
                        loginScreen.sessionIndex = newSessionIndex;
                        sessionButton.icon = sessionIcon;
                        sessionButton.label = sessionButton.showLabel ? sessionLabel : "";
                    }
                    onClose: {
                        popup.close();
                    }
                }

                Component.onCompleted: {
                    [x, y] = menuArea.calculatePopupPos("up", "center", popup, sessionButton);
                }
            }
        }
    }

    Component {
        id: keyboardMenuComponent

        IconButton {
            id: keyboardButton

            height: 36
            width: 36
            icon: Config.getIcon("keyboard.svg")
            iconSize: 16
            borderSize: 1
            borderColor: active || focus ? "#6CCBA6F7" : "#2512091c"
            backgroundColor: "#ffffff"
            backgroundOpacity: 0.15
            activeBackgroundColor: "#12091c"
            activeBackgroundOpacity: 0.7
            contentColor: "#12091c"
            activeContentColor: "#ffffff"
            active: showKeyboard
            fontFamily: "system"
            borderRadius: 6
            enabled: loginScreen.showKeyboard || loginScreen.state === "normal"
            activeFocusOnTab: true
            focus: false
            onClicked: {
                loginScreen.showKeyboard = !loginScreen.showKeyboard;
            }
            tooltipText: "Toggle virtual keyboard"
        }
    }

    Component {
        id: powerMenuComponent

        IconButton {
            id: powerButton

            height: 36
            width: 36
            icon: Config.getIcon("power.svg")
            iconSize: 16
            contentColor: "#12091c"
            activeContentColor: "#ffffff"
            fontFamily: "system"
            active: popup.visible
            borderRadius: 6
            borderSize: 1
            borderColor: active || focus ? "#6CCBA6F7" : "#2512091c"
            backgroundColor: "#ffffff"
            backgroundOpacity: 0.15
            activeBackgroundColor: "#12091c"
            activeBackgroundOpacity: 0.7
            enabled: loginScreen.state === "normal" || popup.visible
            activeFocusOnTab: true
            focus: false
            onClicked: {
                popup.open();
            }
            tooltipText: "Power options"

            Popup {
                id: popup
                parent: powerButton
                background: Rectangle {
                    color: "#ffffff"
                    opacity: 0.65
                    radius: 6

                    Rectangle {
                        anchors.fill: parent
                        visible: true
                        radius: parent.radius
                        color: "transparent"
                        border {
                            color: "#2012091c"
                            width: 1
                        }
                    }
                }
                dim: true
                padding: 5
                Overlay.modal: Rectangle {
                    color: "transparent"
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: function (event) {
                            popup.close();
                            event.accepted = true;
                        }
                    }
                }

                onOpened: loginScreen.safeStateChange("popup")
                onClosed: loginScreen.safeStateChange("normal")

                modal: true
                popupType: Popup.Item
                closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
                focus: visible

                PowerMenu {
                    focus: popup.focus
                    onClose: {
                        popup.close();
                    }
                }

                Component.onCompleted: {
                    [x, y] = menuArea.calculatePopupPos("up", "center", popup, powerButton);
                }
            }
        }
    }

    Row {
        id: bottomCenterButtons

        height: childrenRect.height
        width: childrenRect.width
        spacing: 8

        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
            bottomMargin: 30
        }
    }

    property var createdObjects: []

    Component.onCompleted: {
        var createdObject;

        createdObject = sessionMenuComponent.createObject(bottomCenterButtons, {});
        if (createdObject) {
            createdObjects.push(createdObject);
        }

        createdObject = keyboardMenuComponent.createObject(bottomCenterButtons, {});
        if (createdObject) {
            createdObjects.push(createdObject);
        }

        createdObject = powerMenuComponent.createObject(bottomCenterButtons, {});
        if (createdObject) {
            createdObjects.push(createdObject);
        }
    }

    Component.onDestruction: {
        for (var i = 0; i < createdObjects.length; i++) {
            if (createdObjects[i]) {
                createdObjects[i].destroy();
            }
        }
        createdObjects = [];
    }

    function calculatePopupPos(direction, align, popup, button) {
        var popupMargin = 5;
        var x = 0, y = 0;

        if (direction === "up") {
            y = -popup.height - popupMargin;
            if (align === "start") {
                x = 0;
            } else if (align === "end") {
                x = -popup.width + button.width;
            } else {
                x = (button.width - popup.width) / 2;
            }
        } else if (direction === "down") {
            y = button.height + popupMargin;
            if (align === "start") {
                x = 0;
            } else if (align === "end") {
                x = -popup.width + button.width;
            } else {
                x = (button.width - popup.width) / 2;
            }
        } else if (direction === "left") {
            x = -popup.width - popupMargin;
            if (align === "start") {
                y = 0;
            } else if (align === "end") {
                y = -popup.height + button.height;
            } else {
                y = (button.height - popup.height) / 2;
            }
        } else {
            x = button.width + popupMargin;
            if (align === "start") {
                y = 0;
            } else if (align === "end") {
                y = -popup.height + button.height;
            } else {
                y = (button.height - popup.height) / 2;
            }
        }
        return [x, y];
    }
}