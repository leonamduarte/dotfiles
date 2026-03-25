# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import subprocess
from libqtile import bar, hook, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
import colors

# from qtile_extras import widget
from qtile_extras.widget.decorations import PowerLineDecoration, RectDecoration

# from spotify import Spotify


def dmlogout():
    qtile.cmd_spawn("sh -c /home/lm/.config/qtile/scripts/dm-logout.sh")


def search():
    qtile.cmd_spawn("rofi -show drun")


def power():
    qtile.cmd_spawn("sh -c ~/.config/rofi/scripts/power")


powerline = {
    "decorations": [
        RectDecoration(use_widget_background=True, padding_y=5, filled=True, radius=0),
        PowerLineDecoration(path="arrow_right", padding_y=5),
    ]
}

mod = "mod4"  # Sets mod key to SUPER/WINDOWS
myTerm = "wezterm"  # My terminal of choice
myBrowser = "brave"  # My browser of choice
myFiles = "thunar"  # My file manager of choice
myCode = "code"  # vscode
myMusic = "spotify"  # spotify
myEmacs = "emacs --init-directory ~/.config/bashmacs"  # The space at the end is IMPORTANT!
myNeovim = "neovide"
logOut = dmlogout

# Allows you to input a name when adding treetab section.


@lazy.layout.function
def add_treetab_section(layout):
    prompt = qtile.widgets_map["prompt"]
    prompt.start_input("Section name: ", layout.cmd_add_section)


# A function for hide/show all the windows in a group


@lazy.function
def minimize_all(qtile):
    for win in qtile.current_group.windows:
        if hasattr(win, "toggle_minimize"):
            win.toggle_minimize()


# A function for toggling between MAX and MONADTALL layouts


@lazy.function
def maximize_by_switching_layout(qtile):
    current_layout_name = qtile.current_group.layout.name
    if current_layout_name == "monadtall":
        qtile.current_group.layout = "max"
    elif current_layout_name == "max":
        qtile.current_group.layout = "monadtall"


keys = [
    # The essentials
    Key([mod], "Return", lazy.spawn(myTerm), desc="Terminal"),
    Key([mod, "shift"], "d", lazy.spawn("rofi -show drun"), desc="Run Launcher"),
    # Key([mod, "shift"], "s", lazy.spawn("flameshot gui"), desc="Run screenshot"),
    Key([mod, "shift"], "Return", lazy.spawn(myFiles), desc="Run thunar"),
    Key([mod, "shift"], "p", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod, "shift"], "w", lazy.spawn(myBrowser), desc="Web browser"),
    Key([mod], "F2", lazy.spawn(myCode), desc="code"),
    Key([mod, "shift"], "n", lazy.spawn(myNeovim), desc="nvim"),
    Key([mod, "shift"], "s", lazy.spawn(myMusic), desc="spotify"),
    Key(
        [mod],
        "b",
        lazy.hide_show_bar(position="all"),
        desc="Toggles the bar to show/hide",
    ),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload the config"),
    Key(
        [mod, "shift"],
        "x",
        lazy.spawn("sh -c /home/lm/.config/qtile/scripts/dm-logout.sh"),
        desc="logout menu",
    ),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    # Switch between windows
    # Some layouts like 'monadtall' only need to use j/k to move
    # through the stack, but other layouts like 'columns' will
    # require all four directions h/j/k/l to move around.
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key(
        [mod, "shift"],
        "h",
        lazy.layout.shuffle_left(),
        lazy.layout.move_left().when(layout=["treetab"]),
        desc="Move window to the left/move tab left in treetab",
    ),
    Key(
        [mod, "shift"],
        "l",
        lazy.layout.shuffle_right(),
        lazy.layout.move_right().when(layout=["treetab"]),
        desc="Move window to the right/move tab right in treetab",
    ),
    Key(
        [mod, "shift"],
        "j",
        lazy.layout.shuffle_down(),
        lazy.layout.section_down().when(layout=["treetab"]),
        desc="Move window down/move down a section in treetab",
    ),
    Key(
        [mod, "shift"],
        "k",
        lazy.layout.shuffle_up(),
        lazy.layout.section_up().when(layout=["treetab"]),
        desc="Move window downup/move up a section in treetab",
    ),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "space",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    # Treetab prompt
    Key(
        [mod, "shift"],
        "a",
        add_treetab_section,
        desc="Prompt to add new section in treetab",
    ),
    # Grow/shrink windows left/right.
    # This is mainly for the 'monadtall' and 'monadwide' layouts
    # although it does also work in the 'bsp' and 'columns' layouts.
    Key(
        [mod],
        "equal",
        lazy.layout.grow_left().when(layout=["bsp", "columns"]),
        lazy.layout.grow().when(layout=["monadtall", "monadwide"]),
        desc="Grow window to the left",
    ),
    Key(
        [mod],
        "minus",
        lazy.layout.grow_right().when(layout=["bsp", "columns"]),
        lazy.layout.shrink().when(layout=["monadtall", "monadwide"]),
        desc="Grow window to the left",
    ),
    # Grow windows up, down, left, right.  Only works in certain layouts.
    # Works in 'bsp' and 'columns' layout.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key(
        [mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"
    ),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod], "m", lazy.layout.maximize(), desc="Toggle between min and max sizes"),
    Key([mod], "t", lazy.window.toggle_floating(), desc="toggle floating"),
    Key(
        [mod],
        "f",
        lazy.window.toggle_fullscreen(),
        desc="toggle fullscreen",
    ),
    Key(
        [mod, "shift"],
        "m",
        minimize_all(),
        desc="Toggle hide/show all windows on current group",
    ),
    # Switch focus of monitors
    Key([mod], "period", lazy.next_screen(), desc="Move focus to next monitor"),
    Key([mod], "comma", lazy.prev_screen(), desc="Move focus to prev monitor"),
    # Emacs programs launched using the key chord SUPER+e followed by 'key'
    Key([mod], "e", lazy.spawn(myEmacs), desc="Emacs Dashboard"),
]

