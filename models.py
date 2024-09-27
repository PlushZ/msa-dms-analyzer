from sqlalchemy import Column, Integer, Text, Float, ForeignKey
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base

# Base class for declarative class definitions
Base = declarative_base()

# Define ORM models

class GeneURN(Base):
    __tablename__ = 'gene_urn'
    gene_urn_id = Column(Integer, primary_key=True, autoincrement=True)
    urn_mavedb = Column(Text, unique=True)
    gene_name = Column(Text)
    target_seq = Column(Text)
    pearson_dms_blosum62 = Column(Float)
    spearman_dms_blosum62 = Column(Float)
    pearson_dms_grantham = Column(Float)
    spearman_dms_grantham = Column(Float)
    pearson_dms_grantham_disruptive = Column(Float, nullable=True)
    spearman_dms_grantham_disruptive = Column(Float, nullable=True)
    pearson_dms_grantham_tolerant = Column(Float, nullable=True)
    spearman_dms_grantham_tolerant = Column(Float, nullable=True)
    pearson_dms_blosum62_unfavorable = Column(Float, nullable=True)
    spearman_dms_blosum62_unfavorable = Column(Float, nullable=True)
    pearson_dms_blosum62_favorable = Column(Float, nullable=True)
    spearman_dms_blosum62_favorable = Column(Float, nullable=True)

class Species(Base):
    __tablename__ = 'species'
    species_id = Column(Integer, primary_key=True, autoincrement=True)
    species_name = Column(Text, unique=True)

class Mutation(Base):
    __tablename__ = 'mutation'
    mutation_id = Column(Integer, primary_key=True, autoincrement=True)
    gene_urn_id = Column(Integer, ForeignKey('gene_urn.gene_urn_id'))
    species_id = Column(Integer, ForeignKey('species.species_id'))
    position = Column(Integer)
    wt_residue = Column(Text)
    variant_residue = Column(Text)
    edit_distance = Column(Integer)
    # Relationships
    gene_urn = relationship('GeneURN')
    species = relationship('Species')

class DMS(Base):
    __tablename__ = 'dms'
    dms_id = Column(Integer, primary_key=True, autoincrement=True)
    mutation_id = Column(Integer, ForeignKey('mutation.mutation_id'))
    dms_range_id = Column(Integer, ForeignKey('dms_range.dms_range_id'))
    score = Column(Float)
    # Relationships
    dms_range = relationship('DmsRange')
    mutation = relationship('Mutation')

class DmsRange(Base):    
    __tablename__ = 'dms_range'
    dms_range_id = Column(Integer, primary_key=True, autoincrement=True)
    gene_urn_id = Column(Integer, ForeignKey('gene_urn.gene_urn_id'))
    nonsense_from_data = Column(Float)
    max_hyperactivity = Column(Float)
    synonymous_from_data = Column(Float)
    calc_method = Column(Text)
    nonsense_from_method = Column(Float)
    synonymous_from_method = Column(Float)
    min_from_data = Column(Float)
    max_from_data = Column(Float)
    # Relationships
    gene_urn = relationship('GeneURN')

class MSA(Base):
    __tablename__ = 'msa'
    msa_id = Column(Integer, primary_key=True, autoincrement=True)
    mutation_id = Column(Integer, ForeignKey('mutation.mutation_id'))
    shannon_entropy = Column(Float)
    jsd = Column(Float)
    phylop = Column(Float)
    phastcons = Column(Float)
    gerp = Column(Float)
    percentage_identity = Column(Float)
    ci = Column(Float)
    variant_percentage_residue = Column(Float)
    # Relationships
    mutation = relationship('Mutation')

class SubstitutionMatrix(Base):
    __tablename__ = 'substitution_matrix'
    amino_acid_x = Column(Text, primary_key=True)
    amino_acid_y = Column(Text, primary_key=True)
    benner22 = Column(Float)
    benner6 = Column(Float)
    benner74 = Column(Float)
    blastn = Column(Float)
    blastp = Column(Float)
    blosum45 = Column(Float)
    blosum50 = Column(Float)
    blosum62 = Column(Float)
    blosum80 = Column(Float)
    blosum90 = Column(Float)
    dayhoff = Column(Float)
    feng = Column(Float)
    genetic = Column(Float)
    gonnet1992 = Column(Float)
    johnson = Column(Float)
    jones = Column(Float)
    levin = Column(Float)
    mclachlan = Column(Float)
    mdm78 = Column(Float)
    megablast = Column(Float)
    nuc_4_4 = Column(Float)
    pam250 = Column(Float)
    pam30 = Column(Float)
    pam70 = Column(Float)
    rao = Column(Float)
    risler = Column(Float)
    str = Column(Float)
    grantham = Column(Float)

class IntegratedData(Base):
    __tablename__ = 'integrated_data'
    integrated_data_id = Column(Integer, primary_key=True, autoincrement=True)
    mutation_id = Column(Integer, ForeignKey('mutation.mutation_id'))
    dms_score = Column(Float)
    shannon_entropy = Column(Float)
    jsd = Column(Float)
    phylop = Column(Float)
    phastcons = Column(Float)
    gerp = Column(Float)
    percentage_identity = Column(Float)
    ci = Column(Float)
    variant_percentage_residue = Column(Float)
    BENNER22 = Column(Float)
    BENNER6 = Column(Float)
    BENNER74 = Column(Float)
    BLASTN = Column(Float)
    BLASTP = Column(Float)
    BLOSUM45 = Column(Float)
    BLOSUM50 = Column(Float)
    BLOSUM62 = Column(Float)
    BLOSUM80 = Column(Float)
    BLOSUM90 = Column(Float)
    DAYHOFF = Column(Float)
    FENG = Column(Float)
    GENETIC = Column(Float)
    GONNET1992 = Column(Float)
    JOHNSON = Column(Float)
    JONES = Column(Float)
    LEVIN = Column(Float)
    MCLACHLAN = Column(Float)
    MDM78 = Column(Float)
    MEGABLAST = Column(Float)
    NUC_4_4 = Column(Float)
    PAM250 = Column(Float)
    PAM30 = Column(Float)
    PAM70 = Column(Float)
    RAO = Column(Float)
    RISLER = Column(Float)
    STR = Column(Float)
    # Relationships
    mutation = relationship('Mutation')
