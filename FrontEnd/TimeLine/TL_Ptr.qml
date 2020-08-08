import QtQuick 2.12
import QtGraphicalEffects 1.0

// pointer + trace container
Item {
    property var trace: trace
    property var pointer : pointer
    property var pointer2: pointer2
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
