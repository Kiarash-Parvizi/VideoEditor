import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

// TimeLine
Item {
    id: timeLine
    property alias tl_data: tl_data
    property alias tl_ptr : tl_ptr
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
        property alias trace: tl_ptr.trace
        onPressed: {
            trace.x = mouseX
            trace.width = 0
            tl_ptr.set_ptr1(mouseX)
        }
        onPressedChanged: {
            soundEffects.play_done_low()
        }
        onMouseXChanged: {
            timeLine.progressRatio = mouseX/width
            tl_ptr.set_ptr2(mouseX)
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
