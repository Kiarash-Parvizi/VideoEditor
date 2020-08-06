import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import QtMultimedia 5.12
// TimeLine
Rectangle {
    width: parent.width
    height: 32
    //color: "#0C090A"
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 43

    function setPointerPosition(d) {
        timePointer.x = d*width
    }
    function reset() {
        timePointer.x = 0
    }

    //LINES
    Rectangle {
        width: parent.width
        height: 1
        opacity: 0.2
        color: "black"
        y: parent.height/4
    }
    Rectangle {
        id: midLine
        width: parent.width
        height: 2
        opacity: 0.2
        color: "black"
        y: parent.height/2
    }
    Rectangle {
        width: parent.width
        height: 1
        opacity: 0.2
        color: "black"
        y: parent.height*3/4
    }

    // Pointer
    Rectangle {
        id:timePointer
        Rectangle {
            id: timePointer_circle
            anchors.centerIn: parent
            width: 6; height: 4
            color: "#1F45FD"
            radius: width/2
        }

        width: 4
        height: parent.height
        color: "#1F45FC"
    }


    MouseArea {
        anchors.fill: parent
        enabled: mediaSection.video.hasSource
        onMouseXChanged: {
            //print(mouseX)
            var diam = timePointer.width/2
            var newX = mouseX-diam
            if (newX < -diam) {
                newX = -diam
            }
            if (newX > parent.width-diam) {
                newX = parent.width-diam
            }
            timePointer.x = newX
            mediaSection.video.seek(mediaSection.video.duration*newX/width)
        }
    }
    Glow {
        anchors.fill: midLine
        radius: 8
        samples: 19
        color: "#3060D7"
        source: midLine
    }
    Glow {
        anchors.fill: timeTail
        radius: 10
        samples: 19
        color: "#5080A7"
        source: midLine
    }
    // Tail
    Rectangle {
        id: timeTail
        color: "#1a49c9";
        y: midLine.y
        height: 2; width: timePointer.x
    }

    // timePointer Effects
    Glow {
        anchors.fill: timePointer
        radius: 10
        samples: 19
        color: "#4090C7"
        source: timePointer
    }
}
