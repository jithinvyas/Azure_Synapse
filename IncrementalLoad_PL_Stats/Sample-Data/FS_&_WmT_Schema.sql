select * from sys.tables

-- # Creating a Source Table
create table File_Source
(
    FieldID int,
    FileName varchar(40),
    LastModifytime datetime
);
INSERT INTO File_Source
    (FieldID, FileName, LastModifytime)
VALUES
    (1, 'aaaa','05/06/2017 12:56:00 AM'),
    (2, 'bbbb','05/07/2019 05:23:00 PM'),

-- # Creating WmT (Watermark Table)
create table watermarktable
(
	TableName varchar(40),
	WatermarkValue datetime
);
INSERT INTO watermarktable
VALUES ('File_Source','2019-11-24 17:23:00.000')  

--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
--xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

select * from File_Source
select * from watermarktable

-- FileSource Lookup's Query
select MAX(LastModifytime) as LatestDate from File_Source

-- Source Query (On Cloud)
select * from File_Source
'''''
where LastModifytime > '@{activity('WmT_Lookup').output.firstRow.WatermarkValue}'
and
LastModifytime <= '@{activity('FS_Lookup').output.firstRow.LatestDate}'

@activity('FS_Lookup').output.firstRow.LatestDate
@activity('WmT_Lookup').output.firstRow.TableName

@formatDateTime(convertTimeZone(utcNow(), 'UTC', 'India Standard Time'), 'yyyy-MM-dd HH:mm:ss')
'''''

--Insert Queries
INSERT INTO File_Source
    (FieldID, FileName, LastModifytime)
VALUES
    (3, 'cccc','02/28/2021 08:35:00 AM'),
    (4, 'dddd','07/12/2022 03:20:00 PM'),
    (5, 'eeee','10/31/2022 12:35:00 AM');

-- Create SP
CREATE or ALTER PROCEDURE [dbo].[usp_Update_WatermarkTable] @LastModifyTime datetime, @TableName varchar(40)
AS
BEGIN
	UPDATE watermarktable
	SET [WatermarkValue] = @LastModifyTime
	WHERE [TableName] = @TableName
END

-- Insert few After running Pipeline
INSERT INTO File_Source
    (FieldID, FileName, LastModifytime)
VALUES
    (6, 'ffff','02/06/2023 11:14:05 AM'),
    (7, 'gggg','04/17/2023 12:20:00 PM'),
	(8, 'hhhh','06/18/2023 05:25:00 PM'),
	(9, 'iiii','10/21/2023 09:30:05 PM');

INSERT INTO File_Source
    (FieldID, FileName, LastModifytime)
VALUES
    (10, 'jjjj','01/31/2024 11:57:24 AM');

-- Run Pipeline and Check updated WmT
select * from File_Source
select * from watermarktable

-- Additional Queries
delete from File_Source
where FieldID > 5

update watermarktable
set WatermarkValue = '10/31/2022 12:35:00 AM'

update File_source
set LastModifytime = '10/31/2022 12:35:00 AM'
where FieldID = 5