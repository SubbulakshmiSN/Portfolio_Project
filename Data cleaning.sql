--cleaning Messy data---

--#1.Importing dataset
select * from Portfolio_Project..Nashvile_Housing

--#2.standardize sale date format

select SaleDate , convert(date, SaleDate)
from Portfolio_Project..Nashvile_Housing

update Nashvile_Housing
set SaleDate = CONVERT(date, SaleDate)  --it doesnt work, the table wont get updated

alter table Nashvile_Housing
add Sales_Date date;

update Nashvile_Housing
set Sales_Date = CONVERT(date, SaleDate)


-- #3.Populate property address data

select * 
from Portfolio_Project..Nashvile_Housing
where PropertyAddress is null
order by ParcelID

select a. ParcelID, a. PropertyAddress, b.ParcelID, b.PropertyAddress , isnull(a. PropertyAddress,b. PropertyAddress)
from Portfolio_Project..Nashvile_Housing a
join Portfolio_Project..Nashvile_Housing b
 on a .ParcelID = b. ParcelID
 and a .[UniqueID] <> b. [UniqueID]
 where a. PropertyAddress is null

update a
set PropertyAddress = isnull(a. PropertyAddress,b. PropertyAddress)
from Portfolio_Project..Nashvile_Housing a
join Portfolio_Project..Nashvile_Housing b
 on a .ParcelID = b. ParcelID
 and a .[UniqueID] <> b. [UniqueID]
 where a. PropertyAddress is null

 select PropertyAddress
 from Portfolio_Project..Nashvile_Housing


 --#4.Breaking out address into individual columns(address, city,state)

 select
 SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)) as Address,
 CHARINDEX(',',PropertyAddress)
 from Portfolio_Project..Nashvile_Housing

 select
 SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address
 from Portfolio_Project..Nashvile_Housing

 select
 SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
 SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress)) as Address
 from Portfolio_Project..Nashvile_Housing

 alter table Nashvile_Housing
add Property_Address nvarchar(255);

update Nashvile_Housing
set Property_Address=SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 

alter table Nashvile_Housing
add Property_City nvarchar(255);

update Nashvile_Housing
set Property_City = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress))

select* 
from Portfolio_Project..Nashvile_Housing

--#5.to change owner address

select
parsename(replace(owneraddress, ',','.'),3),
parsename(replace(owneraddress, ',','.'),2),
parsename(replace(owneraddress, ',','.'),1)
from Portfolio_Project..Nashvile_Housing

alter table Nashvile_Housing
add Owner_Address nvarchar(255);

update Nashvile_Housing
set Owner_Address = parsename(replace(owneraddress, ',','.'),3)

alter table Nashvile_Housing
add Owner_City nvarchar(255);

update Nashvile_Housing
set Owner_City = parsename(replace(owneraddress, ',','.'),2)

alter table Nashvile_Housing
add Owner_State nvarchar(255);

update Nashvile_Housing
set Owner_State = parsename(replace(owneraddress, ',','.'),1)


--#6.change y and n to yes and no in sold as vacant field

select distinct (SoldAsVacant)
from Portfolio_Project..Nashvile_Housing

select distinct (SoldAsVacant), count(SoldAsVacant)
from Portfolio_Project..Nashvile_Housing
group by SoldAsVacant
order by 2


select SoldAsVacant,
 case when SoldAsVacant ='Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end
from Portfolio_Project..Nashvile_Housing


alter table Nashvile_Housing
add Sold_As_Vacant varchar(50);

update Nashvile_Housing
set Sold_As_Vacant = case when SoldAsVacant ='Y' then 'Yes'
     when SoldAsVacant = 'N' then 'No'
	 else SoldAsVacant
	 end


--#7.to delete column

alter table Portfolio_Project..Nashvile_Housing
drop column SoldAsVacant

select * from Portfolio_Project..Nashvile_Housing


--#8.Remove duplicates using cte

with RownumCTE AS(
select * ,
 row_number() over(
 partition by ParcelID,
              PropertyAddress,
			  SalePrice,
			  SaleDate,
			  LegalReference
			  order by 
			     UniqueID 
				 ) Row_num
         
from Portfolio_Project..Nashvile_Housing
 )
  DELETE from RownumCTE
 where Row_num > 1

 --#9.DELETE unused column
 alter table Portfolio_Project..Nashvile_Housing
drop column PropertyAddress,
            SaleDate,
			OwnerAddress


 alter table Portfolio_Project..Nashvile_Housing
drop column TaxDistrict

--#10.view the clean data
select * from Portfolio_Project..Nashvile_Housing






 


