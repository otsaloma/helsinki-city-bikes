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
import QtPositioning 5.3
import "."

Map {
    id: map
    anchors.fill: parent
    center: QtPositioning.coordinate(60.169, 24.941)
    focus: true
    gesture.enabled: true
    minimumZoomLevel: 6
    plugin: MapPlugin {}

    property bool ready: false
    property bool showMenuButton: true
    property var  stations: []
    property var  utime: -1
    property real zoomLevelPrev: 8

    Behavior on center {
        CoordinateAnimation {
            duration: 500
            easing.type: Easing.InOutQuad
        }
    }

    MenuButton {}
    PositionMarker {}

    Timer {
        // XXX: For some reason we need to do something to trigger
        // a redraw to avoid only a part of tiles being displayed
        // right at start before any user panning or zooming.
        id: patchTimer
        interval: 1000
        repeat: true
        running: map.ready && app.running
        triggeredOnStart: true
        property int timesRun: 0
        onTriggered: {
            map.pan(+2, -2);
            map.pan(-2, +2);
            patchTimer.running = timesRun++ < 5;
        }
    }

    Timer {
        id: updateTimer
        interval: 5000
        repeat: true
        running: py.ready && map.ready && app.running
        triggeredOnStart: true
        onTriggered: map.updateStationsMaybe();
    }

    MouseArea {
        anchors.fill: parent
        onDoubleClicked: map.centerOnPosition();
    }

    Component.onCompleted: {
        // Use a daytime gray street map if available.
        // Needed properties available since Sailfish OS 1.1.0.38.
        for (var i = 0; i < map.supportedMapTypes.length; i++) {
            var type = map.supportedMapTypes[i];
            if (type.style  === MapType.GrayStreetMap &&
                type.mobile === true &&
                type.night  === false)
                map.activeMapType = type;
        }
        map.center = QtPositioning.coordinate(60.169, 24.941);
        map.centerOnPosition();
        gps.onInitialCenterChanged.connect(map.centerOnPosition);
        // XXX: Must set zoomLevel in onCompleted.
        // http://bugreports.qt-project.org/browse/QTBUG-40779
        map.setZoomLevel(14);
        map.ready = true;
    }

    gesture.onPinchFinished: {
        // Round piched zoom level to avoid fuzziness.
        if (map.zoomLevel < map.zoomLevelPrev) {
            map.zoomLevel % 1 < 0.75 ?
                map.setZoomLevel(Math.floor(map.zoomLevel)):
                map.setZoomLevel(Math.ceil(map.zoomLevel));
        } else if (map.zoomLevel > map.zoomLevelPrev) {
            map.zoomLevel % 1 > 0.25 ?
                map.setZoomLevel(Math.ceil(map.zoomLevel)):
                map.setZoomLevel(Math.floor(map.zoomLevel));
        }
    }

    Keys.onPressed: {
        // Allow zooming with plus and minus keys on the emulator.
        (event.key === Qt.Key_Plus)  && map.setZoomLevel(map.zoomLevel+1);
        (event.key === Qt.Key_Minus) && map.setZoomLevel(map.zoomLevel-1);
    }

    function addStation(props) {
        // Add a new station marker to the map.
        var component = Qt.createComponent("Station.qml");
        var item = component.createObject(map);
        item.uid = props.id;
        item.coordinate = QtPositioning.coordinate(props.y, props.x);
        item.bikes = props.bikes;
        item.capacity = props.capacity;
        map.stations.push(item);
        map.addMapItem(item);
    }

    function centerOnPosition() {
        // Center map on current position.
        map.center = QtPositioning.coordinate(
            gps.position.coordinate.latitude,
            gps.position.coordinate.longitude);

    }

    function setZoomLevel(zoom) {
        // Set the current zoom level.
        map.zoomLevel = zoom;
        map.zoomLevelPrev = zoom;
    }

    function updateStation(props) {
        // Update station marker or add if missing.
        for (var i = 0; i < map.stations.length; i++) {
            if (map.stations[i].uid !== props.id) continue;
            var coord = QtPositioning.coordinate(props.y, props.x);
            map.stations[i].coordinate = coord;
            map.stations[i].bikes = props.bikes;
            map.stations[i].capacity = props.capacity;
            return;
        }
        map.addStation(props);
    }

    function updateStations() {
        // Fetch data from Python backend and update station markers.
        if (!py.ready) return;
        py.call("hcb.app.list_stations", [], function(results) {
            map.utime = Date.now();
            for (var i = 0; i < results.length; i++)
                updateStation(results[i]);
        });
    }

    function updateStationsMaybe() {
        // Update stations markers if not updated in a while.
        if (Date.now() - map.utime > 60000)
            map.updateStations();
    }

}
