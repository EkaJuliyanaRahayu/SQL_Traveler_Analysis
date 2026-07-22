-- ============================================================
-- Analisis Tren & Pola Perjalanan Wisatawan (Traveler Behavior Analysis)
-- Dataset: dicoding-503106.Traveler.Travel_edition (Google BigQuery)
-- ============================================================

-- 1. Seleksi Dasar Seluruh Data
SELECT * FROM `dicoding-503106.Traveler.Travel_edition`;


-- 2. Filter Berdasarkan Tujuan (WHERE + operator logika)
SELECT * FROM `dicoding-503106.Traveler.Travel_edition`
WHERE Destination = 'Japan'
   OR Destination LIKE 'T%o'
LIMIT 6;


-- 3. Analisis Biaya / Durasi Perjalanan (fungsi agregasi dasar)
SELECT
  AVG(`Duration_days_`) AS durasi_rata_rata,
  MAX(`Duration_days_`) AS durasi_terbesar,
  MIN(`Duration_days_`) AS durasi_terkecil
FROM `dicoding-503106.Traveler.Travel_edition`;


-- 4. Menghitung Total Perjalanan per Destinasi (GROUP BY)
SELECT
  Destination,
  COUNT(*) AS total_perjalanan
FROM `dicoding-503106.Traveler.Travel_edition`
WHERE Destination IS NOT NULL
GROUP BY Destination
ORDER BY total_perjalanan DESC;


-- 5. Memfilter Hasil Agregasi dengan HAVING
SELECT
  Destination,
  COUNT(*) AS total
FROM `dicoding-503106.Traveler.Travel_edition`
WHERE Destination IS NOT NULL
GROUP BY Destination
HAVING COUNT(*) > 3
ORDER BY total DESC
LIMIT 7;


-- 6. Analisis Berdasarkan Tahun (EXTRACT + ORDER BY)
SELECT * FROM `dicoding-503106.Traveler.Travel_edition`
WHERE `Start date` IS NOT NULL
  AND EXTRACT(YEAR FROM `Start date`) = 2023
ORDER BY `Start date` ASC;


-- 7. Pengelompokan Kategori Perjalanan Sederhana (CASE WHEN - 2 kondisi)
SELECT
  `Trip ID`,
  Destination,
  `Duration_days_`,
  CASE
    WHEN `Duration_days_` > 7 THEN 'Long Trip'
    ELSE 'Short Trip'
  END AS Trip_Categori
FROM `dicoding-503106.Traveler.Travel_edition`
WHERE `Duration_days_` IS NOT NULL
LIMIT 10;


-- 8. Kombinasi Filter Teks (LIKE) dan Filter Tahun (EXTRACT)
SELECT * FROM `dicoding-503106.Traveler.Travel_edition`
WHERE Destination LIKE '%a'
  AND EXTRACT(YEAR FROM `Start date`) = 2022;


-- 9. Multi-Grouping (GROUP BY 2 kolom sekaligus)
SELECT
  Destination,
  EXTRACT(YEAR FROM `Start date`) AS tahun,
  COUNT(*) AS total_perjalanan
FROM `dicoding-503106.Traveler.Travel_edition`
WHERE Destination IS NOT NULL
GROUP BY Destination, EXTRACT(YEAR FROM `Start date`)
ORDER BY total_perjalanan DESC;


-- 10. Memfilter Rata-rata Durasi per Destinasi dengan HAVING AVG(...)
SELECT
  Destination,
  AVG(`Duration_days_`) AS trip_rata_rata
FROM `dicoding-503106.Traveler.Travel_edition`
WHERE Destination IS NOT NULL
GROUP BY Destination
HAVING AVG(`Duration_days_`) > 8
ORDER BY trip_rata_rata DESC;


-- 11. CASE WHEN Multi-Kondisi dengan Rentang Angka (BETWEEN) - 3 kategori
SELECT
  `Trip ID`,
  Destination,
  `Duration_days_`,
  CASE
    WHEN `Duration_days_` < 7 THEN 'Short Trip'
    WHEN `Duration_days_` BETWEEN 7 AND 10 THEN 'Medium Trip'
    WHEN `Duration_days_` > 10 THEN 'Long Trip'
  END AS Trip_Categori
FROM `dicoding-503106.Traveler.Travel_edition`
WHERE `Duration_days_` IS NOT NULL;


-- 12. Menggabungkan CASE WHEN ke dalam GROUP BY (total per kategori durasi)
SELECT
  CASE
    WHEN `Duration_days_` < 7 THEN 'Short Trip'
    WHEN `Duration_days_` BETWEEN 7 AND 10 THEN 'Medium Trip'
    WHEN `Duration_days_` > 10 THEN 'Long Trip'
  END AS Trip_Categori,
  COUNT(*) AS Total_perjalanan
FROM `dicoding-503106.Traveler.Travel_edition`
WHERE `Duration_days_` IS NOT NULL
GROUP BY Trip_Categori
ORDER BY Total_perjalanan DESC;
