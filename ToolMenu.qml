import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.0

// ToolMenu
Rectangle {
    Layout.minimumWidth: window.width*0.3
    color: "#2C2C2C"

    property var mainMenu: mainMenu

    // blueRect Style
    Rectangle {
        id: glowLine_1
        color: "#3060D7"
        width: 1; height: parent.height
        anchors.right: parent.right
        opacity: 0.3
    }
    Glow {
        anchors.fill: glowLine_1
        radius: 8
        samples: 19
        color: "#3060D7"
        source: glowLine_1
        opacity: 0.3
    }

    // Switcher
    Button {
        id: switcher
        focusPolicy: Qt.NoFocus
        text: timeLine.visible ? "VIDEOSLIDER" : "TIMELINE"
        font: eliantoFontLoader.name
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top; anchors.topMargin: parent.height*0.02
        width: parent.width*0.4; height: parent.height*0.05
        z: 1
        onClicked: {
            timeLine.setMode()
        }
    }
    DropShadow {
        anchors.fill: switcher
        horizontalOffset: 3
        verticalOffset: 3
        radius: 8.0
        samples: 17
        color: "black"
        source: switcher
    }

    // Right Menu
    Item {
        //id: rightMenu
        height: parent.height; width: parent.width
        anchors.top: parent.top; anchors.topMargin: parent.height*0.09
        anchors.horizontalCenter: parent.horizontalCenter
        //bg
        Rectangle {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width*0.96; height: parent.parent.height*0.9
            color: "#252525"
        }
        //flickable-view
        Flickable {
            anchors.fill: parent
            anchors.leftMargin: parent.width*0.02
            anchors.rightMargin: parent.width*0.02
            contentHeight: mainMenu.height * 0.9
            contentWidth: parent.width
            flickableDirection: Flickable.VerticalFlick
            clip: true

            // Tools & Components
            ColumnLayout {
                id: mainMenu
                spacing: 10
                width: parent.width

                property var childs: Array.from(children)
                function reset_all() {
                    childs.forEach(function(child) {
                        child.reset()
                    })
                }

                IntervalCutter {
                    Layout.topMargin: 16
                    Layout.leftMargin: 22
                }

                Rectangle {
                    color: "red"
                    width: 10
                    height: 10
                    function reset() {}
                }
            }
        }

        BoxShadows {
        }
    }
}
