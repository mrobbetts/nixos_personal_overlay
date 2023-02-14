{ lib
, stdenv
, fetchFromGitLab
, pkgs
, buildNpmPackage
, python3
, openssh
, ffmpeg
, nodejs
, tree
, jq
}:


buildNpmPackage rec {
  pname = "shinobi";
  version = "0.9";

  # Note; the dev branch doesn't contain the default sqlite and conf files and such, which we
  #       are piggy-backing from. So, use the master branch and pull in pactches as needed.
  src = fetchFromGitLab {
    owner = "Shinobi-Systems";
    repo = "Shinobi";
    rev = "07584db326ba8077f448a8383cc677469a769cbf";
    sha256 = "sha256-u0+xUoz78CtUTIHF2umnxiNrwuS0FZsfUkY0XjMpHNU=";
  };

  buildInputs = [
    openssh
  ];

  nativeBuildInputs = [
    nodejs
    ffmpeg
    openssh
    python3
    tree
    jq
  ];

  # Temporarily, we need to inject sqlite3 into the dependencies ourselves.
  # 
  # We:
  # 1. Add sqlite3 dependency (if not installed, Shinobi will try to npm-install it at runtime when used).
  #   - Add sqlite3 into package.json by hand (found a version number by messing with `npm install`).
  #   - Update `package-lock.json` with the command `npm install --package-lock-only sqlite3`.
  #   - Generate diff simply with `git diff > ~/package.json-files.patch`.
  # 2. Pull in patch from dev branch to make conf location customizable.
  # 3. Duplicate the above logic by hand to make super-user conf location customizable.
  # 4. Print conf and super file locations to log. Optional, really, now it's working.
  patches = [
    patches/package.json-files.patch
    patches/superLocation.patch
    patches/consoleLog.patch
  ];

  dontNpmBuild = true;

  npmDepsHash = "sha256-0VA1xLzyHyg/GFs+7TxSymps3wFXcVVaLt+/3QV8mAg=";
#  npmDepsHash = lib.fakeHash;

  makeCacheWritable = true;

  # The prepack script runs the build script, which we'd rather do in the build phase.
  npmPackFlags = [ "--ignore-scripts" ];
  npmFlags = [ "--legacy-peer-deps" ];
}