power_commands = {
    "s": ("systemctl poweroff", "System Shutdown"),
    "r": ("systemctl reboot", "System Reboot"),
    "p": ("systemctl suspend", "System Suspend"),
}
for key, (cmd, desc) in power_commands.items():
    keys.append(Key([mod, "control"], key, lazy.spawn(cmd), desc=desc))


# groups = []
group_names = ["1", "2", "3", "4", "5"]
# group_names = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]
# group_labels = ["DEV", "WWW", "SYS", "MUS", "VBOX", "CHAT", "DOC", "VID", "GFX", "MISC"]
# group_labels = ["", "", "", "", "", "", "𝦝", "", "", "⛨"]
# group_labels = ["I", "II", "III", "IV", "V", "VI"]
# group_labels = ["", "", "", "", "", ""]
group_labels = ["", "", "", "", ""]
group_layouts = ["monadtall"] * len(group_names)

# Cria grupos 1-5
groups = []

for i, name in enumerate(group_names):
    matches = []
    if name == "2":
        matches = [Match(wm_class="firefox-developer-edition")]

    groups.append(
        Group(
            name=name,
            label=group_labels[i],
            layout=group_layouts[i],
            matches=matches,
        )
    )


# Keybindings para grupos 1-5
# for group in groups[:-1]:  # Exclui o �ltimo grupo ("6")
for group in groups:
    keys.extend(
        [
            Key([mod], group.name, lazy.group[group.name].toscreen()),
            Key([mod, "shift"], group.name, lazy.window.togroup(group.name)),
        ]
    )
# color = colors.Dracula
color = colors.Cozytile
# color = colors.Palenight
layout_theme = {
    "border_width": 2,
    "margin": 12,
    "border_focus": color[8],
    "border_normal": color[0],
}

layouts = [
    layout.MonadTall(**layout_theme),
    # layout.Tile(**layout_theme),
    # layout.Max(**layout_theme),
]

widget_defaults = dict(
    font="JetBrainsMono", fontsize=12, padding=0, background=color[0]
)


extension_defaults = widget_defaults.copy()


def separator():
    return widget.TextBox(
        text="|",
        font="JetBrainsMono",
        foreground=color[9],
        padding=2,
        fontsize=14,
    )


