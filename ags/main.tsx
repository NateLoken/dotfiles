import app from "ags/gtk4/app";
import { Astal, Gtk } from "ags/gtk4";
import { For, createBinding, createComputed } from "ags";
import { createPoll } from "ags/time";
import GLib from "gi://GLib";
import Hyprland from "gi://AstalHyprland";
import Network from "gi://AstalNetwork";
import Bluetooth from "gi://AstalBluetooth";
import style from "./style.scss";

const hypr = Hyprland.get_default();
const network = Network.get_default();
const bluetooth = Bluetooth.get_default();
function Workspaces() {
  const workspaces = createBinding(hypr, "workspaces");
  const focused = createBinding(hypr, "focused-workspace");
  const sorted = workspaces((list) =>
    [...list].sort((a, b) => a.id - b.id).filter((w) => w.id > 0),
  );
  return (
    <box class="segment workspaces" spacing={7}>
      <For each={sorted}>
        {(ws) => (
          <button
            class={focused((f) => (f?.id === ws.id ? "ws active" : "ws"))}
            onClicked={() => ws.focus()}
          >
            <box class="ws-stack" />
          </button>
        )}
      </For>
    </box>
  );
}
function OpenApps() {
  const focusedClient = createBinding(hypr, "focused-client");
  const activeLabel = createComputed(() => {
    const client = focusedClient();
    if (!client) return "DESKTOP";
    return (client.class || client.title || "APP").toUpperCase();
  });
  return (
    <box class="segment active-window" spacing={6}>
      <label class="active-label" label={activeLabel} xalign={0.5} hexpand halign={Gtk.Align.CENTER} />
    </box>
  );
}
function WifiStatus() {
  const wifi = network.wifi;
  const ssid = createBinding(wifi, "ssid");
  const enabled = createBinding(wifi, "enabled");
  const strength = createBinding(wifi, "strength");
  const netClass = createComputed(() => {
    if (!enabled()) return "status-icon wifi off";
    if (!ssid()) return "status-icon wifi disconnected";
    return "status-icon wifi connected";
  });
  const wifiIcon = createComputed(() => {
    if (!enabled()) return "󰖪";
    if (!ssid()) return "󰤩";
    const value = strength();
    if (value > 80) return "󰤨";
    if (value > 60) return "󰤥";
    if (value > 35) return "󰤢";
    return "󰤟";
  });
  return <label class={netClass} label={wifiIcon} />;
}
function BluetoothStatus() {
  const powered = createBinding(bluetooth, "is-powered");
  const connected = createBinding(bluetooth, "is-connected");
  const btClass = createComputed(() => {
    if (!powered()) return "bt off";
    return connected() ? "bt connected" : "bt on";
  });
  const btIcon = createComputed(() => {
    if (!powered()) return "󰂲";
    return connected() ? "󰂱" : "󰂯";
  });
  return (
    <button class={btClass((v) => `icon-button ${v}`)} onClicked={() => bluetooth.toggle()}>
      <label class="status-icon bt" label={btIcon} />
    </button>
  );
}
function ClockModule() {
  const clock = createPoll("--- --- -- --:--", 1000, () => {
    const now = GLib.DateTime.new_now_local();
    return now ? now.format("%a %b %d %H:%M") ?? "--- --- -- --:--" : "--- --- -- --:--";
  });
  return (
    <box class="segment clock-module">
      <label class="clock-label" label={clock} xalign={0.5} hexpand halign={Gtk.Align.CENTER} />
    </box>
  );
}
function ConnectivityModule() {
  return (
    <box class="segment connectivity-module" spacing={8}>
      <WifiStatus />
      <BluetoothStatus />
    </box>
  );
}
function Island() {
  return (
    <box class="island" spacing={8}>
      <Workspaces />
      <OpenApps />
      <ClockModule />
      <box class="right-cluster" spacing={6}>
        <ConnectivityModule />
      </box>
    </box>
  );
}
function IslandWindow(monitor: number) {
  const { TOP, LEFT, RIGHT } = Astal.WindowAnchor;
  return (
    <window
      visible
      name={`island-${monitor}`}
      namespace="dynamic-island"
      monitor={monitor}
      layer={Astal.Layer.OVERLAY}
      exclusivity={Astal.Exclusivity.IGNORE}
      keymode={Astal.Keymode.ON_DEMAND}
      anchor={TOP | LEFT | RIGHT}
      class="IslandWindow"
    >
      <box class="island-stage" hexpand halign={Gtk.Align.CENTER} valign={Gtk.Align.START}>
        <Island />
      </box>
    </window>
  );
}
app.start({
  css: style,
  main() {
    for (let i = 0; i < app.monitors.length; i++) {
      IslandWindow(i);
    }
  },
});
