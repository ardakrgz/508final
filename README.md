# 508final
# Reanalysis of RNA-seq Data from Sis2 Deletion in Yeast

## Project Summary

This repository presents a reproducibility project based on this open access study:

**Sis2 regulates yeast replicative lifespan in a dose-dependent manner**
[https://doi.org/10.1038/s41467-023-43233-y](https://doi.org/10.1038/s41467-023-43233-y)

Using publicly available RNA-Seq data from the study, I replicated the bioinformatics workflow to investigate transcriptional changes caused by the deletion of the **Sis2** gene in *Saccharomyces cerevisiae*. This reanalysis was conducted as a final project for a graduate-level bioinformatics course at Informatics Institute, Middle East Technical University.

> This is an independent replication for educational purposes only. All credit for the dataset and original study goes to the authors of Ölmez et al. (2023).

## Goals

* Reproduce RNA-seq analysis steps: Quality control, alignment, quantification, differential expression.
* Interpret results in the context of aging and metabolism.
* Perform GO and KEGG enrichment analysis.
* Practice troubleshooting and open science documentation.

## Data Sources

* GEO Accession: [GSE205228](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE205228)
* SRA Study ID: [SRP377849](https://trace.ncbi.nlm.nih.gov/Traces/index.html?view=study&acc=SRP377849)

Samples used:

* **Wild-Types: WT (BY4741\_A, BY4741\_B)**
* **Sis2 gene deletion: sis2Δ (sis2\_Delta\_A, sis2\_Delta\_B)**

## Directory Structure

```
├── data/                # Links and metadata for raw data
├── scripts/             # Galaxy histories and R scripts
├── results/             # Output files, figures
├── docs/                # Final report and references
└── README.md            # Project overview
```

## Tools & Environments

* Galaxy (usegalaxy.org and usegalaxy.eu)
* FASTQC (v0.12.1), MultiQC (v1.27), Cutadapt (v5.0), RNA STAR (v2.7.11a), featureCounts (v2.1.1), DESeq2 (v2.11.40.8), goseq (v.1.50.0)
* R (v4.4.1): pathview, goseq
* Reference genome: *S. cerevisiae* R64 (sacCer3)

## Analysis Workflow

1. **Quality Control**: FASTQC → MultiQC → Cutadapt → FASTQC → MultiQC
2. **Alignment & Counting**: RNA STAR → featureCounts
3. **Differential Expression**: DESeq2
4. **GO Enrichment**: Galaxy `goseq` and R `goseq`
5. **KEGG Analysis**: R `pathview` (partial), KEGG Mapper (manual)

## Key Results

* \~70% mapping rate in RNA STAR alignment
* 64 DEGs identified between WT and sis2Δ (adj. p < 0.05, log2FC > 1)
* Enriched GO terms: CoA biosynthesis, cellular metabolism, stress responses
* Enriched KEGG pathways: metabolic pathways, nucleotide metabolism, cell cycle

## Biological Interpretation

* The DEGs and enriched pathways suggest metabolic reprogramming and stress response activation following *Sis2* deletion.
* Results align with the original paper’s finding that *Sis2* deletion increases replicative lifespan through metabolic shifts and possibly reduced CoA levels.

## Limitations

* Some tool limitations in Galaxy required switching to R for GO/KEGG steps.
* KEGG pathway visualization lacks expression value coloring due to gene ID format incompatibilities.

## Links to Workflows & Scripts

* [Galaxy USA History](https://usegalaxy.org/u/ardakaragoz/h/take-home-1)
* [Galaxy EU History](https://usegalaxy.eu/u/ardkrz/h/eu-take-home-1)
* R scripts: see `scripts/goseq_analysis.R`, `scripts/kegg_analysis.R`

## References

* Krisko & Kennedy, 2021. *Yeast as a model organism for aging research.* [Handbook of the Biology of Aging](https://doi.org/10.1016/B978-0-12-815962-0.00008-1) 
* Ölmez et al., 2023. *Sis2 regulates yeast replicative lifespan in a dose-dependent manner*. [Nature Communications](https://doi.org/10.1038/s41467-023-43233-y)
* Steffen, K. K., Kennedy, B. K., & Kaeberlein, M., 2009. *Measuring replicative life span in the budding yeast*. [Journal of Visualized Experiments](https://doi.org/10.3791/1209)
