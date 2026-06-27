-- TẠO DATABASE
CREATE DATABASE Project_Makerting

-- SỬ DỤNG DATABASE
USE Project_Makerting_new

-- SỬ DỤNG BẢNG
SELECT * FROM Marketing;

-- DATA MINING 

-- Vấn đề đặt ra: Nhiều chiến dịch "đốt tiền" mà không tạo ra doanh thu tương ứng

/* 
- 1. Ngân sách lớn nhưng doanh thu không đạt kỳ vọng?
- **Có phải một số kênh đang tiêu tốn quá nhiều ngân sách nhưng không hiệu quả?**
- **Kênh nào có ROAS thấp nhất?** 
*/

-- ROAS của các kênh 
SELECT Channel,SUM(Total_Revenue) AS Total_Revenue,SUM(Budget) AS Budget ,SUM(Total_Revenue)/SUM(Budget) AS ROAS,
(SELECT SUM(Budget) FROM Marketing) AS Total_Budget_Company,(SUM(Budget) * 100.0 / (SELECT SUM(Budget) FROM Marketing)) AS Budget_Percentage,
(SELECT SUM(Total_Revenue) FROM Marketing) AS Total_Revenue,
(SELECT SUM(Total_Revenue) * 100.0/(SELECT SUM(Total_Revenue) FROM Marketing)) AS Revenue_Percentage
FROM Marketing
GROUP BY Channel
ORDER BY Budget DESC

-- Những kênh có nhiều chiến dịch lỗ nhất
SELECT Channel,AVG(Budget) AS AVG_Budget,COUNT(Campaign_ID) AS Total_Campaign,AVG(ROAS) AS AVG_Roas FROM Marketing
WHERE ROAS < 1
GROUP BY Channel
ORDER BY COUNT(Campaign_ID) DESC

-- TOP 10 chiến dịch bị lỗ (Nguy hiểm)
SELECT TOP 10 *  FROM Marketing
WHERE ROAS < 1
ORDER BY ROAS ASC



/* Insights:
1.Facebook và TikTok đang có Roas thấp nhất so với mặt bằng chung ROAS <= 2

2.Ngân sách của Facebook chiếm phần trăm chi phí của doanh nghiệp là 19,61% nhưng ko tạo ra hiệu quả
trong khi đó ngân sách của Google Ads chiếm phần trăm chí phí của doanh nghiệp 19.26% nhưng hiệu qua mang lại cao hơn rất nhiều
so với Facebook

3. TikTok và Facebook là 2 kênh duy nhất có %Doanh Thu < %Chi Phi

4.Linkedln có tổng số chiến dịch bị lỗ cao nhất (24 chiến dịch) nhưng chi phí bỏ ra thấp hơn Tiktok (19 Chiến dịch) 

5.TOP 10 Chiến dịch bị lỗ cao nhất tập trung nhiều vào kênh TikTok (5 chiến dịch)
*/


/*
2. Tỷ lệ chuyển đổi từ quảng cáo thấp – Vì sao?

- Click nhiều nhưng không ra đơn – Nguyên nhân từ đâu?
- Landing page có vấn đề hay nhóm khách hàng mục tiêu chưa đúng?
*/

SELECT * FROM Marketing

-- Đo lường tỷ lệ chuyển đổi thực tế (CVR)
SELECT Channel,SUM(Conversions) AS Conversions, SUM(Clicks) AS Clicks, SUM(Conversions) * 100.0/SUM(Clicks) AS CVR 
FROM Marketing
GROUP BY Channel
ORDER BY CVR DESC

-- Landing page có vấn đề không? (Phân tích tỷ lệ thoát)
SELECT
    Channel,
    ROUND(SUM(Bounce_Rate * Clicks) / SUM(Clicks), 2) AS BounceRate_Weighted,
    SUM(Conversions) * 100.0/SUM(Clicks) AS CVR 
    
FROM Marketing
GROUP BY Channel
ORDER BY BounceRate_Weighted DESC;


-- Targeting có đúng không? (Đối tượng khách hàng)
SELECT
    Channel,
    ROUND(SUM(Budget) / SUM(Clicks), 2)                 AS CPC,
    ROUND(SUM(Budget) / NULLIF(SUM(Conversions), 0), 2) AS cost_per_conversion,
    ROUND(SUM(Conversions) * 100.0 / SUM(Clicks), 2)    AS CVR,
    ROUND(SUM(Total_Revenue) / NULLIF(SUM(Conversions), 0), 2) AS revenue_per_conversion
