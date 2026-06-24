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

    required property var screen

    // --- Configuration & Helpers ---

    property var targetScreens: {
        var screens = Quickshell.screens;
        for (var i = 0; i < screens.length; i++) {
            if (screens[i].name === root.screen) return [screens[i]];
        }
        return []
    }

    function getIcon(appId) {
        if (!appId) return "application-x-executable";
        if (appId === "System") return "settings";
        var entry = DesktopEntries.heuristicLookup(appId);
        if (entry && entry.icon) return entry.icon;
        return appId;
    }

    // --- Grouping Logic ---

    property var windowGroups: ({})
    property var appsList: []

    function updateAppsList() {
        var apps = Object.keys(root.windowGroups).filter(function(app) {
            return root.windowGroups[app] && root.windowGroups[app].length > 0;
        });
        apps.sort();
        root.appsList = apps;
        root.groupsChanged();
    }

    function registerWindow(win) {
        if (!win || !win.appId) return;
        var app = win.appId;

        if (!root.windowGroups[app]) {
            root.windowGroups[app] = [];
        }

        if (root.windowGroups[app].indexOf(win) === -1) {
            root.windowGroups[app].push(win);
            updateAppsList();
        }
    }

    function unregisterWindow(win) {
        if (!win) return;
        
        // Search by object reference directly to bypass null property issues on teardown
        var found = false;
        for (var app in root.windowGroups) {
            var list = root.windowGroups[app];
            var idx = list.indexOf(win);
            if (idx > -1) {
                list.splice(idx, 1);
                if (list.length === 0) {
                    delete root.windowGroups[app];
                }
                found = true;
                break;
            }
        }
        if (found) {
            updateAppsList();
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
        return root.windowGroups[appId] ? root.windowGroups[appId].length : 0;
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

    Variants {
        model: root.targetScreens

        PanelWindow {
            id: panel

            required property var modelData
            screen: modelData

            exclusiveZone: implicitWidth

            anchors {
                top: true
                bottom: true
                left: true
            }

            implicitWidth: 42
            color: "#142027"

            ColumnLayout {
                anchors.fill: parent
                anchors.topMargin: 8
                anchors.bottomMargin: 8
                spacing: 4

                // --- Clock & Date ---
                Item {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 42
                    Layout.preferredHeight: clockColumn.implicitHeight + 2
                    Layout.bottomMargin: 4

                    readonly property var calProcess: Process {
                        command: ["brave", "--app=https://calendar.google.com"]
                    }

                    MouseArea {
                        width: parent.width
                        height: parent.height
                        cursorShape: Qt.PointingHandCursor
                        onClicked: parent.calProcess.startDetached()

                        Rectangle {
                            anchors.fill: parent
                            radius: 5
                            color: "white"
                            opacity: parent.containsMouse ? 0.07 : 0.0
                            Behavior on opacity { NumberAnimation { duration: 150 } }
                        }
                    }

                    SystemClock {
                        id: clock
                        precision: SystemClock.Minutes
                    }

                    ColumnLayout {
                        id: clockColumn
                        anchors.centerIn: parent
                        spacing: -2
                        enabled: false

                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: Qt.formatDateTime(clock.date, "hh")
                            color: "white"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 14
                            font.weight: 800
                        }

                        Text {
                            Layout.alignment: Qt.AlignHCenter
                            text: Qt.formatDateTime(clock.date, "mm")
                            color: "white"
                            font.family: "JetBrainsMono Nerd Font"
                            font.pixelSize: 14
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
                }

                // --- App List ---
                Repeater {
                    model: root.appsList
                    delegate: Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 34

                        readonly property string currentAppId: modelData
                        readonly property int groupCount: root.getGroupCount(currentAppId)

                        Connections {
                            target: root
                            function onGroupsChanged() {
                                badgeRect.visible = root.getGroupCount(currentAppId) > 1;
                                countText.text    = root.getGroupCount(currentAppId);
                            }
                        }

                        MouseArea {
                            id: mouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: root.activateGroup(currentAppId)
                        }

                        Rectangle {
                            width: 30; height: 30
                            anchors.centerIn: parent
                            radius: 5
                            color: "white"
                            opacity: mouseArea.containsMouse ? 0.1 : 0.0
                            Behavior on opacity { NumberAnimation { duration: 150 } }
                        }

                        IconImage {
                            anchors.centerIn: parent
                            width: 20; height: 20
                            source: Quickshell.iconPath(root.getIcon(currentAppId))
                        }

                        Rectangle {
                            id: badgeRect
                            visible: groupCount > 1
                            width: 14; height: 14
                            radius: 7
                            color: "#AD3822"
                            anchors.bottom: parent.bottom
                            anchors.right: parent.right
                            anchors.rightMargin: 8
                            anchors.bottomMargin: 2

                            Text {
                                id: countText
                                anchors.centerIn: parent
                                text: groupCount
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

                // --- Bottom Controls ---
                ColumnLayout {
                    spacing: 8

                    component ControlButton: Item {
                        Layout.alignment: Qt.AlignHCenter
                        Layout.fillWidth: true
                        Layout.preferredHeight: 24

                        property string iconName: ""
                        signal clicked()

                        MouseArea {
                            id: btnMouseArea
                            width: parent.width
                            height: parent.height 
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: parent.clicked()
                        }

                        Rectangle {
                            width: 24; height: 24
                            anchors.centerIn: parent
                            radius: 5
                            color: "white"
                            opacity: btnMouseArea.containsMouse ? 0.1 : 0.0
                            Behavior on opacity { NumberAnimation { duration: 150 } }
                        }

                        IconImage {
                            anchors.centerIn: parent
                            width: 14; height: 14
                            source: Quickshell.iconPath(parent.iconName)
                        }
                    }

                    ControlButton {
                        iconName: "volume-level-high"
                        readonly property var process: Process {
                            command: ["lio-launch-floating-terminal", "--silent", "wiremix"]
                        }
                        onClicked: process.startDetached()
                    }

                    ControlButton {
                        iconName: "system-shutdown"
                        readonly property var process: Process {
                            command: ["walker", "--provider", "menus:power"]
                        }
                        onClicked: process.startDetached()
                    }

                    ControlButton {
                        iconName: "notifications"
                    }
                }
            }
        }
    }
}
