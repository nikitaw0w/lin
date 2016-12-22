/**
 * MyPlaylist.qml
 *
 * copyright (c) 2016 Stepanov Mihail
 */

import QtQuick 2.0
import QtQuick.Controls 1.4
import QtMultimedia 5.6
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4

Rectangle {
    color:"black"
    radius: 4

    property int chosen_index
    property int cur_offset
    property int cur_index

    Component {
        id: nameDelegate
        Text {
            id: cur
            font.pixelSize: 16
            text: songname(source)
            color: "yellow"
            MouseArea{
                id: element
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onDoubleClicked: {
                    if(mouse.button == Qt.LeftButton){
                        playlist.currentIndex = index
                        player.play()
                    }
                }
                onClicked: {
                    if(mouse.button == Qt.RightButton) {
                        options.popup()
                        chosen_index = index
                    }
                }
            }
        }
    }

    Menu{
        id:options
        MenuItem {
            text: qsTr('Delete')
            onTriggered: {
                if (chosen_index < playlist.currentIndex){

                    cur_offset = player.position
                    cur_index = playlist.currentIndex - 1

                    playlist.removeItem(chosen_index)
                    playlist.currentIndex = cur_index
                    player.play()
                    player.seek(cur_offset)
                } else {
                    playlist.removeItem(chosen_index)
                }
            }
        }
    }

    //костыль
    function songname(fileurl){
        var filename  = fileurl.toString();
        filename = filename.substring(filename.lastIndexOf('/')+1, filename.lastIndexOf('.'));
        return filename
    }

    ScrollView{
        anchors.fill: parent
        anchors.margins: mrg
        clip: true
        style: ScrollViewStyle {
            handle: Rectangle {
                radius: 4
                implicitWidth: mrg
                color: "gray"
            }
            scrollBarBackground: Rectangle {
                radius: 4
                implicitWidth: mrg
                color: "black"
            }
            decrementControl: Rectangle {
                radius: 4
                implicitWidth: mrg
                implicitHeight: mrg
                color: "gray"
            }
            incrementControl: Rectangle {
                radius: 4
                implicitWidth: mrg
                implicitHeight: mrg
                color: "gray"
            }
        }

        ListView {
            id:list
            currentIndex: playlist.currentIndex
            model: playlist
            delegate: nameDelegate
            highlight: Rectangle {
                color: "gray"
                radius: 4
            }
        }
    }

    Item{
        focus:true
        Keys.onPressed: {
            if (event.isAutoRepeat) {
                return;
            }
            switch (event.key) {
            case Qt.Key_Delete:
                playlist.removeItem(playlist.currentIndex);
                break;
            }
        }
    }
}


