# 2주차 메인 폴더 생성
mkdir -p week2/{1_monday,2_tuesday,3_wednesday,4_thursday,5_friday}/screenshots

# 각 요일별 상세 분석 기록용 마크다운 파일 생성
touch week2/1_monday/commands.md
touch week2/2_tuesday/commands.md
touch week2/3_wednesday/commands.md
touch week2/4_thursday/commands.md
touch week2/5_friday/checklist.md

# 2주차 메인 README.md 파일 생성
cat <<EOF > week2/README.md
# ??? 2주차 실습: 네트워크 패킷 분석 기초 (Wireshark & tcpdump)

본 실습은 네트워크 보안 관제의 기초인 패킷 구조를 파악하고, 시스템 로그와 네트워크 트래픽 간의 상관관계를 분석하는 데 목적이 있습니다.

---

### ?? 주간 실습 일정 및 내용

#### **1. [월요일: 네트워크 인터페이스 모니터링](./1_monday/)**
- **실습 목표:** 네트워크 인터페이스 상태 확인 및 실시간 트래픽 흐름 파악
- **수행 기록:**
  - [ ] [네트워크 설정 및 활성 연결 화면 캡처](./1_monday/screenshots/)
  - [ ] [인터페이스 정보 및 주요 연결 상태 기록 (Link)](./1_monday/commands.md)

#### **2. [화요일: 패킷 덤프 기초 (tcpdump)](./2_tuesday/)**
- **실습 목표:** CLI 환경에서 패킷 캡처 및 파일(.pcap) 저장 실습
- **수행 기록:**
  - [ ] [특정 포트 패킷 캡처 화면 캡처](./2_tuesday/screenshots/)
  - [ ] [tcpdump 옵션 정리 및 분석 결과 기록 (Link)](./2_tuesday/commands.md)

#### **3. [수요일: 프로토콜 상세 분석 (Wireshark)](./3_wednesday/)**
- **실습 목표:** GUI 기반 패킷 분석 도구를 이용한 TCP/UDP 헤더 구조 분석
- **수행 기록:**
  - [ ] [TCP 3-Way Handshake 과정 상세 캡처](./3_wednesday/screenshots/)
  - [ ] [계층별 프로토콜 분석 결과 기록 (Link)](./3_wednesday/commands.md)

#### **4. [목요일: 로그-패킷 상관관계 분석](./4_thursday/)**
- **실습 목표:** 1주차 보안 로그와 2주차 네트워크 패킷을 매칭하여 침입 시도 입증
- **수행 기록:**
  - [ ] [SSH 접속 시 발생하는 패킷 흐름 캡처](./4_thursday/screenshots/)
  - [ ] [로그와 패킷 간 타임라인 정합성 분석 (Link)](./4_thursday/commands.md)

#### **5. [금요일: 데이터 최종 점검 및 백업](./5_friday/)**
- **체크리스트:** [캡처 이미지 네이밍, pcap 파일 백업 및 리포트 작성](./5_friday/checklist.md)

---

### 2주차 총평
> **목표:** 네트워크 트래픽 분석을 통한 침입 탐지 역량 확보
> **환경:** RHEL (Target), Kali Linux (Attacker), Wireshark
EOF

echo "? 2주차 실습 폴더 및 README 생성이 완료되었습니다!"
ls -R week2