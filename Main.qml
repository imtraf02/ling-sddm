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

        // AnimatedImage { // `.gif`s are seg faulting with multi monitors... QT/SDDM issue?
        Image {
            // Background
            id: backgroundImage
            anchors.fill: parent

            property string tsource: root.state === "lockState" ? Config.lockScreenBackground : Config.loginScreenBackground
            property bool isVideo: {
                if (!tsource || tsource.toString().length === 0)
                    return false;
                var parts = tsource.toString().split(".");
                if (parts.length === 0)
                    return false;
                var ext = parts[parts.length - 1];
                return ["avi", "mp4", "mov", "mkv", "m4v", "webm"].indexOf(ext) !== -1;
            }
            property bool displayColor: root.state === "lockState" && Config.lockScreenUseBackgroundColor || root.state === "loginState" && Config.loginScreenUseBackgroundColor
            property string placeholder: Config.animatedBackgroundPlaceholder

            source: {
                if (tsource.startsWith("/") || tsource.startsWith("file://") || tsource.startsWith("qrc:/")) return tsource;
                return !isVideo ? "backgrounds/" + tsource : (placeholder.length > 0 ? "backgrounds/" + placeholder : "");
            }
            cache: true
            mipmap: true
            fillMode: {
                if (Config.backgroundFillMode === "stretch") return Image.Stretch;
                if (Config.backgroundFillMode === "fit") return Image.PreserveAspectFit;
                return Image.PreserveAspectCrop;
            }

            Rectangle {
                id: backgroundColor
                anchors.fill: parent
                color: root.state === "lockState" && Config.lockScreenUseBackgroundColor ? Config.lockScreenBackgroundColor : root.state === "loginState" && Config.loginScreenUseBackgroundColor ? Config.loginScreenBackgroundColor : "black"
                visible: backgroundImage.displayColor || (backgroundVideoOutput.visible && backgroundImage.placeholder.length === 0)
            }

            MediaPlayer {
                id: mediaPlayer
                source: {
                    if (!backgroundImage.isVideo) return "";
                    if (backgroundImage.tsource.startsWith("/") || backgroundImage.tsource.startsWith("file://") || backgroundImage.tsource.startsWith("qrc:/")) 
                        return backgroundImage.tsource;
                    return Qt.resolvedUrl("backgrounds/" + backgroundImage.tsource);
                }
                loops: MediaPlayer.Infinite
                videoOutput: backgroundVideoOutput
                audioOutput: AudioOutput {
                    muted: true
                }
                autoPlay: true
                onErrorOccurred: function (error, errorString) {
                    if (error !== MediaPlayer.NoError && (!backgroundImage.placeholder || backgroundImage.placeholder.length === 0)) {
                        backgroundImage.displayColor = true;
                    }
                }
            }

            VideoOutput {
                id: backgroundVideoOutput
                anchors.fill: parent
                visible: backgroundImage.isVideo && !backgroundImage.displayColor
                fillMode: {
                    if (Config.backgroundFillMode === "stretch") return VideoOutput.Stretch;
                    if (Config.backgroundFillMode === "fit") return VideoOutput.PreserveAspectFit;
                    return VideoOutput.PreserveAspectCrop;
                }
            }
        }

        MultiEffect {
            // Background effects
            id: backgroundEffect
            source: backgroundImage
            anchors.fill: parent
            blurEnabled: backgroundImage.visible && blurMax > 0
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
