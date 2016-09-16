function Component()
{
    // connect open help pages
    installer.installationFinished.connect(this, Component.prototype.installationFinishedPageIsShown);
    installer.finishButtonClicked.connect(this, Component.prototype.installationFinished);
}

Component.prototype.createOperations = function()
{
    component.createOperations();
    
    if (systemInfo.kernelType === "winnt") {
        component.addOperation("Mkdir", "@StartMenuDir@");
        component.addOperation("CreateShortcut", "@TargetDir@/@ProductName@.exe", "@StartMenuDir@/@ProductName@.lnk");
    }
    else if (systemInfo.kernelType === "linux") {
        var desktopEntry = "Version=@ProductVersion@\nType=Application\nTerminal=false\nExec=@TargetDir@/runner\nName=@ProductName@\nComment=A small application for work time management\nIcon=@TargetDir@/ico.png\nCategories=Office;\n"
    
        // add desktop file in package
        component.addOperation("Delete", "@TargetDir@/@ProductName@.desktop");
        component.addOperation("CreateDesktopEntry", "@TargetDir@/@ProductName@.desktop", desktopEntry);
        
        // add other desktop files
        if (installer.value("HomeDir") == "/root") { // check for root
            component.addOperation("Mkdir", "/usr/share/applications/");
            component.addOperation("CreateDesktopEntry", "/usr/share/applications/@ProductName@.desktop", desktopEntry);
        }
        else {
            component.addOperation("Mkdir", "@HomeDir@/.local/share/applications/");
            component.addOperation("CreateDesktopEntry", "@HomeDir@/.local/share/applications/@ProductName@.desktop", desktopEntry);
        }
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
