import QtQuick 2.0
import Ubuntu.Components 1.1

ProgressBar {
    property var webview

    height: units.dp(3)

    showProgressPercentage: false
    value: webview ? webview.loadProgress / 100 : 0.0
    property color color: "#3F548D"
    visible: webview ? webview.loading
                       && !webview.lastLoadStopped
                     : false

    clip: true

    Rectangle {
    id: border
    anchors.fill: parent

    color: "#3F548D"
    border.width: 0
    border.color: parent.color
    }
   }
