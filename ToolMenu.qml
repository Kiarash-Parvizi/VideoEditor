import QtQuick 2.12
import QtQuick.Layouts 1.12
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

    // Right Menu
    Flickable {
        id: rightMenu
        height: parent.height
        width: parent.width
        contentHeight: mainMenu.height
        contentWidth: parent.width

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
            }

            Rectangle {
                color: "red"
                width: 10
                height: 10
                function reset() {}
            }
        }
    }
}
