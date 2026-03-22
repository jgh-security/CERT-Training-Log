# Incident 05 - DVWA WebShell Attack Analysis

## 1. 사건 개요

본 분석은 DVWA(Damn Vulnerable Web Application) 환경에서 File Upload 취약점을 이용하여  
WebShell 업로드 및 명령 실행 공격(RCE)을 재현하고, 웹 서버 로그를 기반으로 공격 행위를 분석하기 위한 실습이다.

공격자는 업로드 기능의 검증 미흡을 악용하여 PHP 기반 WebShell을 서버에 업로드하고,  
HTTP 요청을 통해 명령을 전달하여 서버에서 실행할 수 있는 가능성을 확인한다.

본 보고서에서는 공격 재현 과정, 웹 로그 분석, 타임라인 재구성 및 IOC(침해 지표)를 기반으로  
공격 흐름을 분석할 예정이다.

---

## 2. 분석 환경

| 구분 | 환경 |
|------|------|
| Target | RHEL |
| Attacker | Kali Linux |
| Web Server | nginx |
| Web Application | DVWA |
| 주요 로그 | /var/log/nginx/access.log |

---

## 3. 공격 재현 과정

### 3.1 WebShell 업로드
(작성 예정)

- File Upload 기능을 이용한 PHP 파일 업로드
- 업로드 경로 확인 (/hackable/uploads/)
- 업로드된 파일 접근 여부 확인

---

### 3.2 명령 실행 (RCE)
(작성 예정)

- WebShell 접근을 통한 명령 실행 시도
- cmd 파라미터를 이용한 시스템 명령 전달
- 명령 실행 가능 여부 확인

---

## 4. 웹 로그 분석 결과

### 4.1 Access Log 분석
(작성 예정)

- 업로드 요청 로그 분석 (POST)
- 업로드 파일 접근 로그 분석 (GET)
- cmd 파라미터 포함 요청 식별

---

### 4.2 주요 공격 패턴 분석
(작성 예정)

- 업로드된 PHP 파일 직접 접근
- cmd 파라미터 기반 명령 실행 시도
- 반복적인 요청 패턴 분석

---

## 5. 타임라인 재구성

| 시간 | 이벤트 | 근거 로그 | 해석 |
|------|--------|-----------|------|
|      |        |           |      |
|      |        |           |      |
|      |        |           |      |

---

## 6. IOC (Indicators of Compromise)

| 구분 | 값 | 설명 |
|------|----|------|
| URL | (작성 예정) | WebShell 접근 경로 |
| Parameter | cmd= | 명령 실행 파라미터 |
| Command | (작성 예정) | 실행된 시스템 명령 |
| Pattern | (작성 예정) | WebShell 접근 패턴 |
| Directory | /hackable/uploads/ | 업로드 파일 저장 경로 |

---

## 7. 대응 및 개선 방안
(작성 예정)

- 파일 업로드 검증 강화
- 업로드 디렉토리 실행 권한 제한
- 웹 로그 모니터링 및 이상 탐지
- 입력값 필터링 및 보안 정책 적용

---

## 8. 결론
(작성 예정)
