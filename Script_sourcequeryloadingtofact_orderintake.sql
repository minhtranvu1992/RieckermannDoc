/*VENTAS_OrderIntake_trade*/
if OBJECT_ID('tempdb..#temp1') is not null drop table #temp1
SELECT a.nr_auftrag,
       a.erfasst,
       a.abgerechnet_dat,
       a.betreff,
       a.nr_kunde,
       a.nr_liefnt,
       a.bez,
       a.nr_gart AS industry,
       a.cty,
       a.department,
       a.nr_position_vpos,
       a.liefertermin,
       RTRIM(a.Merchandise) AS Merchandise,
       a.preis_ges_dm,
       a.preis_ges_wr,
       b.DB2,
       a.bu_id,
       a.currency,
       a.Backlogrelevant,
       a.office_reference
INTO #temp1
FROM dbo.vTMP_VENTAS_OrderIntake_Trade_02_BU AS a
     INNER JOIN dbo.vTMP_VENTAS_OrderIntake_Trade_03_DB2pos AS b ON a.nr_auftrag = b.nr_auftrag
                                                                    AND a.nr_position_vpos = b.nr_position_vpos
WHERE(a.erfasst >= '2008-01-01')

if OBJECT_ID('tempdb..#temp2') is not null drop table #temp2
select 
FAKT_OrderIntake.nr_auftrag,
FAKT_OrderIntake.erfasst,
FAKT_OrderIntake.abgerechnet_dat,
FAKT_OrderIntake.betreff,
FAKT_OrderIntake.nr_kunde,
FAKT_OrderIntake.nr_liefnt,
FAKT_OrderIntake.bez,
FAKT_OrderIntake.industry,
FAKT_OrderIntake.cty,
FAKT_OrderIntake.department,
FAKT_OrderIntake.nr_position_vpos,
FAKT_OrderIntake.liefertermin,
FAKT_OrderIntake.Merchandise,
FAKT_OrderIntake.preis_ges_dm,
FAKT_OrderIntake.preis_ges_wr,
FAKT_OrderIntake.DB2,
FAKT_OrderIntake.bu_id,
FAKT_OrderIntake.currency,
FAKT_OrderIntake.Backlogrelevant,
FAKT_OrderIntake.office_reference,
CASE
           WHEN dbo.vTMP_VENTAS_OrderComplete_Trade_DB2pos.nr_konto1 = '3730'
                AND dbo.vTMP_VENTAS_OrderComplete_Trade_DB2pos.[Calculation_Status] = 1
           THEN dbo.vTMP_VENTAS_OrderComplete_Trade_DB2pos.PostCal_Value_DB2 / 2
           ELSE dbo.vTMP_VENTAS_OrderComplete_Trade_DB2pos.PostCal_Value_DB2
       END AS Postcal_IntakeDB2,
	  '0' AS Postcal_IntakeDB2_currency,
       dbo.vTMP_VENTAS_OrderComplete_Trade_DB2pos.PostCal_Value_DB3,
       CASE
           WHEN dbo.vTMP_VENTAS_OrderComplete_Trade_DB2pos.nr_konto1 = '3730'
                AND dbo.vTMP_VENTAS_OrderComplete_Trade_DB2pos.[Calculation_Status] = 0
           THEN dbo.vTMP_VENTAS_OrderComplete_Trade_DB2pos.PreCal_Value_DB2 / 2
           ELSE dbo.vTMP_VENTAS_OrderComplete_Trade_DB2pos.PreCal_Value_DB2
       END AS Precal_IntakeDB2,
	  '0' AS Precal_IntakeDB2_Currency,
	  dbo.vTMP_VENTAS_OrderComplete_Trade_DB2pos.PreCal_Value_DB3 as Precal_IntakeDB3,
	  '0' AS Postcal_IntakeDB3,
	  dbo.vTMP_VENTAS_OrderComplete_Trade_Value.PreCal_Value_Currency AS Precal_IntakeValue_Currency,
       dbo.vTMP_VENTAS_OrderComplete_Trade_Value.PreCal_Value AS Precal_IntakeValue,
       dbo.vTMP_VENTAS_OrderComplete_Trade_Value.PostCal_Value_Currency AS Postcal_IntakeValue_Currency,
       dbo.vTMP_VENTAS_OrderComplete_Trade_Value.PostCal_Value AS Postcal_IntakeValue,
       dbo.vTMP_VENTAS_OrderComplete_Trade_DB2pos.[Calculation_Status],
	  dbo.vTMP_VENTAS_OrderComplete_Trade_Value.[Calculation_Status] AS Calculation_Status_Trade
