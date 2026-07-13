# Issues

> Status legend: ✅ Confirmed · ⚠️ Partially confirmed

## Outlook

### No RTL/LTR Toggle Shortcut → System shortcut bypassed by web renderer ✅

The new Outlook for Mac (2022+) is built on a web-stack renderer (WebKit/OWA)
rather than native AppKit/NSTextView, so the macOS system shortcut
Ctrl+Cmd+←/→ for paragraph direction is never received by the text engine.
The old Classic Outlook had no RTL/LTR toggle at all. Unlike Outlook for
Windows (Ctrl+Shift), no keyboard shortcut for explicit direction switching
exists on the Mac version. Auto-BiDi detection is available — typing a
Hebrew/Arabic character will auto-shift alignment — but it cannot be
force-toggled. The Format → Paragraph direction menu entry works as a
mouse-only fallback.

References:
- https://support.apple.com/en-us/102650 — macOS keyboard shortcuts; confirms
  Ctrl+Cmd+←/→ is the Cocoa NSTextView paragraph direction shortcut
- https://support.microsoft.com/en-US/accessibility/word/keyboard-shortcuts-in-word
  — Microsoft keyboard shortcut reference; RTL/LTR toggle absent from Mac list

### Paste Options Control → Accessible only via mouse click on a small icon ✅

After pasting into an Outlook for Mac message, a small paste control icon
appears at the bottom of the pasted text. Clicking it reveals paste options
(Keep Source Formatting, Match Destination Formatting). On Mac this is
exclusively a mouse/trackpad interaction — the icon must be clicked. The
icon is easy to miss as it appears directly adjacent to or just below the
pasted content and disappears on the next keystroke. Unlike Outlook for
Windows, which uses Word as its email editor and inherits the Ctrl-after-paste
keyboard shortcut to open the paste options menu via keyboard, no equivalent
keyboard shortcut exists in Outlook for Mac. The Outlook for Mac keyboard
shortcuts reference lists no shortcuts in its "Edit and format text" section.

References:
- https://support.microsoft.com/en-US/accessibility/outlook/mac/keyboard-shortcuts-in-outlook-for-mac
  — Outlook for Mac keyboard shortcuts; "Edit and format text" section is
  empty, confirming no paste options keyboard shortcut exists on Mac
- https://support.microsoft.com/en-US/accessibility/outlook/keyboard-shortcuts-for-outlook
  — Outlook for Windows keyboard shortcuts; signals that Mac has a separate,
  different keyboard shortcut set

### Context-Based RTL/LTR Detection → Behaves randomly (unconfirmed)

The auto-BiDi engine in the new Outlook for Mac, which infers paragraph
direction from the first strongly-typed character, is reported to behave
inconsistently. This may interact with the lack of an explicit toggle
shortcut (see above), as there is no way to override incorrect auto-detection.
Status unconfirmed; the behaviour likely varies by Outlook build version.

### ESC in Full Screen → Closes window instead of only exiting full screen ✅

Outlook intercepts the ESC key internally to dismiss dialogs and compose
windows before macOS can process it as a full-screen exit event. The result
is that pressing ESC while Outlook is in full screen both exits full screen
and closes the active window simultaneously. Standard macOS behavior would
leave the window open. The correct alternative is Ctrl+Cmd+F or clicking the
green ⬤ button to toggle full screen without closing the window.

References:
- https://support.apple.com/en-us/102650 — confirms Ctrl+Cmd+F as the macOS
  full-screen toggle shortcut

### New Window in Full Screen → Window cannot be moved ✅

When Outlook is in full screen and a message is opened in a new window, the
subsidiary window is rendered inside the full-screen Space without a proper
movable title bar region. This is a combination of Outlook not setting
correct NSWindow style flags and the macOS constraint that secondary windows
in a full-screen Space must be correctly configured to be draggable. Exiting
full screen before opening messages in new windows avoids the problem.

References:
- https://developer.apple.com/documentation/appkit/nswindow — NSWindow
  documentation; correct style masks required for movable secondary windows

## Word

