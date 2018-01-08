import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3 as Popups
import Ubuntu.Content 0.1
import "MimeTypeMapper.js" as MimeTypeMapper

Component {
    Popups.PopupBase {
        id: picker
        objectName: "contentPickerDialog"

        parent: QuickUtils.rootItem(this)

        property var activeTransfer
        property var selectedItems

        Rectangle {
            anchors.fill: parent

            ContentTransferHint {
                anchors.fill: parent
                activeTransfer: picker.activeTransfer
            }

            ContentPeerPicker {
                id: peerPicker
                anchors.fill: parent
                visible: true
                contentType: ContentType.All
                handler: ContentHandler.Source

                onPeerSelected: {
                    if (model.allowMultipleFiles) {
                        peer.selectionType = ContentTransfer.Multiple
                    } else {
                        peer.selectionType = ContentTransfer.Single
                    }
                    picker.activeTransfer = peer.request()
                    stateChangeConnection.target = picker.activeTransfer
                }

                onCancelPressed: {
                    webview.focus = true
                    model.reject()
                }
            }
        }

        Connections {
            id: stateChangeConnection
            onStateChanged: {
                if (picker.activeTransfer.state === ContentTransfer.Charged) {
                    selectedItems = []
                    for(var i in picker.activeTransfer.items) {
                        selectedItems.push(String(picker.activeTransfer.items[i].url).replace("file://", ""))
                    }
                    acceptTimer.running = true
                }
            }
        }

        Timer {
            id: acceptTimer
            interval: 100
            repeat: true
            onTriggered: {
                if(Qt.application.active) {
                    webview.focus = true
                    model.accept(selectedItems)
                }
            }
        }

        Component.onCompleted: {
            if(acceptTypes.length === 1) {
                var contentType = MimeTypeMapper.mimeTypeToContentType(acceptTypes[0])
                if(contentType == ContentType.Unknown) {
                    // If we don't recognise the type, allow uploads from any app
                    contentType = ContentType.All
                }
                peerPicker.contentType = contentType
            } else {
                peerPicker.contentType = ContentType.All
            }
            show()
        }
    }
}
