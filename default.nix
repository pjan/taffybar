let

  mkTaffybar = pkgs: haskellPkgs:
    let
      myTaffybarEnv = haskellPkgs.ghcWithPackages (self: [ haskellPkgs.my-taffybar ]);
    in pkgs.stdenv.mkDerivation {
      name = "taffybar-with-packages";

      nativeBuildInputs = [ pkgs.makeWrapper ];
      buildCommand = ''
        mkdir -p $out/bin
        makeWrapper ${myTaffybarEnv}/bin/my-taffybar-exe $out/bin/taffybar \
          --set NIX_GHC "${myTaffybarEnv}/bin/ghc" \
          --prefix PATH : "${pkgs.htop}/bin"
      '';

      meta = {
        platforms = pkgs.lib.platforms.unix;
      };
    };

in import ./nix/package.nix {
    packageName = "my-taffybar";

    root = ./.;

    ghcVersion = "ghc822";

    withHoogle = true;

    profiling = false;

    shellDepends = pkgs: haskellPkgs: [
      haskellPkgs.hpack
      haskellPkgs.ghcid
      haskellPkgs.stylish-haskell
    ];

    pinnedPkgsPath = ./nix/nixpkgs.json;

    overrides = pkgs: {
    };

    haskellOverrides = {

      skipTests = [
        "ghc-mod"
        "hasktags"
      ];

      jailbreak = [
        "cabal-helper"
        "ghc-mod"
        "taffybar"
      ];

      skipHaddock = [
        "cabal-helper"
        "ghc-mod"
      ];

      justStaticExecutables = [
        "ghc-mod"
        "brittany"
        "hpack"
      ];

      path = ./nix/overrides/haskell;

      manual = pkgs: self: super: {
        gi-dbusmenugtk3 = pkgs.haskell.lib.addPkgconfigDepend super.gi-dbusmenugtk3 pkgs.gtk3;
        taffybar = super.taffybar.overrideDerivation (drv: {
          strictDeps = true;
          src = pkgs.fetchFromGitHub {
            owner = "taffybar";
            repo = "taffybar";
            rev = "v2.1.1";
            sha256 = "12g9i0wbh4i66vjhwzcawb27r9pm44z3la4693s6j21cig521dqq";
          };
        });
      };

    };

    results = {
      "taffybar" = mkTaffybar;
    };

}
