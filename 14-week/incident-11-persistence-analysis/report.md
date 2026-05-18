# Incident 11 - Linux Persistence Analysis

## 1. 사건 개요

본 분석은 Linux 환경에서 공격자가 시스템 내 지속성(Persistence)을 확보하는 과정을 재현하고, 관련 아티팩트를 기반으로 침해 흔적을 분석하는 과정을 정리한 문서이다.

공격자는 SSH를 통해 시스템에 접근한 이후 root 권한을 획득하고, cron 및 bashrc 기반 Persistence 기법을 사용하여 시스템 내 자동 실행 환경을 구성하였다.

이후 bash history, secure 로그, crontab 및 bashrc 파일을 기반으로 공격 흐름을 분석하고 타임라인을 재구성할 예정이다.

---

## 2. 분석 목표

* Linux Persistence 행위 분석
* cron 기반 자동 실행 흔적 분석
* bashrc 기반 자동 실행 행위 분석
* SSH 및 sudo 로그 기반 침해 흐름 추적
* 시스템 내부 아티팩트 기반 행위 분석
* 타임라인 기반 공격 흐름 재구성

---

## 3. 분석 환경

| 항목 | 내용 |
|------|------|
| Attacker | Kali Linux (10.0.0.51) |
| Target | RHEL Linux (10.0.0.50) |
| 분석 대상 | bashrc, crontab, secure 로그 |
| 분석 도구 | Linux 기본 명령어 |
| 분석 방식 | Persistence 기반 포렌식 분석 |

---

## 4. 분석 대상

### 4.1 bashrc 기반 Persistence 분석

공격자는 로그인 시 자동 실행을 위해 `.bashrc` 파일을 수정할 예정이다.

예상 Persistence 행위:

```text
echo "/tmp/realbackdoor.sh" >> ~/.bashrc
```

이를 통해 사용자가 로그인할 때마다 특정 스크립트가 자동 실행되는 환경을 구성할 예정이다.

---

### 4.2 cron 기반 Persistence 분석

공격자는 cron을 이용하여 주기적으로 특정 스크립트가 실행되도록 설정할 예정이다.

예상 Persistence 행위:

```text
* * * * * /tmp/realbackdoor.sh
```

이를 통해 일정 주기로 Persistence가 유지되는 환경을 구성할 예정이다.

---

### 4.3 secure 로그 분석

```text
/var/log/secure
```

SSH 로그인 및 sudo 사용 기록을 분석하여 공격 흐름을 추적할 예정이다.

예상 확인 이벤트:

```text
Accepted password for nova
sudo: nova : USER=root
session opened for user root
```

---

## 5. 분석 예정 항목

### 5.1 SSH 접속 확인

* Attacker → Target SSH 접속 수행 예정
* secure 로그 기반 접속 흔적 분석 예정

---

### 5.2 Persistence 생성 행위 분석

* bashrc 수정 행위 확인 예정
* cron 등록 행위 확인 예정
* Persistence 스크립트 생성 여부 분석 예정

---

### 5.3 시스템 아티팩트 분석

* bash_history 기반 명령 기록 분석 예정
* secure 로그 기반 권한 상승 분석 예정
* cron 및 bashrc 기반 자동 실행 흔적 분석 예정

---

## 6. 예상 결과

* SSH 접속 흔적 확인 가능
* sudo 기반 권한 상승 행위 확인 가능
* bashrc 기반 Persistence 흔적 확인 가능
* cron 기반 자동 실행 흔적 확인 가능
* 시스템 내부 아티팩트 기반 행위 추적 가능
* 타임라인 기반 공격 흐름 재구성 가능

---

## 7. 결론(예정)

이번 분석을 통해 Linux 환경에서 Persistence가 어떻게 구성되는지 확인하고, 시스템 내부 아티팩트를 기반으로 공격자의 지속성 확보 행위를 분석할 예정이다.

또한 단순 로그 분석을 넘어 cron, bashrc 등 실제 시스템 구성 요소를 기반으로 침해 흐름을 추적함으로써 포렌식 관점의 분석 경험을 확장할 예정이다.

향후에는 systemd 서비스 기반 Persistence, 계정 생성 기반 Persistence 및 로그 삭제 행위 분석 등 보다 심화된 침해사고 분석으로 확장할 예정이다.