import QtQuick 2.12
import QtMultimedia 5.12

Item {
    property var medScale: {
        //let reso = vids[nid].metaData.resolution
        ////print(vids[nid].metaData.)
        //if (typeof resolution === 'undefined') {
        //    print("undef")
        //    print("reso: " + reso.width)
        //    return [0, 0]
        //}
        //let w = reso.width, h = reso.height
        //let vid_ratio = w/h, con_ratio = width/h
        //if (vid_ratio > con_ratio) {
        //    let r = width / w
        //    return [width, h*r]
        //} else {
        //    let r = height / h
        //    return [w*r, height]
        //}
        return [0, 0]
    }
    property real vid_width : 0
    property real vid_height: 0
    property bool isPlaying: false
    property bool isLoading: vids[cid].status === MediaPlayer.Loading //isPlaying && vids[cid].status !== MediaPlayer.Loaded
    property bool showLogo: true
    onIsLoadingChanged: {
        print("isLoading: " + isLoading)
    }
    //
    function calc_medScale() {
    }
    //
    property int nid: 1
    property int cid: 0
    function inc_ids() { nid = (nid + 1) % 2; cid = (cid + 1) % 2; }
    property var vids: [
        video, video2
    ]
    //
    function set_play() {
        if (isPlaying) {
            vids[nid].pause()
            isPlaying = false
        } else {
            vids[nid].play()
            isPlaying = true
        }
    }
    function set_pause() {
        if (isPlaying) {
            vids[nid].pause()
            isPlaying = false
        }
    }

    function set_dis() {
        TL_Player.change_process()
        vids[cid].dis()
        vids[nid].dis()
        showLogo = true
    }
    //
    function set_playbackRate(v) {
        video.playbackRate = v
        video2.playbackRate= v
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
            print("QNext: " + next)
            if (next == "Err") {
                print("Tail")
                vids[nid].dis()
                showLogo = true
                return
            }

            if (isRoot) {
                vids[cid].setup(next, startTime)
                vids[nid].setup(extra, extra_startTime)
            } else {
                vids[nid].setup(next, startTime)
            }
            vids[cid]._play()
            showLogo = false
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

    // MouseArea
    MouseArea {
        anchors.fill: video
        onClicked: {
            //set_dis()
            set_pause()
            TL_Player.change_process()
        }
    }
}
