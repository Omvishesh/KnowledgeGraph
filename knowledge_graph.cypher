// Knowledge Graph Cypher Script
// Generated from table metadata analysis

// Clear existing graph data
MATCH (n) DETACH DELETE n;

// Create table nodes
CREATE (t:Table {
  name: 'quaterly_key_aggregates_of_national_accounts',
  data_domain: 'GDP',
  business_metadata: 'Quarterly GDP aggregates for short-term macroeconomic forecasting.',
  columns: 'year, indicator, industry, quarter, value_at_current_price',
  source: 'MoSPI - National Accounts Division',
  rows_count: 1568
});

CREATE (t:Table {
  name: 'key_aggregates_of_national_accounts',
  data_domain: 'GDP',
  business_metadata: 'Core national account metrics supporting national budget and policy planning.',
  columns: 'year, item, value, value_category, value_unit',
  source: 'MoSPI - National Accounts Division',
  rows_count: 1098
});

CREATE (t:Table {
  name: 'per_capita_income_product_final_consumption',
  data_domain: 'GDP',
  business_metadata: 'Key indicators of living standards and consumption behavior at the national level.',
  columns: 'year, item, population, value, value_unit',
  source: 'MoSPI - National Accounts Division',
  rows_count: 156
});

CREATE (t:Table {
  name: 'quaterly_estimates_of_expenditure_components_gdp',
  data_domain: 'GDP',
  business_metadata: 'Expenditure-side GDP estimates by quarter for demand-side economic insights.',
  columns: 'year, item, quarter, price_type, value',
  source: 'MoSPI - National Accounts Division',
  rows_count: 936
});

CREATE (t:Table {
  name: 'consumer_price_index_cpi_for_agricultural_and_rural_labourers',
  data_domain: 'CPI',
  business_metadata: 'Inflation trends affecting rural/agricultural labor for wage/policy insights.',
  columns: 'state, year, category, index_value, labour_type',
  source: 'Ministry of Labour & Employment',
  rows_count: 168
});

CREATE (t:Table {
  name: 'city_wise_housing_price_indices',
  data_domain: 'CPI',
  business_metadata: 'Housing inflation trends at city level to track real estate affordability.',
  columns: 'city, year, quarter, index_value',
  source: 'National Housing Bank',
  rows_count: 2350
});

CREATE (t:Table {
  name: 'cpi_worker_data',
  data_domain: 'CPI',
  business_metadata: 'CPI data tracking worker income trends across categories and regions.',
  columns: 'year, time_period, worker_type, region, index_value',
  source: 'Ministry of Finance',
  rows_count: 156
});

CREATE (t:Table {
  name: 'cpi_food_worker_data',
  data_domain: 'CPI',
  business_metadata: 'CPI for food-specific inflation experienced by workers.',
  columns: 'year, time_period, worker_type, region, index_value',
  source: 'Ministry of Finance',
  rows_count: 40
});

CREATE (t:Table {
  name: 'nifty_sme_index_daily_values',
  data_domain: 'MSME',
  business_metadata: 'Daily stock index data representing SME equity market movements.',
  columns: 'index_name, date, open, high, low, close',
  source: 'NSE Indices',
  rows_count: 2077
});

CREATE (t:Table {
  name: 'msme_definitions_by_sector',
  data_domain: 'MSME',
  business_metadata: 'Threshold benchmarks to classify MSMEs across sectors and geographies.',
  columns: 'sector, criteria, micro_threshold, small_threshold, medium_threshold',
  source: 'Asian Development Bank',
  rows_count: 177
});

CREATE (t:Table {
  name: 'msme_global_data',
  data_domain: 'MSME',
  business_metadata: 'Comparative international MSME data for regional economic analysis.',
  columns: 'source, region, country, year, value',
  source: 'Asian Development Bank / ERDI',
  rows_count: 6556
});

CREATE (t:Table {
  name: 'asuse_est_num_workers_by_employment_gender',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Presents worker distribution by gender and nature of employment (e.g., full-time/part-time), across sectors and activity categories.',
  columns: 'year, stateut, sector, indicator, activity_category, establishment_type, gender, nature_of_employment, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 468
});

CREATE (t:Table {
  name: 'whole_sale_price_index_fy',
  data_domain: 'CPI',
  business_metadata: 'Wholesale inflation by commodity used for supply chain and price tracking.',
  columns: 'year, commodity_name, index_value',
  source: 'Ministry of Commerce & Industry',
  rows_count: 10308
});

CREATE (t:Table {
  name: 'msme_priority_sector_view',
  data_domain: 'MSME',
  business_metadata: 'Monthly Gross Bank Credit (GBC) outstanding in crores for the top ten most critical priority sectors within the Non-Food credit category',
  columns: 'month_numeric,year,effective_date,gbc_in_cr,id,subgroup,data_source,date_stamp,released_on,updated_on,month,sector,group_name',
  source: 'Reserve Bank of India',
  rows_count: 2485
});

CREATE (t:Table {
  name: 'msme_gdp_by_region_view',
  data_domain: 'MSME',
  business_metadata: 'GDP contribution of MSMEs by region/subregion and country within Asia',
  columns: 'data_upload_date,year,value,subregion,source,heading,region,country',
  source: 'Asian Development Bank / ERDI',
  rows_count: 50
});

CREATE (t:Table {
  name: 'msme_gdp_by_sector_view',
  data_domain: 'MSME',
  business_metadata: 'GDP contribution of MSMEs by sector across Asian countries and regions',
  columns: 'data_upload_date,year,value,sector,source,heading,region,country',
  source: 'Asian Development Bank / ERDI',
  rows_count: 175
});

CREATE (t:Table {
  name: 'msme_share_by_region_view',
  data_domain: 'MSME',
  business_metadata: 'MSME share (%) in the economy, by region/subregion/country',
  columns: 'data_upload_date,year,value,subregion,source,heading,region,country',
  source: 'Asian Development Bank / ERDI',
  rows_count: 46
});

CREATE (t:Table {
  name: 'msme_share_by_sector_view',
  data_domain: 'MSME',
  business_metadata: 'MSME share (%) by sector (e.g., services, manufacturing) across Asia',
  columns: 'data_upload_date,year,value,sector,source,heading,region,country',
  source: 'Asian Development Bank / ERDI',
  rows_count: 175
});

CREATE (t:Table {
  name: 'india_fy_gdp_view',
  data_domain: 'GDP',
  business_metadata: 'Aggregated national-level GDP metrics by financial year. Captures GDP and GVA growth at constant and current prices. Any India level summarization needs for GDP across years, trending and growth rate can be done from this table',
  columns: 'year,value_in_cr_const,growth_rate_const,value_in_cr_current,growth_rate_current',
  source: 'MoSPI - National Accounts Division',
  rows_count: 14
});

CREATE (t:Table {
  name: 'india_fy_national_income_view',
  data_domain: 'GDP',
  business_metadata: 'National income accounting components both for Gross and Net Income levels with growth rates at both constant and current prices, financial year-wise.',
  columns: 'year,item,value_in_cr_const,growth_rate_const,value_in_cr_current,growth_rate_current',
  source: 'MoSPI - National Accounts Division',
  rows_count: 28
});

CREATE (t:Table {
  name: 'asuse_est_annual_emoluments_per_hired_worker',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Shows average annual emoluments (wages/salaries) paid per hired worker, broken down by state, sector, activity type, and establishment characteristics.',
  columns: 'year, stateut, sector, indicator, sub_indicator, activity_category, establishment_type, hired_worker, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 63
});

CREATE (t:Table {
  name: 'asuse_est_annual_gva_per_establishment',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Captures Gross Value Added (GVA) per establishment annually, segmented by state, sector, activity category, and establishment type.',
  columns: 'year, stateut, sector, indicator, activity_category, establishment_type, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 112
});

CREATE (t:Table {
  name: 'asuse_est_num_establishments_pursuing_mixed_activity',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Represents the number of establishments engaged in more than one activity (mixed), categorized by sector, establishment type, and activity.',
  columns: 'year, stateut, sector, indicator, establishment_type, activity_category, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 216
});

CREATE (t:Table {
  name: 'msme_employees_share_by_region_view',
  data_domain: 'MSME',
  business_metadata: 'GDP contribution of MSMEs by region/subregion and country within Asia',
  columns: 'heading, region, country, subregion, year, value, source, data_upload_date',
  source: 'Asian Development Bank / ERDI',
  rows_count: 50
});

CREATE (t:Table {
  name: 'msme_global_sector',
  data_domain: 'MSME',
  business_metadata: 'GDP contribution of MSMEs by region/subregion and country within Asia',
  columns: 'heading, region, country, subregion, year, value, source, data_upload_date',
  source: 'Asian Development Bank / ERDI',
  rows_count: 525
});

CREATE (t:Table {
  name: 'asuse_est_value_key_characteristics_by_workers',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Contains values of key establishment characteristics classified by different worker traits (e.g., skill level, role), across various activity categories.',
  columns: 'year, stateut, sector, indicator, broad_activity_category, worker_characteristics, worker_number, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 1350
});

CREATE (t:Table {
  name: 'asuse_estimated_annual_gva_per_worker_rupees',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Provides estimated annual GVA per worker (in rupees), by state, sector, establishment, and activity category.',
  columns: 'year, stateut, sector, indicator, activity_category, establishment_type, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 1350
});

CREATE (t:Table {
  name: 'asuse_estimated_number_of_workers_by_type_of_workers',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Estimates the number of workers by type (e.g., hired, self-employed) and gender, segmented by establishment and activity characteristics.',
  columns: 'year, stateut, sector, indicator, activity_category, establishment_type, gender, type_of_worker, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 1350
});

CREATE (t:Table {
  name: 'asuse_per1000_estb_by_hours_worked_per_day',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Shows the distribution (per 1000 establishments) by number of working hours per day, by sector and establishment category.',
  columns: 'year, stateut, sector, indicator, activity_category, establishment_type, no_of_working_hours, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 4032
});

CREATE (t:Table {
  name: 'asuse_per1000_estb_by_months_operated_last_365days',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Indicates how many months establishments operated in the past year (per 1000 estb), across different sectors and activities.',
  columns: 'year, stateut, sector, indicator, activity_category, establishment_type, no_of_months_operated, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 4032
});

CREATE (t:Table {
  name: 'asuse_per1000_estb_registered_under_acts_authorities',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Shows registration status of establishments (per 1000), detailing which acts/agencies they’re registered under.',
  columns: 'year, stateut, sector, indicator, sub_indicator, actsagency_of_registration, activity_category, establishment_type, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 4032
});

CREATE (t:Table {
  name: 'asuse_per1000_estb_using_computer_internet_last365_days',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Reflects digital adoption: proportion of establishments using computers or the internet in the last 365 days (per 1000).',
  columns: 'year, stateut, sector, indicator, sub_indicator, broad_activity_category, establishment_type, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 5400
});

CREATE (t:Table {
  name: 'asuse_per1000_of_estb_using_internet_by_type_of_its_use',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Details how establishments use the internet (e.g., communication, sales, training), with usage type breakdown per 1000 establishments.',
  columns: 'year, stateut, sector, indicator, broad_activity_category, usage_of_internet, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 6048
});

CREATE (t:Table {
  name: 'asuse_per1000_proppartn_estb_by_edu_owner_mjr_partner',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Shows educational profile of owners/major partners of proprietary/partnership establishments, per 1000 establishments.',
  columns: 'year, stateut, sector, indicator, general_education_level, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 6300
});

CREATE (t:Table {
  name: 'asuse_per1000_proppartn_estb_by_other_econ_activities',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Highlights prevalence (per 1000) of proprietors/partners engaging in other economic activities besides their main business.',
  columns: 'year, stateut, sector, indicator, activity_category, other_economic_activitycount, establishment_type, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 6750
});

CREATE (t:Table {
  name: 'asuse_per1000_proppartn_estb_by_socialgroup_owner',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Breaks down proprietary/partnership establishments by social group (e.g., SC/ST/OBC/General) of the owner or major partner.',
  columns: 'year, stateut, sector, indicator, activity_category, establishment_type, social_group_of_ownermajor_partner, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 8064
});

CREATE (t:Table {
  name: 'asuse_per_1000_distri_of_establishments_by_nature_of_operation',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Distribution (per 1000) of establishments by their operational nature (seasonal, perennial, casual), segmented by sector and activity.',
  columns: 'year, stateut, sector, indicator, activity_category, establishment_type, nature_of_operation, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 8100
});

CREATE (t:Table {
  name: 'asuse_per_1000_distri_of_establishments_by_type_of_location',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Displays how establishments are spread across types of locations per 1000 establishments.',
  columns: 'year, stateut, sector, indicator, activity_category, establishment_type, location_of_establishments, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 9024
});

CREATE (t:Table {
  name: 'asuse_per_1000_distri_of_establishments_by_type_of_ownership',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Categorizes establishments per 1000 by ownership type (proprietary, partnership, others) across activity and sector.',
  columns: 'year, stateut, sector, indicator, activity_category, establishment_type, ownership_type, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 8100
});

CREATE (t:Table {
  name: 'asuse_per_1000_of_establishments_which_are_npis_and_non_npis',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Shows proportion of Non-Profit Institutions (NPIs) vs non-NPIs (per 1000) across broad activity categories.',
  columns: 'year, stateut, sector, indicator, broad_activity_category, npi_status, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 8100
});

CREATE (t:Table {
  name: 'asuse_statewise_est_num_of_estb_pursuing_mixed_activity',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'State-wise estimates of establishments engaged in mixed activities ',
  columns: 'year, stateut, sector, indicator, broad_activity_category, establishment_type, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 9450
});

CREATE (t:Table {
  name: 'asuse_statewise_est_num_of_estb_serving_as_franchisee_outlet',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Estimates of establishments acting as franchisee outlets, broken down by state and sector.',
  columns: 'year, stateut, sector, indicator, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 12150
});

CREATE (t:Table {
  name: 'asuse_statewise_est_num_of_worker_by_employment_and_gender',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'State-level distribution of workers by gender and nature of employment ',
  columns: 'year, stateut, sector, indicator, broad_activity_category, establishment_type, gender, nature_of_employment, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 12096
});

CREATE (t:Table {
  name: 'asuse_statewise_estimated_annual_emoluments_per_hired_worker',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Average annual emoluments paid per hired worker, reported at the state level across sectors.',
  columns: 'year, stateut, sector, indicator, sub_indicator, broad_activity_category, establishment_type, hired_worker, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 13500
});

CREATE (t:Table {
  name: 'asuse_statewise_estimated_annual_gva_per_establishment_rupees',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Shows annual Gross Value Added (GVA) per establishment (in ₹) by state and sector.',
  columns: 'year, stateut, sector, indicator, broad_activity_category, establishment_type, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 16128
});

CREATE (t:Table {
  name: 'asuse_statewise_estimated_annual_gva_per_worker_rupees',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Displays annual GVA per worker (₹) at the state level, across various activities and sectors.',
  columns: 'year, stateut, sector, indicator, broad_activity_category, establishment_type, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 72576
});

CREATE (t:Table {
  name: 'asuse_statewise_estimated_number_of_workers_by_type_of_workers',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Estimates the number of workers by type (e.g., self-employed, hired) and gender per state.',
  columns: 'year, stateut, sector, indicator, broad_activity_category, establishment_type, gender, type_of_worker, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 36288
});

CREATE (t:Table {
  name: 'asuse_statewise_per1000_distri_of_estb_by_nature_of_operation',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Statewise share (per 1000) of establishments categorized by their operational nature.',
  columns: 'year, stateut, sector, indicator, broad_activity_category, establishment_type, nature_of_operation, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 24192
});

CREATE (t:Table {
  name: 'asuse_statewise_per1000_distri_of_estb_by_type_of_location',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Indicates the distribution of establishments per 1000 across various location types within each state.',
  columns: 'year, stateut, sector, indicator, broad_activity_category, establishment_type, location_of_establishments, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 24300
});

CREATE (t:Table {
  name: 'asuse_statewise_per1000_distri_of_estb_by_type_of_ownership',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Shows the ownership pattern (e.g., individual, partnership) of establishments per 1000, statewise.',
  columns: 'year, stateut, sector, indicator, broad_activity_category, establishment_type, ownership_type, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 18864
});

CREATE (t:Table {
  name: 'asuse_statewise_per1000_estb_by_hours_worked_per_day',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Breaks down per 1000 establishments by average daily working hours, across states.',
  columns: 'year, stateut, sector, indicator, broad_activity_category, no_of_working_hours, establishment_type, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 41616
});

CREATE (t:Table {
  name: 'asuse_statewise_per1000_estb_by_month_num_operated_last365_day',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Reports the number of operational months (out of 12) per 1000 establishments in the past year, by state.',
  columns: 'year, stateut, sector, indicator, broad_activity_category, establishment_type, no_of_months_operated, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 40320
});

CREATE (t:Table {
  name: 'asuse_statewise_per1000_estb_maintain_post_bank_saving_acc',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'State-level data on how many establishments per 1000 maintain a post office or bank savings account.',
  columns: 'year, stateut, sector, indicator, broad_activity_category, establishment_type, account_holder, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 27804
});

CREATE (t:Table {
  name: 'asuse_statewise_per1000_estb_registered_diff_acts_authorities',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Shows the number of registered establishments (per 1000) under various acts and authorities, statewise.',
  columns: 'year, stateut, sector, indicator, sub_indicator, actsagency_of_registration, broad_activity_category, establishment_type, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 24192
});

CREATE (t:Table {
  name: 'asuse_statewise_per1000_estb_use_computer_internet_last365_day',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Captures computer/internet usage among establishments in the past year, per 1000, across states.',
  columns: 'year, stateut, sector, indicator, sub_indicator, broad_activity_category, establishment_type, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 20160
});

CREATE (t:Table {
  name: 'asuse_statewise_per1000_proppart_estb_by_social_grp_mjr_prtner',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Shows per 1000 proprietary/partnership establishments by the social group of the main owner/partner, statewise.',
  columns: 'year, stateut, sector, indicator, broad_activity_category, establishment_type, social_group_of_ownermajor_partner, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 13950
});

CREATE (t:Table {
  name: 'mis_access_to_improved_source_of_drinking_water',
  data_domain: 'social_migration_and_households',
  business_metadata: 'Shows the proportion of households with access to improved sources of drinking water, categorized by sector and sub-indicator.',
  columns: 'indicator, f_value, sub_indicator, sector, state',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 222
});

CREATE (t:Table {
  name: 'mis_access_to_mass_media_and_broadband',
  data_domain: 'social_migration_and_households',
  business_metadata: 'Captures household access to internet, mass media, and broadband services, broken down by sector and indicator.',
  columns: 'sector, f_value, internet_access, state, indicator',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 222
});

CREATE (t:Table {
  name: 'mis_availability_of_basic_transport_and_public_facility',
  data_domain: 'social_migration_and_households',
  business_metadata: 'Provides data on household access to transportation and public facilities, grouped by sector and sub-indicator.',
  columns: 'sub_indicator, indicator, sector, f_value, state',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 333
});

CREATE (t:Table {
  name: 'mis_different_source_of_finance',
  data_domain: 'social_migration_and_households',
  business_metadata: 'Describes various financial sources accessed by households, categorized by sector and type of finance source.',
  columns: 'f_value, state, source_of_finance, indicator, sector',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 555
});

CREATE (t:Table {
  name: 'mis_exclusive_access_to_improved_latrine',
  data_domain: 'social_migration_and_households',
  business_metadata: 'Indicates households with exclusive access to improved sanitation facilities, segmented by sector and sub-indicator.',
  columns: 'sector, indicator, state, f_value, sub_indicator',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 222
});

CREATE (t:Table {
  name: 'mis_household_assets',
  data_domain: 'social_migration_and_households',
  business_metadata: 'Details asset ownership (like vehicles, appliances) among households, categorized by sector and asset type.',
  columns: 'indicator, sector, sub_indicator, state, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 333
});

CREATE (t:Table {
  name: 'mis_improved_latrine_and_hand_wash_facility_in_households',
  data_domain: 'social_migration_and_households',
  business_metadata: 'Reports availability of both improved latrines and handwashing facilities within households by sector and state.',
  columns: 'sub_indicator, state, indicator, sector, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 555
});

CREATE (t:Table {
  name: 'mis_improved_source_of_drinking_water_within_household',
  data_domain: 'social_migration_and_households',
  business_metadata: 'Shows the presence of improved drinking water sources within the household premises, segmented by sector and sub-indicator.',
  columns: 'sector, sub_indicator, state, f_value, indicator',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 555
});

CREATE (t:Table {
  name: 'mis_income_change_due_to_migration',
  data_domain: 'social_migration_and_households',
  business_metadata: 'Analyzes household income variation resulting from migration, grouped by sector and sub-indicator.',
  columns: 'indicator, f_value, sector, sub_indicator, state',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 555
});

CREATE (t:Table {
  name: 'mis_main_reason_for_leaving_last_usual_place_of_residence',
  data_domain: 'social_migration_and_households',
  business_metadata: 'Provides insights into reasons for leaving previous residence, segmented by gender, sector, and migration reason.',
  columns: 'state, f_value, gender, sector, migration_reason, indicator',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 6327
});

CREATE (t:Table {
  name: 'mis_main_reason_for_migration',
  data_domain: 'social_migration_and_households',
  business_metadata: 'Captures the primary reasons for migration across sectors and genders, such as employment, marriage, or education.',
  columns: 'sector, f_value, gender, indicator, state, main_reason_for_migration',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 6327
});

CREATE (t:Table {
  name: 'mis_possession_of_air_conditioner_and_air_cooler',
  data_domain: 'social_migration_and_households',
  business_metadata: 'Indicates household ownership of air conditioners or coolers, segmented by sector and type.',
  columns: 'desc, indicator, sector, sub_indicator, state, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 440
});

CREATE (t:Table {
  name: 'mis_usage_of_mobile_phone',
  data_domain: 'social_migration_and_households',
  business_metadata: 'Reflects mobile phone usage patterns across gender, age groups, and sectors.  ',
  columns: 'state, sector, gender, age_group, indicator, f_value',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 666
});

CREATE (t:Table {
  name: 'mis_usual_place_of_residence_different_from_current_place',
  data_domain: 'social_migration_and_households',
  business_metadata: 'Highlights households whose current residence differs from their usual place of residence, categorized by sector.',
  columns: 'f_value, indicator, sector, state',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 111
});

CREATE (t:Table {
  name: 'sa_agri_hhs_crop_sale_quantity_by_agency_major_disposal',
  data_domain: 'agriculture_and_rural',
  business_metadata: 'Data on crop sale quantities by major disposal agencies, categorized by crop type, season, and state, including the source and timing of data collection and release.',
  columns: 'f_value, indicator, sub_indicator, season, crop, crop_agency, visit, data_source, updated_on, state, released_on',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 20
});

CREATE (t:Table {
  name: 'sa_agri_hhs_reporting_use_of_diff_farming_resources',
  data_domain: 'agriculture_and_rural',
  business_metadata: 'Data capturing the reported use of different farming resources (e.g., tools, inputs) by households across states and seasons, categorized by procurement type and source of data collection.',
  columns: 'f_value, indicator, season, resource, sub_resource, major_procurement, sub_major_procurement, visit_name, data_source, updated_on, state, released_on',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 1488
});

CREATE (t:Table {
  name: 'sa_agri_hhs_use_purchased_seed_by_quality',
  data_domain: 'agriculture_and_rural',
  business_metadata: 'Captures household-level agricultural data on the usage of purchased seeds categorized by quality, procurement agency, and seed type across different states and seasons.',
  columns: 'f_value, indicator, season, agency_procurement, seed_procurements, sub_seed_procurements, visit_name, data_source, updated_on, state, released_on',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 1158
});

CREATE (t:Table {
  name: 'sa_avg_expenditure_and_receipts_on_farm_and_nonfarm_assets',
  data_domain: 'agriculture_and_rural',
  business_metadata: 'Provides average expenditure and income data related to farm and non-farm productive assets and businesses, segmented by landholding size, season, and state.',
  columns: 'f_value, indicator, sub_indicator, season, land_possessedhectares, expenditure_receipt, productive_assets, business_type, data_source, updated_on, state, released_on',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 1860
});

CREATE (t:Table {
  name: 'sa_avg_gross_cropped_area_value_quantity_crop_production',
  data_domain: 'agriculture_and_rural',
  business_metadata: 'Details the average gross cropped area along with the quantity and value of crop production, categorized by crop type, season, and state-level harvesting activity.',
  columns: 'state, indicator, sub_indicator, season, harvested_name, sub_harvested, visit_name, f_value, data_source, updated_on, released_on',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 1560
});

CREATE (t:Table {
  name: 'sa_avg_monthly_expenses_and_receipts_for_crop_production',
  data_domain: 'agriculture_and_rural',
  business_metadata: 'Captures average monthly crop production expenses and receipts based on land possession size and type of crop. Useful for analyzing profitability across farm sizes.',
  columns: 'f_value, indicator, season, land_possessedhectares, crop_production, expenses_recipt, data_source, updated_on, state, released_on',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 2509
});

CREATE (t:Table {
  name: 'sa_avg_monthly_total_expenses_crop_production',
  data_domain: 'agriculture_and_rural',
  business_metadata: 'Provides total average monthly expenses incurred by agricultural households on crop production, segmented by landholding size and crop type.',
  columns: 'f_value, indicator, sub_indicator, season, land_possessedhectares, crop_production, data_source, updated_on, state, released_on',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 2145
});

CREATE (t:Table {
  name: 'sa_avg_monthly_total_expenses_receipts_animal_farming_30_days',
  data_domain: 'agriculture_and_rural',
  business_metadata: 'Reports average monthly animal farming expenses and receipts over a 30-day period, classified by landholding size and season.',
  columns: 'f_value, indicator, land_possessedhectares, season, expenses_imputed, expenditure_receipt, data_source, updated_on, state, released_on',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 2790
});

CREATE (t:Table {
  name: 'sa_dist_agri_hh_not_insuring_crop_by_reason_for_selected_crop',
  data_domain: 'agriculture_and_rural',
  business_metadata: 'Shows distribution of agricultural households that do not insure crops, with reasons like lack of awareness or access, disaggregated by season and visit.',
  columns: 'state, indicator, season, sub_indicator, visit, insurance_awareness, f_value, data_source, updated_on, released_on',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 3045
});

CREATE (t:Table {
  name: 'sa_dist_agri_hhs_seed_use_by_agency_of_procurement',
  data_domain: 'agriculture_and_rural',
  business_metadata: 'Details the distribution of seed usage by procurement agency (government, private, etc.), season, and crop type across households.',
  columns: 'f_value, indicator, sub_indicator, season, visit_name, crop, crop_procurement, data_source, updated_on, state, released_on',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 3211
});

CREATE (t:Table {
  name: 'sa_dist_hhs_leasing_out_land_and_avg_area_social_group',
  data_domain: 'agriculture_and_rural',
  business_metadata: 'Tracks households leasing out land, average area leased, and social group-wise distribution, helping study land tenure trends.',
  columns: 'f_value, indicator, sub_indicator, season, social_group, ownership_holding, data_source, updated_on, state, released_on',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 3348
});

CREATE (t:Table {
  name: 'sa_dist_of_agri_hhs_reporting_use_of_purchased_seed',
  data_domain: 'agriculture_and_rural',
  business_metadata: 'Captures data on households using purchased seeds, quality levels, and season-wise distribution to assess seed market penetration.',
  columns: 'f_value, indicator, sub_indicator, season, quality_seeds, visit, data_source, updated_on, state, released_on',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 4095
});

CREATE (t:Table {
  name: 'sa_dist_of_hhs_by_hh_classification_for_diff_classes_of_land',
  data_domain: 'agriculture_and_rural',
  business_metadata: 'Classifies households by social group, employment type, and land possession class to show structural patterns in agricultural household demographics.',
  columns: 'f_value, indicator, social_group, household_classification, land_possessedhectares, household_employment, household_sub_employment, visit_name, data_source, updated_on, state, released_on',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 4464
});

CREATE (t:Table {
  name: 'sa_distribution_hhs_leasing_in_land_avg_area_social_group',
  data_domain: 'agriculture_and_rural',
  business_metadata: 'Provides data on leasing-in of land, including social group distribution and average leased area, aiding in land access analysis.',
  columns: 'f_value, indicator, sub_indicator, season, social_group, ownership_holding, data_source, updated_on, state, released_on',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 5704
});

CREATE (t:Table {
  name: 'sa_distribution_loan_outstanding_by_source_of_loan_taken',
  data_domain: 'agriculture_and_rural',
  business_metadata: 'Presents outstanding agricultural loans by loan source (e.g., institutional, informal), land size, and visit, highlighting credit reliance.',
  columns: 'f_value, indicator, source_of_loan, season, land_possessedhectares, visit_name, data_source, updated_on, state, released_on',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 6975
});

CREATE (t:Table {
  name: 'sa_distribution_operational_holdings_by_possession_type',
  data_domain: 'agriculture_and_rural',
  business_metadata: 'Shows how operational land holdings are distributed by type of possession (e.g., owned, leased), useful for tenure and access studies.',
  columns: 'f_value, indicator, season, ownership_holding, possession_holding, data_source, updated_on, state, released_on',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 4464
});

