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
Công ty ABC đã triển khai **500 chiến dịch quảng cáo** trên 5 nền tảng Marketing khác nhau (Facebook Ads, Google Ads, TikTok Ads, Email Marketing, LinkedIn Ads) với tổng ngân sách lên tới **50 tỷ VNĐ** trong vòng 6 tháng qua. 

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
## Insights:

Facebook và TikTok đang có ROAS thấp nhất so với mặt bằng chung (ROAS <= 2).

Ngân sách của Facebook chiếm 19.61% tổng chi phí nhưng hiệu quả sinh lời kém. Trong khi đó, Google Ads chiếm mức chi phí tương đương (19.26%) nhưng mang lại doanh thu cao hơn rất nhiều.

TikTok và Facebook là 2 kênh duy nhất có % Doanh Thu < % Chi Phí.

TOP 10 chiến dịch lỗ cao nhất tập trung nhiều nhất vào kênh TikTok (5/10 chiến dịch).



