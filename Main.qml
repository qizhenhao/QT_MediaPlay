import QtQuick
import QtQuick.Window
import QtQuick.Controls.Fusion
import QtMultimedia
import QtQuick.Effects
import MediaControls
import Config

Window {
    id:root
    width: 1200
    height: 780
    minimumHeight: 460
    minimumWidth: 640
    title: qsTr("视频播放器")
    color: Config.mainColor
    visible: true

    property alias currentFile: playlistInfo.currIndex
    property alias playlistLooped: playbackControl.isPlaylistLooped
    // property alias metadataInfo: settingsInfo.metadataInfo
    // property alias tracksInfo: settingsInfo.tracksInfo

    function playMedia(){
        mediaPlayer.source = playlistInfo.getSource()
        mediaPlayer.play()
    }

    function closeOverlayAll(){
        root.closeOverlay(settingsInfo)
        root.closeOverlay(playlistInfo)
    }
    function closeOverlay(overlayss){
        overlayss.visible = false
    }
    function showOverlay(overlayss){
        console.log(overlayss.id)
        overlayss.visible = true
    }

    MouseArea{
        id:mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onPositionChanged: {
           if(!seeker.opacity)
           {
               if(videoOutput.fullScreen){
                   showControls.start()
               }
               else{
                   seeker.showSeeker.start()
               }
           } else {
               timer.restart()
           }
        }
        onClicked: root.closeOverlayAll();
    }


    Timer{
        id:timer
        interval:3000
        onTriggered: {
            if(!seeker.isMediaSliderPressed){
                if(videoOutput.fullScreen){
                    hideControls.start()
                }else{
                    seeker.hideSeeker.start()
                }
            }else{
                timer.restart()
            }
        }
    }
    ErrorPopup{
        id:errorPopup
    }
    Label {
        text: qsTr("点击 <font color=\"#41CD52\">这里</font> 选择要播放的文件.")
        font.pixelSize: 24
        color: Config.secondColor
        anchors.centerIn: parent
        visible: !errorPopup.visible && !videoOutput.visible// && !defaultCoverArt.visible

        TapHandler {
            onTapped: menuBar.openFileMenu.open()
        }
    }
    PlayerMenuBar{
        id: menuBar

        anchors.left: parent.left
        anchors.right: parent.right

        visible: !videoOutput.fullScreen

        onFileOpened: (path) => {
            console.log(path)
            ++root.currentFile
            playlistInfo.addFile(root.currentFile, path)
            mediaPlayer.source = path
            mediaPlayer.play()
        }

    }

    MediaPlayer{
        id:mediaPlayer
        playbackRate: playbackControl.playbackRate
        videoOutput: videoOutput
        audioOutput: AudioOutput{
            id:audio
            volume: playbackControl.volume
        }
        source: new URL("")
        function updateMetadata() {
            root.metadataInfo.clear()
            root.metadataInfo.read(mediaPlayer.metaData)
        }
        onMetaDataChanged: updateMetadata()
        onActiveTracksChanged: updateMetadata()
        onTracksChanged: {
            settingsInfo.tracksInfo.selectedAudioTrack = mediaPlayer.activeAudioTrack
            settingsInfo.tracksInfo.selectedVideoTrack = mediaPlayer.activeVideoTrack
            settingsInfo.tracksInfo.selectedSubtitleTrack = mediaPlayer.activeSubtitleTrack
            updateMetadata()
        }
        onErrorOccurred: {
            errorPopup.errorMsg = mediaPlayer.errorString
            errorPopup.open()
        }
        onMediaStatusChanged: {//*****
            if ((MediaPlayer.EndOfMedia === mediaStatus && mediaPlayer.loops !== MediaPlayer.Infinite) &&
                    ((root.currentFile < playlistInfo.mediaCount - 1) || playlistInfo.isShuffled)) {
                if (!playlistInfo.isShuffled) {
                    ++root.currentFile
                }
                root.playMedia()
            } else if (MediaPlayer.EndOfMedia === mediaStatus && root.playlistLooped && playlistInfo.mediaCount) {
                root.currentFile = 0
                root.playMedia()
            }
        }
    }
    VideoOutput {
        id:videoOutput
        anchors.top: fullScreen || Config.isMobileTarght ? parent.top : menuBar.bottom
        anchors.bottom: fullScreen?parent.bottom:playbackControl.top
        anchors.left: parent.left
        anchors.right:parent.right
        anchors.leftMargin: fullScreen ? 0:20
        anchors.rightMargin: fullScreen ? 0:20
        visible: mediaPlayer.hasVideo//需要改
        property bool fullScreen: false
        TapHandler{
            onDoubleTapped: {
                if(parent.fullScreen)
                {
                    root.showNormal()
                }
                else
                {
                    root.showFullScreen()
                }
                parent.fullScreen = !parent.fullScreen
            }
            onTapped:{
                root.closeOverlayAll()
            }
        }

    }
    Image {
        id: defaultCoverArt
        anchors.horizontalCenter: videoOutput.horizontalCenter
        anchors.verticalCenter: videoOutput.verticalCenter
        visible: !videoOutput.visible && mediaPlayer.hasAudio
        source: Config.iconSource("Default_CoverArt", false)
    }
    Rectangle{
        id:background
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: seeker.opacity ? seeker.top : playbackControl.top
        color: Config.mainColor
        opacity: videoOutput.fullScreen?0.75:0.5
    }

    Image {
        id: shadow
        source: `qrc:/qt/qml/MediaControls/icons/Shadow.png`
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
    PlaybackSeekControl{
        id:seeker
        anchors.left:videoOutput.left
        anchors.right:videoOutput.right
        anchors.bottom:playbackControl.top
        mediaPlayer:mediaPlayer
        fullScreenButton.onClicked:{
            if(mediaPlayer.hasVideo){
                videoOutput.fullScreen?root.showNormal():root.showFullScreen()
                videoOutput.fullScreen = !videoOutput.fullScreen
            }
        }
        settingsButton.onClicked:!settingsInfo.visible ? root.showOverlay(settingsInfo) : root.closeOverlay(settingsInfo)
    }
    PlaybackControl{
        id:playbackControl
        anchors.bottom:parent.bottom
        anchors.left:parent.left
        anchors.right:parent.right
        mediaPlayer:mediaPlayer
        isPlaylistVisible: playlistInfo.visible

        onPlayNextFile:{
            if(playlistInfo.mediaCount){
                if(!playlistInfo.shuffled){
                    ++root.currentFile
                    if(root.currentFile>=playlistInfo.mediaCount){
                        if(root.playlistLooped){
                            root.currentFile=0;
                        }
                        else{
                            --root.currentFile;
                            return;
                        }
                    }
                }
                root.playMedia()
            }
        }

        onPlayPreviousFile:{
            if(playlistInfo.mediaCount){
                if(!playlistInfo.shuffled){
                    --root.currentFile
                    if(root.currentFile<0){
                        if(root.playlistLooped){
                            root.currentFile=playlistInfo.mediaCount-1;
                        }
                        else{
                            ++root.currentFile;
                            return;
                        }
                    }
                }
                root.playMedia()
            }
        }

        playlistButton.onClicked: playlistInfo.visible =!playlistInfo.visible// ? root.showOverlay(playlistInfo) : root.closeOverlay(playlistInfo)
    }

    MultiEffect {
        source: settingsInfo
        anchors.fill: settingsInfo
        shadowEnabled: settingsInfo.visible
        visible: settingsInfo.visible
    }
    MultiEffect {
        source: playlistInfo
        anchors.fill: playlistInfo
        shadowEnabled: playlistInfo.visible
        visible:playlistInfo.visible
    }
    PlaylistInfo{
        id:playlistInfo
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: seeker.top //根据控制栏进行修改
        height: 500

        anchors.topMargin: 10
        anchors.rightMargin: 5

        visible: false
        shuffled:playbackControl.isPlaylistShuffle//通过控制栏进行修改
        width_view:parent.width-30
        onPlaylistUpdated:{
            if (mediaPlayer.playbackState == MediaPlayer.StoppedState && root.currentFile < playlistInfo.mediaCount - 1) {
                ++root.currentFile
                root.playMedia()
            }
        }

        onCurrentFileRemoved:{
            mediaPlayer.stop()

            if (root.currentFile <= playlistInfo.mediaCount ) {
                root.playMedia()
            } else if (playlistInfo.mediaCount) {
                --root.currentFile
                root.playMedia()
            }
            else
               root.currentFile=0;
        }
    }

    SettingsInfo {
        id: settingsInfo

        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: seeker.opacity ? seeker.top : playbackControl.top
        anchors.topMargin: 10
        anchors.rightMargin: 5
        mediaPlayer: mediaPlayer
        selectedAudioTrack: mediaPlayer.activeAudioTrack
        selectedVideoTrack: mediaPlayer.activeVideoTrack
        selectedSubtitleTrack: mediaPlayer.activeSubtitleTrack
        visible: false
    }

    ParallelAnimation {
        id: showControls

        NumberAnimation {
            targets: [playbackControl, seeker, shadow]
            property: "opacity"
            to: 1
            duration: 1000
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: background
            property: "opacity"
            to: 0.5
            duration: 1000
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: playbackControl
            property: "anchors.bottomMargin"
            to: 0
            duration: 1000
            easing.type: Easing.InOutQuad
        }
    }
    ParallelAnimation {
        id: hideControls

        NumberAnimation {
            targets: [playbackControl, seeker, background, shadow]
            property: "opacity"
            to: 0
            duration: 1000
            easing.type: Easing.InOutQuad
        }
        NumberAnimation {
            target: playbackControl
            property: "anchors.bottomMargin"
            to: -playbackControl.height - seeker.height
            duration: 1000
            easing.type: Easing.InOutQuad
        }
    }
}
