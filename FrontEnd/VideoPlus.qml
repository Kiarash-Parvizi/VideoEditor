import QtQuick 2.12
import QtMultimedia 5.12

Item {
    property real vid_width : 0
    property real vid_height: 0
    property bool isPlaying: false
    //
    function set_play() {
        if (isPlaying) {
            video.vids[video.nid].pause()
            isPlaying = false
        } else {
            video.vids[video.nid].play()
            isPlaying = true
        }
    }

    function timeLineMode_changed() {
        if (!timeLineMode) {
            video.pause()
            video2.pause()
        }
    }
    Connections {
        target: TL_Player
        onPlayBuffer: {
            video.set_src(path, startPos, isRoot, extra_path, extra_startPos)
        }
    }

    // MultiVideo
    Video {
        id: video
        playbackRate: 1
        anchors.centerIn: parent
        width: vid_width; height: vid_height
        enabled: true
        visible: true
        property int nid: 1
        property int cid: 0
        function inc_ids() { nid = (nid + 1) % 2; cid = (cid + 1) % 2; }
        property var vids: [
            video, video2
        ]
        //
        property int startTime: 0
        function setup(src, _startTime) {
            startTime = _startTime
            source = src
        }
        function _play() {
            visible = true
            play()
            seek(startTime)
            video2.dis()
        }
        function dis() {
            //enabled = false
            visible = false
            pause()
        }

        function set_src(next, startTime, isRoot, extra, extra_startTime) {
            if (isRoot) {
                vids[cid].setup(next, startTime)
                vids[nid].setup(extra, extra_startTime)
            } else {
                vids[nid].setup(next, startTime)
            }
            vids[cid]._play()
            isPlaying = true
            inc_ids()
        }
    }
    Video {
        id: video2
        anchors.centerIn: parent
        playbackRate: 1
        width: vid_width; height: vid_height
        enabled: true
        visible: false
        property int startTime: 0
        function setup(src, _startTime) {
            startTime = _startTime
            source = src
        }
        function _play() {
            visible = true
            play()
            seek(startTime)
            video.dis()
        }
        function dis() {
            visible = false
            pause()
        }
    }
}
