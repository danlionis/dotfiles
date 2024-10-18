import board
import digitalio
import supervisor

# import neopixel
from kb import KMKKeyboard
from storage import getmount

from kmk.keys import KC
from kmk.modules.capsword import CapsWord
from kmk.modules.combos import Combos
from kmk.modules.holdtap import HoldTap
from kmk.modules.layers import Layers
from kmk.modules.mouse_keys import MouseKeys
from kmk.modules.split import Split, SplitSide
from kmk.modules.sticky_keys import StickyKeys
from kmk.modules.tapdance import TapDance

supervisor.set_next_code_file(filename="code.py", reload_on_error=True)

left = str(getmount("/").label)[-1] == "L"
split_side = SplitSide.LEFT if left else SplitSide.RIGHT

keyboard = KMKKeyboard()

powerled = digitalio.DigitalInOut(board.POWER_LED)
powerled.direction = digitalio.Direction.OUTPUT
powerled.value = True  # true is off in this case

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
    (2, 3): 4,
}
layers = Layers(combo_layers)

holdtap = HoldTap()
holdtap.tap_time = 250

mouse_key = MouseKeys()

capsword = CapsWord()

tapdance = TapDance()
tapdance.tap_time = 150

sticky_keys = StickyKeys(release_after=500)

combos = Combos()

keyboard.modules = [
    split,
    holdtap,
    layers,
    mouse_key,
    combos,
    tapdance,
    capsword,
    sticky_keys,
]

# Cleaner key names
_______ = KC.TRNS
XXXXXXX = KC.NO

# Mod-taps
R_CTL = KC.HT(KC.R, KC.LCTRL, prefer_hold=False)
I_CTL = KC.HT(KC.I, KC.RCTRL, prefer_hold=False)
S_ALT = KC.HT(KC.S, KC.LALT, prefer_hold=False)
E_ALT = KC.HT(KC.E, KC.LALT, prefer_hold=False)


mod_time = 200


def LALT(k):
    return KC.HT(k, KC.LALT, prefer_hold=False, tap_interrupted=True, tap_time=mod_time)


def RALT(k):
    return KC.HT(k, KC.RALT, prefer_hold=False, tap_interrupted=True, tap_time=mod_time)


def RCTL(k):
    return KC.HT(k, KC.RCTL, prefer_hold=False, tap_interrupted=True, tap_time=mod_time)


def LCTL(k):
    return KC.HT(k, KC.LCTL, prefer_hold=False, tap_interrupted=True, tap_time=mod_time)


def RGUI(k):
    return KC.HT(k, KC.RGUI, prefer_hold=False, tap_interrupted=True, tap_time=mod_time)


def LGUI(k):
    return KC.HT(k, KC.LGUI, prefer_hold=False, tap_interrupted=True, tap_time=mod_time)


def KTY(k):
    """
    kitty mod
    """
    return KC.HT(
        k,
        KC.LCTRL(KC.LSHIFT),
        prefer_hold=False,
        tap_interrupted=True,
        tap_time=mod_time,
    )


X_CTL = KC.HT(KC.X, KC.LCTRL, prefer_hold=False, tap_time=mod_time)
C_GUI = KC.HT(KC.C, KC.LGUI, prefer_hold=False, tap_time=mod_time)
DOT_CTL = KC.HT(KC.DOT, KC.RCTRL, prefer_hold=False, tap_time=mod_time)
COM_GUI = KC.HT(KC.COMM, KC.LGUI, prefer_hold=False, tap_time=mod_time)
Z_ALT = KC.HT(KC.Z, KC.LALT, prefer_hold=False, tap_time=mod_time)
SLASH_ALT = KC.HT(KC.SLASH, KC.LALT, prefer_hold=False, tap_time=mod_time)

ESC_TAB = KC.HT(KC.ESC, KC.TAB)  # TAB when held, ESC when tapped

# Layers
SPC_LNAV = KC.LT(1, KC.SPC, tap_time=300, prefer_hold=True, tap_interrupted=False)
ENT_LNUM = KC.LT(2, KC.ENT, tap_time=300, prefer_hold=True)
ESC_LSYM = KC.LT(3, KC.ESC, tap_time=300, prefer_hold=True)

