function Controller()
{
    if (installer.isInstaller()) {
        installer.setDefaultPageVisible(QInstaller.ComponentSelection, false); // hide component selection
    }
}
