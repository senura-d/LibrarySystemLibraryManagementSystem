package com.library.model;

public class StudentMember extends Member {
    private String studentId;

    public StudentMember(String memberId, String fullName, String email, String passwordHash, String studentId) {
        super(memberId, fullName, email, passwordHash);
        this.studentId = studentId;
    }

    public String getStudentId() { return studentId; }
}