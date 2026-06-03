import java.io.IOException;
import java.util.HashMap;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(urlPatterns = {"/TambahKeKeranjang"})
public class KeranjangServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Jika diakses langsung lewat browser (GET), arahkan ke halaman utama
        response.sendRedirect("index.html");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Ambil ID produk yang dipilih user dari tombol beli
        String produkId = request.getParameter("id");
        
        // 2. Ambil atau buat session baru untuk keranjang
        HttpSession session = request.getSession();
        HashMap<String, Integer> keranjang = (HashMap<String, Integer>) session.getAttribute("keranjang");
        
        if (keranjang == null) {
            keranjang = new HashMap<>();
        }
        
        // 3. Tambahkan produk ke dalam keranjang
        keranjang.put(produkId, keranjang.getOrDefault(produkId, 0) + 1);
        
        // 4. Simpan kembali ke dalam session browser
        session.setAttribute("keranjang", keranjang);
        
        // 5. Lempar kembali ke halaman katalog setelah sukses menambah barang
        response.sendRedirect("katalog.jsp");
    }
}