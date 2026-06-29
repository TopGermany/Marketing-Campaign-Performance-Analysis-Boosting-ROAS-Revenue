# 📊 Phân Tích Hiệu Quả Chiến Dịch Marketing & Tối Ưu ROAS (Marketing Campaign Analysis)

## 📑 Mục Lục
- [1. Bối Cảnh Dự Án](#1-bối-cảnh-dự-án)
- [2. Mục Tiêu Kinh Doanh](#2-mục-tiêu-kinh-doanh)
- [3. Từ Điển Dữ Liệu (Data Dictionary)](#3-từ-điển-dữ-liệu-data-dictionary)
- [4. Quy Trình Phân Tích (Methodology)](#4-quy-trình-phân-tích-methodology)
- [5. Phân Tích Dữ Liệu Bằng SQL](#5-phân-tích-dữ-liệu-bằng-sql-data-analysis)
- [6. Trực Quan Hóa Dữ Liệu (Power BI)](#6-trực-quan-hóa-dữ-liệu-power-bi-dashboards)
- [7. Đề Xuất Chiến Lược (Recommendations)](#7-đề-xuất-chiến-lược-recommendations)

---

## 1. 🏢 Bối Cảnh Dự Án
Công ty POC đã triển khai **500 chiến dịch quảng cáo** trên 5 nền tảng Marketing khác nhau (Facebook Ads, Google Ads, TikTok Ads, Email Marketing, LinkedIn Ads) với tổng ngân sách lên tới **50 tỷ VNĐ** trong vòng 6 tháng qua. 

Tuy nhiên, dù đã chi tiêu một lượng ngân sách lớn, công ty đang đối mặt với tình trạng nhiều chiến dịch "đốt tiền" nhưng không mang lại doanh thu. Kỳ vọng ban đầu của công ty là đạt mức **ROAS (Return on Ad Spend) >= 3.5**, nhưng thực tế rất nhiều chiến dịch đang có mức ROAS thấp dưới ngưỡng hòa vốn.

---

## 2. 🎯 Mục Tiêu Kinh Doanh
Dự án được thực hiện nhằm giải quyết các câu hỏi kinh doanh trọng tâm sau:
1. **Ngân sách lớn nhưng doanh thu không đạt kỳ vọng?** Có phải một số kênh đang tiêu tốn quá nhiều ngân sách nhưng không hiệu quả? Kênh nào có ROAS thấp nhất?
2. **Tỷ lệ chuyển đổi từ quảng cáo thấp - Vì sao?** Click nhiều nhưng không ra đơn - Nguyên nhân từ đâu? Landing page có vấn đề hay nhóm khách hàng mục tiêu chưa đúng?
3. **Phân tích hiệu suất từng kênh quảng cáo:** Facebook Ads hay Google Ads hiệu quả hơn? TikTok Ads có lợi thế với khách hàng trẻ tuổi không? Email Marketing có giữ chân khách hàng cũ không?
4. **Đề xuất chiến lược tối ưu Marketing:** Nên tăng ngân sách cho kênh nào? Chiến dịch nào cần cắt giảm hoặc tối ưu lại? Cách cải thiện ROAS để đạt tối thiểu 3.5?

---

## 3. 📚 Từ Điển Dữ Liệu (Data Dictionary)

| Trường Dữ Liệu | Ý Nghĩa |
| :--- | :--- |
| `Campaign_ID` | Mã định danh của từng chiến dịch quảng cáo. |
| `Channel` | Nền tảng quảng cáo (Facebook, Google, TikTok, Email, LinkedIn). |
| `Budget` | Ngân sách đã chi tiêu (VNĐ). |
| `Clicks` | Số lượt nhấp chuột vào quảng cáo. |
| `Conversions` | Số đơn hàng / Khách hàng chuyển đổi thành công. |
| `CPC` | Cost per Click - Chi phí cho mỗi lượt nhấp. |
| `Total_Revenue`| Tổng doanh thu mang lại từ chiến dịch. |
| `Ad_CTR` | Click Through Rate - Tỷ lệ Click trên số lần hiển thị. |
| `Bounce_Rate` | Tỷ lệ thoát trang sau khi click vào quảng cáo. |
| `ROAS` | Return on Ad Spend - Chỉ số đo lường lợi nhuận trên chi phí quảng cáo. |

---

## 4. 🔍 Quy Trình Phân Tích (Methodology)

1. **Data Cleaning (Làm sạch dữ liệu):** Xử lý các dòng dữ liệu bị thiếu (missing values), chuẩn hóa định dạng số liệu. Đặc biệt, **tính toán lại chỉ số CPC** do dữ liệu gốc đang bị áp dụng sai công thức (Công thức chuẩn: `CPC = Budget / Clicks`).
2. **Exploratory Data Analysis (EDA):** Dùng SQL để tính toán chỉ số trung bình ROAS, CTR của từng nền tảng để có cái nhìn tổng quan.
3. **Data Visualization (Trực quan hóa dữ liệu):** Đưa dữ liệu đã xử lý vào Power BI, xây dựng các biểu đồ tương tác để so sánh hiệu suất giữa các kênh.
4. **Insights Generation:** Tổng hợp kết quả và rút ra nguyên nhân các chiến dịch kém hiệu quả để đề xuất tối ưu.

---

## 5. 💻 Phân Tích Dữ Liệu Bằng SQL (Data Analysis)

### Vấn đề 1: Ngân sách lớn nhưng doanh thu không đạt kỳ vọng?
Kiểm tra xem kênh nào đang tiêu tốn ngân sách và kênh nào có ROAS thấp nhất.

```sql
-- Tính toán ROAS tổng quan của các kênh 
SELECT 
    Channel,
    SUM(Total_Revenue) AS Total_Revenue,
    SUM(Budget) AS Budget,
    SUM(Total_Revenue)/SUM(Budget) AS ROAS,
    (SELECT SUM(Budget) FROM Marketing) AS Total_Budget_Company,
    (SUM(Budget) * 100.0 / (SELECT SUM(Budget) FROM Marketing)) AS Budget_Percentage,
    (SELECT SUM(Total_Revenue) FROM Marketing) AS Total_Revenue,
    (SELECT SUM(Total_Revenue) * 100.0/(SELECT SUM(Total_Revenue) FROM Marketing)) AS Revenue_Percentage
FROM Marketing
GROUP BY Channel
ORDER BY Budget DESC;
```
<img width="960" height="117" alt="image" src="https://github.com/user-attachments/assets/39d1a45b-4fee-46b3-8d68-a68da8b42040" />

```sql
-- Những kênh có nhiều chiến dịch lỗ nhất
SELECT Channel,AVG(Budget) AS AVG_Budget,COUNT(Campaign_ID) AS Total_Campaign,AVG(ROAS) AS AVG_Roas FROM Marketing
WHERE ROAS < 1
GROUP BY Channel
ORDER BY COUNT(Campaign_ID) DESC
```
<img width="502" height="115" alt="image" src="https://github.com/user-attachments/assets/929ed301-57ff-4a28-8433-0a865818190e" />

```sql
-- TOP 10 chiến dịch bị lỗ (Nguy hiểm)
SELECT TOP 10 *  FROM Marketing
WHERE ROAS < 1
ORDER BY ROAS ASC
```
<img width="1012" height="220" alt="image" src="https://github.com/user-attachments/assets/92dd1ae6-6ca8-491f-8f9c-b4ef44691ed2" />

## Insights:

- Facebook và TikTok đang có ROAS thấp nhất so với mặt bằng chung (ROAS <= 2).

- Ngân sách của Facebook chiếm 19.61% tổng chi phí nhưng hiệu quả sinh lời kém. Trong khi đó, Google Ads chiếm mức chi phí tương đương (19.26%) nhưng mang lại doanh thu cao hơn rất nhiều.

- TikTok và Facebook là 2 kênh duy nhất có % Doanh Thu < % Chi Phí.

- TOP 10 chiến dịch lỗ cao nhất tập trung nhiều nhất vào kênh TikTok (5/10 chiến dịch).

## Vấn đề 2: Tỷ lệ chuyển đổi (CVR) từ quảng cáo thấp - Vì sao?
Đánh giá chất lượng Landing Page và tệp khách hàng mục tiêu (Targeting).

```sql
-- Đánh giá chất lượng Targeting qua CPC, Cost per Conversion và CVR
SELECT
    Channel,
    ROUND(SUM(Budget) / SUM(Clicks), 2) AS CPC,
    ROUND(SUM(Budget) / NULLIF(SUM(Conversions), 0), 2) AS cost_per_conversion,
    ROUND(SUM(Conversions) * 100.0 / SUM(Clicks), 2) AS CVR,
    ROUND(SUM(Total_Revenue) / NULLIF(SUM(Conversions), 0), 2) AS revenue_per_conversion
FROM Marketing
GROUP BY Channel
ORDER BY CPC DESC, cost_per_conversion DESC, CVR DESC;
```
<img width="522" height="117" alt="image" src="https://github.com/user-attachments/assets/4095719b-a620-428a-9538-f54d24887157" />


```sql
-- Nhận diện các chiến dịch đang kéo sai tệp người dùng (Click rẻ nhưng chi phí ra đơn cực đắt)
SELECT TOP 15
    Campaign_ID, Channel, Budget, Clicks, Conversions,
    ROUND(Budget * 1.0 / NULLIF(Clicks, 0), 2) AS cpc_actual,
    ROUND(Budget * 1.0 / NULLIF(Conversions, 0), 2) AS cost_per_conversion,
    ROUND(Conversions * 100.0 / NULLIF(Clicks, 0), 2) AS cvr
FROM Marketing
WHERE Conversions > 0
  AND (Budget * 1.0 / Clicks) < (SELECT AVG(Budget * 1.0 / NULLIF(Clicks, 0)) FROM Marketing)
ORDER BY cost_per_conversion DESC;
```
<img width="682" height="317" alt="image" src="https://github.com/user-attachments/assets/e0b3a7f6-3903-44f9-b779-2248f5cc319a" />

## Insights:
- Kết hợp giữa CVR và Bounce Rate, Landing Page không phải là nguyên nhân chính dẫn đến ROAS thấp. Vấn đề nằm ở việc xác định đối tượng khách hàng (Targeting).
- LinkedIn xác định đối tượng chuẩn xác nhất (CPC rẻ, CVR cao nhất, Cost/Conversion thấp).
- TikTok tốn rất nhiều tiền (CPC đắt thứ 2) nhưng CVR thấp. Nghĩa là phải tiêu tốn cực kỳ nhiều chi phí mới ra được 1 đơn hàng.
Các chiến dịch cá biệt như CAMP_350, CAMP_8 có Cost/Conversion lên tới 
400K–618K trong khi Doanh thu trên mỗi đơn chỉ đạt ~$35K vì vậy các chiến dịch này đang lỗ nặng trên từng đơn hàng.

## 6. 📈 Trực Quan Hóa Dữ Liệu (Power BI Dashboards)

<img width="1350" height="740" alt="Recording 2026-06-29 204630" src="https://github.com/user-attachments/assets/8f9bd5a0-2fe6-46b6-aa15-2bc65d530916" />

## Trang 1: Overview Dashboard (Bức tranh tổng thể)

<img width="1321" height="742" alt="Screenshot 2026-06-29 170609" src="https://github.com/user-attachments/assets/909edab1-bd0d-40b7-8d84-3ae3707ac5d9" />

- Biểu đồ này tạo ra để trả lời câu hỏi gì? Cung cấp cái nhìn toàn cảnh về tình hình kinh doanh hiện tại. Kênh nào đang "gánh" doanh thu và kênh nào đang "đốt tiền" toàn đội?
  
- ## Phân tích: ## Dựa vào hệ thống KPI và Bar Chart ROAS by Channel, ta thấy ngay Email Marketing (2.20) đang dẫn đầu về hiệu quả, trong khi Facebook Ads (1.91) nằm bét bảng. Đặc biệt, bảng Campaigns at risks giúp CMO điểm mặt chỉ tên ngay lập tức những chiến dịch đang có ROAS < 1 để can thiệp kịp thời.

## Trang 2: Campaigns Action Dashboard (Bản đồ hành động)

<img width="1325" height="742" alt="Screenshot 2026-06-29 170623" src="https://github.com/user-attachments/assets/b0f7d1c0-d423-4a35-b062-2a59503079f6" />

- Biểu đồ này tạo ra để trả lời câu hỏi gì? Trả lời nhanh gọn câu hỏi "Hành động tiếp theo với 484 chiến dịch là gì?". Giám đốc không thể rà soát từng chiến dịch một, mà cần sự phân loại nhóm hành động rõ ràng.
  
- Phân tích: Bằng tư duy Phân nhóm (Segmentation), 484 chiến dịch được chia thành 3 nhóm hành động:
    - Scale Up (197 campaigns): ROAS lý tưởng (>= 2.5) -> Đề xuất tăng tiền ngay.
    - Optimize (193 campaigns): Cần theo dõi thêm và tối ưu nội dung.
    - Pause Now (94 campaigns): Đây là nguyên nhân cốt lõi gây lãng phí. Nhóm này ngốn tới 27.55% tổng ngân sách ($3.52B) nhưng mang lại lợi nhuận âm -> Yêu cầu tắt (Pause) ngay lập tức.

## Trang 3: Budget Efficiency Dashboard (Hiệu quả phân bổ dòng tiền)

<img width="1327" height="747" alt="Screenshot 2026-06-29 170639" src="https://github.com/user-attachments/assets/9e69a1c2-2e08-43b0-9a15-a537a871072b" />

- Biểu đồ này tạo ra để trả lời câu hỏi gì? Đánh giá xem phần trăm ngân sách (Budget Share) cấp cho từng kênh đã tương xứng với doanh thu (Revenue Share) mà kênh đó mang lại hay chưa? Mức độ lãng phí đang là bao nhiêu?
  
- Phân tích:  Sử dụng khái niệm Efficiency Gap (Khoảng trống hiệu suất). Biểu đồ cột chỉ rõ Facebook Ads và TikTok Ads đang có "Gap âm" (-1.7% và -0.6%), minh chứng cho việc sử dụng vốn kém hiệu quả. Đây là cơ sở dữ liệu vững chắc để bảo vệ quan điểm rút ngân sách khỏi 2 kênh này.

## 7. 🚀 Đề Xuất Chiến Lược (Recommendations)

## 1. Nhóm kênh cần Tăng Ngân Sách (Scale Up): ## 

- LinkedIn Ads: Là kênh có chất lượng Targeting chuẩn nhất (CVR cao nhất, chi phí ra đơn thấp). Cần tập trung dồn ngân sách vào đây để tối đa hóa số lượng khách hàng tiềm năng.
  
- Email Marketing & Google Ads: Có tỷ lệ ROAS cao nhất và mức độ giữ chân khách hàng (Retention) rất tốt. Đề xuất mở rộng tệp từ khóa (Google) và phát triển kịch bản Email tự động để tăng trưởng doanh thu.
  
## 2. Nhóm kênh cần Cắt Giảm / Tối Ưu Lại (Optimize & Pause): ##

- Tắt ngay (Pause) 94 chiến dịch lỗ: Nằm trong nhóm "Pause Now" trên Dashboard, việc chặn đứng ngay lập tức các chiến dịch này sẽ cứu lại 27.55% ngân sách doanh nghiệp đang bị lãng phí.
  
- TikTok Ads: Cắt giảm ngân sách. Mặc dù nhắm đến giới trẻ, chi phí click (CPC) quá đắt đỏ và không sinh ra đơn hàng. Cần thay đổi mục tiêu chiến dịch từ "Chuyển đổi" sang "Tăng nhận diện thương hiệu" (Brand Awareness).

- Facebook Ads: Đang có ROAS thấp nhất toàn chiến dịch (1.91). Cần A/B Testing lại hoàn toàn tệp khách hàng mục tiêu hoặc thay đổi chất lượng nội dung quảng cáo (Creatives) trước khi tiếp tục chi tiền.

---

Cảm ơn bạn đã quan tâm đến dự án của tôi! Nếu có cơ hội trao đổi hoặc hợp tác, vui lòng liên hệ với tôi qua Email: ## hoquocuong2005@gmail.com ##


