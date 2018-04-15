Create DataFrames and DataArrays
df = DataFrame(A = 1:4, B = randn(4))
df = DataFrame(rand(20,5)) | 5 columns and 20 rows of random floats
@data(my_list) | Create a dataarray from an iterable my_list and accepts NA 
df = DataFrame() ;df[:A] = 1:5 ;df[:B] = ["M", "F", "F", "M", "F"]

Importing Data
df = readtable("dataset.csv") | From a CSV file
df = readtable("dataset.tsv") | From a delimited text file (like TSV)
df = readtable("dataset.txt", separator = '\t') | With a tab delimiter
df = DataFrame(load("data.xlsx", "Sheet1")) | From an Excel file using FileIO,ExcelFiles
df = readxl(DataFrame, "Filename.xlsx", "Sheet1!A1:C4") | From an Excel file using DataFrames,ExcelReaders
df = readxlsheet(DataFrame, "Filename.xlsx", "Sheet1") |  From a whole sheet of Excel file using DataFrames,ExcelReaders
#Read from a SQL table/database
db = SQLite.connect("file.sqlite") # connection_object
df = SQLite.query(db,"SELECT * FROM tables") | Read from a SQL table/database using SQLite and DataFrames
df = json2df(json_string) | Read from a JSON formatted string, URL or file using DataFramesIO
df_html = readtable(Requests.get_streaming("http://example.com")) | Parses an html URL, string or file and extracts tables to a list of dataframes
DataFrame(dict) | From a dict, keys for columns names, values for data as lists

Exporting Data
writetable("output.csv", df) | Write to a CSV file
writetable("output.dat", df, separator = ',', header = false) | Write to a CSV file
df2json(json) | Write to a file in JSON format using DataFramesIO and DataFrames



Viewing/Inspecting Data
head(df) | First 5 rows of the DataFrame
tail(df) | Last 5 rows of the DataFrame
head(df,n) | First n rows of the DataFrame
tail(df,n) | Last n rows of the DataFrame
size(df) | Number of rows and columns
length(df) | length of columns
nrow(df) | Number of rows
ncol(df) | Number of columns
showcols(df) | Show columns,missing,Datatype 
describe(df) | Summary statistics for numerical columns
unique!(df) | View unique 
values(df) or DataFrames.columns(df) | Return values or columns and their values.

Selection of Columns
df[:columnname] or df["columnname"] | Returns column with label col as Series
df[1] | Select First column by number 
df[[:col1, :col2]] or df[[Symbol("col1"),Symbol("col2")]] | Returns columns as a new DataFrame
df[:, [:col1,:col2]] | Select specific columns of a dataframe and all rows of each column.
df[:, [1,3]] | Select specific columns of a dataframe
df[:, [Symbol("col1"),Symbol("col2")]] | Select specific columns of a dataframe

s.iloc[0] | Selection by position
# Python => s.loc['index_one'] | Selection by index
df[1:3,[:col1,:col2]] | Selecting a subset of rows by index and an (ordered) subset of columns by name

#Python => df.iloc[0,:] | First row
df[1,:] | Select First row of all columns

# Python=> df.iloc[0,0] | First element of first column
df[1, 1] | First element of first column

# Python=> df.iloc[2:10] | Second row 2 to row 10 with all columns
df[2:10,:] | Second row 2 to row 10 with all columns

df[[1,2],:] Select row1 and row2 with all columns
# Python => df.loc[2]
df[2,:] | Select by index 2 all columns 



Data Cleaning and Wrangling
names(df)  | Names of columns
names!(df,['a','b','c']) | Rename columns
rename!(df,:oldname,:newname) | Rename single column ,by modifying the original
showcols(df) | Shows the datatype,missing value of entire dataframe 
isna.(s) | Checks for Missing NA in Arrray,Returns Boolean Arrray
isna.(df[:columname]) | Checks for null Values of a column, Returns Boolean Arrray
find(isna.(df[:,:columnname])) | Returns the individual rows of a column with missing values/na
.!isna.(df[:columnname]) | Returns a dataframe that contains no rows with missing values.
.!isna.() | Opposite of isna.()

dropna(df) | Drop all rows that contain null values
completecases!(df) | Drop all columns that contain null values like df.dropna(how='all')
df[isna.(df[:col1]),:col1] = x | Replace all null values with x
df[isna.(df[:col1]),:col1] = mean(df[:col1]) | Replace all null values with mean but mean must have no NA so use describe(df) and then its mean.
eltypes(df) | List Datatype of elements
convert(Array, df[:col1])| Convert the datatype of the series to float
indexmap(df[:A]) | Map the index


Filter, Sort, Groupby,Split Combine
df[df[:col1] .> 0.9] | Rows where the column col is greater than 0.9
df[(df[:col1] .> 0.2) & (df[:col1] .< 0.5)] | Rows where 0.5 > col > 0.2
sort!(df, rev = true) | Sort values by col1 in ascending order
sort!(df, cols = [:col1, :col2]) | Sort by col2 and col2
sort!(df,col1,rev=false) | Sort values by col1 in descending order
sort!(df, cols = [order(:col1, by = uppercase),order(:col2, rev = true)]) | Sort values by col1 by uppercase then col2 in descending order
sort!(df, cols = [order(:col1, rev = true),order(:col2, rev = false)]) | Sort values by col1 in ascending order then col2 in descending order

groupby(DataFrame,[:column]) | Returns a groupby object for values from one column
groupby(DataFrame,[:col1,:col2]) | Returns groupby object for values from multiple columns
aggregate(df,:col1,[size,length]) | Applying Aggregate of Functions to DataFrame with aggregate()
stack(df, [:col1, :col2; ]) | Reshape from wide to long format
melt(df, [:col1, :col2]) | Reshape from wide to long format ,prefers specification of the id columns
unstack(df, :id, :value) | Reshape from long to wide format
by(df, :columnname, df -> mean(df[:columnname2])) | Apply the function mean() across each column
colwise(mean, df) | Apply functions eg. mean to all columns


Join and Combine or Concat
# Append  and Horizontal Concat
append!(df1,df2) | Add the rows of df1 to the end of df2 (columns should be identical)
hcat(df,df[:columnname]) | Add the columns in df1 to the end of df2 (rows should be identical)
join(df1,df2,on=:ID,kind=:left) | SQL-style join the columns in df1 with the columns on df2 where the rows for col have identical values. how can be one of 'left', 'right', 'outer', 'inner','cross'
join(df1,df2,on=:ID,kind=:anti) | :anti => return rows that do not match with the keys

Statistics
describe(df) | Summary statistics for numerical columns
mean(df) | Returns the mean of all columns
mean(df[:col1]) | Returns the mean of columns 1
colwise(mean, df) | Apply functions mean to all columns
cor(df[:col1]) | Returns the correlation of a column in a DataFrame
counts(df[:col1]) | Returns the number of non-null values in a column of a DataFrame
maximum(df[:col1]) | Returns the highest value in column1
minimum(df[:col1]) | Returns the lowest value in column1
median(df[:col1]) | Returns the median of a column
mode(df[:col1]) | Returns the mode of a column
std(df[:col1]) | Returns the standard deviation of column1



# By Jesse JCharis
# Jesus Saves @ JCharisTech

# Inspired By DataQuest and J-Secur1ty