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
(작성 예정)

- WebShell 접근 로그 분석
- cmd 파라미터 포함 요청 확인

---

### 3.2 주요 공격 패턴 식별
(작성 예정)

- cmd= 파라미터 사용
- /uploads/ 경로 접근
- php 파일 실행

---

## 4. 탐지 조건 정의

### 4.1 탐지 키워드 도출
(작성 예정)

- cmd=
- shell.php
- /uploads/
- .php

---

### 4.2 탐지 로직 정의
(작성 예정)

예시:

```
cmd= 포함 요청 AND uploads 디렉토리 접근
```

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
