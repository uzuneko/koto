@echo off
rem KOTO�R�C���̍̌@���O�������擾�������̂ŁB�B�B
rem 1�x�����O���擾���Ă��Ȃ��ꍇ�͈ȉ��̃R�}���h�ň�x���؂��ĂƂ��Ă����B
rem �����̓g�����U�N�V�������ł��B10��������Ƃ�������100000�Ə\���ɑ傫�Ȑ��l�ɂ��܂��B
rem 1) koto-cli listtransactions "*" 10000 > LASTLOG.log
rem 2) copy LASTLOG.log > tmp.log
rem ��1)�̃R�}���h�̐�����LASTLOG.log�Ɏ擾���Ă��������������w��B
rem �����O�͍ŐV����ǂݏo�����̂łł��邾���傫�Ȓl�ɂ���
rem ����ԌÂ����O���܂܂��悤�Ɏ擾���܂��B
rem ��2)�̃R�}���h�ŃR�s�[���� tmp.log�����̃o�b�`���ɏ㏑�����܂��B

rem koto-cli ������f�B���N�g���Ɉړ�
D:
cd "D:\koto1.0.13_win_64bit"

rem �p�����[�^�ݒ�(LASTLOG:�ŏI�s�擾�p���O�AMAXCOUNT:�ő厎�s��)
set LASTLOG=tmp.log
set /A MAXCOUNT=5000
set tTime=""

rem ���O�t�@�C����ǂݍ���ōŌ��"timereceived": ��tTIME�Ɋi�[
for /F "tokens=1-2" %%i in (%LASTLOG%) do (
  if %%i=="timereceived": (
    set tTIME=%%j
  )
)

rem �i�[�ł��Ȃ�������I��
if %tTIME%=="" goto END
echo �擾�ς݃��O�� timereceived: %tTIME%

:settarget
rem koto-cli�̃��O�o�͋@�\���g���� tTIME���ŐV���牽���ڂ����擾
rem ���s�񐔂͍ő� MAXCOUNT�܂�

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
  echo �X�V���ꂽ���O�͂���܂���ł����B
  goto END
)

rem �����������̃��O�� tmp.log�ɏo��
koto-cli listtransactions "*" %CNT% > tmp.log

rem tmp.log ��ǂݍ���ōŐV�� "timereceived": ��nTIME�Ɋi�[
for /F "tokens=1-2" %%i in (tmp.log) do (
  if %%i=="timereceived": (
    set nTIME=%%j
  )
)

rem tmp.log�� �ŐVtimereceived.log �ɃR�s�[
set LASTLOGNAME=%nTIME:~0,10%.log
copy tmp.log %LASTLOGNAME% > NULL
echo %LASTLOGNAME% ���o�͂��܂����B

:END
echo.
pause
