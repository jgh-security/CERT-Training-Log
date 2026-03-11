Incident 03 - DVWA XSS Attack Analysis
1. 사건 개요

본 분석은 DVWA(Damn Vulnerable Web Application) 환경에서 발생 가능한 XSS(Cross-Site Scripting) 공격을 재현하고 웹 서버 로그 기반으로 공격 행위를 분석하기 위한 실습 문서이다.

공격자는 입력값 검증이 수행되지 않는 취약점을 이용하여 JavaScript 코드를 삽입할 수 있으며 브라우저에서 스크립트가 실행되는 현상을 통해 취약 여부를 확인할 수 있다.

본 보고서에서는 Reflected XSS 및 Stored XSS 공격을 단계적으로 수행하고 access log를 기반으로 공격 흐름을 분석할 예정이다.

2. 분석 환경
구분	환경
Target	RHEL
Attacker	Kali Linux
Web Server	nginx
Web Application	DVWA
주요 로그	/var/log/nginx/access.log
3. 공격 재현 과정
3.1 Reflected XSS 테스트

DVWA의 XSS (Reflected) 페이지(/vulnerabilities/xss_r/)에서 다음 payload를 이용하여 취약점을 테스트하였다.

<script>alert(1)</script>

해당 payload 입력 후 브라우저에서 alert 창이 실행되는 것을 확인하였다.

이를 통해 사용자 입력값이 HTML 응답에 그대로 반영되며 브라우저에서 JavaScript 코드가 실행되는 Reflected XSS 취약점이 존재함을 확인하였다.







3.2 Payload 변형 테스트

기본 script 태그 외에도 이벤트 핸들러 기반 payload를 입력하여 필터링 여부를 확인하였다.

<img src=x onerror=alert(1)>

해당 payload 입력 후 브라우저에서 alert 창이 정상적으로 실행되었으며, 존재하지 않는 리소스(x)에 대한 추가 요청이 access log에 기록되는 것을 확인하였다.

이를 통해 단순 script 태그 외의 이벤트 기반 payload도 실행 가능함을 확인하였다.







3.3 Stored XSS 테스트

DVWA의 XSS (Stored) 페이지(/vulnerabilities/xss_s/)에서 다음 payload를 입력하였다.

<script>alert(document.cookie)</script>

게시글 저장 후 페이지 재접속 시 저장된 스크립트가 반복 실행되었으며 브라우저에서 현재 세션 쿠키(PHPSESSID, security)가 출력되는 것을 확인하였다.

이를 통해 Stored XSS의 저장 및 반복 실행 특성을 확인하였다.







4. 웹 로그 분석
4.1 Access Log 분석

웹 서버의 /var/log/nginx/access.log 로그를 분석한 결과 XSS 관련 요청이 정상적으로 기록되는 것을 확인하였다.

Reflected XSS에서는 payload가 GET 요청 URL에 직접 포함되어 access log에서 식별 가능하였으며, Stored XSS에서는 POST 요청이 발생하여 서버 측 저장 구조가 확인되었다.

확인된 주요 패턴은 다음과 같다.

%3Cscript%3Ealert%281%29%3C%2Fscript%3E

onerror%3Dalert%281%29

POST /vulnerabilities/xss_s/

로그 분석을 통해 Source IP, 요청 URI, payload 반영 여부를 확인하였다.










4.2 공격 단계 분석

로그 패턴을 기반으로 다음 단계의 공격 흐름을 분석할 예정이다.

기본 Reflected XSS 테스트

<script>alert(1)</script>

→ 브라우저 내 스크립트 실행 여부 확인

이벤트 핸들러 기반 Payload 테스트

<img src=x onerror=alert(1)>

→ 필터 우회 가능 여부 확인

Stored XSS 등록

<script>alert(document.cookie)</script>

→ 저장형 공격 여부 확인

5. 타임라인 재구성

실습 후 access log를 기반으로 다음 항목을 정리할 예정이다.

시간	이벤트	근거 로그	해석
작성 예정	Reflected XSS 요청	access.log	초기 공격
작성 예정	Payload 변형 요청	access.log	필터 우회 시도
작성 예정	Stored XSS 등록	access.log	저장형 공격
6. IOC (Indicators of Compromise)

실습 과정에서 확인된 값을 기반으로 IOC를 정리할 예정이다.

구분	값	설명
Source IP	작성 예정	공격 수행 IP
공격 대상 URL	/vulnerabilities/xss_r/	Reflected XSS 페이지
공격 대상 URL	/vulnerabilities/xss_s/	Stored XSS 페이지
공격 패턴	<script>alert(1)</script>	기본 XSS 테스트
공격 패턴	<img src=x onerror=alert(1)>	이벤트 기반 실행
공격 패턴	<script>alert(document.cookie)</script>	쿠키 접근 시도
로그 위치	/var/log/nginx/access.log	웹 서버 접근 로그
7. 대응 및 개선 방안
7.1 입력값 검증 강화

사용자 입력값에서 script 태그 및 이벤트 핸들러를 필터링해야 한다.

7.2 Output Encoding 적용

HTML 출력 시 특수문자를 escape 처리하여 브라우저 실행을 방지해야 한다.

7.3 CSP(Content Security Policy) 적용

인라인 스크립트 실행을 제한하여 XSS 피해를 줄일 수 있다.

7.4 로그 기반 공격 탐지

다음 문자열을 지속적으로 모니터링할 필요가 있다.

script

alert(

document.cookie

onerror=

8. 결론

본 주차에서는 DVWA 환경에서 Reflected XSS 및 Stored XSS 공격을 단계적으로 수행하고 웹 서버 로그 기반으로 공격 흐름을 분석할 예정이다.

실습 결과를 기반으로 최종 공격 패턴과 대응 방안을 정리한다.



