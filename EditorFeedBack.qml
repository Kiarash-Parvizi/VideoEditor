import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0

// VisualFeedback
Item {
    width: parent.width; height: 42
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 75

    property var redLine_indicator: redLine_indicator

    Rectangle {
        anchors.bottom: parent.bottom
        color: "white"
        width: window.width; height: 23
    }
    // some style
    Rectangle {
        id: glowLine_vr_1
        color: "#5080A7"
        width: window.width; height: 2
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 23
    }
    Glow {
        anchors.fill: glowLine_vr_1
        radius: 9
        samples: 20
        color: "#5080A7"
        source: glowLine_vr_1
    }
    Rectangle {
        color: "red"
    }

    Image {
        id: ruler
        property int init_width: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 2
        width: init_width; height: 12
        source: "resources/ruler.png"
        OpacityMask {
            source: ruler_mask
            maskSource: ruler
        }

        LinearGradient {
            id: ruler_mask
            anchors.fill: parent
            gradient: Gradient {
                GradientStop { position: 0.0; color: "white" }
                GradientStop { position: 0.5; color: "transparent"}
            }
        }
        Component.onCompleted: {
            init_width = window.width*1.05
        }
        Rectangle {
            color: "#3d3d40"
            anchors.bottom: parent.bottom
            width: parent.width
            height: 2
            y: parent.height
        }
        Rectangle {
            id: ruler_blueLine
            color: "#3060D7"
            opacity: 0.5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 3
            width: parent.width
            height: 2
            y: parent.height
        }
        Glow {
            anchors.fill: ruler_blueLine
            radius: 8
            opacity: 0.5
            samples: 20
            color: "#3060D7"
            source: ruler_blueLine
        }
        // Red Indicators
        Rectangle {
            id: redLine_indicator
            color: "red"
            opacity: 0.5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 3
            width: 2
            height: 4
            y: parent.height
            function set_x(x_r) {
                x = x_r * window.width
            }
            function set_w(w_r) {
                if (w_r === 0) {
                    width = 2; return
                }
                width = w_r * window.width - x + 2
            }
            function reset() {
                width = 2
            }
        }
    }
}
