<div align="center">
  <h1>Matriz de Regressão: Topologia HCL & Segurança em Nuvem</h1>
  <p><b>Quantificando "Security Smells" em Infraestrutura como Código (IaC) via Análise de AST</b></p>

  <a href="https://nixos.org/"><img src="https://img.shields.io/badge/Ambiente-Nix-5277C3.svg?logo=nixos&logoColor=white" alt="Ambiente: Nix"></a>
  <a href="https://duckdb.org/"><img src="https://img.shields.io/badge/OLAP-DuckDB-FFF000.svg?logo=duckdb&logoColor=black" alt="Banco de Dados: DuckDB"></a>
  <a href="https://checkov.io/"><img src="https://img.shields.io/badge/SAST-Checkov-20B2AA.svg" alt="SAST: Checkov"></a>
  <a href="#aviso-de-embargo-academico"><img src="https://img.shields.io/badge/Status-Embargo_Acad%C3%AAmico-red.svg" alt="Status: Embargo Acadêmico"></a>
</div>

<details>
  <summary><h2>🇺🇸 Read the Documentation in English</h2></summary>
  <hr>
  <p>Please refer to the main <a href="./README.md">README.md</a> for the documentation in English.</p>
  <hr>
</details>

## 📋 Sumário
* [Aviso de Embargo Acadêmico](#aviso-de-embargo-acadêmico)
* [1. Resumo Executivo](#1-resumo-executivo)
* [2. Arquitetura do Sistema (Pipeline ELT)](#2-arquitetura-do-sistema-pipeline-elt)
* [3. Rigor Metodológico e Estatístico](#3-rigor-metodológico-e-estatístico)
* [4. Matriz de Ground Truth](#4-matriz-de-ground-truth)
* [5. Estrutura do Repositório](#5-estrutura-do-repositório)
* [6. Protocolo de Execução](#6-protocolo-de-execução)

---

<a id="aviso-de-embargo-academico"></a>
> [!WARNING]
> **AVISO DE EMBARGO ACADÊMICO:** Este repositório serve como vitrine arquitetural e projeto de infraestrutura para um Trabalho de Graduação (**FATEC Campinas**) em andamento. Para proteger a propriedade intelectual, a integridade dos dados e evitar plágio metodológico antes da publicação formal, os scripts principais de extração, o Data Warehouse (DuckDB) e os modelos de regressão multivariada são mantidos em um repositório privado. Este espelho público demonstra a arquitetura do sistema, o ambiente de execução determinístico e o esquema analítico.

## 1. Resumo Executivo
A validação de segurança em nuvem é estruturalmente reativa ("violação e correção"). O paradigma existente falha em antecipar vulnerabilidades introduzidas pela complexidade do código declarativo.

Este projeto desloca o DevSecOps inteiramente para a esquerda (**shift-left**), tratando o Compliance-as-Code como um problema rigoroso de **Engenharia de Dados (Processamento em Batch)**. Ao extrair a **Árvore de Sintaxe Abstrata (AST)** de configurações Terraform (HCL), o sistema prova matematicamente que decisões arquiteturais sub-ótimas — como monólitos, acoplamento profundo de módulos e alta densidade de valores estáticos (*hardcoded*) — atuam como preditores diretos e quantificáveis de falhas de conformidade em infraestrutura AWS (CIS, PCI-DSS v4.0, HIPAA).

## 2. Arquitetura do Sistema (Pipeline ELT)
O sistema opera sob um paradigma **Extract, Load, Transform (ELT)**, projetado para execução determinística e consultas analíticas de alto rendimento.

```text
┌─────────────────┐      ┌───────────────────────────┐      ┌──────────────────┐      ┌──────────────────┐
│ GitHub / API    │      │ Mecanismo de Auditoria    │      │ Armazém de Dados │      │ Apresentação     │
│ Sourcegraph CLI ├─(1)─►│ Parser AST HCL (Python)   ├─(2)─►│ Local            ├─(3)─►│ Dashboard SPA    │
│ (Corpus MSR)    │ Ext  │ (tree-sitter / networkx)  │ Trn  │ (DuckDB Columnar)│ Ld   │ (Node.js/React)  │
└─────────────────┘      └───────────────────────────┘      └──────────────────┘      └──────────────────┘
```

*   **Infraestrutura e Determinismo:** Configurado inteiramente via **Nix flakes** para garantir reprodutibilidade ambiental absoluta em qualquer sistema POSIX, eliminando falhas do tipo "funciona na minha máquina". Orquestração conteinerizada via Docker Compose.
*   **Fase 1 (Extract):** Ingestão de alta performance de módulos AWS HCL de código aberto (*Mining Software Repositories*) aplicando controles estritos de maturidade (stars > 15).
*   **Fase 2 (Process):** Execução simultânea em lote. O **Checkov** avalia o corpus contra 24 políticas de conformidade ortogonais. Simultaneamente, um parser Python extrai métricas de grafos topológicos (Profundidade, Complexidade Ciclomática, Acoplamento) diretamente da AST.
*   **Fase 3 (Load):** Ingestão no **DuckDB**, otimizado para agregações matemáticas de baixa latência e regressão multivariada sem o overhead de requisições de rede.

## 3. Rigor Metodológico e Estatístico

O mecanismo analítico é regido por padrões estritos de engenharia de software empírica:

*   **Matriz de Alta Dimensionalidade:** Avalia 48 variáveis estruturais independentes contra 24 variáveis de segurança dependentes, resultando em um mínimo de 1.152 testes univariados ortogonais.
*   **Controle de FDR (Mitigação de P-Hacking):** Para suprimir matematicamente a inflação do Erro Tipo I (Falso Positivo) inerente a testes de matrizes massivas, o pipeline aplica o procedimento de **Taxa de Falsa Descoberta (FDR)** de Benjamini-Hochberg com um limiar rigoroso de 5%.
*   **Isolamento Causal:** O Viés de Variável Omitida (OVB) é controlado via Gráficos Acíclicos Direcionados (DAGs), isolando o efeito estrutural puro da AST HCL de vieses externos de maturidade do desenvolvedor.
*   **Tratamento de Recursos Nulos:** O sistema ignora dinamicamente recursos AWS não instanciados na AST, excluindo-os estatisticamente dos denominadores de probabilidade condicional para evitar distorções de Falsos Negativos.

## 4. Matriz de Ground Truth

O modelo de regressão mapeia estruturas de código topológicas para vulnerabilidades de infraestrutura do mundo real.

| Framework | Vetor de Segurança (IDs Checkov) | Preditores Causais Topológicos (AST) |
| :--- | :--- | :--- |
| **CIS AWS Foundations** | Arquitetura e IAM<br>*(ex: CKV_AWS_1, CKV_AWS_7, CKV_AWS_41)* | `numLiteralExpression`, `avgMccabeCC`, `entropyOfStrings`, `maxDepthNestedBlocks` |
| **PCI DSS v4.0** | Redes e Transacional<br>*(ex: CKV_AWS_25, CKV_AWS_260, CKV_AWS_277)* | `numDynamicBlocks`, `numLoops`, `countOfBooleanFlags`, `numConditionalExpressions` |
| **HIPAA & LGPD** | Privacidade e Dados de Saúde<br>*(ex: CKV_AWS_5, CKV_AWS_16, CKV_AWS_55)* | `moduleNestingDepth`, `numCrossResourceReferences`, `avgDepthNestedBlocks` |

## 5. Estrutura do Repositório

```bash
.
├── data/
│   ├── processed/         # Matrizes de regressão AST e JSONL do SAST
│   └── raw_hcl/           # Corpus de repositórios AWS HCL clonados
├── src/
│   ├── extract/           # Scripts de ingestão GitHub/Sourcegraph
│   └── transform/         # Parsers AST Python (tree-sitter)
├── warehouse/
│   └── ast_security_matrix.duckdb  # Armazenamento colunar local (Excluído via .gitignore)
├── docker-compose.yml     # Orquestração OCI determinística e mapeamento de volumes
├── flake.nix              # Ambiente declarativo Nix e injeção de LSP
└── justfile               # Runner de comandos do pipeline
```

## 6. Protocolo de Execução

Para revisores que utilizam a imagem OCI pré-compilada, a execução do pipeline é abstraída via orquestração declarativa. O estado do DuckDB requer mapeamento de volume explícito.

<kbd>Passo 1</kbd> Carregar o artefato OCI imutável compilado via Nix:

```bash
docker load < result
```

<kbd>Passo 2</kbd> Executar o pipeline ELT (o `docker-compose.yml` força nativamente o mapeamento de volumes do host para preservação do estado do DuckDB):

```bash
docker-compose up ast-pipeline
```
