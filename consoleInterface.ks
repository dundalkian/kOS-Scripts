clearscreen.
function recordInput {

    set tmp to nextChar().
    set userInput to list(tmp).
    print userInput:join("") at (0,35).
    until tmp = "ENTER" {
        print tmp.
        set tmp to nextChar.
        userInput:add(tmp).
        print userInput:join("") at (0,35).
    }
    print "enter".
    //When enter works properly, have the recordInput function return the string
    //version of the list that was formed. This then used for command/navigation

}

function nextChar {
    until (terminal:input:haschar) {

    }
    return terminal:input:getchar.
}


set terminal:charwidth to 8.
set terminal:charheight to 8.
wait 0.
set terminal:width to 50.
set terminal:height to 36.


print "Larry's kOS Magic Menu Interface".
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
print "+------------------------------------------------+".
print " ".
print "Use Action Group 0 to exit".

set done to false.
on AG10 set done to true.

until done {
    if (terminal:input:haschar) {
        recordInput.
    }
}
