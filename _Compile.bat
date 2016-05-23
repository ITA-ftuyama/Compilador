@echo off
echo ######################################
echo #        Analisador Semântico        #
echo #   para Linguagem COMP-ITA 2016     #
echo ######################################

:loop

cd ..
echo Chamando Flex
flex Compilador/_Lab04.l

echo Chamando Yacc
yacc -v Compilador/_Lab04.y

echo.
echo Compilando arquivo
gcc y.tab.c main.c yyerror.c -o _Lab04 -lfl

echo.
echo Compilando programa

REM _Lab04  < Compilador/_Lab04Teste.dat > Compilador/_Lab04TesteOutput.dat
_Lab04  < Compilador/_Lab04Prog.dat > Compilador/_Lab04ProgOutput.dat

REM Loop compilation with delay
REM timeout /t 10
REM goto loop

echo.
echo Completo
pause
