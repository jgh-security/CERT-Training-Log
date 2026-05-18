# 14-Week: Linux Persistence Analysis

## 주제

Linux Persistence(지속성) 행위 분석 및 흔적 탐지

---

## Incident 목록

* [Incident 11: Linux Persistence Analysis](./incident-11-persistence-analysis/report.md)

---

## 목표

* Linux 환경 내 Persistence 행위 분석
* cron 및 bashrc 기반 지속성 흔적 확인
* SSH 및 sudo 로그 기반 행위 추적
* 시스템 내부 아티팩트 기반 침해 흐름 분석
* 타임라인 기반 공격 흐름 재구성

---

## 분석 대상

* ~/.bashrc
* crontab
* bash_history
* /var/log/secure

---

## 주요 내용

* SSH 기반 원격 접속 수행
* sudo를 통한 root 권한 상승
* cron 등록 기반 Persistence 구성
* .bashrc 변조 기반 자동 실행 구성
* secure 로그 기반 세션 분석
* bash history 기반 행위 추적
* Persistence 행위 타임라인 재구성

---

## 기대 효과

* Linux Persistence 기법 이해
* 지속성 확보 흔적 식별 역량 강화
* 시스템 내부 아티팩트 분석 능력 향상
* 포렌식 기반 침해사고 대응 흐름 이해

---

※ 본 주차는 Linux 환경에서 공격자가 시스템 내 지속성(Persistence)을 확보하는 과정을 재현하고, 관련 아티팩트를 기반으로 침해 흔적을 분석하는 것을 목표로 한다.