CREATE (t:Table {
  name: 'sa_est_num_of_hhs_for_each_size_class_of_land_possessed',
  data_domain: 'agriculture_and_rural',
  business_metadata: 'Estimates the number of households in each landholding class and their classification, useful for studying farm size structure.',
  columns: 'f_value, indicator, household_classification, land_possessedhectares, visit_name, data_source, updated_on, state, released_on',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 7440
});

CREATE (t:Table {
  name: 'sa_estimated_no_of_hhs_for_different_social_groups',
  data_domain: 'agriculture_and_rural',
  business_metadata: 'Provides estimates of agricultural households categorized by social groups and household classification, including visit-based survey details.',
  columns: 'f_value, indicator, sub_indicator, household_classification, social_group, visit_name, data_source, updated_on, state, released_on',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 9672
});

CREATE (t:Table {
  name: 'sa_no_of_hhs_owning_of_livestock_of_different_types',
  data_domain: 'agriculture_and_rural',
  business_metadata: 'Captures the number of households owning livestock by type, season, gender, and social group, indicating ownership levels.',
  columns: 'f_value, indicator, season, social_group, gender, ownership_holding, stock, data_source, updated_on, state, released_on',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 13392
});

CREATE (t:Table {
  name: 'sa_no_per_1000_distri_of_agri_hhs_reporting_sale_of_crops',
  data_domain: 'agriculture_and_rural',
  business_metadata: 'Reports the number per 1000 agricultural households involved in crop sales, disaggregated by season, sub-indicator, and insurance awareness.',
  columns: 'f_value, indicator, sub_indicator, season, visit, insurance_awareness, data_source, updated_on, state, released_on',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 34272
});

CREATE (t:Table {
  name: 'sa_no_per_hh_operational_holding_by_size_hh_oper_holding',
  data_domain: 'agriculture_and_rural',
  business_metadata: 'Shows per-household distribution of operational holdings by size, social group, and household classification.',
  columns: 'f_value, indicator, sub_indicator, household_classification, social_group, season, operational_holding, data_source, updated_on, state, released_on',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 13392
});

CREATE (t:Table {
  name: 'sa_per_1000_agri_hh_insured_experienced_crop_loss',
  data_domain: 'agriculture_and_rural',
  business_metadata: 'Reflects the number per 1000 insured agricultural households that experienced crop loss during a particular season.',
  columns: 'f_value, indicator, visit, season, sub_indicator, crop_production, crop_experienced, data_source, updated_on, state, released_on',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 13950
});

CREATE (t:Table {
  name: 'sa_per_1000_crop_producing_hh_crop_disposal_agency_sale_satisf',
  data_domain: 'agriculture_and_rural',
  business_metadata: 'Indicates satisfaction levels with crop disposal via various agencies, reported per 1000 crop-producing households.',
  columns: 'f_value, indicator, season, major_disposal, level_of_satisfaction, subsatisfactory_name, agency, visit_name, data_source, updated_on, state, released_on',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 13950
});

CREATE (t:Table {
  name: 'sa_perc_dist_of_land_for_hhs_belonging_operational_holding',
  data_domain: 'agriculture_and_rural',
  business_metadata: 'Details percentage distribution of land area for households by operational holding size and ownership status.',
  columns: 'f_value, indicator, season, ownership_holding, possession, data_source, updated_on, state, released_on',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 8928
});

CREATE (t:Table {
  name: 'sa_percent_distribution_of_leased_out_land_by_terms_of_lease',
  data_domain: 'agriculture_and_rural',
  business_metadata: 'Provides percentage distribution of leased-out land categorized by terms of lease and ownership status.',
  columns: 'f_value, indicator, season, ownership_holding, terms_lease, data_source, updated_on, state, released_on',
  source: 'National Sample Survey Office, MoSPI',
  rows_count: 136080
});

CREATE (t:Table {
  name: 'statewise_nsdp',
  data_domain: 'GDP',
  business_metadata: 'This table contains statewise Net State Domestic Product (NSDP) data in both constant and current prices with growth rates by state and year. Use for queries about state-level economic performance, NSDP values, and state economic growth. ',
  columns: 'state, year, nsdp_crores_constant, nsdp_growth_constant_percent, nsdp_crores_current, nsdp_growth_current_percent, date_updated, source_url, source',
  source: '',
  rows_count: 476
});

CREATE (t:Table {
  name: 'statewise_nsva',
  data_domain: 'GDP',
  business_metadata: 'This table contains statewise Net State Value Added (NSVA) data in constant and current prices by state, industry, sub-industry, and economic sectors (primary, secondary, tertiary). Use for queries about sectoral contribution to state economies and industry-wise state performance.',
  columns: 'state, industry, sub_industry, is_primary, is_secondary, is_tertiary, year, publication_date, value_constant_lakh, value_current_lakh, data_updated_date, source_url, source',
  source: 'Ministry of Statistics And Programme Implementation',
  rows_count: 10611
});

CREATE (t:Table {
  name: 'statewise_pcnsdp',
  data_domain: 'GDP',
  business_metadata: 'This table contains statewise Net State Value Added (NSVA) data in constant and current prices by state, industry, sub-industry, and economic sectors (primary, secondary, tertiary). Use for queries about sectoral contribution to state economies and industry-wise state performance. ',
  columns: 'state, year, pc_nsdp_crores_constant, pc_nsdp_growth_constant_percent, pc_nsdp_crores_current, pc_nsdp_growth_current_percent, date_updated, source_url, source',
  source: 'Ministry of Statistics And Programme Implementation',
  rows_count: 476
});

CREATE (t:Table {
  name: 'periodic_labour_force_survey',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Provides state-wise labor market indicators such as LFPR, unemployment rate, and worker population ratio, disaggregated by gender, age group, sector, education, and social groups. Useful for analyzing employment trends and workforce demographics.',
  columns: 'year, state, gender, age_group, sector, status, religion, social_group, general_education, higher_education, labour_force_participation_rate, labour_force_participation_rate_unit, unemployment_rate, unemployment_rate_unit, worker_population_ratio, worker_population_ratio_unit, data_updated_date, source_url, source',
  source: 'National Sample Survey Office',
  rows_count: 74233
});

CREATE (t:Table {
  name: 'annual_survey_of_industries',
  data_domain: 'enterprise_establishment_surveys',
  business_metadata: 'Captures detailed industry-wise data based on NIC classifications across states and years, including indicators like output, employment, and financial performance. Ideal for analyzing trends in the formal industrial sector.',
  columns: 'nic_classification, year, state, sector, indicator, nic_code, nic_description, nic_type, value, unit, data_updated_date, source_url, source, source_extra',
  source: 'National Sample Survey Office',
  rows_count: 2120410
});

CREATE (t:Table {
  name: 'other_macro_economic_indicators_daily_data',
  data_domain: 'GDP',
  business_metadata: 'Provides daily time-series data on key macroeconomic indicators like stock indices (NIFTY, BANKEX), RBI interest rates (repo, reverse repo), and forex rates. Useful for tracking short-term market and monetary trends.',
  columns: 'date_stamp, nse_snp_cnx_nifty_index, bse_bankex_index, repo_rate_overnight_percent, reverse_repo_rate_overnight_percent, daily_call_money_rate_high_percent, daily_call_money_rate_low_percent, rbi_reference_rate_inr_per_usd',
  source: 'RBI Database on Economy',
  rows_count: 3716
});

CREATE (t:Table {
  name: 'other_macro_economic_indicators_monthly_data',
  data_domain: 'GDP',
  business_metadata: 'Contains monthly aggregated data on fiscal metrics, bank credit, trade, inflation (WPI), RBI balance sheet, and monetary aggregates. Ideal for analyzing macroeconomic health, monetary trends, and fiscal performance over time.',
  columns: 'date_stamp, m_one_crore, m_two_crore, m_three_crore, domestic_credit_crore, net_bank_credit_to_government_crore, bank_credit_to_commercial_sector_crore, credit_to_the_commercial_sector_by_the_banking_system_crore, sum_of_credit_to_the_government_and_credit_to_the_commercial_se, credit_to_the_government_by_the_banking_system_crore, fiscal_deficit_crore, gross_primary_deficit_crore, on_revenue_account_of_which_interest_payments_crore, total_revenue_crore, total_expenditure_crore, foreign_trade_exports_crore, foreign_trade_imports_crore, wpi_monthly_all_commodity_index, wpi_monthly_manufactured_products_index, market_capitalisation_bse_crore, rbi_balance_sheet_liabilities_crore, rbi_balance_sheet_currency_crore, rbi_balance_sheet_assets_crore, rbi_balance_sheet_loans_total_crore, rbi_balance_sheet_loans_banks_crore, rbi_balance_sheet_loans_governments_crore, rbi_balance_sheet_loans_others_crore, rbi_balance_sheet_domestic_securities_crore, currency_with_the_public_crore, demand_deposits_with_the_banks_crore, other_deposits_with_reserve_bank_crore',
  source: 'RBI Database on Economy',
  rows_count: 892
});

CREATE (t:Table {
  name: 'other_macro_economic_indicators_quaterly_data',
  data_domain: 'GDP',
  business_metadata: 'This dataset captures detailed quarterly Balance of Payments (BoP) metrics, GDP figures (at both constant and current prices), and the All India House Price Index. It includes:BoP components like current account (credits, debits, balance), capital account (FDI, portfolio investment, loans), services trade (travel, insurance), transfers (private and official), and errors & omissions in both INR and USD. Foreign investment flows into and out of India, helping track external sector health.',
  columns: 'date_stamp, all_india_house_price_index_in_units, bop_current_account_balance_crore, bop_current_account_credit_crore, bop_current_account_balance_usd_millions, bop_current_account_debit_crore, bop_current_account_debit_usd_millions, bop_direct_foreign_investment_abroad_net_crore, bop_direct_foreign_investment_abroad_net_usd_million, bop_direct_foreign_investment_india_net_inr_crore, bop_direct_foreign_investment_india_net_usd_million, bop_errors_and_omissions_net_inr_crore, bop_errors_and_omissions_net_usd_million, bop_foreign_direct_investment_india_abroad_net_inr_crore, bop_foreign_direct_investment_india_abroad_net_usd_million, bop_income_net_inr_crore, bop_merchandise_credit_inr_crore, bop_merchandise_debit_inr_crore, bop_merchandise_net_inr_crore, bop_monetary_movements_net_inr_crore, bop_monetary_movements_net_usd_million, bop_other_investment_loans_capital_debt_serivce_net_inr_crore, bop_other_investment_loans_capital_debt_serivce_net_usd_million, bop_portfolio_investment_abroad_net_inr_crore, bop_portfolio_investment_abroad_net_usd_million, bop_portfolio_investment_india_net_inr_crore, bop_portfolio_investment_india_net_usd_million, bop_portfolio_investment_net_crore, bop_portfolio_investment_net_usd_million, bop_gov_services_not_included_elsewhere_net_crore, bop_gov_services_not_included_elsewhere_net_usd_million, bop_services_insurance_net_crore, bop_services_insurance_usd_million, bop_services_crore, bop_services_travel_net_crore, bop_services_travel_net_usd_million, bop_total_capital_account_net_crore, bop_total_capital_account_net_usd_million, bop_transfer_official_credit_crore, bop_transfer_official_credit_usd_million, bop_transfer_official_debit_crore, bop_transfer_official_debit_usd_million, bop_transfer_private_credit_crore, bop_transfer_private_credit_usd_million, bop_transfer_private_debit_crore, bop_transfer_private_debit_usd_million, bop_transfers_total_net_crore, gdp_market_prices_constant, gdp_market_prices_current',
  source: 'RBI Database on Economy',
  rows_count: 61
});

CREATE (t:Table {
  name: 'other_macro_economic_indicators_weekly_data',
  data_domain: 'GDP',
  business_metadata: 'Weekly macroeconomic indicators capturing short-term interest rates (call money borrowing rates) and key foreign reserves data including foreign currency assets and total foreign exchange reserves.',
  columns: 'date_stamp, call_money_rate_borrowings_high_percent, call_money_rate_borrowings_low_percent, foreign_currency_assets_crore, foreign_exchange_reserves_crore',
  source: 'RBI Database on Economy',
  rows_count: 547
});

CREATE (t:Table {
  name: 'top_fifty_macro_economic_indicators_fortnightly_data',
  data_domain: 'GDP',
  business_metadata: 'Fortnightly snapshot of key macroeconomic indicators such as investment in India, aggregate deposits, money supply (M3), and important banking ratios like cash-deposit and credit-deposit ratios, along with outstanding certificates of deposit.',
  columns: 'date_stamp, investment_in_india_crore, aggregate_desposits_crore, cash_deposit_ratio_rate, credit_deposit_ratio_percentage, m_three_crore, certificates_of_deposit_amount_outstanding_crore',
  source: 'RBI Database on Economy',
  rows_count: 202
});

CREATE (t:Table {
  name: 'top_fifty_macro_economic_indicators_monthly_data',
  data_domain: 'GDP',
  business_metadata: 'Monthly data on major macroeconomic indicators, including foreign direct and portfolio investments, trade metrics (exports, imports, trade balance), digital and retail payments, market borrowings, and the exchange rate of the Indian Rupee against the US Dollar.',
  columns: 'date_stamp, commercial_paper_amount_outstanding_crores, net_foreign_direct_investment_us_dollars_million, direct_investment_to_india_us_dollars_million, foreign_direct_investment_by_india_us_dollars_million, net_portfolio_investment_us_dollars_million, total_investment_inflows_us_dollars_million, foreign_currency_non_resident_bank_us_dollars_million, external_commercial_borrowings_registrations_us_dollars_million, foreign_trade_exports_total_us_million_dollars, foreign_trade_imports_total_us_million_dollars, foreign_trade_balance_total_us_million_dollars, total_retail_payments_rupee_crore, total_digital_payments_rupee_crore, market_borrowing_sg_gross_amount_raised_rupee_crore, exchange_rate_of_indian_rupee_dollar_month_end',
  source: 'RBI Database on Economy',
  rows_count: 93
});

CREATE (t:Table {
  name: 'top_fifty_macro_economic_indicators_quaterly_data',
  data_domain: 'GDP',
  business_metadata: 'Quarterly data capturing key external sector indicators such as net balance of payments, international investment position, and India\'s gross external debt in USD million.',
  columns: 'date_stamp, overall_balance_of_payments_net_us_million_dollars, international_investment_position_net_us_miilion_dollars, indias_external_debt_gross_total_us_million_dollars',
  source: 'RBI Database on Economy',
  rows_count: 30
});

CREATE (t:Table {
  name: 'top_fifty_macro_economic_indicators_weekly_data',
  data_domain: 'GDP',
  business_metadata: 'Weekly data on key monetary and financial indicators including policy rates (repo, reverse repo, SDF, MSF, bank rate), treasury bill yields, government bond yields, forward premia of USD, reserve ratios (CRR, SLR), and foreign exchange reserves (in USD million).',
  columns: 'date_stamp, forward_premia_of_us_dollar_one_month_percentage, forward_premia_of_us_dollar_three_month_percentage, forward_premia_of_us_dollar_six_month_percentage, reverse_repo_rate_percentage, marginal_standing_facility_rate, bank_rate, base_rate, treasury_bill_91_day_primary_yield_percentage, treasury_bill_182_day_primary_yield_percentage, treasury_bill_364_day_primary_yield_percentage, g_sec_10_year_yield_fbil_percentage, cash_reserve_ratio_percentage, statutory_liquidity_ratio_percentage, policy_repo_rate_percentage, standing_deposit_facility_sdf_rate, foreign_exchange_reserves_us_dollar_million',
  source: 'RBI Database on Economy',
  rows_count: 403
});

CREATE (t:Table {
  name: 'gst_registrations',
  data_domain: 'GDP',
  business_metadata: 'This dataset presents GST registrations across Indian states by taxpayer type, including normal, composition, TCS, TDS, non-resident, OIDAR, and UIN holders.It helps analyze business distribution, GST scheme adoption, and regional economic activity.',
  columns: 'state, normal_taxpayers, composition_taxpayers, input_service_distributor, casual_taxpayers, tax_collector_at_source, tax_deductor_at_source, non_resident_taxpayers, oidar, uin_holders, total ',
  source: 'RBI Goods and Services',
  rows_count: 39
});

CREATE (t:Table {
  name: 'gst_settlement_of_igst_to_states',
  data_domain: 'GDP',
  business_metadata: 'This dataset details monthly IGST settlements from the central government to Indian states, covering both regular and adhoc components.It offers insights into state revenue flows, fiscal dynamics, and the impact of GST on state finances.',
  columns: 'fiscal_year, month, month_numeric, state, regular_settlement_crore, adhoc_settlement_crore, total_crore',
  source: 'RBI Goods and Services',
  rows_count: 2418
});

CREATE (t:Table {
  name: 'gst_statewise_tax_collection_data',
  data_domain: 'GDP',
  business_metadata: 'This dataset records monthly and yearly GST collections for each Indian state, detailing CGST, SGST, IGST, and CESS amounts.It enables trend analysis, state-wise comparisons, and assessment of GST’s contribution to overall revenue.',
  columns: 'fiscal_year, state_name, cgst_crore, sgst_crore, igst_crore, cess_crore, total_crore, month',
  source: 'RBI Goods and Services',
  rows_count: 2028
});

CREATE (t:Table {
  name: 'gst_statewise_tax_collection_refund_data',
  data_domain: 'GDP',
  business_metadata: 'This dataset details monthly and yearly GST refunds for each Indian state, segmented into CGST, SGST, IGST, and CESS.It supports analysis of refund flows, system efficiency, and the fiscal health of states.',
  columns: 'fiscal_year, state_name, cgst_refund_crore, sgst_refund_crore, igst_refund_crore, cess_refund_crore, total_refund_crore, month',
  source: 'RBI Goods and Services',
  rows_count: 1976
});

CREATE (t:Table {
  name: 'gstr_one',
  data_domain: 'GDP',
  business_metadata: 'This dataset tracks GSTR-1 return filing behavior across Indian states, including eligible taxpayers, timely and late filings, totals, and filing percentages.It enables analysis of GST compliance trends, state-wise performance, and changes over time.',
  columns: 'fiscal_year, month, state, filing_perc_as_on_30th_jun_2025, no_tax_payers_filed_by_due_date, no_of_tax_payers_eligible_to_file, no_of_tax_payers_filed_after_due_date, total_returns_filed',
  source: 'RBI Goods and Services',
  rows_count: 1900
});

CREATE (t:Table {
  name: 'gstr_three_b',
  data_domain: 'GDP',
  business_metadata: 'This dataset tracks GSTR-3B filing compliance across Indian states, detailing eligible taxpayers, timely and late filings, totals, and filing percentages.It helps analyze GST compliance trends, state-wise variations, and the effectiveness of tax administration.',
  columns: 'fiscal_year, month, state, filing_perc_as_on_30th_jun_2025, no_tax_payers_filed_by_due_date, no_of_tax_payers_eligible_to_file, no_of_tax_payers_filed_after_due_date, total_returns_filed',
  source: 'RBI Goods and Services',
  rows_count: 1900
});

CREATE (t:Table {
  name: 'gross_and_net_tax_collection',
  data_domain: 'GDP',
  business_metadata: 'This dataset details India’s gross and net tax collections, including GST revenues segmented by CGST, SGST, IGST, and CESS, with monthly and yearly figures.It offers insights into revenue trends, GST’s sectoral impact, and the nation’s fiscal health, sourced from the RBI.',
  columns: 'category, sub_category, year, month, monthly_value_crore, yearly_value_crore',
  source: 'RBI Goods and Services',
  rows_count: 952
});

CREATE (t:Table {
  name: 'niryat_ite_commodity',
  data_domain: 'GDP',
  business_metadata: 'Includes export values in million USD, month-on-month growth rates, and share of total exports for major commodity groups such as engineering goods, petroleum, pharmaceuticals, electronics, and textiles. Data is updated monthly by the Government of India via NIRYAT portal.',
  columns: 'fiscal_year, commodity_group, total_exports_mn_usd, mar_exports_mn_usd, feb_exports_mn_usd, mom_growth_percent, share_percent, updated_on',
  source: 'National Import Export Record for Yearly Analysis of Trade',
  rows_count: 64
});

CREATE (t:Table {
  name: 'niryat_ite_state',
  data_domain: 'GDP',
  business_metadata: 'Includes state-wise export values in million USD, monthly growth rates, and share of national exports. Helps assess regional export hubs such as Gujarat, Maharashtra, Tamil Nadu, and others. Data is updated monthly by the Government of India via the NIRYAT portal.',
  columns: 'fiscal_year, state_ut, total_exports_mn_usd, mar_exports_mn_usd, feb_exports_mn_usd, mom_growth_percent, share_percent, updated_on',
  source: 'National Import Export Record for Yearly Analysis of Trade',
  rows_count: 85
});

CREATE (t:Table {
  name: 'fpi_india_yr_invtype',
  data_domain: 'Finance_and_Industry',
  business_metadata: 'Structured yearly national-level FPI data; can answer queries on annual inflows/outflows, investment composition, trends across asset types, and cumulative totals',
  columns: 'financial_year, equity, debt_general_limit, debt_vrr, debt_far, hybrid, mutual_funds_equity, mutual_funds_debt, mutual_funds_hybrid, mutual_funds_solution_oriented, mutual_funds_other, aif, total_for_fy, cumulative_total, updated_on',
  source: 'FPI - NSDL',
  rows_count: 34
});

CREATE (t:Table {
  name: 'wages_sector_industry_index',
  data_domain: 'Finance_and_Industry',
  business_metadata: 'Structured dataset; can answer queries on wage trends across sectors and industries, base year comparison, and temporal changes in wages',
  columns: 'base_year, sector, industry, year, period_as_on, wri_index, updated_on',
  source: 'Labour Bureau',
  rows_count: 444
});

CREATE (t:Table {
  name: 'eshram_state_dly_registrations',
  data_domain: 'Finance_and_Industry',
  business_metadata: 'Structured dataset; can answer queries on daily registration counts by state, district, scheme-wise breakdown, and fiscal year aggregation',
  columns: 'state, district, ssk, csc, self, umang, other_scheme, total_registrations, released_on, updated_on, date_stamp, fiscal_year',
  source: 'eShram',
  rows_count: 778
});

CREATE (t:Table {
  name: 'stock_india_mth_boaccounts',
  data_domain: 'Finance_and_Industry',
  business_metadata: 'Structured dataset; can answer queries on monthly trends in new account openings, closures, and total BO accounts by category across India',
  columns: 'year, month, month_numeric, category, new_accounts, accounts_closed, accounts_end_current, released_on, updated_on, date_stamp',
  source: 'NSDL',
  rows_count: 78
});

CREATE (t:Table {
  name: 'stock_india_mth_dps',
  data_domain: 'Finance_and_Industry',
  business_metadata: 'Structured dataset; can answer queries on monthly participant trends, net changes, and category-wise participation across India',
  columns: 'year, month, month_numeric, category, participants_beginning, new_registered, cancelled, participants_end',
  source: 'NSDL',
  rows_count: 66
});

CREATE (t:Table {
  name: 'revenue_maharashtra_fy_category',
  data_domain: 'Finance_and_Industry',
  business_metadata: 'Structured dataset; supports queries on state revenue trends, category/sub-category breakdowns, and fiscal contribution percentages',
  columns: 'fiscal_year, category, sub_category, revenue_in_crore, percent_to_total, description',
  source: 'Government of Maharashtra',
  rows_count: 102
});

CREATE (t:Table {
  name: 'mf_monthly_schemes',
  data_domain: 'Finance_and_Industry',
  business_metadata: 'Structured dataset; enables analysis of monthly mutual fund trends, scheme performance, inflows/outflows, and net assets under management',
  columns: 'scheme_category, scheme_type, scheme_name, no_of_schemes, no_of_folios, funds_mobilized_inr_cr, repurchase_redemption_inr_cr, net_inflow_outflow_inr_cr, net_assets_under_management_inr_cr, average_net_assets_under_management_inr_cr, no_of_segregated_portfolios, net_assets_segregated_portfolio_inr_cr, month, month_numeric, year, fiscal_year, released_on, data_source',
  source: 'AMFI',
  rows_count: 1037
});

CREATE (t:Table {
  name: 'statewise_petroleum_consumption',
  data_domain: 'Finance_and_Industry',
  business_metadata: 'Structured dataset; allows analysis of state-level petroleum consumption trends over fiscal years',
  columns: 'state, quantity_in_000_tonne, fiscal_year',
  source: 'NITI Aayog - ICED',
  rows_count: 188
});

CREATE (t:Table {
  name: 'co2_emissions_by_fuel_yearly',
  data_domain: 'Finance_and_Industry',
  business_metadata: 'Structured dataset; supports analysis of annual CO2 emission trends by fuel type',
  columns: 'year, coal_mt_co2, oil_gas_mt_co2, updated_on',
  source: 'NITI Aayog - ICED',
  rows_count: 17
});

CREATE (t:Table {
  name: 'quick_estimates_major_commodities_july_export',
  data_domain: 'Finance_and_Industry',
  business_metadata: 'Structured dataset; supports analysis of monthly export trends and percent change by commodity',
  columns: 'commodity, value_inr_crore_jul24, value_inr_crore_apr24_jul24, value_inr_crore_jul25, value_inr_crore_apr25_jul25, percent_change_inr_jul25_vs_jul24, percent_change_inr_apr25_jul25_vs_apr24_jul24',
  source: 'Ministry of Commerce & Industry',
  rows_count: 32
});

CREATE (t:Table {
  name: 'quick_estimates_major_commodities_july_import',
  data_domain: 'Finance_and_Industry',
  business_metadata: 'Structured dataset; supports analysis of monthly import trends and percent change by commodity',
  columns: 'commodity, value_inr_crore_jul24, value_inr_crore_apr24_jul24, value_inr_crore_jul25, value_inr_crore_apr25_jul25, percent_change_inr_jul25_vs_jul24, percent_change_inr_apr25_jul25_vs_apr24_jul24',
  source: 'Ministry of Commerce & Industry',
  rows_count: 32
});

CREATE (t:Table {
  name: 'statewise_cumulative_renewable_power',
  data_domain: 'Finance_and_Industry',
  business_metadata: 'Structured dataset; supports analysis of renewable energy capacity trends across states and energy sources',
  columns: 'state_ut, year, small_hydro, wind, bio_power, waste_to_energy, solar, total, growth_rate_percent, released_on, updated_on, data_source, fiscal_year, date_stamp',
  source: 'MoSPI - Energy Statistics Division',
  rows_count: 78
});

CREATE (t:Table {
  name: 'marketcap_nse_india_mth',
  data_domain: 'Finance_and_Industry',
  business_metadata: 'Structured dataset; enables tracking of NSE market capitalization trends month-wise and fiscal year-wise',
  columns: 'fiscal_year, month, month_numeric, market_cap_in_lakhs, updated_on',
  source: 'RBI - Database on Indian Economy',
  rows_count: 28
});

CREATE (t:Table {
  name: 'ki_assam_mth_sctg',
  data_domain: 'Finance_and_Industry',
  business_metadata: 'Structured dataset; allows analysis of budget vs actuals and performance tracking of Assam state fiscal indicators',
  columns: 'indicator_category, indicator_type, indicator_name, budget_estimates, actuals, percentage_actual_budget_estimate_current, percentage_actual_budget_estimate_previous_year',
  source: 'Comptroller & Auditor General (CAG) - Assam State Accounts',
  rows_count: 41
});

CREATE (t:Table {
  name: 'insurance_india_mth_sctg',
  data_domain: 'Finance_and_Industry',
  business_metadata: 'Structured dataset; English content only; enables analysis of premiums, policy numbers, growth rates, and market share trends for non-life insurers',
  columns: 'insurer, fire, marine_total, marine_cargo, marine_hull, engineering, motor_total, motor_od, motor_tp, health, aviation, liability, pa, all_other_misc, grand_total, growth_percent, market_percent, accretion',
  source: 'General Insurance Council (GIC)',
  rows_count: 84
});

CREATE (t:Table {
  name: 'toll_state_monthly_etc_transactions',
  data_domain: 'Finance_and_Industry',
  business_metadata: 'Structured dataset; supports analysis of monthly toll transaction value and volume',
  columns: 'fiscal_year, month, fee_plaza_name, state, transaction_count, transaction_amount',
  source: 'IHMCL',
  rows_count: 27645
});

CREATE (t:Table {
  name: 'ev_state_yr_catg',
  data_domain: 'EV',
  business_metadata: 'Annual state-wise EV registration data from 2000 onwards, showing year-on-year EV registration and the share of EVs in total vehicle registrations by broad category (e.g., 2 Wheeler, 4 Wheeler). Data is structured for analysis of trends in EV adoption across Indian states.',
  columns: 'year, state, broad_category, ev_vehicle_registered, percentage_share_of_ev_in_total_vehicle_registered, updated_on',
  source: 'NITI Aayog - ICED',
  rows_count: 10920
});

