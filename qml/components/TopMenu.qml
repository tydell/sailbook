import QtQuick 2.4
import Ubuntu.Web 0.2
import Ubuntu.Components 1.3
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.Popups 1.3
import Ubuntu.Content 1.1

Rectangle {
    id: topMenu
    z: 100000
    width: parent.width
    height: units.gu(6)
    color: "#3b5998"

    Rectangle {
        width: parent.width
        height: units.gu(0.1)
        color: UbuntuColors.lightGrey
    }

    Row {
        width: parent.width
        height: parent.height-units.gu(0.2)
        anchors {
            centerIn: parent
        }

        Item {
            width: parent.width/11
            height: parent.height

            Icon {
                anchors.centerIn: parent
                width: units.gu(3.2)
                height: width
                name: "home"
                color: "#ffffff"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    webview.url = 'https://touch.facebook.com'
                }
            }
        }

        Item {
            width: parent.width/11
            height: parent.height

            Icon {
                anchors.centerIn: parent
                width: units.gu(3.2)
                height: width
                name: "contact-group"
                color: "#ffffff"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    webview.url = 'https://touch.facebook.com/friends'
                }
            }
        }

        Item {
            width: parent.width/11
            height: parent.height

            Icon {
                anchors.centerIn: parent
                width: units.gu(3.2)
                height: width
                name: "messaging-app-symbolic"
                color: "#ffffff"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    webview.url = 'https://touch.facebook.com/messages'
                }
            }
        }

        Item {
            width: parent.width/11
            height: parent.height

            Icon {
                anchors.centerIn: parent
                width: units.gu(3.2)
                height: width
                name: "notification"
                color: "#ffffff"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    webview.url = 'https://touch.facebook.com/notifications'
                }
            }
        }

        Item {
            width: parent.width/11
            height: parent.height

            Icon {
                anchors.centerIn: parent
                width: units.gu(3.2)
                height: width
                name: "rssreader-app-symbolic"
                color: "#ffffff"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    webview.url = 'https://touch.facebook.com/groups'
                }
            }
        }

        Item {
            width: parent.width/11
            height: parent.height

            Icon {
                anchors.centerIn: parent
                width: units.gu(3.2)
                height: width
                name: "event"
                color: "#ffffff"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    webview.url = 'https://touch.facebook.com/events'
                }
            }
        }

        Item {
            width: parent.width/11
            height: parent.height

            Icon {
                anchors.centerIn: parent
                width: units.gu(3.2)
                height: width
                name: "go-previous"
                color: "#ffffff"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    webview.goBack()
                }
            }
        }

        Item {
            width: parent.width/11
            height: parent.height

            Icon {
                anchors.centerIn: parent
                width: units.gu(3.2)
                height: width
                name: "go-next"
                color: "#ffffff"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    webview.goForward()
                }
            }
        }

        Item {
            width: parent.width/11
            height: parent.height

            Icon {
                anchors.centerIn: parent
                width: units.gu(3.2)
                height: width
                name: "settings"
                color: "#ffffff"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    webview.url = 'https://touch.facebook.com/settings'
                }
            }
        }

        Item {
            width: parent.width/11
            height: parent.height

            Icon {
                anchors.centerIn: parent
                width: units.gu(3.2)
                height: width
                name: "info"
                color: "#ffffff"
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
