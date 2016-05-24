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
REM _Lab04  < Compilador/_Lab04Prog.dat > Compilador/_Lab04ProgOutput.dat

goto Test_declaracao
	echo.
	echo ### Testes para Declaração de Variáveis
	_Lab04 < Compilador/Bench/BenchDeclaracao01.dat > Compilador/Bench/oBenchDeclaracao01.dat
:Test_declaracao

goto Test_principal
	echo.
	echo ### Testes para função Principal ###
	_Lab04 < Compilador/Bench/BenchPrincipal01.dat > Compilador/Bench/oBenchPrincipal01.dat
	_Lab04 < Compilador/Bench/BenchPrincipal02.dat > Compilador/Bench/oBenchPrincipal02.dat
	_Lab04 < Compilador/Bench/BenchPrincipal03.dat > Compilador/Bench/oBenchPrincipal03.dat
:Test_principal

REM Loop compilation with delay
REM timeout /t 10
REM goto loop

echo.
echo Completo
pause
