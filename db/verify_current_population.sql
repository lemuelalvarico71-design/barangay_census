-- SQL Queries to Verify Population Counts
-- This calculates: Head of Household (1 per household) + All Family Members from JSON
-- 
-- Population Formula: 1 (head of household) + JSON_LENGTH(family_members)
-- This matches the calculation used in dashboard_page.dart

-- For current year (2025)
SELECT 
    census_year,
    COUNT(*) as total_households,
    -- Count 1 for each head of household + JSON array length for family members
    SUM(
        1 + COALESCE(
            CASE 
                WHEN family_members IS NULL OR family_members = '' OR family_members = 'null' THEN 0
                ELSE JSON_LENGTH(family_members)
            END,
            0
        )
    ) as total_population
FROM households
WHERE census_year = YEAR(CURDATE())  -- Current year (2025)
GROUP BY census_year;

-- Alternative: More detailed breakdown per household (current year)
SELECT 
    id,
    household_number,
    head_of_household,
    -- Calculate actual: 1 (head) + family members count
    1 + COALESCE(
        CASE 
            WHEN family_members IS NULL OR family_members = '' OR family_members = 'null' THEN 0
            ELSE JSON_LENGTH(family_members)
        END,
        0
    ) as calculated_total,
    family_members
FROM households
WHERE census_year = YEAR(CURDATE())
ORDER BY id;

-- ============================================
-- POPULATION BY EACH CENSUS YEAR
-- ============================================
-- This query shows population count for ALL census years
SELECT 
    census_year,
    COUNT(*) as total_households,
    -- Count 1 for each head of household + JSON array length for family members
    SUM(
        1 + COALESCE(
            CASE 
                WHEN family_members IS NULL OR family_members = '' OR family_members = 'null' THEN 0
                ELSE JSON_LENGTH(family_members)
            END,
            0
        )
    ) as total_population
FROM households
GROUP BY census_year
ORDER BY census_year ASC;

-- ============================================
-- DETAILED BREAKDOWN BY YEAR
-- ============================================
-- Shows each year with household count and population
SELECT 
    census_year,
    COUNT(*) as households,
    SUM(
        1 + COALESCE(
            CASE 
                WHEN family_members IS NULL OR family_members = '' OR family_members = 'null' THEN 0
                ELSE JSON_LENGTH(family_members)
            END,
            0
        )
    ) as population,
    ROUND(
        SUM(
            1 + COALESCE(
                CASE 
                    WHEN family_members IS NULL OR family_members = '' OR family_members = 'null' THEN 0
                    ELSE JSON_LENGTH(family_members)
                END,
                0
            )
        ) / COUNT(*),
        2
    ) as avg_household_size
FROM households
GROUP BY census_year
ORDER BY census_year ASC;

-- ============================================
-- SUMMARY COMPARISON (Current Year Only)
-- ============================================
SELECT 
    'Calculated (1 head + JSON members)' as method,
    SUM(
        1 + COALESCE(
            CASE 
                WHEN family_members IS NULL OR family_members = '' OR family_members = 'null' THEN 0
                ELSE JSON_LENGTH(family_members)
            END,
            0
        )
    ) as population,
    COUNT(*) as households
FROM households
WHERE census_year = YEAR(CURDATE());