INTO #temp2
FROM 
#temp1 AS FAKT_OrderIntake 
LEFT JOIN dbo.vTMP_VENTAS_OrderComplete_Trade_Value 
ON dbo.vTMP_VENTAS_OrderComplete_Trade_Value.nr_auftrag = FAKT_OrderIntake.nr_auftrag
                                        AND dbo.vTMP_VENTAS_OrderComplete_Trade_Value.nr_position = FAKT_OrderIntake.nr_position_vpos
LEFT JOIN dbo.vTMP_VENTAS_OrderComplete_Trade_DB2pos ON dbo.vTMP_VENTAS_OrderComplete_Trade_DB2pos.nr_auftrag = dbo.vTMP_VENTAS_OrderComplete_Trade_Value.nr_auftrag
                                                             AND dbo.vTMP_VENTAS_OrderComplete_Trade_DB2pos.nr_position = dbo.vTMP_VENTAS_OrderComplete_Trade_Value.nr_position
WHERE FAKT_OrderIntake.abgerechnet_dat is null


SELECT a.nr_auftrag,
       a.erfasst,
       a.abgerechnet_dat,
       a.betreff,
       a.nr_kunde,
       a.nr_liefnt,
       a.bez,
       a.nr_gart AS industry,
       a.cty,
       a.department,
       a.nr_position_vpos,
       a.liefertermin,
       RTRIM(a.Merchandise) AS Merchandise,
       a.preis_ges_dm,
       a.preis_ges_wr,
       b.DB2,
       a.bu_id,
       a.currency,
       a.Backlogrelevant,
       a.office_reference,
	 CASE WHEN ISNULL(o.Precal_IntakeValue,0)=0 THEN a.preis_ges_dm
	 ELSE ISNULL(o.Precal_IntakeValue,0)
	 END AS Precal_IntakeValue ,
	 CASE WHEN ISNULL(o.Precal_IntakeDB2,0)=0 THEN b.DB2
	 ELSE ISNULL(o.Precal_IntakeDB2,0)
	 END AS Precal_IntakeDB2,
       ISNULL(o.Precal_IntakeDB2_Currency,0) AS Precal_IntakeDB2_Currency,
       CASE WHEN ISNULL(o.Precal_IntakeValue_Currency,0)=0 then a.preis_ges_wr
	  ELSE ISNULL(o.Precal_IntakeValue_Currency,0)
	  END AS Precal_IntakeValue_Currency,
	  ISNULL(o.Postcal_IntakeValue,0) AS Postcal_IntakeValue,
	  ISNULL(o.Postcal_IntakeValue_Currency,0) AS Postcal_IntakeValue_Currency,
      ISNULL(o.Postcal_IntakeDB2,0) AS Postcal_IntakeDB2,
       ISNULL(o.Postcal_IntakeDB2_currency,0) AS Postcal_IntakeDB2_currency,
       ISNULL(o.Precal_IntakeDB3,0) AS Precal_IntakeDB3,
       ISNULL(o.Postcal_IntakeDB3,0) AS Postcal_IntakeDB3,
       CASE WHEN o.[Calculation_Status] is null THEN 0
	  ELSE o.[Calculation_Status]
	  END AS Calculation_Status

FROM dbo.vTMP_VENTAS_OrderIntake_Trade_02_BU AS a
     INNER JOIN dbo.vTMP_VENTAS_OrderIntake_Trade_03_DB2pos AS b ON a.nr_auftrag = b.nr_auftrag
                                                                    AND a.nr_position_vpos = b.nr_position_vpos
	INNER JOIN #temp2  AS o on a.nr_auftrag=o.nr_auftrag and a.nr_position_vpos=o.nr_position_vpos 
						

WHERE(a.erfasst >= '2008-01-01');
-----------------------------------------------------------------------------------------------------

/*VENTAS_OrderIntake_commision*/
if OBJECT_ID('tempdb..#temp1') is not null drop table #temp1



SELECT b.nr_position,
       a.nr_kontrakt,
       a.abgerechnet_dat,
       a.nr_liefnt,
       a.nr_kunde,
       a.nr_gart AS industry,
       a.erfasst,
       a.seriell,
       a.liefertermin,
       a.bez,
       RTRIM(a.Merchandise) AS Merchandise,
       a.nr_adress_k,
       a.cty,
       a.department,
       a.preis_ges_dm,
       a.preis_ges_wr,
       b.DB2,
       a.bu_id,
       a.currency,
       a.Backlogrelevant,
       a.office_reference