FROM Marketing
GROUP BY Channel
ORDER BY CPC DESC,cost_per_conversion DESC,CVR DESC

-- Chiến dịch nào đang kéo sai người
SELECT TOP 15
    Campaign_ID,
    Channel,
    Budget,
    Clicks,
    Conversions,
    ROUND(Budget * 1.0 / NULLIF(Clicks, 0), 2)          AS cpc_actual,
    ROUND(Budget * 1.0 / NULLIF(Conversions, 0), 2)     AS cost_per_conversion,
    ROUND(Conversions * 100.0 / NULLIF(Clicks, 0), 2)   AS cvr
FROM Marketing
WHERE Conversions > 0
  AND (Budget * 1.0 / Clicks) < (
        SELECT AVG(Budget * 1.0 / NULLIF(Clicks, 0)) FROM Marketing
      )                          -- CPC thấp hơn trung bình
ORDER BY cost_per_conversion DESC

SELECT * FROM Marketing


/* Insights:
1. So sánh với BenchMark ngành
- TikTok (5,34%): Vượt xa benchmark ngành (1.4–2.3%). Có tỷ lệ chuyển đổi cao so với tiêu chuẩn ngành
- Linkedln (6.11%): Là kênh có tỷ lệ chuyển đổi cao nhất và có tỷ lệ chuyển đổi cao hơn so với benchmark ngành (2–6.1%)
- Facebook (5.70%): Benchmark ngành (5–8.95%) nằm trong dải thấp của Benchmark ngành, cần có nhiều cải thiện thêm
- Google (5.29%): Trong dải benchmark (3.68–7.52%) nhưng chưa đạt mức tốt (7.52%)
- Email (5.45%):  Ổn, nằm trong dải benchmark (2–8%)

2. Kết hợp giữa CVR và BounceRate cho thấy rằng landing-page không phải là nguyên nhân dẫn đến ROAS Thấp

3.Các kênh có đang xác định đúng đối tượng cũng như là chi phí bỏ ra trong một cú click có cao mà ko đạt được mục đích hay không ?  
- Linkedln: xác định đối tượng đúng với thị trường nhất (CPC Rẻ, CVR cao nhất, Cost_per_conversion thấp)
- Google: Google có CPC rẻ nhất nhưng tỷ lệ chuyển đổi chưa cao cần xem lại keyword targeting.
- TikTok: Đang là kênh cần chi ra nhiều tiền nhất với CPC cao đứng thứ 2 toàn bộ dataset nhưng CVR lại thấp - tức là phải tiêu nhiều tiền
mới có 1 đơn hàng

4. CAMP_350 (Google), CAMP_8 (TikTok), CAMP_494 (Google) có Cost/Conv từ $400K–$618K 
trong khi Revenue/Conv trung bình chỉ ~$35K → đang lỗ nặng trên từng đơn hàng.
*/


/*
3. Phân tích hiệu suất từng kênh quảng cáo:
- Facebook Ads hay Google Ads hiệu quả hơn?
- TikTok Ads có lợi thế với khách hàng trẻ tuổi không?
- Email Marketing có giữ chân khách hàng cũ không?
*/

SELECT Channel,SUM(Total_Revenue) AS Total_Revenue,SUM(Budget) AS Budget ,SUM(Total_Revenue)/SUM(Budget) AS ROAS,
(SELECT SUM(Budget) FROM Marketing) AS Total_Budget_Company,(SUM(Budget) * 100.0 / (SELECT SUM(Budget) FROM Marketing)) AS Budget_Percentage,
(SELECT SUM(Total_Revenue) FROM Marketing) AS Total_Revenue,
(SELECT SUM(Total_Revenue) * 100.0/(SELECT SUM(Total_Revenue) FROM Marketing)) AS Revenue_Percentage
FROM Marketing
GROUP BY Channel
ORDER BY Budget DESC

