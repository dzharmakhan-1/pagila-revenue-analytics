## Design Decisions & Improvements

### Grain Definition
The fact table is defined at the payment transaction level.
This ensures accurate revenue aggregation and aligns with
how revenue is realized in the source system.

### Schema Choice
A star schema was selected over a snowflake schema to
minimize joins and improve BI performance.

### Degenerate Dimensions
The rental_id is stored in the fact table to allow traceability
without adding unnecessary dimensions.

### Data Quality Controls
- Revenue amounts validated to be greater than zero
- Referential integrity enforced via foreign keys
- Row counts validated between staging and fact tables

### Future Enhancements
In a production environment, this pipeline could be extended
using cloud-based orchestration tools such as AWS Glue.
