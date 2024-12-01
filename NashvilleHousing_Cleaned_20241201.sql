/*

Cleaning Data in SQL Queries

*/


-- Read data from the main dataset
SELECT * 
FROM SQLminiproject.dbo.NashvilleHousing;


-- Create a temporary table to store data from the main dataset
CREATE TABLE #TempNashvilleHousing (
    UniqueID INT,                        
    ParcelID NVARCHAR(50),               
    LandUse NVARCHAR(100),               
    PropertyAddress NVARCHAR(255),       
    SaleDate DATETIME,                   
    SalePrice DECIMAL(18,2),             
    LegalReference NVARCHAR(255),        
    SoldAsVacant NVARCHAR(3),            
    OwnerName NVARCHAR(255),             
    OwnerAddress NVARCHAR(255),          
    Acreage DECIMAL(18,4),               
    TaxDistrict NVARCHAR(50),            
    LandValue DECIMAL(18,2),             
    BuildingValue DECIMAL(18,2),         
    TotalValue DECIMAL(18,2),            
    YearBuilt INT,                       
    Bedrooms INT,                        
    FullBath INT,                        
    HalfBath INT                         
);

-- Insert data from the main dataset into the temporary table
INSERT INTO #TempNashvilleHousing
SELECT *
FROM SQLminiproject.dbo.NashvilleHousing;


-- Verify the data in the temporary table
SELECT * 
FROM #TempNashvilleHousing;

--------------------------------------------------------------

-- Standardize Data Format

-- Select the original SaleDate column and convert it to a DATE format for previewing the data
SELECT SaleDate, CONVERT(DATE,Saledate)
FROM #TempNashvilleHousing

-- Update the SaleDate column to store only the DATE part (removing the time portion)
UPDATE #TempNashvilleHousing
SET SaleDate = CONVERT(DATE,Saledate)

-- Add a new column named SaleDateConverted to the table for storing the converted DATE values
ALTER TABLE #TempNashvilleHousing
ADD SaleDateConverted Date; 

-- Update the new SaleDateConverted column with the DATE-converted values from the SaleDate column
UPDATE #TempNashvilleHousing
SET SaleDateConverted = CONVERT(DATE,Saledate)

-- Select the new SaleDateConverted column along with the original SaleDate to verify the update
SELECT SaleDateConverted, CONVERT(DATE,Saledate)
FROM #TempNashvilleHousing


--------------------------------------------------------------

-- Populate Propety Address data

-- Select all columns from the temporary table to view the current dataset
-- Uncomment the WHERE clause to filter rows where PropertyAddress is NULL
SELECT *
FROM #TempNashvilleHousing
--WHERE PropertyAddress is null
ORDER BY ParcelID

-- Compare rows with NULL PropertyAddress values to rows with the same ParcelID
-- Use ISNULL to determine the potential replacement for NULL values in PropertyAddress
SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM #TempNashvilleHousing a
JOIN #TempNashvilleHousing b
	on a.ParcelID = b.ParcelID -- Match rows by ParcelID
	and a.[UniqueID ] <> b.[UniqueID ] -- Ensure the rows are distinct (different UniqueID)
WHERE a.PropertyAddress is null

-- Update the rows with NULL PropertyAddress values
-- Set PropertyAddress to the non-NULL value from the matching row (if available)
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM #TempNashvilleHousing a
JOIN #TempNashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null


--------------------------------------------------------------

-- Breaking out Address into Individual Column (Address, City, State)

-- Property Adress

-- This is to review the current state of PropertyAddress values
SELECT PropertyAddress
FROM #TempNashvilleHousing

-- Split the PropertyAddress column into two parts: Address and City
-- Address: Extract the substring before the first comma
-- City: Extract the substring after the first comma
SELECT
SUBSTRING (PropertyAddress, 1, CHARINDEX(',',PropertyAddress) - 1) as Address,
SUBSTRING (PropertyAddress, CHARINDEX(',',PropertyAddress) + 2, len(PropertyAddress)) as Address
FROM #TempNashvilleHousing

-- Add a new column to store the split Address part from PropertyAddress
ALTER TABLE #TempNashvilleHousing
ADD PropertySplitAddress Nvarchar(255); 