SELECT
    Channel,
    ROUND(SUM(Budget) / SUM(Clicks), 2)                 AS CPC,
    ROUND(SUM(Budget) / NULLIF(SUM(Conversions), 0), 2) AS cost_per_conversion,
    ROUND(SUM(Conversions) * 100.0 / SUM(Clicks), 2)    AS CVR,
    ROUND(SUM(Total_Revenue) / NULLIF(SUM(Conversions), 0), 2) AS revenue_per_conversion
FROM Marketing
GROUP BY Channel
ORDER BY CPC DESC,cost_per_conversion DESC,CVR DESC


/*
1. So sánh hiệu quả giữa các kênh 
- Google (ROAS = 2.2) hiệu quả hơn so với Facebook (ROAS = 1.91) với CPC của Google thấp hơn so với FaceBook 
và Cost_Per_Conversion của google thấp hơn so với FaceBook. Tuy nhiên CVR của Facebook(CVR = 5.7) nhỉnh hơn môt xíu so với Google (CVR = 5.29)

- Linkedln và Email là 2 kênh đang chiếm nhiều chi phí nhất của doanh nghiệp, Linkedln có (ROAS = 2.13) thấp hơn một xíu so với (ROAS = 2.19) của Email
Nhưng cả 2 kênh đều đang mang lại tính hiệu tích cực cho doanh nghiệp với chi phí một lượt click của Email và Linkedln thấp hơn so với Facebook
cũng như là TikTok và tỷ lệ chuyển đổi CVR cao lần lượt Linkedln(CVR = 6.11) và Email (CVR = 5.45)

2. TikTok Ads có lợi thế với khách hàng trẻ tuổi không?
- Hiện tại TikTok đang là kênh tốn nhiều chi phí nhất cũng như là chi phí bỏ ra cho một clicks rất cao nhưng CVR mang lại không hiệu quả
chỉ được CVR = 5.34 Qua đó cho ta thấy rằng mặc dù TikTok có nhiều người trẻ tuổi sử dụng nhưng khả năng tạo ra đơn hàng cho Doanh nghiệp không được
hiệu quả cho lắm.

3. Email Marketing có giữ chân khách hàng cũ không ? 
- Nhin chung tỷ lệ giữ chân khách hàng của Email rất tốt chúng ta có thể nhìn vào CVR của 5 kênh thì có thể CVR của Email đang cao thứ 3 với CVR 
= 5.45 gần ngang bằng Facebook với CVR = 5.7 qua đó cho chúng ta thấy rằng Email Đang là kênh có thể giữ chân khách hàng cũ rất tốt

*/


/*
4. Đề xuất chiến lược tối ưu Marketing:
- Nên tăng ngân sách cho kênh nào?

- Chiến dịch nào cần cắt giảm hoặc tối ưu lại?

- Cách cải thiện ROAS để đạt tối thiểu 3.5?
*/

/*
1. Nên tăng ngân sách cho kênh nào?
- Nhìn tổng quan ra chúng ta nên tập trung tăng ngân sách cho Linkedln bởi vì tỷ lệ chuyển đổi CVR của kênh này cao cũng như là cost_per_conversion và
CPC của kênh này thấp so với 4 kênh còn lại. Ngoài ra Email và Google cũng là 2 kênh chúng ta nên đầu tư thêm ngân sách bởi vì chỉ số ROAS của
Email cũng như Google rất cao lần lượt là 2.20 và 2.19

2.Chiến dịch nào cần cắt giảm hoặc tối ưu lại?
- TikTok là kênh nên cắt giảm lại ngân sách bởi vì ROAS của kênh không mang lại tính hiệu tích cực cho doanh nghiệp cũng như là CPC và cost_per_conversion
của kênh rất cao khiến chi phí bỏ ra của doanh nghiệp rất cao. TikTok cũng có tỷ lệ chuyển đổi CVR = 5.34 rất thấp, thấp thứ 2 so với các kênh. Qua đó chúng 
ta nên cắt giảm ngân sách để tập trung đầu tư cho kênh khác hiệu quả hơn

- Facebook cũng là kênh nên cắt giảm ngân sách bởi vì CPC cũng như là Cost_per_Conversion rất cao và CVR thấp hơn so với BenchMark ngành. ROAS của Facebook
cũng ko đáp ứng đúng kỳ vọng của doanh nghiệp với Roas = 1.91 thấp nhất so với 4 kênh còn lại
*/

SELECT * FROM Marketing