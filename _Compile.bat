@echo off
echo ######################################
echo #  Gerador de Codigo Intermediario   #
echo #   para Linguagem COMP-ITA 2016     #
echo ######################################

cd ..

echo Chamando Flex
flex Compilador/_Lab05.l

echo Chamando Yacc
yacc -v Compilador/_Lab05.y

echo.
echo Compilando arquivo
gcc y.tab.c main.c yyerror.c -o _Lab05 -lfl

echo.
echo Compilando programa

_Lab05  < Compilador/_Lab05Prog.dat > Compilador/_Lab05ProgOutput.dat
_Lab05  < Compilador/_Lab05Teste.dat > Compilador/_Lab05TesteOutput.dat

 goto Testes_Semanticos
	_Lab05 < Compilador/Bench/BenchDeclaracao.dat > Compilador/Bench/oBenchDeclaracao.dat
	_Lab05 < Compilador/Bench/BenchPrincipal.dat > Compilador/Bench/oBenchPrincipal.dat
	_Lab05 < Compilador/Bench/BenchIndexada.dat > Compilador/Bench/oBenchIndexada.dat
	_Lab05 < Compilador/Bench/BenchCompatibilidade.dat > Compilador/Bench/oBenchCompatibilidade.dat
	_Lab05 < Compilador/Bench/BenchPara.dat > Compilador/Bench/oBenchPara.dat
	_Lab05 < Compilador/Bench/BenchCallFunc.dat > Compilador/Bench/oBenchCallFunc.dat
	_Lab05 < Compilador/Bench/BenchRetornoFunc.dat > Compilador/Bench/oBenchRetornoFunc.dat
:Testes_Semanticos

echo Completo
cd Compilador
pause