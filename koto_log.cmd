@echo off
rem KOTOコインの採掘ログを差分取得したいので。。。
rem 1度もログを取得していない場合は以下のコマンドで一度取り切ってとっておく。
rem 数字はトランザクション数です。10万件あるという方は100000と十分に大きな数値にします。
rem 1) koto-cli listtransactions "*" 10000 > LASTLOG.log
rem 2) copy LASTLOG.log > tmp.log
rem ※1)のコマンドの数字はLASTLOG.logに取得しておきたい件数を指定。
rem ※ログは最新から読み出されるのでできるだけ大きな値にして
rem ※一番古いログが含まれるように取得します。
rem ※2)のコマンドでコピーした tmp.logをこのバッチ中に上書きします。

rem koto-cli があるディレクトリに移動
D:
cd "D:\koto1.0.13_win_64bit"

rem パラメータ設定(LASTLOG:最終行取得用ログ、MAXCOUNT:最大試行回数)
set LASTLOG=tmp.log
set /A MAXCOUNT=5000
set tTime=""

rem ログファイルを読み込んで最後の"timereceived": をtTIMEに格納
for /F "tokens=1-2" %%i in (%LASTLOG%) do (
  if %%i=="timereceived": (
    set tTIME=%%j
  )
)

rem 格納できなかったら終了
if %tTIME%=="" goto END
echo 取得済みログの timereceived: %tTIME%

:settarget
rem koto-cliのログ出力機能を使って tTIMEが最新から何件目かを取得
rem 試行回数は最大 MAXCOUNTまで

set /A CNT=0
SETLOCAL enabledelayedexpansion
for /L %%i in (0,1,%MAXCOUNT%) do (
  koto-cli listtransactions "*" 1 %%i | find "%tTIME%" > nul
  if "!ERRORLEVEL!"=="0" (
    set /A CNT=%%i
    goto createlog
  )
)

:createlog
if "%CNT%"=="0" (
  echo 更新されたログはありませんでした。
  goto END
)

rem 差分件数分のログを tmp.logに出力
koto-cli listtransactions "*" %CNT% > tmp.log

rem tmp.log を読み込んで最新の "timereceived": をnTIMEに格納
for /F "tokens=1-2" %%i in (tmp.log) do (
  if %%i=="timereceived": (
    set nTIME=%%j
  )
)

rem tmp.logを 最新timereceived.log にコピー
set LASTLOGNAME=%nTIME:~0,10%.log
copy tmp.log %LASTLOGNAME% > NULL
echo %LASTLOGNAME% を出力しました。

:END
echo.
pause
