package com.library.recommendation;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class RecommendationEngine {


    private final List<String> popularBooks = Arrays.asList(
            "Clean Code",
            "Effective Java",
            "Design Patterns",
            "Refactoring",
            "Head First Java",
            "Introduction to Algorithms",
            "Code Complete",
            "Artificial Intelligence: A Modern Approach",
            "Operating System Concepts",
            "HTML & CSS"
    );

    public List<String> getRecommendations(String category) {
        List<String> books = new ArrayList<>();

        if (category == null || category.isEmpty()) {

            books.addAll(popularBooks);
        }
        else if (category.equalsIgnoreCase("Programming")) {
            books.addAll(Arrays.asList(
                    "Clean Code",
                    "Effective Java",
                    "Java: The Complete Reference",
                    "Head First Java",
                    "The Pragmatic Programmer",
                    "Code Complete",
                    "Refactoring",
                    "Introduction to Algorithms",
                    "Java Concurrency in Practice",
                    "Algorithms Unlocked"
            ));
        }
        else if (category.equalsIgnoreCase("Database")) {
            books.addAll(Arrays.asList(
                    "Learning SQL",
                    "Database System Concepts",
                    "MySQL Cookbook",
                    "SQL in 10 Minutes",
                    "Pro SQL Server",
                    "NoSQL Distilled",
                    "MongoDB: The Definitive Guide",
                    "Oracle PL/SQL Programming",
                    "High Performance MySQL",
                    "Fundamentals of Database Systems"
            ));
        }
        else if (category.equalsIgnoreCase("Web")) {
            books.addAll(Arrays.asList(
                    "HTML & CSS",
                    "JavaScript: The Good Parts",
                    "Spring in Action",
                    "Learning React",
                    "JavaScript: The Definitive Guide",
                    "Eloquent JavaScript",
                    "CSS Secrets",
                    "Node.js Design Patterns",
                    "Vue.js Up & Running",
                    "Pro Angular"
            ));
        }
        else if (category.equalsIgnoreCase("Data Science")) {
            books.addAll(Arrays.asList(
                    "Python for Data Analysis",
                    "Hands-On Machine Learning with Scikit-Learn, Keras & TensorFlow",
                    "Data Science from Scratch",
                    "Deep Learning with Python",
                    "R for Data Science",
                    "Introduction to Statistical Learning",
                    "Practical Statistics for Data Scientists",
                    "Machine Learning Yearning",
                    "Python Machine Learning",
                    "Applied Predictive Modeling"
            ));
        }
        else if (category.equalsIgnoreCase("Artificial Intelligence")) {
            books.addAll(Arrays.asList(
                    "Artificial Intelligence: A Modern Approach",
                    "Deep Learning",
                    "Machine Learning: A Probabilistic Perspective",
                    "Pattern Recognition and Machine Learning",
                    "Reinforcement Learning: An Introduction",
                    "AI Superpowers",
                    "Hands-On AI for Beginners",
                    "Python AI Projects",
                    "Neural Networks and Deep Learning",
                    "Practical AI for Developers"
            ));
        }
        else if (category.equalsIgnoreCase("Networking")) {
            books.addAll(Arrays.asList(
                    "Computer Networking: A Top-Down Approach",
                    "Data Communications and Networking",
                    "Network+ Guide to Networks",
                    "TCP/IP Illustrated",
                    "Network Warrior",
                    "Routing TCP/IP",
                    "CCNA Routing and Switching Study Guide",
                    "Wireshark Network Analysis",
                    "Computer Networks",
                    "High-Performance Browser Networking"
            ));
        }
        else if (category.equalsIgnoreCase("Cybersecurity")) {
            books.addAll(Arrays.asList(
                    "Hacking: The Art of Exploitation",
                    "The Web Application Hacker's Handbook",
                    "Cybersecurity Essentials",
                    "Metasploit: The Penetration Tester’s Guide",
                    "Network Security Essentials",
                    "Applied Cryptography",
                    "Practical Malware Analysis",
                    "Blue Team Handbook",
                    "Penetration Testing: A Hands-On Guide",
                    "The Basics of Hacking and Penetration Testing"
            ));
        }
        else if (category.equalsIgnoreCase("Cloud Computing")) {
            books.addAll(Arrays.asList(
                    "Cloud Computing: Concepts, Technology & Architecture",
                    "Architecting the Cloud",
                    "AWS Certified Solutions Architect Official Study Guide",
                    "Google Cloud Platform in Action",
                    "Azure for Architects",
                    "Cloud Native Patterns",
                    "Cloud Security and Privacy",
                    "Learning AWS",
                    "Mastering Cloud Computing",
                    "Cloud Design Patterns"
            ));
        }
        else if (category.equalsIgnoreCase("Software Engineering")) {
            books.addAll(Arrays.asList(
                    "Clean Code",
                    "Design Patterns",
                    "Refactoring",
                    "The Pragmatic Programmer",
                    "Code Complete",
                    "Software Engineering: A Practitioner's Approach",
                    "Head First Software Development",
                    "Agile Software Development",
                    "Continuous Delivery",
                    "Domain-Driven Design"
            ));
        }
        else if (category.equalsIgnoreCase("Operating Systems")) {
            books.addAll(Arrays.asList(
                    "Operating System Concepts",
                    "Modern Operating Systems",
                    "Linux Kernel Development",
                    "Understanding the Linux Kernel",
                    "Windows Internals",
                    "Operating Systems: Three Easy Pieces",
                    "The Design of the UNIX Operating System",
                    "Computer Organization and Design",
                    "Advanced Programming in the UNIX Environment",
                    "Practical Guide to Linux Commands"
            ));
        }
        else {

            books.addAll(popularBooks);
        }

        return books;
    }
}
