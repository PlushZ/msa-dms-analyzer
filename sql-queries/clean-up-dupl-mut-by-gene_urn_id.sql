-- Step 1: Calculate the average score for each unique set of mutation fields, for a chosen gene_urn_id
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
        m.gene_urn_id = 2  -- Filter by chosen gene_urn_id
    GROUP BY 
        m.gene_urn_id, 
        m.species_id, 
        m.position, 
        m.wt_residue, 
        m.variant_residue
),

-- Step 2: Update the dms table with the average score for the row with the minimum mutation_id for the chosen gene_urn_id
updated_dms AS (
    UPDATE dms
    SET score = avg_scores.avg_score
    FROM avg_scores
    WHERE 
        dms.mutation_id = avg_scores.min_mutation_id
    AND avg_scores.gene_urn_id = 2  -- Ensure updates are limited to chosen gene_urn_id
    RETURNING dms.mutation_id
),

-- Step 3: Delete rows from the dms table with mutation_id values greater than the minimum mutation_id for the chosen gene_urn_id
deleted_dms AS (
    DELETE FROM dms
    WHERE mutation_id NOT IN (SELECT min_mutation_id FROM avg_scores)
    AND mutation_id IN (SELECT mutation_id FROM mutation WHERE gene_urn_id = 2)  -- Restrict to chosen gene_urn_id
    RETURNING mutation_id
),

-- Step 4: Delete rows from the mutation table with mutation_id values that were deleted from dms for the chosen gene_urn_id
deleted_mutation AS (
    DELETE FROM mutation
    WHERE mutation_id IN (SELECT mutation_id FROM deleted_dms)
    AND gene_urn_id = 2  -- Ensure deletion is restricted to chosen gene_urn_id
    RETURNING mutation_id
)

-- Final step: Combine the select statements into the WITH clause
SELECT * FROM deleted_dms;
--SELECT * FROM deleted_mutation;
