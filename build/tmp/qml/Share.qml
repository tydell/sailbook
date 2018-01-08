import QtQuick 2.0
import Ubuntu.Components 1.1
import Ubuntu.Components.Popups 1.0
import Ubuntu.DownloadManager 0.1
import Ubuntu.Content 0.1

Item {
    id: shareItem

    signal done()

    Component {
        id: shareDialog
        ContentShareDialog {
            Component.onDestruction: shareItem.done()
        }
    }

    Component {
        id: contentItemComponent
        ContentItem { }
    }

    function share(url, name, contentType) {
        var sharePopup = PopupUtils.open(shareDialog, shareItem, {"contentType" : contentType})
        sharePopup.items.push(contentItemComponent.createObject(shareItem, {"url" : url, "name" : name}))
    }

    function shareLink(url, title) {
        share(url, title, ContentType.Links)
    }

}
