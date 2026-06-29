📊 Phân Tích Hiệu Quả Chiến Dịch Marketing & Tối Ưu ROAS (Marketing Campaign Analysis)
Lưu ý cho nhà tuyển dụng: Dự án này mô phỏng quy trình xử lý dữ liệu và phân tích hiệu suất thực tế của một Data Analyst nhằm giải quyết bài toán kinh doanh cốt lõi: Tối ưu hóa chi phí quảng cáo và tăng doanh thu.

📑 Mục Lục
Bối Cảnh Dự Án
Mục Tiêu Kinh Doanh
Từ Điển Dữ Liệu (Data Dictionary)
Quy Trình Phân Tích (Methodology)
Phân Tích Dữ Liệu Bằng SQL
Trực Quan Hóa Dữ Liệu (Power BI)
Đề Xuất Chiến Lược (Recommendations)
1. 🏢 Bối Cảnh Dự Án
Công ty ABC đã triển khai 500 chiến dịch quảng cáo trên 5 nền tảng Marketing khác nhau (Facebook Ads, Google Ads, TikTok Ads, Email Marketing, LinkedIn Ads) với tổng ngân sách lên tới 50 tỷ VNĐ trong vòng 6 tháng qua.

Tuy nhiên, dù đã chi tiêu một lượng ngân sách lớn, công ty đang đối mặt với tình trạng nhiều chiến dịch "đốt tiền" nhưng không mang lại doanh thu. Kỳ vọng ban đầu của công ty là đạt mức ROAS (Return on Ad Spend) 
≥
≥ 3.5, nhưng thực tế rất nhiều chiến dịch đang có mức ROAS thấp dưới ngưỡng hòa vốn.

2. 🎯 Mục Tiêu Kinh Doanh
Dự án được thực hiện nhằm giải quyết các câu hỏi kinh doanh trọng tâm sau:

Ngân sách lớn nhưng doanh thu không đạt kỳ vọng? Có phải một số kênh đang tiêu tốn quá nhiều ngân sách nhưng không hiệu quả? Kênh nào có ROAS thấp nhất?
Tỷ lệ chuyển đổi từ quảng cáo thấp - Vì sao? Click nhiều nhưng không ra đơn - Nguyê nhân từ đâu? Landing page có vấn đề hay nhóm khách hàng mục tiêu chưa đúng?
Phân tích hiệu suất từng kênh quảng cáo: Facebook Ads hay Google Ads hiệu quả hơn? TikTok Ads có lợi thế với khách hàng trẻ tuổi không? Email Marketing có giữ chân khách hàng cũ không?
Đề xuất chiến lược tối ưu Marketing: Nên tăng ngân sách cho kênh nào? Chiến dịch nào cần cắt giảm hoặc tối ưu lại? Cách cải thiện ROAS để đạt tối thiểu 3.5?
3. 📚 Từ Điển Dữ Liệu (Data Dictionary)
Trường Dữ Liệu	Ý Nghĩa
Campaign_ID	Mã định danh của từng chiến dịch quảng cáo.
Channel	Nền tảng quảng cáo (Facebook, Google, TikTok, Email, LinkedIn).
Budget	Ngân sách đã chi tiêu (VNĐ).
Clicks	Số lượt nhấp chuột vào quảng cáo.
Conversions	Số đơn hàng / Khách hàng chuyển đổi thành công.
CPC	Cost per Click - Chi phí cho mỗi lượt nhấp.
Total_Revenue	Tổng doanh thu mang lại từ chiến dịch.
Ad_CTR	Click Through Rate - Tỷ lệ Click trên số lần hiển thị.
Bounce_Rate	Tỷ lệ thoát trang sau khi click vào quảng cáo.
ROAS	Return on Ad Spend - Chỉ số đo lường lợi nhuận trên chi phí quảng cáo.
4. 🔍 Quy Trình Phân Tích (Methodology)
Data Cleaning (Làm sạch dữ liệu): Xử lý các dòng dữ liệu bị thiếu (missing values), chuẩn hóa định dạng số liệu. Đặc biệt, tính toán lại chỉ số CPC do dữ liệu cũ đang bị áp dụng sai công thức (Công thức chuẩn: CPC = Budget / Clicks).
Exploratory Data Analysis (EDA): Dùng SQL để tính toán chỉ số trung bình ROAS, CTR của từng nền tảng để có cái nhìn tổng quan.
Data Visualization (Trực quan hóa dữ liệu): Đưa dữ liệu đã xử lý vào Power BI, xây dựng các biểu đồ tương tác để so sánh hiệu suất giữa các kênh.
Insights Generation: Tổng hợp kết quả và rút ra nguyên nhân các chiến dịch kém hiệu quả để đề xuất tối ưu.
5. 💻 Phân Tích Dữ Liệu Bằng SQL (Data Analysis)
Vấn đề 1: Ngân sách lớn nhưng doanh thu không đạt kỳ vọng?
Kiểm tra xem kênh nào đang tiêu tốn ngân sách và kênh nào có ROAS thấp nhất.

