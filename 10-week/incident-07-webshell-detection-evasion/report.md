# Incident 07 - WebShell Detection Rule Analysis

---

## 1. 사건 개요

본 보고서는 DVWA(Damn Vulnerable Web Application) 환경에서 File Upload 취약점을 통해 업로드된 WebShell을 이용한
원격 명령 실행(RCE) 공격을 기반으로, 웹 서버 로그 및 탐지 룰을 통해 공격을 식별하는 것을 목적으로 한다.

공격자는 업로드된 WebShell 파일에 접근하여 cmd 파라미터를 통해 시스템 명령을 실행할 수 있으며,
이 과정에서 발생하는 로그 및 네트워크 트래픽, 파일 특성을 기반으로 탐지 가능 여부를 분석하였다.

---

## 2. 분석 환경

| 구분              | 환경                        |
| --------------- | ------------------------- |
| Target          | RHEL                      |
| Web Server      | nginx                     |
| Web Application | DVWA                      |
| 주요 로그           | /var/log/nginx/access.log |

---

## 3. 공격 로그 분석

### 3.1 WebShell 요청 확인

WebShell을 이용한 명령 실행 요청은 다음과 같은 형태로 발생한다.

```
GET /hackable/uploads/shell.php?cmd=id
```

해당 요청을 통해 WebShell 파일에 접근하여 cmd 파라미터를 이용한 명령 실행이 이루어진다.

---

### 3.2 공격 패턴 식별

로그 분석을 통해 다음과 같은 공통 패턴을 확인하였다.

* cmd= 파라미터 포함
* /hackable/uploads/ 경로 접근
* .php 파일 실행
* GET 요청 기반 명령 전달

이는 WebShell 기반 원격 명령 실행 공격의 특징적인 패턴이다.

---

## 4. 탐지 조건 정의

### 4.1 탐지 키워드

* cmd=
* /hackable/uploads/
* .php

---

### 4.2 탐지 로직

```
cmd= 포함 요청 AND uploads 경로 접근
```

단일 키워드 기반 탐지는 오탐 가능성이 있으므로 경로 조건과 함께 사용하는 것이 효과적이다.

---

## 5. 탐지 룰 및 검증

### 5.1 grep 기반 탐지

다음 명령어를 통해 WebShell 요청을 탐지하였다.

```bash
grep "cmd=" access.log
```

이를 통해 cmd 파라미터를 포함한 요청이 로그에서 식별되는 것을 확인하였다.

---

### 5.2 탐지 우회 분석

파라미터 이름을 변경한 요청(exec=id)을 수행하였다.

해당 요청은 명령 실행은 실패하였으나, 로그에는 기록되었으며 기존 cmd 기반 탐지에서는 식별되지 않았다.

이를 통해 특정 파라미터에 의존하는 탐지 방식의 한계를 확인하였다.

---

### 5.3 Snort 기반 탐지

Snort를 이용하여 네트워크 기반 탐지를 수행하였다.

다음과 같은 룰을 적용하였다.

```
alert tcp any any -> any 80 (msg:"WebShell cmd detection"; content:"cmd="; sid:1000001; rev:1;)
```

WebShell 요청 발생 시 Snort에서 alert가 발생하는 것을 확인하였다.

이를 통해 네트워크 기반 IDS에서도 WebShell 공격을 탐지할 수 있음을 검증하였다.

---

### 5.4 YARA 기반 탐지

YARA를 이용하여 WebShell 파일 탐지를 수행하였다.

다음과 같은 룰을 적용하였다.

```
rule WebShell_Detection
{
    strings:
        $a = "system($_GET"
    condition:
        $a
}
```

업로드 디렉토리를 대상으로 스캔한 결과 WebShell 파일이 탐지되는 것을 확인하였다.

---

## 6. 대응 및 개선 방안

* 업로드 디렉토리에서 PHP 실행 제한
* 입력값 검증 강화
* system(), exec() 등 위험 함수 제한
* 로그 및 IDS 기반 탐지 체계 구축

---

## 7. 결론

본 분석에서는 WebShell을 이용한 원격 명령 실행 공격을 기반으로
로그, 네트워크, 파일 관점에서 탐지 가능성을 확인하였다.

단일 키워드 기반 탐지는 우회 가능성이 존재하므로
다양한 탐지 기법을 결합하는 것이 중요함을 확인하였다.

