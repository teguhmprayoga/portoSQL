'1. Jumlah Kolom pada Tabel products:'
SHOW COLUMNS FROM products;
+--------------+---------+------+-----+---------+-------+
| Field        | Type    | Null | Key | Default | Extra |
+--------------+---------+------+-----+---------+-------+
| product_id   | int(11) | YES  | MUL | NULL    |       |
| desc_product | text    | YES  |     | NULL    |       |
| category     | text    | YES  |     | NULL    |       |
| base_price   | int(11) | YES  |     | NULL    |       |
+--------------+---------+------+-----+---------+-------+ 


'2. Jumlah Baris pada Tabel products:'
SELECT COUNT(*) AS jumlah_baris
FROM products;
+--------------+
| jumlah_baris |
+--------------+
|         1145 |
+--------------+ 


'3. Jumlah Jenis Kategori Produk yang Unik dari Tabel products:'
SELECT COUNT(DISTINCT category) AS jumlah_kategori
FROM products;
+-----------------+
| jumlah_kategori |
+-----------------+
|              12 |
+-----------------+


'4. Banyak Variabel dengan Nilai NULL/Kosong dalam tabel products'
SELECT 
    (SUM(CASE WHEN desc_product IS NULL OR desc_product = '' THEN 1 ELSE 0 END) > 0) +
    (SUM(CASE WHEN category IS NULL OR category = '' THEN 1 ELSE 0 END) > 0) +
    (SUM(CASE WHEN base_price IS NULL OR base_price = '' THEN 1 ELSE 0 END) > 0) AS jumlah_variabel_null_kosong
FROM products;
+-----------------------------+
| jumlah_variabel_null_kosong |
+-----------------------------+
|                           0 |
+-----------------------------+


'5. Jumlah Kolom pada Tabel orders:'
SHOW COLUMNS FROM orders;
+-------------+---------+------+-----+---------+-------+
| Field       | Type    | Null | Key | Default | Extra |
+-------------+---------+------+-----+---------+-------+
| order_id    | int(11) | YES  | MUL | NULL    |       |
| seller_id   | int(11) | YES  | MUL | NULL    |       |
| buyer_id    | int(11) | YES  | MUL | NULL    |       |
| kodepos     | text    | YES  |     | NULL    |       |
| subtotal    | int(11) | YES  |     | NULL    |       |
| discount    | int(11) | YES  |     | NULL    |       |
| total       | int(11) | YES  |     | NULL    |       |
| created_at  | text    | YES  |     | NULL    |       |
| paid_at     | text    | YES  |     | NULL    |       |
| delivery_at | text    | YES  |     | NULL    |       |
+-------------+---------+------+-----+---------+-------+


'6. Jumlah Baris pada Tabel orders:'
SELECT COUNT(*) AS jumlah_baris
FROM orders;
+--------------+
| jumlah_baris |
+--------------+
|        74874 |
+--------------+


'7. Banyak Variabel dengan Nilai NULL/Kosong dari tabel orders:'
SELECT
    (SUM(CASE WHEN discount IS NULL OR discount = '' THEN 1 ELSE 0 END)> 0) +
    (SUM(CASE WHEN paid_at IS NULL OR paid_at = '' THEN 1 ELSE 0 END) > 0) +
    (SUM(CASE WHEN delivery_at IS NULL OR delivery_at = '' THEN 1 ELSE 0 END) > 0) AS jumlah_variabel_null_kosong
FROM orders;
+-----------------------------+
| jumlah_variabel_null_kosong |
+-----------------------------+
|                           1 |
+-----------------------------+ 


'8. Banyak Variabel yang Berisi Data Angka int dari tabel products:'
SELECT COUNT(*) AS jumlah_kolom_amount
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'products'
AND TABLE_SCHEMA = 'portfolio'
AND DATA_TYPE IN ('INT', 'DECIMAL', 'FLOAT', 'DOUBLE');
+---------------------+
| jumlah_kolom_amount |
+---------------------+
|                   2 |
+---------------------+


'9. Total Pengguna:'
SELECT COUNT(DISTINCT user_id) AS total_pengguna
FROM users;
+----------------+
| total_pengguna |
+----------------+
|          17936 |
+----------------+ 


'10. Banyak Pengguna yang Pernah Bertransaksi Sebagai Pembeli:'
SELECT COUNT(DISTINCT buyer_id) AS buyers
FROM orders;
+--------+
| buyers |
+--------+
|  17877 |
+--------+


