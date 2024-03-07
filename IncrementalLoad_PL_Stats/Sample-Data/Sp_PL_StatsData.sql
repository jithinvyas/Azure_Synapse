-- PL_Stats tables gets updated when the pipeline has triggered
create table PL_Stats(
						ADF_Name varchar(30),
						PL_Name varchar(30),
						PL_RunID varchar(30),
						PL_StartTime datetime,
						CD_EndTime datetime,
						PL_EndTime datetime
)

select * from PL_Stats

create or alter procedure ADFPL_Executions(
											@ADF_Name varchar(30),
											@PL_Name varchar(30),
											@PL_RunID varchar(30),
											@PL_StartTime datetime,
											@CD_EndTime datetime,
											@PL_EndTime datetime
)AS
Begin
		Insert into PL_Stats values (@ADF_Name, @PL_Name, @PL_RunID, @PL_StartTime, @CD_EndTime, @PL_EndTime)
End


select * from File_Source
select * from watermarktable

select * from PL_Stats
