pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Dialogs
import QtQuick.Layouts
import QtCore
import MediaControls
import Config

Rectangle {
    id:root
    implicitWidth: 380

    color:Config.mainColor
    border.color: "lightgrey"
    radius: 10

    property int width_view: -1
    property int currIndex: -1
    property bool shuffled: false
    property alias mediaCount: files.count
    signal playlistUpdated()
    signal currentFileRemoved()

    function getSource(){
        if(mediaCount===0)
            return "";
        if(shuffled){
            let randindex = Math.floor(Math.random()*mediaCount)
            while(randindex == currIndex){
                randindex = Math.floor(Math.random()*mediaCount)
            }
            currIndex = randindex
        }
        return files.get(currIndex).path
    }

    function addFiles(count, selectedFiles)
    {
        selectedFiles.forEach(function(file){
            const url = new URL(file)
            files.insert(count,{
                          path:url,
                          isMovie:isMovie(url.toString())
                         })
        })
        palylistUpdated()
    }
    function addFile(index,selectedFile){
        if(index>mediaCount||index<0)
        {
            index = 0;
            currIndex = 0;
        }
        //上面添加文件用的url，这里就不用了？
        files.insert(index,{
                        path:selectedFile,
                        isMovie:isMovie(selectedFile.toString())
                     })
    }
    function isMovie(path)
    {
        const paths = path.split('.')
        const extension = paths[paths.length - 1]
        const musicFormats = ["mp3","wav","acc"]
        for(const fmat of musicFormats){
               if(fmat === extension)
                    return false
        }
        return true
    }

    MouseArea{
        anchors.fill: parent
        preventStealing: true
        onPositionChanged: {
            const f_wid = parent.width
            if(mouseX+f_wid>=f_wid-90&&mouseX+f_wid<=f_wid+90)
            if((f_wid>280||mouseX<0)&&(f_wid<width_view||mouseX>0))
                parent.width -= mouseX
        }
    }

    FileDialog{
        id:folderView
        title:qsTr("选择要播放的视频或音频")
        currentFolder: StandardPaths.standardLocations(StandardPaths.MoviesLocaton)[0]
        fileMode: FileDialog.OpenFiles
        onAccepted: {
            root.addFiles(files.count, folderView.selectedFiles)
            close()
        }
    }
    ListModel{
        id:files
        //{
        //
        //
        //}
    }
    Item{
        id:playlist
        anchors.fill: parent
        anchors.margins: 30
        RowLayout{
            id:header
            width: parent.width
            Label{
                font.bold: true
                font.pixelSize: 20
                text: qsTr("播放列表")
                color: Config.secondColor
                Layout.fillWidth: true
            }
            CustomButton{
                icon.source:Config.iconSource("Add_file")
                onClicked:folderView.open()
            }
        }



        ListView{
            id:listview
            model: files
            anchors.fill: parent
            anchors.topMargin: header.height+30
            spacing: 20
            delegate:RowLayout{
                id:row
                width: listview.width
                spacing: 15
                required property string path
                required property int index
                required property bool isMovie

                Image{
                    id:mediaIcon
                    states: [
                        State {
                            name: "activeMovie"
                            when: root.currIndex === row.index &&row.isMovie
                            PropertyChanges {
                                mediaIcon.source: Config.iconSource("Movie_Active",false);
                            }
                        },
                        State {
                            name: "inactiveMovie"
                            when: root.currIndex != row.index &&row.isMovie
                            PropertyChanges {
                                mediaIcon.source: Config.iconSource("Movie_Icon");
                            }
                        },
                        State {
                            name: "activeMusic"
                            when: root.currIndex === row.index &&!row.isMovie
                            PropertyChanges {
                                mediaIcon.source: Config.iconSource("Music_Active",false);
                            }
                        },
                        State {
                            name: "inactiveMusic"
                            when: root.currIndex != row.index &&!row.isMovie
                            PropertyChanges {
                                mediaIcon.source: Config.iconSource("Music_Icon");
                            }
                        }
                    ]
                }
                Label{
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    font.bold:root.currentIndex === row.index
                    color:root.currIndex === row.index?"#41CD52" : Config.secondColor
                    font.pixelSize: 18
                    text: {
                        const paths = row.path.split('/')
                        return paths[paths.length-1]
                    }
                }
                CustomButton{
                    icon.source:Config.iconSource("Trash_Icon")
                    onClicked:{
                        const removeindex = row.index;
                        files.remove(removeindex)
                        if(root.currIndex === removeindex)
                        {
                            root.currentFileRemoved()
                        }else if(root.currIndex>removeindex){
                            --root.currIndex;
                        }
                    }
                }
            }
            remove: Transition {
                NumberAnimation {
                    property: "opacity"
                    from: 1.0
                    to:0.0
                    duration: 400
                }
            }
            add:Transition {
                NumberAnimation {
                    property: "opacity"
                    from:0.0
                    to:1.0
                    duration: 400

                }
                NumberAnimation {
                    property: "scale"
                    from:0.5
                    to:1.0
                    duration: 400
                }
            }
            displaced: Transition{
                NumberAnimation {
                    property: "y"
                    duration: 200
                    easing.type: Easing.OutBounce
                }
            }
        }
    }
}
