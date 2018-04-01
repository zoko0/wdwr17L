library(testthat)
source("src/src.R")

test_that("Function countExpected counts correct number based on tStudent.pdf", {
  expect_equal(round(countExpectedValue(45, 1, 4, data.frame(bottom = 20, top = 50)), 2), 44.97)
})

