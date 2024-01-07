import board
import digitalio

# import neopixel

from kb import KMKKeyboard
from storage import getmount
from kmk.keys import KC
from kmk.modules.capsword import CapsWord
from kmk.modules.oneshot import OneShot
from kmk.modules.holdtap import HoldTap
from kmk.modules.layers import Layers
from kmk.modules.mouse_keys import MouseKeys
from kmk.modules.split import Split, SplitSide
from kmk.modules.tapdance import TapDance
from kmk.handlers.sequences import simple_key_sequence


left = str(getmount("/").label)[-1] == "L"
split_side = SplitSide.LEFT if left else SplitSide.RIGHT

keyboard = KMKKeyboard()


split = Split(
    # split_flip=True,
    data_pin=board.D1,
    split_side=split_side,
    split_target_left=True,
    # Using the default wasn't working, try pio
    use_pio=True,
    uart_flip=True,
)

combo_layers = {
    (1, 3): 4,
    (2, 3): 4,
}
layers = Layers(combo_layers)

holdtap = HoldTap()
holdtap.tap_time = 300

mouse_key = MouseKeys()
capsword = CapsWord()

tapdance = TapDance()
tapdance.tap_time = 150

oneshot = OneShot()

keyboard.modules = [
    split,
    holdtap,
    oneshot,
    layers,
    mouse_key,
    tapdance,
    capsword,
]

# Cleaner key names
_______ = KC.TRNS
XXXXXXX = KC.NO

# Mod-taps
R_CTL = KC.HT(KC.R, KC.LCTRL, prefer_hold=False)
I_CTL = KC.HT(KC.I, KC.RCTRL, prefer_hold=False)
S_ALT = KC.HT(KC.S, KC.LALT, prefer_hold=False)
E_ALT = KC.HT(KC.E, KC.LALT, prefer_hold=False)

X_CTL = KC.HT(KC.X, KC.LCTRL, prefer_hold=False, tap_time=200)
C_GUI = KC.HT(KC.C, KC.LGUI, prefer_hold=False, tap_time=200)
DOT_CTL = KC.HT(KC.DOT, KC.RCTRL, prefer_hold=False, tap_time=200)
COM_GUI = KC.HT(KC.COMM, KC.LGUI, prefer_hold=False, tap_time=200)
Z_ALT = KC.HT(KC.Z, KC.LALT, prefer_hold=False, tap_time=200)
SLASH_ALT = KC.HT(KC.SLASH, KC.LALT, prefer_hold=False, tap_time=200)

ESC_TAB = KC.HT(KC.ESC, KC.TAB)  # TAB when held, ESC when tapped

# Layers
SPC_LNAV = KC.LT(1, KC.SPC, tap_time=180, prefer_hold=True, tap_interrupted=False)
ENT_LNUM = KC.LT(2, KC.ENT, tap_time=160, prefer_hold=True)
ESC_LSYM = KC.LT(3, KC.ESC, tap_time=160, prefer_hold=True)

# Misc
KITTY_MOD = KC.LSHIFT(KC.LCTRL)
# SHFT_CW = KC.TD(KC.OS(KC.LSFT), KC.CW)  # SHIFT when held, CapsWord when double tapped
SHFT_OS = KC.OS(KC.LSFT)
VIM_SAVE = simple_key_sequence((KC.ESC, KC.COLN, KC.W, KC.ENTER))
DC_MUTE = KC.LALT(KC.LCTL(KC.LSFT(KC.M)))
DC_DEAF = KC.LALT(KC.LCTL(KC.LSFT(KC.D)))
LOCK = KC.LGUI(KC.ESC)
CTRL_W = KC.LCTRL(KC.W)
GUI_SPC = KC.RGUI(KC.SPACE)
CTL_BSPC = KC.LCTL(KC.BSPC)

# Umlaute
UML = {
    "A": KC.RALT(KC.A),
    "O": KC.RALT(KC.O),
    "U": KC.RALT(KC.U),
    "S": KC.RALT(KC.S),
}

