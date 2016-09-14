function Component()
{
    installer.setDefaultPageVisible(QInstaller.ComponentSelection, false); // hide component selection
    
    // connect open help pages
    installer.installationFinished.connect(this, Component.prototype.installationFinishedPageIsShown);
    installer.finishButtonClicked.connect(this, Component.prototype.installationFinished);
}

Component.prototype.createOperations = function()
{
    component.createOperations();
    
    if (installer.value("os") === "x11")
    {
        component.addOperation("Mkdir", "@HomeDir@/.local/share/applications/");
        component.addOperation("CreateDesktopEntry", "@HomeDir@/.local/share/applications/@ProductName@.desktop", "Version=@ProductVersion@\nType=Application\nTerminal=false\nExec=@TargetDir@/runner\nName=@ProductName@\nIcon=@TargetDir@/ico.png\n");
    }
}

Component.prototype.installationFinishedPageIsShown = function()
{
    try {
        if (installer.isInstaller() && installer.status == QInstaller.Success) {
            installer.addWizardPageItem( component, "OpenHelpForm", QInstaller.InstallationFinished );
        }
    } catch(e) {
        console.log(e);
    }
}

Component.prototype.installationFinished = function()
{
    try {
        if (installer.isInstaller() && installer.status == QInstaller.Success) {
            var openHelp = component.userInterface( "OpenHelpForm" ).openHelpCheckBox.checked;
            if (openHelp) {
                QDesktopServices.openUrl("file:///" + installer.value("TargetDir") + "/help.pdf");
            }
        }
    } catch(e) {
        console.log(e);
    }
}
