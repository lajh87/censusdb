
# census

<!-- badges: start -->
<!-- badges: end -->

The goal of census is to analyse the impact of military bases on the local economy

## Data

Data are saved in a postgresql database called `census`.

The postgis extension is enabled with

```
CREATE EXTENSION postgis;
```

See https://postgis.net/workshops/postgis-intro/creating_db.html


2001 output areas census data
https://www.scotlandscensus.gov.uk/documents/2001-census-table-data-output-area/

Scottish output area classifications are available for 2001 and 2011 from

https://borders.ukdataservice.ac.uk/bds.html

Census flows are from
https://beta.ukdataservice.ac.uk/datacatalogue/studies/study?id=7713
https://wicid.ukdataservice.ac.uk/

ONS Postcode Lookup Table from
https://geoportal.statistics.gov.uk/datasets/3700342d3d184b0d92eae99a78d9c7a3/about

2011 and 2021 Census Boundaries are from
https://ukdataservice.ac.uk/learning-hub/census/other-information/census-boundary-data/
https://borders.ukdataservice.ac.uk/easy_download.html




