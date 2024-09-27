SELECT 
    g.gene_name, 
    g.urn_mavedb, 
	m.position, m.wt_residue, m.variant_residue, m.edit_distance, 
    mt.type AS mutation_type,
    s.blosum62, 
    s.grantham,
    d.score, 
    dr.nonsense_from_data,
    dr.nonsense_from_method,
    --dr.max_hyperactivity,
    dr.synonymous_from_data,
    dr.synonymous_from_method,
    dr.calc_method,
    dr.min_from_data,
    dr.max_from_data
FROM 
    mutation m
JOIN 
    gene_urn g ON m.gene_urn_id = g.gene_urn_id
JOIN 
    dms d ON m.mutation_id = d.mutation_id
JOIN 
    substitution_matrix s ON m.wt_residue = s.amino_acid_x AND m.variant_residue = s.amino_acid_y
JOIN 
    dms_range dr ON dr.gene_urn_id = m.gene_urn_id
JOIN 
    mutation_type mt ON mt.mutation_type_id = m.mutation_type_id 
WHERE 
    --(s.blosum62 >= 2 OR s.grantham <= 50) AND 
    (s.grantham >= 100 OR s.blosum62 <= -2) 
	--((m.wt_residue = 'L' AND m.variant_residue = 'I') OR (m.wt_residue = 'I' AND m.variant_residue = 'L'))
ORDER BY 
    g.urn_mavedb DESC;
