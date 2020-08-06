import QtQuick 2.12

// shadowLines
Item {
    anchors.horizontalCenter: parent.horizontalCenter
    width: parent.width*0.96; height: parent.parent.height*0.9
    Rectangle {
        anchors.left: parent.left;
        width: 8; height: parent.height
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 1.0; color: "transparent" }
            GradientStop { position: 0.0; color: "#101010" }
        }
    }
    Rectangle {
        anchors.right: parent.right;
        width: 8; height: parent.height
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 1.0; color: "#101010" }
        }
    }
    Rectangle {
        anchors.top: parent.top
        width: parent.width; height: 8
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 1.0; color: "transparent" }
            GradientStop { position: 0.0; color: "#101010" }
        }
    }
    Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width; height: 8
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0; color: "transparent" }
            GradientStop { position: 1.0; color: "#131313" }
        }
    }
}
