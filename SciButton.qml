import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

Button {
    width: 40; height: 40;
    x: 20; y: 20; z: 1
    background: Rectangle {
        opacity: 0
    }
    Image {
        id: openMenuId
        anchors.fill: parent
        source: "resources/open-menu.png"
    }
    Glow {
        anchors.fill: openMenuId
        radius: 8
        samples: 20
        color: "#5070D7"
        source: openMenuId
        opacity: 0.6
        z: 1
    }
    DropShadow {
        anchors.fill: openMenuId
        horizontalOffset: 3
        verticalOffset: 3
        radius: 8.0
        samples: 17
        color: "black"
        z: 1
        source: openMenuId
    }
}
