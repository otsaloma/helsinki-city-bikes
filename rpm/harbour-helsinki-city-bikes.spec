# Prevent brp-python-bytecompile from running.
%define __os_install_post %{___build_post}

# "Harbour RPM packages should not provide anything".
%define __provides_exclude_from ^%{_datadir}/.*$

Name: harbour-helsinki-city-bikes
Version: 0.0.1
Release: 1
Summary: HSL city bike stations and their real-time occupancy
License: GPLv3+
URL: https://github.com/otsaloma/helsinki-city-bikes
Source: %{name}-%{version}.tar.xz
BuildArch: noarch
BuildRequires: make
Requires: libsailfishapp-launcher
Requires: pyotherside-qml-plugin-python3-qt5 >= 1.2
Requires: qt5-plugin-geoservices-nokia
Requires: qt5-qtdeclarative-import-location
Requires: qt5-qtdeclarative-import-positioning >= 5.2
Requires: sailfishsilica-qt5

%description
View the locations of city bike stations and their occupancy.

Included are all Helsinki Region Transport (HSL) city bike stations.
Data is from the Digitransit HSL API and should be real-time.

%prep
%setup -q

%install
make DESTDIR=%{buildroot} PREFIX=/usr install

%files
%defattr(-,root,root,-)
%{_datadir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/*/apps/%{name}.png
