source("C:/Users/benny/Documents/My Resps/NHS-Geography-Code-Lookup-File/Geo File.R")
Cancer_Data_Mortality_HB <- get_resource(res_id = "57f0983f-864e-4dbd-b3dc-ea8f16de83a4")
Cancer_Data_Mortality_CA <- get_resource(res_id = "eebc8f38-7297-4bdc-a417-69ce3e2e6d44")


Cancer_Data_Mortality_CA <- Cancer_Data_Mortality_CA %>% 
  rename(GeoCode = CA)

Cancer_Data_Mortality_HB <- full_join(Cancer_Data_Mortality_HB, HB_Lookup, by = "HB") %>% 
  mutate(DataTye = "Mortality") %>% 
  rename(GeoCode = HB, GeoName = HBName)

Cancer_Data_Mortality_CA <- full_join(Cancer_Data_Mortality_CA, Council_Lookup, by = "GeoCode") %>% 
  mutate(DataTye = "Mortality")

Cancer_Mortality <- bind_rows(Cancer_Data_Mortality_CA, Cancer_Data_Mortality_HB)