def init_widgets_list():
    widgets_list = [
        widget.Spacer(length=5),
        widget.Image(
            filename="~/.config/qtile/Assets/launch_Icon.png",
            scale="False",
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn("rofi -show drun")},
        ),
        widget.Prompt(font="JetBrainsMono", fontsize=10, foreground=color[1]),
        widget.GroupBox(
            fontsize=22,
            margin_y=3,
            margin_x=8,
            padding_y=0,
            padding_x=2,
            borderwidth=3,
            active=color[8],
            inactive=color[9],
            rounded=True,
            highlight_color=color[0],
            highlight_method="line",
            this_current_screen_border=color[7],
            this_screen_border=color[4],
            other_current_screen_border=color[7],
            other_screen_border=color[4],
        ),
        separator(),
        widget.LaunchBar(
            progs=[
                ("🦁", "firefox-developer-edition", "Web Browser"),
                ("🚀", "wezterm", "Terminal"),
                ("📁", "thunar", "PCManFM file manager"),
                ("🎸", "com.spotify.Client", "Spotify"),
            ],
            fontsize=12,
            padding=5,
            foreground=color[3],
        ),
        separator(),
        widget.CurrentLayout(foreground=color[8], padding=5, **powerline),

        widget.TextBox(
            text="|",
            font="JetBrainsMono",
            foreground=color[9],
            padding=2,
            fontsize=14,
        ),
        widget.WindowName(foreground=color[6], padding=8, max_chars=40),
        widget.GenPollText(
            update_interval=300,
            func=lambda: subprocess.check_output(
                "printf $(uname -r)", shell=True, text=True
            ),
            foreground=color[3],
            padding=8,
            fmt="❤  {}",
        ),
        widget.CPU(
            foreground=color[4],
            padding=8,
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn(myTerm + " -e htop")},
            format="  Cpu: {load_percent}%",
        ),
        widget.Memory(
            foreground=color[8],
            padding=8,
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn(myTerm + " -e htop")},
            format="{MemUsed: .0f}{mm}",
            fmt="🖥  Mem: {}",
        ),
        widget.DF(
            update_interval=60,
            foreground=color[5],
            padding=8,
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn("notify-disk")},
            partition="/",
            # format = '[{p}] {uf}{m} ({r:.0f}%)',
            format="{uf}{m} free",
            fmt="🖴  Disk: {}",
            visible_on_warn=False,
        ),
        widget.Volume(
            foreground=color[7],
            padding=8,
            fmt="🕫  Vol: {}",
        ),
        widget.Clock(
            foreground=color[8],
            padding=8,
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn("notify-date")},
            # Uncomment for date and time
            # format = "⧗  %a, %b %d - %H:%M",
            # Uncomment for time only
            format="⧗  %I:%M %p",
        ),
        # Adicione na lista de widgets, por exemplo, após o GenPollText (uname -r)
        # Requer o pacote libqtile-extras ou a libqtile nativa (CheckUpdates)
        widget.CheckUpdates(
            distro="Arch",
            update_interval=1800, # 30 minutos
            display_format="📦 {updates}",
            no_update_string="📦 0 ",
            mouse_callbacks={"Button1": lambda: qtile.cmd_spawn(myTerm + " -e sudo pacman -Syu")},
        ),
        widget.Systray(padding=6),
        widget.Spacer(length=8),
    ]
    return widgets_list


def init_widgets_screen1():
    widgets_screen1 = init_widgets_list()
    return widgets_screen1


# All other monitors' bars will display everything but widgets 22 (systray) and 23 (spacer).


def init_widgets_screen2():
    widgets = []

    for w in init_widgets_list():
        if isinstance(w, widget.Systray):
            continue
        widgets.append(w)

    # Remove Spacer final se existir
    if widgets and isinstance(widgets[-1], widget.Spacer):
        widgets.pop()

    return widgets

# For adding transparency to your bar, add (background="#00000000") to the "Screen" line(s)
# For ex: Screen(top=bar.Bar(widgets=init_widgets_screen2(), background="#00000000", size=24)),


def init_screens():
    return [
        Screen(
            top=bar.Bar(widgets=init_widgets_screen1(), margin=[0, 0, 0, 0], size=28),
        ),
        Screen(
            top=bar.Bar(widgets=init_widgets_screen2(), margin=[0, 0, 0, 0], size=28),
        ),
    ]


if __name__ in ["config", "__main__"]:
    screens = init_screens()
    widgets_list = init_widgets_list()
    widgets_screen1 = init_widgets_screen1()
    widgets_screen2 = init_widgets_screen2()

mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    border_focus=color[8],
    border_width=2,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="dialog"),  # dialog boxes
        Match(wm_class="download"),  # downloads
        Match(wm_class="error"),  # error msgs
        Match(wm_class="file_progress"),  # file progress boxes
        Match(wm_class="kdenlive"),  # kdenlive
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="notification"),  # notifications
        Match(wm_class="pinentry-gtk-2"),  # GPG key password entry
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(wm_class="toolbar"),  # toolbars
        Match(wm_class="Yad"),  # yad boxes
        Match(title="branchdialog"),  # gitk
        Match(title="Confirmation"),  # tastyworks exit box
        Match(title="Qalculate!"),  # qalculate-gtk
        Match(title="pinentry"),  # GPG key password entry
        Match(title="tastycharts"),  # tastytrade pop-out charts
        Match(title="tastytrade"),  # tastytrade pop-out side gutter
        # tastytrade pop-out allocation
        Match(title="tastytrade - Portfolio Report"),
        # tastytrade settings
        Match(wm_class="tasty.javafx.launcher.LauncherFxApp"),
    ],
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None


@hook.subscribe.startup_once
def start_once():
    home = os.path.expanduser("~")
    autostart_path = os.path.expanduser("~/.config/qtile/autostart.sh")
    qtile.cmd_spawn(autostart_path)

# @hook.subscribe.startup_once

wmname = "LG3D"
