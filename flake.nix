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
          # Extraction & Integration
          requests
          graphql-core # Required if directly querying Sourcegraph GraphQL API
          
          # AST Processing & Graph Mathematics
          networkx
          tree-sitter # High-performance AST parsing
          
          # Data Engineering & Warehouse Load
          duckdb
          pandas
          pyarrow
        ]);

      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # 1. Pipeline Execution Core
            pythonEnv
            just # Deterministic command runner for pipeline phases

            # 2. MSR Extraction (Sourcegraph)
            src-cli # Sourcegraph CLI for large-scale code search and batch extraction

            # 3. Static Audit Engine (Policy-as-Code)
            checkov
            opentofu # HCL evaluation backend

            # 4. Data Warehouse & Visualization
            duckdb
            harlequin # Terminal UI for DuckDB, optimized for Zellij multiplexing

            # 5. Editor Subsystem (Language Servers for Helix)
            basedpyright # Python type-checking
            ruff         # Python AST-aware linter and formatter
            nixd         # Nix deterministic LSP
            nixpkgs-fmt  # Nix formatter
            terraform-ls # HCL LSP
            marksman     # Markdown LSP
            taplo        # TOML LSP (for pyproject.toml / justfile)
          ];

          shellHook = ''
            export PROJECT_ROOT="$PWD"
            export DUCKDB_PATH="$PROJECT_ROOT/warehouse/ast_security_matrix.duckdb"
            export PYTHONPATH="$PROJECT_ROOT/src:$PYTHONPATH"
            
            # Sourcegraph Configuration (Requires user to set SRC_ENDPOINT and SRC_ACCESS_TOKEN)
            export SRC_ENDPOINT="https://sourcegraph.com"

            # Create required directory structures
            mkdir -p "$PROJECT_ROOT/warehouse" "$PROJECT_ROOT/src/extract" "$PROJECT_ROOT/src/transform"

            echo "[STATE: ACTIVE] ELT Pipeline Environment Initialized."
            echo "[ENGINE] Python ${pkgs.python3.version} | DuckDB $(duckdb --version)"
            echo "[TOOLING] Checkov, Sourcegraph CLI, Harlequin (DB-TUI)"
            echo "[LSP] Pyright, Ruff, Nixd, Terraform-ls, Marksman"
          '';
        };
      }
    );
}
