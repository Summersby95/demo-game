# 2048: Super Mario 64 Edition

A fully-featured clone of 2048 inspired by the visuals of **Super Mario 64**. Built with LÖVE (Love2D).

## Features

-   **3 Distinct Themes**:
    -   *Bob-omb Battlefield* (Sky Blue / Green)
    -   *Lethal Lava Land* (Dark Red / Lava)
    -   *Cool, Cool Mountain* (Deep Blue / Ice)
-   **Save System**: Quit anytime and use "Continue" to resume your progress.
-   **Modern UI**: Animated menus and smooth tile transitions.
-   **Responsive Gameplay**: Deferred animation logic ensures 100% accurate merge timing.

## How to Play

### Controls
-   **Arrow Keys** or **WASD**: Slide tiles.
-   **Escape**: Return to Main Menu.
-   **Mouse**: Click menu buttons.

### Rules
1.  Slide tiles to move them across the grid.
2.  Tiles with the same number merge into one when they touch (e.g., 2 + 2 = 4).
3.  Add up to **2048** to win (but you can keep playing for a high score!).

## Installation & Running

### Option 1: Download Release (Windows)
1.  Go to the **Releases** tab on GitHub.
2.  Download the latest `2048-SM64.zip`.
3.  Extract and run `2048-SM64.exe`.

### Option 2: Run from Source (Any OS)
1.  Install **[LÖVE 11.4+](https://love2d.org/)**.
2.  Clone or download this repository.
3.  Open a terminal in the project folder.
4.  Run:
    ```bash
    love .
    ```

## Building
This project includes a GitHub Action to automatically build Windows executables on every push.
To build manually:
1.  Zip the contents of this folder (select `main.lua`, `conf.lua`, and `src/`).
2.  Rename to `game.love`.
3.  Fuse with `love.exe` (Windows) or run with LÖVE app (Mac/Linux).