### Home/End Keys → Navigate to document boundaries instead of line boundaries ✅

Word for Mac maps Home and End to the beginning and end of the document
respectively, adopting the macOS convention, while Word for Windows maps
them to the beginning and end of the current line. This discrepancy has
persisted across all Word for Mac versions (2011 through Microsoft 365/2026).
The macOS DefaultKeyBinding.dict mechanism does not help because Word bypasses
the Cocoa text system entirely using its own internal keyboard event table.
Outlook for Mac "gets it right" only because the new Outlook was rebuilt on
web/WebKit technologies, where browser-standard keyboard handling maps Home/End
to line boundaries. Three workarounds exist: (1) native Mac equivalents
⌘← / ⌘→ for line start/end and ⌘⇧← / ⌘⇧→ to select to line boundaries;
(2) Karabiner-Elements remapping Home→⌘← and End→⌘→ at the HID driver
level specifically for com.microsoft.Word; (3) Word's built-in macro approach
via Tools → Customize Keyboard, assigning Selection.HomeKey Unit:=wdLine and
Selection.EndKey Unit:=wdLine to the Home and End keys, saved to Normal.dotm.

References:
- https://support.microsoft.com/en-US/accessibility/word/keyboard-shortcuts-in-word
  — Word for Windows: Home = "beginning of current line"; absent from Mac version
- https://damieng.com/blog/2015/make-home-end-keys-behave-like-windows-on-mac-os-x/
  — confirms Mac default: Home goes to top of document, not line
- https://apple.stackexchange.com/questions/16135/remap-home-and-end-to-beginning-and-end-of-line
  — confirms DefaultKeyBinding.dict is ignored by cross-platform apps including Word
- https://karabiner-elements.pqrs.org — HID-level key remapper; most reliable fix

## Tasks

### Cmd-` Window Cycling → Fixed order, not LRU; no way to change ✅

macOS cycles application windows with Cmd-` in a fixed creation/stacking order
matching the Window menu. There is no built-in mechanism for LRU (most
recently used) ordering at the within-app window level, unlike Alt+Tab on
Windows. Cmd-Shift-` cycles in reverse. No preference pane or developer API
exists to configure LRU ordering. Third-party utilities such as Contexts
(contexts.co) or Witch (manytricks.com/witch) provide LRU-style per-window
switching via custom key bindings.

References:
- https://support.apple.com/en-us/102650 — confirms Cmd-` as window cycle
  shortcut; no LRU variant documented

### Cmd-Tab Scope → Cycles all Spaces, not current Space only ✅

