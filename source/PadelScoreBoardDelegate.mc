import Toybox.Lang;
import Toybox.WatchUi;

class PadelScoreBoardDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
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
        System.println("Button pressed: SET");
        PadelScoreBoardView.lastButtonName = "SET";
        WatchUi.requestUpdate();
        return true;
    }

    function onBack() as Boolean {
        System.println("Button pressed: BACK");
        PadelScoreBoardView.lastButtonName = "BACK";
        WatchUi.requestUpdate();
        return true;
    }
}