package com.library.servlet;

import com.library.recommendation.RecommendationEngine;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/recommend")
public class RecommendationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        
        String category = request.getParameter("category");

        RecommendationEngine engine = new RecommendationEngine();
        List<String> recommendations = engine.getRecommendations(category);

        request.setAttribute("recommendations", recommendations);
        request.getRequestDispatcher("recommendedBooks.jsp")
                .forward(request, response);
    }
}
