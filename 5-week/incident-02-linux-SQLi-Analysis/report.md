# Incident 02 - DVWA SQL Injection Analysis

## 1. 사건 개요
(작성 예정)

---

## 2. 분석 환경
- Target: RHEL
- Attacker: Kali Linux
- Web Server: nginx
- Application: DVWA
- 주요 로그: /var/log/nginx/access.log

---

## 3. 공격 재현 과정

### 3.1 수동 테스트
(작성 예정)

### 3.2 자동화 도구 사용
Kali Linux에서 sqlmap을 사용하여 DVWA SQL Injection 취약점을 자동으로 탐지하였다.
세션 유지를 위해 DVWA 로그인 쿠키(PHPSESSID, security=low)를 전달하였다.

sqlmap 분석 결과, GET 파라미터 id가 SQL Injection에 취약하며,
time-based blind(SLEEP) 및 UNION 기반 기법으로 취약점이 확인되었다.
또한 DBMS는 MariaDB(MySQL fork)로 식별되었고, dvwa DB가 존재함을 확인하였다.

---

## 4. 웹 로그 분석 결과

### 4.1 Access Log 분석
(작성 예정)

### 4.2 Error Log 분석
(작성 예정)

---

## 5. 타임라인 재구성

| 시간 | 이벤트 | 근거 로그 | 해석 |
|------|--------|-----------|------|
|      |        |           |      |

---

## 6. IOC (Indicators of Compromise)

| 구분 | 값 | 설명 |
|------|----|------|
|      |    |      |

---

## 7. 대응 및 개선 방안
(작성 예정)

---

## 8. 결론
(작성 예정)


