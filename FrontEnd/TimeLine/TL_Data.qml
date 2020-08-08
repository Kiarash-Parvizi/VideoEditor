import QtQuick 2.12

Item {
    property alias tl_video: tl_video
    property alias tl_audio: tl_audio
    // VideoBuffer
    TL_Video {
        id: tl_video
        anchors.top: parent.top;
        width: parent.width; height: parent.height/2
    }

    // AudioBuffer
    TL_Audio {
        id: tl_audio
        anchors.bottom: parent.bottom;
        width: parent.width; height: parent.height/2
    }

}
