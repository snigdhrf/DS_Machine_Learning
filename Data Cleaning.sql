/*

Cleaning Data in SQL Queries

*/

SELECT * 
FROM 
PortfolioProject.. NashvilleHousing

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format

SELECT SaleDate 
FROM PortfolioProject.. NashvilleHousing

ALTER TABLE NashvilleHousing
ADD SaleDateConverted DATE

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(DATE,SaleDate)

SELECT SaleDateConverted 
FROM PortfolioProject.. NashvilleHousing


 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

SELECT PropertyAddress 
FROM PortfolioProject.. NashvilleHousing
WHERE PropertyAddress IS NULL

SELECT * FROM 
PortfolioProject.. NashvilleHousing
ORDER BY ParcelID


SELECT a.ParcelID, a.PropertyAddress, 
	   b.ParcelID, b.PropertyAddress,
	   ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject.. NashvilleHousing a
JOIN PortfolioProject.. NashvilleHousing b
	   ON
	   a.ParcelID =  b.ParcelID AND
	   a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL


UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject.. NashvilleHousing a
JOIN PortfolioProject.. NashvilleHousing b
	   ON
	   a.ParcelID =  b.ParcelID AND
	   a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL


--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress 
FROM 
PortfolioProject.. NashvilleHousing

--SUBSTRING : extracts some characters from a string 
--SUBSTRING(string, start, length)
--CHARINDEX : searches for a substring in a string, and returns the position
--CHARINDEX(substring, string)


SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS ADDRESS1,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) AS ADDRESS2
FROM 
PortfolioProject.. NashvilleHousing


ALTER TABLE NashvilleHousing
	ADD PropertySplitAddress VARCHAR(255)

UPDATE NashvilleHousing
	SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 

ALTER TABLE NashvilleHousing
	ADD PropertySplitCity VARCHAR(255)

UPDATE NashvilleHousing
	SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) 


SELECT * FROM 
PortfolioProject.. NashvilleHousing

-- PARSENAME : Returns the specified part of an object name
-- PARSENAME ('object_name' , object_piece )

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.NashvilleHousing
-- PARSENAME works backwards on the object

ALTER TABLE NashvilleHousing
	Add OwnerSplitAddress Nvarchar(255)

Update NashvilleHousing
	SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
	Add OwnerSplitCity Nvarchar(255)

Update NashvilleHousing
	SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
	Add OwnerSplitState Nvarchar(255)

Update NashvilleHousing
	SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From 
PortfolioProject.dbo.NashvilleHousing


--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(SoldAsVacant),
		COUNT(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant, 
	CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END
FROM PortfolioProject.. NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant =
	CASE 
	WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END



-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.. NashvilleHousing
--order by ParcelID
)

SELECT *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From PortfolioProject.. NashvilleHousing



---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select *
From PortfolioProject.. NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate


-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------