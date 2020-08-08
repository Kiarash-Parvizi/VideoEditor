import QtQuick 2.12

Item {
    // VideoBuffer
    TL_Video {
        anchors.top: parent.top;
        width: parent.width; height: parent.height/2
    }

    // AudioBuffer
    TL_Audio {
        anchors.bottom: parent.bottom;
        width: parent.width; height: parent.height/2
    }

}
