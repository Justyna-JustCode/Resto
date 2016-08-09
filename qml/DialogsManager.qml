import QtQuick 2.5
import "dialogs"

Item {
    id: root

    // accessors ---------------------------------------------------------
    function showBreakRequestDialog() {
        d.showDialog(breakRequestDialog)
    }
    function showBreakDialog() {
        d.showDialog(breakDialog);
    }
    function showEndWorkRequestDialog() {
        d.showDialog(endWorkRequestDialog)
    }
    function showAboutDialog() {
        d.showDialog(aboutDialog)
    }
    function showSettingsDialog() {
        d.showDialog(settingsDialog)
    }
    // -------------------------------------------------------------------

    // logic -------------------------------------------------------------
    QtObject {
        id: d

        property var loaderComponent: Component {
            Loader {
                property string id

                Connections {
                    target: item

                    onClosing: {
                        var id = this.id;
                        d.loadersMap[id].destroy();
                        d.loadersMap[id] = "";
                    }
                }
            }
        }
        property var loadersMap: new Object

        function showDialog(component) {
            var id = component.toString();
            if (loadersMap[id]) {
                console.warn("Dialogs Manager", "Dialog already exist");
                return;
            }

            var loaderItem = loaderComponent.createObject(root);
            loaderItem.id = id;
            loaderItem.sourceComponent = component;
            loaderItem.active = true;
            loaderItem.item.show();

            loadersMap[id] = loaderItem;
        }
    }
    // -------------------------------------------------------------------

    // components --------------------------------------------------------
    Component {
        id: breakRequestDialog

        BreakRequestDialog {
            onAccept: {
                controller.startBreak();
                showBreakDialog();
            }
            onPostpone: {
                controller.postponeBreak();
            }
            onSkip: {
                controller.startWork();
            }
        }
    }

    Component {
        id: breakDialog

        BreakDialog {
            onEndBreak: {
                controller.startWork();
            }
        }
    }

    Component {
        id: endWorkRequestDialog

        EndWorkRequestDialog {
            onAccept: {
                controller.stop();
            }
        }
    }

    Component {
        id: aboutDialog

        AboutDialog {}
    }

    Component {
        id: settingsDialog

        SettingsDialog {}
    }
    // -------------------------------------------------------------------
}
