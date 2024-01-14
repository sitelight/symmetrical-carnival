WITH ranked_entries AS (
    SELECT
        *,
        LEAD(Date) OVER (
            PARTITION BY PartnerID
            ORDER BY Date
        ) AS next_date_from
    FROM {{ ref('table_1_partners_input') }}
),
scd_entries AS (
    SELECT
        TechnicalKey,
        PartnerID,
        Name,
        Canton,
        Date AS Date_From,
        COALESCE(DATE_SUB(next_date_from, INTERVAL 1 DAY), '9999-12-31 00:00:00') AS Date_To,
        CASE 
            WHEN next_date_from IS NULL THEN 'Yes'
            ELSE 'No'
        END AS Is_valid
    FROM ranked_entries
)
SELECT
    TechnicalKey,
    PartnerID,
    Name,
    Canton,
    Date_From,
    Date_To,
    Is_valid
FROM scd_entries
ORDER BY PartnerID, Date_From DESC