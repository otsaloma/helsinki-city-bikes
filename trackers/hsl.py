# -*- coding: utf-8 -*-

# Copyright (C) 2016 Osmo Salomaa
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

"""
City bikes in Helsinki.

http://www.hsl.fi/kaupunkipyörät
"""

import hcb
import time


class Tracker:

    def __init__(self):
        """Initialize a :class:`Tracker` instance."""
        self._stations = []
        self._utime = -1

    @hcb.util.api_query(fallback=[])
    def list_stations(self):
        """Return a list of bike stations and their occupancy."""
        # Avoid making requests too often.
        if time.time() - self._utime < 60:
            return self._stations
        url = "http://api.digitransit.fi/routing/v1/routers/hsl/bike_rental"
        stations = hcb.http.request_json(url)
        stations = [dict(
            id=station["id"],
            name=station["name"],
            x=station["x"],
            y=station["y"],
            bikes=station["bikesAvailable"],
            capacity=station["bikesAvailable"]+station["spacesAvailable"],
        ) for station in stations["stations"]]
        self._stations = stations
        self._utime = time.time()
        return stations
