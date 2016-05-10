@echo off
echo ######################################
echo #        Analisador Sintatico        #
echo #   para Linguagem COMP-ITA 2016     #
echo ######################################

:loop

cd ..
echo Chamando Flex
flex Compilador/_Lab04.l

echo Chamando Yacc
yacc Compilador/_Lab04.y

echo.
echo Compilando arquivo
gcc y.tab.c main.c yyerror.c -o _Lab04 -lfl

echo.
echo Analisador Sintatico para programa
_Lab04  < Compilador/_Lab04Teste.dat > Compilador/_Lab04TesteOutput.dat

REM timeout /t 3
REM goto loop

echo.
echo Completo
pause


