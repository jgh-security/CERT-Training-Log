# Incident 06 - WebShell Detection Rule Analysis

---

## 1. 사건 개요

본 보고서는 DVWA(Damn Vulnerable Web Application) 환경에서 File Upload 취약점을 통해 업로드된 WebShell을 이용한
원격 명령 실행(RCE) 공격을 기반으로, 웹 서버 로그에서 탐지 가능한 패턴을 분석하고 탐지 룰을 정의하는 것을 목적으로 한다.

공격자는 업로드된 WebShell 파일에 접근하여 cmd 파라미터를 통해 시스템 명령을 실행할 수 있으며,
이 과정에서 발생하는 웹 로그를 기반으로 공격 패턴을 식별하고 탐지 기준을 도출하였다.

---

## 2. 분석 환경

| 구분 | 환경 |
|------|------|
| Target | RHEL |
| Web Server | nginx |
| Web Application | DVWA |
| 주요 로그 | /var/log/nginx/access.log |

---

## 3. 공격 로그 분석

### 3.1 WebShell 공격 로그 확인

이전 주차에서 수행한 WebShell 공격 실습 과정에서 확보한 access log 화면을 기준으로,
WebShell 명령 실행 요청을 확인하였다.

확인된 주요 요청은 다음과 같다.

```
GET /hackable/uploads/shell.php?cmd=id
GET /hackable/uploads/shell.php?cmd=whoami
GET /hackable/uploads/shell.php?cmd=uname%20-a
```

위 요청을 통해 업로드된 WebShell 파일에 직접 접근하여 cmd 파라미터를 이용한
명령 실행이 이루어진 것을 확인할 수 있다.

또한 WebShell을 통해 실제 시스템 명령이 실행되는 것을 확인하였다.

![WebShell Command Execution](./evidence/screenshots/03_rce_id_result.png)

해당 결과를 통해 cmd 파라미터를 이용한 원격 명령 실행(RCE)이 정상적으로 수행됨을 확인할 수 있다.

---

### 3.2 주요 공격 패턴 식별

WebShell 공격 로그를 기반으로 다음과 같은 공통 패턴을 식별하였다.

- cmd= 파라미터를 포함한 요청
- /hackable/uploads/ 디렉토리 접근
- shell.php 파일 실행
- GET 요청을 통한 명령 전달

해당 패턴은 정상적인 사용자 요청에서는 발생하지 않는 비정상적인 요청 형태이며,
WebShell을 이용한 원격 명령 실행 공격의 특징으로 판단할 수 있다.

---

## 4. 탐지 조건 정의

### 4.1 탐지 키워드 도출

WebShell 공격 로그 분석을 통해 다음과 같은 탐지 키워드를 도출하였다.

- cmd=
- shell.php
- /hackable/uploads/
- .php

---

### 4.2 탐지 로직 정의

도출된 키워드를 기반으로 다음과 같은 탐지 조건을 정의하였다.

```
cmd= 포함 요청 AND /hackable/uploads/ 경로 접근
```

또는

```
cmd= 포함 요청 AND .php 파일 접근
```

해당 조건은 WebShell을 이용한 명령 실행 요청을 탐지하기 위한 기본적인 탐지 로직이다.

---

## 5. 탐지 룰 생성

### 5.1 grep 기반 탐지

WebShell 공격 탐지를 위해 grep을 이용한 로그 분석을 수행하였다.

다음과 같은 명령어를 사용하여 cmd 파라미터를 포함한 요청을 탐지할 수 있다.

```bash
grep "cmd=" access.log
```

실제 환경에서는 로그 로테이션 및 파일 변경으로 인해 동일 조건 검색 시 결과가 출력되지 않을 수 있다.

따라서 본 실습에서는 WebShell 요청 패턴(cmd=)을 기반으로 탐지 가능함을 확인하였다.

---

## 6. 탐지 결과 분석

cmd 파라미터는 WebShell을 통한 명령 실행 시 필수적으로 포함되는 특징적인 요소로,
해당 키워드를 기반으로 공격 요청을 효과적으로 식별할 수 있다.

또한 uploads 디렉토리 접근과 결합할 경우 오탐(false positive)을 줄이고
보다 정확한 탐지가 가능하다.

---

## 7. 대응 및 개선 방안

### 7.1 업로드 파일 실행 제한

업로드 디렉토리에서 PHP 실행을 차단하여 WebShell 실행을 방지해야 한다.

---

### 7.2 입력값 검증 강화

cmd와 같은 파라미터를 통한 명령 실행이 불가능하도록 입력값 검증을 강화해야 한다.

---

### 7.3 위험 함수 제한

php.ini 설정을 통해 system(), exec() 등의 함수 실행을 제한(disable_functions)해야 한다.

---

### 7.4 로그 기반 탐지 체계 구축

cmd=, /uploads/, .php 등의 패턴을 기반으로 지속적인 로그 모니터링 체계를 구축해야 한다.

---

## 8. 결론

본 분석에서는 DVWA 환경에서 WebShell을 이용한 원격 명령 실행 공격을 기반으로
웹 로그에서 탐지 가능한 패턴을 도출하였다.

cmd 파라미터와 uploads 경로 접근은 WebShell 공격의 핵심적인 특징으로,
이를 기반으로 간단한 탐지 룰을 생성할 수 있음을 확인하였다.

단순한 파일 업로드 취약점이라도 적절한 통제가 이루어지지 않을 경우
서버 명령 실행으로 이어질 수 있으며, 이를 탐지하기 위한 로그 기반 분석과
탐지 룰 적용이 중요함을 확인하였다.
