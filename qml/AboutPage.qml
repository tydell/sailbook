import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.Components.Popups 1.3



/* General info about the application */
Dialog {
       id: aboutDialogue
       title: qsTr("About Sailbook")
       text: qsTr("Sailbook: version 1.5 <br><br> Copyright (c) 2017-2018 <br> by Rudi Timmermans  <br><br> E-Mail: <a href=\"mailto://rudi.timmer@gmx.us\">rudi.timmer@gmx.us</a> <br><br> Thanks to: <br><br> Alain Molteni <br> for the icon and splash screen <br><br> Sander Klootwijk, <br> Joan CiberSheep <br> for testing")
       Button {
           text: qsTr("Close")
           onClicked: PopupUtils.close(aboutDialogue)
       }
}