macOS Cmd-Tab cycles through all running applications across all Spaces and
full-screen Spaces. There is no built-in option to restrict the switcher to
the current Space. This makes it impossible to use Cmd-Tab as a within-Space
workflow tool when apps are spread across multiple Spaces. Cmd-` cycles
windows of the same application only. Third-party utilities Contexts
(contexts.co) and Witch (manytricks.com/witch) replace Cmd-Tab with a
Space-aware switcher that lists only apps and windows present on the current
Space.

References:
- https://support.apple.com/en-us/102650 — macOS keyboard shortcuts reference;
  Cmd-Tab documented as global app switcher with no per-Space scope option
- https://contexts.co — Space-aware per-window switcher
- https://manytricks.com/witch — Space-aware per-window switcher

### Desktop vs. Full Screen Window Targeting → App appears once in Cmd-Tab ✅

macOS Cmd-Tab shows one entry per application regardless of how many windows
that application has across different Spaces or full-screen Spaces. Switching
to an application via Cmd-Tab brings whichever window was last active, with
no way to target a specific Space's window directly. Mission Control (Ctrl+↑
or three-finger swipe) or the application's own Window menu are the only
native ways to reach a specific window. Third-party utilities such as Contexts
provide per-window Cmd-Tab entries that distinguish between Spaces.

References:
- https://support.apple.com/guide/mac-help/work-in-multiple-spaces-mh14112/mac
  — Apple Spaces guide; confirms one Cmd-Tab slot per app

## Stage Manager

### Safari Window Assignment → Cannot assign to a stage without another app ⚠️

Stage Manager treats all windows of a single application as belonging to one
stage entity. Dragging a Safari window onto a stage that contains only a
strip thumbnail (with no other app) is unreliable because Safari's multi-window
nature conflicts with Stage Manager's per-app grouping model. The behaviour is
partially improved since macOS Sonoma (14) but full per-window cross-stage
assignment remains unavailable. Ensuring the target stage already contains at
least one other application before dragging Safari to it improves reliability.

References:
- https://support.apple.com/guide/mac-help/use-stage-manager-mchl534ba392/mac
  — official Stage Manager guide; describes grouping by dragging apps

### Recent Apps Strip → Only 5 recent groups shown; no scroll to reveal more ✅

Stage Manager displays at most approximately 5 recent app groups in the left
strip. Groups that have not been used recently are silently hidden with no
visual indicator. Despite what intuition suggests, the strip is not scrollable
— neither mouse wheel nor trackpad scroll gestures have any effect on it. This
is a by-design limitation: Apple's official documentation describes the strip
as showing "recently used apps" only, and mentions no mechanism to view or
scroll through all open groups. To access apps not visible in the strip, use
the Dock, Mission Control (F3 / Ctrl+↑), or Cmd+Tab. If a group becomes
inaccessible via the strip, Mission Control is the only reliable way to reach
it without quitting and relaunching apps.

References:
- https://support.apple.com/guide/mac-help/use-stage-manager-mchl534ba392/mac
  — official Stage Manager guide; describes strip as "recently used apps" with
  no scroll or "show all" mechanism documented

### Keyboard Navigation → No keyboard shortcuts exist for any Stage Manager action ✅

Apple's Stage Manager documentation and the macOS keyboard shortcuts reference
list zero keyboard shortcuts for Stage Manager — no shortcut to switch between
stages, activate the strip, group apps, or ungroup apps. Unlike Spaces (which
has Ctrl+number and Ctrl+←/→), Stage Manager is entirely pointer-driven. This
gap has persisted from macOS Ventura (13) through Tahoe (26). Mission Control
(Ctrl+↑) is the closest native alternative. Keyboard Maestro or BetterTouchTool
can automate clicking the strip at fixed screen coordinates as a fragile
workaround.

References:
- https://support.apple.com/guide/mac-help/use-stage-manager-mchl534ba392/mac
  — Stage Manager guide; lists only mouse actions, no keyboard shortcuts
- https://support.apple.com/en-us/102650 — macOS keyboard shortcuts reference;
  zero Stage Manager entries

### Session Persistence → Stages are not restored after logout ✅

Stage Manager stores stage groupings only in memory. Logout, restart, or
shutdown discards all group topology. The macOS "Reopen windows when logging
back in" feature restores which apps and windows are open but does not
reconstruct Stage Manager groups. Stages must be manually rebuilt after every
login. No native workaround exists; this limitation has been present since
Stage Manager launched in macOS Ventura (13) and remains unaddressed in
Tahoe (26).

References:
- https://support.apple.com/guide/mac-help/use-stage-manager-mchl534ba392/mac
  — no persistence mechanism mentioned in the official guide

### Drag and Drop → Staged applications do not accept drops ✅

Only the center-stage (currently active) application participates in
drag-and-drop. Applications shown in the left-side strip are rendered as
static thumbnails and do not act as live drop targets. Dragging content from
any application toward a strip thumbnail results in a rejected drop. To
transfer content, both the source and destination must be in the same stage
group (placed together in the center stage), or copy-paste must be used instead.

References:
- https://support.apple.com/guide/mac-help/use-stage-manager-mchl534ba392/mac
  — confirms strip items are for switching only; no drag-to-strip described

## Mission Control

### Window Management → No close or reorder of windows in Mission Control view ✅

Mission Control (Ctrl+↑ or three-finger swipe up) shows all open windows as a
birds-eye layout. Two window management actions that might be expected are
absent: (1) windows cannot be closed from within Mission Control — no × button
appears on window thumbnails and no keyboard shortcut closes a hovered window;
clicking a window instead exits Mission Control and brings that window to the
front, so the only way to close a window is to exit Mission Control, close it,
then re-enter; (2) windows cannot be reordered or repositioned within the
current Space's layout — the only supported drag action is moving a window to a
different Space or full-screen app thumbnail in the Spaces bar at the top.
Both limitations have been present since Mission Control replaced Exposé in
OS X Lion (10.7, 2011); Exposé on Snow Leopard (10.6) did show hover-to-reveal
× buttons on window thumbnails, a capability that was not carried over.

References:
- https://support.apple.com/guide/mac-help/view-open-windows-spaces-mission-control-mh35798/mac
  — Apple's complete Mission Control documentation; full action set listed with
  no mention of closing or reordering windows on the current Space
- https://support.apple.com/en-us/102650 — macOS keyboard shortcuts reference;
  Mission Control shortcuts listed with no close-window shortcut
- https://apple.stackexchange.com/questions/402568/is-it-possible-to-close-windows-from-app-expos%c3%a9
  — community confirmation that no close action exists in App Exposé/Mission
  Control; describes the exit-close-reenter workaround

## Keyboard

### Israeli Layout → SI-1452 layout installed but key mapping incorrect for some keys ⚠️

The macOS built-in Hebrew input sources (Hebrew, Hebrew QWERTY, Hebrew-PC) map
punctuation characters but do not correspond to the physical key positions of
the Israeli Standard SI-1452 keyboard. An open-source implementation of the
SI-1452-2 (2017) physical layout by Erez Volk installs correctly via its DMG
installer and can coexist with existing Hebrew input sources. However, the
mapping is incorrect for some letters and symbols. Attempts to fix the mapping
using AI assistance failed to produce a correct result for both Unicode and
non-Unicode applications.

References:
- https://github.com/ErezVolk/mac-hebrew-si-1452-2 — Mac Hebrew SI 1452-2
  keyboard layout; DMG installer and installation instructions

## Safari

### External Link Target → No control over which window receives external links ✅

When a link is opened from an external application (Mail, Slack, etc.), Safari
uses internal heuristics to select a target window and exposes no user-facing
preference to control this behaviour. The Settings → Tabs → "Open pages in
tabs instead of windows" option controls the window-vs-tab decision globally
but does not determine which window or Tab Group receives the link. The
behaviour can be unpredictable when multiple Safari windows or Tab Groups are
open. Three workarounds exist: (1) safari-redirect (github.com/alonbl/safari-redirect)
registers itself as the default browser, intercepts the URL Apple Event, and
uses AppleScript (`make new document`) to always open the link in a new Safari
window on the current desktop — lightweight, open-source, no rules needed;
(2) Velja (sindresorhus.com/velja, requires macOS 26+) and (3) the open-source
Browserosaurus intercept external link events and can route them to a specific
browser window or profile.

References:
- https://support.apple.com/guide/safari/safari-settings-overview-sfri10642/mac
  — Safari settings reference; no per-source link routing option documented
- https://github.com/alonbl/safari-redirect — proxy default browser; always
  opens external links in a new Safari window on the current desktop
- https://sindresorhus.com/velja — Velja URL router; rules-based link routing

### Tab Overview → No drag-to-reorder or swipe-to-close ✅

Safari's tab overview (Shift-Cmd-\ or pinch-to-zoom out on a trackpad) shows
all open tabs as a grid of cards. Two interactions that exist elsewhere are
absent here: (1) tabs cannot be reordered by dragging within the overview grid
— drag-to-reorder only works in the normal tab bar; (2) there is no
swipe-left/right gesture to close a tab card, unlike Safari on iPhone/iPad
where swiping a tab card in the tab overview dismisses it. On Mac the only way
to close a tab from the overview is to click its × button. Apple's official
"Keyboard shortcuts and gestures" reference for Safari on Mac lists the
complete set of tab gestures and does not include either of these interactions
for the tab overview.

References:
- https://support.apple.com/guide/safari/keyboard-shortcuts-and-gestures-cpsh003/mac
  — Safari for Mac keyboard shortcuts and gestures reference; full tab action
  set listed (Shift-Cmd-\ to show tab overview); no drag-to-reorder or
  swipe-to-close gesture documented for the tab overview
- https://osxdaily.com/2016/08/23/close-tabs-safari-iphone/ — confirms that
  swipe-left on a tab card in the iPhone tab view closes it; feature absent
  on Mac

### Full Screen New Windows → New windows open as full-screen Spaces ✅

When Safari is in full-screen mode (occupying its own Space) and opens a new
window — via Cmd+N, a link with target=_blank, or an external application —
macOS places that window into a new full-screen Space rather than on the
desktop. This is a consequence of the macOS Spaces architecture: full-screen
apps spawn new windows as additional full-screen Spaces by default. The
behaviour has been consistent across Ventura (13) through Tahoe (26). Using
Safari in "Fill" mode (Fn+Ctrl+F / green button long-press → Fill) instead of
true full screen prevents the cascade, as Fill-mode windows remain on the
desktop Space. For example, clicking a link in Outlook activates the
full-screen Safari and opens the link as a new tab there, rather than on
the desktop.

References:
- https://support.apple.com/guide/mac-help/work-in-multiple-spaces-mh14112/mac
  — Apple Spaces guide; "If you use the app full screen, it appears in its
  own space"

## Terminal

### Large Paste in Terminal → Hangs when pasted content exceeds 1024 bytes ✅

When running a program that reads from stdin (e.g. `cat` without arguments) and
pasting content longer than 1024 bytes via the clipboard (Cmd+V), the terminal
hangs: input is accepted up to the `MAX_CANON` limit, the program waits for a
line terminator to flush the buffer, and the OS refuses to enqueue more bytes
until the buffer drains — a deadlock. `MAX_CANON` is a compile-time constant in
the macOS/BSD kernel TTY line discipline (value: 1024) and cannot be changed at
runtime via `sysctl` or `stty`. The hang resolves with Ctrl+C; the truncated
portion of the paste is silently discarded. The canonical macOS workaround is
`pbpaste`, which reads directly from the clipboard pasteboard and bypasses the
TTY line discipline entirely.

Validation:
```
getconf MAX_CANON          # prints 1024 — the hard per-line byte limit
python3 -c "print('A'*1100, end='')" | pbcopy   # copy 1100-byte string
cat                        # then Cmd+V → terminal hangs after 1024 bytes
```

References:
- `getconf MAX_CANON` — POSIX utility to query the compile-time TTY constant;
  returns 1024 on all macOS versions through Tahoe (26)
- https://developer.apple.com/library/archive/documentation/System/Conceptual/ManPages_iPhoneOS/man4/tty.4.html
  — macOS tty(4) man page; describes canonical mode and the MAX_CANON limit
- `pbpaste(1)` man page — macOS clipboard tool; reads pasteboard directly,
  no TTY buffer involved

## Google Docs

### RTL/LTR Shortcut → Ctrl+Shift+←/→ does not work on macOS ✅

Google Docs provides Ctrl+Shift+→ (RTL) and Ctrl+Shift+← (LTR) to toggle
paragraph direction, but these shortcuts do not work on macOS regardless of
browser. The macOS system maps Ctrl+Shift+← / Ctrl+Shift+→ to word-level
selection extension (moveWordBackwardAndModifySelection: /
moveWordForwardAndModifySelection:) at the OS level, which conflicts with the
Google Docs handler. The shortcut is consumed or interfered with before Google
Docs can act on it cleanly. No fix has been released by Apple or Google as of
mid-2026. The reliable workaround is to use Format → Paragraph direction from
the Google Docs menu, which works in all browsers without a keyboard shortcut.

References:
- https://support.google.com/docs/answer/179738 — Google Docs keyboard
  shortcuts; documents Ctrl+Shift+←/→ for paragraph direction with a caveat
  that "some shortcuts might not work for all languages or keyboards"
- https://support.apple.com/en-us/102650 — macOS keyboard shortcuts reference
