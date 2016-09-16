function Controller()
{
    // aditional properties
    var appBit = "32bit"; // TODO is there a better solution?
    
    installer.setDefaultPageVisible(QInstaller.ComponentSelection, false); // hide component selection
    
    // set different target dir for different windows (do not install in home dir)
    if (systemInfo.kernelType === "winnt") {
        installer.setValue("TargetDir", "@ApplicationsDir@/@Publisher@/@ProductName@/");
        
        if (appBit == "64bit") { // change to 64bit program files if 64bit app binary
            var programFiles = installer.environmentVariable("ProgramW6432");
            if (programFiles != "") {
                installer.setValue("TargetDir", programFiles + "/@Publisher@/@ProductName@/");
            }
        }

    }
}

Controller.prototype.IntroductionPageCallback = function()
{
    if (installer.isUninstaller()) {
        // Get the current wizard page
        var widget = gui.currentPageWidget(); 
        if (widget != null) {
            // Don't show buttons because we just want to uninstall the software
            widget.findChild("PackageManagerRadioButton").visible = false;
            widget.findChild("UpdaterRadioButton").visible = false;
            widget.findChild("UninstallerRadioButton").visible = false;
        }
    }
}

Controller.prototype.LicenseAgreementPageCallback = function()
{
    var widget = gui.currentPageWidget();
    if (widget != null) {
        widget.AcceptLicenseRadioButton.checked = true;
    }
}