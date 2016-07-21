/* -*- coding: utf-8-unix -*-
 *
 * Copyright (C) 2016 Osmo Salomaa
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.0
import QtPositioning 5.3
import Sailfish.Silica 1.0
import "."

ApplicationWindow {
    id: app
    allowedOrientations: defaultAllowedOrientations
    cover: Cover { id: cover }
    initialPage: Page {
        id: page
        allowedOrientations: app.defaultAllowedOrientations
        Map { id: map }
    }
    property bool running: applicationActive || cover.active
    PositionSource { id: gps }
    Python { id: py }
    Component.onDestruction: {
        py.ready && py.call_sync("hcb.app.quit", []);
    }
    function getIcon(name) {
        // Return path to icon suitable for user's screen,
        // finding the closest match to Theme.pixelRatio.
        var ratios = [1.00, 1.25, 1.50, 1.75, 2.00];
        var minIndex = -1, minDiff = 1000;
        for (var i = 0; i < ratios.length; i++) {
            var diff = Math.abs(Theme.pixelRatio - ratios[i]);
            minIndex = diff < minDiff ? i : minIndex;
            minDiff = Math.min(minDiff, diff);
        }
        var ratio = ratios[minIndex].toFixed(2);
        return "icons/%1@%2.png".arg(name).arg(ratio);
    }
}
