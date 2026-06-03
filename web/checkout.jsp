<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Checkout Resmi - Toko Database</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f4f4f4; }
        .nota-box { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); max-width: 600px; margin: 0 auto; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border-bottom: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #f8f9fa; }
        .total-row { font-size: 18px; font-weight: bold; background-color: #e9ecef; }
        .btn-bayar { background: #28a745; color: white; border: none; padding: 12px 20px; border-radius: 5px; cursor: pointer; width: 100%; font-size: 16px; margin-top: 20px; }
        .btn-kembali { display: inline-block; margin-top: 15px; color: #007bff; text-decoration: none; }
    </style>
</head>
<body>

    <div class="nota-box">
        <h2>🧾 Nota Pembelian (Sistem Database)</h2>
        <p>Rincian akhir belanjaan yang diambil langsung dari data pusat.</p>

        <table>
            <thead>
                <tr>
                    <th>Nama Barang</th>
                    <th>Harga Satuan</th>
                    <th>Jumlah</th>
                    <th>Subtotal</th>
                </tr>
            </thead>
            <tbody>
                <%
                    HashMap<String, Integer> keranjang = (HashMap<String, Integer>) session.getAttribute("keranjang");
                    int totalBayar = 0;

                    if (keranjang == null || keranjang.isEmpty()) {
                        out.print("<tr><td colspan='4' style='text-align:center;'>Tidak ada barang di keranjang.</td></tr>");
                    } else {
                        // Buka koneksi database untuk mencari harga asli terbaru
                        String user = "root";
                        String pass = "";
                        
                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db_toko", user, pass);
                            
                            for (String namaProduk : keranjang.keySet()) {
                                int jumlah = keranjang.get(namaProduk);
                                int hargaSatuan = 0;

                                // Query otomatis mencari harga berdasarkan nama produk di database
                                String sql = "SELECT harga FROM produk WHERE nama_produk = ?";
                                PreparedStatement pstmt = conn.prepareStatement(sql);
                                pstmt.setString(1, namaProduk);
                                ResultSet rs = pstmt.executeQuery();
                                
                                if (rs.next()) {
                                    hargaSatuan = rs.getInt("harga");
                                }
                                
                                int subtotal = hargaSatuan * jumlah;
                                totalBayar += subtotal;
                                
                                rs.close();
                                pstmt.close();
                %>
                <tr>
                    <td><%= namaProduk %></td>
                    <td>Rp <%= String.format("%,d", hargaSatuan) %></td>
                    <td><%= jumlah %> pcs</td>
                    <td>Rp <%= String.format("%,d", subtotal) %></td>
                </tr>
                <%
                            }
                            conn.close();
                        } catch (Exception e) {
                            out.print("<tr><td colspan='4' style='color:red;'>Gagal menghitung harga database: " + e.getMessage() + "</td></tr>");
                        }
                    }
                %>
                <tr class="total-row">
                    <td colspan="3" style="text-align: right;">Total Yang Harus Dibayar:</td>
                    <td>Rp <%= String.format("%,d", totalBayar) %></td>
                </tr>
            </tbody>
        </table>

      <% if (keranjang != null && !keranjang.isEmpty()) { %>
            <form action="BayarServlet" method="POST">
                <button type="submit" class="btn-bayar">
                    💵 Bayar Sekarang (Simpan Permanen)
                </button>
            </form>
        <% } %>
        <br>
        <a href="katalog.jsp" class="btn-kembali">← Kembali Belanja</a>
    </div>

</body>
</html>