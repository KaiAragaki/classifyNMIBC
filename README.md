
<!-- README.md is generated from README.Rmd. Please edit that file -->

# classifyNMIBC

This package implements a Pearson nearest-centroid classifier that
assigns class labels to single samples according to the four
transcriptomic UROMOL2021 classes of non-muscle-invasive bladder cancer
(NMIBC): class 1, class 2a, class 2b and class 3.

The classifier code was adapted from the consensusMIBC classifier:
Kamoun, A et. al. A Consensus Molecular Classification of
Muscle-invasive Bladder Cancer, Eur Urol (2019), doi:
<https://doi.org/10.1016/j.eururo.2019.09.006> Both classifiers can be
found on our online web application: <http://nmibc-class.dk>

A smaller, example data set is provided to run the classifier.

## Installation

You can install the development version of classifyNMIBC from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("KaiAragaki/classifyNMIBC")
```

## Citation

Please cite *Lindskrog and Prip et al. An integrated multi-omics
analysis identifies prognostic molecular subtypes of non-muscle-invasive
bladder cancer. Nat Commun. 2021. PMID: 33863885. DOI:
10.1038/s41467-021-22465-w*

## Example

``` r
library(classifyNMIBC)
head(test_data)
#>                     U0026     U1270     U0062     U0268     U1031     U2111
#> ENSG00000000003  7.798584  7.650730  7.982110  8.100190  7.868289  6.856981
#> ENSG00000000005 -3.741143 -2.388611 -3.741143 -3.741143 -2.520977 -3.741143
#> ENSG00000000419  5.585231  5.684473  6.071433  5.741398  5.660815  4.292722
#> ENSG00000000457  4.640907  4.590306  4.755231  4.959714  4.571911  4.438253
#> ENSG00000000460  3.089819  3.344651  3.347822  3.038356  2.752188  3.450399
#> ENSG00000000938  2.263241  2.406814  2.025895  2.341007  2.932129  1.992647
#>                     U2038     U1335      U1374     U0766     U0207     U1462
#> ENSG00000000003  5.516853  7.302941 10.1367763  7.140048  7.993570  9.173919
#> ENSG00000000005 -3.741143 -2.573852 -2.4999592 -3.741143 -3.741143 -2.755169
#> ENSG00000000419  3.480889  5.863297  6.1344214  5.168890  5.576756  5.700350
#> ENSG00000000457  4.733730  4.686152  5.0704695  4.596911  4.745745  4.213344
#> ENSG00000000460  4.775156  4.108638  4.0559071  3.830356  4.767176  3.493735
#> ENSG00000000938  1.659560  2.801057  0.2591421  2.475362  0.161279  2.185324
#>                     U0141     U1046      U0115     U0903     U2057     U0349
#> ENSG00000000003  8.062838  7.929645  7.1726727  6.689667  7.042662  7.760344
#> ENSG00000000005 -3.741143 -3.741143 -0.2272847 -3.741143 -3.741143 -3.741143
#> ENSG00000000419  5.554523  5.155768  4.1701108  4.836986  5.209737  5.184493
#> ENSG00000000457  4.531744  5.741963  3.9186114  4.800784  4.514011  4.354929
#> ENSG00000000460  3.883842  2.940034  2.8257664  2.573462  3.600897  2.741864
#> ENSG00000000938  1.760882  2.960636  1.6747387  3.288770  2.423403  3.228414
#>                     U1148     U0316
#> ENSG00000000003  8.174573  6.235883
#> ENSG00000000005 -3.741143 -3.741143
#> ENSG00000000419  6.099845  3.902631
#> ENSG00000000457  4.910223  4.622666
#> ENSG00000000460  3.130189  2.513943
#> ENSG00000000938  1.639018  2.703945
```

``` r
test_data |> 
  classifyNMIBC(min_cor = 0.2, gene_id = "ensembl_gene_ID", tidy = FALSE) |> 
  head()
#> # A tibble: 6 × 9
#>   sample class   estimate conf.low conf.high nearest statistic parameter sep_lvl
#>   <chr>  <chr>      <dbl>    <dbl>     <dbl> <chr>       <dbl>     <int>   <dbl>
#> 1 U0026  Class_1    0.872    0.861     0.882 Class_1      78.6      1940   0.460
#> 2 U0026  Class_…    0.724    0.703     0.745 Class_1      46.3      1940   0.460
#> 3 U0026  Class_…    0.840    0.827     0.853 Class_1      68.3      1940   0.460
#> 4 U0026  Class_3    0.765    0.746     0.783 Class_1      52.3      1940   0.460
#> 5 U0062  Class_1    0.894    0.884     0.902 Class_1      87.7      1940   0.776
#> 6 U0062  Class_…    0.752    0.732     0.771 Class_1      50.3      1940   0.776
```
