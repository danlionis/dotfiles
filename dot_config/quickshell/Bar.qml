// @ pragma IconTheme Papirus-Dark
import QtQuick
import QtQuick.Layouts
import QtQml
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Widgets

Scope {
    id: root 
    
    signal groupsChanged()

    property var screen: 0;
    // --- Configuration & Helpers ---
    property var targetScreen: {
        var screens = Quickshell.screens;
        return screens[screen];
    }

    function getIcon(appId) {
        if (!appId) return "application-x-executable";
        
        // Custom override for your "System" app
        if (appId === "System") return "settings"; 

        var entry = DesktopEntries.heuristicLookup(appId);
        if (entry && entry.icon) return entry.icon;
        return appId;
    }

    // --- Grouping Logic ---
    ListModel { id: groupedAppsModel }
    property var windowGroups: ({}) 

    function registerWindow(win) {
        var app = win.appId || "unknown";
        
        if (!root.windowGroups[app]) {
            root.windowGroups[app] = [];
            
            // Sorting Logic
            var inserted = false;
            for (var i = 0; i < groupedAppsModel.count; i++) {
                if (app.localeCompare(groupedAppsModel.get(i).appId) < 0) {
                    groupedAppsModel.insert(i, { "appId": app });
                    inserted = true;
                    break;
                }
            }
            if (!inserted) {
                groupedAppsModel.append({ "appId": app });
            }
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
            var next = list.shift();
            next.activate();
            list.push(next);
        }
    }

    function getGroupCount(appId) {
        return (root.windowGroups[appId]) ? root.windowGroups[appId].length : 0;
    }

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
        id: panel
        screen: targetScreen
        
        anchors {
            top: true
            bottom: true
            left: true
        }

        implicitWidth: 48
        color: "#142027"

        ColumnLayout {
            anchors.fill: parent
            anchors.topMargin: 8
            anchors.bottomMargin: 8
            spacing: 4

            // --- Clock & Date ---
            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                Layout.bottomMargin: 10
                spacing: -2
                
                MouseArea {
                    anchors.fill: parent
                    readonly property var process: Process {
                        command: ["brave", "--app=https://calendar.google.com"]
                    }
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    // onClicked: root.activateGroup(currentAppId)
                    onClicked: process.startDetached()
                }

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
                    font.weight: 800
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    text: Qt.formatDateTime(clock.date, "mm")
                    color: "white"
                    font.family: "JetBrainsMono Nerd Font"
                    font.pixelSize: 18
                }

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 4
                    text: Qt.formatDateTime(clock.date, "dd.M")
                    color: "white"
                    opacity: 0.6
                    font.family: "JetBrainsMono Nerd Font"
                    font.weight: 600
                    font.pixelSize: 10
                }
            }

            // --- App List ---
            Repeater {
                model: groupedAppsModel
                delegate: Item {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 42
                    readonly property string currentAppId: appId

                    MouseArea {
                        id: mouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: root.activateGroup(currentAppId)
                    }

                    Rectangle {
                        width: 38; height: 38
                        anchors.centerIn: parent
                        radius: 5
                        color: "white"
                        opacity: mouseArea.containsMouse ? 0.1 : 0.0
                        Behavior on opacity { NumberAnimation { duration: 150 } }
                    }
                    
                    IconImage {
                        anchors.centerIn: parent
                        width: 28; height: 28
                        source: Quickshell.iconPath(root.getIcon(currentAppId))
                    }

                    Rectangle {
                        id: badge
                        visible: root.getGroupCount(currentAppId) > 1
                        width: 14; height: 14
                        radius: 7
                        color: "#AD3822"
                        anchors.bottom: parent.bottom
                        anchors.right: parent.right
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
                            color: "#BDDDD2"
                            font.pixelSize: 10
                            font.bold: true
                            font.family: "JetBrainsMono Nerd Font"
                        }
                    }
                }
            }

            // --- Spacer ---
            Item { Layout.fillHeight: true }


            ColumnLayout {
                spacing: 8
                Item {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    Layout.preferredHeight: 24
                    id: audio


                    MouseArea {
                        readonly property var process: Process {
                            command: ["lio-launch-floating-terminal", "--silent", "wiremix"]
                        }
                        id: mouseAreaAudio
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        // onClicked: root.activateGroup(currentAppId)
                        onClicked: process.startDetached()
                    }
                    Rectangle {
                        width: 28; height: 28
                        anchors.centerIn: parent
                        radius: 5
                        color: "white"
                        opacity: mouseAreaAudio.containsMouse ? 0.1 : 0.0
                        Behavior on opacity { NumberAnimation { duration: 150 } }
                    }
                    IconImage {
                        anchors.centerIn: parent
                        width: 16; height: 16
                        source: Quickshell.iconPath("volume-level-high")
                    }
                }

                Item {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    Layout.preferredHeight: 24
                    id: power


                    MouseArea {
                        readonly property var process: Process {
                            command: ["walker", "--provider", "menus:power"]
                        }
                        id: mouseAreaPower
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        // onClicked: root.activateGroup(currentAppId)
                        onClicked: process.startDetached()
                    }
                    Rectangle {
                        width: 28; height: 28
                        anchors.centerIn: parent
                        radius: 5
                        color: "white"
                        opacity: mouseAreaPower.containsMouse ? 0.1 : 0.0
                        Behavior on opacity { NumberAnimation { duration: 150 } }
                    }
                    IconImage {
                        anchors.centerIn: parent
                        width: 16; height: 16
                        source: Quickshell.iconPath("system-shutdown")
                    }
                }

                Item {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    Layout.preferredHeight: 24
                    id: notifications


                    MouseArea {
                        id: mouseAreaNotifications
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                    }
                    Rectangle {
                        width: 28; height: 28;
                        anchors.centerIn: parent
                        radius: 5
                        color: "white"
                        opacity: mouseAreaNotifications.containsMouse ? 0.1 : 0.0
                        Behavior on opacity { NumberAnimation { duration: 150 } }
                    }
                    IconImage {
                        anchors.centerIn: parent
                        width: 16; height: 16
                        source: Quickshell.iconPath("notifications")
                    }
                }
            }
        }
    }
}
