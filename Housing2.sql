/******  1. cleaning the data ******/
SELECT 
  * 
FROM 
  [Housing Data].[dbo].[NashvilleHousing] -- date format
sELECT 
  convert (date, saledate) 
FROM 
  [NashvilleHousing] 
update 
  NashvilleHousing 
set 
  saledate =;
alter table 
  NashvilleHousing 
add 
  saledateconvertd date;
update 
  NashvilleHousing 
set 
  saledateconvertd = convert (date, saledate) -----------
  --populate property adress
select 
  a.ParcelID, 
  a.propertyaddress, 
  c.ParcelID, 
  c.propertyaddress 
from 
  NashvilleHousing A 
  join NashvilleHousing C on a.ParcelID = c.ParcelID 
  and a.[UniqueID ] <> c.[UniqueID ] 
where 
  a.propertyaddress is null 
update 
  a 
set 
  propertyaddress = ISNULL (
    a.propertyaddress, c.propertyaddress
  ) 
from 
  NashvilleHousing A 
  join NashvilleHousing C on a.ParcelID = c.ParcelID 
  and a.[UniqueID ] <> c.[UniqueID ] 
where 
  a.propertyaddress is null --------------- 
  ---BREAKING DOWN THE propertyaddress---
SELECT 
  * 
FROM 
  [Housing Data].[dbo].[NashvilleHousing] 
SELECT 
  SUBSTRING (
    propertyaddress, 
    1, 
    CHARINDEX(',', PropertyAddress)-1
  ) as adress, 
  SUBSTRING (
    propertyaddress, 
    CHARINDEX(',', PropertyAddress)+ 1, 
    LEN(PropertyAddress)
  ) as adress 
FROM 
  [Housing Data].[dbo].[NashvilleHousing] 
ALTER TABLE 
  [Housing Data].[dbo].[NashvilleHousing] 
ADD 
  PropertySPLITAddress NVARCHAR(255) 
UPDATE 
  [Housing Data].[dbo].[NashvilleHousing] 
SET 
  PropertySPLITAddress = SUBSTRING (
    propertyaddress, 
    1, 
    CHARINDEX(',', PropertyAddress)-1
  ) 
ALTER TABLE 
  [Housing Data].[dbo].[NashvilleHousing] 
ADD 
  PropertySPLITCITY NVARCHAR(255) 
UPDATE 
  [Housing Data].[dbo].[NashvilleHousing] 
SET 
  PropertySPLITCITY = SUBSTRING (
    propertyaddress, 
    CHARINDEX(',', PropertyAddress)+ 1, 
    LEN(PropertyAddress)
  ) 
SELECT 
  PARSENAME(
    REPLACE (OwnerAddress, ',', '.'), 
    3
  ), 
  PARSENAME(
    REPLACE (OwnerAddress, ',', '.'), 
    2
  ), 
  PARSENAME(
    REPLACE (OwnerAddress, ',', '.'), 
    1
  ) 
FROM 
  [Housing Data].[dbo].[NashvilleHousing] 
ALTER TABLE 
  [Housing Data].[dbo].[NashvilleHousing] 
ADD 
  OwnerAddressSTREET NVARCHAR(255) 
UPDATE 
  [Housing Data].[dbo].[NashvilleHousing] 
SET 
  OwnerAddressSTREET = PARSENAME(
    REPLACE (OwnerAddress, ',', '.'), 
    3
  ) 
ALTER TABLE 
  [Housing Data].[dbo].[NashvilleHousing] 
ADD 
  OwnerAddresscCITY NVARCHAR(255) 
UPDATE 
  [Housing Data].[dbo].[NashvilleHousing] 
SET 
  OwnerAddresscCITY = PARSENAME(
    REPLACE (OwnerAddress, ',', '.'), 
    2
  ) 
ALTER TABLE 
  [Housing Data].[dbo].[NashvilleHousing] 
ADD 
  OwnerAddressSTATE NVARCHAR(255) 
UPDATE 
  [Housing Data].[dbo].[NashvilleHousing] 
SET 
  OwnerAddressSTATE = PARSENAME(
    REPLACE (OwnerAddress, ',', '.'), 
    1
  ) ----- CHANGE y AND N TO YES AND NO
SELECT 
  SoldAsVacant, 
  CASE WHEN SoldAsVacant = 'N' THEN 'NO' WHEN SoldAsVacant = 'Y' THEN 'YES' ELSE SoldAsVacant END 
FROM 
  [Housing Data].[dbo].[NashvilleHousing] 
UPDATE 
  [Housing Data].[dbo].[NashvilleHousing] 
SET 
  SoldAsVacant = CASE WHEN SoldAsVacant = 'N' THEN 'NO' WHEN SoldAsVacant = 'Y' THEN 'YES' ELSE SoldAsVacant END 
SELECT 
  DISTINCT (SoldAsVacant), 
  COUNT(SoldAsVacant) 
FROM 
  [Housing Data].[dbo].[NashvilleHousing] 
GROUP BY 
  SoldAsVacant 
ORDER BY 
  2 ---- REMOVE DUP---
  WITH ROWNUMCTE AS(
    SELECT 
      *, 
      ROW_NUMBER() OVER(
        PARTITION BY PARCElID, 
        propertyaddress, 
        SALEPRICE, 
        SALEDATE, 
        LEGALREFERENCE 
        ORDER BY 
          UNIQUEID
      ) ROW_NUM 
    FROM 
      [Housing Data].[dbo].[NashvilleHousing]
  ) --   ORDER BY  PARCElID      
SELECT 
  * 
FROM 
  ROWNUMCTE 
WHERE 
  ROW_NUM > 1 --ORDER BY  propertyaddress  
  ----------------- DELETE THE UNUSED COL
SELECT 
  * 
FROM 
  [Housing Data].[dbo].[NashvilleHousing] 
ALTER TABLE 
  [Housing Data].[dbo].[NashvilleHousing] 
drop 
  column owneraddress, 
  taXdistrict, 
  propertyaddress, 
  saledate
