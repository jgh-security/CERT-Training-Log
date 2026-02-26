# Incident 01 - Linux SSH Intrusion Analysis

## 1. 사건 개요
본 실습은 SSH Brute Force 공격을 재현하고, 해당 침해 행위를 시스템 로그 기반으로 분석한 결과를 정리한 문서이다.

---

## 2. 분석 환경
- Target: RHEL
- Attacker: Kali Linux
- 주요 로그: /var/log/secure

---

## 3. 공격 재현 과정

### 3.1 사전 준비

- Target: RHEL 서버 (SSH 서비스 활성화 상태)
- Attacker: Kali Linux
- 공격 대상 계정: target
- 실습 비밀번호: 0000 (취약한 비밀번호 설정)

---

### 3.2 SSH Brute Force 수행

Kali 환경에서 다음 명령어를 통해 SSH Brute Force 공격을 수행하였다.

```bash
echo 0000 > pass.txt
hydra -l target -P pass.txt 192.168.200.81 ssh -t 4 -V
```

공격 결과, target 계정의 비밀번호가 0000으로 확인되어 SSH 로그인에 성공하였다.

3.3 침입 후 내부 행위 수행

SSH 로그인 이후 sudo 권한을 사용하여 시스템 변경 행위를 수행하였다.

```bash
sudo useradd intruder
sudo touch /tmp/compromised_file
sudo sh -c 'echo "intrusion test" >> /tmp/compromised_file'
```

수행된 행위는 다음과 같다.

신규 계정 intruder 생성

/tmp/compromised_file 파일 생성

파일 내 문자열 추가

이는 단순 로그인 이후 시스템 내부 변경이 발생한 것으로,
침해 활동이 실제로 수행되었음을 보여준다.

3.4 로그 기반 행위 확인

침입 이후 /var/log/secure 로그를 통해 인증 성공 및 sudo 실행 기록을 확인하였다.

```bash
sudo tail -n 30 /var/log/secure
```

---

## 4. 로그 분석 결과
(화요일에 작성 예정)

---

## 5. 타임라인 재구성

| 시간 | 이벤트 | 근거 로그 | 해석 |
|------|--------|-----------|------|
| 17:34:34 | SSH 로그인 성공 (1차) | Accepted password for target | 이후 시스템 변경 행위 없음(테스트/사전 접속 가능성) |
| 17:48:52 | SSH 로그인 성공 (2차) | Accepted password for target | 이후 sudo 및 계정 생성으로 이어짐(본 사건 시작점) |
| 17:50:03 | sudo useradd 실행 | COMMAND=/bin/useradd intruder | 권한 사용을 통한 시스템 변경 |
| 17:50:03 | 신규 계정 생성 | new user: name=intruder | 지속성(Persistence) 확보 시도 가능 |
| 18:59:14 | 파일 생성 | COMMAND=/bin/touch /tmp/compromised_file | 침입 후 아티팩트 생성 |
| 19:04:57 | 파일 내용 추가 | COMMAND=/bin/sh -c 'echo "intrusion test" >> /tmp/compromised_file' | 생성 파일 변경(내부 활동) |

### 분석 요약

SSH 로그인 성공(17:48:52) 이후 약 1분 11초 만에 sudo 권한을 사용하여 신규 계정을 생성하였다.
이는 단순 인증 성공이 아닌, 시스템 변경을 동반한 침해 행위로 판단된다.
또한 이후 임시 파일 생성 및 내용 추가 행위가 확인되어 침입자가 시스템 내부에서 지속적인 활동을 수행한 것으로 분석된다.

---

## 6. IOC (Indicators of Compromise)

| 구분 | 값 | 설명 |
|------|----|------|
| Source IP | 192.168.200.80 | SSH 로그인 성공이 발생한 원격 IP |
| 인증 계정 | target | 침해에 사용된 정상 사용자 계정 |
| 신규 계정 | intruder | 침입 후 생성된 계정 |
| 생성 파일 | /tmp/compromised_file | 침입 후 생성된 임시 파일 |
| 실행 명령 | useradd intruder | 시스템 계정 생성 행위 |
| 실행 명령 | touch /tmp/compromised_file | 파일 생성 행위 |
| 실행 명령 | sh -c 'echo "intrusion test" >> /tmp/compromised_file' | 파일 내용 변경 행위 |
| 로그 위치 | /var/log/secure | 인증 및 sudo 기록 확인 로그 |

### IOC 분석

본 침해는 단일 Source IP(192.168.200.80)에서 시작되었으며,
SSH 인증 성공 이후 시스템 계정 생성 및 파일 생성 행위가 연속적으로 발생하였다.
특히 신규 계정(intruder) 생성 행위는 시스템 내 장기 접근 권한 확보를 위한 지속성(Persistence) 확보 시도로 판단된다.

---

## 7. 대응 및 개선 방안

### 7.1 SSH 보안 강화

- 불필요한 계정 제거 (intruder 계정 삭제)
- 비밀번호 인증 비활성화 및 공개키 인증 방식 사용
- root 직접 로그인 차단 (PermitRootLogin no 설정)
- SSH 포트 변경 또는 접근 제어(방화벽) 적용

### 7.2 계정 및 권한 관리 강화

- sudo 권한 최소화 (wheel 그룹 관리 점검)
- 불필요한 계정 생성 모니터링 체계 구축
- /etc/passwd, /etc/shadow 무결성 점검

### 7.3 탐지 및 모니터링 강화

- Failed password 임계치 기반 경고 설정
- fail2ban 도입을 통한 Brute Force 자동 차단
- 보안 로그(/var/log/secure) 주기적 모니터링

### 대응 평가

본 침해는 기본적인 SSH 계정 보안 미흡으로 인해 발생하였다.
강력한 비밀번호 정책 및 접근 제어 정책을 적용할 경우 동일 유형의 공격은 사전 차단 가능하다.

---

## 8. 결론

본 실습을 통해 SSH Brute Force 공격 재현부터 내부 행위 수행,
그리고 로그 기반 타임라인 재구성 및 IOC 도출까지 전 과정을 분석하였다.

특히 로그인 성공 직후 신규 계정 생성 및 파일 생성 행위가 연속적으로 발생한 점을 근거로,
해당 행위는 단순 인증 성공이 아닌 시스템 변경을 동반한 침해 사고로 판단하였다.

본 사례는 SSH 접근 통제, 계정 관리, 로그 모니터링의 중요성을 보여주는 대표적인 사례로,
기본 보안 설정 강화만으로도 유사 침해를 효과적으로 예방할 수 있음을 확인하였다.











