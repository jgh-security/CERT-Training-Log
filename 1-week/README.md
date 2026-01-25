Markdown

# 1주차 실습: RHEL 시스템 보안 로그 분석

본 실습은 침해대응(CERT)의 기초인 시스템 로그 구조를 파악하고, 외부 침입 시 발생하는 흔적을 식별하는 데 목적이 있습니다.

---

### 📅 주간 실습 일정 및 내용

#### **1. [월요일: 시스템 로그의 흐름 파악 (`journalctl`)](./1_monday/)**
- **실습 목표:** RHEL 통합 로그 관리 도구인 journal 로그 사용법 익히기
- **주요 명령어:** `journalctl -xe`, `journalctl -u sshd`
- **수행 기록:**
  - [ ] [실시간 시스템 메시지 화면 캡처 및 업로드](./1_monday/screenshots/)
  - [ ] [특이사항 및 상세 분석 확인 (Link)](./1_monday/commands.md)

#### **2. [화요일: 인증 보안 로그 분석 (`/var/log/secure`)](./2_tuesday/)**
- **실습 목표:** 외부 침입 시 발생하는 인증 실패 흔적 식별
- **실습 방법:** Kali 접속 시도 → 비밀번호 오입력 → `/var/log/secure` 확인
- **수행 기록:**
  - [ ] [`Failed password` 문구 및 IP 포함 로그 캡처](./2_tuesday/screenshots/)
  - [ ] [분석 결과 및 침입 흔적 상세 기록 (Link)](./2_tuesday/commands.md)

#### **3. [수요일: 종합 시스템 로그 필터링 (`/var/log/messages`)](./3_wednesday/)**
- **실습 목표:** 시스템 에러 및 하드웨어 변화 로그 탐색
- **주요 명령어:** `grep -i "error"`, `grep -i "usb"`
- **수행 기록:**
  - [ ] [특정 키워드 필터링 결과 터미널 화면 캡처](./3_wednesday/screenshots/)
  - [ ] [분석 결과 및 필터링 내역 (Link)](./3_wednesday/commands.md)

#### **4. [목요일: 접속자 이력 추적 (`last`, `lastb`)](./4_thursday/)**
- **실습 목표:** 명령어 기반의 사용자 접속 기록 및 실패 이력 확인
- **주요 명령어:** `lastb` (실패), `last` (성공)
- **수행 기록:**
  - [ ] [`lastb` 실행 결과(공격 흔적) 캡처](./4_thursday/screenshots/)
  - [ ] [분석 결과 및 접속 이력 상세 (Link)](./4_thursday/commands.md)

#### **5. [금요일: 데이터 최종 점검 및 백업](./5_friday/)**
- **체크리스트:** [캡처 이미지 네이밍, 로그 백업 현황 확인](./5_friday/checklist.md)

---

### ✍️ 1주차 총평
[주말 작성 예정]
