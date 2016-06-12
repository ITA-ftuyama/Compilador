@echo off
echo ######################################
echo #  Gerador de Codigo Intermediario   #
echo #   para Linguagem COMP-ITA 2016     #
echo ######################################

cd ..
:loop

echo Chamando Flex
flex Compilador/_Lab05.l

echo Chamando Yacc
yacc -v Compilador/_Lab05.y

echo.
echo Compilando arquivo
gcc y.tab.c main.c yyerror.c -o _Lab05 -lfl

echo.
echo Compilando programa

_Lab05  < Compilador/_Lab05Proga.dat > Compilador/_Lab05ProgOutput.dat

 goto Teste
	echo ### Testes - Declaracao de Variaveis
	_Lab05 < Compilador/Bench/BenchDeclaracao.dat > Compilador/Bench/oBenchDeclaracao.dat

	echo ### Testes - Funcao Principal
	_Lab05 < Compilador/Bench/BenchPrincipal.dat > Compilador/Bench/oBenchPrincipal.dat

	REM echo ### Testes - Variaveis Indexadas 
	REM _Lab05 < Compilador/Bench/BenchIndexada.dat > Compilador/Bench/oBenchIndexada.dat

	echo ### Testes - Compatibilidade
	_Lab05 < Compilador/Bench/BenchCompatibilidade.dat > Compilador/Bench/oBenchCompatibilidade.dat

	echo ### Testes - Comando Para
	_Lab05 < Compilador/Bench/BenchPara.dat > Compilador/Bench/oBenchPara.dat

	echo ### Testes - CallFuncao
	_Lab05 < Compilador/Bench/BenchCallFunc.dat > Compilador/Bench/oBenchCallFunc.dat

	echo ### Testes - RetornoFuncao
	_Lab05 < Compilador/Bench/BenchRetornoFunc.dat > Compilador/Bench/oBenchRetornoFunc.dat

:Teste

echo Completo
pause

REM Loop compilation with delay
REM timeout /t 10
REM goto loop

