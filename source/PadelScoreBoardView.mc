import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Application;

class PadelScoreBoardView extends WatchUi.View {

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
        var margin = 10;
        var tableWidth = 40 + 30 + 30 + 20 + 20;
        var tableHeight = 60;
        var tableX = margin;
        var tableY = 70;
        
        // Column widths: Score | Player | Player | Games | Sets
        var colWidths = [40, 30, 30, 20, 20];
        var rowHeight = tableHeight / 2;
        
        if (gameState.lastScoreMessage != "") {
            dc.drawText(10, 50, Graphics.FONT_MEDIUM, gameState.lastScoreMessage, Graphics.TEXT_JUSTIFY_LEFT | Graphics.TEXT_JUSTIFY_VCENTER);
        }

        // Draw table borders
        dc.drawRectangle(tableX, tableY, tableWidth, tableHeight);
        dc.drawLine(tableX, tableY + rowHeight, tableX + tableWidth, tableY + rowHeight);
        
        // Draw column lines
        var x = tableX;
        for (var i = 0; i < colWidths.size(); i++) {
            x = x + colWidths[i];
            if (i < colWidths.size() - 1) {
                dc.drawLine(x, tableY, x, tableY + tableHeight);
            }
        }
        
        // Get player positions
        var positions = gameState.playerPositions;
        
        // Row 1: Top Team (P3 and P4)
        var row1Y = tableY + rowHeight / 2;
        x = tableX;
        
        // Score
        var topScore = gameState.getScoreString(gameState.topTeamScore);
        dc.drawText(x + colWidths[0]/2, row1Y, Graphics.FONT_TINY, topScore, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        x = x + colWidths[0];
        
        // Player left (position 2 = top-left)
        dc.drawText(x + colWidths[1]/2, row1Y, Graphics.FONT_TINY, "P" + positions[2], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        x = x + colWidths[1];
        
        // Player right (position 3 = top-right)
        dc.drawText(x + colWidths[2]/2, row1Y, Graphics.FONT_TINY, "P" + positions[3], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        x = x + colWidths[2];
        
        // Games won
        dc.drawText(x + colWidths[3]/2, row1Y, Graphics.FONT_TINY, gameState.topTeamGames.toString(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        x = x + colWidths[3];
        
        // Sets won
        dc.drawText(x + colWidths[4]/2, row1Y, Graphics.FONT_TINY, gameState.topTeamSets.toString(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
        // Row 2: Bottom Team (P1 and P2)
        var row2Y = tableY + rowHeight + rowHeight / 2;
        x = tableX;
        
        // Score
        var bottomScore = gameState.getScoreString(gameState.bottomTeamScore);
        dc.drawText(x + colWidths[0]/2, row2Y, Graphics.FONT_TINY, bottomScore, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        x = x + colWidths[0];
        
        // Player left (position 0 = bottom-left)
        dc.drawText(x + colWidths[1]/2, row2Y, Graphics.FONT_TINY, "P" + positions[0], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        x = x + colWidths[1];
        
        // Player right (position 1 = bottom-right)
        dc.drawText(x + colWidths[2]/2, row2Y, Graphics.FONT_TINY, "P" + positions[1], Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        x = x + colWidths[2];
        
        // Games won
        dc.drawText(x + colWidths[3]/2, row2Y, Graphics.FONT_TINY, gameState.bottomTeamGames.toString(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        x = x + colWidths[3];
        
        // Sets won
        dc.drawText(x + colWidths[4]/2, row2Y, Graphics.FONT_TINY, gameState.bottomTeamSets.toString(), Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        
        // Display current server in top right
        dc.drawText(width - 25, 25, Graphics.FONT_LARGE, "P" + gameState.currentServer, Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
    }
    
    // Static variable to hold last button name
    static var lastButtonName = null;

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
