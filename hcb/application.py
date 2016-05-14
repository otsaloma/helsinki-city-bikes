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

"""Show real-time information about city bikes and stations."""

import hcb

__all__ = ("Application",)


class Application:

    """Show real-time information about city bikes and stations."""

    def __init__(self):
        """Initialize an :class:`Application` instance."""
        self._tracker = hcb.Tracker("hsl")

    def list_stations(self):
        """Return a list of available stations."""
        return self._tracker.list_stations()

    def quit(self):
        """Quit the application."""
        hcb.http.pool.terminate()
