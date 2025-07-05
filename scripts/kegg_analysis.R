library(goseq)
library(ggplot2)
library(KEGGREST)

# Step 1: Load DEG info
deg <- read.table("tsv_diff_ex.txt", header = FALSE, sep = "\t", stringsAsFactors = FALSE)
genes <- setNames(as.integer(tolower(trimws(deg$V2)) == "true"), deg$V1)

# Step 2: Load gene lengths
gene_length <- read.table("tsv_gene_length.txt", header = FALSE, sep = "\t", stringsAsFactors = FALSE)
lengths <- setNames(gene_length$V2, gene_length$V1)

# Step 3: Probability Weighting Function (PWF)
pwf <- nullp(genes, bias.data = lengths)

# Step 4: Load KEGG gene-to-pathway mapping
gene2kegg_raw <- read.table("gene2kegg_fixed.txt", header = FALSE, sep = "\t", stringsAsFactors = FALSE)
gene2cat_kegg <- split(sub("sce:", "", gene2kegg_raw$V1), gene2kegg_raw$V2)

# Step 5: KEGG enrichment test
kegg_results <- goseq(pwf, gene2cat = gene2cat_kegg, test.cats = "KEGG")

# Step 6: Get KEGG pathway names
pathways <- unique(kegg_results$category)
pathway_info <- sapply(pathways, function(pid) {
  info <- tryCatch(keggGet(pid)[[1]], error = function(e) NULL)
  if (!is.null(info) && !is.null(info$NAME)) {
    return(info$NAME)
  } else {
    return(NA)
  }
})
kegg_results$pathway_name <- pathway_info[match(kegg_results$category, names(pathway_info))]

# Step 7: Plot top 10 enriched pathways
top_kegg <- head(kegg_results[order(kegg_results$over_represented_pvalue), ], 10)
top_kegg$pathway_name <- factor(top_kegg$pathway_name, levels = rev(top_kegg$pathway_name))

ggplot(top_kegg, aes(x = pathway_name, y = -log10(over_represented_pvalue))) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  labs(
    x = "KEGG Pathway",
    y = "-log10(Over-represented p-value)",
    title = "Top 10 Enriched KEGG Pathways"
  ) +
  theme_minimal()