'11. Banyak Pengguna yang Pernah Bertransaksi sebagai Penjual'
SELECT COUNT(DISTINCT seller_id) AS sellers
FROM orders;
+---------+
| sellers |
+---------+
|      69 |
+---------+


'12. Banyak Pengguna yang Pernah Bertransaksi sebagai Pembeli dan Penjual'
SELECT COUNT(DISTINCT buyer_id) AS users_both_roles
FROM orders
WHERE buyer_id IN (
    SELECT seller_id
    FROM orders
);
+------------------+
| users_both_roles |
+------------------+
|               69 |
+------------------+


'13. Banyak Pengguna yang Tidak Pernah Bertransaksi sebagai Pembeli maupun Penjual'
SELECT COUNT(*) AS users_never_transacted
FROM users u
LEFT JOIN (
    SELECT buyer_id AS user_id FROM orders
    UNION
    SELECT seller_id AS user_id FROM orders
) t ON u.user_id = t.user_id
WHERE t.user_id IS NULL;
+------------------------+
| users_never_transacted |
+------------------------+
|                     59 |
+------------------------+


'14. 5 pembeli dengan dengan total pembelian terbesar (berdasarkan total harga barang setelah diskon)'
SELECT u.user_id, u.nama_user, SUM(o.total) AS total_spent
FROM users u
JOIN orders o ON u.user_id = o.buyer_id
GROUP BY u.user_id, u.nama_user
ORDER BY total_spent DESC
LIMIT 5;
+---------+-------------------------------+-------------+
| user_id | nama_user                     | total_spent |
+---------+-------------------------------+-------------+
|      60 | Jaka Hastuti                  |    68956000 |
|     122 | R.M. Banara Hastuti, S.Pd     |    62564000 |
|      72 | Harsanto Melani, M.Ak         |    54333000 |
|   14411 | Jaga Puspasari                |    54102250 |
|   11140 | R.A. Yulia Padmasari, S.I.Kom |    52743200 |
+---------+-------------------------------+-------------+


'15. Pengguna yang tidak pernah menggunakan diskon ketika membeli barang dan merupakan 5 pembeli dengan transaksi terbanyak'
-- Langkah 1: Temukan jumlah transaksi kelima
WITH ranked_transactions AS (
    SELECT u.user_id, u.nama_user, COUNT(o.order_id) AS transaction_count,
           ROW_NUMBER() OVER (ORDER BY COUNT(o.order_id) DESC, u.user_id ASC) AS rank
    FROM users u
    JOIN orders o ON u.user_id = o.buyer_id
    LEFT JOIN (
        SELECT buyer_id
        FROM orders
        GROUP BY buyer_id
        HAVING SUM(discount) > 0
    ) AS discount_buyers ON u.user_id = discount_buyers.buyer_id
    WHERE discount_buyers.buyer_id IS NULL
    GROUP BY u.user_id, u.nama_user
)

-- Langkah 2: Tampilkan pengguna dengan jumlah transaksi >= urutan kelima
SELECT user_id, nama_user, transaction_count
FROM ranked_transactions
WHERE transaction_count >= (
    SELECT MIN(transaction_count)
    FROM ranked_transactions
    WHERE rank <= 5)
ORDER BY transaction_count DESC, user_id ASC;
+---------+---------------------------+-------------------+
| user_id | nama_user                 | transaction_count |
+---------+---------------------------+-------------------+
|      22 | Gandi Rahmawati           |                16 |
|     122 | R.M. Banara Hastuti, S.Pd |                16 |
|      20 | Dr. Adika Kusmawati, S.Pt |                14 |
|      60 | Jaka Hastuti              |                14 |
|     136 | Among Nugroho             |                14 |
|     150 | drg. Capa Namaga, S.Pd    |                14 |
|     155 | R.M. Lamar Gunarto        |                14 |
+---------+---------------------------+-------------------+


'16. Pengguna yang bertransaksi setidaknya 1 kali setiap bulan di tahun 2020 dengan rata-rata total amount per transaksi lebih dari 1 Juta (bulan tercatat dari Januari hingga Mei saja)'
SELECT 
    u.user_id, 
    u.email, 
    COUNT(o.order_id) AS transaction_count, 
    AVG(o.total) AS average_transaction_amount
