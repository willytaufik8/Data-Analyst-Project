# Sales Performance Dashboard

A data analytics project for monitoring sales performance through SQL data extraction, transactional data integration, sales metric calculations, and interactive visualization in Microsoft Excel.

The dataset used in this project is **ClassicModels**, a sales dataset containing vehicle models and related collectible products. The analysis results are summarized in an Excel workbook containing integrated transaction data, PivotTables, performance metrics, and charts.

## Project Objectives

This project was created to answer the following business questions:

- What are the total sales, cost, profit, and profit margin?
- Which products and product lines have the highest sales volume?
- How do sales and profit trends change by month and year?
- Which countries contribute the most profit?
- Which customers have the highest number of purchases/orders?
- What business opportunities and actions can be identified from the sales patterns?

## Data Flow

```text
ClassicModels Database
        |
        v
Data.sql
  (database structure and source data)
        |
        v
Ekspor SQL.sql
  (JOINs + metric calculations)
        |
        v
Excel Workbook
  (Project + PivotTables + charts)
        |
        v
Sales Performance Dashboard / Report
```

The query in `Ekspor SQL.sql` combines the following tables:

- `customers` for customer identity and country
- `orders` for order dates and order numbers
- `orderdetails` for ordered quantities and selling prices per item
- `products` for product names, product lines, and buying prices

The query produces the following calculated columns:

- `Sales = priceEach × quantityOrdered`
- `Cost = buyPrice × quantityOrdered`
- `Profit = Sales − Cost`
- `purchaseNumber`, calculated with `DENSE_RANK()` to assign each customer's purchase sequence based on the order date

## Repository Contents

| File | Description |
|---|---|
| [`Data.sql`](Data.sql) | SQL dump of the `classicmodels` database, including table structures and source data. |
| [`Ekspor SQL.sql`](Ekspor%20SQL.sql) | SQL query for extracting and transforming the transactional data for analysis. |
| [`Dashboard Project 2.0.xlsx`](Dashboard%20Project%202.0.xlsx) | Excel workbook containing the Project dataset, PivotTables, metrics, and visualizations. |
| [`Personal Project By Taufik Willy H..pdf`](Personal%20Project%20By%20Taufik%20Willy%20H..pdf) | Presentation report containing the analysis results and business recommendations. |

## Excel Workbook Structure

The `Dashboard Project 2.0.xlsx` workbook contains three worksheets:

- **Pivot**: summary metrics, product line analysis, top products, monthly and yearly sales, profit by country, monthly profit, and top buyers.
- **Project**: the transaction-level dataset produced from the SQL query and prepared for analysis.
- **Dashboard**: the worksheet provided for the dashboard view.

## Data Dictionary: `Project` Worksheet

The `Project` worksheet uses one row for one **product detail within an order**. Therefore, a single `orderNumber` can appear on multiple rows when an order contains multiple products.

| Variable | Type/Format | Description |
|---|---|---|
| `orderDate` | Date | The date when the order was placed. In Excel, the date may be stored internally as an Excel serial date. Used for monthly and yearly trend analysis. |
| `orderNumber` | Integer | The unique order number. One order can contain multiple product-detail rows. |
| `customerNumber` | Integer | The unique ID of the customer who placed the order. |
| `customerName` | Text | The name of the customer company or buyer. |
| `country` | Text | The country where the customer is located. Used for geographic analysis and profit-by-country analysis. |
| `productLine` | Text/Category | The product category or product line, such as `Classic Cars`, `Vintage Cars`, `Motorcycles`, `Planes`, `Ships`, `Trains`, and `Trucks and Buses`. |
| `productName` | Text | The specific name of the product sold. |
| `quantityOrdered` | Integer | The number of units ordered on the transaction-detail row. Can be summed to calculate total units sold. |
| `priceEach` | Decimal | The selling price per unit at the time of the transaction. This value comes from the order detail and may vary between transactions. |
| `buyPrice` | Decimal | The buying price or unit cost of the product. Used to calculate cost. |
| `Sales` | Decimal | The sales value for the transaction-detail row. Formula: `priceEach × quantityOrdered`. |
| `Cost` | Decimal | The total product cost for the transaction-detail row. Formula: `buyPrice × quantityOrdered`. |
| `Profit` | Decimal | The gross profit for the transaction-detail row. Formula: `Sales − Cost`. |
| `purchaseNumber` | Integer | The customer's purchase sequence based on `orderDate`, calculated with `DENSE_RANK()` and partitioned by `customerNumber`. The same value can appear on multiple product rows from the same order/date. |

### Variable Usage Notes

