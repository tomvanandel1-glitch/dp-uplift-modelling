# Differentially-Private Synthetic Data for Uplift Modelling

**Student number:** S4721985

This repository contains the complete, reproducible pipeline for the thesis. The notebook
[`thesis_pipeline.ipynb`](thesis_pipeline.ipynb), run from top to bottom, regenerates every table,
figure, and CSV reported in the work: the main analysis — building differentially-private synthetic
versions of the Hillstrom (2008) e-mail dataset with the MST mechanism and evaluating two-model
uplift performance across the privacy budget ε — together with two extensions (a pooling-robustness
study and an analysis of the ε "sweet spot").

It is **self-contained**: the input dataset and the MST library (`private-pgm`) are included, so no
downloads or extra setup are needed beyond creating the Python environment. All analysis code and
random seeds are fixed (master seed **42**), so a clean run is fully deterministic and reproduces
the reported results.

---

## Quick start

The repository ships with everything required. On a machine with **Anaconda/Miniconda**:

**Option A — double-click (macOS).** Double-click **`run.command`**. It creates the environment the
first time (a few minutes) and opens Jupyter Lab; then choose **Run ▸ Run All Cells**.
*(If macOS blocks it, right-click ▸ Open.)*

**Option B — terminal (any OS).** From inside this folder:
```bash
conda env create -f environment.yml      # one-time setup
conda activate thesis-uplift
jupyter lab thesis_pipeline.ipynb        # then Run ▸ Run All Cells
```

**Option C — pip instead of conda.** In a fresh Python 3.11+ environment, from inside this folder:
```bash
pip install -r requirements.txt
jupyter lab thesis_pipeline.ipynb
```

Run the notebook **from this folder** (so `PROJECT_ROOT` is this folder). §0 prints an `[ok]`/`[warn]`
status for every prerequisite before any heavy computation starts; all outputs are written into this
folder's `data/` and `results/`.

---

## Isolation
The notebook reads a single input — the bundled Hillstrom CSV — and writes every output inside one
project folder, `PROJECT_ROOT` (this repository). Nothing is written outside it.

### Environment variables (optional — all have working defaults)
| Variable | Default | Purpose |
|---|---|---|
| `PROJECT_ROOT` | current working folder | Output root — everything is written here. |
| `PRIVATE_PGM_MECHANISMS` | the bundled `./private-pgm/mechanisms` | Folder containing the MST mechanism. |

---

## What's in the repository
```
<repo>/  (= PROJECT_ROOT)
├── thesis_pipeline.ipynb     # the reproducible pipeline (run this)
├── run.command               # double-click launcher (macOS)
├── environment.yml           # conda environment (pinned)
├── requirements.txt          # pip alternative (pinned)
├── README.md
├── private-pgm/              # bundled MST library (the `mbi` package + mechanisms)
├── data/
│   ├── raw/                  # input: the Hillstrom CSV (included)
│   ├── main_benchmarks/      # train/test split and benchmark datasets (generated)
│   ├── main_synthetic_mst/   # MST differentially-private synthetic datasets (generated)
│   └── extra_analysis/       # datasets for the two extensions (generated)
└── results/
    ├── main/
    │   ├── raw_outputs/       # results tables and appendix CSVs
    │   ├── thesis_tables/     # formatted Chapter-4 tables
    │   └── figures/           # Chapter-4 figures (300 DPI)
    └── extra_analysis/
        ├── epsilon_elbow/     # ε-elbow runs, summary, decision, figure
        ├── pooling_robustness/# pooling-robustness results + appendix table
        └── sweetspot_v2/      # sweet-spot validation, runs, summary + figures
```
The `data/` (beyond `raw/`) and `results/` sub-folders are created on the first run.

---

## Notebook sections
All paths are relative to `PROJECT_ROOT`.

| Section | Reads | Writes |
|---|---|---|
| **§0 — Setup** | — | creates the project folder tree |
| **§1 — Main pipeline** | `data/raw/` | `data/main_benchmarks/`, `data/main_synthetic_mst/`, `data/extra_analysis/epsilon_elbow/`, `results/main/{raw_outputs,thesis_tables,figures}/`, `results/extra_analysis/epsilon_elbow/` |
| **§2 — Extension: pooling robustness** | `data/raw/` | `data/extra_analysis/pooling_robustness/`, `results/extra_analysis/pooling_robustness/raw_outputs/` |
| **§3 — Extension: the ε sweet spot** | `data/main_benchmarks/`, `results/main/raw_outputs/results_summary.csv` | `data/extra_analysis/sweetspot_v2/`, `results/extra_analysis/sweetspot_v2/{raw_outputs,figures}/` |

The key path variables (all derived from `PROJECT_ROOT`, set once in §0): `DATA_DIR`, `SYNTH_DIR`,
`RESULTS_DIR`, `TABLES_DIR`, `FIGURES_DIR`, `RAW_PATH`, `ELBOW_*`, `RAW_CSV`, `SPLIT_DATA_DIR`,
`SPLIT_SYNTH_DIR`, `SPLIT_RESULTS_DIR`, `MAIN_DATA`, `MAIN_SUMMARY`, `SWEET_ROOT`, `SWEET_DATA`,
`SWEET_SYNTH`, `SWEET_RES`.

---

## Third-party code, licence, and citation

The `private-pgm/` folder is **not my own work**. It bundles **Private-PGM** (the `mbi` package) by
Ryan McKenna, Gerome Miklau, and Daniel Sheldon (College of Information and Computer Sciences,
University of Massachusetts Amherst), used unmodified under the **Apache License 2.0**. The full
licence text is retained in [`private-pgm/LICENSE`](private-pgm/LICENSE). Upstream repository:
https://github.com/ryan112358/mbi

Per the authors' request, if you use this software please cite:

> McKenna, R., Miklau, G., & Sheldon, D. (2021). *Private-PGM* (Version v2021-10-04-jpc) [Computer
> software]. Apache-2.0.
> https://github.com/journalprivacyconfidentiality/private-pgm-jpc-778/tree/v2021-10-04-jpc

together with the associated publication in the *Journal of Privacy and Confidentiality*. All other
code in this repository is my own.