CREATE (t:Table {
  name: 'trade_india_mth_commodity_import',
  data_domain: 'Trade',
  business_metadata: 'Monthly import data for all commodities, including HS codes, growth rates, and total imports, structured for analysis of trade trends.',
  columns: 'hscode, commodity, month, month_numeric, year, financial_year, values_in_cr, percentage_growth, updated_on',
  source: 'Ministry of Commerce - Trade Statistics',
  rows_count: 2772
});

CREATE (t:Table {
  name: 'trade_india_mth_commodity_export',
  data_domain: 'Trade',
  business_metadata: 'Monthly export data for all commodities, including HS codes, growth rates, and total exports, structured for analysis of trade trends.',
  columns: 'hscode, commodity, month, month_numeric, year, financial_year, values_in_cr, percentage_growth, updated_on',
  source: 'Ministry of Commerce - Trade Statistics',
  rows_count: 2772
});

CREATE (t:Table {
  name: 'trade_india_mth_stateut_country_export',
  data_domain: 'Trade',
  business_metadata: 'Monthly/annual export data for Indian states/UTs by country, including total exports, month-wise exports, growth rates, and percentage share. The commodity view is used to classify subgroups like engineering, petroleum, etc., for industry trend analysis. Timeline: last 5 years.',
  columns: 'states_ut_name, total_exports, march_exports_in_million_dollars, feb_exports_in_million_dollars, percentage_growth_compared_to_previous_month, percentage_share_in_selected_criteria_total_exports, fiscal_year, updated_on',
  source: 'Ministry of Commerce - Niryat Portal',
  rows_count: 185
});

CREATE (t:Table {
  name: 'trade_india_mth_commoditygrp_country_export',
  data_domain: 'Trade',
  business_metadata: 'Monthly/annual export data for Indian commodity groups by country, including total exports, month-wise exports, growth rates, and percentage share. The commodity view classifies subgroups like engineering, petroleum, etc., for understanding trends in specific industries. Timeline: last 5 years.',
  columns: 'commodity_group, total_exports, march_exports_in_million_dollars, feb_exports_in_million_dollars, percentage_growth_compared_to_previous_month, percentage_share_in_selected_criteria_total_exports, fiscal_year, updated_on',
  source: 'Ministry of Commerce - Niryat Portal',
  rows_count: 160
});

CREATE (t:Table {
  name: 'traffic_india_mth_air_passengers',
  data_domain: 'Traffic',
  business_metadata: 'Monthly and annual data of air passengers at Ayodhya Airport for the first half of 2024. Structured for analysis of passenger trends over time.',
  columns: 'year, month, month_numeric, passengers_numbers, updated_on',
  source: 'Data.gov.in',
  rows_count: 6
});

CREATE (t:Table {
  name: 'energy_india_statewise_coal_reserves',
  data_domain: 'Energy, Power and Renewable Resources',
  business_metadata: 'Annual state-wise data of estimated coal reserves, including proved, indicated, inferred reserves, total reserves, and distribution percentage. Structured for analysis of energy resources across Indian states.',
  columns: 'year, state, proved, indicated, inferred, total, distribution_percent, updated_on, released_on',
  source: 'MoSPI - Energy Statistics Division',
  rows_count: 32
});

CREATE (t:Table {
  name: 'energy_india_statewise_crude_oil_ngas_reserves',
  data_domain: 'Energy, Power and Renewable Resources',
  business_metadata: 'Annual state-wise data of estimated crude oil and natural gas reserves, including estimated reserves and distribution percentages. Structured for analysis of energy resources across Indian states.',
  columns: 'year, state, crude_oil_est_reserves, crude_oil_distribution_percent, natural_gas_est_reserves, natural_gas_distribution_percent, updated_on, released_on',
  source: 'MoSPI - Energy Statistics Division',
  rows_count: 30
});

CREATE (t:Table {
  name: 'labour_india_sector_industry_occupation_wages',
  data_domain: 'Labour',
  business_metadata: 'Annual data covering national, sector-wise, industry-wise, and occupation-wise wages with base year 2016. Structured for analysis of occupation-specific wage trends across states from 2020 to 2023.',
  columns: 'base_year, sector, industry, occupation, year, period_as_on, absolute_wages',
  source: 'Labour Bureau',
  rows_count: 5598
});

CREATE (t:Table {
  name: 'labour_india_rural_wages',
  data_domain: 'Labour',
  business_metadata: 'Biannual rural wage data (1st Jan and 1st July) covering national, state, sector, occupation, and item-wise wages for men and women. Structured for analyzing rural wage trends across occupations and items.',
  columns: 'year, month, state, occupation, item, men, women',
  source: 'Labour Bureau',
  rows_count: 66625
});

CREATE (t:Table {
  name: 'fdi_india_fy_state',
  data_domain: 'FDI',
  business_metadata: 'Quarterly FDI inflow data from 2020 to 2025 by state, including values in INR crore, USD million, and percentage of total inflow.',
  columns: 'state_name, fdi_in_inr_crore, fdi_in_usd_million, inflow_percentage, financial_year',
  source: 'Department for Promotion of Industry and Internal Trade (DPIIT), MoCI, GoI',
  rows_count: 176
});

CREATE (t:Table {
  name: 'fdi_india_fy_sector',
  data_domain: 'FDI',
  business_metadata: 'Quarterly FDI inflow data from 2020 to 2025 by sector, including values in INR crore, USD million, and percentage of total inflow.',
  columns: 'sector_name, fdi_in_inr_crore, fdi_in_usd_million, inflow_percentage, financial_year',
  source: 'Department for Promotion of Industry and Internal Trade (DPIIT), MoCI, GoI',
  rows_count: 344
});

CREATE (t:Table {
  name: 'fdi_india_fy_country',
  data_domain: 'FDI',
  business_metadata: 'Quarterly FDI inflow data from 2020 to 2025 by country, including values in INR crore, USD million, and percentage of total inflow.',
  columns: 'country_name, fdi_in_inr_crore, fdi_in_usd_million, inflow_percentage, financial_year',
  source: 'Department for Promotion of Industry and Internal Trade (DPIIT), MoCI, GoI',
  rows_count: 649
});

CREATE (t:Table {
  name: 'mf_india_qtr_total',
  data_domain: 'Mutual Funds',
  business_metadata: 'Quarterly mutual fund totals from 2020 onwards, capturing schemes, folios, net inflows/outflows, assets under management, and segregated portfolio AUM. Structured for trend analysis and summary reporting.',
  columns: 'scheme_name, no_of_schemes, no_of_folios, funds_mobilized, repurchase_redemption, net_inflow_outflow, net_assets_under_management, average_net_assets_under_management, no_of_segregated_portfolios, segregated_portfolio_aum, month, year, quarter',
  source: 'AMFI',
  rows_count: 737
});

CREATE (t:Table {
  name: 'sp_india_daily_state',
  data_domain: 'Social Protection (PM-JAY Performance)',
  business_metadata: 'Daily data by state/UT capturing Ayushman card issuance, hospital admissions, and empanelled hospitals. Structured for monitoring PM-JAY performance including gender and age distribution where available.',
  columns: 'state_name, total_ayushman_card_created, total_hospital_admissions, total_hospital_empanelled, updated_on',
  source: 'National Health Authority (NHA)',
  rows_count: 35
});

CREATE (t:Table {
  name: 'trade_india_annual_country',
  data_domain: 'Trade',
  business_metadata: 'Annual trade data covering India for 2020–2025, including all HS codes up to 6-digit level, with unit price details for India and world. Focused on India data due to time constraints; some country data presented as images is skipped.',
  columns: 'country, year, total_hs_code_tariff_line',
  source: 'Indian Trade Portal',
  rows_count: 156
});

CREATE (t:Table {
  name: 'insurance_india_mth_life_insurer',
  data_domain: 'Insurance',
  business_metadata: 'Monthly life insurance metrics from 2020–2025, covering total premiums, policy numbers, growth percentages, and market share by insurer. Last 6 months data will be ingested in SQL.',
  columns: 'insurer, category, metric_type, year, month, month_numeric, value, growth_percentage, market_share',
  source: 'IRDAI',
  rows_count: 2592
});

CREATE (t:Table {
  name: 'annual_chemical_production_data',
  data_domain: 'IIP',
  business_metadata: 'Annual production of major chemicals in India, categorized by product and chemical group, based on data from the Ministry of Chemicals and Fertilizers.',
  columns: 'group_name,product,year,value ',
  source: 'Ministry of Chemicals and Fertilizers, Government of India',
  rows_count: 736
});

CREATE (t:Table {
  name: 'crude_oil_mth_data',
  data_domain: 'Finance_and_Industry',
  business_metadata: 'Monthly quantity of crude oil processed by various public and private refineries in India.',
  columns: 'month, year, oil_company, quantity_metric_tonnes',
  source: 'Ministry of Petroleum and Natural Gas Petroleum Planning & Analysis Cell, Government of India',
  rows_count: 1392
});

CREATE (t:Table {
  name: 'ppac_mth_petroleum_consumption',
  data_domain: 'Finance_and_Industry',
  business_metadata: 'Monthly consumption in India for key petroleum products such as LPG, diesel, and petrol.',
  columns: 'month, year, products, quantity_metric_tonnes, updated_date',
  source: 'Ministry of Petroleum and Natural Gas Petroleum Planning & Analysis Cell, Government of India',
  rows_count: 792
});

CREATE (t:Table {
  name: 'airport_sewa_services_data',
  data_domain: 'social_migration_and_households',
  business_metadata: 'Details the services, amenities, and grievance redressal information available at various airports under the AirSewa initiative.',
  columns: 'airport, category, title, description, email, phone, website, last_updated',
  source: 'Aikosh',
  rows_count: 260
});

CREATE (t:Table {
  name: 'msme_sambandh_procurement_data',
  data_domain: 'MSME',
  business_metadata: 'Ministry-wise Procurement target vs achievement of mses, sc/st, women ',
  columns: 's_no, ministry_name, total_annual_target_crore, achievement_crore, target_mses_crore, achievement_mses_crore, target_sc_st_mses_crore, achievement_sc_st_mses_crore, target_women_mses_crore, target_women_mses_crore, achievement_women_mses_crore, fiscal_year',
  source: 'Ministry of Micro Small and Medium Enterprises',
  rows_count: 330
});

CREATE (t:Table {
  name: 'trade_india_mth_country',
  data_domain: 'Trade',
  business_metadata: 'Covers monthly country-wise Indian export data from 2020 to September 2025. Enables analysis of trade trends across nations. Supports queries like: “Which countries began importing new categories of Indian goods since 2022?”, and “Which countries started importing pharmaceutical products for the first time in 2022–2025?”. All countries are covered, with financial year and monthly granularity.',
  columns: 'country, year, month, value',
  source: 'Ministry of Commerce & Industry – TradeStat',
  rows_count: 2022
});

CREATE (t:Table {
  name: 'trade_india_mth_region',
  data_domain: 'Trade',
  business_metadata: 'Covers monthly region-wise Indian export data from 2020 to September 2025, with region and subregion splits. Enables analysis of regional demand patterns and seasonal export peaks. Supports queries such as: “Which regions showed a seasonal peak in exports for textiles from 2018 to 2025?”. Data is structured for all months and regions, allowing strategic planning for logistics and production.',
  columns: 'region, subregion, month, year, value, type',
  source: 'Ministry of Commerce & Industry – TradeStat',
  rows_count: 364
});

CREATE (t:Table {
  name: 'epfo_india_mth_payroll_view',
  data_domain: 'EPFO',
  business_metadata: 'Covers monthly payroll data from 2020 to August 2025, split by age groups and establishments remitting first ECR. Source includes comprehensive Excel/PDF with state, gender, industry, additions, and exits. Helps map formal jobs, demographics, sector splits, and workforce dynamics. Example queries: “Which sector added most jobs?”, “Exits and additions state-wise?”.',
  columns: 'month, age_less_than_18, age_18_21, age_22_25, age_26_28, age_29_35, age_more_than_35, total, establishments_remitting_first_ecr',
  source: 'EPFO (Employees’ Provident Fund Organisation)',
  rows_count: 70
});

CREATE (t:Table {
  name: 'trade_india_mth_region_commodity',
  data_domain: 'Trade',
  business_metadata: 'Covers monthly region–commodity wise export data from 2020 to September 2025. Includes HS code, commodity name, and export values. Enables analysis of regional contributions to total exports and how they changed during global events. Example query: “What is the change in export share by region before and after the COVID-19 pandemic?”. Data allows detailed commodity-level drilldowns for all regions across the last five years.',
  columns: 'hscode, commodity, region, year, month, value_in_crore, percentage_growth',
  source: 'Ministry of Commerce & Industry – TradeStat',
  rows_count: 2765
});

CREATE (t:Table {
  name: 'rbi_india_mth_payment_system_indicators',
  data_domain: 'RBI',
  business_metadata: 'Covers monthly data from FY21 onwards for payment systems. Includes section, item, sub_item, monthly volume (in lakhs) and value (in crores). Priority for Go-Live ingestion: Monthly/Bi-monthly/Quarterly/Half-yearly/Annual data. Daily/Weekly data can be considered second priority. Occasional updates are ignored for Go-Live.',
  columns: 'section, item, sub_item, month, year, volume_in_lakhs, value_in_crores',
  source: 'Reserve Bank of India',
  rows_count: 240
});

CREATE (t:Table {
  name: 'rbi_india_mth_bank_rtgs',
  data_domain: 'RBI',
  business_metadata: 'Covers monthly RTGS data from FY21 onwards. Includes bank-wise inward and outward transaction volumes and values. Priority for Go-Live ingestion: Monthly/Bi-monthly/Quarterly/Half-yearly/Annual data. Daily/Weekly data can be considered second priority. Occasional updates are ignored for Go-Live.',
  columns: 'month, month_numeric, year, bank_name, inward_volume_interbank, inward_volume_customer, inward_volume_total, inward_volume_percent, inward_value_interbank_crore, inward_value_customer_crore, inward_value_total_crore, inward_value_percent, outward_volume_interbank, outward_volume_customer, outward_volume_total, outward_volume_percent, outward_value_interbank_crore, outward_value_customer_crore, outward_value_total_crore, outward_value_percent',
  source: 'Reserve Bank of India',
  rows_count: 1485
});

CREATE (t:Table {
  name: 'rbi_india_mth_bank_neft',
  data_domain: 'RBI',
  business_metadata: 'Covers monthly NEFT data from FY21 onwards. Includes bank-wise inward credit and outward debit counts and amounts. Priority for Go-Live ingestion: Monthly/Bi-monthly/Quarterly/Half-yearly/Annual data. Daily/Weekly data can be considered second priority. Occasional updates are ignored for Go-Live.',
  columns: 'month, month_numeric, year, bank_name, received_inward_credits_count, received_inward_credits_amount_crore, total_outward_debits_count, total_outward_debits_amount_crore',
  source: 'Reserve Bank of India',
  rows_count: 1421
});

CREATE (t:Table {
  name: 'rbi_india_mth_bank_mobile_banking',
  data_domain: 'RBI',
  business_metadata: 'Covers monthly mobile banking data from FY21 onwards. Includes bank-wise transaction volume, value, and number of active mobile banking customers. Priority for Go-Live ingestion: Monthly/Bi-monthly/Quarterly/Half-yearly/Annual data. Daily/Weekly data can be considered second priority. Occasional updates are ignored for Go-Live.',
  columns: 'month, month_numeric, year, bank_name, volume_actuals, value_rs_thousand, active_customers_mobile_banking',
  source: 'Reserve Bank of India',
  rows_count: 3482
});

CREATE (t:Table {
  name: 'rbi_india_mth_bank_internet_banking',
  data_domain: 'RBI',
  business_metadata: 'Covers monthly internet banking data from FY21 onwards. Includes bank-wise transaction volume, value, and number of active internet banking customers. Priority for Go-Live ingestion: Monthly/Bi-monthly/Quarterly/Half-yearly/Annual data. Daily/Weekly data can be considered second priority. Occasional updates are ignored for Go-Live.',
  columns: 'month, month_numeric, year, bank_name, volume_actuals, value_rs_thousand, active_customers_internet_banking',
  source: 'Reserve Bank of India',
  rows_count: 766
});

CREATE (t:Table {
  name: 'demography_india_yr_popsexgrowth',
  data_domain: 'Demography',
  business_metadata: 'Trends in population, sex ratio, and average annual growth rate of population of post-independence India. Covers rural, urban, and total populations by gender. All 106 datasets ingested.',
  columns: 'year, rural_male, rural_female, rural_person, rural_sex_ratio, urban_male, urban_female, urban_person, urban_sex_ratio, total_male, total_female, total_person, total_sex_ratio, aagr_male, aagr_female, aagr_person',
  source: 'MOSPI',
  rows_count: 12
});

CREATE (t:Table {
  name: 'demography_india_state_yr_literacy',
  data_domain: 'Demography',
  business_metadata: 'Percentage of persons able to read and write short simple statements in their everyday life with understanding. All 26 datasets ingested.',
  columns: 'state_ut, age_group, rural_male, rural_female, rural_person, urban_male, urban_female, urban_person, all_male, all_female, all_person',
  source: 'MOSPI',
  rows_count: 111
});

CREATE (t:Table {
  name: 'hces_india_yr_sector',
  data_domain: 'Household Consumption Expenditure',
  business_metadata: 'All 54 datasets ingested; includes imputed MPCE values for rural and urban sectors.',
  columns: 'state_ut, rural_avg_mpce, urban_avg_mpce, rural_avg_mpce_imputed, urban_avg_mpce_imputed',
  source: 'MOSPI',
  rows_count: 37
});

CREATE (t:Table {
  name: 'asi_imp_principal_characteristics_by_rural_urban_sector',
  data_domain: 'Industry Survey',
  business_metadata: 'All 11 datasets ingested; data split by rural and urban sectors.',
  columns: 'year, rural, urban, principal_characteristics, release_on, updated_on, data_source',
  source: 'MOSPI',
  rows_count: 91
});

CREATE (t:Table {
  name: 'asi_imp_principal_characteristics_india_by_mjr_indus_grp',
  data_domain: 'Industry Survey',
  business_metadata: 'All 11 datasets ingested; data split by major industry groups.',
  columns: 'year, food_products, beverages, tobacco_products, textiles, wearing_apparel, cotton_ginning_cleaning_and_bailing_seed_processing_for_propagation, salt_production_by_evaporation_of_sea_water_or_other_saline_water, leather_and_related_products, wood_and_products_of_wood_and_cork_except_furniture, paper_and_paper_products, printing_and_reproduction_of_recorded_media, coke_and_refined_petroleum_products, chemicals_and_chemical_products, pharmaceuticals_medicinal_chemical_and_botanical_products, rubber_and_plastics_products, other_non_metallic_mineral_products, basic_metals, fabricated_metal_products_except_machinery_and_equipment, computer_electronic_and_optical_products, electrical_equipment, machinery_and_equipment_nec, motor_vehicles_trailers_and_semi_trailers, other_transport_equipment, manufacture_of_furniture, 32_other_manufacturing, repair_and_installation_of_machinery_and_equipment, waste_collection_treatment_disposal_activities_materials_recovered, publishing_activities, other_industries, characteristics, release_on, updated_on, data_source',
  source: 'MOSPI',
  rows_count: 91
});

CREATE (t:Table {
  name: 'asi_industrywise_factories_2022_23',
  data_domain: 'Industry Survey',
  business_metadata: 'All 11 datasets ingested; data split by type of industries.',
  columns: 'type_of_industries, no_of_factories, release_on, updated_on, data_source',
  source: 'MOSPI',
  rows_count: 29
});

CREATE (t:Table {
  name: 'asi_no_of_workers_and_person_engaged',
  data_domain: 'Industry Survey',
  business_metadata: 'All 11 datasets ingested; data includes workers and total persons engaged per year.',
  columns: 'year, no_of_workers, total_person_engaged, release_on, updated_on, data_source',
  source: 'MOSPI',
  rows_count: 42
});

CREATE (t:Table {
  name: 'asi_num_of_factories_nva',
  data_domain: 'Industry Survey',
  business_metadata: 'All 11 datasets ingested; data includes number of factories and net value added per year.',
  columns: 'year, net_value_added_nva_lakhs, no_of_factories, release_on, updated_on, data_source',
  source: 'MOSPI',
  rows_count: 42
});

CREATE (t:Table {
  name: 'asi_statewise_number_of_factories_for_2022_23',
  data_domain: 'Industry Survey',
  business_metadata: 'All 11 datasets ingested; data includes number of factories by state for 2022-23.',
  columns: 'states, number_of_factories_in_no, release_on, updated_on, data_source',
  source: 'MOSPI',
  rows_count: 35
});

CREATE (t:Table {
  name: 'asi_top_ten_states_by_number_of_factories',
  data_domain: 'Industry Survey',
  business_metadata: 'All 11 datasets ingested; data includes top ten states by number of factories for multiple years up to 2022-23.',
  columns: 'states, 2010_11, 2011_12, 2012_13, 2013_14, 2014_15, 2015_16, 2016_17, 2017_18, 2018_19, 2019_20, 2020_21, 2021_22, 2022_23, release_on, updated_on, data_source',
  source: 'MOSPI',
  rows_count: 37
});

CREATE (t:Table {
  name: 'asi_trend_imp_characteristics_technical_coefficients',
  data_domain: 'Industry Survey',
  business_metadata: 'All 11 datasets ingested; data includes trends in important characteristics with technical coefficients by region.',
  columns: 'year, technical_co_efficients, region, release_on, updated_on, data_source',
  source: 'MOSPI',
  rows_count: 36
});

CREATE (t:Table {
  name: 'asi_trend_of_imp_characteristics_structural_ratios',
  data_domain: 'Industry Survey',
  business_metadata: 'All 11 datasets ingested; data includes trends in important characteristics with structural ratios by region.',
  columns: 'year, structural_ratios, region, release_on, updated_on, data_source',
  source: 'MOSPI',
  rows_count: 48
});

CREATE (t:Table {
  name: 'asi_trend_of_imp_principal_characteristics_india',
  data_domain: 'Industry Survey',
  business_metadata: 'All 11 datasets ingested; includes annual trends of important principal characteristics for India by income category.',
  columns: 'year, value, income, release_on, updated_on, data_source',
  source: 'MOSPI',
  rows_count: 294
});

CREATE (t:Table {
  name: 'iip_in_assam',
  data_domain: 'IIP',
  business_metadata: 'Structured dataset extracted from Assam IIP PDF (2019-20 to 2022-23); used for analyzing state-level industrial performance, growth patterns, and Covid-19 impact.',
  columns: 'nic_code, industry_description, weight, year, index_value, updated_on',
  source: 'Directorate of Economics & Statistics, Assam',
  rows_count: 220
});

CREATE (t:Table {
  name: 'iip_in_kerala_fy_index',
  data_domain: 'IIP',
  business_metadata: 'Structured dataset covering quarterly IIP data for Kerala from 2019 to 2024, sourced from ECOSTAT Excel files containing seven sheets representing different industrial categories.',
  columns: 'fiscal_year, category, index_value, updated_on',
  source: 'Department of Economics and Statistics, Government of Kerala (ECOSTAT)',
  rows_count: 58
});

CREATE (t:Table {
  name: 'iip_in_kerala_monthly',
  data_domain: 'IIP',
  business_metadata: 'Structured dataset containing monthly IIP data for Kerala across multiple industrial categories for fiscal years 2019–2024, extracted from ECOSTAT Excel files with seven categorized sheets.',
  columns: 'fiscal_year, category, month, index_value, updated_on',
  source: 'Department of Economics and Statistics, Government of Kerala (ECOSTAT)',
  rows_count: 491
});

CREATE (t:Table {
  name: 'iip_in_kerala_quarterly',
  data_domain: 'IIP',
  business_metadata: 'Structured dataset containing quarterly IIP data for Kerala across multiple industrial categories for fiscal years 2019–2024, extracted from ECOSTAT Excel files with seven categorized sheets representing sectoral performance.',
  columns: 'fiscal_year, quarter, category, index_value, updated_on',
  source: 'Department of Economics and Statistics, Government of Kerala (ECOSTAT)',
  rows_count: 168
});

CREATE (t:Table {
  name: 'iip_in_rajasthan_fy_index',
  data_domain: 'IIP',
  business_metadata: 'Structured dataset providing financial year-wise IIP data for Rajasthan across major categories — All Industries, Manufacturing, Electricity, and Mining. Data extracted from the Rajasthan IIP portal using category and year filters, covering approximately five fiscal years from 2018–19 to 2023–24.',
  columns: 'fiscal_year, category, index_value, updated_on',
  source: 'Directorate of Economics and Statistics, Government of Rajasthan',
  rows_count: 20
});

CREATE (t:Table {
  name: 'iip_in_rajasthan_monthly',
  data_domain: 'IIP',
  business_metadata: 'Structured dataset providing month-wise IIP data for Rajasthan across key industrial categories — All Industries, Manufacturing, Electricity, and Mining. Data sourced from the Rajasthan IIP portal using category and year filters covering approximately five fiscal years from 2018–19 to 2023–24.',
  columns: 'fiscal_year, category, month, index_value, updated_on',
  source: 'Directorate of Economics and Statistics, Government of Rajasthan',
  rows_count: 204
});

CREATE (t:Table {
  name: 'iip_in_rajasthan_two_digit_index',
  data_domain: 'IIP',
  business_metadata: 'Structured dataset showing two-digit industry-level IIP data for Rajasthan across approximately five fiscal years (2018–19 to 2023–24). Data extracted from the Rajasthan IIP portal using category and year filters for granular sectoral analysis.',
  columns: 'nic_code, industry_description, fiscal_year, index_value, updated_on',
  source: 'Directorate of Economics and Statistics, Government of Rajasthan',
  rows_count: 115
});

CREATE (t:Table {
  name: 'iip_in_andra_pradesh_sector_industry_wise',
  data_domain: 'IIP',
  business_metadata: 'Structured dataset containing sector- and industry-wise IIP data for Andhra Pradesh derived from DES monthly PDF reports (“Statement I, II, III”) for the period Jan 2019 to June 2024. Useful for tracking industrial performance and sectoral trends across time.',
  columns: 'nic_code, industry_description, weight, year, month, index_value, updated_on',
  source: 'Directorate of Economics and Statistics, Government of Andhra Pradesh',
  rows_count: 170
});

CREATE (t:Table {
  name: 'iip_in_andra_pradesh_sector_wise',
  data_domain: 'IIP',
  business_metadata: 'Structured dataset providing sector-wise monthly IIP data for Andhra Pradesh from Jan 2019 to June 2024, sourced from DES “Monthly Index of Industrial Production” reports. Covers key industrial sectors for tracking production trends and economic performance at the state level.',
  columns: 'sector, fiscal_year, month, index_value, updated_on',
  source: 'Directorate of Economics and Statistics, Government of Andhra Pradesh',
  rows_count: 148
});

CREATE (t:Table {
  name: 'iip_in_andra_pradesh_use_wise',
  data_domain: 'IIP',
  business_metadata: 'Structured dataset presenting use-based monthly IIP data for Andhra Pradesh from Jan 2019 to June 2024. Covers various use categories to analyze industrial production trends and the contribution of different goods types to overall state-level industrial growth.',
  columns: 'use, fiscal_year, month, index_value, updated_on',
  source: 'Directorate of Economics and Statistics, Government of Andhra Pradesh',
  rows_count: 160
});

CREATE (t:Table {
  name: 'imf_dm_export',
  data_domain: 'Macro-economic aggregates',
  business_metadata: 'Structured dataset representing the percentage share of each country’s GDP (PPP) relative to the world total, as published in IMF’s World Economic Outlook DataMapper. Covers annual data from 1980 to 2029 across advanced, emerging, and developing economies; useful for comparative macroeconomic analysis and global growth distribution trends.',
  columns: 'country, year, gdp_share_ppp, updated_on',
  source: 'International Monetary Fund (IMF) DataMapper',
  rows_count: 11577
});

CREATE (t:Table {
  name: 'irdai_nonlife_india_mth_insurer',
  data_domain: 'Insurance',
  business_metadata: 'Structured dataset containing monthly performance metrics of non-life insurers in India. Covers total and cumulative premium values, growth rates, and market share across categories. Hindi text was excluded; only English data was retained and processed for accurate analysis.',
  columns: 'released_on, insurer_name, premium_month_current, premium_month_previous, premium_cumulative_current, premium_cumulative_previous, market_share, growth_pct, category, month, month_numeric, updated_on',
  source: 'Insurance Regulatory and Development Authority of India (IRDAI)',
  rows_count: 503
});

