# 11-Week: WebShell Post-Exploitation Forensic Analysis

## 주제

WebShell 공격 이후 시스템 내 흔적 분석 및 타임라인 재구성

## Incident 목록

* [Incident 08: WebShell Post-Exploitation Forensic Analysis](./incident-08-webshell-forensic-analysis/report.md)

## 목표

* WebShell 공격 이후 발생한 시스템 흔적 식별
* 로그 기반 침해 행위 분석
* 타임라인 재구성을 통한 공격 흐름 파악

---

## 주요 내용

* nginx access.log 기반 WebShell 접근 로그 분석
* /var/log/secure 및 journalctl을 통한 시스템 로그 분석
* history, last 명령어를 활용한 사용자 행위 추적
* 업로드 디렉토리 내 파일 분석 및 변경 사항 확인
* 로그 및 시스템 흔적을 기반으로 타임라인 재구성

---

※ 본 주차는 WebShell 공격 이후 남은 다양한 로그 및 시스템 흔적을 분석하여
침해 행위를 재구성하고, 실제 침해사고 대응 관점에서 분석 역량을 강화하는 것을 목표로 한다.
