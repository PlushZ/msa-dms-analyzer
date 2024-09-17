CREATE TABLE dms_range (
    dms_range_id SERIAL PRIMARY KEY,
    gene_urn_id INT REFERENCES gene_urn(gene_urn_id),
    lof NUMERIC,  -- loss of function score
    gof NUMERIC,  -- gain of function score
    wt NUMERIC,   -- wild-type score
    calc_method VARCHAR(255)  -- calculation method
);

-- Step 1: Add a foreign key reference to the new table
ALTER TABLE dms
ADD COLUMN dms_range_id INT REFERENCES dms_range(dms_range_id);

-- Step 2: Drop the old columns
ALTER TABLE dms
DROP COLUMN wt_score,
DROP COLUMN min_lof_score,
DROP COLUMN max_gof_score,
DROP COLUMN score_calc_method;