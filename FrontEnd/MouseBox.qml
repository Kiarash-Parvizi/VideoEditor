import QtQuick 2.12

// boxPoser
Item {
    id: boxPoser
    //Rectangle {
    //    color: "red"
    //    anchors.fill: parent
    //    opacity: 0.3
    //}

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
            var coord_x = mouseX
            if (coord_x < 0) {
                coord_x = 0
            } else if (coord_x > width) {
                coord_x = width
            }
            //
            //print("X: " + coord_x)
            var d = coord_x - boxPoser.startX
            if (d === 0) {
                return
            } if (d > 0) {
                redRect.x = startX
                redRect.width = d
            } else {
                redRect.x = coord_x;
                redRect.width = -d
            }
        }
        onMouseYChanged: {
            var coord_y = mouseY
            if (coord_y < 0) {
                coord_y = 0
            } else if (coord_y > height) {
                coord_y = height
            }
            //
            //print("Y: " + coord_y)
            var h = coord_y - boxPoser.startY
            if (h === 0) {
                return
            } if (h > 0) {
                redRect.y = startY;
                redRect.height = h
            } else {
                redRect.y = coord_y;
                redRect.height = -h
            }
        }
        onReleased: {
            // set-tool-Props
        }

        onContainsMouseChanged: {
        }
    }
}
