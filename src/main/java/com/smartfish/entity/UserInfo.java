package com.smartfish.entity;

import jakarta.persistence.*;
import lombok.Data;

@Entity
@Table(name = "user_info")
@Data
public class UserInfo {
    @Id
    private String userId;
    private String password;
    private String userName;
    private String phone;
    private String address;
    private String fax;
    private String remarks;
    
    // 추가된 부분: DB의 pw_hint 컬럼과 연결됩니다.
    @Column(name = "pw_hint")
    private String pwHint;
}