FROM users u
JOIN orders o ON u.user_id = o.buyer_id
WHERE YEAR(o.created_at) = 2020
GROUP BY u.user_id, u.email
HAVING COUNT(DISTINCT MONTH(o.created_at)) = (SELECT COUNT(DISTINCT MONTH(o.created_at)) FROM orders WHERE YEAR(o.created_at) = 2020)
AND AVG(o.total) > 1000000
ORDER BY transaction_count DESC;
+---------+------------------------------+-------------------+----------------------------+
| user_id | email                        | transaction_count | average_transaction_amount |
+---------+------------------------------+-------------------+----------------------------+
|    3965 | asmanfirgantoro@cv.org       |                 6 |               1967966.6667 |
|    4808 | wastutigenta@perum.desa.id   |                 6 |               2256333.3333 |
|    5620 | namagaargono@hotmail.com     |                 6 |               3934000.0000 |
|    7905 | riyantialika@gmail.com       |                 6 |               4315333.3333 |
|    9027 | hasna57@yahoo.com            |                 6 |               2473833.3333 |
|    9694 | owinarsih@yahoo.com          |                 6 |               1963833.3333 |
|    9898 | dananguyainah@cv.desa.id     |                 6 |               3448666.6667 |
|   10569 | karmanpurnawati@hotmail.com  |                 6 |               2421891.6667 |
|   11195 | fnainggolan@hotmail.com      |                 6 |               5867500.0000 |
|   12011 | kuswoyobakda@gmail.com       |                 6 |               3852883.3333 |
|   12381 | lukmanjailani@yahoo.com      |                 6 |               2814033.3333 |
|   12813 | ida51@ud.net                 |                 6 |               1723700.0000 |
|   13973 | amiwibisono@cv.my.id         |                 6 |               4961416.6667 |
|     302 | pharyanto@perum.or.id        |                 5 |               3406400.0000 |
|    1270 | artawannashiruddin@gmail.com |                 5 |               2386900.0000 |
|    1403 | taswirprabowo@ud.mil.id      |                 5 |               2341200.0000 |
|    1952 | maras02@hotmail.com          |                 5 |               1187000.0000 |
|    2112 | hsaefullah@yahoo.com         |                 5 |               1827400.0000 |
|    2424 | maryadiviolet@ud.mil.id      |                 5 |               5639880.0000 |
|    2512 | iswahyudiprabawa@gmail.com   |                 5 |               1663080.0000 |
|    3185 | bzulkarnain@yahoo.com        |                 5 |               5310480.0000 |
|    4660 | sakapalastri@pd.gov          |                 5 |               1890800.0000 |
|    5061 | xsetiawan@hotmail.com        |                 5 |               2800700.0000 |
|    5966 | ibrahimsaputra@ud.mil.id     |                 5 |               2157000.0000 |
|    5973 | hwinarsih@yahoo.com          |                 5 |               2308200.0000 |
|    6231 | skusmawati@hotmail.com       |                 5 |               1278480.0000 |
|    6251 | tfirgantoro@ud.gov           |                 5 |               3520520.0000 |
|    8172 | ganepusada@gmail.com         |                 5 |               3923000.0000 |
|    8705 | wasitabajragin@yahoo.com     |                 5 |               1581200.0000 |
|    9030 | chelseasaputra@ud.mil        |                 5 |               1851000.0000 |
|   10088 | latuponojais@perum.gov       |                 5 |               1167750.0000 |
|   11094 | mpermadi@hotmail.com         |                 5 |               2675320.0000 |
|   11998 | dyulianti@gmail.com          |                 5 |               4900920.0000 |
|   12716 | tedi40@gmail.com             |                 5 |               3974080.0000 |
|   14080 | setyawaluyo@hotmail.com      |                 5 |               1123800.0000 |
|   14652 | nilampurnawati@hotmail.com   |                 5 |               2060600.0000 |
|   15467 | megantaraajiono@cv.org       |                 5 |               2171000.0000 |
|   15674 | luluh59@hotmail.com          |                 5 |               3520140.0000 |
+---------+------------------------------+-------------------+----------------------------+


'17. Domain email dari penjual di Store.'
'*domain adalah nama unik setelah tanda @, biasanya menggambarkan nama organisasi dan imbuhan internet standar (seperti .com, .co.id dan lainnya)'
SELECT DISTINCT 
    SUBSTRING_INDEX(u.email, '@', -1) AS domain_email
