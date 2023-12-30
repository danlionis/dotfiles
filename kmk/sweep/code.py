import board
import digitalio
import neopixel

from kb import KMKKeyboard
from storage import getmount
from kmk.keys import KC, make_key
from kmk.extensions.lock_status import LockStatus
from kmk.extensions.rgb import RGB
from kmk.modules.capsword import CapsWord
from kmk.modules.combos import Chord, Combos
from kmk.modules.oneshot import OneShot
from kmk.modules.holdtap import HoldTap
from kmk.modules.layers import Layers
from kmk.modules.mouse_keys import MouseKeys
from kmk.modules.split import Split, SplitSide
from kmk.modules.tapdance import TapDance
from kmk.handlers.sequences import send_string, simple_key_sequence


left = str(getmount("/").label)[-1] == "L"
split_side = SplitSide.LEFT if left else SplitSide.RIGHT

powerled = digitalio.DigitalInOut(board.POWER_LED)
powerled.direction = digitalio.Direction.OUTPUT
powerled.value = True  # true is off in this case

led = neopixel.NeoPixel(board.NEOPIXEL, 1, brightness=0.05, auto_write=False)
if left:
    # led.fill((255, 238, 88))
    led.fill((255, 0, 128))
    led.show()

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

layers = Layers()

holdtap = HoldTap()
holdtap.tap_time = 300

mouse_key = MouseKeys()
capsword = CapsWord()

tapdance = TapDance()
tapdance.tap_time = 150

oneshot = OneShot()

keyboard.modules = [
    split,
    oneshot,
    capsword,
    holdtap,
    layers,
    mouse_key,
    tapdance,
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
DOT_CTL = KC.HT(KC.DOT, KC.RCTRL, prefer_hold=False, tap_time=200)
Z_ALT = KC.HT(KC.Z, KC.LALT, prefer_hold=False, tap_time=200)
SLASH_ALT = KC.HT(KC.SLASH, KC.LALT, prefer_hold=False, tap_time=200)

ESC_TAB = KC.HT(KC.ESC, KC.TAB)  # TAB when held, ESC when tapped

# Layers
SPC_LNAV = KC.LT(1, KC.SPC, tap_time=180, prefer_hold=False)
ENT_LNUM = KC.LT(2, KC.ENT, tap_time=150, prefer_hold=True)
GUI_LSYM = KC.LT(3, KC.ENT, tap_time=150, prefer_hold=True)

# Misc
KITTY_MOD = KC.LSHIFT(KC.LCTRL)
# SHFT_CW = KC.TD(KC.OS(KC.LSFT), KC.CW)  # SHIFT when held, CapsWord when double tapped
SHFT_CW = KC.OS(KC.LSFT)
VIM_SAVE = simple_key_sequence((KC.COLN, KC.W, KC.ENTER))
LOCK = KC.LGUI(KC.ESC)
CTRL_W = KC.LCTRL(KC.W)

# Umlaute
UML = {
    "A": KC.RALT(KC.A),
    "O": KC.RALT(KC.O),
    "U": KC.RALT(KC.U),
    "S": KC.RALT(KC.S),
}


# fmt: off
template = [ # template 
    _______,    _______,    _______,    _______,    _______,    _______,    _______,    _______,    _______,    _______,
    _______,    _______,    _______,    _______,    _______,    _______,    _______,    _______,    _______,    _______,
    _______,    _______,    _______,    _______,    _______,    _______,    _______,    _______,    _______,    _______,
                                        _______,    _______,    _______,    _______,
],


# fmt: off
# flake8: noqa
keyboard.keymap = [
    [  # Colemak-DH (0)
        KC.Q,       KC.W,       KC.F,       KC.P,       KC.B,       KC.J,       KC.L,       KC.U,       KC.Y,       KC.SCLN,
        KC.A,       KC.R,       KC.S,       KC.T,       KC.G,       KC.M,       KC.N,        KC.E,       KC.I,      KC.O,
        # KC.A,       R_CTL,      S_ALT,      KC.T,       KC.G,       KC.M,       KC.N,       E_ALT,      I_CTL,      KC.O,
        Z_ALT,      X_CTL,      KC.C,       KC.D,       KC.V,       KC.K,       KC.H,       KC.COMM,    DOT_CTL,    SLASH_ALT,
                                            GUI_LSYM,   SHFT_CW,    SPC_LNAV,   ENT_LNUM,
    ],
    [ # NAV/VIM (1)
        VIM_SAVE,   _______,    _______,    _______,    LOCK,       _______,    _______,    _______,    _______,    KC.BSPC,
        KC.ESC,     KC.LCTL,    _______,    KC.TAB,     _______,    KC.LEFT,    KC.DOWN,    KC.UP,      KC.RIGHT,   KC.ENTER,
        _______,    _______,    _______,    KITTY_MOD,  _______,    _______,    _______,    _______,    _______,    _______,
                                            _______,    _______,    _______,    _______,
    ],
    [  # NUMBERS/UMLAUT (2)
        _______,    _______,    _______,    _______,    _______,    _______,    _______,    _______,    _______,    _______,
        KC.N1,      KC.N2,      KC.N3,      KC.N4,      KC.N5,      KC.N6,      KC.N7,      KC.N8,      KC.N9,      KC.N0,
        _______,    _______,    KC.MINUS,   KC.PLUS,    _______,    UML["A"],   UML["O"],   UML["U"],   UML["S"],   _______,
                                            _______,    _______,    _______,    _______,
    ],
    [  # SYMBOLS (3)
        _______,    _______,    _______,    KC.ESC,     KC.TILDE,   KC.UNDS,    KC.LPRN,    KC.LCBR,    KC.LBRC,    KC.DEL,
        _______,    KC.PERC,    KC.SLSH,    KC.ENT,     _______,    KC.EQUAL,   KC.RPRN,    KC.RCBR,    KC.RBRC,    KC.SCLN,
        _______,    _______,    _______,    KC.PERC,    _______,    UML["A"],   UML["O"],   UML["U"],   UML["S"],   KC.RESET,
                                            _______,    _______,    _______,    _______,
    ],
    [  # FN (4)
        _______,    _______,    _______,    _______,    _______,    _______,    _______,    _______,    _______,    _______,
        KC.F1,      KC.F2,      KC.F3,      KC.F4,      KC.F5,      KC.F6,      KC.F7,      KC.F8,      KC.F9,      KC.F10,
        _______,    _______,    _______,    _______,    _______,    _______,    _______,    _______,    _______,
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
                                            KC.BSPC,    KC.SPACE,   SPC_LNAV,   KC.ENT,
    ],
]


# fmt: on
combos = Combos()
keyboard.modules.append(combos)

combos.combos = [
    Chord((17, 18), KC.BSPC, timeout=50, match_coord=True),
    Chord((KC.Z, KC.X), KC.TG(6), timeout=100),
]

if __name__ == "__main__":
    keyboard.go()
