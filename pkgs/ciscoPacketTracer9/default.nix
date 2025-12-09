{
  stdenv,
  lib,
  dpkg,
  autoPatchelfHook,
  makeWrapper,
  alsa-lib,
  dbus,
  expat,
  fontconfig,
  freetype,
  glib,
  glibc,
  libsForQt5,
  libglvnd,
  libpulseaudio,
  libxkbcommon,
  libxml2,
  libxslt,
  nspr,
  nss,
  xorg,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "ciscoPacketTracer9";
  version = "9.0.0";

  src = ./CiscoPacketTracer_900_Ubuntu_64bit.deb;

  nativeBuildInputs = [
    autoPatchelfHook
    dpkg
    makeWrapper
  ];

  buildInputs = [
    alsa-lib
    dbus
    expat
    fontconfig
    freetype
    glib
    glibc
    libglvnd
    libpulseaudio
    libsForQt5.qt5.qtwebview
    libsForQt5.qt5.qtwebengine
    libxkbcommon
    libxml2
    libxslt
    nspr
    nss
    xorg.libX11
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXtst
    xorg.libxcb
    zlib
  ];

  unpackPhase = ''
    dpkg-deb -x $src .
  '';

  installPhase = ''
    mkdir -p $out/{bin,share/applications}
    cp -r opt $out/opt

    ln -s $out/opt/pt/packettracer $out/bin/${pname}

    install -Dm644 opt/pt/packettracer.desktop $out/share/applications/${pname}.desktop
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace "/opt/pt/packettracer" "${pname}"
  '';

  meta = with lib; {
    description = "Cisco Packet Tracer 9";
    homepage = "https://www.netacad.com/";
    license = licenses.unfree;
    platforms = platforms.linux;
    mainProgram = pname;
  };
}
