import QtQuick 2.12
import QtQuick.Controls 2.12

import "../RC"

Item {
    id: root

    //BG
    Label {
        anchors.centerIn: parent
        text: "NULL VIDEO BUFFER"
        font: eliantoFontLoader.name
        color: "white"
    }

    Row {
        anchors.fill: parent

        Repeater {
            id: repeater
            onCountChanged: {
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