CREATE (t:Table {
  name: 'youthpower_district_level_metrics',
  data_domain: 'Youth Development',
  business_metadata: 'District-level youth development scorecards measuring economic opportunity, workforce participation, education quality, and skills readiness. Composite Y-Power scores track youth progress across four key dimensions with detailed metrics on population, MSMEs, employment, schools, colleges, ITI, and PMKVY programs for policy analysis and inter-district comparisons.',
  columns: 'state, district, year, y_power_score, opportunity_score, workforce_score, education_score, readiness_and_skills_score, total_population_in_lacs, total_youth_population_in_lacs, savings_per_working_age_in_lacs, mudra_loan_to_labour_force_ratio_in_thousands, csr_spending_per_capita_in_rupees, csr_share_percent, msmes_per_10k_population, trains_per_week_per_1000_sqkm, msme_micro_percent, msme_small_percent, msme_medium_percent, manufacturing_enterprises_percent, services_enterprises_percent, number_of_jobs_in_lacs, registered_unorganised_workers_in_lacs, labor_force_participation_percent, unemployment_rate, epfo_coverage_rate, salaried_regular_workers_percent, self_employed_workers_percent, casual_workers_percent, msme_micro_employment_percent, msme_small_employment_percent, msme_medium_employment_percent, number_of_schools_in_thousands, private_schools_percent, vocational_schools_percent, enrollment_ratio, ger_class_6_to_8, ger_class_9_to_12, test_scores_percent, english_score_class_10, maths_score_class_10, number_of_colleges, accredited_colleges_percent, private_colleges_percent, iti_seats_per_lac_youth, iti_vacant_seats_percent, iti_seats_top_3_trades_percent, seats_in_top_3_trades_in_thousands, trainer_vacancies_percent, certified_trainers_percent, pmkvy_enrollment_per_lac, pmkvy_assessment_percent, pmkvy_certification_percent, pmkvy_enrollments_top_3_jobs_percent, top_skill_1, top_skill_2, top_skill_3, released_on, updated_on, date_stamp',
  source: 'YouthPower website',
  rows_count: 714
});

CREATE (t:Table {
  name: 'netc_india_mth_stats',
  data_domain: 'Toll / Fastag',
  business_metadata: 'Structured dataset covering monthly Fastag issuance and transaction statistics for India from 2016 to June 2025. Includes total volume, average daily volume, total transaction value, and average daily transaction value.',
  columns: 'month, year, volume_in_mn, avg_daily_volume_in_mn, value_in_cr, avg_daily_value_in_cr, month_numeric',
  source: 'National Payments Corporation of India (NPCI)',
  rows_count: 47
});

CREATE (t:Table {
  name: 'ewb_state_mth_stats',
  data_domain: 'GST',
  business_metadata: 'Structured dataset capturing monthly E-way bill activity for all Indian states from 2017 to 2025. Includes counts and assessable values for within-state, outgoing, and incoming transactions.',
  columns: 'state_name, year, month_numeric, within_state_no_of_suppliers, within_state_no_of_ewb, within_state_assessable_value_crore, outgoing_no_of_suppliers, outgoing_no_of_ewb, outgoing_assessable_value_crore, incoming_no_of_suppliers, incoming_no_of_ewb, incoming_assessable_value_crore',
  source: 'GST Council / gst.gov.in',
  rows_count: 3246
});

CREATE (t:Table {
  name: 'tlm_state_yr_transport_access',
  data_domain: 'Transportation, Logistics and Mobility',
  business_metadata: 'Structured annual dataset (Jun 2022 – Jun 2023) capturing transport access metrics for urban and rural populations by State/UT, based on the Household Consumption Expenditure Survey, Table 23.',
  columns: 'state_ut, year, urban_low_capacity_transport_access_pct, urban_high_capacity_transport_access_pct, rural_all_weather_road_access_pct, released_on, updated_on',
  source: 'Ministry of Statistics and Program Implementation | Government Of India',
  rows_count: 37
});

CREATE (t:Table {
  name: 'hces_state_yr_assets',
  data_domain: 'Household consumption expenditure survey',
  business_metadata: 'Structured annual dataset (Jun 2022 – Jun 2023) capturing household asset ownership at state and rural/urban level, based on the Household Consumption Expenditure Survey, Table 22.',
  columns: 'state_ut, year, telephone_mobile_rural, telephone_mobile_urban, telephone_mobile_all, computer_rural, computer_urban, computer_all, released_on, updated_on',
  source: 'Ministry of Statistics and Program Implementation | Government Of India',
  rows_count: 37
});

CREATE (t:Table {
  name: 'env_state_yr_river_water_quality',
  data_domain: 'Environment',
  business_metadata: 'Structured annual dataset for 32 states capturing multiple river water quality parameters, sourced from EnviStats India (2022), useful for monitoring environmental health and inter-state comparisons.',
  columns: 'state_ut, year, temperature_min_c, temperature_max_c, dissolved_oxygen_min_mg_l, dissolved_oxygen_max_mg_l, ph_min, ph_max, conductivity_min_umho_cm, conductivity_max_umho_cm, bocd_min_mg_l, bocd_max_mg_l, nitrate_min_mg_l, nitrate_max_mg_l, faecal_coliform_min_mpn_100ml, faecal_coliform_max_mpn_100ml, total_coliform_min_mpn_100ml, total_coliform_max_mpn_100ml, released_on, updated_on',
  source: 'Ministry of Statistics and Program Implementation | Government of India',
  rows_count: 32
});

CREATE (t:Table {
  name: 'company_india_annual_type_mca',
  data_domain: 'Ministry of Corporate Affairs',
  business_metadata: 'Structured annual national-level dataset presenting the distribution of companies by ownership and paid-up capital size, useful for analyzing corporate structure trends in India.',
  columns: 'financial_year, company_type, paid_up_share_capital_crore, number_of_companies, percentage_of_total_companies',
  source: 'Ministry of Corporate Affairs (MCA)',
  rows_count: 24
});

CREATE (t:Table {
  name: 'epfo_nat_ind_exempted_establishments_list',
  data_domain: 'EPFO',
  business_metadata: 'Structured national-level dataset listing exempted establishments under EPFO, last updated in August 2024. Useful for identifying compliance patterns, sectoral distribution, and policy impact of exemption coverage.',
  columns: 'est_id, est_name, month, month_numeric, released_on, updated_on',
  source: 'Employees’ Provident Fund Organisation (EPFO), Government of India',
  rows_count: 1279
});

CREATE (t:Table {
  name: 'ins_nat_yr_fin_highlights',
  data_domain: 'Insurance',
  business_metadata: 'Structured national-level dataset presenting key financial and operational indicators of insurers, valuable for analyzing industry size, capital structure, and distribution network.',
  columns: 'category, company_name, no_of_employees, no_of_agents_brokers, no_of_offices, no_of_policies, no_of_point_of_sale_personnel, fdi_rs_cr, capital_free_reserves_rs_cr, financial_year, released_on, updated_on',
  source: 'Insurance Regulatory and Development Authority of India (IRDAI)',
  rows_count: 161
});

CREATE (t:Table {
  name: 'energy_nat_ann_petroleum_products_consumption',
  data_domain: 'Energy, Power and Renewable Resources',
  business_metadata: 'Structured annual dataset containing national-level consumption volumes for key petroleum products, last updated in August 2025. Useful for analyzing energy demand trends, refining sector performance, and fuel consumption patterns across India.',
  columns: 'month, year, products, quantity_000_metric_tonnes, updated_date',
  source: 'Ministry of Petroleum and Natural Gas, Government of India',
  rows_count: 492
});

CREATE (t:Table {
  name: 'energy_wld_nat_mth_crude_petroleum_trade',
  data_domain: 'Energy, Power and Renewable Resources',
  business_metadata: 'Structured dataset offering monthly and annual statistics on crude oil and petroleum product trade by Indian oil companies. Includes information on product category, trade type, and trade value, facilitating analysis of India’s energy import-export balance and dependency trends.',
  columns: 'month, year, products, trade, quantity_000_metric_tonnes, value_rs_crore, value_usd_million, date_updated',
  source: 'Ministry of Petroleum and Natural Gas, Government of India',
  rows_count: 364
});

CREATE (t:Table {
  name: 'energy_nat_mth_crude_oil_prod',
  data_domain: 'Energy, Power and Renewable Resources',
  business_metadata: 'Structured dataset containing monthly indigenous crude oil production data for India. Enables analysis of company-wise production performance, national output trends, and contribution to India’s overall energy self-reliance.',
  columns: 'month, year, company_name, quantity_000_metric_tonnes',
  source: 'Ministry of Petroleum and Natural Gas, Government of India',
  rows_count: 168
});

CREATE (t:Table {
  name: 'energy_nat_mth_petroleum_prod',
  data_domain: 'Energy, Power and Renewable Resources',
  business_metadata: 'Structured dataset representing monthly production data of petroleum products across India, enabling analysis of refinery output trends, product-specific production patterns, and national energy supply dynamics.',
  columns: 'month, year, products, quantity_000_metric_tonnes, updated_date',
  source: 'Ministry of Petroleum and Natural Gas, Government of India',
  rows_count: 360
});

CREATE (t:Table {
  name: 'mca_nat_mth_comp_closed',
  data_domain: 'Ministry of Corporate Affairs',
  business_metadata: 'Structured dataset listing companies that ceased operations, categorized by month and year. Useful for analyzing business closure trends, economic health indicators, and sectoral exit patterns in India.',
  columns: 'cin, company_name, month, month_numeric, year, released_on, updated_on',
  source: 'Ministry of Corporate Affairs, Government of India',
  rows_count: 9338
});

CREATE (t:Table {
  name: 'mca_nat_mth_companies_registered',
  data_domain: 'Ministry of Corporate Affairs',
  business_metadata: 'Structured dataset providing monthly records of newly registered companies across India. Useful for analyzing entrepreneurship trends, business growth, and sectoral distribution over time.',
  columns: 'cin, class, company_name, date_of_registration, company_type, activity_code, released_on, updated_on',
  source: 'Ministry of Corporate Affairs, Government of India',
  rows_count: 177562
});

CREATE (t:Table {
  name: 'gst_statewise_fiscal_year_collection_view',
  data_domain: 'GDP',
  business_metadata: 'This dataset records monthly and yearly GST collections for each Indian state, detailing CGST, SGST, IGST, and CESS amounts.It enables trend analysis, state-wise comparisons, and assessment of GST’s contribution to overall revenue.',
  columns: 'fiscal_year, state_name, cgst_crore, sgst_crore, igst_crore, cess_crore, total_crore, month',
  source: 'RBI Goods and Services',
  rows_count: 2028
});

CREATE (t:Table {
  name: 'gst_statewise_fiscal_year_igst_settlement_view',
  data_domain: 'GDP',
  business_metadata: 'This dataset details monthly IGST settlements from the central government to Indian states, covering both regular and adhoc components.It offers insights into state revenue flows, fiscal dynamics, and the impact of GST on state finances.',
  columns: 'fiscal_year, month, month_numeric, state, regular_settlement_crore, adhoc_settlement_crore, total_crore',
  source: 'RBI Goods and Services',
  rows_count: 2418
});

CREATE (t:Table {
  name: 'gst_statewise_fiscal_year_refund_view',
  data_domain: 'GDP',
  business_metadata: 'This dataset details monthly and yearly GST refunds for each Indian state, segmented into CGST, SGST, IGST, and CESS.It supports analysis of refund flows, system efficiency, and the fiscal health of states.',
  columns: 'fiscal_year, state_name, cgst_refund_crore, sgst_refund_crore, igst_refund_crore, cess_refund_crore, total_refund_crore, month',
  source: 'RBI Goods and Services',
  rows_count: 1976
});

CREATE (t:Table {
  name: 'msme_global_view',
  data_domain: 'MSME',
  business_metadata: 'Comparative international MSME data for regional economic analysis.',
  columns: 'source, region, country, year, value',
  source: 'Asian Development Bank / ERDI',
  rows_count: 6556
});

CREATE (t:Table {
  name: 'iip_india_yr_sctg',
  data_domain: 'IIP',
  business_metadata: 'Annual IIP index and growth trends across sectors and categories based on a base year.',
  columns: 'id, base_year, year, sector_type, category, sub_category, iip_index, iip_growth_rate, data_source, released_on, updated_on',
  source: 'MoSPI - Economic Statistics Division',
  rows_count: 429
});

CREATE (t:Table {
  name: 'iip_india_yr_subcatg_view',
  data_domain: 'IIP',
  business_metadata: 'Annual IIP index and growth trends across sectors and categories based on a base year.',
  columns: 'id, base_year, year, sector_type, category, sub_category, iip_index, iip_growth_rate, data_source, released_on, updated_on',
  source: 'MoSPI - Economic Statistics Division',
  rows_count: 429
});

CREATE (t:Table {
  name: 'iip_india_mth_subcatg_view',
  data_domain: 'IIP',
  business_metadata: 'Monthly industrial production performance, enabling near real-time analysis of sectoral trends.',
  columns: 'year, month, sector_type, category, sub_category, iip_index, iip_growth_rate, data_source, released_on, updated_on, date_stamp, month_numeric, fiscal_year',
  source: 'MoSPI - Economic Statistics Division',
  rows_count: 5313
});

CREATE (t:Table {
  name: 'iip_india_mth_catg_view',
  data_domain: 'IIP',
  business_metadata: 'Monthly industrial production performance, enabling near real-time analysis of sectoral trends.',
  columns: 'year, month, sector_type, category, sub_category, iip_index, iip_growth_rate, data_source, released_on, updated_on, date_stamp, month_numeric, fiscal_year',
  source: 'MoSPI - Economic Statistics Division',
  rows_count: 5313
});

CREATE (t:Table {
  name: 'iip_india_yr_catg_view',
  data_domain: 'IIP',
  business_metadata: 'Annual IIP index and growth trends across sectors and categories based on a base year.',
  columns: 'id, base_year, year, sector_type, category, sub_category, iip_index, iip_growth_rate, data_source, released_on, updated_on',
  source: 'MoSPI - Economic Statistics Division',
  rows_count: 429
});

CREATE (t:Table {
  name: 'gdp_india_fy_item_estimates',
  data_domain: 'GDP',
  business_metadata: 'Contains annual GDP estimates by sector and expenditure components. Includes GDP values at constant and current prices, along with GVA growth rates. Flags indicate sectoral classification (primary, secondary, tertiary), and whether the item is a GVA component, GDP value, or expenditure element. Used for constructing GDP from both production and expenditure approaches. Includes metadata for last update date',
  columns: 'year, item, value_in_cr_const, growth_rate_const, value_in_cr_current, growth_rate_current, primary_flag, secondary_flag, tertiary_flag, gva_at_basic_prices_flag, expenditure_component_flag, is_gdp_flag, data_updated_date',
  source: 'MoSPI - National Accounts Division',
  rows_count: 364
});

CREATE (t:Table {
  name: 'gdp_india_fy_expenditure_estimates_dtls_view',
  data_domain: 'GDP',
  business_metadata: 'Provides detailed annual GDP expenditure estimates, including all expenditure components. Contains values at constant and current prices along with growth rates. Supports analysis of consumption, government spending, gross capital formation, and net exports contributing to overall GDP expenditure across fiscal years.',
  columns: 'year, item, value_in_cr_const, growth_rate_const, value_in_cr_current, growth_rate_current, data_updated_date',
  source: 'MoSPI - National Accounts Division',
  rows_count: 364
});

CREATE (t:Table {
  name: 'gdp_india_qtr_estimates_view',
  data_domain: 'GDP',
  business_metadata: 'Provides quarterly GDP estimates at constant and current prices along with GVA growth rates. Derived from gdp_india_qtr_item_estimates. Useful for tracking short-term economic performance and quarterly sectoral contributions.',
  columns: 'year, quarter, item, value_in_cr_const, growth_rate_const, value_in_cr_current, growth_rate_current, data_updated_date',
  source: 'MoSPI - National Accounts Division',
  rows_count: 1197
});

CREATE (t:Table {
  name: 'gdp_india_qtr_primsector_estimates_view',
  data_domain: 'GDP',
  business_metadata: 'Provides quarterly GDP estimates for the Primary Sector at constant and current prices, along with GVA growth rates. Derived from national GDP data to analyze agriculture, forestry, fishing, and mining performance in quarterly intervals.',
  columns: 'year, quarter, item, value_in_cr_const, growth_rate_const, value_in_cr_current, growth_rate_current, data_updated_date',
  source: 'MoSPI - National Accounts Division',
  rows_count: 1197
});

CREATE (t:Table {
  name: 'gdp_india_qtr_secsector_estimates_view',
  data_domain: 'GDP',
  business_metadata: 'Provides quarterly GDP estimates for the Secondary Sector at constant and current prices, along with GVA growth rates. Derived from national GDP data to analyze manufacturing, construction, electricity, gas, water supply, and related industries in quarterly intervals.',
  columns: 'year, quarter, item, value_in_cr_const, growth_rate_const, value_in_cr_current, growth_rate_current, data_updated_date',
  source: 'MoSPI - National Accounts Division',
  rows_count: 1197
});

CREATE (t:Table {
  name: 'gdp_india_qtr_tersector_estimates_view',
  data_domain: 'GDP',
  business_metadata: 'Provides quarterly GDP estimates for the Tertiary Sector at constant and current prices, along with GVA growth rates. Derived from national GDP data to analyze services such as trade, transport, communication, finance, real estate, and public administration.',
  columns: 'year, quarter, item, value_in_cr_const, growth_rate_const, value_in_cr_current, growth_rate_current, data_updated_date',
  source: 'MoSPI - National Accounts Division',
  rows_count: 1197
});

CREATE (t:Table {
  name: 'gdp_india_qtr_tersector_estimates_dtls_view',
  data_domain: 'GDP',
  business_metadata: 'Provides detailed quarterly GDP estimates for the Tertiary Sector, including constant and current price values and GVA growth rates. Useful for in-depth analysis of service sector performance such as trade, transport, communication, finance, real estate, and public administration.',
  columns: 'year, quarter, item, value_in_cr_const, growth_rate_const, value_in_cr_current, growth_rate_current, data_updated_date',
  source: 'MoSPI - National Accounts Division',
  rows_count: 1197
});

CREATE (t:Table {
  name: 'gdp_india_qtr_secsector_estimates_dtls_view',
  data_domain: 'GDP',
  business_metadata: 'Provides detailed quarterly GDP estimates for the Secondary Sector at both constant and current prices, including GVA growth rates. Useful for analyzing industrial performance, including manufacturing, construction, and utilities during each fiscal quarter.',
  columns: 'year, quarter, item, value_in_cr_const, growth_rate_const, value_in_cr_current, growth_rate_current, data_updated_date',
  source: 'MoSPI - National Accounts Division',
  rows_count: 1197
});

CREATE (t:Table {
  name: 'gdp_india_qtr_primsector_estimates_dtls_view',
  data_domain: 'GDP',
  business_metadata: 'Provides detailed quarterly GDP estimates for the Primary Sector at both constant and current prices, along with GVA growth rates. Focuses on agriculture, forestry, fishing, and mining performance within India’s quarterly GDP framework.',
  columns: 'year, quarter, item, value_in_cr_const, growth_rate_const, value_in_cr_current, growth_rate_current, data_updated_date',
  source: 'MoSPI - National Accounts Division',
  rows_count: 1197
});

CREATE (t:Table {
  name: 'gdp_state_fy_actuals',
  data_domain: 'GDP',
  business_metadata: 'Provides comprehensive annual economic output metrics for each Indian state, including GSVA and GSDP at constant and current prices, population estimates, per capita income, and year-on-year growth rates. Derived from state-level national accounts data for fiscal analysis.',
  columns: 'id, state, year, gsva_constant_in_lakhs, gsva_current_in_lakhs, gsdp_constant_in_lakhs, gsdp_current_in_lakhs, population, per_capita_gsdp_constant, per_capita_gsdp_current, gsdp_current_yoy_percent, gsdp_constant_yoy_percent, released_on, updated_on, data_source',
  source: 'MoSPI - National Accounts Division',
  rows_count: 448
});

CREATE (t:Table {
  name: 'gdp_state_fy_subindustry_actuals',
  data_domain: 'GDP',
  business_metadata: 'Detailed state-wise and sub-industry-wise GDP data at constant and current prices. Includes sectoral (primary, secondary, tertiary) flags, tax and subsidy components for granular analysis of state economic performance.',
  columns: 'id, base_year, state, industry, sub_industry, primary_flag, secondary_flag, tertiary_flag, taxes_on_products, subsidies_on_products, year, constant_value_in_lakh, current_value_in_lakh, released_on, data_source, updated_on',
  source: 'MoSPI - National Accounts Division',
  rows_count: 11252
});

CREATE (t:Table {
  name: 'gdp_state_fy_industry_actuals_view',
  data_domain: 'GDP',
  business_metadata: 'Provides state-wise and industry-level GDP actuals at constant and current prices. Aggregated from sub-industry data to represent total GSVA and GSDP performance across sectors within each state and fiscal year.',
  columns: 'state, industry, year, constant_value_in_lakh, current_value_in_lakh, released_on, updated_on',
  source: 'MoSPI - National Accounts Division',
  rows_count: 11252
});

CREATE (t:Table {
  name: 'gdp_state_fy_subindustry_actuals_view',
  data_domain: 'GDP',
  business_metadata: 'Provides state-wise and sub-industry-wise GDP actuals at constant and current prices, filtered to exclude aggregate (total) industry rows.',
  columns: 'id, base_year, state, industry, sub_industry, primary_flag, secondary_flag, tertiary_flag, taxes_on_products, subsidies_on_products, year, constant_value_in_lakh, current_value_in_lakh, released_on, data_source, updated_on',
  source: 'MoSPI - National Accounts Division',
  rows_count: 11252
});

CREATE (t:Table {
  name: 'gdp_india_qtr_expenditure_estimates_dtls_view',
  data_domain: 'GDP',
  business_metadata: 'Provides detailed quarterly GDP expenditure estimates at constant and current prices, including growth rates. Derived from GDP item-level estimates table where expenditure_component_flag = true.',
  columns: 'year, quarter, item, value_in_cr_const, growth_rate_const, value_in_cr_current, growth_rate_current, data_updated_date',
  source: 'MoSPI - National Accounts Division',
  rows_count: 1197
});

CREATE (t:Table {
  name: 'cpi_state_mth_subgrp_view',
  data_domain: 'CPI',
  business_metadata: 'Provides the same structure as cpi_state_mth_subgrp for downstream CPI processing and visualization.',
  columns: 'base_year, year, month, month_numeric, state, sector, group_name, sub_group_name, inflation_index, inflation_rate, released_on, updated_on, data_source, date_stamp, fiscal_year',
  source: 'MoSPI - Price Statistics Division',
  rows_count: 216435
});

CREATE (t:Table {
  name: 'cpi_india_mth_grp_view',
  data_domain: 'CPI',
  business_metadata: 'Provides all-India monthly CPI data aggregated at the group level. Filtered from cpi_state_mth_subgrp where state = \'All India\' and sub_group_name = \'*\' to represent national-level CPI indicators.',
  columns: 'base_year, year, month, month_numeric, state, sector, group_name, inflation_index, inflation_rate, released_on, updated_on, data_source, date_stamp, fiscal_year',
  source: 'MoSPI - Price Statistics Division',
  rows_count: 216435
});

CREATE (t:Table {
  name: 'cpi_india_mth_subgrp_view',
  data_domain: 'CPI',
  business_metadata: 'Provides All-India monthly CPI data at a subgroup level derived from cpi_state_mth_subgrp, excluding aggregate subgroup entries. Useful for analyzing detailed inflation components across consumption categories.',
  columns: 'id, base_year, year, month, month_numeric, state, sector, group_name, sub_group_name, inflation_index, inflation_rate, released_on, updated_on, data_source, date_stamp, fiscal_year',
  source: 'MoSPI - Price Statistics Division',
  rows_count: 216435
});

CREATE (t:Table {
  name: 'msme_state_ureg_recent',
  data_domain: 'MSME',
  business_metadata: 'Updated state-level MSME registration statistics including micro, small, medium units and total counts from Udyam portal.',
  columns: 'state, micro, small, medium, total_udyam, ime_uap, total_msme, data_source, released_on, updated_on',
  source: 'Ministry of MSME',
  rows_count: 37
});

CREATE (t:Table {
  name: 'msme_india_mth_subgrp_bankcredit',
  data_domain: 'MSME',
  business_metadata: 'Credit growth and performance of MSME sectors across time.',
  columns: 'id, year, month, month_numeric, sector, group_name, subgroup, effective_date, outstanding_as_on, unit, released_on, updated_on, data_source, date_stamp, fiscal_year',
  source: 'Reserve Bank of India',
  rows_count: 21672
});

CREATE (t:Table {
  name: 'msme_india_mth_sector_bankcredit_view',
  data_domain: 'MSME',
  business_metadata: 'Credit growth and performance of MSME sectors across time.',
  columns: 'id, year, month, month_numeric, sector, group_name, subgroup, effective_date, outstanding_as_on, unit, released_on, updated_on, data_source, date_stamp, fiscal_year',
  source: 'Reserve Bank of India',
  rows_count: 21672
});

CREATE (t:Table {
  name: 'msme_india_mth_grp_bankcredit_view',
  data_domain: 'MSME',
  business_metadata: 'Credit growth and performance of MSME sectors across time.',
  columns: 'year, month, sector, group_name, effective_date, outstanding_as_on, unit, released_on, updated_on, data_source, date_stamp, month_numeric, fiscal_year',
  source: 'Reserve Bank of India',
  rows_count: 14829
});

CREATE (t:Table {
  name: 'msme_india_mth_subgrp_bankcredit_view',
  data_domain: 'MSME',
  business_metadata: 'Provides detailed MSME monthly subgroup-level bank credit information across sectors and groups, derived from RBI sectoral deployment data.',
  columns: 'year, month, sector, group_name, subgroup, effective_date, outstanding_as_on, unit, released_on, updated_on, data_source, date_stamp, month_numeric, fiscal_year',
  source: 'Reserve Bank of India',
  rows_count: 6843
});

CREATE (t:Table {
  name: 'gdp_india_fy_estimates_view',
  data_domain: 'GDP',
  business_metadata: 'This view provides annual GDP estimates at constant and current prices, including growth rates, derived from gdp_india_fy_item_estimates where is_gdp_flag = TRUE. It simplifies the GDP-level summary used for visualization and analysis under MoSPI National Accounts Division data.',
  columns: 'year, value_in_cr_const, growth_rate_const, value_in_cr_current, growth_rate_current, data_updated_date',
  source: 'MoSPI - National Accounts Division',
  rows_count: 364
});

CREATE (t:Table {
  name: 'aadhaar_biometric_monthly_data',
  data_domain: 'E-Governance',
  business_metadata: 'Structured national-level dataset that provides granular insights into Aadhaar biometric update patterns by geography and age group, useful for tracking enrolment activity and infrastructure reach.',
  columns: 'date, state, district, pincode, bio_age_5_17, bio_age_17_plus',
  source: 'Unique Identification Authority of India (UIDAI)',
  rows_count: 109743
});

CREATE (t:Table {
  name: 'aadhaar_demographic_monthly_data',
  data_domain: 'Demography',
  business_metadata: 'Structured national-level dataset offering insights into demographic Aadhaar update activity by region and age group, supporting analyses of population engagement with Aadhaar services.',
  columns: 'date, state, district, pincode, demo_age_5_17, demo_age_17_plus',
  source: 'Unique Identification Authority of India (UIDAI)',
  rows_count: 20911
});

CREATE (t:Table {
  name: 'cghs_approved_hospital_data',
  data_domain: 'Healthcare, Wellness and Family Welfare',
  business_metadata: 'Structured dataset providing details of healthcare facilities approved under CGHS, enabling analysis of regional healthcare accessibility and network coverage for government employees and pensioners.',
  columns: 'diagnostic_centre_name, diagnostic_centre_address, city_name',
  source: 'Ministry of Health and Family Welfare | Government of India',
  rows_count: 2601
});

CREATE (t:Table {
  name: 'ores_minerals_exports_yearly',
  data_domain: 'Chemical, Mining and Natural Resources',
  business_metadata: 'Structured dataset capturing India’s mineral export performance across multiple years, useful for assessing trade trends, resource economics, and export value contributions from the mining sector.',
  columns: 'ores_and_minerals, measurement_unit, quantity_2015_16_revised, value_2015_16, quantity_2016_17_provisional, value_2016_17, quantity_2017_18_provisional, value_2017_18, note_quantity_2015_16, note_value_2015_16, note_quantity_2016_17, note_value_2016_17, note_quantity_2017_18, note_value_2017_18',
  source: 'Ministry of Mines | Government of India',
  rows_count: 141
});

CREATE (t:Table {
  name: 'asi_state_principal_characteristics',
  data_domain: 'Industry Survey',
  business_metadata: 'Structured dataset from ASI capturing state-wise and sector-wise industrial characteristics, supporting analysis of industrial output, workforce, and sectoral composition across NIC classifications.',
  columns: 'nic_classification, year, state, sector, indicator, nic_code, nic_description, nic_type, value, unit, release_on, updated_on, data_source',
  source: 'Ministry of Statistics and Programme Implementation (MOSPI)',
  rows_count: 290304
});

CREATE (t:Table {
  name: 'port_dwell_time_month',
  data_domain: 'Commerce, Finance, Banking and Insurance',
  business_metadata: 'Structured national-level dataset capturing monthly cargo dwell time metrics across Indian ports, useful for analyzing port operational efficiency, trade bottlenecks, and logistics infrastructure performance.',
  columns: 'port_name, month, year, category, dwell_time, release_on, updated_on, data_source',
  source: 'Ministry of Commerce and Industry, Government of India',
  rows_count: 1047
});

