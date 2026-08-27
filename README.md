# Sales Performance Dashboard

Project analisis data untuk memantau performa penjualan melalui proses ekstraksi data dari database SQL, penggabungan data transaksi, perhitungan metrik penjualan, dan visualisasi interaktif menggunakan Microsoft Excel.

Dataset yang digunakan adalah **ClassicModels**, yaitu dataset penjualan produk model kendaraan dan koleksi terkait. Hasil analisis dirangkum dalam workbook Excel yang berisi data transaksi terintegrasi, PivotTable, metrik performa, serta grafik analisis.

## Tujuan Project

Project ini dibuat untuk menjawab beberapa pertanyaan bisnis berikut:

- Berapa total sales, cost, profit, dan profit margin?
- Produk dan product line apa yang paling banyak terjual?
- Bagaimana tren sales dan profit setiap bulan serta setiap tahun?
- Negara mana yang memberikan kontribusi profit terbesar?
- Siapa customer dengan jumlah pembelian/order terbanyak?
- Apa peluang tindakan bisnis berdasarkan pola penjualan yang ditemukan?

## Alur Data

```text
Database ClassicModels
        |
        v
Data.sql
  (struktur dan data tabel)
        |
        v
Ekspor SQL.sql
  (JOIN + perhitungan metrik)
        |
        v
Workbook Excel
  (Project + PivotTable + chart)
        |
        v
Sales Performance Dashboard / Report
```

Query pada `Ekspor SQL.sql` menggabungkan tabel berikut:

- `customers` untuk identitas customer dan negara
- `orders` untuk tanggal serta nomor order
- `orderdetails` untuk jumlah unit dan harga jual per item
- `products` untuk nama produk, product line, dan harga beli

Query menghasilkan kolom turunan berikut:

- `Sales = priceEach × quantityOrdered`
- `Cost = buyPrice × quantityOrdered`
- `Profit = Sales − Cost`
- `purchaseNumber` menggunakan `DENSE_RANK()` untuk memberi urutan pembelian customer berdasarkan tanggal order

## Isi Repository

| File | Deskripsi |
|---|---|
| [`Data.sql`](Data.sql) | SQL dump database `classicmodels`, termasuk struktur tabel dan data sumber. |
| [`Ekspor SQL.sql`](Ekspor%20SQL.sql) | Query ekstraksi dan transformasi data transaksi untuk kebutuhan analisis. |
| [`Dashboard Project 2.0.xlsx`](Dashboard%20Project%202.0.xlsx) | Workbook Excel berisi data Project, PivotTable, metrik, dan visualisasi. |
| [`Personal Project By Taufik Willy H..pdf`](Personal%20Project%20By%20Taufik%20Willy%20H..pdf) | Laporan presentasi hasil analisis dan rekomendasi bisnis. |

## Struktur Workbook Excel

Workbook `Dashboard Project 2.0.xlsx` memiliki tiga worksheet:

- **Pivot**: ringkasan metrik, analisis product line, top product, sales tahunan-bulanan, profit berdasarkan negara, profit bulanan, dan top buyer.
- **Project**: dataset transaksi hasil query SQL yang telah disiapkan untuk analisis.
- **Dashboard**: worksheet yang disediakan untuk tampilan dashboard.

## Data Dictionary Worksheet `Project`

Worksheet `Project` menggunakan satu baris sebagai satu **detail produk dalam sebuah order**. Oleh karena itu, satu `orderNumber` dapat muncul di beberapa baris apabila order tersebut berisi beberapa produk.

