import { Bar } from "./bar.js";
import Gdk from "gi://Gdk";

App.config({
  style: "./style.css",
  windows: [
    Bar(0),
    // NotificationPopups(0)
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
