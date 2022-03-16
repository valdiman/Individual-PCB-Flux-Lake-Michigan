## README file

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.

This README file was generated on March 02 2022 by Andres Martinez (ORCID: 0000-0002-0572-1494)

This README file describes R code to calculate the air-water flux of individual PCB congeners from southern Lake Michigan from air and water active samples from September 2010. It includes a Monte Carlo simulation. Net, absorption and volatilization fluxes can be calculated. (i) For net fluxes, keep both air and water concentrations, (ii) for absoprtion, water concentration should be 0 and (iii) for volatilization, air concentration should be 0. This change can be perform in line 245. The code is written to calculate per deployment time, thus concentrations and meteorological data need to be selected. The data can be downloaded from PANGAEA (link), using the R package pangaear (https://cran.microsoft.com/snapshot/2022-01-01/web/packages/pangaear/pangaear.pdf).

This work was supported by the National Institutes of Environmental Health Sciences (NIEHS) grant #P42ES013661 and the U.S. Environmental Protection Agency’s Great Lakes National Program Office (Grant No. GL-00E00515-0). The funding sponsor did not have any role in study design; in collection, analysis, and/or interpretation of data; in creation of the dataset; and/or in the decision to submit this data for publication or deposit it in a repository.

# Citations

Citation for the data:

Boesen AC, Martinez A, Hornbuckle KC (2019). PCB congener data of gas-phase, dissolved water, meteorological conditions, and air-water PCB fluxes in southwestern Lake Michigan, 2010. PANGAEA, https://doi.org/10.1594/PANGAEA.897545

Publication citation:

Boesen AC, Martinez A, Hornbuckle KC (2020). Air-water PCB fluxes from southwestern Lake Michigan revisited. Environmental Science and Pollution Research 27, pages8826–8834 (2020), https://link.springer.com/article/10.1007/s11356-019-05159-1


# Software installation

This section of the ReadMe file provides short instructions on how to download and install "R Studio".  "R Studio" is an open source (no product license required) integrated development environment (IDE) for "R" and completely free to use.  To install "R Studio" follow the instructions below:

1. Visit the following web address: https://www.rstudio.com/products/rstudio/download/
2. Click the "download" button beneath RStudio Desktop
3. Click the button beneath "Download RStudio Desktop".  This will download the correct installation file based on the operating system detected.
4. Run the installation file and follow on-screen instructions.