sql

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
(Chèn ảnh kết quả bảng truy vấn 1 tại đây)

sql

-- Thống kê các kênh có nhiều chiến dịch lỗ nhất (ROAS < 1)
SELECT 
    Channel,
    AVG(Budget) AS AVG_Budget,
    COUNT(Campaign_ID) AS Total_Campaign,
    AVG(ROAS) AS AVG_Roas 
FROM Marketing
WHERE ROAS < 1
GROUP BY Channel
ORDER BY COUNT(Campaign_ID) DESC;
(Chèn ảnh kết quả bảng truy vấn 2 tại đây)

💡 Insights:

Facebook và TikTok đang có ROAS thấp nhất so với mặt bằng chung (ROAS 
≤
≤ 2).
Ngân sách của Facebook chiếm 19.61% tổng chi phí nhưng hiệu quả sinh lời kém. Trong khi đó, Google Ads chiếm mức chi phí tương đương (19.26%) nhưng mang lại doanh thu cao hơn rất nhiều.
TikTok và Facebook là 2 kênh duy nhất có % Doanh Thu < % Chi Phí.
TOP 10 chiến dịch lỗ cao nhất tập trung nhiều nhất vào kênh TikTok (5/10 chiến dịch).
Vấn đề 2: Tỷ lệ chuyển đổi (CVR) từ quảng cáo thấp - Vì sao?
Đánh giá chất lượng Landing Page và tệp khách hàng mục tiêu (Targeting).

sql

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
(Chèn ảnh kết quả bảng truy vấn 3 tại đây)

sql

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
(Chèn ảnh kết quả bảng truy vấn 4 tại đây)

💡 Insights:

Kết hợp giữa CVR và Bounce Rate, Landing Page không phải là nguyên nhân chính dẫn đến ROAS thấp. Vấn đề nằm ở việc xác định đối tượng khách hàng (Targeting).
LinkedIn xác định đối tượng chuẩn xác nhất (CPC rẻ, CVR cao nhất, Cost/Conversion thấp).
TikTok tốn rất nhiều tiền (CPC đắt thứ 2) nhưng CVR thấp. Nghĩa là phải tiêu tốn cực kỳ nhiều chi phí mới ra được 1 đơn hàng.
Các chiến dịch cá biệt như CAMP_350, CAMP_8 có Cost/Conversion lên tới 
400
K
–
400K–618K trong khi Doanh thu trên mỗi đơn chỉ đạt ~
35
K
35K\rightarrow$ Đang lỗ nặng trên từng đơn hàng.
6. 📈 Trực Quan Hóa Dữ Liệu (Power BI Dashboards)
Link tương tác Dashboard: [Chèn Link Power BI Service / Novypro của cậu tại đây] (Chèn 1 file GIF ngắn 10s cảnh cậu tương tác, click bộ lọc trên Dashboard tại đây)

Dashboard được thiết kế không chỉ để hiển thị số liệu, mà nhằm trực tiếp giải quyết các bài toán phân bổ dòng tiền và hành động cho từng chiến dịch.

Trang 1: Overview Dashboard (Bức tranh tổng thể)
(Chèn hình ảnh Overview Dashboard tại đây)

