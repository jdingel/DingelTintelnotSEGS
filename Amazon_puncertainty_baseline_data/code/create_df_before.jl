import Pkg
Pkg.activate("../input/Project.toml")
using DataFrames, CSV, StatFiles

df_before = DataFrame(load("../input/nyc2010_lodes_wzero_wdelta.dta"))
df_before = sort(df_before,[:j, :i])
df_before = select!(df_before, Not([:impute, :delta, :log_delta])) #drop unnecessary columns

#export df_before to csv
CSV.write("../temp/df_before.csv", df_before)