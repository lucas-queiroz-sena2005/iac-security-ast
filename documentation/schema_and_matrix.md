05. RELATIONAL SCHEMA & ORTHOGONAL MATRIX

1. DDL: CORE ENTITIES (DuckDB)

Repositorio (Control Variables): id_repo (PK, UUID), url_github (Unique), stars (Maturity bias control), linhas_codigo_total (Volume control).

Topologia_AST (Independent Variables): id_arquivo (PK), id_repo (FK), file_path, eloc_state_file (Effective LoC), module_tree_depth (Nesting level), hcl_cyclomatic_complexity (Dynamic/Conditional density), hardcoded_density (Literal vs Abstraction ratio), output_coupling_rate (Inter-module variable dependency).

Auditoria_Checkov (Dependent Variables): id_auditoria (PK), id_arquivo (FK), check_id (Rule ID), resource_type, resultado (PASSED/FAILED), framework (CIS, PCI, LGPD).

2. INDEPENDENT VARIABLES (HCL AST EXTRACTS)

Depth & Nesting: maxDepthNestedBlocks, avgDepthNestedBlocks, moduleNestingDepth.

Logic & Expression: avgMccabeCC, maxMccabeCC, numConditionalExpressions, numLiteralExpression, countOfBooleanFlags.

Dynamic Mutations & Coupling: numDynamicBlocks, numLoops, numCrossResourceReferences, numMetaArg, numDataSources, maxIndexAccess, numVariables, numDefaultVariables, entropyOfStrings, numComplexDataTypes, numDependencies.

3. ORTHOGONAL GROUND TRUTH MATRIX (3x8)

24 Checkov Policies mapped causally to AST variables.

A. CIS AWS Foundations (Architecture & IAM)

CKV_AWS_1 (Admin IAM): numLiteralExpression & avgMccabeCC

CKV_AWS_7 (KMS Lifecycle): countOfBooleanFlags & numMetaArg

CKV_AWS_9 (Password Age): maxIndexAccess & numVariables

CKV_AWS_10 (Password Length): moduleNestingDepth & numDefaultVariables

CKV_AWS_11 (IAM Complexity): numDataSources & numCrossResourceReferences

CKV_AWS_23 (Security Group Audit): numDynamicBlocks & linesOfCode

CKV_AWS_24 (Perimeter Defense - SSH 0.0.0.0/0): numLoops & numConditionalExpressions

CKV_AWS_41 (Hardcoded Keys): entropyOfStrings & maxDepthNestedBlocks

B. HIPAA (Privacy & Health Data)

CKV_AWS_3 (EBS Encryption): countOfBooleanFlags & numDefaultVariables

CKV_AWS_5 (ElasticSearch Encryption): maxDepthNestedBlocks & numComplexDataTypes

CKV_AWS_6 (ElasticSearch Node-to-Node): avgMccabeCC & numCrossResourceReferences

CKV_AWS_16 (RDS Rest Immutability): numMetaArg & moduleNestingDepth

CKV_AWS_18 (S3 Auditability): numCrossResourceReferences & numLiteralExpression

CKV_AWS_19 (S3 Strict Crypto): numDataSources & numDynamicBlocks

CKV_AWS_21 (S3 Anti-Fraud Versioning): numConditionalExpressions & avgMccabeCC

CKV_AWS_55 (S3 Access Suppression): avgDepthNestedBlocks & numLoops

C. PCI DSS v4.0 (Network & Transactional)

CKV_AWS_2 (ALB SSL/TLS): numLoops & numStringValues

CKV_AWS_8 (Transactional Retention): moduleNestingDepth & numDataSources

CKV_AWS_25 (RDP Ban 3389): numDynamicBlocks & numLiteralExpression

CKV_AWS_260 (HTTP Ban 80): countOfBooleanFlags & maxMccabeCC

CKV_AWS_277 (Perimeter Escape 0.0.0.0/0): numConditionalExpressions & numLiteralExpression

CKV_AWS_56 (S3 Perimeter Containment): numCrossResourceReferences & avgDepthNestedBlocks

CKV_AWS_61 (API Gateway PCI Tracking): numDependencies & numMetaArg

CKV_AWS_93 (ALB Anti-Smuggling): countOfBooleanFlags & maxMccabeCC
