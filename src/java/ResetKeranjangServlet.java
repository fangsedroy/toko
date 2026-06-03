import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(urlPatterns = {"/ResetKeranjang"})
public class ResetKeranjangServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Ambil session yang sedang aktif
        HttpSession session = request.getSession();
        
        // 2. Hapus data keranjang dari session
        session.removeAttribute("keranjang");
        
        // 3. Kembalikan user ke halaman katalog produk
        response.sendRedirect("katalog.jsp");
    }
}