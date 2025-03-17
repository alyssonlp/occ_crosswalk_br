remove(list = ls())
gc()

library(data.table)
library(questionr)
library(foreign)
library(dplyr)

# Set user
user = "Alysson_cpp"

if (user == "Alysson_cpp") {
  data_folder <- "D:/bases_dados/censo/2010/dados_csv2010"
  working_folder <-  "C:/Users/alyssonlp1/Documents/@github/occ_crosswalk_br"
}

varlist <- c("v6461", "v6462", "v6471", "peso_amostral")  

df <- fread(file.path(data_folder, "microdados_pessoa_2010.csv"), 
            select = varlist)

# V6461 - COD / V6462 - CBO
#table_occ <- questionr::wtd.table(df$v6462, df$v6461, weights = df$peso_amostral, na.show = T)
table_occ_df <-
  as.data.table(questionr::wtd.table(df$v6462, df$v6461, 
                                     weights = df$peso_amostral, na.show = T))

length_occ_00 <- length(unique(df$v6462))
length_occ_10 <- length(unique(df$v6461))

table_occ_df <- table_occ_df[N >0,]

length_occ_00_df <- length(unique(table_occ_df$V1))
length_occ_10_df <- length(unique(table_occ_df$V2))

table_occ_df[, n_v1 := .N, by = c("V2")]
table_occ_df[, max_v1 := max(N), by = c("V2")]
table_occ_df[, sh_v1 := N/sum(N), by = c("V2")]

table(table_occ_df[, n_v1])
summary(table_occ_df[N == max_v1, sh_v1])
quantile(table_occ_df[N == max_v1, sh_v1], probs = c(0.01, 0.05, 0.1, 0.15, 0.20, 0.25))

crosswalk_cbo_cod <- table_occ_df[N == max_v1]

colnames(crosswalk_cbo_cod) <- c("CBO", "COD", "N", "n_occ_cbo", "size_most_common", "sh_most_common")

crosswalk_cbo_cod_export <- crosswalk_cbo_cod[is.na(COD) == F, .(CBO, COD)]
colnames(crosswalk_cbo_cod_export) <- c("cbo_dom", "occ_pnadc")

crosswalk_cbo_cod_export <- 
  crosswalk_cbo_cod_export %>% 
  mutate(cbo_dom = as.numeric(cbo_dom), occ_pnadc = as.numeric(occ_pnadc))

fwrite(crosswalk_cbo_cod_export, 
          file = file.path(working_folder, "data", "crosswalks", "crosswalk_cbo_cod.csv"))

write.dta(crosswalk_cbo_cod_export, 
          file = file.path(working_folder, "data", "crosswalks", "crosswalk_cbo_cod.dta"))

# Using industry info:
table_occ_ind <- df %>% 
  group_by(v6461, v6471, v6462) %>%
  summarise(N = sum(peso_amostral))

table_occ_ind <- as.data.table(table_occ_ind)
table_occ_ind[, n_cbo := .N, by = c("v6461", "v6471")]
table_occ_ind[, max_cbo := max(N), by = c("v6461", "v6471")]
table_occ_ind[, sh_cbo := N/sum(N), by = c("v6461", "v6471")]

table(table_occ_ind[, n_cbo])
summary(table_occ_ind[N == max_cbo, sh_cbo])
quantile(table_occ_ind[N == max_cbo, sh_cbo], probs = c(0.01, 0.05, 0.1, 0.15, 0.20, 0.25))

crosswalk_cbo_cod_cnae <- table_occ_ind[N == max_cbo]

crosswalk_cbo_cod_cnae_export <- 
  crosswalk_cbo_cod_cnae[!is.na(v6461), .(v6461, v6471, v6462)]

colnames(crosswalk_cbo_cod_cnae_export) <- c("occ_pnadc", "ind_pnadc", "cbo_dom")

crosswalk_cbo_cod_cnae_export <- 
  crosswalk_cbo_cod_cnae_export %>% 
  mutate(cbo_dom = as.numeric(cbo_dom), 
         occ_pnadc = as.numeric(occ_pnadc),
         ind_pnadc = as.numeric(ind_pnadc))

fwrite(crosswalk_cbo_cod_cnae_export, 
       file = file.path(working_folder, "data", "crosswalks", "crosswalk_cbo_cod_cnae.csv"))

write.dta(crosswalk_cbo_cod_cnae_export, 
          file = file.path(working_folder, "data", "crosswalks", "crosswalk_cbo_cod_cnae.dta"))
