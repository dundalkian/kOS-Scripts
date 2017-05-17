run OrbitData.
clearscreen.
set xcurs to 0.
set ycurs to 35.
set terminal:charwidth to 8.
set terminal:charheight to 8.
wait 0.
set terminal:width to 50.
set terminal:height to 36.
set userInput to list().
mainMenu().

function cursor{
    print "*" at (xcurs, ycurs).
}
function upArrow{
    mainMenu().
    if ycurs = 0 {

    }
    else{
        set ycurs to ycurs - 1.
        cursor().
    }
}
function downArrow{
    mainMenu().
    if ycurs = 35 {

    }
    else{
        set ycurs to ycurs + 1.
        cursor().
    }
}
function leftArrow{
    mainMenu().
    if xcurs = 0 {

    }
    else{
        set xcurs to xcurs - 1.
        cursor().
    }
}
function rightArrow{
    mainMenu().
    if xcurs = 49 {

    }
    else{
        set xcurs to xcurs + 1.
        cursor().
    }
}
function backspace {
    parameter userInput.
    if (userInput:length < 1) {
        return userInput.
    }
    userInput:remove(userInput:length - 1).
    print " " at (userInput:length,35). //overwrite backspaced character
    // print userInput:join("") at (0,35). should not need this line
    return userInput.
}
function mainMenu{
    clearscreen.
    print "Larry's kOS Magic Menu Interface".
    print "_  ".
    print "+------------------------------------------------+".
    print " ".
    print "+------------------------------------------------+".
    print " ".
    print "+------------------------------------------------+".
    print " ".
    print "+------------------------------------------------+".
    print " ".
    print "+------------------------------------------------+".
    print " ".
    print "+------------------------------------------------+".
    print " ".
    print "+------------------------------------------------+".
    print " ".
    print "+------------------------------------------------+".
    print " ".
    print "+------------------------------------------------+".
    print " ".
    print "+------------------------------------------------+".
    print " ".
    print "+------------------------------------------------+".
    print " ".
    print "+------------------------------------------------+".
    print " ".
    print "+------------------------------------------------+".
    print " ".
    print "+------------------------------------------------+".
    print " ".
    print "+------------------------------------------------+".
    print " ".
    print "+------------------------------------------------+".
    print " ".
    print "Use Action Group 0 to exit".
}
function keyListener{
    set charIn to nextChar().
    if (charIn = terminal:input:UPCURSORONE){
        upArrow().
        terminal:input:clear().
    }
    else if (charIn = terminal:input:DOWNCURSORONE){
        downArrow().
        terminal:input:clear().
    }
    else if (charIn = terminal:input:LEFTCURSORONE){
        leftArrow().
        terminal:input:clear().
    }
    else if (charIn = terminal:input:RIGHTCURSORONE){
        rightArrow().
        terminal:input:clear().
    }
    else if (charIn = terminal:input:backspace){
        backspace(userInput).
        terminal:input:clear().
    }
    else if (charIn = terminal:input:enter) {
        terminal:input:clear().
        mainMenu().
        set finalInput to userInput:join("").
        set userInput to list().
        return finalInput.
    }
    else{
        userInput:add(charIn).
        print userInput:join("") at (0,35).
        terminal:input:clear().
    }


}
function nextChar {
    until (terminal:input:haschar) {

    }
    return terminal:input:getchar.
}

set done to false.
on AG10 set done to true.

until done {
    set command to keyListener().
    if (command = "orbit"){
        set desiredorbit to list(100000, 100000, 0).
        transferData(desiredorbit).
    }
}
if done {
    clearscreen.
}
