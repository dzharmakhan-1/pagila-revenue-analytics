## Architecture Overview

The solution follows an ELT architecture:

1. Source data extracted from Pagila OLTP tables
2. Raw data stored in a staging schema
3. Transformations performed using SQL
4. Star schema created for analytical querying

This approach was chosen due to the relational nature of
the source data and the analytical requirements of the task.
