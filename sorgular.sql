-- KitapID verildiğine o kitabı alan kişiye ait verileri getiren function

create function GetBookInfo
(
    @BookID int
)
returns table
as
return
(
    select B.Title as KitapAdi, U.UserName as KullaniciAdi, U.Email, BB.BorrowDate, BB.ReturnDate
    from BorrowedBooks BB
    INNER JOIN Users U on BB.UserID = U.UserID
    INNER JOIN Books B on BB.BookID = B.BookID
    where BB.BookID = @BookID
);

-- Belli kategoriye ait kitapları sayfa sayısına göre sıralama

select B.Title, C.CategoryName, B.PageNumber
from BookCategories BC
join Categories C on BC.CategoryID = C.CategoryID
join Books B on BC.BookID = B.BookID
where C.CategoryName = 'Mystery'

-- Kategorilerde bulunan kitapların sayfa sayıları toplamı 150000 den fazla olan kategoriler sıralandı

select C.CategoryName, sum(B.PageNumber) as ToplamSayfaSayisi
from Categories C
join BookCategories BC on C.CategoryID = BC.CategoryID
join Books B on BC.BookID = B.BookID
group by
C.CategoryName
having 
sum(B.PageNumber) > 150000 
order by
ToplamSayfaSayisi desc

-- Herhangi bir kullanıcının en sevdiği kitap türünü gösterildi

declare @UserID int

select top 1 C.CategoryName, count(*) as ToplamSayi
from BorrowedBooks BB
join BookCategories BC ON BB.BookID = BC.BookID
join Categories C ON BC.CategoryID = C.CategoryID
where BB.UserID = @UserID
group by C.CategoryName
order by ToplamSayi desc;

-- with kullanarak en çok kitap alan ilk 10 kullanıcı listelendi

with EnCokOdunc as (
    select top 10 UserID, count(*) as OduncAlinanKitap
    from BorrowedBooks
    group by UserID
    order by OduncAlinanKitap desc
)
select U.UserName, U.Email, ECO.OduncAlinanKitap
from Users U
join EnCokOdunc ECO on U.UserID = ECO.UserID;
