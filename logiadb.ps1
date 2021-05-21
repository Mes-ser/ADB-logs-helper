# Program do zgrywania logów dla procesów z Androida

### TODO SECTION ###

# Check if phone is connected before trying to get pidID

####################

param([string]$PackageName = "com.xx.xx.xx", 
    [string]$ResultPath = $env:userprofile + "\Desktop\",
    [string]$FileName = "")

############################

$date = Get-Date -format "yyyy-dd-MM_HH-mm-ss";
if($FileName.length -le 0){
    $FileName = $PackageName + "-" +$date;
}
############################

# DONE #
function checkIfADBInstalled(){
    Try{
        $res = Invoke-Expression "& adb version";
        Write-host "ADB detected!" -ForegroundColor "Green";
    }
    Catch{
        Write-host "ADB is not installed, install it or ask someone who knows how to do it." -ForegroundColor "Red";
        exit;
    }
}

# DONE #
function checkIfADBRunning(){

    Write-Host "Checking if ADB server is running..." -ForegroundColor "Green";
    
    Try{
        $res = Get-Process adb -ErrorAction 'Stop';
        Write-Host "ADB server is running!" -ForegroundColor Green;
    }Catch{
        startADBServer;
    }
}

# DONE #
function startADBServer(){

    $res = Invoke-Expression "& adb start-server"; 
    Write-Host $res -ForegroundColor "Red";
}

# DONE #
function checkIfPhoneAuthorized(){
    $res = Invoke-Expression "& adb devices -l";
    if($res -match "unauthorized"){
        return 0;
    }else{
        return 1;
    }
}

# DONE (I think so)#
function getPid(){
    Write-host "Getting process ID..." -ForegroundColor "Green";
    $procID = Invoke-Expression "& adb shell pidof $PackageName";
    if($procID -match '^\d+$'){
        Write-host "Process ID received! [$procID]" -ForegroundColor "Green";
        return $procID;
    }else {
        Write-host "There was an issue with reciving process ID..." -ForegroundColor "Red";
        Write-host "Check connection or package name [$PackageName]" -ForegroundColor "Red";
        exit;
    }
}

# DONE #
function logDump($procID){
    if($procID){
        Write-host "Reading logs for [$procID]$PackageName... To Stop press CTRL+C" -ForegroundColor "Green";
        Invoke-Expression "& adb logcat *:W --pid=$procID > $ResultPath$FileName.txt";
    }
}

# From internet
function waitFor($timeSec){
    Write-Host "Waiting for phone authorization. Check message on your phone screen`r" -ForegroundColor Yellow;
    While( ($timeSec -ge 0) ){
        Write-Host -NoNewLine -ForegroundColor Cyan "`r$timeSec ";
        Start-Sleep 1;
        $timeSec -= 1;
    }
    # To jest do tego by tekst nie był wyświetlany na linii z odliczaniem
    "`r";
}

# >>> Main code <<< #

checkIfADBInstalled
checkIfADBRunning
$flag = 3;
while((-Not (checkIfPhoneAuthorized)) -And $flag -gt 0){
    $flag -= 1;
    waitFor(10);
    if(-Not $flag){
        Write-Host "Time-out... See ya!"
        exit;
    }
}
logDump(getPid);


### TEST GROUND ###

# Invoke-Expression "adb devices -l"
# $test = Invoke-Expression "adb devices -l"
# $lol = $test | Measure-Object;
# $lol.Count;