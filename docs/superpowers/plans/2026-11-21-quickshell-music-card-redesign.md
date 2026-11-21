# Quickshell Music Card Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement the redesigned music player card in Quickshell, matching the Pencil design's layout and typography while preserving dynamic OS theme colors and MPRIS functionality.

**Architecture:** Update the QML component hierarchy to match the Pencil layers, using the existing `ThemeService` for colors but updating dimensions, margins, and font properties.

**Tech Stack:** Qt Quick, QML, Quickshell, MPRIS.

**Spec:** `quickshell-widget.pen`

## Global Constraints
- **Dimensions:** Width 380px.
- **Corner Radius:** 26px.
- **Colors:** MUST use existing `ThemeService` properties (no hardcoded design colors).
- **Typography:** Roboto Mono for track metadata and timestamps; Inter for UI labels.
- **Persistence:** Preserve all MPRIS bindings and playback control logic.

## Review Focus
- **Layout Integrity:** Ensure the card maintains the 380px width and correct padding even with dynamic text.
- **Theme Adaptability:** Verify that using OS theme colors doesn't break legibility (e.g., contrast between progress fill and track).
- **Progress interaction:** Verify the progress bar remains interactive and syncs with MPRIS.

---

### Task 1: Update Card Structure and Geometry
**Files:**
- Modify: `components/MusicCard.qml`

- [ ] **Step 1: Adjust `MusicCard.qml` root properties**
Update width to `380`, radius to `26`. Maintain the existing `root.cardColor` but update the layout margins to `[22, 24, 18, 24]` and gap to `20`.
- [ ] **Step 2: Remove old clock section**
Delete the `Column` containing the time and date (lines 28-41 in original file) and the separator (lines 43-48).
- [ ] **Step 3: Commit**

### Task 2: Implement New Header Row
**Files:**
- Modify: `components/MusicCard.qml`
- Create: `components/HeaderRow.qml`

- [ ] **Step 1: Implement `HeaderRow.qml`**
Create a row with the "Source Selector Pill", "Volume Pill", and "App Button" using layout properties from the design. Use `root.borderColor` for pill backgrounds to stay themed.
- [ ] **Step 2: Bind Volume and Source**
Connect the volume text to `MprisService.volume` and the app name to `MprisService.identity`.
- [ ] **Step 3: Integrate into `MusicCard.qml`**
Place `HeaderRow` at the top of the main `Column`.
- [ ] **Step 4: Commit**

### Task 3: Update Track Info and Album Art
**Files:**
- Modify: `components/AlbumArtwork.qml`
- Modify: `components/TrackInfo.qml`

- [ ] **Step 1: Update `AlbumArtwork.qml`**
Set size to 98x98, radius to 14. Keep existing artwork loading logic.
- [ ] **Step 2: Update `TrackInfo.qml` typography**
Switch to "Roboto Mono". Update font sizes: Title (17px, SemiBold), Artist (13px, Medium), Album (12px, Normal). Use `root.primaryText` and `root.secondaryText`.
- [ ] **Step 3: Commit**

### Task 4: Redesign Progress and Controls
**Files:**
- Modify: `components/ProgressBar.qml`
- Modify: `components/PlaybackControls.qml`

- [ ] **Step 1: Update `ProgressBar.qml`**
Height 4px. Move the elapsed and total duration text into a `Row` below the bar as shown in the design.
- [ ] **Step 2: Update `PlaybackControls.qml`**
Adjust Play/Pause size to 56x56 and spacing between controls to 48px. Use `root.accentColor` for the play button background.
- [ ] **Step 3: Commit**

### Task 5: Implement Wave Spectrum Visualizer
**Files:**
- Modify: `components/Equalizer.qml`

- [ ] **Step 1: Transform `Equalizer.qml`**
Update the bar count to 37 and set width/height/gap to match the "Visualizer Wave Spectrum" from the design. Maintain the existing animation logic.
- [ ] **Step 2: Commit**
