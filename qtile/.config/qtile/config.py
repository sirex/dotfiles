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
import datetime
import subprocess

from libqtile import bar
from libqtile import hook
from libqtile import layout
from libqtile import widget
from libqtile.config import Click
from libqtile.config import Drag
from libqtile.config import DropDown
from libqtile.config import Group
from libqtile.config import Key
from libqtile.config import Match
from libqtile.config import ScratchPad
from libqtile.config import Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal

mod = "mod4"       # Super key
ctrl = "control"
alt = "mod1"
shift = "shift"

terminal = guess_terminal()
launcher = 'rofi -show drun'

mon = 1  # default monitor

keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # https://docs.qtile.org/en/latest/manual/config/keys.html#special-keys

    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([alt], "Tab", lazy.layout.next(), desc="Move window focus to next window"),
    Key([mod, 'shift'], "Tab", lazy.layout.previous(), desc="Move window focus to previous window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, shift], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, shift], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, shift], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, shift], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, ctrl], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, ctrl], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, ctrl], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, ctrl], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),

    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "i", lazy.spawn("firefox"), desc="Launch web browser"),
    Key([mod], "o", lazy.spawn(f"{terminal} -e ranger"), desc="Launch ranger"),
    Key([mod], "n", lazy.spawn(f"{terminal} -e nvim"), desc="Launch nvim"),
    Key([mod], "u", lazy.spawn(f"{terminal} -e htop"), desc="Launch htop"),
    Key([mod], "p", lazy.spawn(f"rofi-pass -m {mon}"), desc="Get password"),
    # Alt+1 autotype
    # Alt+2 type user
    # Alt+3 type pass
    # Alt+4 open url
    # Alt+u copy name
    # Alt+l copy url
    # Alt+p copy pass
    # Alt+o show
    # Alt+h help

    # ScratchPad keys
    Key([mod], "s", lazy.group['scratchpad'].dropdown_toggle('term')),
    Key([mod], "c", lazy.group['scratchpad'].dropdown_toggle('calc')),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.screen.toggle_group(), desc="Toggle between layouts"),
    Key([mod], "grave", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([ctrl, alt], "Delete", lazy.restart(), desc="Restart Qtile"),
    Key([mod, ctrl], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod, ctrl], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "f", lazy.window.toggle_floating(), desc="Toggle floating"),
    Key([mod, shift], 'f', lazy.window.toggle_fullscreen(), desc="Toggle Fullscreen"),
    Key([mod], "space", lazy.spawn(f'rofi -show drun -m {mon}'), desc="Run launcher"),
    Key([mod, ctrl], "space", lazy.spawn(f'rofi -show run -{mon}'), desc="Run launcher"),
    Key([mod], "Page_Down", lazy.screen.next_group(), desc="Next group"),
    Key([mod], "Page_Up", lazy.screen.prev_group(), desc="Previous group"),

    # Volume controls
    Key([], 'XF86AudioRaiseVolume', lazy.spawn('amixer set Master 5%+')),
    Key([], 'XF86AudioLowerVolume', lazy.spawn('amixer set Master 5%-')),
    Key([], 'XF86AudioMute', lazy.spawn('amixer set Master toggle')),

    # Screenshot
    Key([], 'Print', lazy.spawn('gnome-screenshot -i')),

    # System
    Key([mod], "x", lazy.spawn(
        'i3lock --color=000000 --ignore-empty-password --show-failed-attempts'
    ), desc="Lock screen"),
]

groups = [Group(i) for i in "1234567890"]
gscreen = [0, 0, 0, 0, 0, 0, 0, 0, 0, 1]

for s, g in enumerate(groups):
    keys += [
        # Switch to group
        Key(
            [mod],
            g.name,
            lazy.group[g.name].toscreen(gscreen[s]),
            lazy.to_screen(gscreen[s]),
            desc="Switch to group {}".format(g.name),
        ),
        # Move focused window to group
        Key(
            [mod, "shift"],
            g.name,
            lazy.window.togroup(g.name),
            # lazy.group[g.name].toscreen(gscreen[s]),
            # lazy.to_screen(gscreen[s]),
            desc=f"Move focused window to group {g.name}",
        ),
    ]

groups.append(ScratchPad('scratchpad', [
    DropDown('term', terminal),
    DropDown('calc', f'{terminal} -e qalc'),
]))


layouts = [
    layout.Columns(border_focus_stack=["#d75f5f", "#8f3d3d"], border_width=4),
    layout.Max(),
]

widget_defaults = dict(
    font="sans",
    fontsize=16,
    padding=3,
)
extension_defaults = widget_defaults.copy()


class ClockLocale(widget.Clock):
    WEEKDAYS = [
        'pirmadienis',
        'antradienis',
        'trečiadienis',
        'ketvirtadienis',
        'penktadienis',
        'šeštadienis',
        'sekmadienis',
    ]

    def poll(self):
        now = datetime.datetime.now(datetime.timezone.utc)
        if self.timezone:
            now = now.astimezone(self.timezone)
        else:
            now = now.astimezone()
        now = now + self.DELTA
        week_name = self.WEEKDAYS[now.weekday()]
        fmt = self.format.replace('%A', week_name)
        return now.strftime(fmt)


space = 20
bar_size = 32
screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(),
                widget.WindowName(),
                # widget.Chord(
                #     chords_colors={
                #         "launch": ("#ff0000", "#ffffff"),
                #     },
                #     name_transform=lambda name: name.upper(),
                # ),
                widget.Spacer(),
                ClockLocale(format="%A | %Y-%m-%d %H:%M", fontsize=20),
                widget.Spacer(space),
                widget.OpenWeather(location='Vilnius', format='{icon} {temp:.0f}℃'),
                widget.Spacer(space),
                widget.CPUGraph(width=100, border_width=1),
                widget.MemoryGraph(width=100, border_width=1),
                widget.Memory(measure_mem='G', format='{MemUsed:.0f}{mm}'),
                widget.Spacer(),
                widget.Systray(icon_size=bar_size - 5),
            ],
            bar_size,
        ),
    ),
    Screen(),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = False
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"


@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.run([home])
