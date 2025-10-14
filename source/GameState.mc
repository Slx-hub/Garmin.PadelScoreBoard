import Toybox.Lang;
import Toybox.System;
import Toybox.Attention;

class GameState {
    // Message to display after scoring
    var lastScoreMessage as String = "";
    // Player positions: [bottom-left, bottom-right, top-left, top-right]
    var playerPositions as Array<Number> = [];
    
    // Current server (player number 1-4)
    var currentServer as Number = 0;
    
    // Last server (player number 1-4)
    var lastServer as Number = 0;
    
    // Team scores: 0=0pts, 1=15pts, 2=30pts, 3=40pts, 4=advantage
    var bottomTeamScore as Number = 0;  // Team with P1 and P2
    var topTeamScore as Number = 0;     // Team with P3 and P4
    
    // Games and sets won
    var bottomTeamGames as Number = 0;
    var topTeamGames as Number = 0;
    var bottomTeamSets as Number = 0;
    var topTeamSets as Number = 0;
    
    function initialize() {
        reset();
    }
    
    function reset() as Void {
        // Initial positions: [P1, P2, P3, P4]
        playerPositions = [2, 1, 3, 4];
        lastScoreMessage = "";
        
        // Start with P2 serving
        currentServer = 1;
        lastServer = 1;
        
        // Reset scores
        bottomTeamScore = 0;
        topTeamScore = 0;
        bottomTeamGames = 0;
        topTeamGames = 0;
        bottomTeamSets = 0;
        topTeamSets = 0;
        
        Attention.playTone(Attention.TONE_RESET);
    }
    
    // Check if a player is on the bottom team
    function isBottomTeam(playerNum as Number) as Boolean {
        return (playerNum == 1 || playerNum == 2);
    }
    
    // Check if a player is on the top team
    function isTopTeam(playerNum as Number) as Boolean {
        return (playerNum == 3 || playerNum == 4);
    }
    
    // Check if current server is on bottom team
    function isBottomTeamServing() as Boolean {
        return isBottomTeam(currentServer);
    }

    // Get the other player on the same team as the given player
    function getTeammate(playerNum as Number) as Number {
        if (playerNum == 1) { return 2; }
        if (playerNum == 2) { return 1; }
        if (playerNum == 3) { return 4; }
        if (playerNum == 4) { return 3; }
        return 0;
    }
    
    // Switch positions of players on the serving team
    function switchServingTeamPositions() as Void {
        if (isBottomTeamServing()) {
            // Swap P1 and P2 positions
            var temp = playerPositions[0];
            playerPositions[0] = playerPositions[1];
            playerPositions[1] = temp;
        } else {
            // Swap P3 and P4 positions
            var temp = playerPositions[2];
            playerPositions[2] = playerPositions[3];
            playerPositions[3] = temp;
        }
        Attention.playTone(Attention.TONE_ALERT_HI);
    }
    
    // Switch serve to the other team
    function switchServingTeam(silent as Boolean) as Void {
        // Find who on the other team hasn't served last
        var tempserver = currentServer;

        if (isBottomTeamServing()) {
            // Switch to top team
            if (lastServer == 3) {
                currentServer = 4;
            } else {
                currentServer = 3;
            }
        } else {
            // Switch to bottom team
            if (lastServer == 1) {
                currentServer = 2;
            } else {
                currentServer = 1;
            }
        }
        lastServer = tempserver;
        if (!silent) {
            Attention.playTone(Attention.TONE_ALERT_LO);
        }
    }
    
    // Add point to bottom team
    function addPointBottomTeam() as Void {
        var servingTeamScored = isBottomTeamServing();
        lastScoreMessage = "T1 Scored";
        
        // Update score
        if (bottomTeamScore == 3 && topTeamScore >= 3) {
            // Deuce situation
            if (topTeamScore == 4) {
                // Top team had advantage, back to deuce
                topTeamScore = 3;
            } else {
                // Bottom team gets advantage
                bottomTeamScore = 4;
            }
        } else if (bottomTeamScore >= 3 && bottomTeamScore >= topTeamScore) {
            // Bottom team wins the game
            bottomTeamGames = bottomTeamGames + 1;
            System.println("Bottom team wins game! Games: " + bottomTeamGames);
            lastScoreMessage = "T1 Won";
            checkSetWin();
            bottomTeamScore = 0;
            topTeamScore = 0;
            switchServingTeam(true);
            Attention.playTone(Attention.TONE_SUCCESS);
            return;
        } else {
            bottomTeamScore = bottomTeamScore + 1;
        }
        
        // Handle serve rotation
        if (servingTeamScored) {
            switchServingTeamPositions();
        } else {
            switchServingTeam(false);
        }
    }
    
    // Add point to top team
    function addPointTopTeam() as Void {
        var servingTeamScored = isTopTeam(currentServer);
        lastScoreMessage = "T2 Scored";
        
        // Update score
        if (topTeamScore == 3 && bottomTeamScore >= 3) {
            // Deuce situation
            if (bottomTeamScore == 4) {
                // Bottom team had advantage, back to deuce
                bottomTeamScore = 3;
            } else {
                // Top team gets advantage
                topTeamScore = 4;
            }
        } else if (topTeamScore >= 3 && topTeamScore >= bottomTeamScore) {
            // Top team wins the game
            topTeamGames = topTeamGames + 1;
            System.println("Top team wins game! Games: " + topTeamGames);
            lastScoreMessage = "T2 Won";
            checkSetWin();
            bottomTeamScore = 0;
            topTeamScore = 0;
            switchServingTeam(true);
            Attention.playTone(Attention.TONE_SUCCESS);
            return;
        } else {
            topTeamScore = topTeamScore + 1;
        }
        
        // Handle serve rotation
        if (servingTeamScored) {
            switchServingTeamPositions();
        } else {
            switchServingTeam(false);
        }
    }
    
    // Check if a team has won the set
    function checkSetWin() as Void {
        if (bottomTeamGames >= 6 && bottomTeamGames >= topTeamGames + 2) {
            bottomTeamSets = bottomTeamSets + 1;
            System.println("Bottom team wins set! Sets: " + bottomTeamSets);
            bottomTeamGames = 0;
            topTeamGames = 0;
        } else if (topTeamGames >= 6 && topTeamGames >= bottomTeamGames + 2) {
            topTeamSets = topTeamSets + 1;
            System.println("Top team wins set! Sets: " + topTeamSets);
            bottomTeamGames = 0;
            topTeamGames = 0;
        }
    }
    
    // Get score display string for a team
    function getScoreString(score as Number) as String {
        if (score == 0) { return "0"; }
        if (score == 1) { return "15"; }
        if (score == 2) { return "30"; }
        if (score == 3) { return "40"; }
        if (score == 4) { return "ADV"; }
        return "0";
    }
}
