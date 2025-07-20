
alter Table tmp.columns_rename add column id UInt16 not null;
-- add id column to tmp.columns_rename table
-- ClickHouse does not support adding primary key constraints via ALTER TABLE.
-- You must define the primary key when creating the table.
-- If you need to set a primary key, you must recreate the table with the correct ENGINE and PRIMARY KEY clause.

CREATE TABLE tmp.columns_rename (
    id UInt16 not null,
    `column_to_rename` String,
    `cargo` Nullable (String),
    `leg` Nullable (String),
    `leg_service` Nullable (String),
    `p_bet_nds` Nullable (String),
    `p_margin` Nullable (String),
    `p_price` Nullable (String),
    `p_price_expenditure` Nullable (String),
    `p_route_edge` Nullable (String),
    `p_route_vertex` Nullable (String),
    `route_service` Nullable (String),
    `s_common` Nullable (String),
    `s_complex_service` Nullable (String),
    `s_country` Nullable (String),
    `s_currency` Nullable (String),
    `s_freight_etsng` Nullable (String),
    `s_freight_etsng_dan` Nullable (String),
    `s_freight_gng` Nullable (String),
    `s_point` Nullable (String),
    `s_point_type` Nullable (String),
    `s_ref_type_application` Nullable (String),
    `s_service` Nullable (String),
    `s_stage_transportation` Nullable (String),
    `s_type_application` Nullable (String),
    `s_unit_measurement` Nullable (String),
    `transport_solution` Nullable (String)
) ENGINE = MergeTree
ORDER BY id
SETTINGS index_granularity = 8192

alter table tmp.columns_rename add column if not exists p_price_history Nullable (String);
alter table tmp.columns_rename add column if not exists p_price_expenditure_history Nullable (String);

-- ClickHouse
-- Create the tmp.points_merged table with the same structure as dev_transerv_cont.points_merged
CREATE TABLE tmp.points_merged (
    `st_code` UInt32,
    `st_name` String,
    `railway_code` UInt16,
    `railway_name` String,
    `railway_short_name` String,
    `country_name` String COMMENT 'country name',
    `country_uic` UInt8 COMMENT 'ISO3166-1-Alpha-3: Three-letter ISO country code (from iso_a3 field)',
    `lat` Nullable (Float32),
    `lon` Nullable (Float32),
    `st_rail_code` Int64 COMMENT 'merged station and railway codes by "000"'
) ENGINE = MergeTree
ORDER BY
    tuple () SETTINGS index_granularity = 8192

INSERT INTO tmp.points_merged
SELECT * FROM dev_transerv_cont.points_merged;

ALTER TABLE tmp.points_merged
ADD COLUMN IF NOT EXISTS id UUID;

-- alter table tmp.points_merged drop column id;

CREATE TABLE tmp.points_merged_with_id
ENGINE = MergeTree
ORDER BY tuple()
AS
SELECT
    generateUUIDv4() AS id,
    *
FROM tmp.points_merged;

-- DROP TABLE tmp.points_merged;

RENAME TABLE tmp.points_merged_with_id TO tmp.points_merged;

select distinct st_name, country_name
from tmp.points_merged
where country_name  ilike 'Кит%';