import QtQuick 2.0
import QtQuick.Dialogs 1.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0 as Popups

Component {
    Popups.Dialog {
        FileDialog {
            id: fileDialog
            title: i18n.tr("Please choose a file")
            selectMultiple: model.allowMultipleFiles

            onAccepted: {
                var selectedFiles = []
                for(var i in fileDialog.fileUrls) {
                    selectedFiles.push(fileDialog.fileUrls[i].replace("file://", ""))
                }
                model.accept(selectedFiles)
            }

            onRejected: {
                model.reject()
            }
            Component.onCompleted: visible = true
        }
    }
}
