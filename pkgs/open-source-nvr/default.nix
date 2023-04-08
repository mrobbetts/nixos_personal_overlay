{ lib
, stdenv
, fetchFromGitHub
, pkgs
, openssh
, ffmpeg
, nodejs
, nodePackages
, buildNpmPackage
, tree
}:



buildNpmPackage rec {
  pname = "open-source-nvr";
  version = "0.9";

  src = fetchFromGitHub {
    owner = "khowling";
    repo = "open-source-nvr";
    rev = "1f92c75a8e35304c895ed2cead511a2506f058cd";
    sha256 = "sha256-qktpxMQ9rNX/nvKZBDfqk7PO1uayrzJ5XpgbJ5j0atM=";
  };
/*
  buildInputs = [
    openssh
  ];
*/

  nativeBuildInputs = [
#    nodejs
#    ffmpeg
#    openssh
#    python3
    tree
  ];
/*
  prePatch = ''
    #cp sql/shinobi.sample.sqlite shinobi.sqlite
    cp super.sample.json super.json
    ls -l
  '';
*/
  # Temporarily, we need to inject sqlite3 into the dependencies.
  # 
  # We:
  # - Added sqlite3 into package.json by hand (found a version number by messing with `npm install`).
  # - Updated `package-lock.json` with the command `npm install --package-lock-only sqlite3`.
  # - Generate diff simply with `git diff > ~/package.json-files.patch`.
#  patches = [
#    patches/package.json.patch
#  ];
/*
  patchPhase =
    let packageText = lib.readFile ./package.json;
    in
  ''
    tree -L 1
    cat '${packageText}'
    echo '${packageText}' > package.json
  '';
*/

  postBuild = ''
    cat package.json
    tree -L 2
    npm i
    npx tsc
    npm run-script build
  '';

/*
  postInstall =
    let confText = lib.readFile ./conf.json;
    #let confFile = toString ./conf.json;
    in
  ''
    echo "Copying conf.json to $out/lib/node_modules/shinobi/"

    # Copy our fixed-up config json into place.
    echo '${confText}' > $out/lib/node_modules/shinobi/conf.json

    cat $out/lib/node_modules/shinobi/conf.json

    # Copy the default sqlite database file into place.
    cp $out/lib/node_modules/shinobi/sql/shinobi.sample.sqlite $out/lib/node_modules/shinobi/shinobi.sqlite
    tree -L 4 $out

    cat $out/lib/node_modules/shinobi/package.json
  '';
*/
  dontNpmBuild = true;

  npmDepsHash = "sha256-tyOr51J8ac0XJWXg44M3VG0xu4EFZcfuwyMv+gVK0sM=";
#  npmDepsHash = lib.fakeHash;

  makeCacheWritable = true;

  # The prepack script runs the build script, which we'd rather do in the build phase.
  npmPackFlags = [ "--ignore-scripts" ];
  npmFlags = [ "--legacy-peer-deps" ];
}
