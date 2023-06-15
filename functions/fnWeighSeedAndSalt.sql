CREATE FUNCTION [dbo].[fnWeighSeedAndSalt](
    @Seed UNIQUEIDENTIFIER,
    @Salt UNIQUEIDENTIFIER = NULL
) RETURNS TABLE AS RETURN (
    SELECT
        (
            CONVERT(
                INT,
                CONVERT(
                    VARBINARY,
                    SUBSTRING(
                        CONVERT(
                            NVARCHAR(32),
                            HASHBYTES(
                                'MD5',
                                CONCAT(@Seed, @Salt)
                            ) -- end HASHBYTES 
,
                            2
                        ) -- end CONVERT 
,
                        1,
                        4
                    ) -- end SUBSTRING 
,
                    2
                ) -- end CONVERT 
            ) -- end CONVERT 
        ) AS Weight
);