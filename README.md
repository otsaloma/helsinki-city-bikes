Helsinki City Bikes
=====================

[![Build Status](https://travis-ci.org/otsaloma/helsinki-city-bikes.svg)](
https://travis-ci.org/otsaloma/helsinki-city-bikes)

Helsinki City Bikes is an application for Sailfish OS to view the
locations of Helsinki Region Transport (HSL) [city bike][1] stations and
their real-time occupancy. It uses the Digitransit HSL API and should
display data matching the [official web interface][2].

[1]: https://www.hsl.fi/kaupunkipyörät
[2]: https://dev.hsl.fi/kaupunkipyorat/

Helsinki City Bikes is free software released under the GNU General
Public License (GPL), see the file `COPYING` for details.

For testing purposes you can just run `/usr/lib/qt5/bin/qmlscene
qml/helsinki-city-bikes.qml`. For installation, you probably want an
RPM-package; for instructions on building that, see relevant parts from
the file `RELEASING.md`.
