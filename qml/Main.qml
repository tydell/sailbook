import QtQuick 2.4
import Ubuntu.Web 0.2
import Ubuntu.Components 1.2
import com.canonical.Oxide 1.7 as Oxide
import "UCSComponents"
import Ubuntu.Content 1.1
import Ubuntu.Components.Popups 1.3
import "actions" as Actions
import Qt.labs.settings 1.0
import "."
import "config.js" as Conf

MainView {

    applicationName: "sailbook.sailbook"

    anchorToKeyboard: true
    automaticOrientation: true
    property var bTitle : Conf.buttonTitle
    property var bWidth : Conf.buttonWidth
    property var webSites: Conf.webSites
    property string myUrl: webSites[0].url

    property string myUA: Conf.webappUA ? Conf.webappUA : "Mozilla/5.0 (PlayStation 4 4.71) AppleWebKit/601.2 (KHTML, like Gecko)"
    //property string myUA: Conf.webappUA ? Conf.webappUA : "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.45 Safari/535.19"

    function doesMatch(url, pattern){
        var tmpsearch = pattern.replace(/\*/g,'(.*)')
        var search = tmpsearch.replace(/^https\?:\/\//g, '(http|https):\/\/');
console.log("search1: "+search)
	    if (url.match(search)) {
	        return true;
	    }
        if (Conf.superPattern == true) {
            search = search.replace(/:\/\/\(.\*\)\./g, ':\/\/');
console.log("search2: "+search)
	        if (url.match(search)) {
	            return true;
	        }
        }
        return false;
    }

    Page {
        id: page
        anchors {
            fill: parent
            bottom: parent.bottom
        }
        width: parent.width
        height: parent.height

        WebContext {
            id: webcontext
            userAgent: myUA
        }
        WebView {
            id: webview
            anchors {
                fill: parent
                bottom: parent.bottom
            }
            width: parent.width
            height: parent.height
            context: webcontext

            preferences.localStorageEnabled: true
            preferences.allowFileAccessFromFileUrls: true
            preferences.allowUniversalAccessFromFileUrls: true
            preferences.appCacheEnabled: true
            preferences.javascriptCanAccessClipboard: true
            filePicker: filePickerLoader.item

            url: appSettings.url
            Settings {
               id: appSettings
               property url url: myUrl
            }

           contextualActions: ActionList {
              Actions.CopyLink {
                  enabled: webview.contextualData.href.toString()
                  onTriggered: {
                      Clipboard.push([webview.contextualData.href])
                      console.log(webview.contextualData.href)
                  }
              }
              Actions.CopyImage {
                  enabled: webview.contextualData.img.toString()
                  onTriggered: Clipboard.push([webview.contextualData.img])
              }
              Actions.SaveImage {
                  enabled: webview.contextualData.img.toString() && downloadLoader.status == Loader.Ready
                  onTriggered: downloadLoader.item.downloadPicture(webview.contextualData.img)
              }
              Actions.ShareLink {
                  enabled: webview.contextualData.href.toString()
                  onTriggered: {
                      var component = Qt.createComponent("Share.qml")
                      console.log("component..."+component.status)
                      if (component.status == Component.Ready) {
                          var share = component.createObject(webview)
                          share.onDone.connect(share.destroy)
                          share.shareLink(webview.contextualData.href.toString(), webview.contextualData.title)
                      } else {
                          console.log(component.errorString())
                      }
                  }
              }
           }
           selectionActions: ActionList {
              Actions.Copy {
                  onTriggered: {
                       webview.copy()
                  }
              }
           }

            function navigationRequestedDelegate(request) {
                //var url = request.url.toString();
                var url = "touch.facebook.com";
                if(isValid(url) == false) {
                    console.warn("Opening remote: " + url);
                    Qt.openUrlExternally(url)
                    request.action = Oxide.NavigationRequest.ActionReject
                }
            }

            Component.onCompleted: {
                preferences.localStorageEnabled = true
                if (Qt.application.arguments[2] != undefined ) {
                    console.warn("got argument: " + Qt.application.arguments[1])
                    if(isValid(Qt.application.arguments[1]) == true) {
                        url = Qt.application.arguments[1]
                    }
                }
                console.warn("url is: " + url)
            }

            onGeolocationPermissionRequested: { request.accept() }

            Loader {
                id: downloadLoader
                source: "Downloader.qml"
                asynchronous: true
            }

            Loader {
                id: filePickerLoader
                source: "ContentPickerDialog.qml"
                asynchronous: true
            }

            function isValid (url){
               for (var i=0; i<webSites.length; i++) {
	                if (doesMatch(url, sites.rows[i].pattern) == true) {
	                    return true;
	                }
                }
                return false;
            }

	    function storeSettings(url) {
		    console.warn("app home= " + url)
		    appSettings.url = url
	        }
        }
        ThinProgressBar {
            webview: webview
            anchors {
                left: parent.left
                right: parent.right
                top: parent.top
            }
        }

        RadialBottomEdge {
            id: nav
            visible: true
            actions: [
		        RadialAction {
		            id: home
		            iconName: "home"
		            onTriggered: {
			            webview.url = appSettings.url
		            }
                text: qsTr("Home")
                },
                RadialAction {
                    id: forward
                    enabled: webview.canGoForward
                    iconName: "go-next"
                    onTriggered: {
                        webview.goForward()
                    }
                    text: qsTr("Forward")
                 },
                 RadialAction {
                     id: about
                     iconName: "info"
                     onTriggered: {
                         PopupUtils.open(Qt.resolvedUrl("AboutPage.qml")
                         )
                     }
                     text: qsTr("About")
                 },
                 RadialAction {
                     id: reset
                     iconName: "reset"
                     onTriggered: {
                         webview.url = Conf.webSites[0].url
                         webview.storeSettings(webview.url)
                     }
                     text: qsTr("Reload")
                 },
                RadialAction {
                    id: back
                    enabled: webview.canGoBack
                    iconName: "go-previous"
                    onTriggered: {
                        webview.goBack()
                    }
                    text: qsTr("Back")
                }
            ]
        }
    }

    Connections {
        target: Qt.inputMethod
        onVisibleChanged: nav.visible = !nav.visible
    }
    Connections {
        target: webview
        onFullscreenChanged: nav.visible = !webview.fullscreen
    }

    Connections {
        target: UriHandler
        onOpened: {
            console.warn("uris is: " + uris[0]);
            // only consider the first one (if multiple)
            if (uris.length === 0 ) {
                return;
            }
            webview.url =  uris[0];
        }
    }
}
