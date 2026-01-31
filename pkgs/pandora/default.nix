{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  makeBinaryWrapper,
  wayland,
  openssl,
  libX11,
  libxkbcommon,
  vulkan-loader,
  dbus,
  libxcb,
}:

rustPlatform.buildRustPackage {
  pname = "pandora-launcher";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "Moulberry";
    repo = "PandoraLauncher";
    rev = "master";
    hash = "sha256-rHUJjNlr9HVty5cOHml2xNhOL7FQUY+j66aMptfvwB8=";
  };

  cargoHash = "sha256-eLvQdzvm3ZFMDStMwNgjf4lTywYeTV3ZD8m8hxZtUdY=";

  nativeBuildInputs = [
    pkg-config
    makeBinaryWrapper
  ];

  buildInputs = [
    openssl
    libX11
    libxkbcommon
    wayland
    dbus
    libxcb
  ];

  postInstall = ''
    wrapProgram $out/bin/pandora_launcher \
    --prefix LD_LIBRARY_PATH : ${
      lib.makeLibraryPath [
        vulkan-loader
        libX11
        libxkbcommon
        wayland
      ]
    }
  '';

  meta = {
    description = "Pandora is a modern Minecraft launcher that balacnes ease-of-use with powerful instance management features";
    homepage = "https://github.com/Moulberry/PandoraLauncher";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "pandora_launcher";
  };
}
