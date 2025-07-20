CREATE TABLE dev_transerv_cont.ms_mod_val_autogen
(
    id UInt32,
    measure UInt8,
    service UInt32,
    model_run_id String,
    value Float32,
    mape Float32,
    flag UInt8,
    date DateTime64(6, 'UTC')
)
ENGINE = MergeTree
ORDER BY id
SETTINGS index_granularity = 8192
AS
SELECT
    rowNumberInAllBlocks() AS id,
    measure,
    service,
    model_run_id,
    value,
    mape,
    flag,
    date
FROM dev_transerv_cont.ms_mod_val;


-- drop table if exists dev_transerv_cont.ms_mod_val;

rename table dev_transerv_cont.ms_mod_val_autogen to dev_transerv_cont.ms_mod_val;

ALTER TABLE dev_transerv_cont.ms_mod_val DELETE WHERE id = 1;

