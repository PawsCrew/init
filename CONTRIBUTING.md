Executables must start with

    #!/bin/bash 

and a minimum number of flags. 

Use set to set shell options so that calling your script as bash <script_name> does not break its functionality.

While shell scripting isn't a development language, it is used for writing various utility scripts. 

This style guide is more a recognition of its use rather than a suggestion that it be used for widespread deployment.

Some guidelines:

    If you're mostly calling other utilities and are doing relatively little data manipulation, shell is an acceptable choice for the task.
    If performance matters, use something other than shell.
    If you find you need to use arrays for anything more than assignment of ${PIPESTATUS}, you should use Python.
    If you are writing a script that is more than 100 lines long, you should probably be writing it in Python instead. Bear in mind that scripts grow. Rewrite your script in another language early to avoid a time-consuming rewrite at a later date.

Executables should have no extension (strongly preferred) or a .sh extension. Libraries must have a .sh extension and should not be executable.

It is not necessary to know what language a program is written in when executing it and shell doesn't require an extension so we prefer not to use one for executables.

However, for libraries it's important to know what language it is and sometimes there's a need to have similar libraries in different languages. 

Use sudo to provide elevated access if you need it.
All error messages should go to STDERR.

This makes it easier to separate normal status from actual issues.

A function to print out error messages along with other status information is recommended. 

    err() 
    { echo "[$(date +'%Y-%m-%dT%H:%M:%S%z')]: $@" >&2 } 
        if ! do_something; then err "Unable to do_something" 
            exit "${E_DID_NOTHING}" 
        fi

Start each file with a description of its contents.

Every file must have a top-level comment including a brief overview of its contents. 

Example: 

    #!/bin/bash 
    # 
    # Perform hot backups of Oracle databases.

Any function that is not both obvious and short must be commented. Any function in a library must be commented regardless of length or complexity.

It should be possible for someone else to learn how to use your program or to use a function in your library by reading the comments (and self-help, if provided) without reading the code.

All function comments should contain:

    Description of the function
    Global variables used and modified
    Arguments taken
    Returned values other than the default exit status of the last command run

Example: 

    #!/bin/bash 
    ## Perform hot backups of Oracle databases. 
    export PATH='/usr/xpg4/bin:/usr/bin:/opt/csw/bin:/opt/goog/bin' 
    ####################################### 
    # Cleanup files from the backup dir 
    # Globals: 
    # BACKUP_DIR 
    # ORACLE_SID 
    # Arguments: 
    # None 
    # Returns: 
    # None 
    ####################################### 
    cleanup() 
    { ... }

Comment tricky, non-obvious, interesting or important parts of your code.

This follows general Google coding comment practice. 
Don't comment everything. If there's a complex algorithm or you're doing something out of the ordinary, put a short comment in.
Use TODO comments for code that is temporary, a short-term solution, or good-enough but not perfect.

This matches the convention in the C++ Guide.

TODOs should include the string TODO in all caps, followed by your username in parentheses. A colon is optional. 
It's preferable to put a bug/ticket number next to the TODO item as well.

Examples:

    # TODO(mrmonkey): Handle the unlikely edge cases (bug ####)

While you should follow the style that's already there for files that you're modifying, the following are required for any new code.
Indent 2 spaces. No tabs.

Use blank lines between blocks to improve readability. 
Indentation is two spaces. Whatever you do, don't use tabs. For existing files, stay faithful to the existing indentation.
Maximum line length is 80 characters.

If you have to write strings that are longer than 80 characters, this should be done with a here document or an embedded newline if possible. Literal strings that have to be longer than 80 chars and can't sensibly be split are ok, but it's strongly preferred to find a way to make it shorter.

    # DO use 'here document's 
    cat <<END; 
    I am an exceptionally long string. 
    END 

    # Embedded newlines are ok too long_string="I am an exceptionally long string."

Pipelines should be split one per line if they don't all fit on one line.

If a pipeline all fits on one line, it should be on one line.

If not, it should be split at one pipe segment per line with the pipe on the newline and a 2 space indent for the next section of the pipe. 

This applies to a chain of commands combined using '|' as well as to logical compounds using '||' and '&&'. 

    # All fits on one line command1 | command2 # Long commands command1 \ 
    | command2 \ 
    | command3 \ | command4

Put ; do and ; then on the same line as the while, for or if.

Loops in shell are a bit different, but we follow the same principles as with braces when declaring functions. That is: ; then and ; do should be on the same line as the if/for/while. else should be on its own line and closing statements should be on their own line vertically aligned with the opening statement.

Example: 
    
    for dir in ${dirs_to_cleanup}; do
      if [[ -d "${dir}/${ORACLE_SID}" ]]; 
        then log_date "Cleaning up old files in ${dir}/${ORACLE_SID}" 
        rm "${dir}/${ORACLE_SID}/"* 
        if [[ "$?" -ne 0 ]]; 
          then error_message 
        fi 
      else 
        mkdir -p "${dir}/${ORACLE_SID}" 
        if [[ "$?" -ne 0 ]]; 
          then error_message 
        fi 
      fi 
    done

Indent alternatives by 2 spaces.
A one-line alternative needs a space after the close parenthesis of the pattern and before the ;;.

Long or multi-command alternatives should be split over multiple lines with the pattern, actions, and ;; on separate lines.

These are meant to be guidelines, as the topic seems too controversial for a mandatory regulation.

They are listed in order of precedence.

Stay consistent with what you find for existing code.
Quote variables, see Quoting section below.

Don't brace-quote single character shell specials / positional parameters, unless strictly necessary or avoiding deep confusion.
Prefer brace-quoting all other variables. 

      # Section of recommended cases.

              # Preferred style for 'special' variables:
              echo "Positional: $1" "$5" "$3"
              echo "Specials: !=$!, -=$-, _=$_. ?=$?, #=$# *=$* @=$@ \$=$$ ..."

              # Braces necessary:
              echo "many parameters: ${10}"

              # Braces avoiding confusion:
              # Output is "a0b0c0"
              set -- a b c
              echo "${1}0${2}0${3}0"

              # Preferred style for other variables:
              echo "PATH=${PATH}, PWD=${PWD}, mine=${some_var}"
              while read f; do
                echo "file=${f}"
              done &lt; &lt;(ls -l /tmp)

              # Section of <em>discouraged</em> cases

              # Unquoted vars, unbraced vars, brace-quoted single letter
              # shell specials.
              echo a=$avar "b=$bvar" "PID=${$}" "${1}"

              # Confusing use: this is expanded as "${1}0${2}0${3}0",
              # not "${10}${20}${30}
              set -- a b c
              echo "$10$20$30"


Always quote strings containing variables, command substitutions, spaces or shell meta characters, unless careful unquoted expansion is required.

Prefer quoting strings that are "words" (as opposed to command options or path names).

Never quote literal integers.

Be aware of the quoting rules for pattern matches in [[.

Use "$@" unless you have a specific reason to use $*.
