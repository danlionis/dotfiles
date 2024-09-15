import Gdk from "gi://Gdk";

const hyprland = await Service.import("hyprland");
const notifications = await Service.import("notifications");
const mpris = await Service.import("mpris");
const audio = await Service.import("audio");
const battery = await Service.import("battery");
const systemtray = await Service.import("systemtray");

const date = Variable("", {
  poll: [1000, 'date "+%e %b %H:%M"'],
});

// widgets can be only assigned as a child in one container
// so to make a reuseable widget, make it a function
// then you can simply instantiate one by calling it

const dispatch = (ws) => hyprland.messageAsync(`dispatch workspace ${ws}`);

/**
 * @param {number} i
 * @param {import("./types/service").Binding<import("./types/service/hyprland").ActiveID, "id", number>} activeId
 * @param {number} label
 */
export function WorkspaceButton(i, activeId, label) {
  return Widget.Button({
    attribute: i,
    class_name: activeId.as((id) => `${i === id ? "active" : ""}`),
    child: Widget.Label(`${label}`),
    onClicked: () => dispatch(i),
  });
}

export function Workspaces() {
  const activeId = hyprland.active.workspace.bind("id");

  return Widget.EventBox({
    class_name: "workspaces",
    onScrollUp: () => dispatch("+1"),
    onScrollDown: () => dispatch("-1"),
    child: Widget.Box({
      spacing: 4,
      children: Array.from({ length: 10 }, (_, i) => i + 1).map((i) =>
        WorkspaceButton(i, activeId, i),
      ),

      // remove this setup hook if you want fixed number of buttons
      setup: (self) =>
        self.hook(hyprland, () =>
          self.children.forEach((btn) => {
            btn.visible = hyprland.workspaces.some(
              (ws) => ws.id === btn.attribute,
            );
          }),
        ),
    }),
  });
}

// function Workspaces() {
//   const activeId = hyprland.active.workspace.bind("id");
//   return Widget.EventBox({
//     onScrollUp: () => dispatch("+1"),
//     onScrollDown: () => dispatch("-1"),
//     child: Widget.Box({
//       class_name: "workspaces",
//       children: Array.from({ length: 10 }, (_, i) => i + 1).map((i) =>
//         Widget.Button({
//           attribute: i,
//           child: Widget.Label(`${i}`),
//           // label: activeId.as(id => `${i === id ? "focused " + i  : i}`),
//           // class_name: activeId.as(i => `${i === id ? "focused" : ""}`),
//           class_name: activeId.as((id) => `${i === id ? "focused" : ""}`),
//           onClicked: () => dispatch(i),
//         }),
//       ),
//       // remove this setup hook if you want fixed number of buttons
//       setup: (self) =>
//         self.hook(hyprland, () =>
//           self.children.forEach((btn) => {
//             btn.visible = hyprland.workspaces.some(
//               (ws) => ws.id === btn.attribute,
//             );
//           }),
//         ),
//     }),
//   });
// }

// function Workspaces() {
//   const activeId = hyprland.active.workspace.bind("id");
//   const workspaces = hyprland
//     .bind("workspaces")
//     .as((ws) => ws.map(({ id }) => WorkspaceButton(id, activeId, id)));
//
//   // sort workspaces by id
//   workspaces.sort((a, b) => a.attribute - b.attribute);
//
//   return Widget.EventBox({
//     class_name: "workspaces",
//     onScrollUp: () => dispatch("+1"),
//     onScrollDown: () => dispatch("-1"),
//     child: Widget.Box({
//       class_name: "workspaces",
//       spacing: 4,
//       children: workspaces,
//     }),
//   });
// }

/**
 * @param {number} monitor
 */
function ClientTitle(monitor) {
  return Widget.Label({
    class_name: "title",
    label: hyprland.active.client.bind("title"),
  });
}

function Clock() {
  return Widget.Label({
    class_name: "clock",
    label: date.bind(),
  });
}

