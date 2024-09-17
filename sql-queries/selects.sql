--all mutation for particular urn
SELECT m.*, g.gene_name, g.urn_mavedb, d.score
FROM mutation m
JOIN gene_urn g ON m.gene_urn_id = g.gene_urn_id
JOIN dms d ON m.mutation_id = d.mutation_id
--WHERE g.urn_mavedb LIKE '%0001-a-3%' --AND m.position = '358'
WHERE g.gene_urn_id = 109 
	AND m.position=1
	AND m.wt_residue='T'
	AND m.variant_residue='S'
ORDER BY 
	--m.mutation_id,
	m.position;

SELECT d.score
FROM dms d
JOIN mutation m ON m.mutation_id=d.mutation_id
WHERE m.gene_urn_id=109

SELECT g.gene_urn_id
FROM gene_urn g
LEFT JOIN mutation m ON g.gene_urn_id=m.gene_urn_id
GROUP BY g.gene_urn_id
HAVING COUNT(m.mutation_id) = 0
ORDER BY g.gene_urn_id;


SELECT COUNT(*) 
FROM gene_urn

SELECT * 
FROM gene_urn
ORDER BY urn_mavedb

--count of duplicates for each position in mutation
SELECT 
    m.gene_urn_id, 
    m.species_id, 
    m.position, 
    m.wt_residue, 
    m.variant_residue, 
    m.edit_distance, 
    COUNT(*) as duplicate_count,
	g.gene_name, g.urn_mavedb, d.score
FROM 
    mutation m
JOIN gene_urn g ON m.gene_urn_id = g.gene_urn_id
JOIN dms d ON m.mutation_id = d.mutation_id
GROUP BY 
    m.gene_urn_id, 
    m.species_id, 
    m.position, 
    m.wt_residue, 
    m.variant_residue, 
    m.edit_distance,
	g.gene_name, g.urn_mavedb, d.score
HAVING 
    COUNT(*) > 1
ORDER BY 
    g.urn_mavedb, 
    m.position;

-- count of positions with duplicates for each urn
SELECT 
    duplicates.gene_name, 
	duplicates.gene_urn_id,
    duplicates.urn_mavedb,
    COUNT(*) AS count_positions_with_duplicates
FROM (
    SELECT 
        m.gene_urn_id, 
        m.species_id, 
        m.position, 
        m.wt_residue, 
        m.variant_residue, 
        m.edit_distance, 
        COUNT(*) as duplicate_count,
        g.gene_name, 
        g.urn_mavedb, 
        d.score
    FROM 
        mutation m
    JOIN gene_urn g ON m.gene_urn_id = g.gene_urn_id
    JOIN dms d ON m.mutation_id = d.mutation_id
    GROUP BY 
        m.gene_urn_id, 
        m.species_id, 
        m.position, 
        m.wt_residue, 
        m.variant_residue, 
        m.edit_distance, 
        g.gene_name, 
        g.urn_mavedb, 
        d.score
    HAVING 
        COUNT(*) > 1
    ORDER BY 
        g.urn_mavedb, 
        m.position
) AS duplicates
GROUP BY 
	duplicates.gene_urn_id,
    duplicates.gene_name, 
    duplicates.urn_mavedb
ORDER BY 
    count_positions_with_duplicates DESC;


-- subquery for cleaning up duplicates - fene_urn_ids with duplicates
SELECT 
	duplicates.gene_urn_id 
FROM (
    SELECT 
        m.gene_urn_id, 
        m.species_id, 
        m.position, 
        m.wt_residue, 
        m.variant_residue, 
        COUNT(*) as duplicate_count
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



