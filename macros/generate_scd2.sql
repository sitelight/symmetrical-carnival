{% macro generate_scd_type_2_single_table(
    table_name,
    primary_key_column,
    date_column,
    start_date_column_desired_name='Date_From',
    end_date_column_desired_name='Date_To',
    valid_flag_column_desired_name='Is_valid',
    valid_flag_column_true='Yes',
    valid_flag_column_false='No',
    default_end_date='9999-12-31 00:00:00'
) %}

WITH ranked_entries AS (
    SELECT
        *,
        LEAD({{ date_column }}) OVER (
            PARTITION BY {{ primary_key_column }}
            ORDER BY {{ date_column }}
        ) AS next_date
    FROM {{ table_name }}
),

scd_entries AS (
    SELECT
        * EXCEPT ({{date_column}}, next_date),
        {{ date_column }} AS {{ start_date_column_desired_name }},
        COALESCE(DATE_SUB(next_date, INTERVAL 1 DAY), '{{ default_end_date }}') AS {{ end_date_column_desired_name }},
        CASE 
            WHEN next_date IS NULL THEN '{{ valid_flag_column_true }}'
            ELSE '{{ valid_flag_column_false }}'
        END AS {{ valid_flag_column_desired_name }}
    FROM ranked_entries
)

SELECT *
FROM scd_entries
ORDER BY {{ primary_key_column }}, {{ start_date_column_desired_name }} DESC

{% endmacro %}
