library(goseq)
library(dplyr)
library(ggplot2)

# Read input files
deg <- read.table("tsv_diff_ex.txt", sep="\t", header=FALSE, stringsAsFactors=FALSE)
lengths_df <- read.table("tsv_gene_length.txt", sep="\t", header=FALSE, stringsAsFactors=FALSE)
gene2go_df <- read.table("gene2go_clean.txt", sep="\t", header=FALSE, stringsAsFactors=FALSE)

# Prepare DEG vector
deg_vector <- ifelse(tolower(trimws(deg$V2)) == "true", 1, 0)
names(deg_vector) <- deg$V1

# Prepare gene lengths
colnames(lengths_df) <- c("gene_id", "length")
lengths <- lengths_df$length
names(lengths) <- lengths_df$gene_id

# Prepare GO categories
colnames(gene2go_df) <- c("gene_id", "GO")
gene2cat <- split(gene2go_df$GO, gene2go_df$gene_id)

# Probability weighting function
pwf <- nullp(deg_vector, bias.data=lengths)

# GO enrichment
GO.wall <- goseq(pwf, gene2cat=gene2cat, test.cats=c("GO:BP", "GO:MF", "GO:CC"))

# KEGG enrichment
KEGG.wall <- goseq(pwf, gene2cat=gene2cat, test.cats="KEGG")

# Adjust p-values
GO.wall$padj <- p.adjust(GO.wall$over_represented_pvalue, method = "BH")

# Save full GO results
write.csv(GO.wall, file="goseq_results.csv", row.names=FALSE)

# Filter significant GO terms and plot top 10
sig_GO <- GO.wall %>% filter(padj < 0.05)
top_GO <- sig_GO %>% arrange(padj) %>% head(10)

ggplot(top_GO, aes(x = reorder(term, padj), y = -log10(padj))) +
  geom_bar(stat = "identity", fill = "steelblue") +
  coord_flip() +
  labs(x = "GO Term", y = "-log10(adjusted p-value)", 
       title = "Top 10 GO Terms (Adjusted p < 0.05)") +
  theme_minimal()

# Save plot
ggsave("top10_enriched_go_terms.png", width=8, height=6)