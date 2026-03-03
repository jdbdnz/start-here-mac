#!/bin/bash
set -e

echo "Configuring Rectangle..."

RECT_PLIST="$HOME/Library/Preferences/com.knollsoft.Rectangle.plist"

defaults write com.knollsoft.Rectangle launchOnLogin -bool true
defaults write com.knollsoft.Rectangle subsequentExecutionMode -int 1

set_rect_shortcut() {
    local action=$1 key_code=$2 modifier_flags=$3
    /usr/libexec/PlistBuddy -c "Delete :${action}" "$RECT_PLIST" 2>/dev/null || true
    /usr/libexec/PlistBuddy -c "Add :${action} dict" "$RECT_PLIST"
    /usr/libexec/PlistBuddy -c "Add :${action}:keyCode integer ${key_code}" "$RECT_PLIST"
    /usr/libexec/PlistBuddy -c "Add :${action}:modifierFlags integer ${modifier_flags}" "$RECT_PLIST"
}

# Modifier flags
ALT_CMD=1572864         # option + command
CTRL_CMD=1310720        # control + command
CTRL_SHIFT_CMD=1441792  # control + shift + command
CTRL_ALT_CMD=1835008    # control + option + command
CTRL_ALT=786432         # control + option
CTRL_ALT_SHIFT=917504   # control + option + shift
ALT_SHIFT_CMD=1703936   # option + shift + command

# Halves: alt-cmd-arrow
set_rect_shortcut leftHalf          123 $ALT_CMD
set_rect_shortcut rightHalf         124 $ALT_CMD
set_rect_shortcut topHalf           126 $ALT_CMD
set_rect_shortcut bottomHalf        125 $ALT_CMD

# Fullscreen + center: alt-cmd-f / alt-cmd-c
set_rect_shortcut maximize          3   $ALT_CMD
set_rect_shortcut center            8   $ALT_CMD

# Corners: ctrl-cmd-arrow (upper), ctrl-shift-cmd-arrow (lower)
set_rect_shortcut topLeft           123 $CTRL_CMD
set_rect_shortcut topRight          124 $CTRL_CMD
set_rect_shortcut bottomLeft        123 $CTRL_SHIFT_CMD
set_rect_shortcut bottomRight       124 $CTRL_SHIFT_CMD

# Displays: ctrl-alt-cmd-arrow
set_rect_shortcut nextDisplay       124 $CTRL_ALT_CMD
set_rect_shortcut previousDisplay   123 $CTRL_ALT_CMD

# Thirds: ctrl-alt-arrow
set_rect_shortcut moveToNextThird      124 $CTRL_ALT
set_rect_shortcut moveToPreviousThird  123 $CTRL_ALT

# Resize: ctrl-alt-shift-arrow
set_rect_shortcut larger            124 $CTRL_ALT_SHIFT
set_rect_shortcut smaller           123 $CTRL_ALT_SHIFT

# Undo/redo: alt-cmd-z / alt-shift-cmd-z
set_rect_shortcut undoLastMove      6   $ALT_CMD
set_rect_shortcut redoLastMove      6   $ALT_SHIFT_CMD
