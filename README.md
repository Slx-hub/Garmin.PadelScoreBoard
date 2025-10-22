# PadelScoreBoard for Garmin Instinct 2s

## Overview

PadelScoreBoard is a Connect IQ watch app for the Garmin Instinct 2s that helps you keep score for padel matches. It tracks points, games, sets, player positions, and serve rotation according to official padel rules. The app provides a simple table UI, sound cues, customizable player names, and menu actions for managing the game.

![PadelScoreBoard App Screenshot](./img/image.png)

## Features

- **Score Tracking**: Two teams with tennis-style scoring (0, 15, 30, 40, ADV, deuce)
- **Game & Set Counters**: Automatic tracking of games and sets won
- **Player Position Management**: Dynamic player positions with rotation support
- **Serve Rotation**: Automatic serve rotation based on scoring team
- **Player Rotation**: Quick rotation of 3 other players (P2, P3, P4) while user (P1) stays fixed via DOWN button
- **Customizable Player Names**: Toggle between generic names (P1-P4) and custom initials (J, M, D, P)
- **Undo Function**: Revert the last scoring action
- **Current Server Display**: Shows which player is currently serving (top right)
- **Sound Cues**: Audio feedback for scoring, serve changes, player swaps, and undo actions
- **Battery & Time Display**: Current battery level and time shown on screen

## How to Build and Test

### Prerequisites

- [Garmin Connect IQ SDK](https://developer.garmin.com/connect-iq/sdk/) installed
- [VS Code](https://code.visualstudio.com/) with the [Connect IQ extension](https://marketplace.visualstudio.com/items?itemName=Garmin.connectiq)

### Building the App

1. Open the project folder (`PadelScoreBoard`) in VS Code.
2. Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac) to open the Command Palette.
3. Type `Monkey C: Build for Device` and select it to build the app.
   - The compiled `.prg` file will appear in the `bin/` directory.
4. Then copy the compiled `.prg` into your watches `GARMIN/APPS` folder.

### Testing in the Simulator

1. Run with `F5` while having an `mc` file in focus, this should start the simulator
2. Interact with the app using the simulator buttons (see Button Controls below)
3. For a new build, the simulator does not have to be restarted, but it's advised to kill the app `Ctrl+A` before starting with step 1 again

## Button Controls

- **SET** (top right): Add point for top team
- **BACK** (bottom right): Add point for bottom team
- **DOWN** (bottom left): Rotate players (P2, P3, P4 rotate positions while P1 stays fixed)
- **UP** (center left): Currently unused
- **MENU** (long press UP): Open menu

### Menu Options

- **Undo**: Reverts the last scoring action
- **Reset Score**: Resets all scores and positions to initial state
- **Toggle Regulars**: Switch between generic player names (P1-P4) and custom initials (J, M, D, P)
- **Exit**: Closes the app and returns to the watch face

## Notes

- Scoring logic follows padel rules, serve rotation does not
- Sound cues use built-in and custom tone profiles (if supported by device)
- The app is designed for Instinct 2s but may work on other Connect IQ devices

## Troubleshooting

- If you encounter build errors, check for missing SDK or extension updates
- Use the VS Code Problems panel for error details
- For device-specific issues, consult the Garmin Connect IQ documentation
- otherwise, ¯\\\_(ツ)\_/¯

## License

MIT License
