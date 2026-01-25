import QtQuick
import QtQuick.Layouts
import QtQml
import Quickshell
import Quickshell.Wayland
import Quickshell.Widgets

ShellRoot {
    id: root 
    
    // Signal to notify when groups change (required for the counter)
    signal groupsChanged()

    // --- Configuration & Helpers ---
    
    property var targetScreen: {
        var screens = Quickshell.screens;
        var rightmost = screens[0];
        for (var i = 1; i < screens.length; i++) {
            if (screens[i].x > rightmost.x) {
                rightmost = screens[i];
            }
        }
        return rightmost;
    }

    // NEW: Dynamic icon lookup using Quickshell's DesktopEntries
    function getIcon(appId) {
        if (!appId) return "application-x-executable"; // Fallback for empty IDs

        // Try to find the .desktop file matching this appId
        var entry = DesktopEntries.heuristicLookup(appId);
        
        // If found and it has an icon, use it. Otherwise, fallback to appId.
        if (entry && entry.icon) {
            return entry.icon;
        }
        return appId;
    }

    // --- Grouping Logic ---

    // The visible model for the Repeater (List of unique AppIDs)
    ListModel {
        id: groupedAppsModel
    }

    // The internal map storing the actual window objects
    property var windowGroups: ({}) 

    function registerWindow(win) {
        var app = win.appId || "unknown";
        
        // If this is the first window of this app, add to UI model
        if (!root.windowGroups[app]) {
            root.windowGroups[app] = [];
            groupedAppsModel.append({ "appId": app });
        }
        
        root.windowGroups[app].push(win);
        root.groupsChanged(); 
    }

    function unregisterWindow(win) {
        var app = win.appId || "unknown";
        if (!root.windowGroups[app]) return;
        
        var list = root.windowGroups[app];
        var idx = list.indexOf(win);
        
        if (idx > -1) {
            list.splice(idx, 1);
            
            // If no windows left, remove from UI model
            if (list.length === 0) {
                delete root.windowGroups[app];
                for (var i = 0; i < groupedAppsModel.count; i++) {
                    if (groupedAppsModel.get(i).appId === app) {
                        groupedAppsModel.remove(i);
                        break;
                    }
                }
            }
            root.groupsChanged(); 
        }
    }

    function activateGroup(appId) {
        var list = root.windowGroups[appId];
        if (!list || list.length === 0) return;

        if (list.length === 1) {
            list[0].activate();
        } else {
            // Cycle: Move first to last, activate new first
            var next = list.shift();
            next.activate();
            list.push(next);
        }
    }

    function getGroupCount(appId) {
        return (root.windowGroups[appId]) ? root.windowGroups[appId].length : 0;
    }

    // --- Window Tracker ---
    Instantiator {
        model: ToplevelManager.toplevels
        delegate: QtObject {
            readonly property var win: modelData
            Component.onCompleted: root.registerWindow(win)
            Component.onDestruction: root.unregisterWindow(win)
        }
    }

    // --- Visuals ---
    PanelWindow {
        screen: targetScreen
        
        anchors {
            top: true
            bottom: true
            left: true
        }

        implicitWidth: 50
        color: "#1e1e2e"

        ColumnLayout {
            anchors.fill: parent
            anchors.topMargin: 10
            spacing: 4

            // Clock
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 10
                spacing: -2

                SystemClock {
                    id: clock
                    precision: SystemClock.Minutes
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: Qt.formatDateTime(clock.date, "hh")
                    color: "white"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 18
                    font.bold: true
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: Qt.formatDateTime(clock.date, "mm")
                    color: "white"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 18
                }
            }

            // Grouped App List
            Repeater {
                model: groupedAppsModel
                
                delegate: Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    
                    readonly property string currentAppId: appId

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.activateGroup(currentAppId)
                    }

                    // Hover Background
                    Rectangle {
                        width: 38; height: 38
                        anchors.centerIn: parent
                        radius: 5
                        color: "white"
                        opacity: mouseArea.containsMouse ? 0.1 : 0.0
                        Behavior on opacity { NumberAnimation { duration: 150 } }
                    }
                    
                    // Icon
                    IconImage {
                        anchors.centerIn: parent
                        width: 32; height: 32
                        // UPDATED: Use the dynamic getIcon function
                        source: Quickshell.iconPath(root.getIcon(currentAppId))
                    }

                    // Count Badge
                    Rectangle {
                        id: badge
                        visible: root.getGroupCount(currentAppId) > 1
                        
                        width: 14; height: 14
                        radius: 7
                        color: "#fab387" // Peach
                        
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
                        
                        // Custom Margins
                        anchors.rightMargin: 8
                        anchors.bottomMargin: 2
                        
                        Connections {
                            target: root
                            function onGroupsChanged() { 
                                badge.visible = root.getGroupCount(currentAppId) > 1
                                countText.text = root.getGroupCount(currentAppId)
                            }
                        }

                        Text {
                            id: countText
                            anchors.centerIn: parent
                            text: root.getGroupCount(currentAppId)
                            color: "#1e1e2e"
                            font.pixelSize: 10
                            font.bold: true
                            font.family: "JetBrainsMono Nerd Font"
                        }
                    }
                }
            }

            Item { Layout.fillHeight: true }
        }
    }
}
