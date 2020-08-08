import QtQuick 2.12
import QtQuick.Controls 2.12

import "../RC"

Component {
    id: del
    Rectangle {
        border.width: 1; border.color: "black"
        width: CppTimeLine.calc_width(model.len, window.width); height: parent.height
        color: "#303030"
        function reCalc() {
            width = CppTimeLine.calc_width(model.len, window.width)
        }

        Label {
            anchors.left: parent.left; anchors.top: parent.top;
            width: parent.width - 11; height: parent.height/2
            wrapMode: Text.NoWrap
            anchors.leftMargin: 10; anchors.topMargin: 5

            background: Rectangle {
                anchors.fill: parent
                anchors.leftMargin: -5; anchors.topMargin: -2
                color: "#3a3a3a"
            }

            text: util.getMediaName(model._source)
            color: "#101010"
        }
        MouseArea {
            propagateComposedEvents: true
            acceptedButtons: Qt.RightButton
            anchors.fill: parent
            onClicked: {
                if (mouse.button === Qt.RightButton) {
                    contextMenu.open()
                    contextMenu.x = mouseX
                }
            }
        }
        Menu {
            id: contextMenu
            onOpened: {
                soundEffects.play_done()
            }
            MenuItem {
                text: "Remove Video"
                onClicked: {
                    soundEffects.play_done()
                    CppTimeLine.del_VBuf(model.index)
                }
            }
            MenuItem {
                text: "Remove Video+Audio"
                onClicked: {
                    soundEffects.play_done()
                    CppTimeLine.del_VBuf(model.index)
                }
            }
            z: 20
        }
    }
}
