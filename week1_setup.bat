@echo off
echo ### Week1 Project Auto Setup + Git Auto Push ###
echo.

REM =========================================
REM 0. Check 1-week folder exists
REM =========================================
if exist "1-week" (
    echo [INFO] 1-week 폴더가 이미 존재합니다. 생성 작업은 건너뜁니다.
) else (
    echo [INFO] 1-week 폴더가 없으므로 생성합니다.
    mkdir 1-week
)

cd 1-week

REM =========================================
REM Monday
REM =========================================
if not exist monday (
    mkdir monday
    cd monday
    echo # Monday - Commands (journalctl) > commands.md
    echo # Monday - Analysis (System Log Flow) >> analysis.md
    mkdir screenshots
    cd ..
)

REM =========================================
REM Tuesday
REM =========================================
if not exist tuesday (
    mkdir tuesday
    cd tuesday
    echo # Tuesday - Commands (/var/log/secure) > commands.md
    echo # Tuesday - Analysis (SSH 보안 로그) >> analysis.md
    mkdir screenshots
    cd ..
)

REM =========================================
REM Wednesday
REM =========================================
if not exist wednesday (
    mkdir wednesday
    cd wednesday
    echo # Wednesday - Commands (/var/log/messages) > commands.md
    echo # Wednesday - Analysis (종합 시스템 로그) >> analysis.md
    mkdir screenshots
    cd ..
)

REM =========================================
REM Thursday
REM =========================================
if not exist thursday (
    mkdir thursday
    cd thursday
    echo # Thursday - Commands (last / lastb) > commands.md
    echo # Thursday - Analysis (접속자 이력 추적) >> analysis.md
    mkdir screenshots
    cd ..
)

REM =========================================
REM Friday
REM =========================================
if not exist friday (
    mkdir friday
    cd friday
    echo # Friday - Checklist (데이터 점검 및 백업) > checklist.md
    mkdir screenshots
    cd ..
)

REM =========================================
REM Week Summary Report
REM =========================================
if not exist week1_report.md (
    echo # Week 1 Summary Report (1주차 총평) > week1_report.md
    echo. >> week1_report.md
    echo ## 이번 주에 배운 점 >> week1_report.md
    echo. >> week1_report.md
    echo ## 어려웠던 점 >> week1_report.md
    echo. >> week1_report.md
    echo ## 다음 주에 개선할 점 >> week1_report.md
    echo. >> week1_report.md
    echo ## 전체 총평 >> week1_report.md
)

cd ..

REM =========================================
REM Git Auto Push
REM =========================================
echo.
echo --- Git Push 시작 ---
git add .
git commit -m "Auto: Week1 structure updated"
git push
echo.
echo === 완료되었습니다! GitHub에서 확인하세요. ===

pause
