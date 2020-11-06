/********************************************
**
** Copyright 2016 JustCode Justyna Kulinska
**
** This file is part of Resto.
**
** Resto is free software; you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation; either version 2 of the License, or
** any later version.
**
** Resto is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with Resto; if not, write to the Free Software
** Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
**
********************************************/

import QtQuick 2.12
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
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

    CustomSpinBox {
        id: hoursSpin

        Layout.preferredWidth: maxWidth

        to: 23
        from: d.minHours
        suffix: "h"
        maxCharCount: 4

        visible: showHours

        value: d.hours
        onValueChanged: {
            d.hours = value
        }
    }
    CustomSpinBox {
        id: minutesSpin

        Layout.preferredWidth: maxWidth

        to: 59
        from: (hoursSpin.value > d.minHours)
                      ? 0 : d.minMinutes
        suffix: "m"
        maxCharCount: 4

        visible: showMinutes

        value: d.minutes
        onValueChanged: {
            d.minutes = value
        }
    }
    CustomSpinBox {        
        Layout.preferredWidth: maxWidth

        to: 59
        from: (hoursSpin.value > d.minHours ||
                       minutesSpin.value > d.minMinutes)
                      ? 0 : d.minSeconds

        suffix: "s"
        maxCharCount: 4

        visible: showSeconds

        value: d.seconds
        onValueChanged: {
            d.seconds = value
        }
    }
}
