final: prev: {
  filebrowser-quantum = prev.unstable.filebrowser-quantum.overrideAttrs (old: rec {
    version = "1.3.3-stable";
    src = prev.fetchFromGitHub {
      owner = "gtsteffaniak";
      repo = "filebrowser";
      tag = "v${version}";
      hash = "sha256-Q4TtC5x/nAbeZzICH9R9LBqe/8tbQOFR8vAImhQ5sYM=";
    };
    vendorHash = "";
  });

}
