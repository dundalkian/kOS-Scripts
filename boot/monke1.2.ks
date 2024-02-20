set missionName to "monke1.2".
wait until ship:unpacked.

set terminal:width to 45.
set terminal:height to 26.
core:part:getModule("kOSProcessor"):doEvent("Open Terminal").

clearScreen.
wait 0.5.

if ship:status = "PRELAUNCH" {
    cd("0:/lib").

    list files in myFiles.
    for f in myFiles {
        print "loading file " + f:name.
        loadLibrary(f).
        wait 0.2.
    }

    print "All files loaded.".
    print "Starting main program.".

    if not exists("1:/" + missionName + ".ks") {
        print "copying mission".
        copyPath("0:/" + missionName + ".ks", "1:/" + missionName + ".ks").
    }

    wait 0.5.
    clearScreen.
}

kUniverse:quicksaveto(missionName + "_" + ship:status).

switch to 1.
runPath(missionName + ".ks").

function loadLibrary {
  parameter aFile.
  local completePath is "1:/lib/" + aFile.
  if not exists(completePath) {
    copyPath("0:/lib/" + aFile, completePath).
  }
  wait 0.1.
}