# fmt: off
# flake8: noqa
keyboard.keymap = [
    [  # Colemak-DH (0)
        KC.Q,       KC.W,       KC.F,       KC.P,       KC.B,       KC.J,       KC.L,       KC.U,       KC.Y,       KC.SCLN,
        KC.A,       KC.R,       KC.S,       KC.T,       KC.G,       KC.M,       KC.N,        KC.E,       KC.I,      KC.O,
        # KC.A,       R_CTL,      S_ALT,      KC.T,       KC.G,       KC.M,       KC.N,       E_ALT,      I_CTL,      KC.O,
        Z_ALT,      X_CTL,      C_GUI,      KC.D,       KC.V,       KC.K,       KC.H,       COM_GUI,    DOT_CTL,    SLASH_ALT,
        # KC.Z,       KC.X,      KC.C,       KC.D,       KC.V,       KC.K,       KC.H,       KC.COMM,    KC.DOT,    KC.SLASH,
                                            ESC_LSYM,   SHFT_OS,    SPC_LNAV,   ENT_LNUM,
    ],
    [ # NAV/VIM (1)
        VIM_SAVE,   DC_MUTE,    DC_DEAF,    _______,    LOCK,       _______,    _______,    CTL_BSPC,   KC.BSPC,     _______,
        _______,    _______,    _______,    KC.TAB,     GUI_SPC,    KC.LEFT,    KC.DOWN,    KC.UP,      KC.RIGHT,    _______,
        _______,    KC.LCTRL,   KC.LGUI,    KITTY_MOD,  _______,    _______,    _______,    KC.LGUI,    KC.LCTRL,    KC.LALT,
                                            _______,    _______,    _______,    _______,
    ],
    # [  # NUMBERS/UMLAUT (2)
    #     _______,    _______,    _______,    _______,    _______,    _______,    _______,    _______,    _______,    _______,
    #     KC.N1,      KC.N2,      KC.N3,      KC.N4,      KC.N5,      KC.N6,      KC.N7,      KC.N8,      KC.N9,      KC.N0,
    #     _______,    _______,    KC.MINUS,   KC.PLUS,    _______,    UML["A"],   UML["O"],   UML["U"],   UML["S"],   _______,
    #                                         _______,    _______,    _______,    _______,
    # ],
    [  # NUMBERS (2)
        KC.SLSH,    KC.N7,      KC.N8,      KC.N9,      KC.PLUS,    _______,    _______,    _______,    _______,    _______,
        KC.N0,      KC.N1,      KC.N2,      KC.N3,      KC.MINS,    _______,    UML["U"],   UML["A"],   UML["O"],   UML["S"],
        KC.ASTR,    KC.N4,      KC.N5,      KC.N6,      KC.EQL,     _______,    _______,    _______,    _______,    _______,
                                            _______,    _______,    _______,    _______,
    ],
    [  # SYMBOLS (3)
        _______,    _______,    _______,    KC.GRAVE,   KC.TILDE,   KC.UNDS,    KC.LCBR,    KC.RCBR,    _______,    KC.DEL,
        _______,    KC.PERC,    KC.SLSH,    KC.QUOTE,   _______,    KC.BSLASH,  KC.LPRN,    KC.RPRN,    _______,    KC.SCLN,
        KC.PIPE,    _______,    KC.PERC,    KC.DQUO,    _______,    _______,    KC.LBRC,    KC.RBRC,    _______,    _______,
                                            _______,    _______,    _______,    _______,
    ],
    [  # FN (4)
        _______,    KC.F7,      KC.F8,      KC.F9,      KC.F10,     _______,    KC.TG(6),   _______,    _______,    _______,
        _______,    KC.F1,      KC.F2,      KC.F3,      KC.F11,     _______,    _______,    _______,    _______,    _______,
        _______,    KC.F4,      KC.F5,      KC.F6,      KC.F12,     _______,    _______,    _______,    _______,    _______,
                                            _______,    _______,    _______,    _______,
    ],
    [  # QWERTY (5)
        KC.Q,       KC.W,       KC.E,       KC.R,       KC.T,       KC.Y,       KC.U,       KC.I,       KC.O,       KC.P,
        KC.A,       KC.S,       KC.D,       KC.F,       KC.G,       KC.H,       KC.J,       KC.K,       KC.L,       KC.SCLN,
        KC.Z,       KC.X,       KC.C,       KC.V,       KC.B,       KC.N,       KC.M,        KC.COMM,    KC.DOT,    KC.SLSH,
                                            KC.BSPC,    SPC_LNAV,   SPC_LNAV,   KC.ENT,
    ],
    [  # GAMING (6) 
        ESC_TAB,    KC.Q,       KC.W,       KC.E,       KC.R,       KC.Y,       KC.U,       KC.I,       KC.O,       KC.P,
        KC.LSHIFT,  KC.A,       KC.S,       KC.D,       KC.F,       KC.H,       KC.J,       KC.K,       KC.L,       KC.SCLN,
        KC.LCTRL,   KC.Z,       KC.X,       KC.C,       KC.V,       KC.N,       KC.M,       KC.COMM,    KC.DOT,    KC.SLSH,
                                            ESC_LSYM,   KC.SPACE,   SPC_LNAV,   KC.ENT,
    ], 
    [  # SPEEDTYPING (7)
        KC.Q,       KC.W,       KC.F,       KC.P,       KC.B,       KC.J,       KC.L,       KC.U,       KC.Y,       KC.SCLN,
        KC.A,       KC.R,       KC.S,       KC.T,       KC.G,       KC.M,       KC.N,        KC.E,       KC.I,      KC.O,
        Z_ALT,      X_CTL,      KC.C,       KC.D,       KC.V,       KC.K,       KC.H,       KC.COMM,    KC.DOT,    KC.SLASH,
                                            # KC.HT(KC.TAB, KC.TG(7)),   SHFT_CW,    KC.SPACE,   ENT_LNUM,
                                            _______,    _______,    _______,    _______,
    ],
]


if __name__ == "__main__":
    keyboard.go()
