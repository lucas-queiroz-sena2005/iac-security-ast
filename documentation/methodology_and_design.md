03. METHODOLOGY & STATISTICAL DESIGN

1. EXPERIMENTAL DESIGN

Type: Multivariate predictive correlation analysis using observational data (Mining Software Repositories - MSR).

Scope: Strictly AWS provider configurations to isolate structural noise.

Unit of Analysis: The individual declarative block (resource block or module block). Orthogonal evaluation abstracts the global repository context to focus entirely on local topology.

2. PREDICTIVE HYPOTHESES

H1 (General Architecture vs. CIS AWS): Repositories with architectural monoliths (high eloc_state_file) and high abstraction depth (module_tree_depth) exhibit a mathematically higher Defect Density in foundational network and least-privilege (IAM) failures.

H2 (Cyclomatic Complexity vs. PCI-DSS v4.0): Code with high density of dynamic blocks and extreme coupling rates (output_coupling_rate) fails more frequently in the uniform application of cryptography flags and CDE (Cardholder Data Environment) protection.

H3 (Code Maturity vs. LGPD/GDPR): Modules that abuse hardcoded_density (literal strings) and unlinked state fragmentation correlate directly with PII exposure, systematically failing public access block and retention rules.

3. STATISTICAL CONTROLS & BIAS MITIGATION

Omitted Variable Bias (OVB): Controlled via Directed Acyclic Graphs (DAGs) mapping causal assumptions (e.g., isolating developer seniority or repository code churn).

P-Hacking Mitigation: The matrix evaluates 48 independent variables against 24 dependent variables, resulting in at least $k=1152$ univariate tests. This guarantees a Type I error (False Positive) inflation.

Correction Algorithm: Strict application of the Benjamini-Hochberg False Discovery Rate (FDR) procedure at a 5% threshold. Bonferroni adjustment is explicitly rejected due to excessive penalization (Type II error increase) in high-dimensional IaC topology matrices.

4. MSR INGESTION & THE NULL-RESOURCE SCENARIO

Execution Bypass: The engine scans the AST for target nodes. If the required target node (e.g., aws_elasticsearch_domain) does not exist, the specific compliance rule is bypassed.

Referential Integrity Validation: Returns a null/skipped state, preventing false FAILED or PASSED assertions.

Statistical Exclusion: The absence of the resource mathematically excludes it from the conditional probability calculations for that specific regression, preventing False Negative skewing in the multivariate model.
