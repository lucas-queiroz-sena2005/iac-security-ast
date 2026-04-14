04. ARCHITECTURE & PIPELINE (ELT)

1. SYSTEM TOPOLOGY

The system executes a strictly deterministic Extract, Load, Transform (ELT) pipeline. Security validation is modeled fundamentally as a Data Engineering (Batch Processing) optimization constraint.

Infrastructure & Determinism: Configured via Nix (Deterministic Control) and Docker Compose, ensuring absolute environmental reproducibility.

2. EXECUTION PHASES

Phase 1: Extract (Ingestion / MSR)

Target: Mining Software Repositories.

Mechanism: Python scripts interfacing with the GitHub REST API.

Filtering & Mitigation: Imposes rigorous constraints (language:hcl, stars > 15, provider:aws). Executes shallow cloning (--depth 1) strictly on qualified modules. Implements algorithmic pacing for API rate limit mitigation.

Phase 2: Process (AST & Policy Analysis)

Checkov Engine (SAST): Batch processing against 24 orthogonal compliance metrics across CIS AWS, PCI-DSS v4.0, and HIPAA/LGPD/GDPR frameworks. Outputs flattened structural mappings.

HCL Custom Parser: Python-based parser processes the Abstract Syntax Tree (AST) concurrently to extract topological vectors (e.g., independent variables for mathematical regression).

Phase 3: Load (Data Warehouse)

Storage Engine: DuckDB (Optimized columnar local processing).

Constraint: Strict referential integrity. Enables low-latency, performant computation of Defect Density via SQL aggregations without network round-trip delays.

Phase 4: Present (SPA Layer)

API Layer: RESTful architecture built on Node.js/Express.

Visualization: Interactive SPA dashboard projecting spatial complexity regression matrices and orthogonal analysis plots.
