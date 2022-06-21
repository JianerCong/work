
# Redirect all to log.txt
&{
    MSBuild.exe .\gsa_api_v2.csproj -property:OutDir=run;
} *> log.txt

if ($?){
    Write-Host "Runing the app ◑﹏◐"
    .\run\gsa_api_v2.exe
}else{
    less log.txt
}
# Do not prompt for confirmation
# $ConfirmPreference="Low"
# Remove-Item -Recurse -Force run\*