| Variabel | Tipe/format | Deskripsi |
|---|---|---|
| `orderDate` | Date | Tanggal ketika order dibuat. Pada file Excel, tanggal dapat tersimpan sebagai serial date Excel. Digunakan untuk analisis tren berdasarkan tahun dan bulan. |
| `orderNumber` | Integer | Nomor unik order. Satu order dapat memiliki beberapa baris detail produk. |
| `customerNumber` | Integer | ID unik customer yang melakukan order. |
| `customerName` | Text | Nama perusahaan/customer pembeli. |
| `country` | Text | Negara tempat customer berada. Digunakan untuk analisis geografis dan profit per negara. |
| `productLine` | Text/kategori | Kategori atau lini produk, misalnya `Classic Cars`, `Vintage Cars`, `Motorcycles`, `Planes`, `Ships`, `Trains`, serta `Trucks and Buses`. |
| `productName` | Text | Nama spesifik produk yang dijual. |
| `quantityOrdered` | Integer | Jumlah unit produk pada baris order tersebut. Dapat dijumlahkan untuk memperoleh total unit terjual. |
| `priceEach` | Decimal | Harga jual per unit pada saat transaksi. Nilai ini berasal dari detail order dan dapat berbeda antar transaksi. |
| `buyPrice` | Decimal | Harga beli/modal per unit produk. Digunakan untuk menghitung cost. |
| `Sales` | Decimal | Nilai penjualan pada baris transaksi. Rumus: `priceEach × quantityOrdered`. |
| `Cost` | Decimal | Total biaya produk pada baris transaksi. Rumus: `buyPrice × quantityOrdered`. |
| `Profit` | Decimal | Profit kotor pada baris transaksi. Rumus: `Sales − Cost`. |
| `purchaseNumber` | Integer | Urutan pembelian customer berdasarkan `orderDate`, dihitung dengan `DENSE_RANK()` dan dipartisi berdasarkan `customerNumber`. Nilai yang sama dapat muncul pada beberapa baris produk dalam order/tanggal pembelian yang sama. |

### Catatan Penggunaan Variabel

- `Sales`, `Cost`, dan `Profit` adalah metrik level **order detail**, bukan nilai unik per order.
- Untuk menghitung total sales atau profit, gunakan agregasi `SUM()` pada kolom terkait.
- Untuk menghitung jumlah order, gunakan `COUNT(DISTINCT orderNumber)`, bukan jumlah baris worksheet.
- Untuk menghitung jumlah customer, gunakan `COUNT(DISTINCT customerNumber)`.
- `purchaseNumber` tidak sebaiknya dihitung dengan `COUNT()` sebagai jumlah order karena kolom ini merupakan ranking pembelian customer. Untuk menghitung order per customer, gunakan `COUNT(DISTINCT orderNumber)`.
- Nilai mata uang pada workbook mengikuti angka sumber dataset dan ditampilkan dalam satuan dolar Amerika pada laporan.

## Ringkasan Dataset Project

Berdasarkan worksheet `Project` pada workbook:

- Periode transaksi: **6 Januari 2003 – 31 Mei 2005**
- **2.996** baris detail transaksi
- **326** order unik
- **98** customer unik
- **109** produk unik
- **21** negara
- **105.516** unit terjual
- Total sales: sekitar **$9,604 juta**
- Total cost: sekitar **$5,778 juta**
- Total profit: sekitar **$3,826 juta**
- Profit margin: sekitar **39,84%**

## Ringkasan Insight

Insight berikut berasal dari PivotTable dan laporan yang tersimpan di repository:

1. **Performa finansial**
   - Total sales sekitar `$9,604M` dan total profit sekitar `$3,826M`.
   - Profit margin keseluruhan sekitar `39,84%`.

2. **Produk terlaris**
   - `1992 Ferrari 360 Spider red` menjadi produk dengan unit terjual terbanyak, yaitu **1.808 unit**.
   - `1937 Lincoln Berline` berada di posisi berikutnya dengan **1.111 unit**.
   - Product line dengan proporsi unit terbesar adalah **Classic Cars**, diikuti `Vintage Cars`.

3. **Profit berdasarkan negara**
   - **USA** merupakan kontributor profit terbesar, sekitar `$1,309M`.
   - Negara dengan kontribusi profit besar berikutnya adalah **Spain** dan **France**.

