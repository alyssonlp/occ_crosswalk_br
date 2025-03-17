# Crosswalks for the Brazilian Occupation Classification Systems

This repository contains instruction for the crosswalk of occupational classification used by PNAD and PNADC.
There are three systems used since 2001. The first, which started in the 1990's and continued up 2002,
is based in the 1991 Census codification. The second, CBO-Dom, is used by PNAD up to 2015. Finally, PNADC uses
the COD.

The crosswalk between COD and CBO-Dom uses information from the 2010 Brazilian Census and is described in Firpo, S. et al.
(2021) The changing nature of work and inequality in Brazil (2003–19): A descriptive analysis. 
WIDER Working Paper 2021/162. Helsinki: UNU-WIDER. Available [here](https://www.wider.unu.edu/publication/changing-nature-work-and-inequality-brazil-2003%E2%80%9319).
Data from the 2010 Census is available [here](https://insper-my.sharepoint.com/:f:/g/personal/alyssonlp1_insper_edu_br1/EtPnD5Ud6vtLl4OqaZAf7B8Ba92R9QGQ5LLLcYTmLyaEBA?e=e2GASs).
The code that produces this crosswalk is `code/create_crosswalk_cbo_cod.R`. 
The crosswalks are available in [data/crosswalks](data/crosswalks).

The crosswalk between the classification from the 1990s and the CBO-Dom is made available by IBGE [here](https://concla.ibge.gov.br/classificacoes/correspondencias/ocupacao-e-posicao-na-ocupacao.html), but is available in this repository in excel format as CBO-DomxCenso91.xls.