FROM users u
JOIN orders o ON u.user_id = o.seller_id;
+--------------+
| domain_email |
+--------------+
| hotmail.com  |
| pt.mil.id    |
| pd.go.id     |
| pd.ac.id     |
| perum.int    |
| gmail.com    |
| pt.net.id    |
| perum.edu    |
| pd.web.id    |
| cv.id        |
| cv.mil       |
| yahoo.com    |
| pd.net       |
| perum.mil    |
| pt.gov       |
| cv.web.id    |
| ud.net.id    |
| ud.edu       |
| ud.id        |
| ud.go.id     |
| cv.co.id     |
| pd.mil.id    |
| pd.org       |
| ud.net       |
| pd.my.id     |
| perum.mil.id |
| pd.sch.id    |
+--------------+


'18. Top 5 produk yang dibeli di bulan desember 2019 berdasarkan total quantity'
WITH RankedProducts AS (
    SELECT 
        p.desc_product, 
        SUM(od.quantity) AS total_quantity,
        RANK() OVER (ORDER BY SUM(od.quantity) DESC) AS product_rank
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
    WHERE MONTH(o.created_at) = 12
    AND YEAR(o.created_at) = 2019
    GROUP BY p.desc_product
)
SELECT desc_product, total_quantity
FROM RankedProducts
WHERE product_rank <= 5;
+------------------------------------------------------------+----------------+
| desc_product                                               | total_quantity |
+------------------------------------------------------------+----------------+
| QUEEN CEFA BRACELET LEATHER                                |           2550 |
| SHEW SKIRTS BREE                                           |           1423 |
| ANNA FAITH LEGGING GLOSSY                                  |           1323 |
| Cdr Vitamin C 10S                                         |           1242 |
| RIDER CELANA DEWASA SPANDEX ANTI BAKTERI R325BW            |           1186 |
| EMBA SHORT SLEEVE SHIRT BRUCHIO                            |           1167 |
| Close Up Pasta Gigi White Attraction Natural Glow 100G     |           1155 |
| Rexona Deodorant Roll On Women Advaced Whtning 45Ml        |           1073 |
| BLANIK BLOUSE BL023                                        |           1061 |
| RIDER VEST R224BWH                                         |           1047 |
| Coolant Cooling Mountain Water Extract Crysanthemum 350Ml  |           1037 |
+------------------------------------------------------------+----------------+


'17. Menampilkan 10 transaksi dari pembelian dari pengguna dengan user_id 12476, urutkan dari nilai transaksi paling besar. 
Variabel terdiri dari seller_id, buyer_id, nilai_transaksi, dan tanggal_transaksi'
SELECT 
    seller_id,
    buyer_id,
    total AS nilai_transaksi,
    created_at AS tanggal_transaksi
FROM 
    orders
WHERE 
    buyer_id = 12476
ORDER BY 
    total DESC
LIMIT 10;
+-----------+----------+-----------------+---------------------+
| seller_id | buyer_id | nilai_transaksi | tanggal_transaksi   |
+-----------+----------+-----------------+---------------------+
|        61 |    12476 |        12014000 | 2019-12-23 00:00:00 |
|        53 |    12476 |         9436000 | 2019-12-05 00:00:00 |
|        64 |    12476 |         4951000 | 2019-12-19 00:00:00 |
|        57 |    12476 |         4854000 | 2019-12-01 00:00:00 |
|        22 |    12476 |         4010000 | 2019-11-29 00:00:00 |
|        48 |    12476 |         1440000 | 2020-02-27 00:00:00 |
|        61 |    12476 |         1053000 | 2019-10-17 00:00:00 |
|        35 |    12476 |          816000 | 2020-05-12 00:00:00 |
|        60 |    12476 |          740000 | 2019-09-26 00:00:00 |
|         3 |    12476 |          399000 | 2019-09-26 00:00:00 |
+-----------+----------+-----------------+---------------------+


'18. Menampilkan summary transaksi per bulan di tahun 2020. 
Variabel terdiri dari tahun_bulan, jumlah_transaksi, dan total_nilai_transaksi.'
SELECT 
    EXTRACT(YEAR_MONTH FROM created_at) AS tahun_bulan,
    COUNT(tahun_bulan) AS jumlah_transaksi,
    SUM(total) AS total_nilai_transaksi
FROM 
    orders
WHERE 
    created_at >= '2020-01-01'
    AND created_at < '2021-01-01'
GROUP BY 
    tahun_bulan
ORDER BY 
    tahun_bulan;
