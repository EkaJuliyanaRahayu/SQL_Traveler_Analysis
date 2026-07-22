# Analisis Tren & Pola Perjalanan Wisatawan (SQL Project)

Analisis perilaku dan tren perjalanan wisatawan menggunakan SQL (Google BigQuery) untuk mengungkap pola destinasi populer, durasi perjalanan, dan tren berdasarkan waktu.

## Latar Belakang

Memahami pola perjalanan wisatawan — destinasi mana yang paling diminati, berapa lama rata-rata durasi perjalanan, dan bagaimana tren ini berubah dari tahun ke tahun — adalah informasi yang berguna bagi agen travel maupun platform pariwisata untuk merancang strategi promosi dan penawaran paket perjalanan yang lebih tepat sasaran.

Project ini menggunakan SQL untuk menjawab pertanyaan-pertanyaan tersebut secara bertahap, mulai dari eksplorasi data dasar hingga analisis kategori dan tren multi-dimensi.

## Dataset

- **Sumber**: Tabel `Travel_edition` pada dataset `Traveler` (Google BigQuery)
- **Kolom utama**: `Trip ID`, `Destination`, `Start date`, `End date`, `Duration_days_`, `Traveler name`, `Traveler age`, `Traveler gender`, dan lainnya
- **Jumlah baris**: ±139 data perjalanan

## Tools

- **SQL** (Google BigQuery Standard SQL)
- **Google BigQuery Console** sebagai query editor

## Tahapan Analisis

| # | Fokus Analisis | Konsep SQL yang Digunakan |
|---|---|---|
| 1 | Eksplorasi data awal | `SELECT *` |
| 2 | Filter perjalanan ke destinasi tertentu | `WHERE`, `OR`, `LIKE` |
| 3 | Statistik durasi perjalanan | `AVG`, `MAX`, `MIN` |
| 4 | Destinasi terpopuler | `GROUP BY`, `COUNT` |
| 5 | Menyaring destinasi dengan kunjungan signifikan | `HAVING COUNT(*)` |
| 6 | Tren perjalanan tahun 2023 | `EXTRACT(YEAR FROM ...)`, `ORDER BY` |
| 7 | Klasifikasi Long Trip vs Short Trip | `CASE WHEN` (2 kondisi) |
| 8 | Kombinasi filter nama & tahun | `LIKE`, `EXTRACT` |
| 9 | Tren destinasi per tahun | Multi-grouping (`GROUP BY` 2 kolom) |
| 10 | Destinasi dengan durasi rata-rata tinggi | `HAVING AVG(...)` |
| 11 | Klasifikasi 3 kategori durasi trip | `CASE WHEN` + `BETWEEN` |
| 12 | Ringkasan jumlah trip per kategori | `CASE WHEN` di dalam `GROUP BY` |

Query lengkap ada di [`queries.sql`](./queries.sql), screenshot hasil eksekusi ada di folder [`screenshots/`](./screenshots).

## Insight Utama

- **Durasi perjalanan** sebagian besar wisatawan berada di kisaran **Medium Trip (7–10 hari)** — kategori ini mendominasi dengan 104 dari total perjalanan, jauh di atas Short Trip (26) dan Long Trip (7). Artinya paket perjalanan ideal yang bisa ditawarkan platform travel adalah paket 1 minggu lebih.
- **Destinasi tertentu** secara konsisten muncul dengan frekuensi kunjungan tinggi (>3 kali), menunjukkan adanya beberapa destinasi favorit yang bisa dijadikan fokus promosi utama.
- **Rata-rata durasi per destinasi** bervariasi — destinasi dengan `AVG(Duration_days) > 8` menunjukkan wisatawan cenderung menghabiskan waktu lebih lama di sana, kemungkinan destinasi liburan jangka panjang (long-stay) dibanding destinasi transit/singkat.
- **Analisis per tahun** (2023) membantu melihat destinasi mana yang sedang tren pada periode tertentu, berguna untuk perencanaan campaign musiman.

## Contoh Query & Hasil

**Klasifikasi kategori durasi perjalanan (3 kategori):**

```sql
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
```

| Trip_Categori | Total_perjalanan |
|---|---|
| Medium Trip | 104 |
| Short Trip | 26 |
| Long Trip | 7 |

![Hasil klasifikasi kategori trip](./screenshots/12_case_groupby_summary.png)

## Struktur Repo

```
├── README.md
├── queries.sql          # 12 query lengkap dengan komentar
└── screenshots/          # Screenshot eksekusi query & hasil di BigQuery
```

## Author

Eka Juliyana Rahayu — Mahasiswa Teknik Informatika, tertarik di bidang Data Science / Data Analyst.
