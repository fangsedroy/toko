import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/HapusRiwayatServlet"})
public class HapusRiwayatServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String user = "root";
        String pass = "";
        
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/db_toko", user, pass);
            Statement stmt = conn.createStatement();
            
            // Perintah SQL untuk mengosongkan seluruh isi tabel transaksi
            stmt.executeUpdate("TRUNCATE TABLE transaksi");
            
            stmt.close();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        // Setelah dihapus, kembalikan user ke halaman riwayat.jsp
        response.sendRedirect("riwayat.jsp");
    }
}