-- Update the new PropertySplitAddress column with the substring before the first comma
UPDATE #TempNashvilleHousing
SET PropertySplitAddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',',PropertyAddress) - 1)

-- Add another new column to store the split City part from PropertyAddress
ALTER TABLE #TempNashvilleHousing
ADD PropertySplitCity Nvarchar(255); 

-- Update the new PropertySplitCity column with the substring after the first comma
UPDATE #TempNashvilleHousing
SET PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',',PropertyAddress) + 2, len(PropertyAddress))

-- Select all columns from the temporary table to review the updated dataset
SELECT *
FROM #TempNashvilleHousing


-- OwnerAddress

-- This step is to review the current state of OwnerAddress values
SELECT OwnerAddress
FROM #TempNashvilleHousing

-- Split the OwnerAddress column into three components: Address, City, and State
-- The PARSENAME function is used with REPLACE to treat commas as delimiters and extract parts
SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'), 3),
PARSENAME(REPLACE(OwnerAddress,',','.'), 2),
PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
FROM #TempNashvilleHousing

-- Add a new column to store the split Address part from OwnerAddress
ALTER TABLE #TempNashvilleHousing
ADD OwnerSplitAddress Nvarchar(255); 

-- Update the new OwnerSplitAddress column with the first part (Address) from OwnerAddress
UPDATE #TempNashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3)

-- Add another new column to store the split City part from OwnerAddress
ALTER TABLE #TempNashvilleHousing
ADD OwnerSplitCity Nvarchar(255); 

-- Update the new OwnerSplitCity column with the second part (City) from OwnerAddress
UPDATE #TempNashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2)

-- Add a new column to store the split State part from OwnerAddress
ALTER TABLE #TempNashvilleHousing
ADD OwnerSplitState Nvarchar(255); 

-- Update the new OwnerSplitState column with the third part (State) from OwnerAddress
UPDATE #TempNashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)

-- Select all columns from the temporary table to review the updated dataset
SELECT *
FROM #TempNashvilleHousing


--------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant"

-- This step is to analyze the unique values in the SoldAsVacant column and their frequencies
SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant)
FROM #TempNashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

-- The CASE statement converts 'Yes' to 'Y' and 'No' to 'N', leaving other values unchanged
SELECT SoldAsVacant,
CASE WHEN SoldAsVacant = 'Yes' THEN 'Y'
	 WHEN SoldAsVacant = 'No' THEN 'N'
	 ELSE SoldAsVacant
END
FROM #TempNashvilleHousing

-- Update the SoldAsVacant column in the temporary table
-- Apply the same conditional logic to standardize the values directly in the table
UPDATE #TempNashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Yes' THEN 'Y'
	 WHEN SoldAsVacant = 'No' THEN 'N'
	 ELSE SoldAsVacant
END
FROM #TempNashvilleHousing


--------------------------------------------------------------

-- Remove Duplicates

-- Create a Common Table Expression (CTE) to assign row numbers based on specific criteria
-- This step is to identify duplicates by using ROW_NUMBER() and partitioning the data by several columns
WITH RowNumCTE AS(
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
FROM #TempNashvilleHousing
)
-- Select all records where the row number is greater than 1 (duplicates)
-- This allows to see the rows that are considered duplicates based on the partitioned columns
SELECT * 
FROM RowNumCTE
WHERE row_num > 1
ORDER BY PropertyAddress

-- Create the same CTE to assign row numbers to the data
-- This time, the goal is to delete the rows with a row number greater than 1 (duplicates)
WITH RowNumCTE AS(
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
FROM #TempNashvilleHousing
)
-- Delete the duplicate rows from the CTE based on the row number
-- This will remove the duplicate records, leaving only the first instance based on the UniqueID
DELETE
FROM RowNumCTE
WHERE row_num > 1


--------------------------------------------------------------

--Delete Unused Columns

-- Select all data from the temporary table to review the current columns and data
SELECT *
FROM #TempNashvilleHousing

-- Alter the temporary table to remove unused columns
-- In this case, we are dropping the columns: OwnerAddress, PropertyAddress, and SaleDate
-- This will clean up the table by removing columns that are no longer necessary for analysis or processing
ALTER TABLE #TempNashvilleHousing
DROP COLUMN OwnerAddress, PropertyAddress, SaleDate


