import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
// MouseBox_Data
Item {
    height: children[0].height
    function reset() {
        p1_x_text.text = ""; p1_y_text.text = ""
        p2_x_text.text = ""; p2_y_text.text = ""
    }
    function set(P1, P2) {
        if (v1 < v2) {
            if (v1 < 0 || v2 > CppTimeLine.totalVidLen) return
            textField_from.text = parseInt(v1); textField_to.text = parseInt(v2)
        } else {
            if (v2 < 0 || v1 > CppTimeLine.totalVidLen) return
            textField_from.text = parseInt(v2); textField_to.text = parseInt(v1)
        }
    }

    Rectangle {
        anchors.fill: parent.children[1]
        color: "#1C1C1C"
    }
    Frame {

    RowLayout {
        spacing: 16
        property bool isEnabled: mediaSection.timeLineMode
        //
        Image {
            id: point1
            source: "qrc:/resources/brackets-bg.png"
            enabled: parent.isEnabled
            Column {
                anchors.topMargin: parent.height * 0.125
                anchors.fill: parent
                spacing: parent.height / 16
                TextField{
                    id: p1_x_text
                    anchors.horizontalCenter: parent.horizontalCenter
                    placeholderText: "p1.x"
                    width: parent.width * 0.6
                    height: parent.height * 0.38
                    validator: IntValidator {bottom: 1; top: 10000}
                }
                TextField{
                    id: p1_y_text
                    anchors.horizontalCenter: parent.horizontalCenter
                    placeholderText: "p1.y"
                    width: parent.width * 0.6
                    height: parent.height * 0.38
                    validator: IntValidator {bottom: 1; top: 9999}
                }
            }
        }
        Image {
            id: point2
            source: "qrc:/resources/brackets-bg.png"
            enabled: parent.isEnabled
            Column {
                anchors.topMargin: parent.height * 0.125
                anchors.fill: parent
                spacing: parent.height / 16
                TextField{
                    id: p2_x_text
                    anchors.horizontalCenter: parent.horizontalCenter
                    placeholderText: "p2.x"
                    width: parent.width * 0.6
                    height: parent.height * 0.38
                    validator: IntValidator {bottom: 1; top: 10000}
                }
                TextField{
                    id: p2_y_text
                    anchors.horizontalCenter: parent.horizontalCenter
                    placeholderText: "p2.y"
                    width: parent.width * 0.6
                    height: parent.height * 0.38
                    validator: IntValidator {bottom: 1; top: 10000}
                }
            }
        }
        Button {
            focusPolicy: Qt.NoFocus
            Layout.preferredHeight: 25
            Layout.preferredWidth: 25
            ToolTip.visible: hovered
            ToolTip.text: "Box-SelectTool"
            //enabled: parent.isEnabled
            enabled: false
            Image {
                source: "qrc:/resources/select.png"
                y: parent.width*0.15
                x: y
                width: parent.width*0.7
                height: parent.height*0.7
            }
            onClicked: {
                soundEffects.play_done()
            }
        }
        Button {
            focusPolicy: Qt.NoFocus
            Layout.preferredHeight: 25
            Layout.preferredWidth: 25
            ToolTip.visible: hovered
            ToolTip.text: "Blur"
            enabled: parent.isEnabled
            Image {
                source: "qrc:/resources/drop.png"
                y: parent.width*0.15
                x: y
                width: parent.width*0.7
                height: parent.height*0.7
            }
            onClicked: {
                soundEffects.play_done()
            }
        }
    }
    }
}
