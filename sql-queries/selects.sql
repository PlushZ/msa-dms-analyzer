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
    g.id = '197' --AND m.position = '12'
ORDER BY 
	g.urn_mavedb, m.id, m.position;
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
WHERE table_name = 'gene_urn';

SELECT g.gene_urn_id
FROM gene_urn g
LEFT JOIN mutation m ON g.gene_urn_id=m.gene_urn_id
GROUP BY g.gene_urn_id
HAVING COUNT(m.mutation_id) = 0
ORDER BY g.gene_urn_id;


SELECT id, gene_name
FROM gene_urn
where gene_name IN ('SCN5A', 'SOX30', 'CBS', 'SGCB', 'BTK', 'NPHP1', 'HUWE1', 'BRCA1',
    'KCNQ1', 'PTEN', 'BRAF', 'KCNQ4', 'TPK1', 'ATP7B', 'PRKN', 'MSH2',
    'CALM1', 'KCNE1', 'KCNQ2');

SELECT id, gene_name, uniprot_id, uniprot_target_seq_offset, target_seq
FROM gene_urn
where uniprot_target_seq_offset IS NOT NULL
--where gene_name like '%SCN5A%'
ORDER BY id

SELECT DISTINCT id
FROM gene_urn
WHERE spearman_dms_alphamissense != 'NaN' --id = 8;
ORDER BY id

SELECT distinct gene_urn_id
FROM mutation
where eve_score !='NaN'
--WHERE gene_name ilike '%dOmain%'
ORDER BY gene_urn_id

SELECT distinct gene_urn_id
FROM mutation
where eve_score !='NaN'
--WHERE gene_name ilike '%dOmain%'
ORDER BY gene_urn_id

SELECT *
FROM gene_urn
WHERE assay_type = 5
order by urn_mavedb

select * from assay

SELECT count(distinct id)
FROM gene_urn
WHERE assay_type IS NOT NULL
ORDER BY id

SELECT 
	DISTINCT g.id,
	--g.id,
	g.uniprot_id, g.gene_name,
	a.id, a.type,
	mt.type,
	dr.synonymous_from_method, dr.nonsense_from_method
	--m.position, m.wt_residue, m.variant_residue, 
	--d.score, m.eve_score, m. eve_class_75_set, m.clinvar_label, m.alphamissense_class, 
	--m.alphamissense_pathogenicity, m.alphafold_conf_type, g.urn_mavedb
FROM mutation m
JOIN gene_urn g ON m.gene_urn_id = g.id
JOIN dms d ON m.id = d.mutation_id
JOIN assay a ON g.assay_type = a.id
JOIN dms_range dr ON g.id = dr.gene_urn_id
JOIN mutation_type mt ON m.mutation_type_id = mt.id
WHERE d.score IS NOT NULL
	AND m.eve_score != 'NaN'
	AND a.id IN (1, 2) --only function and stability assay types since they are the majority
	AND dr.synonymous_from_method IS NOT NULL
	AND dr.nonsense_from_method IS NOT NULL
ORDER BY g.id

select distinct eve_class_75_set
FROM
    mutation m
JOIN
    dms
    ON dms.mutation_id = m.id
JOIN
    gene_urn g
    ON m.gene_urn_id = g.id
JOIN
    assay a
    ON g.assay_type = a.id
WHERE
    dms.score IS NOT NULL
    AND m.eve_score != 'NaN'
	AND a.id in (1,2)
	AND dr.synonymous_from_method IS NOT NULL
	AND dr.nonsense_from_method IS NOT NULL;


-- Extract DMS scores and related features
SELECT
    g.id AS gene_id,
    m.id AS mutation_id,
    m.position,
    m.wt_residue,
    m.variant_residue,
    m.eve_score,
    m.eve_class_75_set,
    sm.blosum62 AS blosum62_score,
    sm.grantham AS grantham_score,
    dms.score AS dms_score,
    g.assay_type,
	dr.synonymous_from_method,
	dr.nonsense_from_method
FROM
    mutation m
JOIN
    substitution_matrix sm
    ON sm.amino_acid_x = m.wt_residue AND sm.amino_acid_y = m.variant_residue
JOIN
    dms
    ON dms.mutation_id = m.id
JOIN
    gene_urn g
    ON m.gene_urn_id = g.id
JOIN
    assay a
    ON g.assay_type = a.id
JOIN 
	dms_range dr 
	ON g.id = dr.gene_urn_id
WHERE
    dms.score IS NOT NULL
    AND m.eve_score != 'NaN'
    AND a.id IN (1, 2) --only function and stability assay types since they are the majority
	AND dr.synonymous_from_method IS NOT NULL
	AND dr.nonsense_from_method IS NOT NULL;






select count(distinct g.id)
FROM mutation m
JOIN gene_urn g ON m.gene_urn_id = g.id
WHERE m.alphamissense_pathogenicity !='NaN' and m.eve_score != 'NaN' and m.alphafold_conf_type != 'NaN'

select count(*) from gene_urn

select * from assay


SELECT * 
FROM amino_acid_property
ORDER BY full_name

SELECT id, uniprot_id, target_seq
FROM gene_urn
WHERE uniprot_id='Q9BUJ2'
--where id=524

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
JOIN gene_urn g ON m.gene_urn_id = g.id
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



