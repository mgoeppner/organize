organize
================================================================================

Author:            Mike Goeppner

Website URL:       https://github.com/mgoeppner/organize

License:           http://www.gnu.org/licenses/gpl-3.0.txt

About
================================================================================

This shell script will move all media/document files in your home directory to the appropriate XDG directory for that filetype, while leaving a symlink behind in order not to break existing references to that file.

The configuration file is automatically generated on first run and located at:
~/.config/organize/organize.conf

Command line options
================================================================================

-n                Do not symlink after moving
