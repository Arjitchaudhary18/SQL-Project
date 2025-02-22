select * from tenancy_histories
select * from profiles 
select * from houses
select * from addresses
select * from Referrals
select * from employment_details



--Solution to Question 1
SELECT TOP 10 th.profile_id, 
            CONCAT(first_name , '', last_name ) AS full_name , p.phone 
			FROM Tenancy_histories th
			JOIN Profiles p ON th.profile_id=p.profile_id
			WHERE  th.move_out_date IS NOT NULL 
			ORDER BY DATEDIFF(day ,th.move_in_date, th.move_out_date)DESC;





-- Solution to Question 2
SELECT CONCAT(first_name , '', last_name ) AS full_name ,p.email_id , p.phone 
FROM Profiles p
JOIN Tenancy_histories th ON p.profile_id=th.profile_id
WHERE p.marital_status='Y' AND th.rent>9000;


--0r 

--Solution to Question 2 (using sub query) 
SELECT CONCAT(p.first_name, '', p.last_name) AS full_name,  p.email_id,  p.phone
FROM Profiles p
WHERE p.marital_status = 'Y' 
    AND p.profile_id IN (
        SELECT  th.profile_id
        FROM Tenancy_histories th
        WHERE th.rent > 9000 );


	 --Solution to Question 3 

	 select p.profile_id, CONCAT(P.first_name,'', p.last_name) As 
	 Full_name ,p.phone, p.email_id, p.city,th.house_id, th.move_in_date, th.move_out_date , th.rent,
	     (SELECT COUNT (ref_id)FROM Referrals WHERE Ref_ID=p.profile_id)AS total_referrals, 
		 ed.latest_employer, ed.occupational_category 
	 FROM Profiles p
	 JOIN Tenancy_histories th  ON p.profile_id = th.profile_id
	 JOIN Employment_details ed ON p.profile_id = ed.profile_id   
	 WHERE (p.city='Banglore' OR p.city= 'Pune') AND th.move_in_date BETWEEN '2015-01-01' AND '2016-01-31'
	 ORDER BY th.rent DESC;



	 --Solution to Question 4

	 SELECT 
	     CONCAT(p.first_name, '', p.last_name) AS Full_name,
		 p.Email_id,
		 p.phone ,
		 p.referral_code ,
		 SUM(r.referrer_bonus_amount) AS Total_Bonus_Amount
	FROM profiles p
	JOIN Referrals r ON p.profile_id=r.referral_valid
	WHERE r.referral_valid=1
	GROUP BY p.profile_id, p.first_name, p.last_name, p.email_id, p.phone, p.referral_code
	HAVING COUNT (r.ref_id)>1;



	--- Solution to Question 5 
	SELECT city , sum (rent) AS total_rent
	FROM Tenancy_histories th
	JOIN Profiles p ON th.profile_id = p.profile_id
	GROUP BY city WITH ROLLUP;



	----Solution to Question 6

	CREATE VIEW  vw_tenant AS 
    SELECT  p.profile_id , th.rent , th.move_in_date , h.house_type, h.Beds_vacant , a.description, a.city
	From Tenancy_histories th 
	JOIN Profiles p ON th.profile_id=p.profile_id
	JOIN Houses h ON th.house_id=h.house_id
	JOIN Addresses a ON h.house_id=a.house_id
	WHERE th.move_in_date>= '2015-04-30' AND h.beds_vacant >0 ;


	SELECT * FROM vw_tenant


	--- Solution to Question 7
	UPDATE Referrals
	SET valid_till= DATEADD(month, 1,valid_till)
	WHERE ref_ID IN(
	   SELECT ref_ID
	   FROM Referrals
	   GROUP BY ref_ID
	   HAVING COUNT(ref_id)>1
	   );
	   SELECT * FROM Referrals



	--Solution to Question 8

Select p.profile_id,concat (p.first_name, '',p.last_name)As full_name, p.phone,
	CASE 
	    When th.rent> 10000 Then ' Grade A'
	    When th.rent BETWEEN 7500 AND 10000 Then ' Grade B'
	    Else 'Grade C'
	 END AS customer_segment 
	 FROM Tenancy_histories th
	 JOIN profiles p ON th.profile_id=p.profile_id;


	 --Solution to Question 9 
	 SELECT CONCAT (p.first_name, '',p.last_name) AS full_name, p.phone, a.city , h.*
	 FROM Profiles p
	 JOIN Tenancy_histories th  ON p.profile_id= th.profile_id
	 JOIN Houses h ON h.house_id= h.house_id
	 JOIN Addresses a ON h.house_id=a.house_id
	 WHERE p.profile_id NOT IN (
	       SELECT Ref_id
		   FROM Referrals
		   );



	--solution to question 10 

SELECT * 
FROM Houses
WHERE (bed_count - beds_vacant) = 
(SELECT MAX(bed_count - beds_vacant)
 FROM Houses
    );