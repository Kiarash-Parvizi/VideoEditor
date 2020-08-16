import QtQuick 2.0
import QtQuick.Controls 2.12

import "../RC"

Item {
    //BG
    Label {
        visible: repeater.count == 0
        anchors.centerIn: parent
        text: "NO ADDITIONAL AUDIO BUFFER"
        font: fontAssets.eliantoFontLoader.name
        color: "white"
    }

    ///
    MouseArea {
        anchors.fill: parent
        property var el: null
        property real startPosRatio: 0
        property real startMouseX: 0
        onPressed: {
            el = repeater.get_element(mouseX)
            if (el === null) return
            startPosRatio = el.posRatio
            el.underMouse = true
            startMouseX = mouseX
        }
        onMouseXChanged: {
            if (el === null) return
            let dif = mouseX - startMouseX
            el.posRatio = startPosRatio + (dif)/window.width
        }
        onReleased: {
            if (el === null) return
            //
            let posOk = repeater.canHavePos(el)
            if (!posOk) {
                el.posRatio = startPosRatio
            } else {
                soundEffects.play_done()
            }
            el.underMouse = false

            //
            el = null
        }
    }

    // Repeater
    Repeater {
        id: repeater
        anchors.fill: parent
        //
        function canHavePos(element) {
            let x1 = element.x, x1_p = element.x+element.width
            if (x1 < 0 || x1_p > window.width) return false
            //
            for (let i = 0; i < count; i++) {
                let el = itemAt(i)
                if (el === element) continue
                //
                let x2 = el.x, x2_p = el.x+el.width
                if (!( (x1_p < x2) || (x1 > x2_p) )) {
                    return false
                }
            }
            return true
        }
        function get_element(X) {
            for (let i = count-1; i >= 0; i--) {
                let el = itemAt(i)
                if (X >= el.x && X <= el.x+el.width) {
                    return el
                }
            }
            return null
        }

        ///
        model: ListModel {
            ListElement {
                posRatio: 0.1
                widRatio: 0.2
                source: "something good"
            }
            ListElement {
                posRatio: 0.1
                widRatio: 0.1
                source: "hey you mate"
            }
        }

        delegate: Rectangle {
            color: "#303030"
            property real posRatio: model.posRatio
            property string mediaName: util.getMediaName(model.source, false)
            property bool underMouse: false
            x: posRatio * window.width
            height: parent.height; width: model.widRatio * window.width
            TextField {
                readOnly: true
                enabled: false
                anchors.centerIn: parent
                width: parent.width-10
                text: mediaName
                ToolTip.visible: underMouse
                ToolTip.text: text
            }
        }
    }

}