4. **Pola musiman**
   - Sales meningkat tajam pada periode **Oktober–November**.
   - November merupakan bulan dengan sales tertinggi pada ringkasan workbook.
   - Periode Juni–September relatif lebih rendah dibandingkan puncak akhir tahun.

5. **Customer utama**
   - Pada PivotTable, `Euro+ Shopping Channel` memiliki nilai `Count of purchaseNumber` tertinggi, yaitu **259** baris transaksi/detail pembelian.
   - `Mini Gifts Distributors Ltd,` berada di urutan berikutnya dengan **180** baris transaksi/detail pembelian.
   - Angka tersebut bukan jumlah order unik; dari worksheet `Project`, keduanya masing-masing memiliki **26** dan **17** `orderNumber` unik.

## Rekomendasi Bisnis

Berdasarkan pola tersebut, beberapa tindakan yang dapat dipertimbangkan adalah:

- Menyiapkan inventory lebih awal untuk mengurangi risiko stockout sebelum periode Oktober–November.
- Menawarkan loyalty incentive, volume-based rebate, atau kontrak khusus kepada customer dengan volume pembelian tinggi.
- Mengevaluasi alokasi marketing berdasarkan kontribusi profit tiap negara, dengan perhatian khusus pada pasar USA, Spain, dan France.
- Menggunakan dashboard untuk memantau perubahan sales, profit, product line, dan customer secara berkala.

Rekomendasi tersebut bersifat analisis deskriptif dari dataset historis; keputusan aktual tetap perlu mempertimbangkan inventory, kapasitas operasional, biaya marketing, dan faktor bisnis lain.

## Cara Menjalankan Query

1. Gunakan MySQL atau database yang kompatibel dengan sintaks SQL pada `Data.sql`.
2. Jalankan `Data.sql` untuk membuat database `classicmodels` beserta tabel dan datanya.
3. Pilih database `classicmodels`.
4. Jalankan query pada `Ekspor SQL.sql`.
5. Export hasil query ke CSV/Excel apabila diperlukan.
6. Buka `Dashboard Project 2.0.xlsx` untuk melihat data Project dan ringkasan PivotTable.

Contoh perhitungan metrik utama:

```sql
Sales  = priceEach * quantityOrdered
Cost   = buyPrice * quantityOrdered
Profit = Sales - Cost
```

## Tools

- MySQL atau database SQL kompatibel
- Microsoft Excel
- SQL: `JOIN`, CTE, agregasi, dan window function `DENSE_RANK()`
- PivotTable dan chart Excel

## Catatan Reproduksibilitas

- `Data.sql` berisi dataset sumber sehingga query dapat dijalankan ulang secara lokal.
- Hasil agregasi dapat mengalami perbedaan pembulatan kecil karena nilai desimal pada Excel/SQL.
- Pastikan format `orderDate` dikenali sebagai tanggal sebelum membuat grouping berdasarkan tahun atau bulan.
- Jangan menggunakan `COUNT(*)` sebagai jumlah order tanpa deduplikasi karena dataset berada pada grain order detail.

## Author

**Taufik Willy H.**

- LinkedIn: [linkedin.com/in/taufikwilly8](https://www.linkedin.com/in/taufikwilly8)
- Email: Willytaufik8@gmail.com

## License

Repository ini tidak menyertakan file atau pernyataan lisensi khusus. Gunakan dan distribusikan isinya sesuai izin pemilik repository.

---

Project ini menunjukkan bagaimana data transaksi dari SQL dapat dipersiapkan menjadi dataset analitik dan diubah menjadi dashboard Excel yang membantu pemantauan performa penjualan serta pengambilan keputusan berbasis data.

[![GitHub Repository](https://img.shields.io/badge/GitHub-Data--Analyst--Project-181717?logo=github)](https://github.com/willytaufik8/Data-Analyst-Project)

---

**Project By Taufik Willy H.**

Terima kasih.

LinkedIn: [linkedin.com/in/taufikwilly8](https://www.linkedin.com/in/taufikwilly8)
Email: Willytaufik8@gmail.com
