# Incident 07 - WebShell Detection Evasion Analysis

---

## 1. 사건 개요

(작성 예정)

---

## 2. 분석 환경

| 구분 | 환경 |
|------|------|
| Target | RHEL |
| Web Server | nginx |
| Web Application | DVWA |
| 주요 로그 | /var/log/nginx/access.log |

---

## 3. 기존 탐지 방식 분석

### 3.1 기존 탐지 방식
(작성 예정)

- cmd= 기반 탐지
- /uploads/ 경로 기반 탐지

---

### 3.2 기존 탐지의 한계
(작성 예정)

- 단일 키워드 기반 탐지의 한계
- 파라미터 변경 시 탐지 우회 가능
- 인코딩을 통한 우회 가능성

---

## 4. 탐지 우회 기법 분석

### 4.1 URL 인코딩 우회
(작성 예정)

예시:

cmd=
cmd%3D
%63md=

---

### 4.2 파라미터 변형 우회
(작성 예정)

예시:

cmd → c  
cmd → exec  

---

### 4.3 파일명 우회
(작성 예정)

예시:

shell.php → backdoor.php  
shell.php → upload.php  

---

## 5. 탐지 조건 고도화

### 5.1 개선된 탐지 키워드
(작성 예정)

- cmd (변형 포함)
- /uploads/
- .php

---

### 5.2 고도화된 탐지 로직
(작성 예정)

예시:

/uploads/ 경로 AND .php 접근 AND 의심 파라미터 포함

---

## 6. 탐지 룰 개선

### 6.1 grep 기반 개선
(작성 예정)

---

### 6.2 Snort 룰 개선
(작성 예정)

---

### 6.3 YARA 룰 개선
(작성 예정)

---

## 7. 대응 및 개선 방안
(작성 예정)

---

## 8. 결론
(작성 예정)