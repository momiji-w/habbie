{
  description = "Habbie flake for devenv on NixOS";

  inputs.nixpkgs = {
    url = "github:NixOS/nixpkgs";
  };
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.flake-compat = {
    url = "github:edolstra/flake-compat";
    flake = false;
  };
  inputs.android-nixpkgs = {
	  url = "github:tadfisher/android-nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, android-nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          config.android_sdk.accept_license = true;
        };
		android-sdk = android-nixpkgs.sdk.${system} (
          sdkPkgs: with sdkPkgs; [
            cmdline-tools-latest
            build-tools-34-0-0
			build-tools-33-0-2
			build-tools-30-0-3
            platform-tools
			platforms-android-28
            platforms-android-29
            platforms-android-30
            platforms-android-31
            platforms-android-32
            platforms-android-33
            platforms-android-34
			# emulator
          ]
        );
      in {
        devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              flutter
			  jdk17
			  android-sdk
            ];
            ANDROID_HOME = "${android-sdk}/share/android-sdk";
			JAVA_HOME = pkgs.jdk17;

			GRADLE_USER_HOME = "~/.gradle";
            GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${android-sdk}/share/android-sdk/build-tools/34.0.0/aapt2";
			shellHook = ''
			flutter config --android-sdk $ANDROID_HOME
			'';
          };
      });
}
