function Controller()
{
    // aditional properties
    var appBit = "${APP_BIT}"; // TODO is there a better solution?

    if (installer.isInstaller()) {
        installer.setDefaultPageVisible(QInstaller.ComponentSelection, false); // hide component selection
    }

    // set different target dir for different windows (do not install in home dir)
    if (systemInfo.kernelType === "winnt") {
        installer.setValue("TargetDir", "@ApplicationsDir@/@Publisher@/@ProductName@/");
        
        if (appBit == "x86-64") { // change to 64bit program files if 64bit app binary
            var programFiles = installer.environmentVariable("ProgramW6432");
            if (programFiles != "") {
                installer.setValue("TargetDir", programFiles + "/@Publisher@/@ProductName@/");
            }
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
