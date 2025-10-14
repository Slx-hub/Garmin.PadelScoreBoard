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

}