-- Take a close look at our data
Select *
From [Nashville Housing Data Cleaning]..NashvilleHousing

-- Standardize date format
Select SaleDate, CONVERT(date, SaleDate) as SaleDateConverted
From [Nashville Housing Data Cleaning]..NashvilleHousing

Update [Nashville Housing Data Cleaning]..NashvilleHousing
Set SaleDate = CONVERT(date, SaleDate)

-- If it doesn't work approperly
Alter Table [Nashville Housing Data Cleaning]..NashvilleHousing
Add SaleDateConverted date

Update [Nashville Housing Data Cleaning]..NashvilleHousing
Set SaleDateConverted = CONVERT(date, SaleDate)

Select SaleDate, SaleDateConverted
From [Nashville Housing Data Cleaning]..NashvilleHousing

-- Populate PropertyAddress data
Select a.PropertyAddress, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) as PropAddr
From [Nashville Housing Data Cleaning]..NashvilleHousing a Inner Join [Nashville Housing Data Cleaning]..NashvilleHousing b
On a.[ParcelID] = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress Is Null
Order by a.ParcelID

Update a
Set a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
From [Nashville Housing Data Cleaning]..NashvilleHousing a Inner Join [Nashville Housing Data Cleaning]..NashvilleHousing b
On a.[ParcelID] = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is Null

-- Breaking out Property Address into Individual columns
Select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address1,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address2,
PropertyAddress
From [Nashville Housing Data Cleaning]..NashvilleHousing

Alter Table [Nashville Housing Data Cleaning]..NashvilleHousing
Add PropertySplitAddress nvarchar(255)

Update [Nashville Housing Data Cleaning]..NashvilleHousing
Set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1)

Alter Table [Nashville Housing Data Cleaning]..NashvilleHousing
Add PropertySplitCity nvarchar(255)

Update [Nashville Housing Data Cleaning]..NashvilleHousing
Set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

-- Breaking out Owner Address into individual columns
Select PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1),
OwnerAddress
From [Nashville Housing Data Cleaning]..NashvilleHousing

Alter Table [Nashville Housing Data Cleaning]..NashvilleHousing
Add OwnerSplitAddress nvarchar(255)

Update [Nashville Housing Data Cleaning]..NashvilleHousing
Set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 3)

Alter Table [Nashville Housing Data Cleaning]..NashvilleHousing
Add OwnerSplitCity nvarchar(255)

Update [Nashville Housing Data Cleaning]..NashvilleHousing
Set OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 2)

Alter Table [Nashville Housing Data Cleaning]..NashvilleHousing
Add OwnerSplitState nvarchar(255)

Update [Nashville Housing Data Cleaning]..NashvilleHousing
Set OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.'), 1)

-- Change Y and N to Yes and No in "Sold As Vacant" Field
Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [Nashville Housing Data Cleaning]..NashvilleHousing
Group by SoldAsVacant
Order by 2

Update [Nashville Housing Data Cleaning]..NashvilleHousing
Set SoldAsVacant = Case
                         When SoldAsVacant = 'Y' Then 'Yes'
						 When SoldAsVacant = 'N' Then 'No'
						 Else SoldAsVacant
				   End

-- Remove Duplicates
With RowNumCTE as (
Select *, ROW_NUMBER() Over (Partition By ParcelID, PropertyAddress,
                                          SalePrice, SaleDate, LegalReference
										  Order By UniqueID) row_num
From [Nashville Housing Data Cleaning]..NashvilleHousing
)

/*
Delete From RowNumCTE
Where row_num > 1
*/

Select *
From RowNumCTE
Where row_num > 1
Order By PropertyAddress

-- Delete Unused Columns
Select *
From [Nashville Housing Data Cleaning]..NashvilleHousing

Alter Table [Nashville Housing Data Cleaning]..NashvilleHousing
Drop Column PropertyAddress, OwnerAddress, SaleDate, TaxDistrict