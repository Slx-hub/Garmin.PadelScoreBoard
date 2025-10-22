import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Application;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;

class PadelScoreBoardView extends WatchUi.View {

    private var tableBg as Graphics.BitmapReference or Null = null;
    
    // Static UI constants
    private static const MARGIN = 8;
    private static const TABLE_HEIGHT = 60;
    private static const TABLE_Y = 80;
    private static const PLAYER_OFFSET_Y = 5;
    private static const COL_WIDTHS = [40, 30, 30, 20, 20];
    private static const BATTERY_BOX_WIDTH = 120;
    private static const BATTERY_BOX_HEIGHT = 20;
    private static const BATTERY_TEXT_X = 25;
    private static const TIME_TEXT_X = 95;
    private static const SCORE_MESSAGE_X = 12;
    private static const SCORE_MESSAGE_Y = 52;
    private static const SERVER_CENTER_X_OFFSET = 27;
    private static const SERVER_CENTER_Y = 26;
    private static const SERVER_RADIUS = 30;
    private static const TABLE_BG_Y_OFFSET = 20;

    function initialize() {
        View.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        // Don't use the layout, we'll draw everything manually
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        // Load table background image once
        tableBg = WatchUi.loadResource(Rez.Drawables.TableBg);
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        var app = Application.getApp() as PadelScoreBoardApp;
        var delegate = app.getDelegate();
        var gameState = delegate.getGameState();
        
        var width = dc.getWidth();
        
        // Clear screen
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        
        var tableX = MARGIN;
        var rowHeight = TABLE_HEIGHT / 2;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.fillRectangle(0, 0, BATTERY_BOX_WIDTH, BATTERY_BOX_HEIGHT);

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

        // Display battery level
        var battLevel = System.getSystemStats().battery;
        var battStr = Lang.format( "$1$%", [ battLevel.format( "%02d" ) ] );
        dc.drawText(BATTERY_TEXT_X, 0, Graphics.FONT_SMALL, battStr, Graphics.TEXT_JUSTIFY_LEFT);

        // Display current time
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var timeStr = Lang.format("$1$:$2$", [today.hour.format("%02d"), today.min.format("%02d")]);
        dc.drawText(TIME_TEXT_X, 0, Graphics.FONT_SMALL, timeStr, Graphics.TEXT_JUSTIFY_RIGHT);
        
        // Draw table background image
        if (tableBg != null) {
            dc.drawBitmap(tableX, TABLE_Y - TABLE_BG_Y_OFFSET, tableBg);
        }

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        // Display last score message
        if (gameState.lastScoreMessage != "") {
            dc.drawText(SCORE_MESSAGE_X, SCORE_MESSAGE_Y, Graphics.FONT_MEDIUM, gameState.lastScoreMessage, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
        }
        
        // Get player positions
        var positions = gameState.playerPositions;
        
        // Row 1: Top Team (P3 and P4)
        var row1Y = TABLE_Y + rowHeight / 2;
        var x = tableX;
        
        // Score
        var topScore = gameState.getScoreString(gameState.topTeamScore);
        dc.drawText(x + COL_WIDTHS[0]/2, row1Y, Graphics.FONT_SMALL, topScore, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        x = x + COL_WIDTHS[0];
        
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

        // Player left (position 2 = top-left)
        dc.drawText(x + COL_WIDTHS[1]/2, row1Y - PLAYER_OFFSET_Y, Graphics.FONT_MEDIUM, gameState.getPlayerDisplayName(positions[2]), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        x = x + COL_WIDTHS[1];
        
        // Player right (position 3 = top-right)
        dc.drawText(x + COL_WIDTHS[2]/2, row1Y - PLAYER_OFFSET_Y, Graphics.FONT_MEDIUM, gameState.getPlayerDisplayName(positions[3]), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        x = x + COL_WIDTHS[2];
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        // Games won
        dc.drawText(x + COL_WIDTHS[3]/2, row1Y, Graphics.FONT_SMALL, gameState.topTeamGames.toString(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        x = x + COL_WIDTHS[3];
        
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

        // Sets won
        dc.drawText(x + COL_WIDTHS[4]/2, row1Y, Graphics.FONT_SMALL, gameState.topTeamSets.toString(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
        // Row 2: Bottom Team (P1 and P2)
        var row2Y = TABLE_Y + rowHeight + rowHeight / 2;
        x = tableX;
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        
        // Score
        var bottomScore = gameState.getScoreString(gameState.bottomTeamScore);
        dc.drawText(x + COL_WIDTHS[0]/2, row2Y, Graphics.FONT_SMALL, bottomScore, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        x = x + COL_WIDTHS[0];
        
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        
        // Player left (position 0 = bottom-left)
        dc.drawText(x + COL_WIDTHS[1]/2, row2Y + PLAYER_OFFSET_Y, Graphics.FONT_MEDIUM, gameState.getPlayerDisplayName(positions[0]), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        x = x + COL_WIDTHS[1];
        
        // Player right (position 1 = bottom-right)
        dc.drawText(x + COL_WIDTHS[2]/2, row2Y + PLAYER_OFFSET_Y, Graphics.FONT_MEDIUM, gameState.getPlayerDisplayName(positions[1]), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        x = x + COL_WIDTHS[2];
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        // Games won
        dc.drawText(x + COL_WIDTHS[3]/2, row2Y, Graphics.FONT_SMALL, gameState.bottomTeamGames.toString(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        x = x + COL_WIDTHS[3];
        
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

        // Sets won
        dc.drawText(x + COL_WIDTHS[4]/2, row2Y, Graphics.FONT_SMALL, gameState.bottomTeamSets.toString(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
        // Display current server in top right (get player ID from position)
        var serverPlayerId = gameState.playerPositions[gameState.currentServer];
        var serverName = gameState.getPlayerDisplayName(serverPlayerId);
        var serverCenterX = width - SERVER_CENTER_X_OFFSET;
        
        // Draw filled circle with inverted colors
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.fillCircle(serverCenterX, SERVER_CENTER_Y, SERVER_RADIUS);
        
        // Draw text in black on white background
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(serverCenterX, SERVER_CENTER_Y, Graphics.FONT_LARGE, serverName, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
        // Reset colors
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
    }
    
    // Static variable to hold last button name
    static var lastButtonName = null;

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
