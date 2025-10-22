import Toybox.Lang;
import Toybox.System;
import Toybox.Attention;

class GameState {
    // Snapshot for undo
    var snapshot as Dictionary = {};
    // Message to display after scoring
    var lastScoreMessage as String = "";
    // Player positions: [bottom-left, bottom-right, top-left, top-right]
    var playerPositions as Array<Number> = [];
    
    // Current server (array index 0-3)
    var currentServer as Number = 0;
    
    // Last server (array index 0-3)
    var lastServer as Number = 0;
    
    // Display name mode
    var useRegularNames as Boolean = true;
    
    // Display name arrays (indexed by player ID 0-3)
    var genericNames as Array<String> = ["P1", "P2", "P3", "P4"];
    var regularNames as Array<String> = ["J", "M", "D", "P"];
    
    // Team scores: 0=0pts, 1=15pts, 2=30pts, 3=40pts, 4=advantage
    var bottomTeamScore as Number = 0;  // Team with indices 0-1
    var topTeamScore as Number = 0;     // Team with indices 2-3
    
    // Games and sets won
    var bottomTeamGames as Number = 0;
    var topTeamGames as Number = 0;
    var bottomTeamSets as Number = 0;
    var topTeamSets as Number = 0;
    
    function initialize() {
        reset();
    }
    
    function reset() as Void {
        // Initial positions: [P1, P2, P3, P4] (using 0-based indices)
        playerPositions = [0, 1, 2, 3];
        lastScoreMessage = "";
        
        // Start with P2 serving (index 1 = bottom-right position)
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

    function rotatePlayers() {
        var insertPlayer = playerPositions[3]; // defo not player 1
        var tempPlayer = 0;

        for (var i = 0; i <= 3; i++) {
            if (playerPositions[i] == 0) {
                continue;
            }
            tempPlayer = playerPositions[i];
            playerPositions[i] = insertPlayer;
            insertPlayer = tempPlayer;
        }
        
        Attention.playTone({:toneProfile=>PLAYER_SWAP_SOUND});
    }
    
    // Get display name for a player ID
    function getPlayerDisplayName(playerId as Number) as String {
        if (useRegularNames) {
            return regularNames[playerId];
        } else {
            return genericNames[playerId];
        }
    }
    
    // Toggle between regular and generic player names
    function toggleRegularNames() as Void {
        useRegularNames = !useRegularNames;
        Attention.playTone({:toneProfile=>TEAM_SWAP_SOUND});
    }
    
    // Check if a position index is on the bottom team
    function isBottomTeam(positionIndex as Number) as Boolean {
        return (positionIndex == 0 || positionIndex == 1);
    }
    
    // Check if a position index is on the top team
    function isTopTeam(positionIndex as Number) as Boolean {
        return (positionIndex == 2 || positionIndex == 3);
    }
    
    // Check if current server is on bottom team
    function isBottomTeamServing() as Boolean {
        return isBottomTeam(currentServer);
    }

    // Get the other player index on the same team as the given position index
    function getTeammate(positionIndex as Number) as Number {
        if (positionIndex == 0) { return 1; }  // bottom-left -> bottom-right
        if (positionIndex == 1) { return 0; }  // bottom-right -> bottom-left
        if (positionIndex == 2) { return 3; }  // top-left -> top-right
        if (positionIndex == 3) { return 2; }  // top-right -> top-left
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
        Attention.playTone({:toneProfile=>PLAYER_SWAP_SOUND});
    }
    
    // Switch serve to the other team
    function switchServingTeam() as Void {
        var tempserver = currentServer;

        if (isBottomTeamServing()) {
            // Switch to top team
            if (lastServer == 2) {
                currentServer = 3;
            } else {
                currentServer = 2;
            }
        } else {
            // Switch to bottom team
            if (lastServer == 0) {
                currentServer = 1;
            } else {
                currentServer = 0;
            }
        }
        lastServer = tempserver;
        Attention.playTone({:toneProfile=>TEAM_SWAP_SOUND});
    }

        
    // Switch serve to the losing team
    function switchServeToLosingTeam(hasBottomTeamWon as Boolean) as Void {
        var tempserver = currentServer;

        if (hasBottomTeamWon) {
            // Switch to top team
            if (lastServer == 2 || currentServer == 2) {
                currentServer = 3;
            } else {
                currentServer = 2;
            }
        } else {
            // Switch to bottom team
            if (lastServer == 0 || currentServer == 0) {
                currentServer = 1;
            } else {
                currentServer = 0;
            }
        }
        lastServer = tempserver;
    }
    
    // Add point to bottom team
    function addPointBottomTeam() as Void {
    saveSnapshot();
        var servingTeamScored = isBottomTeamServing();
        lastScoreMessage = "Bot Scored";
        
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
            lastScoreMessage = "Bot Won";
            teamWinsGame(true);
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
        saveSnapshot();
        var servingTeamScored = isTopTeam(currentServer);
        lastScoreMessage = "Top Scored";
        
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
            lastScoreMessage = "Top Won";
            teamWinsGame(false);
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

    function teamWinsGame(hasBottomTeamWon as Boolean) as Void {
        checkSetWin();
        bottomTeamScore = 0;
        topTeamScore = 0;
        switchServeToLosingTeam(hasBottomTeamWon);
        Attention.playTone({:toneProfile=>TEAM_WIN_SOUND});
    }
    
    // Check if a team has won the set
    function checkSetWin() as Void {
        if (bottomTeamGames >= 6 && bottomTeamGames >= topTeamGames + 2) {
            bottomTeamSets = bottomTeamSets + 1;
            System.println("Bottom team wins set! Sets: " + bottomTeamSets);
            lastScoreMessage = "Bot Settled";
            bottomTeamGames = 0;
            topTeamGames = 0;
        } else if (topTeamGames >= 6 && topTeamGames >= bottomTeamGames + 2) {
            topTeamSets = topTeamSets + 1;
            System.println("Top team wins set! Sets: " + topTeamSets);
            lastScoreMessage = "Top Settled";
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

        // Save snapshot of all variables
    function saveSnapshot() as Void {
        snapshot = {
            :lastScoreMessage => lastScoreMessage,
            :playerPositions => cloneArray(playerPositions),
            :currentServer => currentServer,
            :lastServer => lastServer,
            :bottomTeamScore => bottomTeamScore,
            :topTeamScore => topTeamScore,
            :bottomTeamGames => bottomTeamGames,
            :topTeamGames => topTeamGames,
            :bottomTeamSets => bottomTeamSets,
            :topTeamSets => topTeamSets
        };
    }
    // Restore snapshot for undo
    function restoreSnapshot() as Void {
        if (snapshot != null) {
            lastScoreMessage = snapshot[:lastScoreMessage];
            playerPositions = cloneArray(snapshot[:playerPositions]);
            currentServer = snapshot[:currentServer];
            lastServer = snapshot[:lastServer];
            bottomTeamScore = snapshot[:bottomTeamScore];
            topTeamScore = snapshot[:topTeamScore];
            bottomTeamGames = snapshot[:bottomTeamGames];
            topTeamGames = snapshot[:topTeamGames];
            bottomTeamSets = snapshot[:bottomTeamSets];
            topTeamSets = snapshot[:topTeamSets];
            Attention.playTone({:toneProfile=>TEAM_SWAP_SOUND});
        }
    }

    function cloneArray(arr as Array<Number>) as Array<Number> {
        var newArr = [];
        for (var i = 0; i < arr.size(); i = i + 1) {
            newArr.add(arr[i]);
        }
        return newArr;
    }
}
