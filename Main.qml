import "."
import QtQuick
import SddmComponents
import QtQuick.Effects
import QtMultimedia
import "components"

Item {
    id: root
    state: Config.lockScreenDisplay ? "lockState" : "loginState"

    FontLoader {
        source: "fonts/supermercado-one/SupermercadoOne-Regular.ttf"
    }

    property bool capsLockOn: false
    Component.onCompleted: {
        if (keyboard)
            capsLockOn = keyboard.capsLock;
    }
    onCapsLockOnChanged: {
        loginScreen.updateCapsLock();
    }

    states: [
        State {
            name: "lockState"
            PropertyChanges {
                target: lockScreen
                opacity: 1.0
            }
            PropertyChanges {
                target: loginScreen
                opacity: 0.0
            }
            PropertyChanges {
                target: loginScreen.loginContainer
                scale: 0.5
            }
            PropertyChanges {
                target: backgroundEffect
                blurMax: Config.lockScreenBlur
                brightness: Config.lockScreenBrightness
                saturation: Config.lockScreenSaturation
            }
        },
        State {
            name: "loginState"
            PropertyChanges {
                target: lockScreen
                opacity: 0.0
            }
            PropertyChanges {
                target: loginScreen
                opacity: 1.0
            }
            PropertyChanges {
                target: loginScreen.loginContainer
                scale: 1.0
            }
            PropertyChanges {
                target: backgroundEffect
                blurMax: Config.loginScreenBlur
                brightness: Config.loginScreenBrightness
                saturation: Config.loginScreenSaturation
            }
        }
    ]
    transitions: Transition {
        enabled: Config.enableAnimations
        PropertyAnimation {
            duration: 150
            properties: "opacity"
        }
        PropertyAnimation {
            duration: 400
            properties: "blurMax"
        }
        PropertyAnimation {
            duration: 400
            properties: "brightness"
        }
        PropertyAnimation {
            duration: 400
            properties: "saturation"
        }
    }

    Item {
        id: mainFrame
        property variant geometry: screenModel.geometry(screenModel.primary)
        x: geometry.x
        y: geometry.y
        width: geometry.width
        height: geometry.height
        
        Rectangle {
            anchors.fill: parent
            color: "black"
        }

        property string tsource: root.state === "lockState" ? Config.lockScreenBackground : Config.loginScreenBackground

        MediaPlayer {
            id: mediaPlayer
            source: {
                if (!mainFrame.tsource || mainFrame.tsource.toString().length === 0) return "";
                var src = mainFrame.tsource.startsWith("/") || mainFrame.tsource.startsWith("file://") || mainFrame.tsource.startsWith("qrc:/") 
                    ? mainFrame.tsource 
                    : Qt.resolvedUrl("./backgrounds/" + mainFrame.tsource);
                return src;
            }
            loops: MediaPlayer.Infinite
            videoOutput: backgroundVideoOutput
            audioOutput: AudioOutput {
                muted: true
            }
            autoPlay: true
            Component.onCompleted: play()
        }

        VideoOutput {
            id: backgroundVideoOutput
            anchors.fill: parent
            fillMode: {
                if (Config.backgroundFillMode === "stretch") return VideoOutput.Stretch;
                if (Config.backgroundFillMode === "fit") return VideoOutput.PreserveAspectFit;
                return VideoOutput.PreserveAspectCrop;
            }
        }

        MultiEffect {
            // Background effects
            id: backgroundEffect
            source: backgroundVideoOutput
            anchors.fill: parent
            blurEnabled: blurMax > 0
            blur: blurMax > 0 ? 1.0 : 0.0
            autoPaddingEnabled: false
        }

        Item {
            id: screenContainer
            anchors.fill: parent
            anchors.top: parent.top

            LockScreen {
                id: lockScreen
                z: root.state === "lockState" ? 2 : 1 // Fix tooltips from the login screen showing up on top of the lock screen.
                anchors.fill: parent
                focus: root.state === "lockState"
                enabled: root.state === "lockState"
                onLoginRequested: {
                    root.state = "loginState";
                    loginScreen.resetFocus();
                }
            }
            LoginScreen {
                id: loginScreen
                z: root.state === "loginState" ? 2 : 1
                anchors.fill: parent
                enabled: root.state === "loginState"
                opacity: 0.0
                onClose: {
                    root.state = "lockState";
                }
            }
        }
    }
}