# Misc
KITTY_MOD = KC.LSHIFT(KC.LCTRL)
# SHFT_CW = KC.TD(KC.OS(KC.LSFT), KC.CW)  # SHIFT when held, CapsWord when double tapped
# SHFT_OS = KC.OS(KC.LSFT)
SK_LSFT = KC.SK(KC.LSFT)
# VIM_SAVE = simple_key_sequence((KC.ESC, KC.COLN, KC.W, KC.ENTER))
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
keyboard.keymap = [
    [  # Colemak-DH (0)
        KC.Q,       KC.W,       KC.F,       KC.P,       KC.B,       KC.J,       KC.L,       KC.U,       KC.Y,       KC.SCLN,
        LALT(KC.A), LCTL(KC.R), LGUI(KC.S), KTY(KC.T),  KC.G,       KC.M,       KTY(KC.N),  RGUI(KC.E), RCTL(KC.I), RALT(KC.O),
        KC.Z,       KC.X,       KC.C,       KC.D,       KC.V,       KC.K,       KC.H,       KC.COMM,    KC.DOT,     KC.SLASH,
                                            ESC_LSYM,   SK_LSFT,    SPC_LNAV,   ENT_LNUM,
    ],
    [ # NAV/VIM (1)
        _______,    _______,    DC_MUTE,    DC_DEAF,    _______,    _______,    _______,    CTL_BSPC,   KC.BSPC,     KC.DEL,
        _______,    _______,    _______,    KC.TAB,     _______,    KC.LEFT,    KC.DOWN,    KC.UP,      KC.RIGHT,    _______,
        _______,    _______,    _______,    _______,    KC.CW,      KC.HOME,    KC.PGDOWN,  KC.PGUP,    KC.END,      _______,
                                            _______,    _______,    _______,    _______,
    ],
    [  # NUMBERS (2)
        _______,    KC.N7,      KC.N8,      KC.N9,      KC.PLUS,    _______,    _______,    UML["U"],   UML["S"],   _______,
        UML["A"],   KC.N1,      KC.N2,      KC.N3,      KC.MINS,    _______,    KC.N0,      _______,    _______,    UML["O"],
        KC.ASTR,    KC.N4,      KC.N5,      KC.N6,      KC.EQL,     _______,    _______,    _______,    _______,    _______,
                                            _______,    _______,    _______,    _______,
    ],
    [  # SYMBOLS (3)
        _______,    KC.AMPR,    KC.ASTR,    _______,    KC.TILDE,   KC.GRAVE,   KC.LCBR,    KC.RCBR,    _______,    KC.COLN,
        _______,    KC.EXLM,    KC.AT,      KC.HASH,    KC.UNDS,    KC.QUOTE,   KC.LPRN,    KC.RPRN,    _______,    _______,
        KC.PIPE,    KC.DOLLAR,  KC.PERC,    KC.CIRC,    _______,    KC.DQUO,    KC.LBRC,    KC.RBRC,    _______,    KC.BSLASH,
                                            _______,    _______,    _______,    _______,
    ],
    [  # FN (4)
        _______,    KC.F7,      KC.F8,      KC.F9,      KC.F10,     _______,    KC.TG(6),   KC.TG(5),   KC.TG(8),   KC.RESET,
        _______,    KC.F1,      KC.F2,      KC.F3,      KC.F11,     KC.MS_LT,   KC.MS_DN,   KC.MS_UP,   KC.MS_RT,   _______,
        _______,    KC.F4,      KC.F5,      KC.F6,      KC.F12,     _______,    KC.MB_LMB,  KC.MB_RMB,  _______,    _______,
                                            _______,    _______,    _______,    _______,
    ],
    [  # QWERTY (5)
        KC.Q,       KC.W,       KC.E,       KC.R,       KC.T,       KC.Y,       KC.U,       KC.I,       KC.O,       KC.P,
        KC.A,       KC.S,       KC.D,       KC.F,       KC.G,       KC.H,       KC.J,       KC.K,       KC.L,       KC.SCLN,
        Z_ALT,      X_CTL,      C_GUI,      KC.V,       KC.B,       KC.N,       KC.M,       COM_GUI,    DOT_CTL,    SLASH_ALT,
                                            ESC_LSYM,   KC.LSFT,    SPC_LNAV,   ENT_LNUM,
    ],
    [  # GAMING (6) 
        KC.TAB,     KC.Q,       KC.W,       KC.E,       KC.R,       KC.Y,       KC.U,       KC.I,       KC.O,       KC.P,
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
    [  # GRAPHITE (8)
        KC.B,       KC.L,       KC.D,       KC.W,       KC.Z,       KC.MINS,    KC.F,       KC.O,       KC.U,       KC.J,
        LALT(KC.N), LCTL(KC.R), LGUI(KC.T), KC.S,       KC.G,       KC.Y,       KC.H,       RGUI(KC.A), RCTL(KC.E), RALT(KC.I),
        KC.Q,       KC.X,       KC.M,       KC.C,       KC.V,       KC.K,       KC.P,       KC.COMM,    KC.DOT,    KC.SLASH,
                                            ESC_LSYM,   KC.LSFT,    SPC_LNAV,   ENT_LNUM,
    ],
]
# fmt: on


if __name__ == "__main__":
    keyboard.go()
