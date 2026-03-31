# Incident 06 - WebShell Detection Rule Analysis

## 1. 사건 개요
(작성 예정)

---

## 2. 분석 환경
- Target:
- Attacker:
- Web Server:
- Application:
- 주요 로그:

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
(작성 예정)

```bash
grep "cmd=" access.log
```

---

### 5.2 Snort 룰
(작성 예정)

```
alert tcp any any -> any 80 (msg:"WebShell Command Execution"; content:"cmd="; sid:1000001;)
```

---

### 5.3 YARA 룰
(작성 예정)

```
rule WebShell_Detection
{
    strings:
        $a = "system($_GET"
    condition:
        $a
}
```

---

## 6. 탐지 결과 분석
(작성 예정)

- 탐지 룰 적용 결과
- 탐지 가능 여부 확인

---

## 7. 대응 및 개선 방안
(작성 예정)

- 탐지 룰 기반 차단
- 웹 서버 로그 모니터링 강화
- 입력값 검증 및 필터링

---

## 8. 결론
(작성 예정)
