/**
 * simple audio player
 *
 * copyright (c) 2016 Stepanov Mihail
 */

import QtQuick 2.5
import QtQuick.Controls 1.4
import QtMultimedia 5.6
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.2
import QtQuick.Controls.Styles 1.4

ApplicationWindow {
    id: window
    visible: true
    width: 1080
    height: 600
    title: qsTr("Audio player")

    property int mrg: 10

    menuBar: MenuBar {
        Menu {
            title: qsTr("File")
            MenuItem {
                text: qsTr("Clear playlist")
                enabled: player.hasAudio
                onTriggered: playlist.clear()
            }

            MenuItem {
                text: qsTr("Exit")
                onTriggered: Qt.quit();
            }
        }
    }

    MediaPlayer{
        id: player
        volume: panel.vol
        autoPlay: true
        playlist: Playlist{
            id:playlist
            playbackMode: "Loop"
        }
        onPlaying: {
            panel.meta_visible = true
        }
    }


    GridLayout{
        id: ui
        anchors.fill:parent
        anchors.margins: mrg
        columnSpacing:  mrg
        rowSpacing: mrg
        columns: 3
        rows: 3

        MyPlaylist {
            id:queue
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.columnSpan: 2
            Layout.rowSpan: 2
            Layout.row:2
            Layout.column:2

            DropArea {
                id: dropTarget
                anchors.fill:parent
                anchors.margins:mrg
                keys: ["text/uri-list"]

                onDropped: {
                    if (drop.hasText) {
                        if (drop.proposedAction == Qt.MoveAction || drop.proposedAction == Qt.CopyAction) {
                            var paths = drop.urls
                            playlist.addItems(paths)
                        }
                    }
                    drop.accept()
                }
            }

        }
        ControlPanel{
            id:panel
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.columnSpan: 2
            Layout.rowSpan: 1
            Layout.row:1
            Layout.column:2
        }
        MyMusicCatalog{
            id:catalog
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.columnSpan: 1
            Layout.rowSpan: 3
            Layout.row: 1
            Layout.column:1
        }
    }
}
