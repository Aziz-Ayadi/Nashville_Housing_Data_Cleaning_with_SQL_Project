# Nashville Housing Data Cleaning with SQL : Project Overview

It's a pure SQL project that tends to manage the data cleaning process of a dataset about Nashville Housing. This process included several parts :

* Converted sales date column so that it became of type date.
* Filled out null and blank values of property address variable with the appropriate values.
* Broke out property address feature into individual columns (address & city).
* Broke out owner address feature into individual columns (address, city & state).
* Standardized the format of Sold As Vacant variable in order to hold only two options (Yes or No).
* Removed duplicate rows using a CTE.
* Dropped useless columns.
