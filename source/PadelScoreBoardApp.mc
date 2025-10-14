import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;

class PadelScoreBoardApp extends Application.AppBase {

    private var delegate as PadelScoreBoardDelegate;

    function initialize() {
        AppBase.initialize();
        delegate = new PadelScoreBoardDelegate();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new PadelScoreBoardView(), delegate ];
    }
    
    function getDelegate() as PadelScoreBoardDelegate {
        return delegate;
    }

}

function getApp() as PadelScoreBoardApp {
    return Application.getApp() as PadelScoreBoardApp;
}