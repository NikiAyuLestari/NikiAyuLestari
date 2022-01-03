#Change date format in column SaleDate

select SaleDate, convert(date, SaleDate)
from dbo.Nashville
alter table Nashville
add SaleDateConverted Date
update Nashville
set SaleDateConverted = convert(Date, SaleDate)
alter table Nashville
drop column SaleDate

#completing Property Address data

select * from Nashville
order by ParcelID
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull (a.PropertyAddress, b.PropertyAddress)
from Nashville a
Join Nashville b on a.ParcelID = b.ParcelID
and a.UniqueID <> b.uniqueID
where a.PropertyAddress is null

update a
set PropertyAddress = isnull (a.PropertyAddress, b.PropertyAddress)
from Nashville a
Join Nashville b on a.ParcelID = b.ParcelID
and a.UniqueID <> b.uniqueID
where a.PropertyAddress is null

#Change Y and N to Yes and No

select SoldAsVacant, case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end
from Nashville

update Nashville
set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end

#Split Property Address into Address, City

select substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1 ),
substring(PropertyAddress, charindex(',', PropertyAddress) +1, len(propertyaddress))
from Nashville
alter table Nashville
add PropertyAddress1 Nvarchar(255)
go
update Nashville
set PropertyAddress1 = substring(PropertyAddress, 1, charindex(',', PropertyAddress) -1 )
alter table Nashville
add PropertySplitCity Nvarchar (255)
go
update Nashville
set PropertySplitCity = substring(PropertyAddress, charindex(',', PropertyAddress) +1, len(propertyaddress))

#Split Owner Address into Address, City, State

select OwnerAddress from Nashville
select parsename(replace(OwnerAddress,',','.'),1), 
parsename(replace(OwnerAddress,',','.'),2),
parsename(replace(OwnerAddress,',','.'),3)
from Nashville

alter table Nashville
add OwnerAddress1 Nvarchar(255)
go
update Nashville
set OwnerAddress1 = parsename(replace(OwnerAddress,',','.'),3)
alter table Nashville
add OwnerCity Nvarchar (255)
go
update Nashville
set OwnerCity = parsename(replace(OwnerAddress,',','.'),2)
alter table Nashville
add OwnerState Nvarchar (255)
go
update Nashville
set OwnerState = parsename(replace(OwnerAddress,',','.'),1)

#Delete unused column

alter table Nashville
drop column PropertyAddress, PropertySplit, OwnerSplit, OwnerAddress
alter table Nashville
drop column OwnerSplitAddress,PropertySplitAddress, OwnerSplitCity
alter table Nashville
drop column OwnerSplitState

#check the result
select* from Nashville
