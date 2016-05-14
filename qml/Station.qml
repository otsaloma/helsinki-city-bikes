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
import QtLocation 5.0
import Sailfish.Silica 1.0

MapQuickItem {
    id: station
    anchorPoint.x: bubble.width/2
    anchorPoint.y: arrow.y
    sourceItem: Item {
        Rectangle {
            id: bubble
            anchors.bottom: bar.bottom
            anchors.left: bikesText.left
            anchors.margins: -Theme.paddingSmall
            anchors.right: capacityText.right
            anchors.top: separator.top
            color: "#bb000000"
        }
        Text {
            id: separator
            color: "white"
            font.family: "sans-serif"
            font.pixelSize: 18
            font.weight: Font.DemiBold
            text: "/"
        }
        Text {
            id: bikesText
            anchors.baseline: separator.baseline
            anchors.right: separator.left
            anchors.rightMargin: 2
            color: "white"
            font.family: "sans-serif"
            font.pixelSize: 18
            font.weight: Font.DemiBold
            horizontalAlignment: Text.AlignRight
            text: station.bikes
            width: Math.max(13, contentWidth)
        }
        Text {
            id: capacityText
            anchors.baseline: separator.baseline
            anchors.left: separator.right
            anchors.leftMargin: 2
            color: "white"
            font.family: "sans-serif"
            font.pixelSize: 18
            font.weight: Font.DemiBold
            horizontalAlignment: Text.AlignLeft
            text: station.capacity
            width: Math.max(13, contentWidth)
        }
        Rectangle {
            id: bar
            anchors.left: bubble.left
            anchors.leftMargin: Theme.paddingSmall
            anchors.top: capacityText.bottom
            anchors.topMargin: Theme.paddingSmall
            color: Theme.highlightColor
            height: Theme.paddingSmall
            width: Math.floor(station.bikes/station.capacity *
                              (bubble.width - 2*Theme.paddingSmall));

        }
        Image {
            id: arrow
            anchors.horizontalCenter: bubble.horizontalCenter
            anchors.top: bubble.bottom
            // Try to avoid a stripe between bubble and arrow.
            anchors.topMargin: -0.5
            source: "icons/bubble-arrow.png"
        }
    }
    property int bikes: 0
    property int capacity: 0
    property string uid: ""
}
