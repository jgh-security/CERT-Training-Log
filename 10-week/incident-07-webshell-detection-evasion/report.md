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

이전 주차에서는 다음과 같은 조건을 기반으로 WebShell 공격을 탐지할 수 있다.

- cmd= 파라미터 기반 탐지
- /hackable/uploads/ 경로 접근 탐지
- .php 파일 실행 탐지

---

### 3.2 기존 탐지의 한계

기존 탐지 방식은 단순 키워드 기반으로 동작하기 때문에 다음과 같은 한계가 존재한다.

- cmd 파라미터 이름이 변경될 경우 탐지 우회 가능
- URL 인코딩을 사용할 경우 탐지 회피 가능
- 특정 파일명(shell.php)에 의존할 경우 다른 이름으로 우회 가능

따라서 보다 효과적인 탐지를 위해서는 다양한 우회 기법을 고려한 탐지 로직이 필요하다.

---

## 4. 탐지 우회 기법 분석

### 4.1 기존 탐지 검증

WebShell 요청(cmd=id)을 수행한 후 access log를 확인하였다.

이후 grep 명령어를 이용하여 cmd= 파라미터를 포함한 요청을 탐지하였으며,
다음과 같이 WebShell 명령 실행 요청이 로그에서 식별되는 것을 확인하였다.

```
GET /hackable/uploads/shell.php?cmd=id HTTP/1.1
```

이를 통해 cmd 파라미터 기반 탐지 방식이 실제 로그에서도 유효하게 동작함을 확인하였다.

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
