
# Project Goal

In this project, raw Netflix data that was not ready for analysis was cleaned, separated, and transformed into a structure that can be easily queried using SQL. The goal was to make fields that had multiple values, were inconsistent, or unorganized more clear, tidy, and suitable for analysis.

------------------------------

📌 Initial Problems:

At the start, the dataset had the following issues:

    * One column contained multiple pieces of information (actors, genres, countries, directors)
    * Date fields were in different formats
    * Some data was in the wrong columns
    * Queries were long and complicated to write

📌 Actions Taken:

To fix these problems, the following steps were applied:

    * Columns with multiple values were split into separate tables
    * Date fields were converted into a standard format that can be used for analysis
    * Missing and NULL values were checked and corrected
    * Data in the wrong columns was fixed

✨ Results
After these steps:

    * Data was separated and became more organized
    * Splitting multiple values made queries shorter and easier to read