+-------------+------------------+-----------------------+
| tahun_bulan | jumlah_transaksi | total_nilai_transaksi |
+-------------+------------------+-----------------------+
|      202001 |             5062 |            9941756800 |
|      202002 |             5872 |           12665113550 |
|      202003 |             7323 |           17189378400 |
|      202004 |             7955 |           21219233750 |
|      202005 |            10026 |           31288823000 |
+-------------+------------------+-----------------------+


'19. Menampilkan 10 pembeli dengan rata-rata nilai transaksi terbesar yang bertransaksi minimal 2 kali di Januari 2020. 
Variabel terdiri dari buyer_id, jumlah_transaksi, dan avg_nilai_transaksi'
SELECT 
    buyer_id,
    COUNT(1) AS jumlah_transaksi,
    AVG(total) AS avg_nilai_transaksi
FROM 
    orders
WHERE 
    created_at >= '2020-01-01' 
    AND created_at < '2020-02-01'
GROUP BY 
    buyer_id
HAVING 
    COUNT(1) >= 2
ORDER BY 
    avg_nilai_transaksi DESC
LIMIT 10;
+----------+------------------+---------------------+
| buyer_id | jumlah_transaksi | avg_nilai_transaksi |
+----------+------------------+---------------------+
|    11140 |                2 |       11719500.0000 |
|     7905 |                2 |       10440000.0000 |
|    12935 |                2 |        8556500.0000 |
|    12916 |                2 |        7747000.0000 |
|    17282 |                2 |        6797500.0000 |
|     1418 |                2 |        6741000.0000 |
|     5418 |                2 |        5336000.0000 |
|    11906 |                2 |        5309500.0000 |
|    12533 |                2 |        5218500.0000 |
|      841 |                2 |        5052500.0000 |
+----------+------------------+---------------------+


'20. Menampilkan semua nilai transaksi minimal 20,000,000 di bulan Desember 2019.
Variabel terdiri dari nama_pembeli, nilai transaksi dan tanggal_transaksi, urutkan sesuai abjad pembeli'
SELECT 
    u.nama_user AS nama_pembeli,
    o.total AS nilai_transaksi,
    o.created_at AS tanggal_transaksi
FROM 
    orders o
INNER JOIN 
    users u ON o.buyer_id = u.user_id
WHERE 
    o.created_at >= '2019-12-01' 
    AND o.created_at < '2020-01-01'
    AND o.total >= 20000000
ORDER BY 
    u.nama_user;
+-------------------------------+-----------------+---------------------+
| nama_pembeli                  | nilai_transaksi | tanggal_transaksi   |
+-------------------------------+-----------------+---------------------+
| Diah Mahendra                 |        21142000 | 2019-12-24 00:00:00 |
| Dian Winarsih                 |        22966000 | 2019-12-21 00:00:00 |
| dr. Yulia Waskita             |        29930000 | 2019-12-28 00:00:00 |
| drg. Kajen Siregar            |        27893500 | 2019-12-10 00:00:00 |
| Drs. Ayu Lailasari            |        22300000 | 2019-12-09 00:00:00 |
| Hendri Habibi                 |        21815000 | 2019-12-19 00:00:00 |
| Kartika Habibi                |        25760000 | 2019-12-22 00:00:00 |
| Lasmanto Natsir               |        22845000 | 2019-12-27 00:00:00 |
| R.A. Betania Suryono          |        20523000 | 2019-12-07 00:00:00 |
| Syahrini Tarihoran            |        29631000 | 2019-12-05 00:00:00 |
| Tgk. Hamima Sihombing, M.Kom. |        29351400 | 2019-12-25 00:00:00 |
| Tgk. Lidya Lazuardi, S.Pt     |        20447000 | 2019-12-16 00:00:00 |
+-------------------------------+-----------------+---------------------+


'21. Menampilkan 5 Kategori dengan total quantity terbanyak di tahun 2020, hanya untuk transaksi yang sudah terkirim ke pembeli.
 Variabel terdiri dari category, total_quantity, total_price'
 SELECT 
    p.category AS category,
    SUM(od.quantity) AS total_quantity,
    SUM(od.price * od.quantity) AS total_price
FROM 
    orders o
INNER JOIN 
    order_details od USING(order_id)
INNER JOIN 
    products p USING(product_id)
WHERE 
    o.created_at >= '2020-01-01' 
    AND o.created_at < '2021-01-01'
    AND o.delivery_at IS NOT NULL
GROUP BY 
    p.category
