# kpq
**Keepass Programmatic Query**


This expect script allows you to use data from an entry in a keepass database securely within another script. Once the variables pointing at the database location is configured, you pass the wrapper function an entry name and variable, and it will prompt the user for credentials as necessary and set the variable passed to the output.

**Setup:**
The first code block is the wrapper/processing function. This will need to be put somewhere in your bash/zsh-init files. The second code block is the expect script. It will need to be saved somewhere on the filesystem. I like to store my scripts in a ~/.shell/ folder, but you can do this wherever. Make sure to note the location however. Once these are done, you can perform the following steps to get it working:

1. Change the kpdbx variable in the wrapper function.
2. Change (Or don't if you don't use a key file) the kpkey variable in the wrapper function. 
3. Change the kpexpectpath variable to point at location of the expect file you saved earlier. Don't wrap it in quotes if it uses expansion (i.e ~)
4. Change the keyrequired variable if you use a key file.
5. Run the following command: chmod u+x <kp.expect location here>

**Usage:**
Once the function is configured, you can use it in other functions by calling it with the appropriate entry names, and a variable name specified to receive the password. Note that you will need to run unset <varname> after using the credential to avoid having it sit in the shell variable.
