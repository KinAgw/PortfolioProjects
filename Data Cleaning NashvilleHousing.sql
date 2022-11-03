SELECT *
FROM [Portfolio Project].dbo.NashvilleHousing


--SaleDate


SELECT SaleDateConverted,CONVERT(Date,SaleDate)
FROM [Portfolio Project].dbo.NashvilleHousing


UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


--POPULATE PROPERTY ADDRESS DATA

SELECT *
FROM [Portfolio Project].dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID


SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [Portfolio Project].dbo.NashvilleHousing a
JOIN [Portfolio Project].dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
	Where a.PropertyAddress is null


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM [Portfolio Project].dbo.NashvilleHousing a
JOIN [Portfolio Project].dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
	Where a.PropertyAddress is null


	
--BREAKING OUT ADDRESS INTO INDIVIDUAL COLUMNS (ADDRESS, CITY, STATE)



SELECT PropertyAddress
FROM [Portfolio Project].dbo.NashvilleHousing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1,CHARINDEX(',', PropertyAddress)-1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address

FROM [Portfolio Project].dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);


UPDATE NashvilleHousing
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);


UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING (PropertyAddress,CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

UPDATE  NashvilleHousing
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)





SELECT *
FROM [Portfolio Project].dbo.NashvilleHousing



SELECT OwnerAddress
FROM [Portfolio Project].dbo.NashvilleHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', ',') , 1)
,PARSENAME(REPLACE(OwnerAddress, ',', ',') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', ',') , 3)


FROM [Portfolio Project].dbo.NashvilleHousing




ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);


UPDATE NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', ','), 1)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);


UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', ',') , 2)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);


UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', ',') , 3)



SELECT *
FROM [Portfolio Project].dbo.NashvilleHousing



--SOLD AS VACANT FIELD




SELECT Distinct (SoldAsVacant), COUNT(SoldAsVacant)
FROM [Portfolio Project].dbo.NashvilleHousing
GROUP by (SoldAsVacant)
order by 2




SELECT SoldAsVacant
, CASE When SoldAsVacant = 'Y' Then 'Yes'
      When SoldAsVacant = 'N' Then 'No'
	  Else SoldAsVacant
	  End
 FROM [Portfolio Project].dbo.NashvilleHousing



 UPDATE NashvilleHousing
 SET SoldAsVacant = CASE When SoldAsVacant = 'Y' Then 'Yes'
      When SoldAsVacant = 'N' Then 'No'
	  Else SoldAsVacant
	  End



--REMOVE DUPLICATES

WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
			 PropertyAddress,
			 SalePrice,
			 SaleDate,
			 LegalReference
			 ORDER BY
			 UniqueID
			 ) row_num

FROM [Portfolio Project].dbo.NashvilleHousing
--order by ParcelID
)
SELECT *
FROM RowNumCTE
Where row_num > 1
--order by PropertyAddress




 SELECT *
 FROM [Portfolio Project].dbo.NashvilleHousing




--DELETE UNUSED COLUMNS



SELECT *
 FROM [Portfolio Project].dbo.NashvilleHousing

 ALTER TABLE [Portfolio Project].dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict,PropertyAddress


ALTER TABLE [Portfolio Project].dbo.NashvilleHousing
DROP COLUMN SaleDate