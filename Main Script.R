source("C:/Users/benny/Documents/My Resps/NHS-Geography-Code-Lookup-File/Geo File.R")
Cancer_Data_Mortality_HB <- get_resource(res_id = "57f0983f-864e-4dbd-b3dc-ea8f16de83a4")
Cancer_Data_Mortality_CA <- get_resource(res_id = "eebc8f38-7297-4bdc-a417-69ce3e2e6d44")
Cancer_Data_Mortality_CRN <- get_resource(res_id = "9574c0f8-c780-49d8-810a-46fa76567fb3")
Cancer_Data_Incidence_HB <- get_resource(res_id = "3aef16b7-8af6-4ce0-a90b-8a29d6870014")
Cancer_Data_Incidence_CRN <- get_resource(res_id = "8cba0250-7e78-496d-8559-98c9c9a3d3e3")

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
  mutate(GeoCode = "Not Required", DataType = "Mortality", GeoType = "Cancer Research Region")

Cancer_Mortality <- bind_rows(Cancer_Data_Mortality_CA, Cancer_Data_Mortality_HB, Cancer_Data_Mortality_CRN) 

Cancer_Mortality_Cleaned <- Cancer_Mortality %>%
  select(GeoCode, CancerSiteICD10Code, CancerSite, Sex, Year, DeathsAllAges, CrudeRate, EASR, WASR, StandardisedMortalityRatio, GeoName, GeoType, DataType) %>% 
  rename(AllAges = DeathsAllAges, StandardisedRatio = StandardisedMortalityRatio )


Cancer_Data_Incidence_HB <- full_join(Cancer_Data_Incidence_HB, HB_Lookup, by = "HB") %>% 
  mutate(DataType = "Incidence") %>% 
  rename(GeoCode = HB, GeoName = HBName, AllAges = IncidencesAllAges, StandardisedRatio = StandardisedIncidenceRatio)

Cancer_Data_Incidence_Cleaned <- Cancer_Data_Incidence_HB %>% 
  select(GeoCode, CancerSiteICD10Code, CancerSite, Sex, Year, AllAges, CrudeRate, EASR, WASR, StandardisedRatio, GeoName, GeoType, DataType) 
  

Cancer_Data_Incidence_CRN <- Cancer_Data_Incidence_CRN %>% 
  mutate(DataType = "Incidence") %>%
  mutate(GeoCode = "Not Required", GeoType = "Cancer Research Region") %>% 
  rename(GeoName = Region, AllAges = IncidencesAllAges, StandardisedRatio = StandardisedIncidenceRatio) 

Cancer_Data_Incidence_CRN_Cleaned <- Cancer_Data_Incidence_CRN %>% 
  select(GeoCode, CancerSiteICD10Code, CancerSite, Sex, Year, AllAges, CrudeRate, EASR, WASR, StandardisedRatio, GeoName, GeoType, DataType) 



Cancer_Full_Data <- bind_rows(Cancer_Data_Incidence_Cleaned, Cancer_Mortality_Cleaned, Cancer_Data_Incidence_CRN_Cleaned)

write_xlsx(Cancer_Full_Data, "cancer_data.xlsx")

#####################################
### Scatter Plot for HB's dataset ###
#####################################

Cancer_HB_ScatterPlot_Incidence <- Cancer_Data_Incidence_HB %>% 
  select(GeoName, GeoCode, CancerSiteICD10Code, CancerSite, Sex, Year, AllAges)

Cancer_HB_ScatterPlot_Mortality <- Cancer_Data_Mortality_HB %>% 
  select(GeoName, GeoCode, CancerSiteICD10Code, CancerSite, Sex, Year, DeathsAllAges)
