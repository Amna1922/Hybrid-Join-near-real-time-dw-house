# Walmart Data Warehouse Project

**Near-real-time Data Warehouse for Walmart transactional analytics using the HYBRIDJOIN algorithm.**

## Table of Contents

1. [Project Overview](#project-overview)
2. [Folder Structure](#folder-structure)
3. [Prerequisites](#prerequisites)
4. [Installation](#installation)
5. [Configuration](#configuration)
6. [Running the Project](#running-the-project)
7. [SQL Analytical Queries](#sql-analytical-queries)
8. [Troubleshooting](#troubleshooting)
9. [Contributors](#contributors)

---

## Project Overview

This project implements a near real time data warehouse pipeline for Walmart transactional data. The core is the hybridjoin algorithm which incrementally joins streaming transactions with master data and loads enriched rows into a `FactSales` table for analytics.

Key goals:

- Ingest transactional data in streaming chunks
- Enrich with DimCustomer and DimProduct
- Maintain a DimDate for time based queries

---

## Folder Structure

```
dwbi_project/
│
├── create_dw.sql
├── load.py
├── hybrid_join.py
├── README.md
│
├── data/
│   ├── transactional_data.csv
│   ├── customer_master_data.csv
│   ├── product_master_data.csv
│
└── queries.sql

```

## Prerequisites

### Software

- Python 3.7+
- MySQL Server 8.0+
- Packages: `pandas`, `pymysql`

## Installation

1. Create Python environment:

```bash
    ensure you have python and mysql setup ready for use on your pcs.
    if not then install mysql from chrome and use google collab for python
```

2. Install Python dependencies:

```bash
pip install pandas pymysql
rest are already installed in python environment
```

## Configuration

write input for connection settings inside `load.py` and `hybrid_join.py`

```python
HOST = 'localhost'
USER = 'root'
PASSWORD = 'your_password'
NAME = 'walmart'
```

---

## Running the Project

### Phase 1 — Database Setup

Create database by running the given create_dw.sql and load data in it by:

```bash
python load.py
```

**Expected console output**

```
Loading customer data...
Loading product data...
Loading date dimension...
Database setup completed successfully!
```

Verify tables:

```mysql
USE walmart;
SHOW TABLES;
SELECT COUNT(*) FROM DimCustomer;
SELECT COUNT(*) FROM DimProduct;
SELECT COUNT(*) FROM DimDate;
```

---

### Phase 2 — HYBRIDJOIN Processing

Start the HYBRIDJOIN ETL:

```bash
python hybrid_join.py
```

Typical output snippets:

```
STARTING HYBRIDJOIN SYSTEM FOR WALMART DATA WAREHOUSE

STEP 1: Tools initialized with hS=10000, vP=500, w=10000
Stream reader thread started...
HYBRIDJOIN algorithm thread started
STEP 2: Loaded 200 tuples to hash table. w=9800, Queue size: 200
STEP 3: Loaded disk partition for key 1001 (vP=1)
STEP 4: Joined 2 records. Freed 2 slots. Total processed: 2
...
ALL DATA PROCESSED - HYBRIDJOIN COMPLETED!
HYBRIDJOIN FINAL: 55000 records loaded to Data Warehouse
HYBRIDJOIN system shutdown complete
```

What it does:

- Streams transactional CSV in chunks
- Probes in-memory hash + disk partitions (HYBRIDJOIN)
- Enriches records and inserts them into `FactSales`

---

### Phase 3 — Data Verification & Analytics

Quick checks:

```sql
USE walmart;
SELECT COUNT(*) AS total_records FROM FactSales;
SELECT * FROM FactSales LIMIT 5;
```

Enrichment sample:

```sql
SELECT *
FROM FactSales
LIMIT 10;
```

## SQL Analytical Queries

> all analytical MYSQL queries are in `sql_queries.sql` for use.

---

## Troubleshooting

**MySQL connection error**

- Ensure MySQL is running.
- Confirm `DB_HOST`, `DB_PORT`, username & password.

**CSV not found**

- Verify `data/` folder and filenames.
- Check file permissions.

**HYBRIDJOIN running slowly**

- Increase stream chunk size (e.g., 500 → 800).
- Reduce sleeps in `hybrid_join.py`.

**Infinite loop**

- `Ctrl+C` to stop.
- Inspect CSV for malformed rows or invalid dates (expect `YYYY-MM-DD`).

---

## Contributors

- Primary: Amna Zubair

---
