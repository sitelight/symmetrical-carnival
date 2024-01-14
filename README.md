# DBT Project for Partner Data SCD2

## Overview

This dbt project transforms partner data from a staging table to an output table implementing Slowly Changing Dimension Type 2 (SCD2) logic. It is designed to track historical changes to partner attributes over time.

## Prerequisites

Before running this project, you should have:

- dbt installed and set up in your environment.
- Access to your data warehouse with the necessary permissions to read from the source schemas and write to the destination schema.
- Configured `profiles.yml` to connect to your target data warehouse – e.g: BigQuery – see [Connection to BigQuery](#connection-to-bigquery) for more information.

## Project Structure

- `models/`: SQL transformations for creating data models.
- `seeds/`: CSV files for seeding reference data.
- `tests/`: Custom tests for data validation.

## Setup

1. Clone the repository to your local system.
2. Navigate to the project directory.

## Connection to BigQuery

The connection to BigQuery is handled in the `profiles.yml` file. You can find more information about configuring your connection [here](https://docs.getdbt.com/reference/warehouse-profiles/bigquery-profile).

To use the project default (SSO), run the following command:

```shell
gcloud auth application-default login
```

before running any `dbt` commands.

For other methods such as service account JSON keys, please refer to the [dbt documentation](https://docs.getdbt.com/reference/warehouse-profiles/bigquery-profile).

## Execution flow

You first need to install the required packages from the `packages.yml` file:

```shell
dbt deps
```

To seed reference data into your data warehouse, run the following command:

```shell
dbt seed
```

The test table will then be created in your target schema.

You can then run `dbt run` and check.

You can then execute the following command to run the tests:

```shell
dbt test
```

To run all commands execute:

```shell
dbt build
```