<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.sql.*"%> <!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Toko Online Dinamis - Database</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; background-color: #f4f4f4; }
        .produk-container { display: flex; gap: 20px; flex-wrap: wrap; }
        .card { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); width: 200px; text-align: center; }
        .btn-beli { background: #28a745; color: white; border: none; padding: 10px 15px; border-radius: 5px; cursor: pointer; }
        .btn-beli:hover { background: #218838; }
        .keranjang-box { background: #fff3cd; padding: 15px; border-radius: 8px; margin-bottom: 20px; border: 1px solid #ffeeba; }
    </style>
</head>
<body>

    <h1>Selamat Datang di Toko Database</h1>

    <div class="keranjang-box">
        <h3>🛒 Isi Keranjang Belanja Kamu:</h3>
        <%
            HashMap<String, Integer> keranjang = (HashMap<String, Integer>) session.getAttribute("interaktif"); // disesuaikan dengan nama session kemarin
            if (keranjang == null || keranjang.isEmpty()) {
                // Jika session kemarin pakai nama "keranjang", sesuaikan di bawah ini:
                keranjang = (HashMap<String, Integer>) session.getAttribute("keranjang");
            }
            
            if (keranjang == null || keranjang.isEmpty()) {
                out.print("<p>Keranjang masih kosong. Yuk belanja!</p>");
            } else {
                out.print("<ul>");
                for (String idProduk : keranjang.keySet()) {
                    int jumlah = keranjang.get(idProduk);
                    out.print("<li>" + idProduk + " — Jumlah: <strong>" + jumlah + " pcs</strong></li>");
                }
                out.print("</ul>");
                out.print("<a href='checkout.jsp'><button style='background:#007bff; color:white; border:none; padding:10px 15px; border-radius:5px; cursor:pointer; margin-right:10px;'>Pergi ke Checkout ➔</button></a>");
                out.print("<a href='ResetKeranjang'><button style='background:#dc3545; color:white; border:none; padding:10px 15px; border-radius:5px; cursor:pointer;'> Kosongkan Keranjang</button></a>");
            }
        %>
    </div>

   <h2>Katalog Produk (Real-time DB)</h2>
    <div class="produk-container">
        <%
            String url = "jdbc:mysql://localhost:3306/db_toko"; 
            String user = "root";
            String pass = "";
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(url, user, pass);
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT * FROM produk");
                
                while(rs.next()) {
                    String namaBarang = rs.getString("nama_produk");
                    int hargaBarang = rs.getInt("harga");
                    String namaGambar = rs.getString("gambar"); // Ambil nama file gambar dari DB
        %>
        <div class="card">
            <img src="images/<%= namaGambar %>" alt="<%= namaBarang %>" style="width:100%; height:150px; object-fit:cover; border-radius:5px; margin-bottom:10px;">
            
            <h3><%= namaBarang %></h3>
            <p>Harga: Rp <%= String.format("%,d", hargaBarang) %></p>
            <form action="TambahKeKeranjang" method="POST">
                <input type="hidden" name="id" value="<%= namaBarang %>">
                <button type="submit" class="btn-beli">Tambah ke Keranjang</button>
            </form>
        </div>
        <%
                }
                rs.close();
                stmt.close();
                conn.close();
            } catch (Exception e) {
                out.print("<p style='color:red;'>Gagal memuat database: " + e.getMessage() + "</p>");
            }
        %>
    </div>

</body>
</html>