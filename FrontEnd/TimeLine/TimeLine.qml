import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

// TimeLine
Item {
    id: timeLine
    property alias tl_data: tl_data
    function setMode() {
        visible = !visible
        mediaSection.video.timeLineMode = visible
        soundEffects.play_space()
    }
    visible: false
    width: window.width; height: 98
    property real progressRatio: 0
    // bg
    Rectangle {
        color: "#101010"
        anchors.fill: parent
        //opacity: 0.4
    }
    // mouse
    MouseArea {
        anchors.fill: parent
        property int startX: 0
        property alias trace: tl_ptr.trace
        onPressed: {
            startX = mouseX
            trace.x = mouseX
            trace.width = 0
            tl_ptr.pointer.x = mouseX
        }
        onPressedChanged: {
            soundEffects.play_done_low()
        }
        onMouseXChanged: {
            var coord_x = mouseX
            tl_ptr.pointer2.x = mouseX
            timeLine.progressRatio = mouseX/width
            if (coord_x < 0) {
                coord_x = 0
            } else if (coord_x > width) {
                coord_x = width
            }
            //
            //print("X: " + coord_x)
            var d = coord_x - startX
            if (d === 0) {
                return
            } if (d > 0) {
                trace.x = startX
                trace.width = d
            } else {
                trace.x = coord_x;
                trace.width = -d
            }
        }
    }
    // Data
    TL_Data {
        id: tl_data
        anchors.fill: parent
    }

    // sepLine
    Item {
        anchors.fill: parent
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter; z: 1
            height: 2; width: parent.width; color: "#4474D7"
        }
        Glow {
            anchors.fill: parent.children[0]; color: "#010101"
            samples: 18; radius: 7; source: parent.children[0];
        }
    }
    TL_Ptr {
        id: tl_ptr
    }
}
