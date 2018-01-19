import QtQuick 2.4
import Ubuntu.Web 0.2
import Ubuntu.Components 1.3
import com.canonical.Oxide 1.19 as Oxide
import Ubuntu.Components.Popups 1.3
import "UCSComponents"
import Ubuntu.Content 1.1
import "actions" as Actions
import QtMultimedia 5.0
import QtFeedback 5.0
import Ubuntu.Unity.Action 1.1 as UnityActions
import "."
import "config.js" as Conf
import "."

MainView {
    objectName: "mainView"

    applicationName: "sailbook.sailbook"

    anchorToKeyboard: true
    automaticOrientation: true


    property string myUrl: Conf.webappUrl
    property string myPattern: Conf.webappUrlPattern

    property string myUA: Conf.webappUA ? Conf.webappUA : "Mozilla/5.0 (PlayStation 4 4.71) AppleWebKit/601.2 (KHTML, like Gecko)"

    Page {
        id: page
        header: Rectangle {
            color: UbuntuColors.orange
            width: parent.width
            height: units.gu(0)
            }
        anchors {
            fill: parent
            bottom: parent.bottom
        }
        width: parent.width
        height: parent.height

        HapticsEffect {
            id: vibration
            attackIntensity: 0.0
            attackTime: 50
            intensity: 1.0
            duration: 10
            fadeTime: 50
            fadeIntensity: 0.0
        }

        SoundEffect {
            id: clicksound
            source: "../sounds/Click.wav"
        }

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
            url: myUrl

            preferences.localStorageEnabled: true
            preferences.allowFileAccessFromFileUrls: true
            preferences.allowUniversalAccessFromFileUrls: true
            preferences.appCacheEnabled: true
            preferences.javascriptCanAccessClipboard: true

            contextualActions: ActionList {

    /// strange...
            Action {
             text: i18n.tr(webview.contextualData.href.toString())
                    enabled: contextualData.herf.toString()
              }

     /// didn't seem to work without a item that is always triggered...
        Action {
            text: i18n.tr("Copy Link")
                   enabled: webview.contextualData.href.toString()

                   //contextualData.href.toString()
            onTriggered: Clipboard.push([webview.contextualData.href])
              }

               Action {
                  text: i18n.tr("Share Link")
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

               Action {
                  text: i18n.tr("Copy Image")
                  enabled: webview.contextualData.img.toString()
                  onTriggered: Clipboard.push([webview.contextualData.img])
               }

               Action {
                   text: i18n.tr("Download Image")
                   enabled: webview.contextualData.img.toString() && downloadLoader.status == Loader.Ready
                   onTriggered: downloadLoader.item.downloadPicture(webview.contextualData.img)
               }
            }

            Component {
                id: customDieDialogComponent

                CustomDieDialog {
                    id: customDieDialog
                }
            }

            function navigationRequestedDelegate(request) {
                var url = request.url.toString();

                if (Conf.hapticLinks) {
                    vibration.start()
                }

                if (Conf.audibleLinks) {
                    clicksound.play()
                }

                if(isValid(url) == false) {
                    console.warn("Opening remote: " + url);
                    PopupUtils.open(customDieDialogComponent, url)
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

            filePicker: pickerComponent

            function isValid (url){
                var pattern = myPattern.split(',');
                for (var i=0; i<pattern.length; i++) {
                    var tmpsearch = pattern[i].replace(/\*/g,'(.*)')
                    var search = tmpsearch.replace(/^https\?:\/\//g, '(http|https):\/\/');
                    if (url.match(search)) {
                       return true;
                    }
                }
                return false;
            }
        }

        NewProgressBar {
            webview: webview
            width: parent.width + units.gu(5)
            anchors {
                //left: parent.left
               // right: parent.right
               horizontalCenter: parent.horizontalCenter
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
                        webview.url = 'https://touch.facebook.com'
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
                    id: reload
                    iconName: "reload"
                    onTriggered: {
                        webview.reload()
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

    Component {
        id: pickerComponent
        PickerDialog {}
    }

    Connections {
        target: Qt.inputMethod
        onVisibleChanged: nav.visible = !nav.visible
    }
        Connections {
        target: webview
        onFullscreenRequested: webview.fullscreen = fullscreen

        onFullscreenChanged: {
                nav.visible = !webview.fullscreen
                if (webview.fullscreen == true) {
                    window.visibility = 5
                } else {
                    window.visibility = 4
                }
            }
    }
    Connections {
        target: UriHandler
        onOpened: {
            if (uris.length === 0 ) {
                return;
            }
            webview.url = uris[0]
            console.warn("uri-handler request")
        }
    }
}
