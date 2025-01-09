$input_folder = Join-Path $PSScriptRoot "Arquivos"
$output_file = Join-Path $PSScriptRoot "resultado.html"

$currentDate = Get-Date
$year = $currentDate.ToString("yyyy")
$month = $currentDate.ToString("MM")

Write-Host "Caminho da pasta de entrada: $input_folder"
Write-Host "Arquivo de saída: $output_file"
Write-Host "Ano atual: $year"
Write-Host "Mês atual: $month"

if (-Not (Test-Path $input_folder)) {
    Write-Host "ERRO: A pasta de entrada não foi encontrada!" -ForegroundColor Red
    Pause
    Exit
}

"<ul>" | Out-File -FilePath $output_file -Encoding UTF8

function Remove-Acentos {
    param($string)
    $string = $string.Normalize([System.Text.NormalizationForm]::FormD)
    $string = $string -replace '\p{M}', ''
    return $string
}

function Convert-ToPascalCase {
    param($string)
    
    $excludedWords = @('das', 'da', 'dos', 'do', 'de')
    
    $words = $string -split '-'
    
    for ($i = 0; $i -lt $words.Length; $i++) {
        $word = $words[$i].ToLower()
        
        if ($i -eq 0 -or -not ($excludedWords -contains $word)) {
            $words[$i] = [regex]::Replace(
                $word,
                '^([a-z])',
                { param($match) $match.Groups[1].Value.ToUpper() }
            )
        } else {
            $words[$i] = $word
        }
    }
    
    return $words -join '-'
}

Get-ChildItem -Path $input_folder -Filter "*.pdf" | ForEach-Object {
    $file_name = $_.Name
    $base_name = $_.BaseName
    
    $clean_file_name = Remove-Acentos -string $file_name
    
    $clean_file_name = $clean_file_name -replace '\s+', '-'
    
    $clean_file_name = $clean_file_name -replace '[^a-zA-Z0-9\.\-]', ''
    
    $clean_file_name = $clean_file_name -replace '-+', '-'

    $clean_file_name = $clean_file_name.Trim('-')

    $clean_file_name = Convert-ToPascalCase -string $clean_file_name

    $html_line = "<li><a href='//www.tjrs.jus.br/static/$year/$month/$clean_file_name'>$base_name</a></li>"
    
    $html_line | Out-File -FilePath $output_file -Append -Encoding UTF8

    Write-Host "Processando arquivo: $file_name -> $clean_file_name"
}

"</ul>" | Out-File -FilePath $output_file -Append -Encoding UTF8

Write-Host "Arquivo HTML gerado em: $output_file" -ForegroundColor Green
Pause
