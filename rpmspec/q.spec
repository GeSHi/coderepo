%define	name	AfterStep
%define	version	2.2.9
%define	release	%mkrel 2
%define	major	0
%define	libname	%mklibname %{name} %{major}
%define	libname_devel	%mklibname %{name} -d
%define	staticname	%mklibname %{name} -s -d
%define	ltitle	AfterStep Window Manager

Summary:	%{ltitle}
Name:		%{name}
Version:	%{version}
Release:	%{release}
License:	GPLv2+
Group:		Graphical desktop/Other
URL:		http://www.afterstep.org/

Source:		ftp://ftp.afterstep.org/stable/AfterStep-%version.tar.xz
Source1:	%{name}-mdkconf.tar.xz
Source3:	%{name}.png.xz
Source4:	%{name}32.png.xz
Source5:	%{name}48.png.xz
Patch2:		%{name}-1.8.9-menuname.patch
Patch3:         %{name}.MenuKey.patch

BuildRoot:	%{_tmppath}/%{name}-%{version}-buildroot
Requires:	desktop-common-data xli 
# Requires: 	%libname = %{version}-%{release}
BuildRequires:	X11-devel
BuildRequires:  libpng-devel
BuildRequires:	libtiff-devel
BuildRequires:   gtk2-devel

%description
AfterStep is a Window Manager for X which started by emulating the NEXTSTEP
look and feel, but which has been significantly altered according to the
requests of various users. Many adepts will tell you that NEXTSTEP is not
only the most visually pleasant interface, but also one of the most functional
and intuitive out there. AfterStep aims to incorporate the advantages of the
NEXTSTEP interface, and add additional useful features.

The developers of AfterStep have also worked very hard to ensure stability and
a small program footprint. Without giving up too many features, AfterStep still
works nicely in environments where memory is at a premium.

%package -n %libname
Summary:	Libraries needed by AfterStep
Group:		Graphical desktop/Other
Provides:	lib%name = %version-%release
 
%description -n %libname
AfterStep is a Window Manager for X which started by emulating the NEXTSTEP
look and feel, but which has been significantly altered according to the
requests of various users. Many adepts will tell you that NEXTSTEP is not
only the most visually pleasant interface, but also one of the most functional
and intuitive out there. AfterStep aims to incorporate the advantages of the
NEXTSTEP interface, and add additional useful features.

The developers of AfterStep have also worked very hard to ensure stability and
a small program footprint. Without giving up too many features, AfterStep still
works nicely in environments where memory is at a premium.

This package contains libraries needed by AfterStep package.

%package -n %libname_devel
Summary:	Devel files needed to build applications based on AfterStep
Group:		Development/C
Provides:	%name-devel lib%name-devel
Requires:	%libname = %version-%release
Obsoletes:	%mklibname -d %name 0

%description -n %libname_devel
AfterStep is a Window Manager for X which started by emulating the NEXTSTEP
look and feel, but which has been significantly altered according to the
requests of various users. Many adepts will tell you that NEXTSTEP is not
only the most visually pleasant interface, but also one of the most functional
and intuitive out there. AfterStep aims to incorporate the advantages of the
NEXTSTEP interface, and add additional useful features.

The developers of AfterStep have also worked very hard to ensure stability and
a small program footprint. Without giving up too many features, AfterStep still
works nicely in environments where memory is at a premium.

This package contains devel files needed to build applications based on
AfterStep.

%package -n %staticname
Summary:	Static library for AfterStep
Group:		Development/C
Provides:	%name-static-devel lib%name-devel
Requires:	%libname_devel = %version-%release

%description -n %staticname
This package contains the static library for AfterStep.

%prep
%setup -q

# LMDK patches
%patch2 -p1
%patch3 -p1
#patch4 -p0 -b .configshared

%build
#rm -f config.status
#export CFLAGS="%optflags"
#export CCFLAGS="%optflags"

%configure2_5x	\
                --enable-sharedlibs \
		--with-imageloader="xsetbg" \
		--with-helpcommand="xterm -fn 9x15 -e man" \
		--with-desktops=1 \
		--with-deskgeometry=1x1 \
		--enable-different-looknfeels \
		--enable-i18n \
		--enable-savewindows \
		--enable-texture \
		--enable-shade \
		--enable-virtual \
		--enable-saveunders \
		--enable-windowlist \
		--enable-availability \
		--enable-shaping \
		--enable-xinerama \
		--enable-script \
		--with-xpm \
		--with-jpeg \
		--with-png \
                --with-ttf \
                --with-tiff