ORDER BY 
    total_quantity DESC
LIMIT 5;
+-----------------+----------------+-------------+
| category        | total_quantity | total_price |
+-----------------+----------------+-------------+
| Kebersihan Diri |         944018 | 28633068000 |
| Fresh Food      |         298372 | 17019337000 |
| Makanan Instan  |         280481 |  1445625000 |
| Bahan Makanan   |         218151 |  2607123000 |
| Minuman Ringan  |         212103 |  1363526000 |
+-----------------+----------------+-------------+


'21. Mencari pembeli yang sudah bertransaksi lebih dari 5 kali, dan setiap transaksi lebih dari 2,000,000.
Variabel terdiri dari nama_pembeli, jumlah_transaksi, total_nilai_transaksi, min_nilai_transaksi. 
Urutan dari total_nilai_transaksi terbesar'
SELECT 
    nama_user AS nama_pembeli, 
    COUNT(1) AS jumlah_transaksi, 
    SUM(total) AS total_nilai_transaksi, 
    MIN(total) AS min_nilai_transaksi
FROM 
    orders
INNER JOIN 
    users ON buyer_id = user_id
GROUP BY 
    user_id, nama_user
HAVING 
    COUNT(1) > 5 
    AND MIN(total) > 2000000
ORDER BY 
    3 DESC;
+--------------------+------------------+-----------------------+---------------------+
| nama_pembeli       | jumlah_transaksi | total_nilai_transaksi | min_nilai_transaksi |
+--------------------+------------------+-----------------------+---------------------+
| Dr. Sidiq Thamrin  |                6 |              41976000 |             2088000 |
| Dina Lailasari     |                8 |              38195000 |             2736000 |
| Puput Uyainah      |                6 |              32710000 |             2677000 |
| R. Tirta Nasyidah  |                6 |              25117800 |             2308800 |
| Martani Laksmiwati |                6 |              24858000 |             2144000 |
| Fitria Narpati     |                6 |              22820000 |             2337000 |
+--------------------+------------------+-----------------------+---------------------+


'22. Mencari Dropshipper
Akan dicari tahu pengguna yang menjadi dropshipper, yakni pembeli yang membeli barang akan tetapi dikirim ke orang lain. Ciri-cirinya yakni transaksinya banyak, dengan alamat yang berbeda-beda.
Dengan demikian, dicari pembeli dengan 10 kali transaksi atau lebih yang alamat pengiriman transaksi selalu berbeda setiap transaksi.
Variabel terdiri dari nama_pembeli, jumlah_transaksi, distinct_kodepos, total_nilai_transaksi, avg_nilai_transaksi. 
Urutan dari jumlah transaksi terbesar'
SELECT 
    nama_user AS nama_pembeli,
    COUNT(1) AS jumlah_transaksi,
    COUNT(DISTINCT orders.kodepos) AS distinct_kodepos,
    SUM(total) AS total_nilai_transaksi,
    AVG(total) AS avg_nilai_transaksi
FROM 
    orders 
INNER JOIN 
    users ON buyer_id = user_id
GROUP BY 
    user_id, nama_user
HAVING 
    COUNT(1) >= 10
    AND COUNT(DISTINCT orders.kodepos) = COUNT(1)
ORDER BY 
    2 DESC;
+--------------------+------------------+------------------+-----------------------+---------------------+
| nama_pembeli       | jumlah_transaksi | distinct_kodepos | total_nilai_transaksi | avg_nilai_transaksi |
+--------------------+------------------+------------------+-----------------------+---------------------+
| Anastasia Gunarto  |               10 |               10 |               7899000 |         789900.0000 |
| R.M. Setya Waskita |               10 |               10 |              30595000 |        3059500.0000 |
+--------------------+------------------+------------------+-----------------------+---------------------+


'23. Mencari Reseller Offline
Selanjutnya, akan dicari tahu jenis pengguna yang menjadi reseller offline atau punya toko offline, yakni pembeli yang sering sekali membeli barang dan seringnya dikirimkan ke alamat yang sama. Pembelian juga dengan quantity produk yang banyak.
Akan dicari pembeli yang punya 8 atau lebih transaksi yang alamat pengiriman transaksi sama dengan alamat pengiriman utama, dan rata-rata total quantity per transaksi lebih dari 10.
Variabel terdiri atas nama_pembeli, jumlah_transaksi, total_nilai_transaksi, avg_nilai_transaksi, avg_quantity_per_transaksi. 
Urutan dari total_nilai_transaksi yang paling besar'
SELECT 
    nama_user AS nama_pembeli,
    COUNT(1) AS jumlah_transaksi,
    SUM(total) AS total_nilai_transaksi,
    AVG(total) AS avg_nilai_transaksi,
    AVG(summary_order.total_quantity) AS avg_quantity_per_transaksi
