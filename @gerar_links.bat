@echo off
setlocal enabledelayedexpansion

:: Caminho da pasta de entrada e saída
set "input_folder=%~dp0Arquivos"
set "output_file=%~dp0resultado.html"

:: Diagnóstico: Mostra o caminho configurado
echo Caminho da pasta de entrada: "%input_folder%"
echo Arquivo de saída: "%output_file%"

:: Verifica se a pasta de entrada existe
if not exist "%input_folder%" (
    echo ERRO: A pasta de entrada nao foi encontrada!
    pause
    exit /b
)

:: Inicia o arquivo HTML
echo ^<ul^> > "%output_file%"

:: Processa os arquivos PDF
for %%f in ("%input_folder%\*.pdf") do (
    echo Processando arquivo: "%%~nxf"
    set "filename=%%~nxf"
    set "basename=%%~nf"

    :: Limpa o nome do arquivo para links amigáveis
    set "clean_name=!basename!"
    set "clean_name=!clean_name:_=-!"
    set "clean_name=!clean_name: =%20!"

    :: Adiciona o link no arquivo HTML (escrevendo a cada iteração)
    >> "%output_file%" echo ^<li^>^<a href="static/2023/12/%%~nxf"^>!clean_name!^</a^>^</li^>
)

:: Finaliza o HTML
echo ^</ul^> >> "%output_file%"

echo Arquivo HTML gerado em: %output_file%
pause