Mục đích: Cung cấp cái nhìn toàn cảnh về tình hình kinh doanh hiện tại. Kênh nào đang "gánh" doanh thu và kênh nào đang kéo lùi toàn đội?
Phân tích: Dựa vào hệ thống KPI và Bar Chart ROAS by Channel, ta thấy ngay Email Marketing (2.20) đang dẫn đầu về hiệu quả, trong khi Facebook Ads (1.91) nằm dưới cùng. Đặc biệt, bảng Campaigns at risks giúp CMO nhận diện ngay lập tức những chiến dịch đang có ROAS < 1 để can thiệp kịp thời.
Trang 2: Campaigns Action Dashboard (Bản đồ hành động)
(Chèn hình ảnh Campaigns Action Dashboard tại đây)

Mục đích: Trả lời câu hỏi "Hành động tiếp theo với 484 chiến dịch là gì?". Giám đốc không thể xem từng chiến dịch một, cần có sự phân loại rõ ràng.
Phân tích: Bằng tư duy Phân khúc (Segmentation), toàn bộ chiến dịch được chia thành 3 nhóm hành động trên Scatter Plot:
Scale Up (197 campaigns): ROAS 
≥
≥ 2.5 
→
→ Đề xuất tăng tiền.
Optimize (193 campaigns): Cần theo dõi thêm.
Pause Now (94 campaigns): Đây là nguyên nhân cốt lõi gây "đốt tiền". Nhóm này ngốn tới 27.55% tổng ngân sách (
3.52
B
)
n
h
ư
n
g
m
a
n
g
l
ạ
i
l
ợ
i
n
h
u
ậ
n
a
^
m
3.52B)nhưngmanglạilợinhuận 
a
^
 m\rightarrow$ Bắt buộc phải tắt ngay lập tức.
Trang 3: Budget Efficiency Dashboard (Hiệu quả phân bổ dòng tiền)
(Chèn hình ảnh Budget Efficiency Dashboard tại đây)

Mục đích: Đánh giá xem ngân sách (Budget Share) cấp cho từng kênh đã tương xứng với doanh thu (Revenue Share) mà kênh đó mang lại hay chưa.
Phân tích: Khái niệm Efficiency Gap (Khoảng trống hiệu suất) được sử dụng. Biểu đồ cột chỉ rõ Facebook Ads và TikTok Ads đang có "Gap âm" (-1.7% và -0.6%), chứng tỏ chúng đang nhận được nhiều ngân sách hơn mức xứng đáng. Đây là minh chứng bằng số liệu cực kỳ vững chắc để bảo vệ quan điểm cắt giảm ngân sách.
7. 🚀 Đề Xuất Chiến Lược (Recommendations)
Từ các insight đúc kết qua SQL và Power BI, tôi đề xuất phương án hành động (Action Plan) như sau:

Nhóm kênh cần Tăng Ngân Sách (Scale Up):

LinkedIn Ads: Là kênh có chất lượng Targeting tốt nhất (CVR cao nhất, chi phí ra đơn thấp). Cần tập trung dồn ngân sách vào đây để tối đa hóa số lượng đơn hàng B2B/chất lượng cao.
Email Marketing & Google Ads: Có tỷ lệ ROAS cao nhất và mức độ giữ chân khách hàng rất tốt. Tiếp tục mở rộng các tệp từ khóa (Google) và kịch bản gửi Mail (Email) để scale doanh thu.
Nhóm kênh cần Cắt Giảm / Tối Ưu Lại (Optimize & Pause):

Tắt ngay (Pause) 94 chiến dịch lỗ: Nằm trong nhóm "Pause Now" trên Dashboard, việc chặn đứng ngay các chiến dịch này sẽ cứu lại 27.55% ngân sách đang bị lãng phí.
TikTok Ads: Cắt giảm ngân sách mạnh. Chi phí click (CPC) quá cao nhưng không ra đơn. Cần đánh giá lại KPI của nền tảng này (Nên chuyển mục tiêu sang Tăng nhận diện thương hiệu thay vì Chuyển đổi trực tiếp).
Facebook Ads: Đang có ROAS tệ nhất (1.91) và hiệu suất kém hơn hẳn tiêu chuẩn ngành. Cần A/B Testing lại tệp khách hàng mục tiêu hoặc thay đổi hoàn toàn Creative (hình ảnh/video quảng cáo) trước khi tiếp tục chi tiền.
Cảm ơn bạn đã đọc! Nếu có bất kỳ phản hồi hoặc cơ hội hợp tác nào, vui lòng liên hệ với tôi qua [LinkedIn của bạn] hoặc Email: [Email của bạn].