- `Sales`, `Cost`, and `Profit` are metrics at the **order-detail level**, not unique order-level values.
- Use `SUM()` on the relevant column to calculate total sales or profit.
- To calculate the number of orders, use `COUNT(DISTINCT orderNumber)` rather than counting worksheet rows.
- To calculate the number of customers, use `COUNT(DISTINCT customerNumber)`.
- `purchaseNumber` should not be counted as the number of orders because it represents a customer's purchase ranking. To calculate orders per customer, use `COUNT(DISTINCT orderNumber)`.
- The currency values follow the source dataset and are presented in US dollars in the report.

## Project Dataset Summary

Based on the `Project` worksheet in the workbook:

- Transaction period: **January 6, 2003 – May 31, 2005**
- **2,996** transaction-detail rows
- **326** unique orders
- **98** unique customers
- **109** unique products
- **21** countries
- **105,516** units sold
- Total sales: approximately **$9.604 million**
- Total cost: approximately **$5.778 million**
- Total profit: approximately **$3.826 million**
- Profit margin: approximately **39.84%**

## Key Insights

The following insights are based on the PivotTables and report included in the repository:

1. **Financial performance**
   - Total sales were approximately `$9.604M`, while total profit was approximately `$3.826M`.
   - The overall profit margin was approximately `39.84%`.

2. **Best-selling products**
   - `1992 Ferrari 360 Spider red` was the best-selling product by units, with **1,808 units sold**.
   - `1937 Lincoln Berline` ranked second, with **1,111 units sold**.
   - `Classic Cars` was the product line with the largest share of units sold, followed by `Vintage Cars`.

3. **Profit by country**
   - **USA** was the largest contributor to profit, generating approximately `$1.309M`.
   - **Spain** and **France** were the next largest contributors.

4. **Seasonality**
   - Sales increased significantly during **October–November**.
   - November was the highest-sales month in the workbook summary.
   - The June–September period was relatively lower than the year-end peak.

5. **Key customers**
   - In the PivotTable, `Euro+ Shopping Channel` had the highest `Count of purchaseNumber`, with **259 transaction-detail/purchase rows**.
   - `Mini Gifts Distributors Ltd,` ranked second, with **180 transaction-detail/purchase rows**.
   - These figures are not unique order counts. In the `Project` worksheet, the two customers had **26** and **17** unique `orderNumber` values, respectively.

## Business Recommendations

Based on these patterns, the following actions can be considered:

- Prepare inventory earlier to reduce the risk of stockouts before the October–November peak season.
- Offer loyalty incentives, volume-based rebates, or customized contracts to high-volume customers.
- Evaluate marketing budget allocation based on each country's profit contribution, with particular attention to the USA, Spain, and France.
- Use the dashboard to monitor changes in sales, profit, product lines, and customer performance regularly.

These recommendations are based on descriptive analysis of historical data. Actual business decisions should also consider inventory levels, operational capacity, marketing costs, and other relevant business factors.

## How to Run the Query

1. Use MySQL or another database system compatible with the SQL syntax in `Data.sql`.
2. Run `Data.sql` to create the `classicmodels` database, tables, and source data.
3. Select the `classicmodels` database.
4. Run the query in `Ekspor SQL.sql`.
5. Export the query results to CSV or Excel if needed.
6. Open `Dashboard Project 2.0.xlsx` to view the `Project` data and PivotTable summaries.

Main metric calculations:

```sql
Sales  = priceEach * quantityOrdered
Cost   = buyPrice * quantityOrdered
Profit = Sales - Cost
```

## Tools

- MySQL or a compatible SQL database
- Microsoft Excel
- SQL: `JOIN`, CTEs, aggregation, and the `DENSE_RANK()` window function
- Excel PivotTables and charts

## Reproducibility Notes

- `Data.sql` contains the source dataset, allowing the query to be run again locally.
- Aggregated results may have minor rounding differences because of decimal handling in Excel and SQL.
- Make sure `orderDate` is recognized as a date before grouping by year or month.
- Do not use `COUNT(*)` as the order count without deduplication because the dataset is stored at the order-detail grain.

## Author

**Taufik Willy H.**

- LinkedIn: [linkedin.com/in/taufikwilly8](https://www.linkedin.com/in/taufikwilly8)
- Email: Willytaufik8@gmail.com

## License

This repository does not include a specific license file or license statement. Use and distribute its contents according to the repository owner's permission.

---

This project demonstrates how transactional data extracted from SQL can be prepared as an analytical dataset and transformed into an Excel dashboard for monitoring sales performance and supporting data-driven decision-making.

[![GitHub Repository](https://img.shields.io/badge/GitHub-Data--Analyst--Project-181717?logo=github)](https://github.com/willytaufik8/Data-Analyst-Project)

---

**Project By Taufik Willy H.**

Thank you.

LinkedIn: [linkedin.com/in/taufikwilly8](https://www.linkedin.com/in/taufikwilly8)
Email: Willytaufik8@gmail.com
