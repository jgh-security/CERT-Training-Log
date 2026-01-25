# 1주차 실습: RHEL 시스템 보안 로그 분석

본 실습은 침해대응(CERT)의 기초인 시스템 로그 구조를 파악하고, 외부 침입 시 발생하는 흔적을 식별하는 데 목적이 있습니다.

---

### 주간 실습 일정 및 상세 기록

#### **1. [월요일: 시스템 로그의 흐름 파악 (`journalctl`)](./1_monday/)**
- **실습 목표:** RHEL 통합 로그 관리 도구인 journal 로그 사용법 익히기
- **주요 명령어:** `journalctl -xe`, `journalctl -u sshd`
- **상세 기록:** [명령어 실행 로그 확인](./1_monday/commands.md) | 📸 [실시간 로그 캡처본](./1_monday/screenshots/)
- **상태:** [ ] 실시간 메시지 확인 완료

#### **2. [화요일: 인증 보안 로그 분석 (`/var/log/secure`)](./2_tuesday/)**
- **실습 목표:** 외부 침입(SSH Brute Force 등) 시 발생하는 인증 실패 흔적 식별
- **실습 방법:** Kali Linux 접속 시도 ➔ 비밀번호 오입력 ➔ `/var/log/secure` 확인
- **상세 기록:** [인증 실패 분석 리포트](./2_tuesday/commands.md) | 📸 [Kali IP 공격 흔적 캡처](./2_tuesday/screenshots/)
- **상태:** [ ] `Failed password` 로그 식별 완료

#### **3. [수요일: 종합 시스템 로그 필터링 (`/var/log/messages`)](./3_wednesday/)**
- **실습 목표:** 시스템 에러 및 하드웨어 변화 로그 탐색
- **주요 명령어:** `grep -i "error"`, `grep -i "usb"`
- **상세 기록:** [필터링 결과 정리](./3_wednesday/commands.md) | 📸 [에러 로그 캡처본](./3_wednesday/screenshots/)
- **상태:** [ ] 하드웨어 변경 이력 확인 완료

#### **4. [목요일: 접속자 이력 추적 (`last`, `lastb`)](./4_thursday/)**
- **실습 목표:** 명령어 기반의 사용자 접속 기록 및 실패 이력 확인
- **주요 명령어:** `lastb` (로그인 실패), `last` (최근 접속)
- **상세 기록:** [접속 이력 추적 결과](./4_thursday/commands.md) | 📸 [접속 실패 기록 캡처](./4_thursday/screenshots/)
- **상태:** [ ] 공격 IP 식별 완료

#### **5. [금요일: 데이터 최종 점검 및 백업](./5_friday/)**
- **최종 점검:** ✅ [실습 데이터 체크리스트](./5_friday/checklist.md)
- **할 일:** 캡처 이미지 네이밍, 로그 텍스트 복사, 외부 저장소 백업 완료

---

### 1주차 총평 (주말 작성 예정)
> [한 주간의 실습을 마친 후 느낀 점이나 배운 점을 이곳에 적으세요.]
