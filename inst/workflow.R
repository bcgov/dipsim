## user defined argument
dataset_size = 1000  #of testdata
wd <- "/Users/brobert/Desktop"

##-------------------------- load routine -------------------------------
##----- load routine step + helper function
parquet_fp <- search_parquet_data()

##----- load routine step
create_folder_structure(folder_location = wd, 
                        name = tools::file_path_sans_ext(basename(parquet_fp)))

##----- load routine step
data <- generate_theoretical(support = parquet_fp, resize = 100000, folder_location = wd)

##----- load routine step
generate_empirical(samp_size = 50, folder_location = wd, 
                   name = tools::file_path_sans_ext(basename(parquet_fp)))

##-------------------------- generate test data -------------------------
##------ generate test data step
generate_testdata(folder_location = wd, name = tools::file_path_sans_ext(basename(parquet_fp)), dataset_size = dataset_size)

##------ generate test data step
## reads test data into global environment
simulated_data <- read_testdata(folder_location = wd, name = tools::file_path_sans_ext(basename(parquet_fp)))

##--------------------------- diagnostics --------------------------------
##----- diagnostics step + helper function
original_data <- glue::glue("{wd}/{tools::file_path_sans_ext(basename(parquet_fp))}/distributions/theoretical/theoretical.csv")
original_data <- readr::read_csv(original_data, na = character())

cols <- compare_data(original_data, simulated_data)

##----- diagnostics step + helper function
#3 this is possibly better applied across cols
vis_sim (original_data, simulated_data, cols) 

##----------------------- clean up temp folder
f=glue::glue("{wd}/{tools::file_path_sans_ext(basename(parquet_fp))}")
unlink(f, recursive = TRUE)
