select 
    wp.path
from public.pages wp;



with folder_path as (
    select 
        concat(pf.path, '/', pa.filename) as path
    from public.assetFolders pf
    
);

SELECT *
from public.assetFolders pf
join 


WITH RECURSIVE folder_paths AS (
    SELECT 
        id,
        name dir_name,
        slug,
        "parentId",
        name::text AS full_path
    FROM "assetFolders"
    WHERE "parentId" IS NULL
    UNION ALL
    SELECT 
        af.id,
        af.name,
        af.slug,
        af."parentId",
        fp.full_path || '/' || af.name AS full_path
    FROM "assetFolders" af
    JOIN folder_paths fp ON af."parentId" = fp.id
)
select
    concat(fp.full_path, '/', a.filename) as path
from folder_paths fp
join public.assets a
on a."folderId" = fp.id;

truncate assets 