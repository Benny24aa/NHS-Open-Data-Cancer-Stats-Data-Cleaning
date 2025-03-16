source("C:/Users/benny/Documents/My Resps/NHS-Geography-Code-Lookup-File/Geo File.R")
Cancer_Data_Mortality_HB <- get_resource(res_id = "57f0983f-864e-4dbd-b3dc-ea8f16de83a4")
Cancer_Data_Mortality_CA <- get_resource(res_id = "eebc8f38-7297-4bdc-a417-69ce3e2e6d44")
Cancer_Data_Mortality_CRN <- get_resource(res_id = "9574c0f8-c780-49d8-810a-46fa76567fb3")
Cancer_Data_Mortality_Scot <- get_resource(res_id = "ba8d7049-ec05-4291-9333-57ca49ce7697")


Cancer_Data_Mortality_CA <- Cancer_Data_Mortality_CA %>% 
  rename(GeoCode = CA)

Cancer_Data_Mortality_HB <- full_join(Cancer_Data_Mortality_HB, HB_Lookup, by = "HB") %>% 
  mutate(DataType = "Mortality") %>% 
  rename(GeoCode = HB, GeoName = HBName)

Cancer_Data_Mortality_CA <- full_join(Cancer_Data_Mortality_CA, Council_Lookup, by = "GeoCode") %>% 
  mutate(DataType = "Mortality")

Cancer_Data_Mortality_CRN <- Cancer_Data_Mortality_CRN %>% 
  select(Region, CancerSiteICD10Code, CancerSite, Sex, Year, DeathsAllAges, CrudeRate, EASR, WASR, StandardisedMortalityRatio) %>% 
  rename(GeoName = Region) %>% 
  mutate(GeoCode = "Not Required", DateType = "Mortality", GeoType = "Cancer Research Region")

Cancer_Mortality <- bind_rows(Cancer_Data_Mortality_CA, Cancer_Data_Mortality_HB, Cancer_Data_Mortality_CRN) 

Cancer_Mortality_Cleaned <- Cancer_Mortality %>%
  select(GeoCode, CancerSiteICD10Code, CancerSite, Sex, Year, DeathsAllAges, CrudeRate, EASR, WASR, StandardisedMortalityRatio, GeoName, GeoType, DataType)


write_xlsx(Cancer_Mortality_Cleaned, "weekly_mortality.xlsx")

