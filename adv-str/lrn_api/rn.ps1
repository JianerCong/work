
# Redirect all to log.txt
&{
    MSBuild.exe .\lrn.csproj -property:OutDir=run;
} 1> log.txt

dir .\run\lrn.exe
if ($?){
    Write-Host "Runing the app ◑﹏◐"
    .\run\lrn.exe
    rm .\run\lrn.exe
}else{
    less log.txt
}
# Do not prompt for confirmation
# $ConfirmPreference="Low"
# Remove-Item -Recurse -Force run\*

