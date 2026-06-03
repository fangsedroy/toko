import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(urlPatterns = {"/BayarServlet"})
public class BayarServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        HashMap<String, Integer> keranjang = (HashMap<String, Integer>) session.getAttribute("keranjang");
        
        if (keranjang != null && !keranjang.isEmpty()) {
            String user = "root";
            String pass = "";
            
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db_toko", user, pass);
                
                // Looping semua barang di keranjang untuk disimpan ke database
                for (String namaProduk : keranjang.keySet()) {
                    int jumlah = keranjang.get(namaProduk);
                    int hargaSatuan = 0;
                    
                    // Cari harga asli dari tabel produk
                    String sqlCari = "SELECT harga FROM produk WHERE nama_produk = ?";
                    PreparedStatement pstmtCari = conn.prepareStatement(sqlCari);
                    pstmtCari.setString(1, namaProduk);
                    ResultSet rs = pstmtCari.executeQuery();
                    if (rs.next()) {
                        hargaSatuan = rs.getInt("harga");
                    }
                    rs.close();
                    pstmtCari.close();
                    
                    int totalHarga = hargaSatuan * jumlah;
                    
                    // Insert ke tabel transaksi
                    String sqlInsert = "INSERT INTO transaksi (nama_produk, harga, jumlah, total_harga) VALUES (?, ?, ?, ?)";
                    PreparedStatement pstmtInsert = conn.prepareStatement(sqlInsert);
                    pstmtInsert.setString(1, namaProduk);
                    pstmtInsert.setInt(2, hargaSatuan);
                    pstmtInsert.setInt(3, jumlah);
                    pstmtInsert.setInt(4, totalHarga);
                    pstmtInsert.executeUpdate();
                    pstmtInsert.close();
                }
                
                conn.close();
                
                // Setelah sukses disimpan ke DB, kosongkan keranjang belanja di session
                session.removeAttribute("keranjang");
                
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        // Alihkan halaman ke riwayat transaksi
        response.sendRedirect("riwayat.jsp");
    }
}