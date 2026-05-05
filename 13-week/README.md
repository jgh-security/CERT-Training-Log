# 13-Week: Artifact-Based Forensic Analysis

## 주제
침해 시스템 내 아티팩트 기반 행위 분석 및 포렌식

## Incident 목록
* [Incident 10: Artifact Analysis and Behavior Tracking](./incident-10-artifact-analysis/report.md)

---

## 목표
- 침해 이후 시스템에 남은 흔적(Artifacts) 분석
- 사용자 및 공격자 행위 추적
- 로그 및 기록 기반 타임라인 구성
- 포렌식 관점에서 공격 흐름 재구성

---

## 주요 내용
- bash_history 기반 명령어 실행 기록 분석
- auth.log 기반 로그인 및 권한 상승 이벤트 분석
- 공격자가 수행한 주요 명령어 식별
- 의심 행위 및 비정상 접근 탐지
- 시간 흐름 기반 타임라인 재구성

---

## 분석 대상
- ~/.bash_history
- /var/log/auth.log (또는 secure)
- 시스템 내 생성/변경 파일 흔적

---

## 기대 효과
- 공격자 행위 추적 능력 향상
- 포렌식 분석 기반 사고 대응 이해

---

※ 본 주차는 공격 이후 시스템 내부에 남은 흔적을 분석하여  
공격자의 행동을 추적하고, 타임라인을 구성하는 포렌식 분석 역량을 강화하는 것을 목표로 한다.
