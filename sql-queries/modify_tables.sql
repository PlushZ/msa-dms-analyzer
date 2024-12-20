CREATE TABLE assay (
    id SERIAL PRIMARY KEY,
    type TEXT NOT NULL
);

INSERT INTO assay (type) VALUES
('function'),
('stability'),
('interaction'),
('aggregation'),
('trafficking');

ALTER TABLE gene_urn
ADD COLUMN assay_type INTEGER REFERENCES assay(id);



UPDATE gene_urn SET assay_type = 1 WHERE id = 551;

DELETE FROM assay
WHERE id = 5;


ALTER TABLE gene_urn
ADD COLUMN uniprot_target_seq_offset INTEGER;