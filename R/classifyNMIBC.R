#' Transcriptomic UROMOL2021 classes of non-muscle-invasive bladder cancer
#' (NMIBC) samples
#'
#' This package performs Pearson nearest-centroid classification according to
#' the transcriptomic classes of NMIBC based on gene expression profiles.
#'
#' @param x `data.frame` with unique genes as rows and samples as columns.
#'   RNA-seq data needs to be log-transformed and micro-array data should be
#'   normalized.
#' @param min_cor Numeric specifying a minimal threshold for best Pearson's
#'   correlation between a sample's gene expression profile and centroids
#'   profiles. A sample showing no correlation above this threshold will remain
#'   unclassifed and prediction results will be set to NA.
#' @param gene_id Character specifying the type of gene identifiers used for the
#'   rownames or first column of `x`
#' @param tidy Logical. If TRUE, assumes the first column contains the gene
#'   identifiers. Otherwise, assumes IDs are rownames
#'
#' @return A `tibble` containing:
#' \describe{
#'   \item{estimate}{Pearson correlation of a given `sample` to the given `class` centroid}
#'   \item{conf.low, conf.high}{low and high end of 95% confidence interval}
#'   \item{nearest}{centroid for which the sample has the highest correlation to}
#'   \item{statistic}{t-statistic}
#'   \item{parameter}{degrees of freedom}
#'   \item{sep_lvl}{(Highest Correlation - 2nd Highest Correlation)/median(Distance to highest correlation)}
#' }
#'
#' @export
#'
#' @examples
#' data(test_data)
#' classifyNMIBC(test_data)
#'
#' @note This classifier was built similarly to the published tool for the
#'   consensus classes of MIBC: Kamoun, A et. al. A Consensus Molecular
#'   Classification of Muscle-invasive Bladder Cancer. Eur Uro (2019), doi:
#'   https://doi.org/10.1016/j.eururo.2019.09.006
#' @importFrom dplyr .data

classifyNMIBC <- function(x, min_cor = 0.2, gene_id = c("ensembl_gene_ID", "hgnc_symbol"), tidy = FALSE) {
    gene_id <- rlang::arg_match(gene_id)

    # TODO: Warn if duplicate gene_id

    # If tidy, assume first col is gene_id. Make it rownames and drop the col.
    if (tidy) {
      x <- as.data.frame(x)
      rownames(x) <- x[, 1]
      x <- x[, -1]
    }

    # Order genes the same in dataset as in centroids
    y <- x[match(classifyNMIBC::centroids[[gene_id]], rownames(x)),]

    if (nrow(y) == 0)
      stop(
        "Empty intersection between profiled genes and the genes used for classification.\n Make sure that gene names correspond to the type of identifiers specified by the gene_id argument"
      )
    if (nrow(y) < 0.6 * nrow(classifyNMIBC::centroids))
      warning(
        "Input gene expression profiles include less than 60% of the genes used for classification. Results may not be relevant"
      )

    array_cor_test <- function(y, class) {
      y |>
        apply(2, \(y) stats::cor.test(y, classifyNMIBC::centroids[[class]]) |> broom::tidy()) |>
        dplyr::bind_rows() |>
        dplyr::mutate(sample = colnames(y), class = class)
    }

    cor_res <-
      dplyr::bind_rows(
        c1 = array_cor_test(y, "Class_1"),
        c2a = array_cor_test(y, "Class_2a"),
        c2b = array_cor_test(y, "Class_2b"),
        c3 = array_cor_test(y, "Class_3")
      ) |>
      dplyr::group_by(.data$sample) |>
      dplyr::arrange(dplyr::desc(.data$estimate)) |>
      dplyr::mutate(
        nearest = .data$class[1],
        nearest_cor = .data$estimate[1],
        dist_to_sec = .data$nearest_cor - .data$estimate[2],
        delta_med = stats::median(.data$nearest_cor - .data$estimate),
        sep_lvl = .data$dist_to_sec / .data$delta_med,
        nearest = ifelse(.data$nearest_cor < min_cor, NA_character_, .data$nearest),
        sep_lvl = ifelse(.data$nearest_cor < min_cor, NA_real_, .data$sep_lvl)
      ) |>
      dplyr::ungroup() |>
      dplyr::select(c("sample", "class", "estimate", "conf.low", "conf.high", "nearest", "statistic", "parameter", "sep_lvl")) |>
      dplyr::arrange(.data$sample, .data$class)

    cor_res
}
