import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.1
import "../components"

// TODO: change into pretty tumbler
RowLayout {
    property int time   // in seconds

    property bool showHours: true
    property bool showMinutes: true
    property bool showSeconds: true

    onTimeChanged: {
        d.update()
    }

    QtObject {
        id: d
        property int hours
        property int minutes
        property int seconds

        function update() {
            var remainSecs = time;

            var hs = Math.floor(remainSecs/3600)
            remainSecs -= hs*3600;

            var mins = Math.floor(remainSecs/60)
            remainSecs -= mins*60;

            hours = hs;
            minutes = mins;
            seconds = remainSecs;
        }
        function calculateTime() {
            var timeSec = seconds +
                    minutes * 60 +
                    hours * 3600;

            time = timeSec;
        }

        onHoursChanged: calculateTime();
        onMinutesChanged: calculateTime();
        onSecondsChanged: calculateTime();
    }

    SpinBox {
        maximumValue: 23
        suffix: "h"

        visible: showHours

        value: d.hours
        onValueChanged: {
            d.hours = value
        }
    }
    SpinBox {
        maximumValue: 59
        suffix: "m"

        visible: showMinutes

        value: d.minutes
        onValueChanged: {
            d.minutes = value
        }
    }
    SpinBox {
        maximumValue: 59
        suffix: "s"

        visible: showSeconds

        value: d.seconds
        onValueChanged: {
            d.seconds = value
        }
    }
}
