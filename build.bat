@echo off
chcp 65001 > nul
echo =====================================================
echo   BUILD: Quan Ly Tiem Net - Web App (JSP+Servlet)
echo =====================================================

REM --- Tìm Maven ---
where mvn >nul 2>&1
if %errorlevel% == 0 (
    set MVN=mvn
    goto :found_mvn
)

REM Thử các đường dẫn phổ biến
for %%P in (
    "C:\Program Files\Apache Maven\bin\mvn.cmd"
    "C:\apache-maven\bin\mvn.cmd"
    "C:\maven\bin\mvn.cmd"
    "C:\tools\maven\bin\mvn.cmd"
) do (
    if exist %%P (
        set MVN=%%P
        goto :found_mvn
    )
)

REM Thử tìm qua MAVEN_HOME
if defined MAVEN_HOME (
    set MVN=%MAVEN_HOME%\bin\mvn.cmd
    goto :found_mvn
)

if defined M2_HOME (
    set MVN=%M2_HOME%\bin\mvn.cmd
    goto :found_mvn
)

echo [ERROR] Không tìm thấy Maven!
echo Vui lòng cài Maven hoặc dùng VS Code với Extension Pack for Java.
echo Tải Maven tại: https://maven.apache.org/download.cgi
pause
exit /b 1

:found_mvn
echo [OK] Tìm thấy Maven: %MVN%

REM --- Build ---
echo.
echo [1/2] Đang clean + compile + package...
%MVN% clean package -DskipTests

if %errorlevel% neq 0 (
    echo.
    echo [ERROR] Build thất bại! Xem lỗi bên trên.
    pause
    exit /b 1
)

echo.
echo [2/2] Build thành công!
echo.
echo File WAR đã tạo tại: target\quan-ly-tiem-net-1.0-SNAPSHOT.war
echo.
echo =====================================================
echo   HƯỚNG DẪN DEPLOY
echo =====================================================
echo.
echo CÁCH 1 - Tomcat (khuyến nghị):
echo   1. Copy file WAR vào thư mục webapps\ của Tomcat
echo   2. Khởi động Tomcat
echo   3. Truy cập: http://localhost:8080/quan-ly-tiem-net-1.0-SNAPSHOT/
echo.
echo CÁCH 2 - Dùng Maven Tomcat plugin (nếu cài Tomcat 9/10):
echo   Chạy: mvn tomcat7:run
echo   Truy cập: http://localhost:8080/quan-ly-tiem-net/
echo.
pause
