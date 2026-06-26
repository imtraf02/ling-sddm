pragma Singleton

import QtQuick

QtObject {
    // General
    property real generalScale: 1.0
    property bool enableAnimations: true
    property string backgroundFillMode: "fill"
    property real inputBlurAmount: 1.0

    // Background
    property string lockScreenBackground: "meow.png"
    property string loginScreenBackground: "meow.png"
    property bool lockScreenDisplay: true

    // Icon helper
    function getIcon(iconName) {
        var ext_arr = iconName.split(".");
        var ext = ext_arr.length > 1 ? ext_arr[ext_arr.length - 1] : "";
        return Qt.resolvedUrl("../assets/icons/" + iconName + (ext === "" ? ".svg" : ""));
    }
}
