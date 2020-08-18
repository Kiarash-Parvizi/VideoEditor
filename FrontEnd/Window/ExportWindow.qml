import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.0
import QtQuick.Window 2.12

Window {
    id: exportWindow
    title: "Export"
    minimumWidth: window.minimumWidth*0.4; minimumHeight: window.minimumHeight*0.4
    maximumWidth: window.maximumWidth*0.41; maximumHeight: window.maximumHeight*0.42
    Rectangle {
        anchors.fill: parent
        color: "#101010"
    }
    Item {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 18
        Column {
            anchors.fill: parent
            spacing: 14
            Row {
                width: parent.width
                spacing: 8
                function set_output_path(path) {
                    pathField.text = path
                }
                TextField {
                    id: pathField
                    width: parent.width - height - parent.spacing
                    text: ""
                    font.pointSize: 7
                    horizontalAlignment: TextInput.AlignHCenter
                    placeholderText: "output path"
                }
                Button {
                    text: "..."
                    height: parent.children[0].height; width: height
                    onClicked: {
                        folderDialog.getFolder(parent.set_output_path)
                    }
                }
            }
            TextField {
                id: nameField
                width: parent.width
                text: "output"
                horizontalAlignment: TextInput.AlignHCenter
                placeholderText: "output name"
            }
            Button {
                onClicked: {
                    if (nameField.text.length == 0 || pathField.text.length == 0) {
                        return
                    }
                    VProcess.exportVideo(" -map [outv] -map [outa] -vcodec libx265 \"" + nameField.text + "\"")
                }
            }
        }
    }
}
