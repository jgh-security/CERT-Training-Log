# Incident 03 - DVWA XSS Attack Analysis

## 1. 사건 개요

본 분석은 DVWA(Damn Vulnerable Web Application) 환경에서 발생 가능한 XSS(Cross-Site Scripting) 공격을 재현하고 웹 서버 로그 기반으로 공격 행위를 분석하기 위한 실습이다.

공격자는 입력값 검증이 수행되지 않는 취약점을 이용하여 JavaScript 코드를 삽입할 수 있으며, 브라우저에서 스크립트가 실행되는 현상을 통해 취약 여부를 확인할 수 있다.

본 보고서에서는 Reflected XSS 및 Stored XSS 공격을 단계적으로 수행하고 access log를 기반으로 공격 흐름을 분석한다.

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

### 3.1 Day 1 (월요일) - Reflected XSS 기초 테스트

DVWA의 XSS (Reflected) 페이지(`/vulnerabilities/xss_r/`)에서 기본 XSS 페이로드를 입력하여 브라우저 반응을 확인하였다.

```html
<script>alert(1)</script>
```

해당 페이로드 입력 후 브라우저에서 alert 창이 실행되는지 확인한다.

확인 항목:

* alert 창 실행 여부
* URL 파라미터 내 script 태그 반영 여부

증적 자료:

* payload 입력 화면 캡처
* alert 실행 화면 저장

---

### 3.2 Day 2 (화요일) - Reflected XSS Payload 변형 테스트

다양한 XSS 페이로드를 입력하여 필터링 여부를 확인한다.

```html
<script>alert('XSS')</script>
<img src=x onerror=alert(1)>
```

확인 항목:

* script 태그 차단 여부
* 이벤트 핸들러 기반 실행 여부

증적 자료:

* payload별 실행 결과 비교 캡처

---

### 3.3 Day 3 (수요일) - Stored XSS 테스트

DVWA의 XSS (Stored) 페이지(`/vulnerabilities/xss_s/`)에서 다음 페이로드를 입력한다.

```html
<script>alert(document.cookie)</script>
```

게시글 저장 후 페이지 재접속 시 저장된 스크립트가 다시 실행되는지 확인한다.

확인 항목:

* 저장 후 alert 발생 여부
* Stored XSS 특성 확인

증적 자료:

* 저장 화면 캡처
* 재접속 실행 화면 저장

---

## 4. 웹 로그 분석

### 4.1 Day 4 (목요일) - Access Log 분석

웹 서버의 `/var/log/nginx/access.log` 로그를 분석하여 XSS 관련 요청을 확인한다.

```bash
sudo grep "script" /var/log/nginx/access.log
```

또는 실시간 확인:

```bash
sudo tail -f /var/log/nginx/access.log
```

확인 항목:

* script 문자열 포함 요청 확인
* Source IP 식별
* 요청 URI 분석

예상 로그 패턴:

```text
GET /dvwa/vulnerabilities/xss_r/?name=<script>alert(1)</script>
```

증적 자료:

* access.log 캡처 저장

---

### 4.2 공격 단계 분석

로그 기반 분석 결과 공격자는 다음 순서로 공격을 수행한다.

1. Reflected XSS 테스트

```text
<script>alert(1)</script>
```

→ 브라우저 내 스크립트 실행 여부 확인

2. Payload 변형 테스트

```text
<img src=x onerror=alert(1)>
```

→ 우회 가능 여부 확인

3. Stored XSS 테스트

```text
<script>alert(document.cookie)</script>
```

→ 저장형 공격 확인

---

## 5. 타임라인 재구성

### Day 5 (금요일) - 공격 흐름 정리

| 시간    | 이벤트              | 근거 로그      | 해석          |
| ----- | ---------------- | ---------- | ----------- |
| 작성 예정 | Reflected XSS 요청 | access.log | 초기 공격       |
| 작성 예정 | Stored XSS 등록    | access.log | 저장형 공격      |
| 작성 예정 | 재접속 요청           | access.log | 저장된 스크립트 실행 |

---

## 6. IOC (Indicators of Compromise)

| 구분        | 값                                       | 설명                |
| --------- | --------------------------------------- | ----------------- |
| Source IP | 작성 예정                                   | 공격 수행 IP          |
| 공격 대상 URL | /vulnerabilities/xss_r/                 | Reflected XSS 페이지 |
| 공격 대상 URL | /vulnerabilities/xss_s/                 | Stored XSS 페이지    |
| 공격 패턴     | <script>alert(1)</script>               | 기본 XSS 테스트        |
| 공격 패턴     | <img src=x onerror=alert(1)>            | 이벤트 기반 실행         |
| 공격 패턴     | <script>alert(document.cookie)</script> | 쿠키 접근 시도          |
| 로그 위치     | /var/log/nginx/access.log               | 웹 서버 접근 로그        |

---

## 7. 대응 및 개선 방안

### 7.1 입력값 검증 강화

사용자 입력값에서 scrip
