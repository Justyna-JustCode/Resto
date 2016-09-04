import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import "../components"

// TODO: change into pretty tumbler
RowLayout {
    property int time   // in seconds
    property int minTime: 0

    property bool showHours: true
    property bool showMinutes: true
    property bool showSeconds: true


    onTimeChanged: {
        d.update()
    }
    onMinTimeChanged: {
        d.updateMin()
    }

    QtObject {
        id: d
        property int hours
        property int minutes
        property int seconds

        property int minHours
        property int minMinutes
        property int minSeconds

        function update() {
            var hs = Math.floor(time/3600)
            var mins = Math.floor( (time%3600)/60 )
            var secs = time%60;

            hours = hs;
            minutes = mins;
            seconds = secs;
        }
        function calculateTime() {
            var timeSec = seconds +
                    minutes * 60 +
                    hours * 3600;

            time = timeSec;
        }

        function updateMin() {
            var hs = Math.floor(minTime/3600)
            var mins = Math.floor( (minTime%3600)/60 )
            var secs = minTime%60;

            minHours = hs;
            minMinutes = mins;
            minSeconds = secs;
        }

        onHoursChanged: calculateTime();
        onMinutesChanged: calculateTime();
        onSecondsChanged: calculateTime();
    }

    SpinBox {
        id: hoursSpin

        maximumValue: 23
        minimumValue: d.minHours
        suffix: "h"

        visible: showHours

        value: d.hours
        onValueChanged: {
            d.hours = value
        }
    }
    SpinBox {
        id: minutesSpin

        maximumValue: 59
        minimumValue: (hoursSpin.value > d.minHours)
                      ? 0 : d.minMinutes
        suffix: "m"

        visible: showMinutes

        value: d.minutes
        onValueChanged: {
            d.minutes = value
        }
    }
    SpinBox {
        maximumValue: 59
        minimumValue: (hoursSpin.value > d.minHours ||
                       minutesSpin.value > d.minMinutes)
                      ? 0 : d.minSeconds

        suffix: "s"

        visible: showSeconds

        value: d.seconds
        onValueChanged: {
            d.seconds = value
        }
    }
}
