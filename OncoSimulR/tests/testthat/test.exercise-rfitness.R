inittime <- Sys.time()
cat(paste("\n Starting exercise-rfitness at", date(), "\n"))
test_that("Expect output", {

    expect_output(print(rfitness(4)), "Fitness", fixed = TRUE)
    expect_output(print(rfitness(4, reference = "max")), "Fitness",
                  fixed = TRUE)
    expect_output(print(rfitness(3, reference = c(1, 0, 1))), "Fitness",
                  fixed = TRUE)
    expect_output(print(rfitness(5, scale = c(1, 7))), "Fitness", fixed = TRUE)
    expect_output(print(rfitness(5, scale = c(1, 4), wt_is_1 = "no",
                           log = TRUE)), "Fitness", fixed = TRUE)
    expect_output(print(rfitness(4, reference = "random2")), "Fitness",
                  fixed = TRUE)
    expect_output(print(rfitness(4, reference = "random2",
                                 min_accessible_genotypes = 6)), "Fitness",
                  fixed = TRUE)
    expect_output(print(rfitness(3, reference = "random2",
                                 min_accessible_genotypes = 6)), "Fitness",
                  fixed = TRUE)
    expect_output(print(rfitness(3, reference = "max",
                                 min_accessible_genotypes = 6)), "Fitness",
                  fixed = TRUE)
})


test_that("Minimal tests of generate_matrix_genotypes", {
    ## By induction, if it works for the few first, should work for all,
    ## unless memory issues. And if we go beyond, say, 10 or 12, it can
    ## take long in slow machines.
    for(i in 1:13) {
        tmp <- OncoSimulR:::generate_matrix_genotypes(i)
        stopifnot(nrow(tmp) == (2^i))
        stopifnot(ncol(tmp) == i)
        cstmp <- colSums(tmp)
        lucstmp <- unique(cstmp)
        stopifnot(length(lucstmp) == 1)
        stopifnot(lucstmp[1] == ((2^i)/2)) ## yes, 2^(i - 1) but do full
        ## simple logic
        rm(tmp)
        rm(cstmp)
        rm(lucstmp)
    }
})

test_that("Warnings if scale out of scale", {
    expect_warning(rfitness(4, wt_is_1 = "force", scale = c(0, 0.5)),
                   "Using wt_is_1 = force", fixed = TRUE)
})

test_that("Error if wrong arguments", {
    expect_error(rfitness(NA),
                 "Number of genes argument (g) is null or NA",
                 fixed = TRUE)
    expect_error(rfitness(NULL),
                 "Number of genes argument (g) is null or NA",
                 fixed = TRUE)
})

cat(paste("\n Ending exercise-rfitness at", date(), "\n"))
cat(paste("  Took ", round(difftime(Sys.time(), inittime, units = "secs"), 2), "\n\n"))
rm(inittime)
