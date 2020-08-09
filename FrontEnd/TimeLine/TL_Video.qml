import QtQuick 2.12
import QtQuick.Controls 2.12

import "../RC"

Item {
    property alias repeater: repeater
    //BG
    Label {
        anchors.centerIn: parent
        text: "NULL VIDEO BUFFER"
        font: fontAssets.eliantoFontLoader.name
        color: "white"
    }

    Row {
        anchors.fill: parent

        Repeater {
            id: repeater
            property bool stateTrigger: CppTimeLine.stateTrigger
            onCountChanged: {
                reCalc()
            }
            onStateTriggerChanged: {
                reCalc()
            }

            // funcs
            function reCalc() {
                for (let i = 0; i < count; i++) {
                    repeater.itemAt(i).reCalc()
                }
            }
            model: CppTimeLine.model
            delegate: TL_Video_delegate {}
        }
    }


}
