# Raw Metadata Online Retail Info

This is a transactional data set which contains all the transactions occurring between 01/12/2010 and 09/12/2011 for a UK-based and registered non-store online retail.

This dataste was taken from: [Online Retail Dataset - UC Irvine](https://archive.ics.uci.edu/dataset/352/online+retail)


## Additional Information

This is a transactional data set which contains all the transactions occurring between 01/12/2010 and 09/12/2011 for a UK-based and registered non-store online retail.The company mainly sells unique all-occasion gifts. Many customers of the company are wholesalers.

## Metadata


| Variable Name | Role       | Type         | Description                                                                                  | Units     | Missing Values |
|---------------|------------|--------------|----------------------------------------------------------------------------------------------|-----------|----------------|
| InvoiceNo     | ID         | Categorical  | A 6-digit integral number uniquely assigned to each transaction. If this code starts with 'C', it indicates a cancellation. | -         | No             |
| StockCode     | ID         | Categorical  | A 5-digit integral number uniquely assigned to each distinct product.                       | -         | No             |
| Description   | Feature    | Categorical  | Product name.                                                                                | -         | No             |
| Quantity      | Feature    | Integer      | The quantities of each product (item) per transaction.                                      | -         | No             |
| InvoiceDate   | Feature    | Date         | The day and time when each transaction was generated.                                        | -         | No             |
| UnitPrice     | Feature    | Continuous   | Product price per unit.                                                                      | Sterling  | No             |
| CustomerID    | Feature    | Categorical  | A 5-digit integral number uniquely assigned to each customer.                               | -         | No             |
| Country       | Feature    | Categorical  | The name of the country where each customer resides.                                         | -         | No             |


## Additional Variable Information

| Variable Name | Description                                                                                                     | Type       |
|---------------|-----------------------------------------------------------------------------------------------------------------|------------|
| InvoiceNo     | Invoice number. A 6-digit integral number uniquely assigned to each transaction. If this code starts with 'c', it indicates a cancellation. | Nominal    |
| StockCode     | Product (item) code. A 5-digit integral number uniquely assigned to each distinct product.                      | Nominal    |
| Description   | Product (item) name.                                                                                           | Nominal    |
| Quantity      | The quantities of each product (item) per transaction.                                                         | Numeric    |
| InvoiceDate   | Invoice Date and time. The day and time when each transaction was generated.                                    | Numeric    |
| UnitPrice     | Unit price. Product price per unit in sterling.                                                                | Numeric    |
| CustomerID    | Customer number. A 5-digit integral number uniquely assigned to each customer.                                 | Nominal    |
| Country       | Country name. The name of the country where each customer resides.                                             | Nominal    |
