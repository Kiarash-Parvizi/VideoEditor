import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

// TimeLine
Item {
    id: timeLine
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
        onPressed: {
            startX = mouseX
            trace.x = mouseX
            trace.width = 0
            pointer.x = mouseX
        }
        onPressedChanged: {
            soundEffects.play_done_low()
        }
        onMouseXChanged: {
            var coord_x = mouseX
            pointer2.x = mouseX
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
    // pointer + trace container
    Item {
        anchors.fill: parent
        // Pointer
        Rectangle {
            id: pointer
            width: 1; height: parent.height; color: "#3060C0"; z: 2
        }
        // Pointer2
        Rectangle {
            id: pointer2
            width: 1; height: parent.height; color: "#3060C0"; z: 2
        }
        // Trace
        Rectangle {
            id: trace
            width: 2; height: parent.height; color: "#3060C0"; z: 2
            opacity: 0.1
        }
        DropShadow {
            anchors.fill: parent.children[0]; source: parent.children[0]
            horizontalOffset: 1; verticalOffset: 0; z: 2
            radius: 4; samples: 17; color: "black"
        }
        DropShadow {
            anchors.fill: parent.children[0]; source: parent.children[0]
            horizontalOffset: -1; verticalOffset: 0; z: 2
            radius: 4; samples: 17; color: "black"
        }
        DropShadow {
            anchors.fill: parent.children[1]; source: parent.children[0]
            horizontalOffset: 1; verticalOffset: 0; z: 2
            radius: 4; samples: 17; color: "black"
        }
        DropShadow {
            anchors.fill: parent.children[1]; source: parent.children[0]
            horizontalOffset: -1; verticalOffset: 0; z: 2
            radius: 4; samples: 17; color: "black"
        }
    }
}
