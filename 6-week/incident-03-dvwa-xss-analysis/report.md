# Incident 03 - DVWA XSS Attack Analysis

## 1. 사건 개요

본 분석은 DVWA(Damn Vulnerable Web Application) 환경에서 발생한 XSS(Cross-Site Scripting) 공격을 재현하고 웹 서버 로그 기반으로 공격 행위를 분석한 결과를 정리한 문서이다.

공격자는 입력값 검증이 수행되지 않는 취약점을 이용하여 JavaScript 코드를 삽입하였으며 브라우저에서 스크립트가 실행되는 현상을 확인하였다.

본 보고서에서는 Reflected XSS 및 Stored XSS 공격 재현, 웹 로그 분석, 타임라인 재구성 및 IOC를 기반으로 공격 흐름을 분석하였다.

---

## 2. 분석 환경

| 구분              | 환경                        |
| --------------- | ------------------------- |
| Target          | RHEL                      |
| Attacker        | Kali Linux                |
| Web Server      | nginx                     |
| Web Application | DVWA                      |
| 주요 로그           | /var/log/nginx/access.log |

---

## 3. 공격 재현 과정

### 3.1 Reflected XSS 테스트

DVWA의 XSS (Reflected) 페이지(`/vulnerabilities/xss_r/`)에서 다음 페이로드를 이용하여 취약점을 테스트하였다.

```html id="m8l9xu"
<script>alert(1)</script>
```

해당 페이로드 입력 후 브라우저에서 alert 창이 실행되는 것을 확인하였다.

이는 사용자 입력값이 HTML 응답에 그대로 반영되어 브라우저에서 JavaScript 코드가 실행되는 Reflected XSS 취약점이 존재함을 의미한다.

---

### 3.2 Payload 변형 테스트

기본 script 태그 외에도 이벤트 핸들러 기반 payload를 입력하여 우회 가능 여부를 확인하였다.

```html id="m4bz2h"
<img src=x onerror=alert(1)>
```

해당 payload 역시 브라우저에서 정상적으로 실행되는 것을 확인하였다.

이는 단순 script 태그 차단만으로는 XSS 방어가 불충분함을 보여준다.

---

### 3.3 Stored XSS 테스트

DVWA의 XSS (Stored) 페이지(`/vulnerabilities/xss_s/`)에서 다음 payload를 입력하였다.

```html id="u6c4pu"
<script>alert(document.cookie)</script>
```

게시글 저장 후 페이지 재접속 시 저장된 스크립트가 다시 실행되는 현상을 확인하였다.

이는 Stored XSS 취약점으로 분류된다.

---

## 4. 웹 로그 분석

### 4.1 Access Log 분석

웹 서버의 `/var/log/nginx/access.log` 로그를 분석한 결과 동일 Source IP에서 XSS 관련 요청이 반복적으로 발생한 것이 확인되었다.

특히 요청 파라미터에 script 태그 및 이벤트 핸들러가 포함된 패턴이 나타났다.

확인된 주요 공격 패턴은 다음과 같다.

* `<script>alert(1)</script>`
* `<img src=x onerror=alert(1)>`
* `<script>alert(document.cookie)</script>`

로그 예시:

```text id="c4g7s5"
GET /dvwa/vulnerabilities/xss_r/?name=<script>alert(1)</script>
```

---

### 4.2 공격 단계 분석

로그 패턴을 기반으로 공격 흐름을 분석한 결과 공격자는 다음과 같은 단계로 XSS 공격을 수행하였다.

1. 기본 Reflected XSS 테스트

```text id="tdvhr9"
<script>alert(1)</script>
```

→ 브라우저 내 스크립트 실행 여부 확인

2. 이벤트 핸들러 기반 Payload 테스트

```text id="bnwq2s"
<img src=x onerror=alert(1)>
```

→ 필터 우회 가능 여부 확인

3. Stored XSS 등록

```text id="i2j7lx"
<script>alert(document.cookie)</script>
```

→ 저장형 공격 수행

---

## 5. 타임라인 재구성

| 시간    | 이벤트                 | 근거 로그   | 해석 |
| ----- | ------------------- | ------- | -- |
| 작성 예정 | Reflected XSS 요청 발생 | /vulner |    |