INTO #temp1
FROM dbo.vTMP_VENTAS_OrderIntake_Comm_02_BU AS a
     INNER JOIN dbo.vTMP_VENTAS_OrderIntake_Comm_03_DB2pos AS b ON a.nr_kontrakt = b.nr_kontrakt
                                                                   AND a.nr_position = b.nr_position
WHERE(a.erfasst >= '2008-01-01');

if OBJECT_ID('tempdb..#temp2') is not null drop table #temp2

SELECT 
FAKT_OrderIntake.nr_kontrakt,
FAKT_OrderIntake.nr_position,
CASE
           WHEN dbo.vTMP_VENTAS_OrderComplete_Comm_DB2pos.nr_konto = '3730'
                AND dbo.vTMP_VENTAS_OrderComplete_Comm_DB2pos.[Calculation_Status] = 0
           THEN dbo.vTMP_VENTAS_OrderComplete_Comm_DB2pos.PreCal_Value_DB2 / 2
           ELSE dbo.vTMP_VENTAS_OrderComplete_Comm_DB2pos.PreCal_Value_DB2
       END AS Precal_IntakeDB2,
'0' as Precal_IntakeDB2_Currency,
dbo.vTMP_VENTAS_OrderComplete_Comm_Value.PreCal_Value_Currency AS Precal_IntakeValue_Currency,
dbo.vTMP_VENTAS_OrderComplete_Comm_Value.PreCal_Value AS Precal_IntakeValue,
dbo.vTMP_VENTAS_OrderComplete_Comm_DB2pos.PreCal_Value_DB3 AS Precal_IntakeDB3,
CASE
           WHEN dbo.vTMP_VENTAS_OrderComplete_Comm_DB2pos.nr_konto = '3730'
                AND dbo.vTMP_VENTAS_OrderComplete_Comm_DB2pos.[Calculation_Status] = 1
           THEN dbo.vTMP_VENTAS_OrderComplete_Comm_DB2pos.PostCal_Value_DB2 / 2
           ELSE dbo.vTMP_VENTAS_OrderComplete_Comm_DB2pos.PostCal_Value_DB2
       END AS Postcal_IntakeDB2,
'0' as Postcal_IntakeDB2_currency,
dbo.vTMP_VENTAS_OrderComplete_Comm_Value.PostCal_Value_Currency AS Postcal_IntakeValue_Currency,
dbo.vTMP_VENTAS_OrderComplete_Comm_Value.PostCal_Value AS Postcal_IntakeValue,
dbo.vTMP_VENTAS_OrderComplete_Comm_DB2pos.PostCal_Value_DB3 AS Postcal_IntakeDB3,
dbo.vTMP_VENTAS_OrderComplete_Comm_DB2pos.[Calculation_Status]
INTO #temp2
FROM 
#temp1 AS FAKT_OrderIntake
LEFT JOIN dbo.vTMP_VENTAS_OrderComplete_Comm_Value ON dbo.vTMP_VENTAS_OrderComplete_Comm_Value.nr_position = FAKT_OrderIntake.nr_position
                                        AND dbo.vTMP_VENTAS_OrderComplete_Comm_Value.nr_kontrakt = FAKT_OrderIntake.nr_kontrakt
LEFT JOIN dbo.vTMP_VENTAS_OrderComplete_Comm_DB2pos ON dbo.vTMP_VENTAS_OrderComplete_Comm_DB2pos.nr_kontrakt = FAKT_OrderIntake.nr_kontrakt
                                        AND dbo.vTMP_VENTAS_OrderComplete_Comm_DB2pos.nr_position = FAKT_OrderIntake.nr_position;