FROM 
    orders
INNER JOIN 
    users ON buyer_id = user_id
INNER JOIN 
    (SELECT 
        order_id, 
        SUM(quantity) AS total_quantity 
     FROM 
        order_details 
     GROUP BY 
        order_id) AS summary_order 
USING(order_id)
WHERE 
    orders.kodepos = users.kodepos
GROUP BY 
    user_id, nama_user
HAVING 
    COUNT(1) >= 8
    AND AVG(summary_order.total_quantity) > 10
ORDER BY 
    total_nilai_transaksi DESC;
+-----------------------------+------------------+-----------------------+---------------------+----------------------------+
| nama_pembeli                | jumlah_transaksi | total_nilai_transaksi | avg_nilai_transaksi | avg_quantity_per_transaksi |
+-----------------------------+------------------+-----------------------+---------------------+----------------------------+
| Gandi Rahmawati             |               12 |              36822000 |        3068500.0000 |                    65.1667 |
| Tgk. Cengkal Hutasoit, M.Ak |                8 |              33943000 |        4242875.0000 |                    91.7500 |
| Prima Usamah                |                8 |              24576000 |        3072000.0000 |                    67.2500 |
| Ir. Paris Siregar, S.Sos    |                8 |              22512000 |        2814000.0000 |                    87.7500 |
| Raisa Habibi, S.Ked         |                8 |              17344000 |        2168000.0000 |                    54.7500 |
| R. Prima Laksmiwati, S.Gz   |                8 |              17269000 |        2158625.0000 |                    50.1250 |
| Lulut Pangestu, S.Ked       |                8 |              16580000 |        2072500.0000 |                    79.2500 |
| Dt. Radika Winarno          |                8 |              16320000 |        2040000.0000 |                    45.2500 |
| Kayla Astuti                |               12 |              15953250 |        1329437.5000 |                    40.3333 |
| Ajiman Haryanti             |                8 |              15527000 |        1940875.0000 |                    47.5000 |
| Laila Jailani               |               10 |              14412000 |        1441200.0000 |                    56.2000 |
| Jaka Hastuti                |                8 |              13914000 |        1739250.0000 |                    39.5000 |
| Anastasia Safitri           |                8 |              13188000 |        1648500.0000 |                    51.7500 |
| Dr. Ganep Latupono, S.Kom   |                8 |              12443200 |        1555400.0000 |                    70.0000 |
| Luhung Pradipta             |                8 |              11272000 |        1409000.0000 |                    65.6250 |
| R.M. Gaiman Setiawan        |                8 |              11268000 |        1408500.0000 |                    71.5000 |
| Ir. Shania Padmasari, S.Psi |               10 |              10839200 |        1083920.0000 |                    44.0000 |
| Wirda Aryani                |                8 |              10580000 |        1322500.0000 |                    36.7500 |
| Drs. Indah Megantara, M.TI. |                8 |              10176000 |        1272000.0000 |                    47.2500 |
| T. Empluk Mandasari, S.IP   |                8 |              10066500 |        1258312.5000 |                    48.5000 |
| Among Nugroho               |                8 |               9996000 |        1249500.0000 |                    30.2500 |
| R. Tania Pangestu           |                8 |               9414000 |        1176750.0000 |                    47.7500 |
| Cakrawangsa Prasetyo, S.T.  |               10 |               7966000 |         796600.0000 |                    28.6000 |
| dr. Galuh Hastuti, S.IP     |                8 |               4352000 |         544000.0000 |                    26.7500 |
| Oni Halim                   |                8 |               2472000 |         309000.0000 |                    26.0000 |
+-----------------------------+------------------+-----------------------+---------------------+----------------------------+


'24. Pembeli sekaligus penjual
Akan dicari penjual yang juga pernah bertransaksi sebagai pembeli minimal 7 kali.
Variabel terdiri dari nama_pengguna, jumlah_transaksi_beli, jumlah_transaksi_jual. 
Urutan berdasarkan abjad dari nama_pengguna'
SELECT 
    u.nama_user AS nama_pengguna,
    COALESCE(b.jumlah_transaksi_beli, 0) AS jumlah_transaksi_beli,
    COALESCE(s.jumlah_transaksi_jual, 0) AS jumlah_transaksi_jual
