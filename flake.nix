{
  description = "ELT Pipeline: HCL AST Topology & Security Regression Warehouse";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        pythonEnv = pkgs.python3.withPackages (ps: with ps; [
          requests
          graphql-core
          networkx
          tree-sitter
          duckdb
          pandas
          pyarrow
        ]);

        pipelineDependencies = [
          pythonEnv
          pkgs.checkov
          pkgs.just
          pkgs.coreutils
          pkgs.bash
        ];

      in
      {
        # Local Development State
        devShells.default = pkgs.mkShell {
          buildInputs = pipelineDependencies ++ (with pkgs; [
            src-cli
            opentofu
            harlequin
            basedpyright
            ruff
            nixd
            nixpkgs-fmt
            terraform-ls
            marksman
            taplo
          ]);

          shellHook = ''
            export PROJECT_ROOT="$PWD"
            export DUCKDB_PATH="$PROJECT_ROOT/warehouse/ast_security_matrix.duckdb"
            export PYTHONPATH="$PROJECT_ROOT/src:$PYTHONPATH"
            export SRC_ENDPOINT="https://sourcegraph.com"

            mkdir -p "$PROJECT_ROOT/warehouse" "$PROJECT_ROOT/src/extract" "$PROJECT_ROOT/src/transform"
          '';
        };

        # OCI Container
        packages.pipeline-image = pkgs.dockerTools.buildLayeredImage {
          name = "hcl-ast-security-pipeline";
          tag = "latest";
          created = "now"; 
          
          contents = pipelineDependencies;

          config = {
            Entrypoint = [ "${pkgs.just}/bin/just" ];
            Cmd = [ "default" ];
            Env = [
              "PYTHONPATH=/app/src"
              "DUCKDB_PATH=/app/warehouse/ast_security_matrix.duckdb"
            ];
            WorkingDir = "/app";
          };
        };

        packages.default = self.packages.${system}.pipeline-image;
      }
    );
}
