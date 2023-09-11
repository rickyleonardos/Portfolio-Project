/* 

Cleaning Data in SQL Queries

*/

select *
from PortfolioProject.dbo.NashvilleHousing

......................................................................................................................

-- Standarized Data Format

select SaleDateConverted, CONVERT(date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SaleDate = CONVERT(date,SaleDate)

alter table NashvilleHousing
add SaleDateConverted date;

update NashvilleHousing
set SaleDateConverted = CONVERT(date,SaleDate)

......................................................................................................................

-- Populate Property Address data

select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing
--Where PropertyAddress is null
order by ParcelID

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) 
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject.dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null

......................................................................................................................

-- Breaking out Address into Individual columns (Address, City, State)

select PropertyAddress
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1) as Address,
	   SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as Address
from PortfolioProject.dbo.NashvilleHousing

alter table NashvilleHousing
add PropertySplitAddress nvarchar(255);

update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1)

alter table NashvilleHousing
add PropertySplitCity nvarchar(255);

update NashvilleHousing
set PropertySplitCIty = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))

select *
from PortfolioProject.dbo.NashvilleHousing

select PARSENAME(REPLACE(OwnerAddress, ',','.') , 3),
	   PARSENAME(REPLACE(OwnerAddress, ',','.') , 2),
	   PARSENAME(REPLACE(OwnerAddress, ',','.') , 1)
from PortfolioProject.dbo.NashvilleHousing

alter table NashvilleHousing
add OwnerSplitAddress nvarchar(255);

update NashvilleHousing
set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.') , 3)

alter table NashvilleHousing
add OwnerSplitCity nvarchar(255);

update NashvilleHousing
set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.') , 2)

alter table NashvilleHousing
add OwnerSplitState nvarchar(255);

update NashvilleHousing
set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.') , 1)

select *
from PortfolioProject.dbo.NashvilleHousing

......................................................................................................................

-- Change Y and N to Yes and NO in "Sold as Vacant" field

select distinct(SoldAsVacant),COUNT(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant,
	case
		when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
	end
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case
						when SoldAsVacant = 'Y' then 'Yes'
						when SoldAsVacant = 'N' then 'No'
						else SoldAsVacant
					end

......................................................................................................................

-- Remove Duplicates

WITH RowNumCTE AS(
select *,
	ROW_NUMBER() OVER (PARTITION BY ParcelID,
									PropertyAddress,
									SalePrice,
									SaleDate,
									LegalReference
				 ORDER BY UniqueID) row_num
from PortfolioProject.dbo.NashvilleHousing
)
select *
from RowNumCTE
where row_num > 1

select * 
from PortfolioProject.dbo.NashvilleHousing

......................................................................................................................

-- Delete Unused Columns

select * 
from PortfolioProject.dbo.NashvilleHousing

alter table PortfolioProject.dbo.NashvilleHousing
drop column PropertyAddress, OwnerAddress, TaxDistrict

alter table PortfolioProject.dbo.NashvilleHousing
drop column SaleDate


 






