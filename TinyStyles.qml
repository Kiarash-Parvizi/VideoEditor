import QtQuick 2.12
import QtGraphicalEffects 1.0

Item {
    anchors.fill: parent
    // upper Shadow
    Rectangle {
        id: upperShadow
        anchors.top: parent.top
        width: parent.width; height: 2
        color: "#0B0B0B"
        z: 1
    }
    Glow {
        anchors.fill: upperShadow
        radius: 10
        samples: 20
        color: "#0B0B0B"
        source: upperShadow
        z: 1
    }

    // BackGround
    Rectangle {
        color: "#1E1E1E"
        visible: true
        anchors.fill: parent
        MouseArea {
            anchors.fill: parent
            onPressed: {
                mediaSection.video.focus = true
            }
        }
    }
}
