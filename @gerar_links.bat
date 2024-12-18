@echo off
setlocal enabledelayedexpansion

set "input_folder=%~dp0Arquivos"
set "output_file=%~dp0resultado.html"

echo Caminho da pasta de entrada: "%input_folder%"
echo Arquivo de saída: "%output_file%"

if not exist "%input_folder%" (
    echo ERRO: A pasta de entrada nao foi encontrada!
    pause
    exit /b
)

echo ^<ul^> > "%output_file%"

for %%f in ("%input_folder%\*.pdf") do (
    echo Processando arquivo: "%%~nxf"
    set "filename=%%~nxf"
    set "basename=%%~nf"

    set "clean_name=!basename!"

    >> "%output_file%" echo ^<li^>^<a href="//www.tjrs.jus.br/static/2024/12/%%~nxf"^>!clean_name!^</a^>^</li^>
)

echo ^</ul^> >> "%output_file%"

echo Arquivo HTML gerado em: %output_file%
pause

echo Arquivo HTML gerado em: %output_file%
pause
