{
  description = "Open pdks";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

		# download.sh https://github.com/efabless/skywater-pdk-libs-sky130_fd_pr /build/open_pdks-1.0.470/sources/sky130_fd_pr
		efabless_skywater-pdk-libs-sky130_fd_pr = {
			url = "github:efabless/skywater-pdk-libs-sky130_fd_pr";
			flake = false;
		};
		# download.sh https://github.com/efabless/skywater-pdk-libs-sky130_fd_io ../sources/sky130_fd_io
		efabless_skywater-pdk-libs-sky130_fd_io = {
			url = "github:efabless/skywater-pdk-libs-sky130_fd_io";
			flake = false;
		};
		# download.sh https://github.com/efabless/skywater-pdk-libs-sky130_fd_sc_hd /build/open_pdks-1.0.470/sources/sky130_fd_sc_hd
		efabless_skywater-pdk-libs-sky130_fd_sc_hd = {
			url = "github:efabless/skywater-pdk-libs-sky130_fd_sc_hd";
			flake = false;
		};
		# download.sh https://github.com/PaulSchulz/sky130_pschulz_xx_hd ../sources/sky130_ml_xx_hd
		PaulSchulz_sky130_pschulz_xx_hd = {
			url = "github:PaulSchulz/sky130_pschulz_xx_hd";
			flake = false;
		};
		# download.sh https://github.com/StefanSchippers/xschem_sky130 ../sources/xschem_sky130
		StefanSchippers_xschem_sky130 = {
			url = "github:StefanSchippers/xschem_sky130";
			flake = false;
		};
		# download.sh https://github.com/efabless/sky130_klayout_pdk ../sources/klayout_sky130
		efabless_sky130_klayout_pdk = {
			url = "github:efabless/sky130_klayout_pdk";
			flake = false;
		};
		# download.sh https://github.com/efabless/mpw_precheck ../sources/precheck_sky130
		efabless_mpw_precheck = {
			url = "github:efabless/mpw_precheck";
			flake = false;
		};
		
  };

  outputs = { self, nixpkgs, efabless_skywater-pdk-libs-sky130_fd_pr, efabless_skywater-pdk-libs-sky130_fd_io, efabless_skywater-pdk-libs-sky130_fd_sc_hd, PaulSchulz_sky130_pschulz_xx_hd, StefanSchippers_xschem_sky130, efabless_sky130_klayout_pdk, efabless_mpw_precheck }: {

    packages.x86_64-linux.open_pdks =
		  let pkgs = import nixpkgs {
						system = "x86_64-linux";
					};
		  in pkgs.stdenv.mkDerivation rec {
				pname = "open_pdks";
				version = "1.0.470";
				src = pkgs.fetchurl {
					url = "http://opencircuitdesign.com/open_pdks/archive/open_pdks-${version}.tgz";
					sha256 = "sha256-Q8Tiy5569XWTpme9V234CrJjaJ3SpgaEDSdjkJOafHk=";
				};
				# nativeBuildInputs = [pkgs.breakpointHook];
				nativeBuildInputs = [ pkgs.python3 pkgs.magic-vlsi pkgs.git ];

				enableParallelBuildung = true;

				git_efabless_skywater_pdk_libs_sky130_fd_pr = efabless_skywater-pdk-libs-sky130_fd_pr;
				git_efabless_skywater_pdk_libs_sky130_fd_io = efabless_skywater-pdk-libs-sky130_fd_io;
				git_efabless_skywater_pdk_libs_sky130_fd_sc_hd = efabless_skywater-pdk-libs-sky130_fd_sc_hd;
				git_PaulSchulz_sky130_pschulz_xx_hd = PaulSchulz_sky130_pschulz_xx_hd;
				git_StefanSchippers_xschem_sky130 = StefanSchippers_xschem_sky130;
				git_efabless_sky130_klayout_pdk = efabless_sky130_klayout_pdk;
				git_efabless_mpw_precheck = efabless_mpw_precheck;

				configureFlags = [
					"--prefix=\${out}"
					"--datarootdir=\${out}"
					"--enable-sky130-pdk"
					"--enable-primitive-sky130"
					"--disable-sc-hs-sky130"
					"--disable-sc-ms-sky130"
					"--disable-sc-ls-sky130"
					"--disable-sc-lp-sky130"
					"--enable-sc-hd-sky130"
					"--disable-sc-hdll-sky130"
					"--disable-sc-hvl-sky130"
					"--disable-gf180mcu-pdk"
				];

				postPatch = ''
					patchShebangs scripts/*
					patchShebangs common/*
					patchShebangs sky130/custom/*
				'';
				patches = [
					./download.sh.patch
				];

			};

    packages.x86_64-linux.default = self.packages.x86_64-linux.open_pdks;

  };
}
