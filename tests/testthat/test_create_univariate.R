testthat::test_that("test data value type", {
  expect_equal(create_univariate(c(1,1,2,2,3,4,5))$value, "n")
  expect_equal(create_univariate(rnorm(10))$value, "n")
  expect_equal(create_univariate(c("apples", "apples"))$value, "c")
})

testthat::test_that("test data distribution type", {
  expect_equal(create_univariate(c(1,1,2,2,3,4,5))$type, "discrete")
  expect_equal(create_univariate(rnorm(10))$type, "continuous")
  expect_equal(create_univariate(rnorm(100))$type, "continuous")
  expect_equal(create_univariate(c("apples", "apples"))$type, "discrete")
})