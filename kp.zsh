#grabs a password from keepass securely, for a script. You need to modify the variables below to match your own config.
function kp () {
    if [[ $# -ne 2 ]]; then
        echo 'Usage: kp "<query>" "<varname>"\nQuery is the name of an entry in keepass. \nPlease be sure to set the config as well.';
        echo '<varname> will be set with the result of the query, if successful.'
        return 1;
    fi
 
    #Change this to match your key file and kdbx.
    local kpdbx=~/Desktop/test3.kdbx
    local kpkey=~/Desktop/test3.key
 
    #set this to path of the expect script. It needs to have u+x
    local kpexpectpath=~/.shell/common/kp.expect
 
 
    #change this if the db doesn't use a password. Don't do this.
    local passwordrequired=true
    #change this if the db uses a key.
    local keyrequired=false
 
    if [ ! -e $kpdbx ] ; then
        echo "Error: kpdbx $kpdbx doesn't exist. Check your config."
        return 1;
    fi
 
    if [ ! -e $kpkey ] && [ "$keyrequired" = true ]; then
        echo "Error: kpkey $kpkey doesn't exist, and keyrequired is true. Check your config."
        return 1;
    fi
 
    if [ ! -e $kpexpectpath ]; then
        echo "Error: kpexpectpath $kpexpectpath doesn't exist. Check your config."
        return 1;
    fi
 
    local entry=$1
    local retvar=$2
 
    local query='show "'$entry'" -a Password --show-protected'
 
    local todos='TODOS:
    - Delete this section when done
    - Fix the input for kp.expect to be sane
    - Fix output buffering and stuff for script and wrapper function (Current)'
 
    local command="open ${kpdbx}"
     
    if [ "$keyrequired" = true ]; then
        command="${command} -k ${kpkey}"
    fi
    if [ "$passwordrequired" = false ]; then
        command="${command} --no-password"
    fi
 
    #This command allows the expect script to interact with stdout to ask for the password from the user,
    #as well as saving the complete output (including terminal control characters) into a variable.
    #its named like this to reduces the chances of a collision with the user specified output variable.
    local output123=$( $kpexpectpath $command $query 2>&1 | tee /dev/tty )
     
    if [[ $output123 =~ "Check your config" ]]; then
        echo "Failed to unlock the Keepass database. Aborting. \n";
        unset output123;
        return 1;
    elif [[ $output123 =~ "Could not find entry with path" ]]; then
        echo "The entry name $entry does not exist. Aborting."
        unset output123;
        return 1;
    else
        #this strips the control characters from the output to grab the password.
        #its named like this to reduces the chances of a collision with the user specified output variable.
        local password123=$(echo $output123 | strings -2 | tail -n1)
        #This is for debugging, needs to come before the single quote escaping though.
        #echo $password123;
 
        #escaping single quotes so we don't break anything
        local password123=`echo $password123 | sed "s/'/'\"'\"'/g"`
 
        #running retvar into eval so we get the return in a variable. idk why bash/zsh doesn't have proper function return.
        eval "$retvar='"$password123"'";
 
        unset output123;
        unset password123;
        return 0;
    fi
}
