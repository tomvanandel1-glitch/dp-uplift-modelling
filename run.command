#!/bin/bash
# =============================================================================
# Double-click this file to set up the environment and open the thesis pipeline.
# (First run creates the conda environment — a few minutes. Later runs are instant.)
# If double-click is blocked by macOS, right-click -> Open, or run it from Terminal.
# =============================================================================
set -e
cd "$(dirname "$0")"          # work inside this folder (= PROJECT_ROOT)

# --- locate and load conda -------------------------------------------------
CONDA_SH=""
for base in "$HOME/anaconda3" "$HOME/opt/anaconda3" "$HOME/miniconda3" "/opt/anaconda3" \
            "/opt/miniconda3" "$(command -v conda >/dev/null 2>&1 && conda info --base 2>/dev/null)"; do
    if [ -n "$base" ] && [ -f "$base/etc/profile.d/conda.sh" ]; then
        CONDA_SH="$base/etc/profile.d/conda.sh"; break
    fi
done
if [ -z "$CONDA_SH" ]; then
    echo "Could not find a conda installation."
    echo "Please open the Anaconda Prompt (or a terminal) and follow README.md instead."
    read -r -p "Press Enter to close." _; exit 1
fi
# shellcheck disable=SC1090
source "$CONDA_SH"

# --- create the environment once, then launch ------------------------------
if ! conda env list | grep -E '[/ ]thesis-uplift$' >/dev/null 2>&1; then
    echo "Creating the 'thesis-uplift' environment (first run only)..."
    conda env create -f environment.yml
fi
conda activate thesis-uplift

echo ""
echo "Launching Jupyter Lab. In the browser tab that opens, open 'thesis_pipeline.ipynb'"
echo "and choose Run > Run All Cells."
echo ""
jupyter lab thesis_pipeline.ipynb
