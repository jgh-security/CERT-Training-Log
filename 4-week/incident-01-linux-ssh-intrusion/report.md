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
(작성 예정)

---

## 4. 로그 분석 결과
(화요일에 작성 예정)

---

## 5. 타임라인 재구성
| 시간 | 이벤트 | 근거 로그 |
|------|--------|-----------|
| 17:48:52 | SSH 로그인 성공 | Accepted password for target |
| 17:50:03 | sudo useradd 실행 | COMMAND=/bin/useradd intruder |
| 17:50:03 | 신규 계정 생성 | new user: name=intruder |
| 18:59:14 | 파일 생성 | COMMAND=/bin/touch /tmp/compromised_file |
| 19:04:57 | 파일 내용 추가 | COMMAND=/bin/sh -c 'echo "intrusion test" >> /tmp/compromised_file' |

### 분석 요약

SSH 로그인 성공(17:48:52) 이후 약 1분 11초 만에 sudo 권한을 사용하여 신규 계정을 생성하였다.
이는 단순 인증 성공이 아닌, 시스템 변경을 동반한 침해 행위로 판단된다.
또한 이후 임시 파일 생성 및 내용 추가 행위가 확인되어 침입자가 시스템 내부에서 지속적인 활동을 수행한 것으로 분석된다.

---

## 6. IOC 정리
(목요일에 작성 예정)

---

## 7. 대응 및 개선 방안
(목요일에 작성 예정)

---

## 8. 결론
(금요일에 작성 예정)


