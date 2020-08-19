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
        MouseArea {
            anchors.fill: parent
        }
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
                    readOnly: true
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
                text: "output.mp4"
                horizontalAlignment: TextInput.AlignHCenter
                placeholderText: "output name"
            }
            Row {
                spacing: 4
                CheckBox {
                    id: compressionCheckBox
                }
                Label {
                    enabled: compressionCheckBox.checked
                    anchors.verticalCenter: parent.verticalCenter
                    color: "white"
                    text: "Compression:    "
                }
                TextField {
                    id: compressionAmount
                    enabled: compressionCheckBox.checked
                    anchors.verticalCenter: parent.verticalCenter
                    placeholderText: "amount"
                    text: "24"
                    validator: IntValidator {bottom: 1; top: 5000}
                }
            }
            Row {
                id: scaleRow
                anchors.left: parent.left
                anchors.leftMargin: 10
                spacing: 4
                function getScale() {
                    if (scale_t_1.text.length === 0 || scale_t_2.text.length === 0) {
                        return "854x480";
                    }
                    return scale_t_1.text + "x" + scale_t_2.text
                }

                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    color: "white"
                    text: "Resolution: "
                }
                TextField {
                    id: scale_t_1
                    implicitWidth: 50
                    horizontalAlignment: TextInput.AlignHCenter
                    validator: IntValidator {bottom: 1; top: 5000}
                    text: "854"
                }
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    color: "white"
                    text: "x"
                }
                TextField {
                    id: scale_t_2
                    implicitWidth: 50
                    horizontalAlignment: TextInput.AlignHCenter
                    text: "480"
                    validator: IntValidator {bottom: 1; top: 5000}
                }
            }
            Row {
                id: darRow
                anchors.left: parent.left
                anchors.leftMargin: 10
                spacing: 4
                function get_dar() {
                    return children[1].text
                }
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    color: "white"
                    text: "video dar: "
                }
                TextField {
                    implicitWidth: 50
                    horizontalAlignment: TextInput.AlignHCenter
                    text: "16/9"// "64/27"
                }
            }
        }
        Button {
            text: "Export"
            font: fontAssets.eliantoFontLoader.name
            anchors.bottom: parent.bottom; anchors.bottomMargin: 50
            anchors.horizontalCenter: parent.horizontalCenter
            onClicked: {
                if (nameField.text.length == 0 || pathField.text.length == 0) {
                    return
                }
                VProcess.set_scaleStr(scaleRow.getScale())
                VProcess.set_darStr(darRow.get_dar()) // 64/27
                let compressionC =
                    (compressionCheckBox.checked && compressionAmount.text.length !== 0)
                    ? " -crf " + parseInt(compressionAmount.text) + " "
                    : ""
                VProcess.exportVideo(" -map [outv] -map [outa] -threads 6 -preset ultrafast -strict -2 -vcodec libx265"
                                     + compressionC + " \"" + pathField.text + "/" + nameField.text + "\"")
            }
        }
    }
}
