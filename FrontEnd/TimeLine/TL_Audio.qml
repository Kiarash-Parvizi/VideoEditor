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
        property bool drag: false
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: {
            if (el === null) return
            if (mouse.button === Qt.RightButton) {
                el.onRightClick()
            }
        }
        //
        onPressed: {
            el = repeater.get_element(mouseX)
            if (el === null) return
            //
            if (mouse.button === Qt.RightButton) {
                drag = false
            } else {
                startPosRatio = el.sPosRatio
                el.underMouse = true
                startMouseX = mouseX
                //
                drag = true;
            }
        }
        onMouseXChanged: {
            if (!drag || el === null) return
            let dif = mouseX - startMouseX
            let v = startPosRatio + (dif)/window.width
            CppTimeLine.set_aaudio_sPosRatio(el.idx, v)
        }
        onReleased: {
            if (!drag || el === null) return
            //
            let posOk = repeater.canHavePos(el)
            if (!posOk) {
                CppTimeLine.set_aaudio_sPosRatio(el.idx, startPosRatio)
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
            if (x1 < 0) {
                CppTimeLine.set_aaudio_sPosRatio(element.idx, 0)
            } else if (x1_p > window.width) {
                let v = 1 - element.width/window.width
                CppTimeLine.set_aaudio_sPosRatio(element.idx, v)
            }
            x1 = element.x; x1_p = element.x+element.width

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
        model: CppTimeLine.aModel

        delegate: Rectangle {
            color: "#303030"
            property int idx: model.index
            property real sPosRatio: model.sPosRatio
            property string mediaName: util.getMediaName(model._source, false)
            property bool underMouse: false
            //
            function onRightClick() {
                contextMenu.open()
            }
            //
            x: sPosRatio * window.width
            height: parent.height;
            width: {
                if (CppTimeLine.totalVidLen > 0) {
                    visible = true
                    let ratio = model.len/CppTimeLine.totalVidLen
                    if (ratio > 1) {
                        visible = false
                        return 0;
                    }
                    return ratio * window.width
                }
                visible = false
                return 0;
            }
            TextField {
                readOnly: true
                enabled: false
                anchors.centerIn: parent
                width: parent.width-10
                text: mediaName
                ToolTip.visible: underMouse
                ToolTip.text: text
            }
            Menu {
                id: contextMenu
                onOpened: {
                    soundEffects.play_done()
                }
                MenuItem {
                    text: "Remove"
                    onClicked: {
                        soundEffects.play_done()
                        CppTimeLine.rem_aaudioBuf(idx)
                    }
                }
                z: 20
            }
        }
    }

}
