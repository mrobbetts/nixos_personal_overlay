# Quick all-packages for personal overlay.

self: pkgs:

with pkgs;

{
  mdnsreflector = callPackage ./mdnsreflector {};
  shinobi       = callPackage ./shinobi {};
}