SELECT b.nr_position,
       a.nr_kontrakt,
       a.abgerechnet_dat,
       a.nr_liefnt,
       a.nr_kunde,
       a.nr_gart AS industry,
       a.erfasst,
       a.seriell,
       a.liefertermin,
       a.bez,
       RTRIM(a.Merchandise) AS Merchandise,
       a.nr_adress_k,
       a.cty,
       a.department,
       a.preis_ges_dm,
       a.preis_ges_wr,
       b.DB2,
       a.bu_id,
       a.currency,
       a.Backlogrelevant,
       a.office_reference,
	   o.Precal_IntakeValue,
	 o.Precal_IntakeDB2,
       o.Precal_IntakeDB2_Currency,
       o.Precal_IntakeValue_Currency,
	  o.Postcal_IntakeValue,
	  o.Postcal_IntakeValue_Currency,
      o.Postcal_IntakeDB2,
       o.Postcal_IntakeDB2_currency,
       o.Precal_IntakeDB3,
       o.Postcal_IntakeDB3,
       o.[Calculation_Status]

FROM dbo.vTMP_VENTAS_OrderIntake_Comm_02_BU AS a
     INNER JOIN dbo.vTMP_VENTAS_OrderIntake_Comm_03_DB2pos AS b ON a.nr_kontrakt = b.nr_kontrakt
                                                                   AND a.nr_position = b.nr_position
    INNER JOIN #temp2 AS o on a.nr_kontrakt = o.nr_kontrakt
                             AND a.nr_position = o.nr_position
WHERE(a.erfasst >= '2008-01-01');


----------------------------------------------------------------------------------------------------

/*FOXPRO_Order_Intake*/

SELECT ord_date,
       ord_no,
       division,
       industry_code,
       bu_id,
       cty,
       merchandise_id,
       descriptionofgoods,
       Salesman,
       sp_centre,
       CASE
           WHEN direct_ord = 1
           THEN 'C'
           ELSE 'T'
       END AS ordertype,
       service,
       contr_no,
       shp_date,
       contr_date,
       customer,
       province,
       pro_centre,
       maker AS supplyer,
       commodity,
       OrderValue_currency_type,
       OrderValue_in_local_currency,
       OrderValue,
       DB2_currency_type,
       DB2_in_local_currency,
       DB2,
       1 AS orderpos,
       shipped,
       'J' AS backlogrelevant,
       ord_no AS office_reference,
	  OrderValue AS Precal_IntakeValue,
	  DB2 AS Precal_IntakeDB2,
       DB2_in_local_currency AS Precal_IntakeDB2_Currency,
       OrderValue_in_local_currency AS Precal_IntakeValue_Currency,
	  '0' as Postcal_IntakeValue,
	  '0' as Postcal_IntakeValue_Currency,
       '0' AS Postcal_IntakeDB2,
       '0' AS Postcal_IntakeDB2_currency,
       '0' AS Precal_IntakeDB3,
       '0' AS Postcal_IntakeDB3,
       '0' AS [Calculation_Status]
FROM dbo.vTMP_Foxpro_OrderIntake
WHERE ord_date >= '2008-01-01'
      AND NOT(OrderValue = 1
              AND DB2 = 0); -- no canceled orders
------------------------------------------------------------------------------------

/*Local Orders_OrderIntake*/

SELECT ID,
       ProcCenterOrderNo,
       Order_Date,
       Shipment_Date,
       bu_id,
       OfficeLocation,
       AbtAusBuchKz,
       LandAusBuchKz,
       Industriebereich,
       Vorgang,
       KdNr,
       Kurs,
       LieferantNr,
       Warenbez,
       DB2,
       EK_Preis,
       VK_Wrg,
       Wert_Wrg,
       MakerComm,
       Customs,
       SubAgent,
       Freight,
       Banking,
       TravellingExp,
       Commissioning,
       Service,
       Contingencies,
       bu_type,
       LieferterminDat,
       Zahlungsbed,
       [User],
       ArtikelAusGA,
       source,
       orderpos,
       vorgang AS office_reference,
       Backlogrelevant,
	  Wert_Wrg AS Precal_IntakeValue,
	  DB2 AS Precal_IntakeDB2,
       '0' AS Precal_IntakeDB2_Currency,
       '0' AS Precal_IntakeValue_Currency,
	  '0' as Postcal_IntakeValue,
	  '0' as Postcal_IntakeValue_Currency,
       '0' AS Postcal_IntakeDB2,
       '0' AS Postcal_IntakeDB2_currency,
       '0' AS Precal_IntakeDB3,
       '0' AS Postcal_IntakeDB3,
       '0' AS [Calculation_Status]
FROM dbo.vTMP_HKGOrders_DB2
WHERE ISNUMERIC(bu_id) = 1;
------------------------------------------------------------------------------------

/*LOD Order Intake*/

SELECT *
FROM vTMP_LOD_OrderIntake;