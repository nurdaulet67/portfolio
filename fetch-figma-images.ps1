# Downloads the 40 case images from Figma into images/ under the names index.html expects.
# The token is asked for when the script runs and is not saved anywhere.
# Figma: Settings > Security > Personal access tokens (scope: file_content read).

$fileKey = '6Lp0HGX9XoMTKC6hZIW8Wa'
$scale = 2

$map = [ordered]@{
  'sigma-01' = '2001:113'; 'sigma-02' = '2001:116'; 'sigma-03' = '2001:117'; 'sigma-04' = '2001:119'; 'sigma-05' = '2001:120'
  'sigma-06' = '2001:125'; 'sigma-07' = '2001:126'; 'sigma-08' = '2001:127'; 'sigma-09' = '2001:128'; 'sigma-10' = '2001:129'
  'iqro-01'  = '2001:169'; 'iqro-02'  = '2001:170'; 'iqro-03'  = '2001:171'
  'iqro-04'  = '2001:176'; 'iqro-05'  = '2001:177'; 'iqro-06'  = '2001:178'; 'iqro-07'  = '2001:179'
  'info-01'  = '2001:206'; 'info-02'  = '2001:207'; 'info-03'  = '2001:208'
  'info-04'  = '2001:216'; 'info-05'  = '2001:217'; 'info-06'  = '2001:218'
  'info-07'  = '2001:223'; 'info-08'  = '2001:224'; 'info-09'  = '2001:225'
  'other-01' = '2001:235'; 'other-02' = '2001:236'; 'other-03' = '2001:237'; 'other-04' = '2001:238'
  'other-05' = '2001:239'; 'other-06' = '2001:240'; 'other-07' = '2001:241'
  'other-08' = '2001:245'; 'other-09' = '2001:242'; 'other-10' = '2001:243'; 'other-11' = '2001:244'
  'other-12' = '2001:232'; 'other-13' = '2001:233'; 'other-14' = '2001:234'
}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ErrorActionPreference = 'Stop'

$secure = Read-Host 'Figma token' -AsSecureString
$token = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure))

$ids = ($map.Values -join ',')
$uri = "https://api.figma.com/v1/images/${fileKey}?ids=$ids&format=jpg&scale=$scale"
$res = Invoke-RestMethod -Uri $uri -Headers @{ 'X-Figma-Token' = $token }

$dir = Join-Path $PSScriptRoot 'site/images'
foreach ($name in $map.Keys) {
  $url = $res.images.($map[$name])
  if (-not $url) { Write-Warning "No render for $name"; continue }
  Invoke-WebRequest -Uri $url -OutFile (Join-Path $dir "$name.jpg") -UseBasicParsing
  Write-Output "$name.jpg"
}
