HCL Topology & Cloud Security Regression Matrix

Quantifying "Security Smells" in Infrastructure as Code (IaC) via AST Analysis

<div align="center">

🇧🇷 Leia a Documentação em Português

</div>

📋 Table of Contents

Academic Embargo Notice

Executive Summary

System Architecture (ELT Pipeline)

Methodological & Statistical Rigor

Ground Truth Matrix

Repository Structure

Execution Protocol

⚠️ Academic Embargo Notice

This repository serves as the architectural showcase and infrastructure blueprint for an ongoing academic thesis (Trabalho de Graduação - FATEC Campinas). To protect intellectual property, data integrity, and prevent methodological scooping prior to formal publication, the core extraction scripts, DuckDB data warehouse, and multivariate regression models are maintained in a secure, private repository. This public repository demonstrates the system architecture, deterministic execution environment, and analytical schema.

1. Executive Summary

Cloud security validation is structurally reactive ("violation and patch"). The existing paradigm fails to anticipate vulnerabilities introduced by declarative code complexity.

This project shifts DevSecOps entirely left by treating Compliance-as-Code as a strict Data Engineering (Batch Processing) problem. By extracting the Abstract Syntax Tree (AST) of Terraform (HCL) configurations, the system proves mathematically that sub-optimal architectural decisions—such as monoliths, deep module coupling, and high hardcoded density—act as direct, quantifiable predictors for compliance failures in AWS infrastructure (CIS, PCI-DSS v4.0, HIPAA).

2. System Architecture (ELT Pipeline)

The system operates under an Extract, Load, Transform (ELT) paradigm, engineered for deterministic execution and high-throughput analytical querying.

┌─────────────────┐      ┌───────────────────────────┐      ┌──────────────────┐      ┌──────────────────┐
│ GitHub / API    │      │ SAST Audit Engine         │      │ Local Data       │      │ Presentation     │
│ Sourcegraph CLI ├─(1)─►│ HCL AST Python Parser     ├─(2)─►│ Warehouse        ├─(3)─►│ Dashboard SPA    │
│ (MSR Corpus)    │ Ext  │ (tree-sitter / networkx)  │ Trn  │ (DuckDB Columnar)│ Ld   │ (Node.js/React)  │
└─────────────────┘      └───────────────────────────┘      └──────────────────┘      └──────────────────┘


Infrastructure & Determinism: Configured entirely via Nix flakes to guarantee absolute environmental reproducibility across any POSIX system, circumventing "works-on-my-machine" failures. Containerized orchestration via Docker Compose.

Phase 1 (Extract): High-throughput ingestion of open-source AWS HCL modules (Mining Software Repositories) enforcing strict maturity controls (stars > 15).

Phase 2 (Process): Concurrent batch execution. Checkov evaluates the corpus against 24 orthogonal compliance policies. Simultaneously, a Python parser extracts topological graph metrics (Depth, Cyclomatic Complexity, Coupling) directly from the AST.

Phase 3 (Load): Ingestion into DuckDB, optimized for low-latency mathematical aggregations and multivariate regression without network round-trip overhead.

3. Methodological & Statistical Rigor

The analytical engine is bound by strict empirical software engineering standards:

High-Dimensional Matrix: Evaluates 48 independent structural variables against 24 dependent security variables, resulting in a minimum of 1,152 orthogonal univariate tests.

FDR Control (P-Hacking Mitigation): To mathematically suppress the Type I error (False Positive) inflation inherent to massive matrix testing, the pipeline enforces the Benjamini-Hochberg False Discovery Rate (FDR) procedure at a strict 5% threshold.

Causal Isolation: Omitted Variable Bias (OVB) is controlled via Directed Acyclic Graphs (DAGs), isolating the pure structural effect of the HCL AST from external developer maturity biases.

Null-Resource Handling: The system dynamically bypasses non-instantiated AWS resources in the AST, statistically excluding them from conditional probability denominators to prevent False Negative skewing.

4. Ground Truth Matrix

The regression model maps topological code structures to real-world infrastructure vulnerabilities:

Framework

Security Vector (Checkov IDs)

Topological Causal Predictors (AST)

CIS AWS Foundations

Architecture & IAM (e.g., CKV_AWS_1, CKV_AWS_41)

numLiteralExpression, avgMccabeCC, entropyOfStrings, maxDepthNestedBlocks

PCI DSS v4.0

Network & Transactional (e.g., CKV_AWS_25, CKV_AWS_277)

numDynamicBlocks, numLoops, countOfBooleanFlags, numConditionalExpressions

HIPAA & LGPD

Privacy & Health Data (e.g., CKV_AWS_5, CKV_AWS_55)

moduleNestingDepth, numCrossResourceReferences, avgDepthNestedBlocks

5. Repository Structure

.
├── data/
│   ├── processed/         # SAST JSONL & AST regression matrices
│   └── raw_hcl/           # Cloned AWS HCL repository corpus
├── src/
│   ├── extract/           # GitHub/Sourcegraph ingestion scripts
│   └── transform/         # Python tree-sitter AST parsers
├── warehouse/
│   └── ast_security_matrix.duckdb  # Columnar local storage (Excluded via .gitignore)
├── docker-compose.yml     # Deterministic OCI orchestration & Volume mapping
├── flake.nix              # Nix declarative environment & LSP injection
└── justfile               # Pipeline command runner


6. Execution Protocol

For reviewers utilizing the pre-compiled OCI image, the pipeline execution is abstracted via declarative orchestration.

Step 1: Load the immutable Nix-compiled OCI artifact:

docker load < result


Step 2: Execute the ELT pipeline (the docker-compose.yml natively enforces host volume mapping for DuckDB state preservation):

docker-compose up ast-pipeline
