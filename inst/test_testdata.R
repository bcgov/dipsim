dataset <- "census_geodata/2019"

file_path <- glue("R:/working/parquet_data/core-snapshot/dipsim_testing_do_not_delete/{dataset}")

data <- open_dataset(file_path) %>% 
  ## filter(datayr %in% c("2018", "2019", "2020")) %>% 
  ## select(-studyid) %>%
  collect()

n = 1000

data <- open_dataset(file_path) %>% 
  filter(datayr %in% c("2018", "2019", "2020")) %>% 
  collect()







