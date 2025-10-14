import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.System;

class PadelScoreBoardDelegate extends WatchUi.BehaviorDelegate {
    
    private var gameState as GameState;

    function initialize() {
        BehaviorDelegate.initialize();
        gameState = new GameState();
    }
    
    function getGameState() as GameState {
        return gameState;
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new PadelScoreBoardMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    function onNextPage() as Boolean {
        System.println("Button pressed: DOWN");
        PadelScoreBoardView.lastButtonName = "DOWN";
        WatchUi.requestUpdate();
        return true;
    }

    function onPreviousPage() as Boolean {
        System.println("Button pressed: UP");
        PadelScoreBoardView.lastButtonName = "UP";
        WatchUi.requestUpdate();
        return true;
    }

    function onSelect() as Boolean {
        System.println("Button pressed: SET - Top team scores");
        gameState.addPointTopTeam();
        WatchUi.requestUpdate();
        return true;
    }

    function onBack() as Boolean {
        System.println("Button pressed: BACK - Bottom team scores");
        gameState.addPointBottomTeam();
        WatchUi.requestUpdate();
        return true;
    }
}