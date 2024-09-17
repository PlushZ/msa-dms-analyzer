-- Step 1: Find the minimal mutation_id for each unique set of mutation fields
WITH min_mutation_ids AS (
    SELECT 
        m.gene_urn_id, 
        m.species_id, 
        m.position, 
        m.wt_residue, 
        m.variant_residue,
        MIN(m.mutation_id) AS min_mutation_id
    FROM 
        mutation m
    WHERE 
        m.gene_urn_id = 6  -- Filter by chosen gene_urn_id
    GROUP BY 
        m.gene_urn_id, 
        m.species_id, 
        m.position, 
        m.wt_residue, 
        m.variant_residue
),

-- Step 2: Delete rows from the dms table where mutation_id is not the minimum for the duplicates
deleted_dms AS (
    DELETE FROM dms
    WHERE mutation_id NOT IN (SELECT min_mutation_id FROM min_mutation_ids)
    AND mutation_id IN (SELECT mutation_id FROM mutation WHERE gene_urn_id = 6)  -- Restrict to chosen gene_urn_id
    RETURNING mutation_id
),

-- Step 3: Delete rows from the mutation table with mutation_id values that were deleted from dms for the chosen gene_urn_id
deleted_mutation AS (
    DELETE FROM mutation
    WHERE mutation_id IN (SELECT mutation_id FROM deleted_dms)
    AND gene_urn_id = 6  -- Ensure deletion is restricted to chosen gene_urn_id
    RETURNING mutation_id
)

-- Final step: Combine the select statements into the WITH clause
SELECT * FROM deleted_dms;