FROM 
    users u
LEFT JOIN 
    (SELECT 
        buyer_id, 
        COUNT(1) AS jumlah_transaksi_beli 
     FROM 
        orders 
     GROUP BY 
        buyer_id) AS b 
    ON u.user_id = b.buyer_id
LEFT JOIN 
    (SELECT 
        seller_id, 
        COUNT(1) AS jumlah_transaksi_jual 
     FROM 
        orders 
     GROUP BY 
        seller_id) AS s 
    ON u.user_id = s.seller_id
WHERE 
    COALESCE(b.jumlah_transaksi_beli, 0) >= 7
ORDER BY 
    u.nama_user ASC;
+----------------------------+-----------------------+-----------------------+
| nama_pengguna              | jumlah_transaksi_beli | jumlah_transaksi_jual |
+----------------------------+-----------------------+-----------------------+
| Bahuwirya Haryanto         |                     8 |                  1032 |
| Bahuwirya Haryanto         |                     8 |                  1032 |
| Dr. Adika Kusmawati, S.Pt  |                     7 |                  1098 |
| Dr. Adika Kusmawati, S.Pt  |                     7 |                  1098 |
| Gandi Rahmawati            |                     8 |                  1078 |
| Gandi Rahmawati            |                     8 |                  1078 |
| Jaka Hastuti               |                     7 |                  1094 |
| Jaka Hastuti               |                     7 |                  1094 |
| R.M. Prayogo Damanik, S.Pt |                     8 |                  1044 |
| R.M. Prayogo Damanik, S.Pt |                     8 |                  1044 |
+----------------------------+-----------------------+-----------------------+


'25. Lama transaksi dibayar
Ingin diketahui bagaimana trend lama waktu transaksi dibayar sejak dibuat.
Dengan demikian akan dihitung rata-rata lama waktu dari transaksi dibuat sampai dibayar, dikelompokkan per bulan.
Variabel terdiri atas tahun_bulan, jumlah_transaksi, avg_lama_dibayar, min_lama_dibayar, max_lama_dibayar. 
Urutan berdasarkan tahun_bulan'
SELECT 
    DATE_FORMAT(created_at, '%Y-%m') AS tahun_bulan,
    COUNT(order_id) AS jumlah_transaksi,
    AVG(DATEDIFF(paid_at, created_at)) AS avg_lama_dibayar,
    MIN(DATEDIFF(paid_at, created_at)) AS min_lama_dibayar,
    MAX(DATEDIFF(paid_at, created_at)) AS max_lama_dibayar
FROM 
    orders
WHERE 
    paid_at IS NOT NULL
GROUP BY 
    DATE_FORMAT(created_at, '%Y-%m')
ORDER BY 
    tahun_bulan;
+-------------+------------------+------------------+------------------+------------------+
| tahun_bulan | jumlah_transaksi | avg_lama_dibayar | min_lama_dibayar | max_lama_dibayar |
+-------------+------------------+------------------+------------------+------------------+
| 2019-01     |              117 |           7.0467 |                1 |               14 |
| 2019-02     |              354 |           7.5399 |                1 |               14 |
| 2019-03     |              668 |           7.4602 |                1 |               14 |
| 2019-04     |              984 |           7.2910 |                1 |               14 |
| 2019-05     |             1462 |           7.3692 |                1 |               14 |
| 2019-06     |             1913 |           7.5729 |                1 |               14 |
| 2019-07     |             2667 |           7.4549 |                1 |               14 |
| 2019-08     |             3274 |           7.6216 |                1 |               14 |
| 2019-09     |             4327 |           7.5021 |                1 |               14 |
| 2019-10     |             5577 |           7.4706 |                1 |               14 |
| 2019-11     |             7162 |           7.5188 |                1 |               14 |
| 2019-12     |            10131 |           7.4980 |                1 |               14 |
| 2020-01     |             5062 |           7.4152 |                1 |               14 |
| 2020-02     |             5872 |           7.5092 |                1 |               14 |
| 2020-03     |             7323 |           7.4674 |                1 |               14 |
| 2020-04     |             7955 |           7.4792 |                1 |               14 |
| 2020-05     |            10026 |           7.4549 |                1 |               14 |
+-------------+------------------+------------------+------------------+------------------+
