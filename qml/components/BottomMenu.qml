import QtQuick 2.4
import Ubuntu.Web 0.2
import Ubuntu.Components 1.3
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.Popups 1.3
import Ubuntu.Content 1.1

Rectangle {
    id: bottomMenu
    z: 100000
    width: parent.width
    height: units.gu(3)
    anchors {
        bottom: parent.bottom
    }

    Rectangle {
        width: parent.width
        height: units.gu(0.1)
        color: UbuntuColors.lightGrey
    }

    Row {
        width: parent.width
        height: parent.height-units.gu(0.1)
        anchors {
            centerIn: parent
            bottom: parent.bottom
        }

        Item {
            width: parent.width/5
            height: parent.height

            Icon {
                anchors.centerIn: parent
                width: units.gu(2.8)
                height: width
                name: "go-previous"
                color: tabs.selectedTabIndex == 0 ? "#000000" : "#999999"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    webview.goBack()
                }
            }
        }

        Item {
            width: parent.width/5
            height: parent.height

            Icon {
                anchors.centerIn: parent
                width: units.gu(2.8)
                height: width
                name: "go-next"
                color: tabs.selectedTabIndex == 1 ? "#000000" : "#999999"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    webview.goForward()
                }
            }
        }

        Item {
            width: parent.width/5
            height: parent.height

            Icon {
                anchors.centerIn: parent
                width: units.gu(2.8)
                height: width
                name: "reload"
                color: "#999999"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    webview.reload()
                }
            }
        }

        Item {
            width: parent.width/5
            height: parent.height

            Icon {
                anchors.centerIn: parent
                width: units.gu(2.8)
                height: width
                name: "home"
                color: tabs.selectedTabIndex == 2 ? "#000000" : "#999999"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    webview.url = 'https://touch.facebook.com'
                }
            }
        }

        Item {
            width: parent.width/5
            height: parent.height

            Icon {
                anchors.centerIn: parent
                width: units.gu(2.8)
                height: width
                name: "info"
                color: tabs.selectedTabIndex == 3 ? "#000000" : "#999999"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    PopupUtils.open(Qt.resolvedUrl("../AboutPage.qml")
                    )
                }
            }
        }
    }
}



