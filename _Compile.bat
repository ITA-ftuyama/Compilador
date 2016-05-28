@echo off
echo ######################################
echo #        Analisador Semântico        #
echo #   para Linguagem COMP-ITA 2016     #
echo ######################################

cd ..
:loop

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

goto Teste
	echo.
	echo ### Testes para Declaração de Variáveis
	_Lab04 < Compilador/Bench/BenchDeclaracao.dat > Compilador/Bench/oBenchDeclaracao.dat

	echo.
	echo ### Testes para função Principal ###
	_Lab04 < Compilador/Bench/BenchPrincipal.dat > Compilador/Bench/oBenchPrincipal.dat

	echo.
	echo ### Testes para Variáveis Indexadas
	_Lab04 < Compilador/Bench/BenchIndexada.dat > Compilador/Bench/oBenchIndexada.dat

	echo.
	echo ### Testes para Compatibilidade
	_Lab04 < Compilador/Bench/BenchCompatibilidade.dat > Compilador/Bench/oBenchCompatibilidade.dat

	echo.
	echo ### Testes para Para
	_Lab04 < Compilador/Bench/BenchPara.dat > Compilador/Bench/oBenchPara.dat

	echo.
	echo ### Testes para CallFunc
	_Lab04 < Compilador/Bench/BenchCallFunc.dat > Compilador/Bench/oBenchCallFunc.dat
	echo.
	echo ### Testes para RetornoFunc
	_Lab04 < Compilador/Bench/BenchRetornoFunc.dat > Compilador/Bench/oBenchRetornoFunc.dat
:Teste

echo.
echo Completo
pause

REM Loop compilation with delay
REM timeout /t 10
goto loop

