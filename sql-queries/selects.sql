select * from integrated_data
--all mutation for particular urn
SELECT 
    m.*, 
    g.gene_name, 
    g.urn_mavedb, 
    d.score, 
    s.blosum62, 
    s.grantham
FROM 
    mutation m
JOIN 
    gene_urn g ON m.gene_urn_id = g.id
JOIN 
    dms d ON m.id = d.mutation_id
JOIN 
    substitution_matrix s 
    ON m.wt_residue = s.amino_acid_x 
    AND m.variant_residue = s.amino_acid_y
WHERE 
    g.id = 13;
--ORDER BY 
	--m.mutation_id,
	--g.urn_mavedb, m.id;
	--m.mutation_type_id DESC

SELECT amino_acid_x, amino_acid_y, blosum62, grantham
FROM substitution_matrix
WHERE amino_acid_x = 'A'
ORDER BY amino_acid_x, amino_acid_y

-------------------------------------
SELECT g.gene_urn_id, g.urn_mavedb, g.gene_name,
FROM gene_urn g
LEFT JOIN mutation m ON g.id = m.gene_urn_id
WHERE m.mutation_id IS NULL
ORDER BY g.urn_mavedb;
-------------------------------------

SELECT 
	id, 
	--gene_name, 
	urn_mavedb, 
	--pearson_dms_blosum62, 
	--spearman_dms_blosum62, 
	pearson_dms_grantham, 
	--spearman_dms_grantham,
	pearson_dms_grantham_disruptive,
    --spearman_dms_grantham_disruptive,
    pearson_dms_grantham_tolerant --,
    --spearman_dms_grantham_tolerant --,
    --pearson_dms_blosum62_unfavorable,
    --spearman_dms_blosum62_unfavorable,
    --pearson_dms_blosum62_favorable --,
    --spearman_dms_blosum62_favorable
FROM gene_urn
--WHERE gene_urn_id=153
ORDER BY ABS(pearson_dms_grantham_disruptive) DESC

select * from mutation_type

select amino_acid_x, amino_acid_y, blosum62, grantham 
from substitution_matrix 
where blosum62 is not null
order by blosum62 asc

select * from gene_urn

select * from dms_range

SELECT column_name
FROM information_schema.columns
WHERE table_name = 'dms_range';

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



