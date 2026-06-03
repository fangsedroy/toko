<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Riwayat Transaksi Pembelian</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f4f4f4; }
        .container { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); max-width: 800px; margin: 0 auto; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border-bottom: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #28a745; color: white; }
        .btn-kembali { display: inline-block; margin-top: 20px; background: #007bff; color: white; padding: 10px 15px; text-decoration: none; border-radius: 5px; }
    </style>
</head>
<body>

    <div class="container">
        <h2>📜 Riwayat Transaksi Penjualan Toko</h2>
        <p>Berikut adalah daftar transaksi yang sudah sukses dibayar dan masuk ke database pusat:</p>

        <table>
            <thead>
                <tr>
                    <th>Waktu Transaksi</th>
                    <th>Nama Produk</th>
                    <th>Harga</th>
                    <th>Jumlah</th>
                    <th>Total Bayar</th>
                </tr>
            </thead>
           <tbody>
                <%
                    String user = "root";
                    String pass = "";
                    int grandTotal = 0; // Tambahkan variabel penampung total keseluruhan
                    
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db_toko", user, pass);
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT * FROM transaksi ORDER BY tanggal_transaksi DESC");
                        
                        boolean adaData = false;
                        while(rs.next()) {
                            adaData = true;
                            int totalBayar = rs.getInt("total_harga");
                            grandTotal += totalBayar; // Jumlahkan setiap total bayar ke grandTotal
                %>
                <tr>
                    <td><%= rs.getTimestamp("tanggal_transaksi") %></td>
                    <td><%= rs.getString("nama_produk") %></td>
                    <td>Rp <%= String.format("%,d", rs.getInt("harga")) %></td>
                    <td><%= rs.getInt("jumlah") %> pcs</td>
                    <td><strong>Rp <%= String.format("%,d", totalBayar) %></strong></td>
                </tr>
                <%
                        }
                        
                        if (!adaData) {
                            out.print("<tr><td colspan='5' style='text-align:center;'>Belum ada riwayat transaksi apapun.</td></tr>");
                        } else {
                            // --- BARIS BARU: MENAMPILKAN TOTAL KESELURUHAN DI PALING BAWAH TABEL ---
                %>
                <tr style="background-color: #e9ecef; font-size: 16px; font-weight: bold;">
                    <td colspan="4" style="text-align: right;">Total Pendapatan Keseluruhan:</td>
                    <td style="color: #28a745;">Rp <%= String.format("%,d", grandTotal) %></td>
                </tr>
                <%
                        }
                        
                        rs.close();
                        stmt.close();
                        conn.close();
                    } catch (Exception e) {
                        out.print("<tr><td colspan='5' style='color:red;'>Gagal memuat riwayat: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>

        <a href="katalog.jsp" class="btn-kembali">← Kembali ke Katalog Utama</a>

       

        <a href="HapusRiwayatServlet" onclick="return confirm('Apakah Anda yakin ingin menghapus semua riwayat transaksi?')" 
           style="display: inline-block; margin-top: 20px; margin-left: 10px; background: #dc3545; color: white; padding: 10px 15px; text-decoration: none; border-radius: 5px;">
           🗑️ Kosongkan Semua Riwayat
        </a>
    </div>

</body>
</html>
    </div>

</body>
</html>