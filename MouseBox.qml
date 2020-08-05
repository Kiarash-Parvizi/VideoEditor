import QtQuick 2.12

// boxPoser
Item {
    id: boxPoser

    //Getters
    function getBox() {
        return [redRect.x, redRect.y, redRect.width, redRect.height]
    }

    Rectangle {
        id: redRect
        x: 100; y: 100
        width: 0; height: 0
        color: "red"
        opacity: 0.2
    }
    property int startX: 0
    property int startY: 0

    MouseArea {
        anchors.fill: parent
        onPressed: {
            boxPoser.startX = mouseX
            boxPoser.startY = mouseY
            redRect.x = mouseX
            redRect.y = mouseY
            redRect.width = 0
            redRect.height = 0
        }

        onMouseXChanged: {
            print("X: " + mouseX)
            var d = mouseX - boxPoser.startX
            if (d === 0) {
                return
            } if (d > 0) {
                redRect.width = d
            } else {
                redRect.x = mouseX;
                redRect.width = -d
            }
        }
        onMouseYChanged: {
            print("Y: " + mouseY)
            var h = mouseY - boxPoser.startY
            if (h === 0) {
                return
            } if (h > 0) {
                redRect.height = h
            } else {
                redRect.y = mouseY;
                redRect.height = -h
            }
        }

        onContainsMouseChanged: {
        }
    }
}
