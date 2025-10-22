import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Application;
import Toybox.System;
import Toybox.Time;
import Toybox.Time.Gregorian;

class PadelScoreBoardView extends WatchUi.View {

    private var tableBg as Graphics.BitmapReference or Null = null;

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
        System.println("Updating View");

        var app = Application.getApp() as PadelScoreBoardApp;
        var delegate = app.getDelegate();
        var gameState = delegate.getGameState();
        
        var width = dc.getWidth();
        
        // Clear screen
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        
        // Define table dimensions
        var margin = 8;
        var tableHeight = 60;
        var tableX = margin;
        var tableY = 80;
        var playerOffsetY = 5;
        
        // Column widths: Score | Player | Player | Games | Sets
        var colWidths = [40, 30, 30, 20, 20];
        var rowHeight = tableHeight / 2;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);

        dc.fillRectangle(0, 0, 120, 20);  // Background box

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

        // Display battery level
        var battLevel = System.getSystemStats().battery;
        var battStr = Lang.format( "$1$%", [ battLevel.format( "%02d" ) ] );
        dc.drawText(25, 0, Graphics.FONT_SMALL, battStr, Graphics.TEXT_JUSTIFY_LEFT);

        // Display current time
        var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
        var timeStr = Lang.format("$1$:$2$", [today.hour.format("%02d"), today.min.format("%02d")]);
        dc.drawText(95, 0, Graphics.FONT_SMALL, timeStr, Graphics.TEXT_JUSTIFY_RIGHT);
        
        // Draw table background image
        if (tableBg != null) {
            dc.drawBitmap(tableX, tableY - 20, tableBg);
        }

        // Draw table borders
        //var tableWidth = 40 + 30 + 30 + 20 + 20;
        //dc.drawRectangle(tableX, tableY, tableWidth, tableHeight);
        //dc.drawLine(tableX, tableY + rowHeight, tableX + tableWidth, tableY + rowHeight);
        
        // Draw column lines
        //var x = tableX;
        //for (var i = 0; i < colWidths.size(); i++) {
        //    x = x + colWidths[i];
        //    if (i < colWidths.size() - 1) {
        //        dc.drawLine(x, tableY, x, tableY + tableHeight);
        //    }
        //}

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        // Display last score message
        if (gameState.lastScoreMessage != "") {
            dc.drawText(12, 52, Graphics.FONT_MEDIUM, gameState.lastScoreMessage, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
        }
        
        // Get player positions
        var positions = gameState.playerPositions;
        
        // Row 1: Top Team (P3 and P4)
        var row1Y = tableY + rowHeight / 2;
        var x = tableX;
        
        // Score
        var topScore = gameState.getScoreString(gameState.topTeamScore);
        dc.drawText(x + colWidths[0]/2, row1Y, Graphics.FONT_SMALL, topScore, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        x = x + colWidths[0];
        
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

        // Player left (position 2 = top-left)
        dc.drawText(x + colWidths[1]/2, row1Y - playerOffsetY, Graphics.FONT_MEDIUM, gameState.getPlayerDisplayName(positions[2]), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        x = x + colWidths[1];
        
        // Player right (position 3 = top-right)
        dc.drawText(x + colWidths[2]/2, row1Y - playerOffsetY, Graphics.FONT_MEDIUM, gameState.getPlayerDisplayName(positions[3]), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        x = x + colWidths[2];
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        // Games won
        dc.drawText(x + colWidths[3]/2, row1Y, Graphics.FONT_SMALL, gameState.topTeamGames.toString(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        x = x + colWidths[3];
        
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

        // Sets won
        dc.drawText(x + colWidths[4]/2, row1Y, Graphics.FONT_SMALL, gameState.topTeamSets.toString(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
        // Row 2: Bottom Team (P1 and P2)
        var row2Y = tableY + rowHeight + rowHeight / 2;
        x = tableX;
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        
        // Score
        var bottomScore = gameState.getScoreString(gameState.bottomTeamScore);
        dc.drawText(x + colWidths[0]/2, row2Y, Graphics.FONT_SMALL, bottomScore, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        x = x + colWidths[0];
        
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        
        // Player left (position 0 = bottom-left)
        dc.drawText(x + colWidths[1]/2, row2Y + playerOffsetY, Graphics.FONT_MEDIUM, gameState.getPlayerDisplayName(positions[0]), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        x = x + colWidths[1];
        
        // Player right (position 1 = bottom-right)
        dc.drawText(x + colWidths[2]/2, row2Y + playerOffsetY, Graphics.FONT_MEDIUM, gameState.getPlayerDisplayName(positions[1]), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        x = x + colWidths[2];
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);

        // Games won
        dc.drawText(x + colWidths[3]/2, row2Y, Graphics.FONT_SMALL, gameState.bottomTeamGames.toString(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        x = x + colWidths[3];
        
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

        // Sets won
        dc.drawText(x + colWidths[4]/2, row2Y, Graphics.FONT_SMALL, gameState.bottomTeamSets.toString(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
        // Display current server in top right (get player ID from position)
        var serverPlayerId = gameState.playerPositions[gameState.currentServer];
        var serverName = gameState.getPlayerDisplayName(serverPlayerId);
        var serverCenterX = width - 27;
        var serverCenterY = 26;
        var serverRadius = 30;
        
        // Draw filled circle with inverted colors
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_WHITE);
        dc.fillCircle(serverCenterX, serverCenterY, serverRadius);
        
        // Draw text in white on black background
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
        dc.drawText(serverCenterX, serverCenterY, Graphics.FONT_LARGE, serverName, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
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
