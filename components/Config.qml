pragma Singleton

import QtQuick

QtObject {
    // [General]
    property real generalScale: 1.0
    property bool enableAnimations: true

    property string backgroundFillMode: "fill"

    // [LockScreen]
    property bool lockScreenDisplay: true
    property int lockScreenPaddingTop: 100
    property int lockScreenPaddingRight: 0
    property int lockScreenPaddingBottom: 0
    property int lockScreenPaddingLeft: 150
    property string lockScreenBackground: "default.mp4"

    property int lockScreenBlur: 32
    property real lockScreenBrightness: 0.0
    property real lockScreenSaturation: 0.0

    // [LockScreen.Clock]
    property bool clockDisplay: true
    property string clockPosition: "center-left"
    property string clockAlign: "center"
    property string clockFormat: "hh:mm"
    property string clockFontFamily: "Supermercado"
    property int clockFontSize: 120
    property int clockFontWeight: 900
    property color clockColor: "#ffaab4"

    // [LockScreen.Date]
    property bool dateDisplay: true
    property string dateFormat: "dddd, MMMM dd, yyyy"
    property string dateFontFamily: "Supermercado"
    property int dateFontSize: 25
    property int dateFontWeight: 600
    property color dateColor: "#ffaab4"
    property int dateMarginTop: -15

    // [LockScreen.Message]
    property bool lockMessageDisplay: false
    property string lockMessagePosition: "bottom-center"
    property string lockMessageAlign: "center"
    property string lockMessageText: "Press any key"
    property string lockMessageFontFamily: "Supermercado"
    property int lockMessageFontSize: 12
    property int lockMessageFontWeight: 400
    property bool lockMessageDisplayIcon: true
    property string lockMessageIcon: "enter.svg"
    property int lockMessageIconSize: 16
    property color lockMessageColor: "#ffaab4"
    property bool lockMessagePaintIcon: true
    property int lockMessageSpacing: 0

    // [LoginScreen]
    property string loginScreenBackground: "default.mp4"

    property int loginScreenBlur: 0
    property real loginScreenBrightness: 0.0
    property real loginScreenSaturation: 0.0

    // [LoginScreen.LoginArea]
    property string loginAreaPosition: "left"
    property int loginAreaMargin: 150
    property int loginAreaMarginTop: 100

    // [LoginScreen.LoginArea.Avatar]
    property int avatarBorderRadius: 30
    property int avatarActiveSize: 100
    property int avatarInactiveSize: 70
    property real avatarInactiveOpacity: 0.35
    property int avatarActiveBorderSize: 3
    property int avatarInactiveBorderSize: 3
    property color avatarActiveBorderColor: "#ffaab4"
    property color avatarInactiveBorderColor: "#ffaab4"

    // [LoginScreen.LoginArea.Username]
    property string usernameFontFamily: "Supermercado"
    property int usernameFontSize: 24
    property int usernameFontWeight: 700
    property color usernameColor: "#ffaab4"
    property int usernameMargin: 10

    // [LoginScreen.LoginArea.PasswordInput]
    property int passwordInputWidth: 180
    property int passwordInputHeight: 45
    property bool passwordInputDisplayIcon: true
    property string passwordInputFontFamily: "Supermercado"
    property int passwordInputFontSize: 18
    property string passwordInputIcon: "password.svg"
    property int passwordInputIconSize: 24
    property color passwordInputContentColor: "#ffaab4"
    property color passwordInputBackgroundColor: "#000000"
    property real passwordInputBackgroundOpacity: 0.0
    property int passwordInputBorderSize: 2
    property color passwordInputBorderColor: "#ffaab4"
    property int passwordInputBorderRadiusLeft: 10
    property int passwordInputBorderRadiusRight: 10
    property int passwordInputMarginTop: 10
    property string passwordInputMaskedCharacter: "●"
    
    // [LoginScreen.LoginArea.LoginButton]
    property color loginButtonBackgroundColor: "#ffaab4"
    property real loginButtonBackgroundOpacity: 0.0
    property color loginButtonActiveBackgroundColor: "#ffaab4"
    property real loginButtonActiveBackgroundOpacity: 1.0
    property string loginButtonIcon: "arrow-right.svg"
    property int loginButtonIconSize: 26
    property color loginButtonContentColor: "#ffaab4"
    property color loginButtonActiveContentColor: "#000000"
    property int loginButtonBorderSize: 2
    property color loginButtonBorderColor: "#ffaab4"
    property int loginButtonBorderRadiusLeft: 10
    property int loginButtonBorderRadiusRight: 10
    property int loginButtonMarginLeft: 5
    property bool loginButtonShowTextIfNoPassword: true
    property bool loginButtonHideIfNotNeeded: true
    property string loginButtonFontFamily: "Supermercado"
    property int loginButtonFontSize: 12
    property int loginButtonFontWeight: 600

    // [LoginScreen.LoginArea.Spinner]
    property bool spinnerDisplayText: true
    property string spinnerText: "Logging in"
    property string spinnerFontFamily: "Supermercado"
    property int spinnerFontWeight: 600
    property int spinnerFontSize: 14
    property int spinnerIconSize: 30
    property string spinnerIcon: "spinner.svg"
    property color spinnerColor: "#ffaab4"
    property int spinnerSpacing: 5

    // [LoginScreen.LoginArea.WarningMessage]
    property string warningMessageFontFamily: "Supermercado"
    property int warningMessageFontSize: 11
    property int warningMessageFontWeight: 400
    property color warningMessageNormalColor: "#ffaab4"
    property color warningMessageWarningColor: "#ffaab4"
    property color warningMessageErrorColor: "#ffaab4"
    property int warningMessageMarginTop: 10

    // [LoginScreen.MenuArea.Buttons]
    property int menuAreaButtonsMarginTop: 0
    property int menuAreaButtonsMarginRight: 0
    property int menuAreaButtonsMarginBottom: 100
    property int menuAreaButtonsMarginLeft: 150
    property int menuAreaButtonsSize: 45
    property int menuAreaButtonsBorderRadius: 5
    property int menuAreaButtonsSpacing: 10
    property string menuAreaButtonsFontFamily: "Supermercado"

    // [LoginScreen.MenuArea.Popups]
    property int menuAreaPopupsMaxHeight: 300
    property int menuAreaPopupsItemHeight: 30
    property int menuAreaPopupsSpacing: 2
    property int menuAreaPopupsPadding: 5
    property bool menuAreaPopupsDisplayScrollbar: false
    property int menuAreaPopupsMargin: 5
    property color menuAreaPopupsBackgroundColor: "#000000"
    property real menuAreaPopupsBackgroundOpacity: 1.0
    property color menuAreaPopupsActiveOptionBackgroundColor: "#ffaab4"
    property real menuAreaPopupsActiveOptionBackgroundOpacity: 1.0
    property color menuAreaPopupsContentColor: "#ffaab4"
    property color menuAreaPopupsActiveContentColor: "#000000"
    property string menuAreaPopupsFontFamily: "Supermercado"
    property int menuAreaPopupsBorderSize: 2
    property color menuAreaPopupsBorderColor: "#ffaab4"
    property int menuAreaPopupsFontSize: 11
    property int menuAreaPopupsIconSize: 16

    // [LoginScreen.MenuArea.Session]
    property bool sessionDisplay: true
    property string sessionPosition: "bottom-left"
    property int sessionIndex: 4
    property string sessionPopupDirection: "up"
    property string sessionPopupAlign: "center"
    property bool sessionDisplaySessionName: true
    property int sessionButtonWidth: 100
    property int sessionPopupWidth: 200
    property color sessionBackgroundColor: "#ffaab4"
    property real sessionBackgroundOpacity: 0.0
    property real sessionActiveBackgroundOpacity: 1.0
    property color sessionContentColor: "#ffaab4"
    property color sessionActiveContentColor: "#000000"
    property int sessionBorderSize: 0
    property int sessionFontSize: 10
    property int sessionIconSize: 24

    // [LoginScreen.MenuArea.Keyboard]
    property bool keyboardDisplay: true
    property string keyboardPosition: "bottom-left"
    property int keyboardIndex: 2
    property color keyboardBackgroundColor: "#ffaab4"
    property real keyboardBackgroundOpacity: 0.0
    property real keyboardActiveBackgroundOpacity: 1.0
    property color keyboardContentColor: "#ffaab4"
    property color keyboardActiveContentColor: "#000000"
    property int keyboardBorderSize: 0
    property string keyboardIcon: "keyboard.svg"
    property int keyboardIconSize: 24

    // [LoginScreen.MenuArea.Power]
    property bool powerDisplay: true
    property string powerPosition: "bottom-left"
    property int powerIndex: 1
    property string powerPopupDirection: "up"
    property string powerPopupAlign: "center"
    property int powerPopupWidth: 100
    property color powerBackgroundColor: "#ffaab4"
    property real powerBackgroundOpacity: 0.0
    property real powerActiveBackgroundOpacity: 1.0
    property color powerContentColor: "#ffaab4"
    property color powerActiveContentColor: "#000000"
    property int powerBorderSize: 0
    property string powerIcon: "power.svg"
    property int powerIconSize: 24

    // [LoginScreen.VirtualKeyboard]
    property real virtualKeyboardScale: 1.0
    property string virtualKeyboardPosition: "login"
    property bool virtualKeyboardStartHidden: true
    property color virtualKeyboardBackgroundColor: "#000000"
    property real virtualKeyboardBackgroundOpacity: 1.0
    property color virtualKeyboardKeyContentColor: "#ffaab4"
    property color virtualKeyboardKeyColor: "#000000"
    property real virtualKeyboardKeyOpacity: 1.0
    property color virtualKeyboardKeyActiveBackgroundColor: "#000000"
    property real virtualKeyboardKeyActiveOpacity: 0.0
    property color virtualKeyboardSelectionBackgroundColor: "#303030"
    property color virtualKeyboardSelectionContentColor: "#ffaab4"
    property color virtualKeyboardPrimaryColor: "#8c90c2"
    property int virtualKeyboardBorderSize: 2
    property color virtualKeyboardBorderColor: "#ffaab4"
    property string virtualKeyboardRestrictInput: "none"

    // [Tooltips]
    property bool tooltipsEnable: true
    property string tooltipsFontFamily: "Supermercado"
    property int tooltipsFontSize: 11
    property color tooltipsContentColor: "#ffaab4"
    property color tooltipsBackgroundColor: "#000000"
    property real tooltipsBackgroundOpacity: 1.0
    property int tooltipsBorderRadius: 5
    property bool tooltipsDisableUser: false
    property bool tooltipsDisableLoginButton: false

    function sortMenuButtons() {
        var menus = [];
        var available_positions = ["top-left", "top-center", "top-right", "center-left", "center-right", "bottom-left", "bottom-center", "bottom-right"];

        if (sessionDisplay)
            menus.push({
                name: "session",
                index: sessionIndex,
                def_index: 0,
                position: available_positions.includes(sessionPosition) ? sessionPosition : "bottom-left"
            });

        if (keyboardDisplay)
            menus.push({
                name: "keyboard",
                index: keyboardIndex,
                def_index: 2,
                position: available_positions.includes(keyboardPosition) ? keyboardPosition : "bottom-right"
            });

        if (powerDisplay)
            menus.push({
                name: "power",
                index: powerIndex,
                def_index: 3,
                position: available_positions.includes(powerPosition) ? powerPosition : "bottom-right"
            });

        // Sort by index or default index if 0
        return menus.sort((c, n) => c.index - n.index || c.def_index - n.def_index);
    }

    function getIcon(iconName) {
        var ext_arr = iconName.split(".");
        var ext = ext_arr.length > 1 ? ext_arr[ext_arr.length - 1] : "";
        return Qt.resolvedUrl(`../icons/${iconName}${ext === "" ? ".svg" : ""}`);
    }
}
