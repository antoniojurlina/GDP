# GDP

A short look into how GDP changed over time (specifically 2001-2017) in the contiguous United States. Data was obtained from the Bureau of Economic Analysis, U.S. Department of Commerce. https://apps.bea.gov/itable/iTable.cfm?ReqID=70&step=1

Data is split into two folders CAGDP2 and CAINC1, which were downloaded from the BEA website. All data is in .csv format. 

The import script focuses on importing the relevant data (industry totals for each county), adapts it for further analysis and stores it as an .RData file.

The mapping script uses the .RData file (together with a file from the maps package that gives coordinates for all state borders) to produce maps across years and a gif (which takes a long time to compute, be wary). 
