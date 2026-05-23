package com.simplebank.servlet;

import com.simplebank.dao.SettingsDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;

@WebServlet("/admin/settings")
@MultipartConfig(maxFileSize = 2 * 1024 * 1024)
public class AdminSettingsServlet extends HttpServlet {
    private final SettingsDAO settingsDAO = new SettingsDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("settings", settingsDAO.getSettings());
        request.getRequestDispatcher("/admin/settings.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String bankName = request.getParameter("bankName");
        if (bankName == null || bankName.trim().isEmpty()) {
            bankName = "Aurora Bank";
        }

        String logoPath = null;
        Part logoPart = request.getPart("logo");
        if (logoPart != null && logoPart.getSize() > 0) {
            String contentType = logoPart.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                response.sendRedirect(request.getContextPath() + "/admin/settings?error=Only_image_files_allowed");
                return;
            }
            String uploadDirPath = getServletContext().getRealPath("/uploads");
            File uploadDir = new File(uploadDirPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();
            String fileName = "bank-logo.png";
            logoPart.write(uploadDirPath + File.separator + fileName);
            logoPath = "uploads/" + fileName + "?v=" + System.currentTimeMillis();
        }

        try {
            settingsDAO.updateSettings(bankName.trim(), logoPath);
            response.sendRedirect(request.getContextPath() + "/admin/settings?success=Settings_updated");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/admin/settings?error=" + e.getMessage().replace(' ', '_'));
        }
    }
}
