import QtQuick 2.0
import Ubuntu.Components 1.1

ProgressBar {
    property var webview

    height: units.dp(3)

    showProgressPercentage: false
    value: webview ? webview.loadProgress / 100 : 0.0
    visible: webview ? webview.loading
                       && !webview.lastLoadStopped
                     : false
}
