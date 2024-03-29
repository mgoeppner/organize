organize
================================================================================

Author:            Mike Goeppner

Website URL:       https://github.com/mgoeppner/organize

About
================================================================================

This shell script will move all media/document files in your home directory to the appropriate XDG directory for that filetype, while leaving a symlink behind in order not to break existing references to that file.

The configuration file is automatically generated on first run and located at:
`$XDG_CONFIG_HOME/organize/organize.conf`

Command line options
================================================================================

`-n`                Do not symlink after moving

`-d`                Do a dry run, will NOT move or symlink files

`-c`				Clean the Downloads folder by deleting all contents

Want to help?
================================================================================

Take a look at https://github.com/mgoeppner/organize/issues to see what needs to be done!
