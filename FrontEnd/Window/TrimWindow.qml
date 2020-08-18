import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import QtQuick.Window 2.12

Window {
    id: trimWindow
    title: "Trim"
    minimumWidth: window.minimumWidth*0.4; minimumHeight: window.minimumHeight*0.4
    maximumWidth: window.maximumWidth*0.41; maximumHeight: window.maximumHeight*0.42
    Rectangle {
        anchors.fill: parent
        color: "#101010"
    }
    Frame {
        //anchors.centerIn: parent
        padding: 30
        anchors.fill: parent
        anchors.leftMargin: 30; anchors.rightMargin : 30
        anchors.topMargin : 30; anchors.bottomMargin: 30
        ColumnLayout {
            spacing: 20
            ComboBox {
                id: trimCombo
                currentIndex: 0
                model: ListModel {
                    ListElement { text: "Videos" }
                    ListElement { text: "Additional Audios" }
                }
                onCurrentIndexChanged: {
                    soundEffects.play_done()
                }
                Component.onCompleted: {
                    Layout.preferredWidth = width + 12
                }
            }
            Row {
                spacing: 2
                TextField {
                    id: trim_textField_minLen
                    width: 200; height: 40
                    placeholderText: "minimum length (in ms)"
                    validator: IntValidator {bottom: 1; top: mediaSection.video.duration}
                }
                Button {
                    property alias minLen: trim_textField_minLen.text
                    width: 70; height: 40
                    text: "Trim"
                    onClicked: {
                        if (minLen.length > 0) {
                            if (trimCombo.currentIndex == 0) {
                                CppTimeLine.trim(parseInt(minLen))
                                timeLine.reset()
                            } else {
                                CppTimeLine.trim_aaudio(parseInt(minLen))
                            }
                            soundEffects.play_done()
                        }
                    }
                }
            }
        }
    }
}
