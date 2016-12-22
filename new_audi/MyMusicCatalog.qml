/**
 * MyMusicCatalog.qml
 *
 * copyright (c) 2016 Stepanov Mihail
 */

import QtQuick 2.7
import Qt.labs.folderlistmodel 2.1
import QtQuick.Dialogs 1.2
import QtQuick.Controls 1.5
import QtQml.Models 2.2
import QtQuick.Layouts 1.1
import QtQuick.Controls.Styles 1.4

Rectangle{
    id:container
    color: "black"
    radius: 4
    Layout.preferredWidth: 300

    TreeView {
        id: tree
        anchors.fill: parent
        anchors.margins: mrg
        clip: true
        model: fileSystemModel
        rootIndex: rootPathIndex
        selection:  ItemSelectionModel {
            id: sel
            model: fileSystemModel
        }
        selectionMode: SelectionMode.ExtendedSelection

        property var index_val

        itemDelegate: Component{
            id:delegate
            Item{

                Text{
                    id: content
                    text:styleData.value
                    color:styleData.textColor
                    elide: styleData.elideMode
                    horizontalAlignment: styleData.textAligment

                    Drag.active: dragArea.drag.active
                    Drag.supportedActions: Qt.CopyAction
                    Drag.dragType: Drag.Automatic
                    Drag.mimeData: { "text/uri-list":  selectedURLs()}

                    states: State {
                        name: "CurrentlyDragging"
                        when: dragArea.drag.active
                        PropertyChanges { target: content; parent: container }
                        PropertyChanges { target: content; x: container.mouseX - content.width / 2 }
                        PropertyChanges { target: content; y: container.mouseY - content.height / 2 }
                    }

                    function selectedURLs() {
                        var indexes = sel.selectedIndexes
                        var urls = ""
                        for (var i in indexes) {
                            if(!fileSystemModel.hasChildren(indexes[i]))
                            urls = urls + fileSystemModel.data(indexes[i], Qt.UserRole + 4)+ "\n"
                        }
                        return urls
                    }

                    MouseArea{
                        id: dragArea
                        anchors.fill: parent
                        drag.target: content
                        drag.filterChildren: true
                        propagateComposedEvents: true
                        onPressed: {
                            if (mouse.modifiers & Qt.ControlModifier) {
                                sel.setCurrentIndex(
                                            styleData.index,
                                            ItemSelectionModel.Toggle)
                            } else
                                if (mouse.modifiers & Qt.ShiftModifier) {
                                    var urls = fileSystemModel.selection(
                                                sel.currentIndex,
                                                styleData.index)

                                    sel.select(urls, ItemSelectionModel.ClearAndSelect)
                                }
                                else {
                                    sel.setCurrentIndex(
                                                styleData.index,
                                                ItemSelectionModel.ClearAndSelect)
                                    tree.index_val = styleData.index //conform
                                }
                        }
                    }
                }
            }
        }

        style: TreeViewStyle{
            //activateItemOnSingleClick: true
            backgroundColor: "black"
            alternateBackgroundColor: "black"
            textColor: "yellow"
            highlightedTextColor : "white"


            handle: Rectangle {
                radius: 4
                implicitWidth: mrg
                color: "gray"
            }

            scrollBarBackground: Rectangle {
                implicitWidth: mrg
                color: "black"
            }
            decrementControl: Rectangle {
                radius: 4
                implicitWidth: mrg
                implicitHeight: 16
                color: "gray"
            }
            incrementControl: Rectangle {
                radius: 4
                implicitWidth: mrg
                implicitHeight: 16
                color: "gray"
            }
        }


        TableViewColumn {
            title: "Name"
            role: "fileName"
            resizable: false
            width: parent.width
        }

        onClicked: index_val = index //conform

        onActivated: {
            var url = fileSystemModel.data(index_val, Qt.UserRole + 4)
            if(!fileSystemModel.hasChildren(index_val))
            playlist.addItem(url)
        }
    }
}