// we don't need dunst or any other notification daemon
// because the Notifications module is a notification daemon itself
function Notification() {
  const popups = notifications.bind("popups");
  return Widget.Box({
    class_name: "notification",
    visible: popups.as((p) => p.length > 0),
    children: [
      Widget.Icon({
        icon: "preferences-system-notifications-symbolic",
      }),
      Widget.Label({
        label: popups.as((p) => p[0]?.summary || ""),
      }),
    ],
  });
}

function Media() {
  const label = Utils.watch("", mpris, "player-changed", () => {
    if (mpris.players[0]) {
      const { track_artists, track_title } = mpris.players[0];
      return `${track_artists.join(", ")} - ${track_title}`;
    } else {
      return "Nothing is playing";
    }
  });

  return Widget.Button({
    class_name: "media",
    on_primary_click: () => mpris.getPlayer("")?.playPause(),
    on_scroll_up: () => mpris.getPlayer("")?.next(),
    on_scroll_down: () => mpris.getPlayer("")?.previous(),
    child: Widget.Label({ label }),
  });
}

function Volume() {
  const icons = {
    101: "overamplified",
    67: "high",
    34: "medium",
    1: "low",
    0: "muted",
  };

  function getIcon() {
    const icon = audio.speaker.is_muted
      ? 0
      : [101, 67, 34, 1, 0].find(
          (threshold) => threshold <= audio.speaker.volume * 100,
        );

    return `audio-volume-${icons[icon]}-symbolic`;
  }

  const icon = Widget.Icon({
    icon: Utils.watch(getIcon(), audio.speaker, getIcon),
  });

  const slider = Widget.Slider({
    hexpand: true,
    draw_value: false,
    on_change: ({ value }) => (audio.speaker.volume = value),
    setup: (self) =>
      self.hook(audio.speaker, () => {
        self.value = audio.speaker.volume || 0;
      }),
  });

  return Widget.Box({
    class_name: "volume",
    css: "min-width: 180px",
    children: [icon, slider],
  });
}

function BatteryLabel() {
  const value = battery.bind("percent").as((p) => (p > 0 ? p / 100 : 0));
  const icon = battery
    .bind("percent")
    .as((p) => `battery-level-${Math.floor(p / 10) * 10}-symbolic`);

  return Widget.Box({
    class_name: "battery",
    visible: battery.bind("available"),
    children: [
      Widget.Icon({ icon }),
      Widget.LevelBar({
        widthRequest: 140,
        vpack: "center",
        value,
      }),
    ],
  });
}

const SysTrayItem = (item) =>
  Widget.Button({
    child: Widget.Icon().bind("icon", item, "icon"),
    tooltipMarkup: item.bind("tooltip_markup"),
    onPrimaryClick: (_, event) => item.activate(event),
    onSecondaryClick: (_, event) => item.openMenu(event),
  });

const sysTray = Widget.Box({
  class_name: "tray",
  children: systemtray.bind("items").as((i) => i.map(SysTrayItem)),
});

// layout of the bar
function Left() {
  return Widget.Box({
    spacing: 8,
    children: [Workspaces(), ClientTitle()],
  });
}

function Center() {
  return Widget.Box({
    spacing: 8,
    children: [Clock()],
  });
}

function Right() {
  return Widget.Box({
    hpack: "end",
    spacing: 8,
    children: [BatteryLabel(), sysTray],
  });
}

function Bar(monitor = 0) {
  return Widget.Window({
    name: `bar-${monitor}`, // name has to be unique
    class_name: "bar",
    monitor,
    anchor: ["top", "left", "right"],
    exclusivity: "exclusive",
    child: Widget.CenterBox({
      class_name: "cbox",
      start_widget: Left(),
      center_widget: Center(),
      end_widget: Right(),
    }),
  });
}

App.config({
  style: "./style.css",
  windows: [
    // Bar(),

    // you can call it, for each monitor
    Bar(0),
  ],
});

export {};

/**
 * @param {(monitor: number) => Gdk.Window} widget
 * @returns {Gdk.Window[]}
 */
export function forMonitors(widget) {
  const n = Gdk.Display.get_default()?.get_n_monitors() || 1;
  return Array.from({ length: n }, (_, i) => widget(i));
}
