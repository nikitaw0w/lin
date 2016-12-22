/**
 * ControlPanel.qml
 *
 * copyright (c) 2016 Stepanov Mihail
 */

import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
import QtQml 2.2

Rectangle{
    id:panel
    color: "black"
    radius: 4
    Layout.maximumHeight: play_button.height + progress.implicitHeight + mdata.implicitHeight + 2*mrg
    Layout.minimumHeight: play_button.height + progress.implicitHeight + mdata.implicitHeight + 2*mrg
    Layout.minimumWidth: control.implicitWidth + 2*mrg

    property alias vol: volslider.value
    property alias meta_visible: mdata.visible

    ColumnLayout{
        anchors.fill:parent
        spacing: 0
        anchors.margins: mrg

        RowLayout{
            id: control
            spacing: 0
            Layout.alignment: "AlignCenter"

            Image {
                id: play_button
                Layout.alignment: "AlignCenter"
                source: "img/play.png"
                MouseArea{
                    anchors.fill:parent
                    onPressed: {
                        player.play()
                        play_button.scale = 0.9
                    }
                    onReleased: {
                        play_button.scale = 1.0
                    }
                }
            }

            Image {
                id: pause_button
                Layout.alignment: "AlignCenter"
                source: "img/pause.png"
                MouseArea{
                    anchors.fill:parent
                    onPressed: {
                        player.pause()
                        pause_button.scale = 0.9
                    }
                    onReleased: {
                        pause_button.scale = 1.0
                    }
                }
            }
            Image {
                id: stop_button
                Layout.alignment: "AlignCenter"
                source: "img/stop.png"
                MouseArea{
                    anchors.fill:parent
                    onPressed: {
                        player.stop()
                        stop_button.scale = 0.9
                    }
                    onReleased: {
                        stop_button.scale = 1.0
                    }
                }
            }

            Image {
                id: prev_button
                Layout.alignment: "AlignCenter"
                source: "img/prev.png"
                MouseArea{
                    anchors.fill:parent
                    onPressed: {
                        playlist.previous()
                        prev_button.scale = 0.9
                    }
                    onReleased: {
                        prev_button.scale = 1.0

                    }
                }
            }
            Image {
                id: next_button
                Layout.alignment: "AlignCenter"
                source: "img/next.png"
                MouseArea{
                    anchors.fill:parent
                    onPressed: {
                        playlist.next()
                        next_button.scale = 0.9
                    }
                    onReleased: {
                        next_button.scale = 1.0
                    }
                }
            }
            Slider{
                id: volslider
                Layout.alignment: "AlignCenter"
                Layout.fillHeight: true
                value: 0.75
                orientation: Qt.Vertical
                maximumValue: 1
                minimumValue: 0
            }
        }
        RowLayout{
            id: progress
            Text{
                id: passed
                text: new Date(progress_slider.value).toLocaleTimeString(Qt.locale(),"mm:ss")
                color:"yellow"
            }
            Slider{
                id:progress_slider
                Layout.fillWidth: true
                value:player.position
                maximumValue: player.duration
                minimumValue:0
                onValueChanged: player.seek(value)
            }
            Text{
                id: left
                text: new Date(player.duration - progress_slider.value).toLocaleTimeString(Qt.locale(),"mm:ss")
                color:"yellow"
            }
        }

        RowLayout{
            id: mdata
            visible: false
            spacing: 2*mrg
            clip: true
            anchors.horizontalCenter: parent.horizontalCenter
            Text{
                id: art
                text: "Artist: " + ((player.metaData.contributingArtist) ? (player.metaData.contributingArtist) : "unknown")
                clip: true
                color:"yellow"
                Layout.alignment: "AlignCenter"
                Layout.maximumWidth: panel.width/count(parent.children)
            }

            Text{
                id: title
                text: "Title: " + ((player.metaData.title) ? (player.metaData.title) : "unknown")
                clip: true
                color:"yellow"
                Layout.alignment: "AlignCenter"
                Layout.maximumWidth: panel.width/count(parent.children)
            }

            Text{
                id: album
                text: "Album: " + ((player.metaData.albumTitle) ? (player.metaData.albumTitle) : "unknown")
                clip: true
                color:"yellow"
                Layout.alignment: "AlignCenter"
                Layout.maximumWidth: panel.width/count(parent.children)
            }

            Text{
                id: year
                text: "Year: " + ((player.metaData.year) ? (player.metaData.year) : "unknown")
                clip: true
                color:"yellow"
                Layout.alignment: "AlignCenter"
                Layout.maximumWidth: panel.width/count(parent.children)
            }
        }
    }
    //костыль
    function count(array){
       for(var i = 1; i < array.length; i++);
       return i
    }
}
