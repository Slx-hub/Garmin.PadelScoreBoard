import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.Application;

class PadelScoreBoardMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
        if (item == :reset_score) {
            System.println("Reset Score");
            var app = Application.getApp() as PadelScoreBoardApp;
            var delegate = app.getDelegate() as PadelScoreBoardDelegate;
            delegate.getGameState().reset();
            WatchUi.requestUpdate();
        }
    }

}