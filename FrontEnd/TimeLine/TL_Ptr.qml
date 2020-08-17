import QtQuick 2.12
import QtGraphicalEffects 1.0

// pointer + trace container
Item {
    property var trace: trace
    property var pointer : pointer
    property var pointer2: pointer2
    property int startX: 0
    anchors.fill: parent
    function reset() {
        pointer.x = pointer2.x = 0
        trace.x = 0; trace.width = 0
        set_toolProps()
    }

    function set_toolProps() {
        toolMenu.intervalCutter.set(pointer.x/window.width * CppTimeLine.totalVidLen, pointer2.x/window.width * CppTimeLine.totalVidLen)
    }

    function inc_ptrs(mul) {
        let amount = mul * window.width/400
        let v1 = pointer.x  + amount
        let v2 = pointer2.x + amount
        if (v1 < 0 || v1 > window.width || v2 < 0 || v2 > window.width) return
        pointer.x  = v1
        pointer2.x = v2
        trace.x += amount
        //
        set_toolProps()
    }
    function set_ptr1(mouseX) {
        startX = mouseX
        pointer.x = mouseX
    }
    function set_ptr2(mouseX) {
        var coord_x = mouseX
        pointer2.x = mouseX
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
        //
        set_toolProps()
    }
    // Pointer
    Rectangle {
        id: pointer
        width: 1; height: parent.height/2; color: "#3060C0"; z: 2
    }
    // Pointer2
    Rectangle {
        id: pointer2
        width: 1; height: parent.height/2; color: "#3060C0"; z: 2
    }
    // Trace
    Rectangle {
        id: trace
        width: 2; height: parent.height/2; color: "#3060C0"; z: 2
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
