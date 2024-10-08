--Query 1: Score for Disruptive Grantham--
SELECT 
    d.score AS score_for_disruptive_grantham
FROM 
    mutation m
JOIN 
    gene_urn g ON m.gene_urn_id = g.id
JOIN 
    dms d ON m.id = d.mutation_id
JOIN 
    substitution_matrix s ON m.wt_residue = s.amino_acid_x AND m.variant_residue = s.amino_acid_y
WHERE 
    g.urn_mavedb = 'urn:mavedb:00000003-b-1' AND
    s.grantham >= 100;
	
--Query 2: Score for Unfavorable Blosum62--
SELECT 
    d.score AS score_for_unfavorable_blosum62
FROM 
    mutation m
JOIN 
    gene_urn g ON m.gene_urn_id = g.id
JOIN 
    dms d ON m.id = d.mutation_id
JOIN 
    substitution_matrix s ON m.wt_residue = s.amino_acid_x AND m.variant_residue = s.amino_acid_y
WHERE 
    g.urn_mavedb = 'urn:mavedb:00000003-b-1' AND
    s.blosum62 <= -2;

--Query 3: Score for Tolerant Grantham--
SELECT 
    d.score AS score_for_tolerant_grantham
FROM 
    mutation m
JOIN 
    gene_urn g ON m.gene_urn_id = g.id
JOIN 
    dms d ON m.id = d.mutation_id
JOIN 
    substitution_matrix s ON m.wt_residue = s.amino_acid_x AND m.variant_residue = s.amino_acid_y
WHERE 
    g.urn_mavedb = 'urn:mavedb:00000003-b-1' AND
    s.grantham <= 50;

--Query 4: Score for Favorable Blosum62--
SELECT 
    d.score AS score_for_favorable_blosum62
FROM 
    mutation m
JOIN 
    gene_urn g ON m.gene_urn_id = g.id
JOIN 
    dms d ON m.id = d.mutation_id
JOIN 
    substitution_matrix s ON m.wt_residue = s.amino_acid_x AND m.variant_residue = s.amino_acid_y
WHERE 
    g.urn_mavedb = 'urn:mavedb:00000003-b-1' AND
    s.blosum62 >= 2;


----full select ----
SELECT 
    g.gene_name, 
    g.urn_mavedb, 
    m.position, 
    m.wt_residue, 
    m.variant_residue, 
	aap_wt.hydrophobic AS wt_hydrophobic, 
	aap_variant.hydrophobic AS variant_hydrophobic,
	aap_wt.secondary_structure_preference AS wt_secondary_structure_preference, 
	aap_variant.secondary_structure_preference AS variant_secondary_structure_preference,
    --m.edit_distance, 
    mt.type AS mutation_type,
    s.blosum62, 
    s.grantham,
    d.score, 
    dr.nonsense_from_data,
    dr.nonsense_from_method,
    --dr.max_hyperactivity,
    --dr.synonymous_from_data,
    --dr.synonymous_from_method,
    dr.calc_method,
    dr.min_from_data,
    dr.max_from_data
FROM 
    mutation m
JOIN 
    gene_urn g ON m.gene_urn_id = g.id
JOIN 
    dms d ON m.id = d.mutation_id
JOIN 
    substitution_matrix s ON m.wt_residue = s.amino_acid_x AND m.variant_residue = s.amino_acid_y
JOIN 
    dms_range dr ON dr.gene_urn_id = m.gene_urn_id
JOIN 
    mutation_type mt ON mt.id = m.mutation_type_id
JOIN 
    amino_acid_property aap_wt ON m.wt_residue = aap_wt.one_letter_code  -- Join for wild-type residue
JOIN 
    amino_acid_property aap_variant ON m.variant_residue = aap_variant.one_letter_code  -- Join for variant residue
WHERE
    g.urn_mavedb = 'urn:mavedb:00000003-b-1'
	--(s.grantham >= 100 OR s.blosum62 <= -2) --AND
	--(s.blosum62 >= 2 OR s.grantham <= 50) AND 
	--((m.wt_residue = 'L' AND m.variant_residue = 'I') OR (m.wt_residue = 'I' AND m.variant_residue = 'L'))
--ORDER BY 
--    g.urn_mavedb DESC;