%make

if [ -x /usr/bin/sgml2html ]; then sgml2html doc/afterstep.sgml; fi


%install
rm -rf $RPM_BUILD_ROOT
%makeinstall_std


# LMDK icons
install -m644 %SOURCE4 -D $RPM_BUILD_ROOT%{_iconsdir}/%{name}.png
install -m644 %SOURCE3 -D $RPM_BUILD_ROOT%{_miconsdir}/%{name}.png
install -m644 %SOURCE5 -D $RPM_BUILD_ROOT%{_liconsdir}/%{name}.png

# Not needed with Mandriva menu
rm -fr $RPM_BUILD_ROOT/%{__datadir}/afterstep/start/Applications/

install -d $RPM_BUILD_ROOT%{_sysconfdir}/X11/wmsession.d
cat > $RPM_BUILD_ROOT%{_sysconfdir}/X11/wmsession.d/15%{name} << EOF
NAME=%{name}
ICON=%{name}.png
EXEC=%{_bindir}/afterstep
DESC=A NeXt like Window-Manager
SCRIPT:
exec %{_bindir}/afterstep
EOF

#if 0
%multiarch_binaries %buildroot%_bindir/afterimage-config
%multiarch_binaries %buildroot%_bindir/afterstep-config
#endif

%clean
rm -rf $RPM_BUILD_ROOT

%post
%make_session
#if %mdkversion < 200900
#update_menus
#post -n %libname -p /sbin/ldconfig
#endif

%postun
%make_session
#if %mdkversion < 200900
#clean_menus
#postun -n %libname -p /sbin/ldconfig
#endif

%files
%defattr(-,root,root)
%config(noreplace) %{_sysconfdir}/X11/wmsession.d/15%{name}
%doc COPYRIGHT ChangeLog NEW README TEAM UPGRADE doc/languages doc/licences
%{_iconsdir}/%{name}.png
%{_miconsdir}/%{name}.png
%{_liconsdir}/%{name}.png
%{_bindir}/*
%{_mandir}/man1/*
%{_mandir}/man3/*
%dir %{_datadir}/afterstep
%{_datadir}/afterstep/*
%_datadir/xsessions/AfterStep.desktop
#_datadir/gnome/wm-properties/AfterStep.desktop

%files -n %libname
%defattr(-,root,root,-)
%{_libdir}/*.so.%major
%{_libdir}/*.so.%major.*

%files -n %libname_devel
%defattr(-,root,root,-)
%{_libdir}/*.so
%dir %_includedir/libAfterConf
%_includedir/libAfterConf/*.h
%dir %_includedir/libAfterStep
%_includedir/libAfterStep/*.h
%_includedir/libASGTK
%_includedir/libAfterImage/*.h

%files -n %staticname
%defattr(-,root,root,-)
%{_libdir}/*.a

%changelog
* Sat Oct 10 2009 mdawkins <mattydaw@gmail.com> 2.2.9-2-unity2009
- rebuild for libjpeg

* Wed Jul 08 2009 mdawkins <mattydaw@gmail.com> 2.2.9-1-unity2009
- imported pkg
- new version 4.2.9
- recompressed with xz
- split out static pkg
- removed epoch

* Thu Jun 12 2008 Pixel <pixel@mandriva.com> 4:2.2.4-2mdv2009.0
+ Revision: 218439
- rpm filetriggers deprecates update_menus/update_scrollkeeper/update_mime_database/update_icon_cache/update_desktop_database/post_install_gconf_schemas
- do not call ldconfig in %%post/%%postun, it is now handled by filetriggers

  + Thierry Vignaud <tvignaud@mandriva.com>
    - drop old menu

* Mon Jan 07 2008 Funda Wang <fundawang@mandriva.org> 4:2.2.4-2mdv2008.1
+ Revision: 146266
- New devel package policy
- fix requires on Mandriva_desk

* Thu Dec 20 2007 Olivier Blin <oblin@mandriva.com> 4:2.2.4-1mdv2008.1
+ Revision: 135819
- restore BuildRoot

  + Thierry Vignaud <tvignaud@mandriva.com>
    - kill re-definition of %%buildroot on Pixel's request
    - buildrequires X11-devel instead of XFree86-devel
    - s/Mandrake/Mandriva/


* Fri Dec 01 2006 Nicolas Lécureuil <neoclust@mandriva.org> 2.2.4-1mdv2007.0
+ Revision: 89500
- New version 2.2.4
