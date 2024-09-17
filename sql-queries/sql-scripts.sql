SELECT Mutation.mutation_id, Gene.gene_name, Species.species_name, Mutation.position, Mutation.ancestral_residue, Mutation.variant_residue, Mutation.edit_distance
FROM Mutation
JOIN Gene ON Mutation.gene_id = Gene.gene_id
JOIN Species ON Mutation.species_id = Species.species_id
WHERE Gene.gene_name like '01-d-2'
limit 10


