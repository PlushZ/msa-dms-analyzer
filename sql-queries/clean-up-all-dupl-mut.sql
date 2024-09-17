-- Step 1: Calculate the average score for each unique set of mutation fields, for gene_urn_ids with duplicates
WITH avg_scores AS (
    SELECT 
        m.gene_urn_id, 
        m.species_id, 
        m.position, 
        m.wt_residue, 
        m.variant_residue,
        MIN(m.mutation_id) AS min_mutation_id,
        AVG(d.score) AS avg_score
    FROM 
        mutation m
    JOIN 
        dms d ON m.mutation_id = d.mutation_id
    WHERE 
        m.gene_urn_id IN (
            -- Subquery to get gene_urn_ids with duplicates
            SELECT 
                duplicates.gene_urn_id 
            FROM (
                SELECT 
                    m.gene_urn_id, 
                    m.species_id, 
                    m.position, 
                    m.wt_residue, 
                    m.variant_residue, 
                    COUNT(*) AS duplicate_count
                FROM 
                    mutation m
                GROUP BY 
                    m.gene_urn_id, 
                    m.species_id, 
                    m.position, 
                    m.wt_residue, 
                    m.variant_residue         
                HAVING 
                    COUNT(*) > 1
            ) AS duplicates
            GROUP BY 
                duplicates.gene_urn_id
        )  -- Filter by gene_urn_ids with duplicates
    GROUP BY 
        m.gene_urn_id, 
        m.species_id, 
        m.position, 
        m.wt_residue, 
        m.variant_residue
),

-- Step 2: Update the dms table with the average score for the row with the minimum mutation_id for the selected gene_urn_ids
updated_dms AS (
    UPDATE dms
    SET score = avg_scores.avg_score
    FROM avg_scores
    WHERE 
        dms.mutation_id = avg_scores.min_mutation_id
    AND avg_scores.gene_urn_id IN (
        -- Same subquery for gene_urn_ids with duplicates
        SELECT 
            duplicates.gene_urn_id 
        FROM (
            SELECT 
                m.gene_urn_id, 
                m.species_id, 
                m.position, 
                m.wt_residue, 
                m.variant_residue, 
                COUNT(*) AS duplicate_count
            FROM 
                mutation m
            GROUP BY 
                m.gene_urn_id, 
                m.species_id, 
                m.position, 
                m.wt_residue, 
                m.variant_residue         
            HAVING 
                COUNT(*) > 1
        ) AS duplicates
        GROUP BY 
            duplicates.gene_urn_id
    )  -- Ensure updates are limited to selected gene_urn_ids
    RETURNING dms.mutation_id
),

-- Step 3: Delete rows from the dms table with mutation_id values greater than the minimum mutation_id for the selected gene_urn_ids
deleted_dms AS (
    DELETE FROM dms
    WHERE mutation_id NOT IN (SELECT min_mutation_id FROM avg_scores)
    AND mutation_id IN (SELECT mutation_id FROM mutation WHERE gene_urn_id IN (
        -- Same subquery for gene_urn_ids with duplicates
        SELECT 
            duplicates.gene_urn_id 
        FROM (
            SELECT 
                m.gene_urn_id, 
                m.species_id, 
                m.position, 
                m.wt_residue, 
                m.variant_residue, 
                COUNT(*) AS duplicate_count
            FROM 
                mutation m
            GROUP BY 
                m.gene_urn_id, 
                m.species_id, 
                m.position, 
                m.wt_residue, 
                m.variant_residue         
            HAVING 
                COUNT(*) > 1
        ) AS duplicates
        GROUP BY 
            duplicates.gene_urn_id
    ))  -- Restrict to selected gene_urn_ids
    RETURNING mutation_id
),

-- Step 4: Delete rows from the mutation table with mutation_id values that were deleted from dms for the selected gene_urn_ids
deleted_mutation AS (
    DELETE FROM mutation
    WHERE mutation_id IN (SELECT mutation_id FROM deleted_dms)
    AND gene_urn_id IN (
        -- Same subquery for gene_urn_ids with duplicates
        SELECT 
            duplicates.gene_urn_id 
        FROM (
            SELECT 
                m.gene_urn_id, 
                m.species_id, 
                m.position, 
                m.wt_residue, 
                m.variant_residue, 
                COUNT(*) AS duplicate_count
            FROM 
                mutation m
            GROUP BY 
                m.gene_urn_id, 
                m.species_id, 
                m.position, 
                m.wt_residue, 
                m.variant_residue         
            HAVING 
                COUNT(*) > 1
        ) AS duplicates
        GROUP BY 
            duplicates.gene_urn_id
    )  -- Ensure deletion is restricted to selected gene_urn_ids
    RETURNING mutation_id
)

-- Final step: Select deleted ids to confirm, all part of the WITH clause
SELECT * FROM deleted_dms;
--SELECT * FROM deleted_mutation;