CREATE (t:Table {
  name: 'vehicle_registrations_state',
  data_domain: 'Transportation, Logistics and Mobility',
  business_metadata: 'Structured dataset showing annual vehicle registration counts by state/UT, sourced from the VAHAN dashboard. Useful for studying trends in vehicle growth, transport infrastructure planning, and state-level mobility analytics.',
  columns: 'state, year_2025, year_2024, year_2023, year_2022, year_2021, total',
  source: 'Ministry of Road Transport and Highways, Government of India',
  rows_count: 35
});

CREATE (t:Table {
  name: 'cumulative_capacity_state_month',
  data_domain: 'Energy, Power and Renewable Resources',
  business_metadata: 'Structured dataset showing monthly cumulative renewable energy capacity by state and source type. Useful for energy policy tracking, renewable adoption studies, and state-level performance comparison.',
  columns: 'state, wind_power, small_hydro_power, bio_power, bagasse_bio_power, n_bagasse_waste_to_energy, waste_to_energy_(off-grid), solar_power(gm), roof_top, hybrid_solar, comp_off_grid_solar, total, month, year, data_source',
  source: 'Ministry of New and Renewable Energy, Government of India',
  rows_count: 304
});

CREATE (t:Table {
  name: 'watersheds_in_india',
  data_domain: 'Rainfall',
  business_metadata: 'Structured dataset representing watershed and hydrological parameters across India. Useful for rainfall correlation, river basin assessment, and water resource planning.',
  columns: 'year, indicator, sub_indicator, river_length, sub_basin, value',
  source: 'National Water Informatics Centre (NWIC), Ministry of Jal Shakti, Government of India',
  rows_count: 846
});

CREATE (t:Table {
  name: 'annual_mean_temperature',
  data_domain: 'Rainfall',
  business_metadata: 'Structured climate dataset showing annual average temperatures, useful for studying temperature variability, climate change patterns, and correlation with rainfall trends.',
  columns: 'year, indicator, unit, period, value',
  source: 'National Spatial Reference Centre (NSRC), Ministry of Earth Sciences, Government of India',
  rows_count: 10
});

CREATE (t:Table {
  name: 'fish_production_yearly',
  data_domain: 'Rainfall',
  business_metadata: 'Structured statewise dataset on annual fish production, useful for analyzing regional variations in fisheries performance, resource utilization, and sustainability patterns alongside climatic and rainfall data.',
  columns: 'year, indicator, unit, state, value',
  source: 'National Spatial Reference Centre (NSRC), Ministry of Earth Sciences, Government of India',
  rows_count: 74
});

CREATE (t:Table {
  name: 'river_basin_catchment',
  data_domain: 'Rainfall',
  business_metadata: 'Structured dataset representing river-wise and basin-level metrics such as catchment areas and hydrological indicators. Useful for environmental monitoring, rainfall-runoff analysis, and water resource planning.',
  columns: 'year, indicator, unit, sub_indicator, river, value',
  source: 'National Spatial Reference Centre (NSRC), Ministry of Earth Sciences, Government of India',
  rows_count: 25
});

CREATE (t:Table {
  name: 'coastline_population_and_length',
  data_domain: 'Rainfall',
  business_metadata: 'Structured dataset containing state-wise coastline length and population metrics, valuable for analyzing coastal density, marine resource management, and climate resilience planning.',
  columns: 'year, indicator, state, sub_indicator, value',
  source: 'National Spatial Reference Centre (NSRC), Ministry of Earth Sciences, Government of India',
  rows_count: 26
});

CREATE (t:Table {
  name: 'faunal_diversity',
  data_domain: 'Rainfall',
  business_metadata: 'Structured biodiversity dataset providing phylum-wise faunal diversity metrics, valuable for understanding ecological composition, environmental monitoring, and sustainable resource management.',
  columns: 'indicator, unit, sub_indicator, phylum, value',
  source: 'National Spatial Reference Centre (NSRC), Ministry of Earth Sciences, Government of India',
  rows_count: 336
});

CREATE (t:Table {
  name: 'lpfr_state_age',
  data_domain: 'Labour',
  business_metadata: 'Structured dataset from MOSPI’s Periodic Labour Force Survey providing insights into labour participation across states, age groups, and gender divisions. Useful for labour market analysis, gender parity evaluation, and employment policy design.',
  columns: 'rural_male, rural_female, rural_person, urban_male, urban_female, urban_person, total_male, total_female, total_person, age_group, start_month, end_month, year, released_on, data_source, state',
  source: 'Ministry of Statistics and Programme Implementation (MOSPI)',
  rows_count: 69
});

CREATE (t:Table {
  name: 'wpr_state_age',
  data_domain: 'Labour',
  business_metadata: 'Structured dataset from MOSPI’s Periodic Labour Force Survey providing Worker Population Ratio (WPR) across states, age groups, and gender categories. Useful for labour utilization analysis, employment trends, and workforce planning.',
  columns: 'rural_male, rural_female, rural_person, urban_male, urban_female, urban_person, total_male, total_female, total_person, age_group, start_month, end_month, year, released_on, data_source, state',
  source: 'Ministry of Statistics and Programme Implementation (MOSPI)',
  rows_count: 69
});

CREATE (t:Table {
  name: 'ur_state_age',
  data_domain: 'Labour',
  business_metadata: 'Structured dataset from MOSPI’s Periodic Labour Force Survey (PLFS) providing Unemployment Rate (UR) across states, age groups, and gender categories. Useful for labour market analysis, policy formulation, and tracking employment challenges across demographic segments.',
  columns: 'rural_male, rural_female, rural_person, urban_male, urban_female, urban_person, total_male, total_female, total_person, age_group, start_month, end_month, year, released_on, data_source, state',
  source: 'Ministry of Statistics and Programme Implementation (MOSPI)',
  rows_count: 69
});

CREATE (t:Table {
  name: 'cpi_iw_point_to_point_inflation',
  data_domain: 'Labour',
  business_metadata: 'Structured dataset from the CPI-IW dashboard covering monthly point-to-point inflation rates based on the 2016 base year, spanning 2020–2025 (June). Includes both national and centre-level indices with statewise mapping, supporting economic and wage indexation analysis.',
  columns: 'id, base_year, year, month, point_to_point_inflation, data_source',
  source: 'Labour Bureau, Ministry of Labour and Employment, Government of India',
  rows_count: 58
});

CREATE (t:Table {
  name: 'cpi_iw_centre_index',
  data_domain: 'Labour',
  business_metadata: 'Structured dataset from the CPI-IW dashboard (base year 2016) covering monthly centre-wise inflation index data for all states and union territories from 2020 to June 2025. Provides granular insights beyond the Economic Survey data, including linking factors and centre-level variations.',
  columns: 'base_year, state, centre, year, month, index, data_source',
  source: 'Labour Bureau, Ministry of Labour and Employment, Government of India',
  rows_count: 5248
});

CREATE (t:Table {
  name: 'msme_employees_share_by_sector_view',
  data_domain: 'MSME',
  business_metadata: 'GDP contribution of MSMEs by region/subregion and country within Asia',
  columns: 'heading, region, country, subregion, year, value, source, data_upload_date',
  source: 'Asian Development Bank / ERDI',
  rows_count: 175
});

CREATE (t:Table {
  name: 'upi_mth_stats',
  data_domain: 'Digital payments',
  business_metadata: 'Structured dataset providing month-wise UPI performance metrics, useful for analyzing digital payment adoption trends, transaction growth, and financial inclusion patterns across India.',
  columns: 'year, month, volume_millions, value_crores, released_on, updated_on, data_source',
  source: 'National Payments Corporation of India (NPCI)',
  rows_count: 55
});

CREATE (t:Table {
  name: 'upi_dly_stats',
  data_domain: 'Digital payments',
  business_metadata: 'Structured daily dataset providing detailed insights into UPI transaction patterns, enabling granular analysis of payment activity, digital adoption, and financial behavior across time.',
  columns: 'year, month, day_num, volume_millions, value_cr, date_stamp, data_source, released_on, updated_on',
  source: 'National Payments Corporation of India (NPCI)',
  rows_count: 1572
});

CREATE (t:Table {
  name: 'upi_mth_failures',
  data_domain: 'Digital payments',
  business_metadata: 'Structured dataset showing monthly UPI transaction success and failure metrics by issuer bank, enabling analysis of transaction reliability, system efficiency, and payment performance trends across financial institutions.',
  columns: 'year, month, issuer_bank_name, total_volume_millions, approved_percentage, bd_percentage, td_percentage, data_source, released_on, updated_on',
  source: 'National Payments Corporation of India (NPCI)',
  rows_count: 2300
});

CREATE (t:Table {
  name: 'construct_state_cement_indicators_view',
  data_domain: 'State Economic Survey',
  business_metadata: 'Structured dataset presenting state-level cement industry indicators for FY24, reflecting construction activity, industrial demand, and real estate sector performance trends across India.',
  columns: 'state, category, subcategory, value, data_source, released_on, updated_on',
  source: 'Cement Manufacturers Association (CMA) Dashboard',
  rows_count: 540
});

CREATE (t:Table {
  name: 'fdi_state_qtr_view',
  data_domain: 'Finance_and_Industry',
  business_metadata: 'Derived from fdi_india_qtr_state; provides fiscal context for analyzing state-wise quarterly FDI inflows in INR, USD, and percentage terms.',
  columns: 'fiscal_year, fiscal_quarter, state_name, fdi_inr_crore, fdi_usd_million, fdi_percent',
  source: 'DPIIT',
  rows_count: 165
});

CREATE (t:Table {
  name: 'cpi_state_mth_grp_view',
  data_domain: 'CPI',
  business_metadata: 'Provides monthly Consumer Price Index (CPI) data by state and group, excluding All India aggregates. Derived from cpi_state_mth_subgrp, this view focuses on broader group-level inflation trends for each state.',
  columns: 'base_year, year, month, month_numeric, state, sector, group_name, inflation_index, inflation_rate, released_on, updated_on, data_source, date_stamp, fiscal_year',
  source: 'MoSPI - Price Statistics Division',
  rows_count: 216435
});

CREATE (t:Table {
  name: 'cws_industry_distribution_state',
  data_domain: 'Labour',
  business_metadata: 'Structured dataset providing state-level employment distribution across industry sectors, useful for labour market analysis, state economic profiling, and workforce planning by demographic and sectoral characteristics.',
  columns: 'state, agriculture_sector, secondary_sector_along_with_mining_and_quarrying, tertiary_sector, all_sector, age_group, gender, area_type, start_month, end_month, year, released_on, data_source',
  source: 'Labour Bureau, Ministry of Labour & Employment, Government of India',
  rows_count: 207
});

CREATE (t:Table {
  name: 'wpi_india_mth_catg',
  data_domain: 'Macro-economic aggregates',
  business_metadata: 'Structured dataset offering granular WPI trends across commodity groups, useful for inflation analysis, price movement tracking, and macroeconomic policy assessments. Covers data from 2010 to 2025 with fiscal year alignment.',
  columns: 'commodity_group, sub_group, commodity_category, commodity_category_sub_group, commodity_name, commodity_weight, month, year, wpi_inflation, wpi_index, month_numeric, fiscal_year',
  source: 'Reserve Bank of India (RBI) – Database on Indian Economy (DBIE)',
  rows_count: 18249
});

CREATE (t:Table {
  name: 'whole_sale_price_index_cal',
  data_domain: 'CPI',
  business_metadata: 'Month-wise WPI dataset for granular inflation diagnostics.',
  columns: 'year, commodity_name, index_value',
  source: 'Ministry of Commerce & Industry',
  rows_count: 9449
});

CREATE (t:Table {
  name: 'india_fy_gdp_expenditure_component_view',
  data_domain: 'GDP',
  business_metadata: 'Contains annual GDP estimates by expenditure components. Includes GDP values at constant and current prices, along with GVA growth rates. Flags indicate sectoral classification (primary, secondary, tertiary), and whether the item is a GVA component, GDP value, or expenditure element. Used for constructing GDP from both production and expenditure approaches. Includes metadata for last update date',
  columns: 'year, component,value_in_cr_const, growth_rate_const, value_in_cr_current, growth_rate_current  ',
  source: 'MoSPI - National Accounts Division',
  rows_count: 112
});

CREATE (t:Table {
  name: 'india_fy_gdp_all_sectors_view',
  data_domain: 'GDP',
  business_metadata: 'Contains annual GDP estimates by sector and expenditure components. Includes GDP values at constant and current prices, along with GVA growth rates. Flags indicate sectoral classification (primary, secondary, tertiary), and whether the item is a GVA component, GDP value, or expenditure element. Used for constructing GDP from both production and expenditure approaches. Includes metadata for last update date',
  columns: 'fiscal_year, item, value_in_cr_const, growth_rate_const,value_in_cr_current, growth_rate_current, data_updated_date',
  source: 'MoSPI - National Accounts Division',
  rows_count: 154
});

CREATE (t:Table {
  name: 'india_fy_gdp_others_view',
  data_domain: 'GDP',
  business_metadata: 'Contains annual GDP estimates by sector and expenditure components. Includes GDP values at constant and current prices, along with GVA growth rates. Flags indicate sectoral classification (primary, secondary, tertiary), and whether the item is a GVA component, GDP value, or expenditure element. Used for constructing GDP from both production and expenditure approaches. Includes metadata for last update date',
  columns: 'fiscal_year, item, value_in_cr_const, growth_rate_const,value_in_cr_current, growth_rate_current, data_updated_date',
  source: 'MoSPI - National Accounts Division',
  rows_count: 364
});

CREATE (t:Table {
  name: 'gdp_india_fy_percapita_view',
  data_domain: 'GDP',
  business_metadata: 'Contains annual GDP estimates by sector and expenditure components. Includes GDP values at constant and current prices, along with GVA growth rates. Flags indicate sectoral classification (primary, secondary, tertiary), and whether the item is a GVA component, GDP value, or expenditure element. Used for constructing GDP from both production and expenditure approaches. Includes metadata for last update date',
  columns: 'fiscal_year, item, value_in_cr_const, growth_rate_const,value_in_cr_current, growth_rate_current, data_updated_date',
  source: 'MoSPI - National Accounts Division',
  rows_count: 44
});

CREATE (t:Table {
  name: 'state_fy_gdp_summary_view',
  data_domain: 'GDP',
  business_metadata: 'Provides comprehensive annual economic output metrics for each Indian state, including GSVA and GSDP at constant and current prices, population estimates, per capita income, and year-on-year growth rates. Derived from state-level national accounts data for fiscal analysis.',
  columns: 'fiscal_year , state, gsva_constant_in_lakhs, gsva_current_in_lakhs, gsdp_constant_in_lakhs, gsdp_current_in_lakhs,gsdp_current_yoy_percent, gsdp_constant_yoy_percent, ',
  source: 'MoSPI - National Accounts Division',
  rows_count: 448
});

CREATE (t:Table {
  name: 'state_fy_percapita_gsdp_summary_view',
  data_domain: 'GDP',
  business_metadata: 'Provides comprehensive annual economic output metrics for each Indian state, including GSVA and GSDP at constant and current prices, population estimates, per capita income, and year-on-year growth rates. Derived from state-level national accounts data for fiscal analysis.',
  columns: 'fiscal_year , state, population,per_capita_gsdp_constant, per_capita_gsdp_current ',
  source: 'MoSPI - National Accounts Division',
  rows_count: 448
});

CREATE (t:Table {
  name: 'rain_india_mth_view',
  data_domain: 'Agriculture and Rural',
  business_metadata: 'Provides comprehensive annual economic output metrics for each Indian state, including GSVA and GSDP at constant and current prices, population estimates, per capita income, and year-on-year growth rates. Derived from state-level national accounts data for fiscal analysis.',
  columns: 'year,unit, month, value, month_numeric',
  source: 'National Spatial Reference Centre (NSRC), Ministry of Earth Sciences, Government of India',
  rows_count: 24
});

CREATE (t:Table {
  name: 'rain_india_yr_view',
  data_domain: 'Agriculture and Rural',
  business_metadata: 'Provides comprehensive annual economic output metrics for each Indian state, including GSVA and GSDP at constant and current prices, population estimates, per capita income, and year-on-year growth rates. Derived from state-level national accounts data for fiscal analysis.',
  columns: 'year,unit, value',
  source: 'National Spatial Reference Centre (NSRC), Ministry of Earth Sciences, Government of India',
  rows_count: 24
});

CREATE (t:Table {
  name: 'rain_district_mth_view',
  data_domain: 'Agriculture and Rural',
  business_metadata: 'Provides comprehensive annual economic output metrics for each Indian state, including GSVA and GSDP at constant and current prices, population estimates, per capita income, and year-on-year growth rates. Derived from state-level national accounts data for fiscal analysis.',
  columns: 'year,month, state, district, monthly_total_rainfall_mm',
  source: 'National Spatial Reference Centre (NSRC), Ministry of Earth Sciences, Government of India',
  rows_count: 5072
});

CREATE (t:Table {
  name: 'rain_district_yr_view',
  data_domain: 'Agriculture and Rural',
  business_metadata: 'Provides comprehensive annual economic output metrics for each Indian state, including GSVA and GSDP at constant and current prices, population estimates, per capita income, and year-on-year growth rates. Derived from state-level national accounts data for fiscal analysis.',
  columns: 'year,state, district, yearly_total_rainfall_mm',
  source: 'National Spatial Reference Centre (NSRC), Ministry of Earth Sciences, Government of India',
  rows_count: 600
});

CREATE (t:Table {
  name: 'cpi_mth_item',
  data_domain: 'CPI',
  business_metadata: 'Provides all-India monthly CPI at Item level to represent national-level CPI indicators.',
  columns: 'base_year, year, month, month_numeric, item, inflation_index, inflation,status, fiscal_yr, released_on, updated_on, data_source, date_stamp, fiscal_year',
  source: 'MoSPI - Price Statistics Division',
  rows_count: 41262
});

CREATE (t:Table {
  name: 'cpi_iw_retail_price_index',
  data_domain: 'CPI',
  business_metadata: 'Provides all-India monthly CPI at Item level for Industrial Workers ',
  columns: 'base_year, year, month, group, sub_group, item, index, data_source',
  source: 'Ministry of Labour & Employment',
  rows_count: 27433
});

CREATE (t:Table {
  name: 'production_of_major_crops',
  data_domain: 'Agriculture, Forestry and Rural Development',
  business_metadata: 'Structured dataset useful for analyzing India’s agricultural output across major crop groups. Supports policy analysis, food security planning, and crop production trend assessment under the Situation Assessment of Agricultural Households (77th Round).',
  columns: 'group_name, commodity_name, year, value_million_tonnes, updated_on',
  source: 'Ministry of Statistics and Programme Implementation (MOSPI)',
  rows_count: 440
});

// Create relationships
MATCH (source:Table {name: 'quaterly_key_aggregates_of_national_accounts'})
MATCH (target:Table {name: 'key_aggregates_of_national_accounts'})
MERGE (source)-[r:AGGREGATES {
  description: 'Annual national account aggregates are calculated by aggregating quarterly key aggregates of national accounts.',
  strength: 0.95
}]->(target);

MATCH (source:Table {name: 'quaterly_estimates_of_expenditure_components_gdp'})
MATCH (target:Table {name: 'quaterly_key_aggregates_of_national_accounts'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Quarterly GDP aggregates depend on the expenditure-side components as they are used to estimate total GDP.',
  strength: 0.9
}]->(target);

MATCH (source:Table {name: 'quaterly_estimates_of_expenditure_components_gdp'})
MATCH (target:Table {name: 'key_aggregates_of_national_accounts'})
MERGE (source)-[r:AGGREGATES {
  description: 'Annual GDP aggregates are derived by aggregating quarterly expenditure-side GDP estimates.',
  strength: 0.9
}]->(target);

MATCH (source:Table {name: 'per_capita_income_product_final_consumption'})
MATCH (target:Table {name: 'key_aggregates_of_national_accounts'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Per capita income and final consumption are calculated using total GDP and population data from national accounts.',
  strength: 0.95
}]->(target);

MATCH (source:Table {name: 'per_capita_income_product_final_consumption'})
MATCH (target:Table {name: 'quaterly_key_aggregates_of_national_accounts'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Per capita income and final consumption metrics at the annual level are influenced by quarterly GDP aggregates.',
  strength: 0.85
}]->(target);

