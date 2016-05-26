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

goto Testes
	echo.
	echo ### Testes para Declaração de Variáveis
	_Lab04 < Compilador/Bench/BenchDeclaracao.dat > Compilador/Bench/oBenchDeclaracao.dat

	echo.
	echo ### Testes para função Principal ###
	_Lab04 < Compilador/Bench/BenchPrincipal1.dat > Compilador/Bench/oBenchPrincipal1.dat
	_Lab04 < Compilador/Bench/BenchPrincipal2.dat > Compilador/Bench/oBenchPrincipal2.dat
	_Lab04 < Compilador/Bench/BenchPrincipal3.dat > Compilador/Bench/oBenchPrincipal3.dat

	echo.
	echo ### Testes para Variáveis Indexadas
	_Lab04 < Compilador/Bench/BenchIndexada.dat > Compilador/Bench/oBenchIndexada.dat

	echo.
	echo ### Testes para Compatibilidade
	_Lab04 < Compilador/Bench/BenchCompatibilidade.dat > Compilador/Bench/oBenchCompatibilidade.dat
:Testes


REM Loop compilation with delay
REM timeout /t 10
REM goto loop

echo.
echo Completo
pause
