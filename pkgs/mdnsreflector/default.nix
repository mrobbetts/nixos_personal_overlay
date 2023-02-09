{ lib, stdenv, fetchFromGitHub, cmake, boost }:

stdenv.mkDerivation rec {
  #name = "libfort-${version}";
  name = "mdnsreflector";
  #version = "0.3.1";
  version = "0.11";

  src = fetchFromGitHub {
    owner = "mrobbetts";
    repo = "mdnsreflector";
    rev = "c5815b3e85fec1bd5acbfca6064e6a282f92cad5";
    sha256 = "sha256-VoOHZyhWQux6OjmGGh9N1pmSl36+QokF4QHQyVwxnCU=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ boost ];

# meta = with stdenv.lib; {
  meta = with lib; {
    homepage = "https://github.com/mrobbetts/mndsreflector";
    description = "An mDNS reflector made with Boost.Asio";
    license = licenses.gpl3;
    platforms = with platforms; linux ++ darwin;
    maintainers = [
      {
        name = "Matthew Robbetts";
        email = "mrobbetts@gmail.com";
      }
    ];
  };
}