MATCH (source:Table {name: 'cpi_worker_data'})
MATCH (target:Table {name: 'per_capita_income_product_final_consumption'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'CPI for workers affects real per capita income and consumption, as inflation erodes purchasing power.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'cpi_food_worker_data'})
MATCH (target:Table {name: 'cpi_worker_data'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'CPI for food is a major component of overall CPI for workers, as food inflation significantly impacts worker cost of living.',
  strength: 0.85
}]->(target);

MATCH (source:Table {name: 'consumer_price_index_cpi_for_agricultural_and_rural_labourers'})
MATCH (target:Table {name: 'per_capita_income_product_final_consumption'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'CPI for rural/agricultural labourers affects real consumption and income in the national accounts by influencing rural purchasing power.',
  strength: 0.75
}]->(target);

MATCH (source:Table {name: 'city_wise_housing_price_indices'})
MATCH (target:Table {name: 'cpi_worker_data'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'City-wise housing price inflation is a component of overall CPI for urban workers, affecting their cost of living.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'nifty_sme_index_daily_values'})
MATCH (target:Table {name: 'key_aggregates_of_national_accounts'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Performance of SME equities reflects and can impact overall economic growth as captured in national accounts, especially through investment and business sentiment.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'nifty_sme_index_daily_values'})
MATCH (target:Table {name: 'quaterly_key_aggregates_of_national_accounts'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Short-term SME market movements can influence quarterly GDP aggregates via investment and business performance.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'msme_definitions_by_sector'})
MATCH (target:Table {name: 'nifty_sme_index_daily_values'})
MERGE (source)-[r:DERIVES_FROM {
  description: 'The composition of the Nifty SME index is determined by the MSME sector definitions, which set eligibility for inclusion.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'india_fy_gdp_view'})
MATCH (target:Table {name: 'india_fy_national_income_view'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'National-level GDP metrics in india_fy_gdp_view are derived from and depend on the components of national income accounting provided in india_fy_national_income_view.',
  strength: 0.95
}]->(target);

MATCH (source:Table {name: 'india_fy_national_income_view'})
MATCH (target:Table {name: 'india_fy_gdp_view'})
MERGE (source)-[r:AGGREGATES {
  description: 'GDP in india_fy_gdp_view is an aggregate of the various national income components listed in india_fy_national_income_view.',
  strength: 0.95
}]->(target);

MATCH (source:Table {name: 'whole_sale_price_index_fy'})
MATCH (target:Table {name: 'india_fy_gdp_view'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Changes in the wholesale price index (WPI) can causally influence nominal GDP growth in india_fy_gdp_view through their impact on price levels and inflation.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'msme_gdp_by_region_view'})
MATCH (target:Table {name: 'india_fy_gdp_view'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'GDP contribution of Indian MSMEs by region (from msme_gdp_by_region_view, filtered for India) is a component of the overall national GDP in india_fy_gdp_view.',
  strength: 0.85
}]->(target);

MATCH (source:Table {name: 'msme_gdp_by_sector_view'})
MATCH (target:Table {name: 'india_fy_gdp_view'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'GDP contribution of Indian MSMEs by sector (from msme_gdp_by_sector_view, filtered for India) is a component of the overall national GDP in india_fy_gdp_view.',
  strength: 0.85
}]->(target);

MATCH (source:Table {name: 'msme_share_by_region_view'})
MATCH (target:Table {name: 'msme_gdp_by_region_view'})
MERGE (source)-[r:DERIVES_FROM {
  description: 'MSME share by region is calculated based on the GDP contribution of MSMEs by region.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'msme_share_by_sector_view'})
MATCH (target:Table {name: 'msme_gdp_by_sector_view'})
MERGE (source)-[r:DERIVES_FROM {
  description: 'MSME share by sector is calculated based on the GDP contribution of MSMEs by sector.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'msme_priority_sector_view'})
MATCH (target:Table {name: 'msme_gdp_by_sector_view'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Gross Bank Credit (GBC) to MSME priority sectors (msme_priority_sector_view) influences sectoral MSME GDP contribution (msme_gdp_by_sector_view) by affecting investment and output.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'msme_priority_sector_view'})
MATCH (target:Table {name: 'msme_share_by_sector_view'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Credit availability to MSME sectors (msme_priority_sector_view) causally influences the MSME share in each sector (msme_share_by_sector_view) by enabling growth and expansion.',
  strength: 0.65
}]->(target);

MATCH (source:Table {name: 'asuse_est_num_workers_by_employment_gender'})
MATCH (target:Table {name: 'msme_gdp_by_sector_view'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The number of workers in MSME sectors (asuse_est_num_workers_by_employment_gender, filtered for MSME sectors and India) causally influences sectoral MSME GDP contribution (msme_gdp_by_sector_view) through labor input.',
  strength: 0.75
}]->(target);

MATCH (source:Table {name: 'asuse_est_num_workers_by_employment_gender'})
MATCH (target:Table {name: 'msme_share_by_sector_view'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The distribution of workers in MSME sectors (asuse_est_num_workers_by_employment_gender) affects the share of MSMEs in each sector (msme_share_by_sector_view) by impacting output and productivity.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'asuse_est_annual_gva_per_establishment'})
MATCH (target:Table {name: 'asuse_estimated_annual_gva_per_worker_rupees'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Gross Value Added (GVA) per establishment depends on the GVA generated per worker and the number of workers in each establishment.',
  strength: 0.85
}]->(target);

MATCH (source:Table {name: 'asuse_est_annual_gva_per_establishment'})
MATCH (target:Table {name: 'asuse_estimated_number_of_workers_by_type_of_workers'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'GVA per establishment is influenced by the number and type of workers employed, as more workers can contribute to higher total GVA.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'asuse_estimated_annual_gva_per_worker_rupees'})
MATCH (target:Table {name: 'asuse_est_value_key_characteristics_by_workers'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'GVA per worker is influenced by worker characteristics such as skill level and role, which affect productivity.',
  strength: 0.75
}]->(target);

MATCH (source:Table {name: 'asuse_est_annual_emoluments_per_hired_worker'})
MATCH (target:Table {name: 'asuse_estimated_number_of_workers_by_type_of_workers'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Average annual emoluments per hired worker depend on the number and type of hired workers in establishments.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'asuse_est_annual_emoluments_per_hired_worker'})
MATCH (target:Table {name: 'asuse_est_annual_gva_per_establishment'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Emoluments per hired worker are influenced by the overall economic performance (GVA) of establishments, as higher GVA can enable higher wages.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'asuse_est_annual_gva_per_establishment'})
MATCH (target:Table {name: 'asuse_est_num_establishments_pursuing_mixed_activity'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'GVA per establishment can be influenced by whether establishments pursue mixed activities, as diversification may affect value addition.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'asuse_est_annual_gva_per_establishment'})
MATCH (target:Table {name: 'asuse_per1000_estb_by_hours_worked_per_day'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'GVA per establishment is affected by the number of working hours per day, as longer hours can increase output.',
  strength: 0.65
}]->(target);

MATCH (source:Table {name: 'asuse_est_annual_gva_per_establishment'})
MATCH (target:Table {name: 'asuse_per1000_estb_by_months_operated_last_365days'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'GVA per establishment depends on the number of months operated in a year, as establishments open longer can generate more value.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'asuse_est_annual_gva_per_establishment'})
MATCH (target:Table {name: 'asuse_est_value_key_characteristics_by_workers'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'GVA per establishment is influenced by key characteristics of workers, such as skill and role, which affect productivity and output.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'asuse_est_annual_gva_per_establishment'})
MATCH (target:Table {name: 'msme_employees_share_by_region_view'})
MERGE (source)-[r:AGGREGATES {
  description: 'State-level GVA per establishment aggregates up to regional/national MSME GDP contribution data for India.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'asuse_est_annual_gva_per_establishment'})
MATCH (target:Table {name: 'msme_global_sector'})
MERGE (source)-[r:AGGREGATES {
  description: 'State-level GVA per establishment aggregates to national MSME GDP contribution, which is then compared globally in this table.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'asuse_estimated_number_of_workers_by_type_of_workers'})
MATCH (target:Table {name: 'asuse_est_value_key_characteristics_by_workers'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The number of workers by type is influenced by worker characteristics, as certain roles or skill levels may be more prevalent in specific types of employment.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'asuse_per1000_estb_using_computer_internet_last365_days'})
MATCH (target:Table {name: 'asuse_per1000_of_estb_using_internet_by_type_of_its_use'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The overall proportion of establishments using the internet (source) causally determines the breakdown of internet usage types (target), as usage type data is conditional on establishments having internet access.',
  strength: 0.85
}]->(target);

MATCH (source:Table {name: 'asuse_per1000_proppartn_estb_by_edu_owner_mjr_partner'})
MATCH (target:Table {name: 'asuse_per1000_estb_using_computer_internet_last365_days'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The educational profile of establishment owners (source) causally influences the likelihood of digital adoption (target), as higher education levels typically increase technology uptake.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'asuse_per1000_estb_registered_under_acts_authorities'})
MATCH (target:Table {name: 'asuse_per_1000_distri_of_establishments_by_type_of_ownership'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The registration status of establishments (source) is causally linked to the type of ownership (target), as different ownership types are subject to different registration requirements.',
  strength: 0.75
}]->(target);

MATCH (source:Table {name: 'asuse_per_1000_distri_of_establishments_by_type_of_ownership'})
MATCH (target:Table {name: 'asuse_per1000_proppartn_estb_by_edu_owner_mjr_partner'})
MERGE (source)-[r:AGGREGATES {
  description: 'The distribution of establishments by ownership type (source) aggregates up to the educational profile of owners of proprietary/partnership establishments (target), as the latter is a subset of the former.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'asuse_per_1000_distri_of_establishments_by_type_of_ownership'})
MATCH (target:Table {name: 'asuse_per1000_proppartn_estb_by_socialgroup_owner'})
MERGE (source)-[r:AGGREGATES {
  description: 'The overall ownership type distribution (source) aggregates to the social group breakdown of proprietary/partnership owners (target), since the latter is a further segmentation of the former.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'asuse_per_1000_distri_of_establishments_by_type_of_ownership'})
MATCH (target:Table {name: 'asuse_per1000_proppartn_estb_by_other_econ_activities'})
MERGE (source)-[r:AGGREGATES {
  description: 'The distribution of ownership types (source) aggregates to the data on proprietors/partners engaging in other economic activities (target), as the latter is a subset of the former.',
  strength: 0.75
}]->(target);

MATCH (source:Table {name: 'asuse_per_1000_distri_of_establishments_by_type_of_location'})
MATCH (target:Table {name: 'asuse_per1000_estb_using_computer_internet_last365_days'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The location type of establishments (source) causally influences digital adoption (target), as establishments in urban areas are more likely to use computers/internet.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'asuse_per_1000_distri_of_establishments_by_nature_of_operation'})
MATCH (target:Table {name: 'asuse_per1000_estb_using_computer_internet_last365_days'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The nature of operation (seasonal, perennial, casual) of establishments (source) influences the likelihood of digital adoption (target), as perennial establishments are more likely to invest in technology.',
  strength: 0.65
}]->(target);

MATCH (source:Table {name: 'asuse_per_1000_of_establishments_which_are_npis_and_non_npis'})
MATCH (target:Table {name: 'asuse_per_1000_distri_of_establishments_by_type_of_ownership'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The status of establishments as NPIs or non-NPIs (source) is causally linked to the type of ownership (target), as NPIs are a specific ownership category.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'asuse_statewise_estimated_annual_gva_per_establishment_rupees'})
MATCH (target:Table {name: 'asuse_statewise_est_num_of_estb_pursuing_mixed_activity'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The annual GVA per establishment is influenced by the number and nature of establishments, including those pursuing mixed activities, as these affect overall productivity and value added.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'asuse_statewise_estimated_annual_gva_per_worker_rupees'})
MATCH (target:Table {name: 'asuse_statewise_estimated_number_of_workers_by_type_of_workers'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'GVA per worker is calculated using total GVA and the number of workers by type; changes in worker composition causally impact GVA per worker.',
  strength: 0.85
}]->(target);

MATCH (source:Table {name: 'asuse_statewise_estimated_annual_gva_per_establishment_rupees'})
MATCH (target:Table {name: 'asuse_statewise_est_num_of_estb_serving_as_franchisee_outlet'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The number of franchisee outlets affects the average GVA per establishment, as franchise businesses may have different productivity levels compared to others.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'asuse_statewise_estimated_annual_emoluments_per_hired_worker'})
MATCH (target:Table {name: 'asuse_statewise_estimated_number_of_workers_by_type_of_workers'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Average annual emoluments per hired worker depend on the composition and number of hired workers in the state.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'asuse_statewise_estimated_annual_gva_per_worker_rupees'})
MATCH (target:Table {name: 'asuse_statewise_estimated_annual_emoluments_per_hired_worker'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Higher emoluments per worker can incentivize productivity, thereby causally influencing GVA per worker.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'asuse_statewise_estimated_annual_gva_per_establishment_rupees'})
MATCH (target:Table {name: 'asuse_statewise_est_num_of_worker_by_employment_and_gender'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The number and type of workers in establishments influence the productivity and thus the GVA per establishment.',
  strength: 0.75
}]->(target);

MATCH (source:Table {name: 'asuse_statewise_estimated_annual_gva_per_worker_rupees'})
MATCH (target:Table {name: 'asuse_statewise_est_num_of_worker_by_employment_and_gender'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The composition of workers by employment type and gender affects overall productivity and GVA per worker.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'asuse_statewise_estimated_annual_gva_per_establishment_rupees'})
MATCH (target:Table {name: 'asuse_statewise_per1000_distri_of_estb_by_nature_of_operation'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The operational nature of establishments (seasonal, perennial, etc.) affects their productivity and thus the GVA per establishment.',
  strength: 0.65
}]->(target);

MATCH (source:Table {name: 'asuse_statewise_estimated_annual_gva_per_establishment_rupees'})
MATCH (target:Table {name: 'asuse_statewise_per1000_distri_of_estb_by_type_of_location'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The distribution of establishments by location (urban/rural, etc.) causally impacts average GVA per establishment due to varying productivity across locations.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'asuse_statewise_estimated_annual_gva_per_establishment_rupees'})
MATCH (target:Table {name: 'asuse_statewise_per1000_distri_of_estb_by_type_of_ownership'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Ownership type (individual, partnership, etc.) influences establishment productivity and thus GVA per establishment.',
  strength: 0.65
}]->(target);

MATCH (source:Table {name: 'asuse_statewise_estimated_annual_gva_per_worker_rupees'})
MATCH (target:Table {name: 'asuse_statewise_per1000_distri_of_estb_by_type_of_ownership'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Ownership structure can influence labor productivity and thus GVA per worker.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'asuse_statewise_per1000_estb_by_hours_worked_per_day'})
MATCH (target:Table {name: 'asuse_statewise_per1000_estb_by_month_num_operated_last365_day'})
MERGE (source)-[r:RELATED_TO {
  description: 'The average daily working hours of establishments is related to the number of months establishments operate in a year, as longer operational months may require adjustment in daily working hours and vice versa.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'asuse_statewise_per1000_estb_maintain_post_bank_saving_acc'})
MATCH (target:Table {name: 'asuse_statewise_per1000_estb_registered_diff_acts_authorities'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The likelihood of establishments maintaining a bank or post office account depends on their registration status under various acts/authorities, as formal registration often requires or encourages formal banking.',
  strength: 0.75
}]->(target);

MATCH (source:Table {name: 'asuse_statewise_per1000_estb_use_computer_internet_last365_day'})
MATCH (target:Table {name: 'mis_access_to_mass_media_and_broadband'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Establishment-level computer/internet usage is influenced by the general household and regional access to mass media and broadband, as broader digital infrastructure enables higher adoption among businesses.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'asuse_statewise_per1000_estb_maintain_post_bank_saving_acc'})
MATCH (target:Table {name: 'mis_different_source_of_finance'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The prevalence of establishments maintaining bank accounts is influenced by the availability and diversity of financial sources accessible to households in the same state, as greater financial inclusion facilitates formal banking.',
  strength: 0.65
}]->(target);

MATCH (source:Table {name: 'asuse_statewise_per1000_estb_registered_diff_acts_authorities'})
MATCH (target:Table {name: 'asuse_statewise_per1000_estb_maintain_post_bank_saving_acc'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Registration under formal authorities often requires establishments to maintain a bank account, making registration a causal driver for account maintenance.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'asuse_statewise_per1000_estb_use_computer_internet_last365_day'})
MATCH (target:Table {name: 'asuse_statewise_per1000_estb_maintain_post_bank_saving_acc'})
MERGE (source)-[r:RELATED_TO {
  description: 'Establishments that use computers and the internet are more likely to maintain bank accounts due to digital banking and compliance requirements.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'mis_access_to_improved_source_of_drinking_water'})
MATCH (target:Table {name: 'mis_availability_of_basic_transport_and_public_facility'})
MERGE (source)-[r:RELATED_TO {
  description: 'Access to improved drinking water is often related to the general availability of public facilities and transport, as infrastructure development tends to be correlated.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'mis_access_to_mass_media_and_broadband'})
MATCH (target:Table {name: 'asuse_statewise_per1000_estb_use_computer_internet_last365_day'})
MERGE (source)-[r:AGGREGATES {
  description: 'Household-level access to broadband and mass media aggregates up to higher establishment-level computer/internet usage, as digital penetration in society leads to greater business adoption.',
  strength: 0.65
}]->(target);

MATCH (source:Table {name: 'mis_different_source_of_finance'})
MATCH (target:Table {name: 'asuse_statewise_per1000_estb_maintain_post_bank_saving_acc'})
MERGE (source)-[r:DERIVES_FROM {
  description: 'The types of finance sources available to households in a state influence the proportion of establishments maintaining formal bank accounts, as a financially inclusive environment supports business formalization.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'mis_main_reason_for_migration'})
MATCH (target:Table {name: 'mis_income_change_due_to_migration'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The reasons for migration (such as employment, marriage, education) causally influence the direction and magnitude of household income changes due to migration.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'mis_main_reason_for_leaving_last_usual_place_of_residence'})
MATCH (target:Table {name: 'mis_main_reason_for_migration'})
MERGE (source)-[r:DERIVES_FROM {
  description: 'The main reason for leaving the last usual place of residence is a primary input to determining the main reason for migration, as migration is defined by leaving one\'s previous residence.',
  strength: 0.85
}]->(target);

MATCH (source:Table {name: 'mis_usual_place_of_residence_different_from_current_place'})
MATCH (target:Table {name: 'mis_main_reason_for_migration'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Households whose current residence differs from their usual place are identified as migrants, and their migration reasons are then categorized in the main reason for migration table.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'mis_income_change_due_to_migration'})
MATCH (target:Table {name: 'mis_household_assets'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Changes in household income due to migration can causally influence the acquisition or loss of household assets, as higher income may lead to increased asset ownership.',
  strength: 0.75
}]->(target);

MATCH (source:Table {name: 'mis_household_assets'})
MATCH (target:Table {name: 'mis_possession_of_air_conditioner_and_air_cooler'})
MERGE (source)-[r:SUPERSET_OF {
  description: 'Household assets include various items, of which air conditioners and air coolers are specific subcategories; thus, the overall asset table is a superset of the air conditioner/cooler possession table.',
  strength: 0.9
}]->(target);

MATCH (source:Table {name: 'mis_household_assets'})
MATCH (target:Table {name: 'mis_usage_of_mobile_phone'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Ownership of mobile phones as an asset enables and causally influences the usage of mobile phones within households.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'mis_exclusive_access_to_improved_latrine'})
MATCH (target:Table {name: 'mis_improved_latrine_and_hand_wash_facility_in_households'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Exclusive access to improved latrines is a necessary component for a household to be classified as having both improved latrine and handwashing facilities.',
  strength: 0.85
}]->(target);

MATCH (source:Table {name: 'mis_improved_source_of_drinking_water_within_household'})
MATCH (target:Table {name: 'mis_household_assets'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Access to improved drinking water within the household can be influenced by asset ownership, such as water purifiers or storage tanks, and in turn, improved water access can affect asset accumulation through better health and productivity.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'sa_avg_gross_cropped_area_value_quantity_crop_production'})
MATCH (target:Table {name: 'sa_avg_monthly_expenses_and_receipts_for_crop_production'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Average gross cropped area and crop production quantity/value causally influence the receipts from crop production, as higher area and production typically lead to higher receipts.',
  strength: 0.85
}]->(target);

MATCH (source:Table {name: 'sa_avg_gross_cropped_area_value_quantity_crop_production'})
MATCH (target:Table {name: 'sa_avg_monthly_total_expenses_crop_production'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The extent of cropped area and crop production influences total expenses on crop production, as larger areas and higher production require more inputs and spending.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'sa_agri_hhs_use_purchased_seed_by_quality'})
MATCH (target:Table {name: 'sa_avg_gross_cropped_area_value_quantity_crop_production'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The use of purchased seeds by quality affects the quantity and value of crop production, as better quality seeds can improve yields and crop value.',
  strength: 0.75
}]->(target);

MATCH (source:Table {name: 'sa_agri_hhs_reporting_use_of_diff_farming_resources'})
MATCH (target:Table {name: 'sa_avg_monthly_total_expenses_crop_production'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The use of different farming resources (inputs, tools) by households drives the total monthly expenses on crop production.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'sa_agri_hhs_reporting_use_of_diff_farming_resources'})
MATCH (target:Table {name: 'sa_avg_gross_cropped_area_value_quantity_crop_production'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The use of farming resources (fertilizers, machinery, etc.) causally influences the gross cropped area and crop yields.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'sa_agri_hhs_use_purchased_seed_by_quality'})
MATCH (target:Table {name: 'sa_agri_hhs_reporting_use_of_diff_farming_resources'})
MERGE (source)-[r:RELATED_TO {
  description: 'Purchased seed usage is a specific type of farming resource use; both are related in the context of input adoption by households.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'sa_dist_agri_hhs_seed_use_by_agency_of_procurement'})
MATCH (target:Table {name: 'sa_agri_hhs_use_purchased_seed_by_quality'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Distribution of seed use by procurement agency influences the overall use of purchased seeds by quality, as agency type often correlates with seed quality.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'sa_avg_monthly_total_expenses_crop_production'})
MATCH (target:Table {name: 'sa_avg_monthly_expenses_and_receipts_for_crop_production'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Total monthly crop production expenses are a component of the overall expenses and receipts calculation for crop production.',
  strength: 0.9
}]->(target);

MATCH (source:Table {name: 'sa_avg_monthly_total_expenses_receipts_animal_farming_30_days'})
MATCH (target:Table {name: 'sa_avg_expenditure_and_receipts_on_farm_and_nonfarm_assets'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Monthly expenses and receipts from animal farming contribute to the overall average expenditure and receipts on farm assets.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'sa_avg_monthly_expenses_and_receipts_for_crop_production'})
MATCH (target:Table {name: 'sa_avg_expenditure_and_receipts_on_farm_and_nonfarm_assets'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Monthly expenses and receipts for crop production are a key component of total farm asset expenditure and receipts.',
  strength: 0.85
}]->(target);

MATCH (source:Table {name: 'sa_dist_agri_hh_not_insuring_crop_by_reason_for_selected_crop'})
MATCH (target:Table {name: 'sa_avg_monthly_total_expenses_crop_production'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Lack of crop insurance can increase the financial risk and potentially the expenses for crop production, as uninsured farmers may spend more on risk mitigation.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'sa_agri_hhs_crop_sale_quantity_by_agency_major_disposal'})
MATCH (target:Table {name: 'sa_avg_monthly_expenses_and_receipts_for_crop_production'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The quantity of crops sold by agency affects the receipts from crop production, as sales volume and agency type influence realized income.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'sa_agri_hhs_crop_sale_quantity_by_agency_major_disposal'})
MATCH (target:Table {name: 'sa_avg_gross_cropped_area_value_quantity_crop_production'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Crop sale quantities by agency reflect and are influenced by the gross cropped area and production quantity.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'sa_distribution_operational_holdings_by_possession_type'})
MATCH (target:Table {name: 'sa_dist_hhs_leasing_out_land_and_avg_area_social_group'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The distribution of operational holdings by possession type depends on the number of households leasing out land, as leasing out directly affects the share of operational holdings under leased arrangements.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'sa_distribution_operational_holdings_by_possession_type'})
MATCH (target:Table {name: 'sa_distribution_hhs_leasing_in_land_avg_area_social_group'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Operational holdings by possession type are influenced by households leasing in land, as this increases the area under leased-in operational holdings.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'sa_est_num_of_hhs_for_each_size_class_of_land_possessed'})
MATCH (target:Table {name: 'sa_dist_of_hhs_by_hh_classification_for_diff_classes_of_land'})
MERGE (source)-[r:AGGREGATES {
  description: 'The estimated number of households for each size class of land possessed aggregates data from household classifications for different land classes.',
  strength: 0.85
}]->(target);

MATCH (source:Table {name: 'sa_estimated_no_of_hhs_for_different_social_groups'})
MATCH (target:Table {name: 'sa_dist_of_hhs_by_hh_classification_for_diff_classes_of_land'})
MERGE (source)-[r:AGGREGATES {
  description: 'Estimated number of households for different social groups aggregates data from household classifications by social group and land class.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'sa_distribution_loan_outstanding_by_source_of_loan_taken'})
MATCH (target:Table {name: 'sa_est_num_of_hhs_for_each_size_class_of_land_possessed'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Outstanding agricultural loans by source are influenced by the number of households in each landholding class, as land size affects credit demand and access.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'sa_no_per_1000_distri_of_agri_hhs_reporting_sale_of_crops'})
MATCH (target:Table {name: 'sa_dist_of_agri_hhs_reporting_use_of_purchased_seed'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The number of agricultural households reporting sale of crops depends on the use of purchased seeds, as higher seed quality and adoption can increase productivity and marketable surplus.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'sa_no_of_hhs_owning_of_livestock_of_different_types'})
MATCH (target:Table {name: 'sa_estimated_no_of_hhs_for_different_social_groups'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Livestock ownership by households is influenced by the number of households in different social groups, as social group composition affects livestock holding patterns.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'sa_no_per_1000_distri_of_agri_hhs_reporting_sale_of_crops'})
MATCH (target:Table {name: 'sa_no_of_hhs_owning_of_livestock_of_different_types'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The sale of crops by agricultural households can be influenced by livestock ownership, as mixed farming systems (crop-livestock) affect market participation and income diversification.',
  strength: 0.5
}]->(target);

MATCH (source:Table {name: 'sa_distribution_operational_holdings_by_possession_type'})
MATCH (target:Table {name: 'sa_est_num_of_hhs_for_each_size_class_of_land_possessed'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The distribution of operational holdings by possession type is influenced by the number of households in each landholding size class, as operational holdings are a function of land possessed.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'sa_dist_hhs_leasing_out_land_and_avg_area_social_group'})
MATCH (target:Table {name: 'sa_distribution_hhs_leasing_in_land_avg_area_social_group'})
MERGE (source)-[r:RELATED_TO {
  description: 'Households leasing out land are directly related to households leasing in land, as these are two sides of the land lease market.',
  strength: 0.9
}]->(target);

MATCH (source:Table {name: 'statewise_nsdp'})
MATCH (target:Table {name: 'statewise_nsva'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Statewise NSDP (Net State Domestic Product) is calculated based on the sum of Net State Value Added (NSVA) across industries and sectors for each state. NSDP depends on the sectoral and industry-wise value added data from NSVA.',
  strength: 0.95
}]->(target);

MATCH (source:Table {name: 'statewise_nsdp'})
MATCH (target:Table {name: 'statewise_pcnsdp'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Per capita NSDP (PCNSDP) is derived from NSDP by dividing by the state population. Thus, PCNSDP depends on NSDP values.',
  strength: 0.9
}]->(target);

MATCH (source:Table {name: 'statewise_nsva'})
MATCH (target:Table {name: 'statewise_nsdp'})
MERGE (source)-[r:AGGREGATES {
  description: 'NSDP aggregates NSVA across all industries and sectors for each state and year.',
  strength: 0.95
}]->(target);

MATCH (source:Table {name: 'annual_survey_of_industries'})
MATCH (target:Table {name: 'statewise_nsva'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Statewise NSVA for the secondary sector (industry) depends on industry-wise output, value added, and employment data from the Annual Survey of Industries.',
  strength: 0.85
}]->(target);

MATCH (source:Table {name: 'annual_survey_of_industries'})
MATCH (target:Table {name: 'statewise_nsdp'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Statewise NSDP includes value added from the industrial sector, which is derived from the Annual Survey of Industries data.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'periodic_labour_force_survey'})
MATCH (target:Table {name: 'statewise_nsdp'})
MERGE (source)-[r:RELATED_TO {
  description: 'Higher NSDP growth is generally associated with improvements in labor market indicators such as employment rates and labor force participation, as measured by the Periodic Labour Force Survey.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'periodic_labour_force_survey'})
MATCH (target:Table {name: 'annual_survey_of_industries'})
MERGE (source)-[r:RELATED_TO {
  description: 'Industrial sector growth (captured in the Annual Survey of Industries) causally increases employment in the formal sector, which is reflected in labor force and employment indicators in the Periodic Labour Force Survey.',
  strength: 0.75
}]->(target);

MATCH (source:Table {name: 'statewise_nsva'})
MATCH (target:Table {name: 'periodic_labour_force_survey'})
MERGE (source)-[r:RELATED_TO {
  description: 'Sectoral value added (especially in primary and secondary sectors) causally influences employment levels and labor force participation at the state level.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'sa_no_per_hh_operational_holding_by_size_hh_oper_holding'})
MATCH (target:Table {name: 'statewise_nsva'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The distribution of operational holdings by size at the state level affects agricultural output and thus the primary sector\'s contribution to NSVA.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'sa_perc_dist_of_land_for_hhs_belonging_operational_holding'})
MATCH (target:Table {name: 'statewise_nsva'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Percentage distribution of land by operational holding size and ownership impacts agricultural productivity and value added in the primary sector for NSVA.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'sa_percent_distribution_of_leased_out_land_by_terms_of_lease'})
MATCH (target:Table {name: 'statewise_nsva'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Terms of land leasing and ownership patterns affect agricultural production and thus the value added in the primary sector (NSVA).',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'sa_per_1000_agri_hh_insured_experienced_crop_loss'})
MATCH (target:Table {name: 'statewise_nsva'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The incidence of crop loss among insured agricultural households impacts agricultural output and value added in the primary sector (NSVA).',
  strength: 0.65
}]->(target);

MATCH (source:Table {name: 'sa_per_1000_crop_producing_hh_crop_disposal_agency_sale_satisf'})
MATCH (target:Table {name: 'statewise_nsva'})
MERGE (source)-[r:RELATED_TO {
  description: 'Satisfaction with crop disposal agencies can influence farmers\' income and market participation, which in turn affects agricultural sector value added (NSVA).',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'other_macro_economic_indicators_daily_data'})
MATCH (target:Table {name: 'other_macro_economic_indicators_monthly_data'})
MERGE (source)-[r:AGGREGATES {
  description: 'Monthly macroeconomic indicators are aggregated from daily data such as interest rates and forex rates; daily fluctuations influence the monthly averages and trends.',
  strength: 0.85
}]->(target);

MATCH (source:Table {name: 'other_macro_economic_indicators_monthly_data'})
MATCH (target:Table {name: 'other_macro_economic_indicators_quaterly_data'})
MERGE (source)-[r:AGGREGATES {
  description: 'Quarterly macroeconomic indicators, such as GDP and balance of payments, are aggregated from monthly fiscal, trade, and monetary data.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'other_macro_economic_indicators_weekly_data'})
MATCH (target:Table {name: 'other_macro_economic_indicators_monthly_data'})
MERGE (source)-[r:AGGREGATES {
  description: 'Monthly indicators such as currency assets and interest rates are influenced by weekly trends in foreign reserves and call money rates.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'top_fifty_macro_economic_indicators_fortnightly_data'})
MATCH (target:Table {name: 'top_fifty_macro_economic_indicators_monthly_data'})
MERGE (source)-[r:AGGREGATES {
  description: 'Monthly macroeconomic indicators such as investment, deposits, and money supply are aggregated from fortnightly data.',
  strength: 0.75
}]->(target);

MATCH (source:Table {name: 'top_fifty_macro_economic_indicators_monthly_data'})
MATCH (target:Table {name: 'top_fifty_macro_economic_indicators_quaterly_data'})
MERGE (source)-[r:AGGREGATES {
  description: 'Quarterly external sector indicators (BoP, IIP, external debt) are aggregated from monthly data on investments, trade, and payments.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'top_fifty_macro_economic_indicators_weekly_data'})
MATCH (target:Table {name: 'top_fifty_macro_economic_indicators_monthly_data'})
MERGE (source)-[r:AGGREGATES {
  description: 'Monthly indicators such as policy rates, bond yields, and forex reserves are influenced by weekly financial and monetary trends.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'other_macro_economic_indicators_quaterly_data'})
MATCH (target:Table {name: 'top_fifty_macro_economic_indicators_quaterly_data'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Quarterly GDP and BoP figures in the \'other_macro_economic_indicators_quaterly_data\' table contribute to overall balance of payments and external sector indicators in the \'top_fifty_macro_economic_indicators_quaterly_data\' table.',
  strength: 0.85
}]->(target);

MATCH (source:Table {name: 'gst_registrations'})
MATCH (target:Table {name: 'gst_settlement_of_igst_to_states'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The volume and type of GST registrations in a state causally influence the IGST settlements received by that state, as higher registrations generally lead to higher tax collections and settlements.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'gst_settlement_of_igst_to_states'})
MATCH (target:Table {name: 'other_macro_economic_indicators_monthly_data'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Monthly IGST settlements to states are a component of total government revenue and fiscal deficit figures in the national monthly macroeconomic indicators.',
  strength: 0.75
}]->(target);

MATCH (source:Table {name: 'other_macro_economic_indicators_monthly_data'})
MATCH (target:Table {name: 'other_macro_economic_indicators_quaterly_data'})
MERGE (source)-[r:DERIVES_FROM {
  description: 'Quarterly GDP and BoP data are derived from the aggregation of monthly fiscal, trade, and monetary indicators.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'other_macro_economic_indicators_quaterly_data'})
MATCH (target:Table {name: 'other_macro_economic_indicators_monthly_data'})
MERGE (source)-[r:SUPERSET_OF {
  description: 'Quarterly data is a superset of monthly data, summarizing and aggregating monthly trends into broader economic measures such as GDP and BoP.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'other_macro_economic_indicators_monthly_data'})
MATCH (target:Table {name: 'top_fifty_macro_economic_indicators_monthly_data'})
MERGE (source)-[r:RELATED_TO {
  description: 'Both tables capture overlapping monthly macroeconomic indicators such as trade, investments, and monetary aggregates, and changes in one can causally relate to changes in the other.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'gst_statewise_tax_collection_data'})
MATCH (target:Table {name: 'gross_and_net_tax_collection'})
MERGE (source)-[r:AGGREGATES {
  description: 'State-wise GST tax collections aggregate to form the national-level gross and net GST tax collection figures.',
  strength: 0.95
}]->(target);

MATCH (source:Table {name: 'gst_statewise_tax_collection_refund_data'})
MATCH (target:Table {name: 'gross_and_net_tax_collection'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'National net tax collections depend on state-wise GST refunds, as refunds reduce the net revenue collected.',
  strength: 0.9
}]->(target);

MATCH (source:Table {name: 'gst_statewise_tax_collection_data'})
MATCH (target:Table {name: 'gst_statewise_tax_collection_refund_data'})
MERGE (source)-[r:RELATED_TO {
  description: 'Gross GST collections at the state level are related to refunds, as higher collections may lead to higher refunds and vice versa.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'gstr_one'})
MATCH (target:Table {name: 'gst_statewise_tax_collection_data'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'GST tax collections depend on the timely and complete filing of GSTR-1 returns by taxpayers in each state.',
  strength: 0.85
}]->(target);

MATCH (source:Table {name: 'gstr_three_b'})
MATCH (target:Table {name: 'gst_statewise_tax_collection_data'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'GST tax collections depend on the filing compliance of GSTR-3B returns, as these returns are used for tax payment and reporting.',
  strength: 0.85
}]->(target);

MATCH (source:Table {name: 'gstr_one'})
MATCH (target:Table {name: 'gstr_three_b'})
MERGE (source)-[r:RELATED_TO {
  description: 'GSTR-1 and GSTR-3B filings are related compliance indicators for GST, with GSTR-1 reporting outward supplies and GSTR-3B being a summary return for tax payment.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'niryat_ite_state'})
MATCH (target:Table {name: 'niryat_ite_commodity'})
MERGE (source)-[r:AGGREGATES {
  description: 'State-wise export data aggregates to commodity-wise national export figures, as state exports by commodity sum to national totals.',
  strength: 0.9
}]->(target);

MATCH (source:Table {name: 'niryat_ite_state'})
MATCH (target:Table {name: 'gross_and_net_tax_collection'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'State-level export performance influences GST collections, especially IGST on exports and related refunds.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'niryat_ite_commodity'})
MATCH (target:Table {name: 'gross_and_net_tax_collection'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'National export performance by commodity group can influence GST collections, as higher exports can increase IGST collections and refund outflows.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'fpi_india_yr_invtype'})
MATCH (target:Table {name: 'gross_and_net_tax_collection'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Foreign Portfolio Investment inflows can impact economic activity and thus influence national tax collections through increased investment and consumption.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'wages_sector_industry_index'})
MATCH (target:Table {name: 'gross_and_net_tax_collection'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Wage growth across sectors and industries can drive consumption, thereby increasing GST and other tax collections at the national level.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'wages_sector_industry_index'})
MATCH (target:Table {name: 'gst_statewise_tax_collection_data'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Sectoral wage growth in a state can boost consumption, leading to higher GST collections at the state level.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'eshram_state_dly_registrations'})
MATCH (target:Table {name: 'wages_sector_industry_index'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Increased registrations of informal workers (e-Shram) may lead to formalization, potentially impacting wage indices in the long run.',
  strength: 0.5
}]->(target);

MATCH (source:Table {name: 'eshram_state_dly_registrations'})
MATCH (target:Table {name: 'gst_statewise_tax_collection_data'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Growth in formal worker registrations (e-Shram) can increase the tax base and eventually lead to higher GST collections at the state level.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'stock_india_mth_boaccounts'})
MATCH (target:Table {name: 'marketcap_nse_india_mth'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Growth in BO (Beneficial Owner) accounts reflects increased retail and institutional participation in the stock market, which can drive up NSE market capitalization through increased trading and investment activity.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'stock_india_mth_dps'})
MATCH (target:Table {name: 'stock_india_mth_boaccounts'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The number of Depository Participants (DPs) and their activity directly impacts the opening and maintenance of BO accounts, as DPs are the intermediaries through which BO accounts are managed.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'mf_monthly_schemes'})
MATCH (target:Table {name: 'marketcap_nse_india_mth'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Mutual fund inflows and net assets under management influence demand for equities, thereby impacting NSE market capitalization.',
  strength: 0.75
}]->(target);

MATCH (source:Table {name: 'statewise_petroleum_consumption'})
MATCH (target:Table {name: 'co2_emissions_by_fuel_yearly'})
MERGE (source)-[r:AGGREGATES {
  description: 'State-level petroleum consumption aggregates to national oil and gas CO2 emissions, as higher petroleum use increases emissions from oil and gas at the national level.',
  strength: 0.85
}]->(target);

MATCH (source:Table {name: 'statewise_cumulative_renewable_power'})
MATCH (target:Table {name: 'co2_emissions_by_fuel_yearly'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Increased renewable power capacity at the state level can reduce reliance on fossil fuels, thereby lowering national CO2 emissions from coal, oil, and gas.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'quick_estimates_major_commodities_july_export'})
MATCH (target:Table {name: 'marketcap_nse_india_mth'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Strong export performance in major commodities can boost corporate earnings and investor sentiment, positively influencing stock market capitalization.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'quick_estimates_major_commodities_july_import'})
MATCH (target:Table {name: 'marketcap_nse_india_mth'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Major commodity import trends affect input costs for industries, which can impact profitability and thus influence NSE market capitalization.',
  strength: 0.5
}]->(target);

MATCH (source:Table {name: 'revenue_maharashtra_fy_category'})
MATCH (target:Table {name: 'statewise_petroleum_consumption'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'State revenue in Maharashtra, especially from taxes on petroleum products, is influenced by the level of petroleum consumption in the state.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'statewise_cumulative_renewable_power'})
MATCH (target:Table {name: 'revenue_maharashtra_fy_category'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Growth in renewable power capacity in Maharashtra can affect state revenue through changes in energy sector taxation and incentives.',
  strength: 0.5
}]->(target);

MATCH (source:Table {name: 'statewise_cumulative_renewable_power'})
MATCH (target:Table {name: 'co2_emissions_by_fuel_yearly'})
MERGE (source)-[r:AGGREGATES {
  description: 'State-level renewable power additions aggregate to national renewable energy capacity, which influences the national CO2 emissions profile.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'ki_assam_mth_sctg'})
MATCH (target:Table {name: 'insurance_india_mth_sctg'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'State fiscal indicators in Assam (e.g., budget allocations, actuals) can causally influence insurance sector performance in Assam, which aggregates into national insurance data. For example, increased state spending or economic activity can drive higher insurance uptake, contributing to national insurance trends.',
  strength: 0.4
}]->(target);

MATCH (source:Table {name: 'toll_state_monthly_etc_transactions'})
MATCH (target:Table {name: 'trade_india_mth_commodity_import'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'State-level toll transactions reflect road transport activity, which is partly driven by movement of imported goods from ports to consumption centers. Higher imports can cause increased toll transactions as goods are transported across states.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'toll_state_monthly_etc_transactions'})
MATCH (target:Table {name: 'trade_india_mth_commodity_export'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'State-level toll transactions are influenced by the movement of export goods to ports. Higher exports can lead to increased road transport and thus higher toll transactions.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'ev_state_yr_catg'})
MATCH (target:Table {name: 'toll_state_monthly_etc_transactions'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Increased adoption of EVs at the state level can causally impact toll transaction patterns, as EVs may be subject to different toll policies or usage rates, affecting overall toll transaction counts and values.',
  strength: 0.5
}]->(target);

MATCH (source:Table {name: 'ev_state_yr_catg'})
MATCH (target:Table {name: 'insurance_india_mth_sctg'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Growth in state-level EV registrations contributes to changes in the national insurance market, driving demand for new types of motor insurance products and affecting premium collections at the national level.',
  strength: 0.5
}]->(target);

MATCH (source:Table {name: 'trade_india_mth_commodity_import'})
MATCH (target:Table {name: 'insurance_india_mth_sctg'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'National import activity, especially in high-value goods, can drive demand for marine and cargo insurance products, influencing the performance of the insurance sector.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'trade_india_mth_commodity_export'})
MATCH (target:Table {name: 'insurance_india_mth_sctg'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'National export activity increases demand for export-related insurance products (e.g., marine, cargo), impacting insurance sector growth and premium collections.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'trade_india_mth_stateut_country_export'})
MATCH (target:Table {name: 'trade_india_mth_commodity_export'})
MERGE (source)-[r:AGGREGATES {
  description: 'State/UT-level export data aggregates up to national commodity export totals, as national exports are the sum of exports from all states/UTs.',
  strength: 1.0
}]->(target);

MATCH (source:Table {name: 'trade_india_mth_commoditygrp_country_export'})
MATCH (target:Table {name: 'trade_india_mth_commodity_export'})
MERGE (source)-[r:AGGREGATES {
  description: 'Commodity group-wise export data by country aggregates into national commodity export totals, as national exports are the sum of all commodity group exports.',
  strength: 1.0
}]->(target);

MATCH (source:Table {name: 'energy_india_statewise_coal_reserves'})
MATCH (target:Table {name: 'trade_india_mth_commodity_export'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'State-wise coal reserves determine the capacity for coal mining and exports, causally influencing India\'s coal export volumes and trends.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'energy_india_statewise_coal_reserves'})
MATCH (target:Table {name: 'trade_india_mth_commodity_import'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Lower state-wise coal reserves or production can lead to higher national coal imports to meet energy demand, causally linking coal reserves to import activity.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'traffic_india_mth_air_passengers'})
MATCH (target:Table {name: 'trade_india_mth_commodity_import'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Growth in air passenger traffic can reflect increased economic activity and demand for imported goods (e.g., electronics, luxury items), potentially driving up import volumes.',
  strength: 0.5
}]->(target);

MATCH (source:Table {name: 'traffic_india_mth_air_passengers'})
MATCH (target:Table {name: 'trade_india_mth_commodity_export'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Increased air passenger traffic may be associated with higher export activity, as business travel and air cargo often rise together, especially for high-value exports.',
  strength: 0.5
}]->(target);

MATCH (source:Table {name: 'energy_india_statewise_crude_oil_ngas_reserves'})
MATCH (target:Table {name: 'fdi_india_fy_state'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'States with higher crude oil and natural gas reserves are likely to attract more FDI in energy and related sectors, as resource availability is a key driver for investment decisions.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'energy_india_statewise_crude_oil_ngas_reserves'})
MATCH (target:Table {name: 'fdi_india_fy_sector'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The availability of crude oil and natural gas reserves at the state level influences sectoral FDI inflows, particularly into the energy, petrochemical, and related sectors at the national level.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'fdi_india_fy_state'})
MATCH (target:Table {name: 'fdi_india_fy_sector'})
MERGE (source)-[r:AGGREGATES {
  description: 'State-level FDI inflows, when aggregated across states and mapped to sectors, contribute to the sectoral FDI inflow figures at the national level.',
  strength: 0.9
}]->(target);

MATCH (source:Table {name: 'fdi_india_fy_state'})
MATCH (target:Table {name: 'fdi_india_fy_country'})
MERGE (source)-[r:AGGREGATES {
  description: 'FDI inflows into states, when summed and attributed to source countries, aggregate up to the national FDI inflow by country.',
  strength: 0.9
}]->(target);

MATCH (source:Table {name: 'fdi_india_fy_sector'})
MATCH (target:Table {name: 'fdi_india_fy_country'})
MERGE (source)-[r:AGGREGATES {
  description: 'Sectoral FDI inflows, when mapped to their source countries, contribute to the total FDI inflow by country at the national level.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'fdi_india_fy_state'})
MATCH (target:Table {name: 'labour_india_sector_industry_occupation_wages'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Higher FDI inflows into states can drive up demand for skilled labor, potentially increasing sector/industry/occupation wages at the national level.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'fdi_india_fy_sector'})
MATCH (target:Table {name: 'labour_india_sector_industry_occupation_wages'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Increased FDI in specific sectors leads to higher investment, expansion, and potentially higher wages in those sectors at the national level.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'labour_india_rural_wages'})
MATCH (target:Table {name: 'labour_india_sector_industry_occupation_wages'})
MERGE (source)-[r:AGGREGATES {
  description: 'Rural wage data, when aggregated and combined with urban wage data, contributes to the overall sector/industry/occupation wage statistics at the national level.',
  strength: 0.85
}]->(target);

MATCH (source:Table {name: 'fdi_india_fy_state'})
MATCH (target:Table {name: 'mf_india_qtr_total'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Higher FDI inflows into states can stimulate economic activity, increase incomes, and indirectly boost mutual fund investments at the national level.',
  strength: 0.5
}]->(target);

MATCH (source:Table {name: 'labour_india_sector_industry_occupation_wages'})
MATCH (target:Table {name: 'mf_india_qtr_total'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Rising wages at the national level increase disposable income, which can lead to higher investments in mutual funds.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'mf_india_qtr_total'})
MATCH (target:Table {name: 'insurance_india_mth_life_insurer'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Higher mutual fund investments reflect greater household savings and financialization, which can also drive growth in life insurance premium collections.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'labour_india_sector_industry_occupation_wages'})
MATCH (target:Table {name: 'insurance_india_mth_life_insurer'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Higher national wages increase household disposable income, enabling greater purchase of life insurance policies and higher premium collections.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'labour_india_rural_wages'})
MATCH (target:Table {name: 'insurance_india_mth_life_insurer'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Increases in rural wages can lead to higher rural household incomes, which may boost rural life insurance penetration and premium collections.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'trade_india_annual_country'})
MATCH (target:Table {name: 'fdi_india_fy_country'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Trade relationships with specific countries often facilitate greater FDI inflows from those countries, as trade partners seek to invest in the Indian market.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'fdi_india_fy_country'})
MATCH (target:Table {name: 'trade_india_annual_country'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Increased FDI from a country can lead to higher trade volumes with that country, as foreign investors import/export goods and services.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'sp_india_daily_state'})
MATCH (target:Table {name: 'labour_india_rural_wages'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Social protection schemes like PM-JAY can improve health outcomes, indirectly supporting higher rural labor productivity and potentially raising rural wages.',
  strength: 0.5
}]->(target);

MATCH (source:Table {name: 'sp_india_daily_state'})
MATCH (target:Table {name: 'insurance_india_mth_life_insurer'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Increased awareness and coverage of social protection schemes can drive demand for private insurance products as complementary risk mitigation.',
  strength: 0.5
}]->(target);

MATCH (source:Table {name: 'annual_chemical_production_data'})
MATCH (target:Table {name: 'trade_india_mth_region_commodity'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Exports of chemical commodities by region (trade_india_mth_region_commodity) depend on the annual production of major chemicals in India (annual_chemical_production_data), as higher domestic production enables greater export capacity.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'crude_oil_mth_data'})
MATCH (target:Table {name: 'ppac_mth_petroleum_consumption'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Monthly petroleum product consumption (ppac_mth_petroleum_consumption) depends on the availability of crude oil processed by Indian refineries (crude_oil_mth_data), as refined products are derived from crude oil inputs.',
  strength: 0.85
}]->(target);

MATCH (source:Table {name: 'crude_oil_mth_data'})
MATCH (target:Table {name: 'trade_india_mth_country'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Exports of petroleum products to other countries (trade_india_mth_country) depend on the volume of crude oil processed in India (crude_oil_mth_data), as refining output determines exportable surplus.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'ppac_mth_petroleum_consumption'})
MATCH (target:Table {name: 'trade_india_mth_country'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Monthly exports of petroleum products (trade_india_mth_country) depend on domestic consumption levels (ppac_mth_petroleum_consumption), as lower domestic consumption can increase exportable surplus.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'trade_india_mth_region_commodity'})
MATCH (target:Table {name: 'trade_india_mth_region'})
MERGE (source)-[r:AGGREGATES {
  description: 'Region-commodity level export data (trade_india_mth_region_commodity) aggregates up to region-level export data (trade_india_mth_region), as total regional exports are the sum of exports across all commodities.',
  strength: 1.0
}]->(target);

MATCH (source:Table {name: 'trade_india_mth_region'})
MATCH (target:Table {name: 'trade_india_mth_country'})
MERGE (source)-[r:AGGREGATES {
  description: 'Country-level export data (trade_india_mth_country) aggregates up to region-level export data (trade_india_mth_region), as regional totals are the sum of exports to constituent countries.',
  strength: 1.0
}]->(target);

MATCH (source:Table {name: 'trade_india_mth_country'})
MATCH (target:Table {name: 'trade_india_mth_region'})
MERGE (source)-[r:DERIVES_FROM {
  description: 'Region-level export data (trade_india_mth_region) is derived from the sum of country-level export data (trade_india_mth_country) for countries within each region.',
  strength: 1.0
}]->(target);

MATCH (source:Table {name: 'epfo_india_mth_payroll_view'})
MATCH (target:Table {name: 'ppac_mth_petroleum_consumption'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Payroll additions (epfo_india_mth_payroll_view), as a proxy for formal employment, drive petroleum product consumption (ppac_mth_petroleum_consumption), since higher employment increases demand for transportation and energy.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'epfo_india_mth_payroll_view'})
MATCH (target:Table {name: 'rbi_india_mth_payment_system_indicators'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Growth in formal employment (epfo_india_mth_payroll_view) increases the volume and value of digital and banking transactions (rbi_india_mth_payment_system_indicators), as more workers receive salaries and participate in the formal financial system.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'msme_sambandh_procurement_data'})
MATCH (target:Table {name: 'epfo_india_mth_payroll_view'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Government procurement from MSMEs (msme_sambandh_procurement_data) supports MSME growth and job creation, leading to higher payroll additions in the formal sector (epfo_india_mth_payroll_view).',
  strength: 0.65
}]->(target);

MATCH (source:Table {name: 'msme_sambandh_procurement_data'})
MATCH (target:Table {name: 'trade_india_mth_region_commodity'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Procurement from MSMEs (msme_sambandh_procurement_data) can boost MSME production capacity, enabling higher exports of MSME-produced commodities (trade_india_mth_region_commodity).',
  strength: 0.5
}]->(target);

MATCH (source:Table {name: 'rbi_india_mth_payment_system_indicators'})
MATCH (target:Table {name: 'trade_india_mth_country'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Efficient payment systems (rbi_india_mth_payment_system_indicators) facilitate international trade transactions, supporting higher exports (trade_india_mth_country).',
  strength: 0.5
}]->(target);

MATCH (source:Table {name: 'rbi_india_mth_bank_mobile_banking'})
MATCH (target:Table {name: 'rbi_india_mth_bank_internet_banking'})
MERGE (source)-[r:RELATED_TO {
  description: 'Mobile banking and internet banking are closely related as both reflect digital banking adoption and can influence each other\'s growth through consumer digital literacy and technological adoption.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'demography_india_state_yr_literacy'})
MATCH (target:Table {name: 'rbi_india_mth_bank_mobile_banking'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Higher state-level literacy rates causally increase adoption and usage of mobile banking services, as more literate populations are more likely to use digital financial services.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'demography_india_state_yr_literacy'})
MATCH (target:Table {name: 'rbi_india_mth_bank_internet_banking'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Higher literacy rates at the state level causally drive greater adoption of internet banking, as digital and financial literacy are prerequisites for usage.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'demography_india_yr_popsexgrowth'})
MATCH (target:Table {name: 'hces_india_yr_sector'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Population growth and demographic structure causally influence household consumption expenditure patterns at the national level.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'hces_india_yr_sector'})
MATCH (target:Table {name: 'asi_imp_principal_characteristics_by_rural_urban_sector'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Household consumption expenditure (demand) causally drives industrial production characteristics in rural and urban sectors, as higher consumption increases demand for manufactured goods.',
  strength: 0.75
}]->(target);

MATCH (source:Table {name: 'asi_imp_principal_characteristics_by_rural_urban_sector'})
MATCH (target:Table {name: 'asi_imp_principal_characteristics_india_by_mjr_indus_grp'})
MERGE (source)-[r:AGGREGATES {
  description: 'Industrial characteristics by rural/urban sector aggregate into characteristics by major industry group at the national level.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'asi_imp_principal_characteristics_india_by_mjr_indus_grp'})
MATCH (target:Table {name: 'asi_industrywise_factories_2022_23'})
MERGE (source)-[r:AGGREGATES {
  description: 'Principal characteristics by industry group aggregate into the total number of factories by industry type.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'asi_industrywise_factories_2022_23'})
MATCH (target:Table {name: 'asi_imp_principal_characteristics_india_by_mjr_indus_grp'})
MERGE (source)-[r:DERIVES_FROM {
  description: 'The number of factories by industry type is derived from the characteristics and classification of major industry groups.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'rbi_india_mth_bank_rtgs'})
MATCH (target:Table {name: 'rbi_india_mth_bank_neft'})
MERGE (source)-[r:RELATED_TO {
  description: 'RTGS and NEFT are both major payment systems in India; changes in one can causally influence the usage patterns of the other as substitutes or complements in the payments ecosystem.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'rbi_india_mth_bank_mobile_banking'})
MATCH (target:Table {name: 'rbi_india_mth_bank_neft'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Increased mobile banking adoption can causally increase NEFT transaction volumes, as mobile banking apps often provide NEFT as a payment option.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'rbi_india_mth_bank_mobile_banking'})
MATCH (target:Table {name: 'rbi_india_mth_bank_rtgs'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Growth in mobile banking can causally increase RTGS transaction volumes, especially for high-value retail and business payments.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'rbi_india_mth_bank_internet_banking'})
MATCH (target:Table {name: 'rbi_india_mth_bank_neft'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Internet banking adoption causally increases NEFT transaction volumes, as NEFT is a common payment mode in internet banking platforms.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'rbi_india_mth_bank_internet_banking'})
MATCH (target:Table {name: 'rbi_india_mth_bank_rtgs'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Internet banking adoption causally increases RTGS transaction volumes, especially for corporate and high-value transactions.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'asi_num_of_factories_nva'})
MATCH (target:Table {name: 'asi_no_of_workers_and_person_engaged'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The number of factories and net value added (NVA) in the industrial sector causally depend on the number of workers and persons engaged, as labor is a key input to industrial output and value addition.',
  strength: 0.85
}]->(target);

MATCH (source:Table {name: 'asi_num_of_factories_nva'})
MATCH (target:Table {name: 'asi_statewise_number_of_factories_for_2022_23'})
MERGE (source)-[r:AGGREGATES {
  description: 'The national-level number of factories is an aggregate of statewise number of factories for 2022-23.',
  strength: 0.95
}]->(target);

MATCH (source:Table {name: 'asi_num_of_factories_nva'})
MATCH (target:Table {name: 'asi_top_ten_states_by_number_of_factories'})
MERGE (source)-[r:AGGREGATES {
  description: 'The total number of factories at the national level is an aggregate of the number of factories in the top ten states (and others).',
  strength: 0.9
}]->(target);

MATCH (source:Table {name: 'asi_trend_of_imp_principal_characteristics_india'})
MATCH (target:Table {name: 'asi_num_of_factories_nva'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Trends in important principal characteristics for India (such as income categories) depend on the net value added and number of factories, as these are major contributors to industrial sector performance.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'asi_trend_of_imp_principal_characteristics_india'})
MATCH (target:Table {name: 'asi_no_of_workers_and_person_engaged'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Principal characteristics of Indian industry (e.g., income, output) are causally influenced by the number of workers and persons engaged, as labor input affects overall industrial performance.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'asi_trend_imp_characteristics_technical_coefficients'})
MATCH (target:Table {name: 'asi_num_of_factories_nva'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Technical coefficients (e.g., input-output ratios) at the regional level causally influence the net value added by affecting industrial productivity and efficiency.',
  strength: 0.75
}]->(target);

MATCH (source:Table {name: 'asi_trend_of_imp_characteristics_structural_ratios'})
MATCH (target:Table {name: 'asi_num_of_factories_nva'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Structural ratios (such as capital-labor ratio, output-capital ratio) at the regional level causally affect net value added and the number of factories by reflecting structural changes in the industry.',
  strength: 0.75
}]->(target);

MATCH (source:Table {name: 'asi_trend_imp_characteristics_technical_coefficients'})
MATCH (target:Table {name: 'asi_trend_of_imp_characteristics_structural_ratios'})
MERGE (source)-[r:RELATED_TO {
  description: 'Technical coefficients and structural ratios are closely related indicators of industrial performance and structure at the regional level; changes in one often reflect or cause changes in the other.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'asi_top_ten_states_by_number_of_factories'})
MATCH (target:Table {name: 'asi_statewise_number_of_factories_for_2022_23'})
MERGE (source)-[r:SUPERSET_OF {
  description: 'The top ten states by number of factories is a subset of the full statewise number of factories data for 2022-23.',
  strength: 0.95
}]->(target);

MATCH (source:Table {name: 'iip_in_kerala_monthly'})
MATCH (target:Table {name: 'iip_in_kerala_fy_index'})
MERGE (source)-[r:AGGREGATES {
  description: 'The quarterly IIP index for Kerala is aggregated from the monthly IIP data for Kerala.',
  strength: 1.0
}]->(target);

MATCH (source:Table {name: 'iip_in_rajasthan_monthly'})
MATCH (target:Table {name: 'iip_in_rajasthan_fy_index'})
MERGE (source)-[r:AGGREGATES {
  description: 'The annual IIP values for Rajasthan (iip_in_rajasthan_fy_index) are aggregated from the monthly IIP data (iip_in_rajasthan_monthly).',
  strength: 0.95
}]->(target);

MATCH (source:Table {name: 'iip_in_rajasthan_two_digit_index'})
MATCH (target:Table {name: 'iip_in_rajasthan_fy_index'})
MERGE (source)-[r:AGGREGATES {
  description: 'The overall Rajasthan IIP index (iip_in_rajasthan_fy_index) is aggregated from the two-digit industry-level IIP data (iip_in_rajasthan_two_digit_index).',
  strength: 0.9
}]->(target);

MATCH (source:Table {name: 'iip_in_rajasthan_monthly'})
MATCH (target:Table {name: 'iip_in_rajasthan_fy_index'})
MERGE (source)-[r:DERIVES_FROM {
  description: 'Annual IIP values are derived from monthly IIP data for Rajasthan.',
  strength: 0.9
}]->(target);

MATCH (source:Table {name: 'iip_in_andra_pradesh_sector_industry_wise'})
MATCH (target:Table {name: 'iip_in_andra_pradesh_sector_wise'})
MERGE (source)-[r:AGGREGATES {
  description: 'Sector-wise IIP for Andhra Pradesh is aggregated from sector- and industry-wise IIP data.',
  strength: 0.9
}]->(target);

MATCH (source:Table {name: 'iip_in_andra_pradesh_sector_industry_wise'})
MATCH (target:Table {name: 'iip_in_andra_pradesh_use_wise'})
MERGE (source)-[r:DERIVES_FROM {
  description: 'Use-wise IIP for Andhra Pradesh is derived from sector- and industry-wise IIP data, as use categories are constructed from industry outputs.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'iip_in_andra_pradesh_sector_wise'})
MATCH (target:Table {name: 'iip_in_andra_pradesh_use_wise'})
MERGE (source)-[r:DERIVES_FROM {
  description: 'Use-wise IIP can be derived from sector-wise IIP data by mapping sectors to use categories.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'iip_in_kerala_quarterly'})
MATCH (target:Table {name: 'youthpower_district_level_metrics'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Industrial production in Kerala (iip_in_kerala_quarterly) causally influences youth employment, opportunity, and workforce participation metrics at the district level (youthpower_district_level_metrics) within Kerala.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'iip_in_rajasthan_fy_index'})
MATCH (target:Table {name: 'youthpower_district_level_metrics'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Rajasthan\'s industrial production (iip_in_rajasthan_fy_index) causally influences youth employment and opportunity metrics at the district level in Rajasthan, as higher industrial output creates more jobs and economic opportunities.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'iip_in_andra_pradesh_sector_wise'})
MATCH (target:Table {name: 'youthpower_district_level_metrics'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Andhra Pradesh\'s sector-wise industrial production (iip_in_andra_pradesh_sector_wise) causally affects youth employment and economic opportunity metrics in Andhra Pradesh districts.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'irdai_nonlife_india_mth_insurer'})
MATCH (target:Table {name: 'imf_dm_export'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The performance of India\'s non-life insurance sector (irdai_nonlife_india_mth_insurer) is influenced by the overall macroeconomic environment and GDP trends (imf_dm_export), as economic growth drives insurance demand.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'energy_nat_ann_petroleum_products_consumption'})
MATCH (target:Table {name: 'energy_wld_nat_mth_crude_petroleum_trade'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Annual national petroleum products consumption depends on the volume of crude and petroleum products imported and traded, as captured in the monthly/annual trade data. Imports are a primary source for domestic consumption.',
  strength: 0.9
}]->(target);

MATCH (source:Table {name: 'energy_nat_ann_petroleum_products_consumption'})
MATCH (target:Table {name: 'netc_india_mth_stats'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'National petroleum products consumption causally drives the volume and value of Fastag transactions, as higher fuel consumption is associated with increased vehicular movement and toll transactions across India.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'netc_india_mth_stats'})
MATCH (target:Table {name: 'ewb_state_mth_stats'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'National Fastag transaction volumes are influenced by the movement of goods, which is captured by state-wise E-way bill activity. Increased E-way bill generation (goods movement) leads to higher toll transactions.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'ewb_state_mth_stats'})
MATCH (target:Table {name: 'netc_india_mth_stats'})
MERGE (source)-[r:AGGREGATES {
  description: 'State-level E-way bill activity aggregates up to influence national Fastag statistics, as goods movement across states contributes to toll collections at the national level.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'tlm_state_yr_transport_access'})
MATCH (target:Table {name: 'ewb_state_mth_stats'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'State-level transport access (road and transport infrastructure) causally drives E-way bill activity, as better transport access facilitates higher goods movement and thus more E-way bills.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'hces_state_yr_assets'})
MATCH (target:Table {name: 'tlm_state_yr_transport_access'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Household asset ownership (e.g., vehicles, mobile phones, computers) at the state level influences transport access, as higher asset ownership is associated with greater demand and utilization of transport infrastructure.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'company_india_annual_type_mca'})
MATCH (target:Table {name: 'ins_nat_yr_fin_highlights'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The number and type of companies at the national level causally drive the size and operational scale of the insurance sector, as more companies increase demand for corporate insurance products and employee coverage.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'company_india_annual_type_mca'})
MATCH (target:Table {name: 'epfo_nat_ind_exempted_establishments_list'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'The distribution and number of companies at the national level influence the number and sectoral spread of EPFO-exempted establishments, as company characteristics determine eligibility and compliance.',
  strength: 0.75
}]->(target);

MATCH (source:Table {name: 'ewb_state_mth_stats'})
MATCH (target:Table {name: 'energy_nat_ann_petroleum_products_consumption'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'State-level E-way bill activity, reflecting goods movement, drives national petroleum product consumption, as increased logistics activity leads to higher fuel usage.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'env_state_yr_river_water_quality'})
MATCH (target:Table {name: 'tlm_state_yr_transport_access'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'State-level transport access can affect river water quality through increased vehicular emissions, runoff, and industrial activity associated with better transport infrastructure.',
  strength: 0.5
}]->(target);

MATCH (source:Table {name: 'ewb_state_mth_stats'})
MATCH (target:Table {name: 'ewb_state_mth_stats'})
MERGE (source)-[r:AGGREGATES {
  description: 'Monthly E-way bill data can be aggregated to quarterly or annual levels for the same state, reflecting hierarchical time aggregation.',
  strength: 1.0
}]->(target);

MATCH (source:Table {name: 'netc_india_mth_stats'})
MATCH (target:Table {name: 'netc_india_mth_stats'})
MERGE (source)-[r:AGGREGATES {
  description: 'Monthly Fastag statistics can be aggregated to quarterly or annual national statistics, reflecting hierarchical time aggregation.',
  strength: 1.0
}]->(target);

MATCH (source:Table {name: 'energy_wld_nat_mth_crude_petroleum_trade'})
MATCH (target:Table {name: 'energy_wld_nat_mth_crude_petroleum_trade'})
MERGE (source)-[r:AGGREGATES {
  description: 'Monthly crude petroleum trade data can be aggregated to annual trade data for the same products and trade types.',
  strength: 1.0
}]->(target);

MATCH (source:Table {name: 'energy_nat_mth_crude_oil_prod'})
MATCH (target:Table {name: 'energy_nat_mth_petroleum_prod'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Petroleum product production depends on crude oil production, as crude oil is the primary input for refineries producing petroleum products in India.',
  strength: 0.85
}]->(target);

MATCH (source:Table {name: 'energy_nat_mth_crude_oil_prod'})
MATCH (target:Table {name: 'iip_india_yr_sctg'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Crude oil production contributes to the Index of Industrial Production (IIP), particularly in the mining and manufacturing sectors, affecting annual IIP growth rates.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'energy_nat_mth_petroleum_prod'})
MATCH (target:Table {name: 'iip_india_yr_sctg'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Production of petroleum products is a key component of India\'s industrial output and directly influences the IIP, especially in the manufacturing sector.',
  strength: 0.75
}]->(target);

MATCH (source:Table {name: 'iip_india_yr_sctg'})
MATCH (target:Table {name: 'iip_india_yr_subcatg_view'})
MERGE (source)-[r:SUPERSET_OF {
  description: 'The sectoral IIP table is a superset of the subcategory view, as the latter provides more granular breakdowns within the same annual IIP data.',
  strength: 0.95
}]->(target);

MATCH (source:Table {name: 'iip_india_yr_subcatg_view'})
MATCH (target:Table {name: 'iip_india_yr_sctg'})
MERGE (source)-[r:AGGREGATES {
  description: 'Subcategory-level IIP indices aggregate up to the sectoral IIP indices in the annual IIP data.',
  strength: 0.95
}]->(target);

MATCH (source:Table {name: 'mca_nat_mth_companies_registered'})
MATCH (target:Table {name: 'mca_nat_mth_comp_closed'})
MERGE (source)-[r:RELATED_TO {
  description: 'The number of companies registered and closed are related as indicators of business dynamism and economic health in India; higher registrations may signal economic growth, while closures may indicate stress.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'iip_india_yr_sctg'})
MATCH (target:Table {name: 'mca_nat_mth_companies_registered'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Higher industrial production (IIP) can stimulate business formation, leading to an increase in new company registrations.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'mca_nat_mth_comp_closed'})
MATCH (target:Table {name: 'iip_india_yr_sctg'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'An increase in company closures may negatively impact industrial production, as fewer operating firms can reduce output.',
  strength: 0.5
}]->(target);

MATCH (source:Table {name: 'gst_statewise_fiscal_year_collection_view'})
MATCH (target:Table {name: 'iip_india_yr_sctg'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'GST collections reflect underlying economic activity, including industrial production; higher IIP generally leads to higher GST collections due to increased production and sales.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'gst_statewise_fiscal_year_collection_view'})
MATCH (target:Table {name: 'gst_statewise_fiscal_year_igst_settlement_view'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'IGST settlements to states are determined by GST collections, as collections drive the pool available for settlement.',
  strength: 0.9
}]->(target);

MATCH (source:Table {name: 'gst_statewise_fiscal_year_collection_view'})
MATCH (target:Table {name: 'gst_statewise_fiscal_year_refund_view'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'GST refunds are a function of GST collections; higher collections may lead to higher refunds due to input tax credits and export-related refunds.',
  strength: 0.85
}]->(target);

MATCH (source:Table {name: 'gst_statewise_fiscal_year_igst_settlement_view'})
MATCH (target:Table {name: 'gst_statewise_fiscal_year_collection_view'})
MERGE (source)-[r:DERIVES_FROM {
  description: 'IGST settlements are derived from the total IGST collected and the allocation rules between the Centre and states.',
  strength: 0.9
}]->(target);

MATCH (source:Table {name: 'gst_statewise_fiscal_year_refund_view'})
MATCH (target:Table {name: 'gst_statewise_fiscal_year_collection_view'})
MERGE (source)-[r:DERIVES_FROM {
  description: 'GST refund data is derived from the total GST collected, as refunds are processed against collected taxes.',
  strength: 0.85
}]->(target);

MATCH (source:Table {name: 'iip_india_mth_subcatg_view'})
MATCH (target:Table {name: 'iip_india_mth_catg_view'})
MERGE (source)-[r:AGGREGATES {
  description: 'Monthly IIP category data is aggregated from subcategory data, as subcategories roll up into broader categories.',
  strength: 0.95
}]->(target);

MATCH (source:Table {name: 'iip_india_mth_catg_view'})
MATCH (target:Table {name: 'iip_india_yr_catg_view'})
MERGE (source)-[r:AGGREGATES {
  description: 'Annual IIP category data is aggregated from monthly IIP category data.',
  strength: 0.97
}]->(target);

MATCH (source:Table {name: 'iip_india_mth_subcatg_view'})
MATCH (target:Table {name: 'iip_india_yr_catg_view'})
MERGE (source)-[r:AGGREGATES {
  description: 'Annual IIP category data ultimately aggregates from monthly subcategory data, via monthly category aggregation.',
  strength: 0.93
}]->(target);

MATCH (source:Table {name: 'iip_india_yr_catg_view'})
MATCH (target:Table {name: 'gdp_india_fy_item_estimates'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Annual GDP sectoral estimates depend on annual IIP trends, as industrial production is a key driver of GDP, especially in the secondary sector.',
  strength: 0.85
}]->(target);

MATCH (source:Table {name: 'gdp_india_fy_item_estimates'})
MATCH (target:Table {name: 'gdp_india_fy_expenditure_estimates_dtls_view'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Detailed GDP expenditure estimates are used to derive overall GDP estimates by expenditure approach.',
  strength: 0.95
}]->(target);

MATCH (source:Table {name: 'gdp_india_fy_expenditure_estimates_dtls_view'})
MATCH (target:Table {name: 'gdp_india_fy_item_estimates'})
MERGE (source)-[r:DERIVES_FROM {
  description: 'GDP by expenditure is derived from the sum of its expenditure components (consumption, investment, government spending, net exports).',
  strength: 0.97
}]->(target);

MATCH (source:Table {name: 'gdp_india_qtr_primsector_estimates_view'})
MATCH (target:Table {name: 'gdp_india_qtr_estimates_view'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Quarterly GDP estimates depend on the primary sector\'s quarterly performance, as it is a component of total GDP.',
  strength: 0.9
}]->(target);

MATCH (source:Table {name: 'gdp_india_qtr_secsector_estimates_view'})
MATCH (target:Table {name: 'gdp_india_qtr_estimates_view'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Quarterly GDP estimates depend on the secondary sector\'s quarterly performance, as it is a component of total GDP.',
  strength: 0.92
}]->(target);

MATCH (source:Table {name: 'gdp_india_qtr_tersector_estimates_view'})
MATCH (target:Table {name: 'gdp_india_qtr_estimates_view'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Quarterly GDP estimates depend on the tertiary sector\'s quarterly performance, as it is a component of total GDP.',
  strength: 0.92
}]->(target);

MATCH (source:Table {name: 'gdp_india_qtr_tersector_estimates_dtls_view'})
MATCH (target:Table {name: 'gdp_india_qtr_tersector_estimates_view'})
MERGE (source)-[r:AGGREGATES {
  description: 'Quarterly tertiary sector GDP summary aggregates from detailed breakdowns in the detailed view.',
  strength: 0.96
}]->(target);

MATCH (source:Table {name: 'gdp_india_qtr_estimates_view'})
MATCH (target:Table {name: 'gdp_india_fy_item_estimates'})
MERGE (source)-[r:AGGREGATES {
  description: 'Annual GDP estimates are aggregated from quarterly GDP estimates.',
  strength: 0.98
}]->(target);

MATCH (source:Table {name: 'iip_india_mth_catg_view'})
MATCH (target:Table {name: 'gdp_india_qtr_secsector_estimates_view'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Quarterly GDP for the secondary sector depends on monthly IIP (industrial production) trends, as manufacturing and industry are major components.',
  strength: 0.88
}]->(target);

MATCH (source:Table {name: 'gdp_state_fy_subindustry_actuals'})
MATCH (target:Table {name: 'gdp_state_fy_industry_actuals_view'})
MERGE (source)-[r:AGGREGATES {
  description: 'State-level industry GDP actuals are aggregated from more granular sub-industry data within each state and year.',
  strength: 1.0
}]->(target);

MATCH (source:Table {name: 'gdp_state_fy_industry_actuals_view'})
MATCH (target:Table {name: 'gdp_state_fy_actuals'})
MERGE (source)-[r:AGGREGATES {
  description: 'State-wise total GSVA and GSDP are aggregated from industry-level GDP actuals for each state and fiscal year.',
  strength: 1.0
}]->(target);

MATCH (source:Table {name: 'gdp_state_fy_subindustry_actuals'})
MATCH (target:Table {name: 'gdp_state_fy_subindustry_actuals_view'})
MERGE (source)-[r:SUPERSET_OF {
  description: 'The subindustry actuals table is a superset, while the subindustry actuals view filters out aggregate (total) industry rows.',
  strength: 0.95
}]->(target);

MATCH (source:Table {name: 'gdp_state_fy_actuals'})
MATCH (target:Table {name: 'gdp_india_qtr_primsector_estimates_dtls_view'})
MERGE (source)-[r:AGGREGATES {
  description: 'State-level annual GDP in the primary sector aggregates up to influence national quarterly primary sector GDP estimates.',
  strength: 0.9
}]->(target);

MATCH (source:Table {name: 'gdp_state_fy_actuals'})
MATCH (target:Table {name: 'gdp_india_qtr_secsector_estimates_dtls_view'})
MERGE (source)-[r:AGGREGATES {
  description: 'State-level annual GDP in the secondary sector aggregates up to influence national quarterly secondary sector GDP estimates.',
  strength: 0.9
}]->(target);

MATCH (source:Table {name: 'gdp_state_fy_actuals'})
MATCH (target:Table {name: 'gdp_india_qtr_expenditure_estimates_dtls_view'})
MERGE (source)-[r:AGGREGATES {
  description: 'State-level annual GDP aggregates up to national quarterly GDP expenditure estimates, as state output forms the basis for national accounts.',
  strength: 0.85
}]->(target);

MATCH (source:Table {name: 'gdp_india_qtr_primsector_estimates_dtls_view'})
MATCH (target:Table {name: 'gdp_india_qtr_expenditure_estimates_dtls_view'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'National quarterly GDP expenditure estimates depend on sectoral GDP estimates, including the primary sector, as part of the expenditure approach to GDP calculation.',
  strength: 0.85
}]->(target);

MATCH (source:Table {name: 'gdp_india_qtr_secsector_estimates_dtls_view'})
MATCH (target:Table {name: 'gdp_india_qtr_expenditure_estimates_dtls_view'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'National quarterly GDP expenditure estimates depend on sectoral GDP estimates, including the secondary sector, as part of the expenditure approach to GDP calculation.',
  strength: 0.85
}]->(target);

MATCH (source:Table {name: 'cpi_state_mth_subgrp_view'})
MATCH (target:Table {name: 'cpi_india_mth_subgrp_view'})
MERGE (source)-[r:AGGREGATES {
  description: 'All-India monthly CPI at the subgroup level is aggregated from state-level monthly CPI subgroup data.',
  strength: 1.0
}]->(target);

MATCH (source:Table {name: 'cpi_state_mth_subgrp_view'})
MATCH (target:Table {name: 'cpi_india_mth_grp_view'})
MERGE (source)-[r:AGGREGATES {
  description: 'All-India monthly CPI group-level data is aggregated from state-level monthly CPI subgroup data, filtered for group-level and national scope.',
  strength: 1.0
}]->(target);

MATCH (source:Table {name: 'cpi_india_mth_subgrp_view'})
MATCH (target:Table {name: 'cpi_india_mth_grp_view'})
MERGE (source)-[r:AGGREGATES {
  description: 'All-India monthly CPI group-level data is aggregated from more granular subgroup-level CPI data.',
  strength: 1.0
}]->(target);

MATCH (source:Table {name: 'cpi_india_mth_grp_view'})
MATCH (target:Table {name: 'gdp_india_qtr_expenditure_estimates_dtls_view'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'National CPI inflation influences components of GDP expenditure, such as private consumption (PFCE), as inflation affects real consumption and expenditure patterns.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'cpi_state_mth_subgrp_view'})
MATCH (target:Table {name: 'gdp_state_fy_actuals'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'State-level CPI inflation influences state-level GDP, particularly through its effect on real consumption and cost structures within the state economy.',
  strength: 0.65
}]->(target);

MATCH (source:Table {name: 'msme_state_ureg_recent'})
MATCH (target:Table {name: 'msme_india_mth_subgrp_bankcredit'})
MERGE (source)-[r:AGGREGATES {
  description: 'State-level MSME registrations aggregate up to influence national-level MSME bank credit trends, as more registered MSMEs at the state level increase demand for credit at the national level.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'msme_state_ureg_recent'})
MATCH (target:Table {name: 'gdp_india_fy_estimates_view'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Growth in state-level MSME registrations contributes to overall economic activity, thereby influencing India\'s GDP growth.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'msme_india_mth_subgrp_bankcredit'})
MATCH (target:Table {name: 'msme_india_mth_sector_bankcredit_view'})
MERGE (source)-[r:SUPERSET_OF {
  description: 'The subgroup-level MSME bank credit data is a superset that can be aggregated to sector-level MSME bank credit data.',
  strength: 0.9
}]->(target);

MATCH (source:Table {name: 'msme_india_mth_subgrp_bankcredit'})
MATCH (target:Table {name: 'msme_india_mth_grp_bankcredit_view'})
MERGE (source)-[r:SUPERSET_OF {
  description: 'Subgroup-level MSME bank credit data aggregates up to group-level MSME bank credit data.',
  strength: 0.9
}]->(target);

MATCH (source:Table {name: 'msme_india_mth_subgrp_bankcredit'})
MATCH (target:Table {name: 'msme_india_mth_subgrp_bankcredit_view'})
MERGE (source)-[r:DERIVES_FROM {
  description: 'The \'view\' table is a derived, possibly cleaned or filtered, version of the raw MSME monthly subgroup-level bank credit data.',
  strength: 1.0
}]->(target);

MATCH (source:Table {name: 'msme_india_mth_subgrp_bankcredit'})
MATCH (target:Table {name: 'gdp_india_fy_estimates_view'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Growth in MSME bank credit at the national level supports MSME sector expansion, which in turn contributes to GDP growth.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'msme_india_mth_sector_bankcredit_view'})
MATCH (target:Table {name: 'gdp_india_fy_estimates_view'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Sector-level MSME bank credit growth supports sectoral output, which is a component of national GDP.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'msme_india_mth_grp_bankcredit_view'})
MATCH (target:Table {name: 'gdp_india_fy_estimates_view'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Group-level MSME bank credit growth enables group-level MSME expansion, contributing to GDP.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'ores_minerals_exports_yearly'})
MATCH (target:Table {name: 'gdp_india_fy_estimates_view'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Mineral exports are a component of net exports in the GDP calculation, so changes in mineral exports causally influence India\'s GDP.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'asi_state_principal_characteristics'})
MATCH (target:Table {name: 'cumulative_capacity_state_month'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'State-level industrial output and characteristics (ASI) are influenced by the availability and growth of renewable energy capacity in the state, as energy is a key input for industrial production.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'asi_state_principal_characteristics'})
MATCH (target:Table {name: 'vehicle_registrations_state'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Growth in state-level industrial activity can drive demand for commercial vehicles, leading to higher vehicle registrations in the state.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'vehicle_registrations_state'})
MATCH (target:Table {name: 'asi_state_principal_characteristics'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Increased vehicle registrations (especially commercial vehicles) can enhance logistics and supply chain efficiency, supporting higher industrial output in the state.',
  strength: 0.5
}]->(target);

MATCH (source:Table {name: 'cumulative_capacity_state_month'})
MATCH (target:Table {name: 'asi_state_principal_characteristics'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Expansion of renewable energy capacity in a state can lower energy costs and improve industrial productivity, thereby positively impacting industrial characteristics.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'port_dwell_time_month'})
MATCH (target:Table {name: 'asi_state_principal_characteristics'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Lower port dwell times nationally indicate improved logistics efficiency, which can facilitate smoother movement of raw materials and finished goods, thus supporting higher industrial output at the state level.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'port_dwell_time_month'})
MATCH (target:Table {name: 'vehicle_registrations_state'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Improved port efficiency (lower dwell time) can stimulate demand for road transport and logistics, leading to increased vehicle registrations in states with major ports.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'cumulative_capacity_state_month'})
MATCH (target:Table {name: 'fish_production_yearly'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Growth in renewable energy (especially solar and wind) can impact fisheries by altering water usage patterns and coastal/riverine environments, influencing fish production at the state level.',
  strength: 0.4
}]->(target);

MATCH (source:Table {name: 'annual_mean_temperature'})
MATCH (target:Table {name: 'fish_production_yearly'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Annual mean temperature affects aquatic ecosystems and fish breeding cycles, thereby influencing state-level fish production.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'watersheds_in_india'})
MATCH (target:Table {name: 'fish_production_yearly'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Watershed and hydrological conditions at the national level determine water availability and quality, which are critical for fish production in various states.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'river_basin_catchment'})
MATCH (target:Table {name: 'fish_production_yearly'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'River basin catchment characteristics affect water flow, nutrient levels, and habitat availability, all of which causally impact state-level fish production.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'coastline_population_and_length'})
MATCH (target:Table {name: 'fish_production_yearly'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'States with longer coastlines and higher coastal populations tend to have greater marine fish production due to increased access to marine resources and labor.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'fish_production_yearly'})
MATCH (target:Table {name: 'faunal_diversity'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'State-level fish production influences aquatic faunal diversity, as fishing pressure and aquaculture practices can alter species composition and abundance.',
  strength: 0.5
}]->(target);

MATCH (source:Table {name: 'cumulative_capacity_state_month'})
MATCH (target:Table {name: 'coastline_population_and_length'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Development of renewable energy infrastructure (e.g., offshore wind, coastal solar) can affect coastal population distribution and resource management.',
  strength: 0.4
}]->(target);

MATCH (source:Table {name: 'fish_production_yearly'})
MATCH (target:Table {name: 'coastline_population_and_length'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'High fish production can support larger coastal populations by providing livelihoods and food security, influencing coastal demographic patterns.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'fish_production_yearly'})
MATCH (target:Table {name: 'asi_state_principal_characteristics'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Fish production contributes to the industrial sector (food processing, export), thus influencing state-level industrial characteristics.',
  strength: 0.5
}]->(target);

MATCH (source:Table {name: 'cumulative_capacity_state_month'})
MATCH (target:Table {name: 'asi_state_principal_characteristics'})
MERGE (source)-[r:AGGREGATES {
  description: 'Monthly renewable energy capacity data can be aggregated to annual figures for use in annual industrial analysis.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'wpr_state_age'})
MATCH (target:Table {name: 'lpfr_state_age'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Worker Population Ratio (WPR) at the state and age group level depends on Labour Participation Rate (LPFR), as only those participating in the labour force can be counted as workers.',
  strength: 0.85
}]->(target);

MATCH (source:Table {name: 'ur_state_age'})
MATCH (target:Table {name: 'lpfr_state_age'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Unemployment Rate (UR) at the state and age group level depends on Labour Participation Rate (LPFR), since UR is calculated as the proportion of unemployed among the labour force.',
  strength: 0.9
}]->(target);

MATCH (source:Table {name: 'ur_state_age'})
MATCH (target:Table {name: 'wpr_state_age'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Unemployment Rate (UR) is inversely related to Worker Population Ratio (WPR) at the same state and age group, as higher WPR generally indicates lower unemployment.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'cpi_iw_point_to_point_inflation'})
MATCH (target:Table {name: 'cpi_iw_centre_index'})
MERGE (source)-[r:DERIVES_FROM {
  description: 'CPI-IW point-to-point inflation is derived from the monthly centre-wise CPI-IW index values, as inflation is calculated from changes in the index.',
  strength: 0.95
}]->(target);

MATCH (source:Table {name: 'cpi_iw_point_to_point_inflation'})
MATCH (target:Table {name: 'ur_state_age'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Rising inflation (CPI-IW) can causally increase unemployment rates at the state level by eroding real wages and reducing labour demand.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'cpi_iw_point_to_point_inflation'})
MATCH (target:Table {name: 'wpr_state_age'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Higher inflation (CPI-IW) can reduce real incomes and discourage labour force participation, impacting the Worker Population Ratio at the state level.',
  strength: 0.65
}]->(target);

MATCH (source:Table {name: 'cpi_iw_point_to_point_inflation'})
MATCH (target:Table {name: 'lpfr_state_age'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Persistent inflation may discourage labour force participation, especially among vulnerable age groups, affecting LPFR at the state level.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'cpi_iw_centre_index'})
MATCH (target:Table {name: 'cpi_iw_point_to_point_inflation'})
MERGE (source)-[r:AGGREGATES {
  description: 'Monthly centre-wise CPI-IW index values are aggregated to compute the national point-to-point inflation rate.',
  strength: 0.95
}]->(target);

MATCH (source:Table {name: 'upi_dly_stats'})
MATCH (target:Table {name: 'upi_mth_stats'})
MERGE (source)-[r:AGGREGATES {
  description: 'Daily UPI transaction data is aggregated to produce monthly UPI statistics at the national level.',
  strength: 1.0
}]->(target);

MATCH (source:Table {name: 'upi_mth_stats'})
MATCH (target:Table {name: 'upi_mth_failures'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Monthly UPI transaction statistics depend on the number of successful and failed transactions as captured in the failures dataset.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'upi_mth_failures'})
MATCH (target:Table {name: 'upi_mth_stats'})
MERGE (source)-[r:DERIVES_FROM {
  description: 'UPI monthly failure rates are derived from the total volume and value of transactions recorded in the monthly statistics.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'construct_state_cement_indicators_view'})
MATCH (target:Table {name: 'wpr_state_age'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'State-level cement industry indicators reflect construction activity, which drives employment and thus influences the Worker Population Ratio (WPR) in construction-intensive states.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'construct_state_cement_indicators_view'})
MATCH (target:Table {name: 'lpfr_state_age'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Increased construction activity, as measured by cement indicators, can boost labour force participation in relevant age groups at the state level.',
  strength: 0.65
}]->(target);

MATCH (source:Table {name: 'construct_state_cement_indicators_view'})
MATCH (target:Table {name: 'ur_state_age'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Higher construction activity (cement indicators) can reduce unemployment rates at the state level by creating more jobs.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'state_fy_gdp_summary_view'})
MATCH (target:Table {name: 'india_fy_gdp_all_sectors_view'})
MERGE (source)-[r:AGGREGATES {
  description: 'India\'s annual GDP by sector aggregates state-level GSDP and GSVA data from each state, as provided in the state_fy_gdp_summary_view.',
  strength: 0.95
}]->(target);

MATCH (source:Table {name: 'state_fy_gdp_summary_view'})
MATCH (target:Table {name: 'gdp_india_fy_percapita_view'})
MERGE (source)-[r:AGGREGATES {
  description: 'National per capita GDP is derived from the sum of state GDPs and population estimates provided in the state_fy_gdp_summary_view.',
  strength: 0.9
}]->(target);

MATCH (source:Table {name: 'india_fy_gdp_all_sectors_view'})
MATCH (target:Table {name: 'gdp_india_fy_percapita_view'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Per capita GDP depends on total GDP values from india_fy_gdp_all_sectors_view and population data.',
  strength: 0.85
}]->(target);

MATCH (source:Table {name: 'india_fy_gdp_expenditure_component_view'})
MATCH (target:Table {name: 'india_fy_gdp_all_sectors_view'})
MERGE (source)-[r:DERIVES_FROM {
  description: 'GDP by sector (production approach) in india_fy_gdp_all_sectors_view is derived from the sum of expenditure components in india_fy_gdp_expenditure_component_view.',
  strength: 0.9
}]->(target);

MATCH (source:Table {name: 'india_fy_gdp_others_view'})
MATCH (target:Table {name: 'india_fy_gdp_all_sectors_view'})
MERGE (source)-[r:SUPERSET_OF {
  description: 'india_fy_gdp_all_sectors_view is a superset, incorporating data from india_fy_gdp_others_view as additional sectoral or component breakdowns.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'fdi_state_qtr_view'})
MATCH (target:Table {name: 'state_fy_gdp_summary_view'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'State-level FDI inflows (quarterly) can causally impact annual state GDP by contributing to investment and economic activity.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'fdi_state_qtr_view'})
MATCH (target:Table {name: 'india_fy_gdp_all_sectors_view'})
MERGE (source)-[r:AGGREGATES {
  description: 'Aggregate FDI inflows at the state level contribute to national investment and thus to India\'s GDP at the national level.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'cpi_state_mth_grp_view'})
MATCH (target:Table {name: 'state_fy_gdp_summary_view'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'State-level inflation (CPI) influences real GDP growth in states by affecting consumption and cost structures.',
  strength: 0.75
}]->(target);

MATCH (source:Table {name: 'wpi_india_mth_catg'})
MATCH (target:Table {name: 'india_fy_gdp_all_sectors_view'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'National WPI (monthly) affects nominal and real GDP by influencing input costs, producer prices, and thus sectoral value added.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'whole_sale_price_index_cal'})
MATCH (target:Table {name: 'wpi_india_mth_catg'})
MERGE (source)-[r:SUPERSET_OF {
  description: 'wpi_india_mth_catg is a superset, providing more detailed breakdowns of wholesale price index data than whole_sale_price_index_cal.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'cws_industry_distribution_state'})
MATCH (target:Table {name: 'state_fy_gdp_summary_view'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Employment distribution by industry in each state causally affects sectoral output and thus state GDP.',
  strength: 0.75
}]->(target);

MATCH (source:Table {name: 'cpi_state_mth_grp_view'})
MATCH (target:Table {name: 'cws_industry_distribution_state'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'State-level inflation (CPI) can influence employment distribution across sectors by affecting real wages and sectoral demand.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'wpi_india_mth_catg'})
MATCH (target:Table {name: 'cpi_state_mth_grp_view'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Changes in wholesale prices (WPI) at the national level can feed into consumer prices (CPI) at the state level through supply chains.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'rain_district_mth_view'})
MATCH (target:Table {name: 'rain_district_yr_view'})
MERGE (source)-[r:AGGREGATES {
  description: 'Yearly district rainfall is aggregated from monthly district rainfall data.',
  strength: 1.0
}]->(target);

MATCH (source:Table {name: 'rain_district_yr_view'})
MATCH (target:Table {name: 'rain_india_yr_view'})
MERGE (source)-[r:AGGREGATES {
  description: 'All-India yearly rainfall is aggregated from yearly district-level rainfall data.',
  strength: 1.0
}]->(target);

MATCH (source:Table {name: 'rain_district_mth_view'})
MATCH (target:Table {name: 'rain_india_mth_view'})
MERGE (source)-[r:AGGREGATES {
  description: 'All-India monthly rainfall is aggregated from monthly district-level rainfall data.',
  strength: 1.0
}]->(target);

MATCH (source:Table {name: 'rain_india_mth_view'})
MATCH (target:Table {name: 'rain_india_yr_view'})
MERGE (source)-[r:AGGREGATES {
  description: 'Yearly all-India rainfall is aggregated from monthly all-India rainfall data.',
  strength: 1.0
}]->(target);

MATCH (source:Table {name: 'rain_india_yr_view'})
MATCH (target:Table {name: 'production_of_major_crops'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Annual rainfall at the all-India level causally influences national agricultural output, as crop production depends on rainfall patterns.',
  strength: 0.8
}]->(target);

MATCH (source:Table {name: 'production_of_major_crops'})
MATCH (target:Table {name: 'state_fy_percapita_gsdp_summary_view'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'Agricultural production at the national level influences state-level GSDP, especially for agriculturally dominant states, as agriculture is a component of GSDP.',
  strength: 0.7
}]->(target);

MATCH (source:Table {name: 'state_fy_percapita_gsdp_summary_view'})
MATCH (target:Table {name: 'cpi_mth_item'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'State-level per capita GSDP (income) influences national CPI via aggregate demand and consumption patterns.',
  strength: 0.6
}]->(target);

MATCH (source:Table {name: 'cpi_mth_item'})
MATCH (target:Table {name: 'cpi_iw_retail_price_index'})
MERGE (source)-[r:SUPERSET_OF {
  description: 'The all-India CPI at item level is a superset of the CPI for industrial workers, as the latter is a specific sub-index of the broader CPI.',
  strength: 0.9
}]->(target);

MATCH (source:Table {name: 'cpi_mth_item'})
MATCH (target:Table {name: 'production_of_major_crops'})
MERGE (source)-[r:DEPENDS_ON {
  description: 'CPI (inflation) influences agricultural production decisions through price signals, affecting what and how much is produced.',
  strength: 0.5
}]->(target);

