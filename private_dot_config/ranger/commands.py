# This is a sample commands.py.  You can add your own commands here.
#
# Please refer to commands_full.py for all the default commands and a complete
# documentation.  Do NOT add them all here, or you may end up with defunct
# commands when upgrading ranger.

# A simple command for demonstration purposes follows.
# -----------------------------------------------------------------------------

from __future__ import absolute_import, division, print_function

# You can import any python module as needed.
import os

# You always need to import ranger.api.commands here to get the Command class:
from ranger.api.commands import Command


# Any class that is a subclass of "Command" will be integrated into ranger as a
# command.  Try typing ":show_files_in_finder<ENTER>" in ranger!
#
# OSX - Reveal selected files in Finder
#
# The following command is useful if you need to select files and drag-and-drop them. For example, as an attachment to gmail message composer. Simply select the files, and run the command:
#
# https://github.com/ranger/ranger/wiki/Custom-Commands#osx---reveal-selected-files-in-finder
#
class show_files_in_finder(Command):
    """
    :show_files_in_finder

    Present selected files in finder
    """

    def execute(self):
        import subprocess

        files = ",".join(
            [
                '"{0}" as POSIX file'.format(file.path)
                for file in self.fm.thistab.get_selection()
            ]
        )
        reveal_script = 'tell application "Finder" to reveal {{{0}}}'.format(files)
        activate_script = 'tell application "Finder" to set frontmost to true'
        script = "osascript -e '{0}' -e '{1}'".format(reveal_script, activate_script)
        self.fm.notify(script)
        subprocess.check_output(
            ["osascript", "-e", reveal_script, "-e", activate_script]
        )


class fzf_select(Command):
    """
    :fzf_select

    Find a file using fzf.

    With a prefix argument select only directories.

    See: https://github.com/junegunn/fzf
    """

    def execute(self):
        import subprocess
        import os.path

        if self.quantifier:
            # match only directories
            command="find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune -o -type d -print 2> /dev/null | sed 1d | cut -b3- | fzf +m"
            # command = "fd -HIL . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune -o -type d -print 2> /dev/null | sed 1d | cut -b3- | fzf +m"
        else:
            # match files and directories
            command="find -L . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune -o -print 2> /dev/null | sed 1d | cut -b3- | fzf +m"
            # command = "fd -HIL . \( -path '*/\.*' -o -fstype 'dev' -o -fstype 'proc' \) -prune -o -print 2> /dev/null | sed 1d | cut -b3- | fzf +m"
        fzf = self.fm.execute_command(
            command, universal_newlines=True, stdout=subprocess.PIPE
        )
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.rstrip("\n"))
            if os.path.isdir(fzf_file):
                self.fm.cd(fzf_file)
            else:
                self.fm.select_file(fzf_file)


#
# ripgrep-all + fzf integration
# https://github.com/ranger/ranger/wiki/Custom-Commands#ripgrep-all--fzf-integration
#
class fzf_rga_documents_search(Command):
    """
    :fzf_rga_search_documents
    Search in PDFs, E-Books and Office documents in current directory.
    Allowed extensions: .epub, .odt, .docx, .fb2, .ipynb, .pdf.

    Usage: fzf_rga_search_documents <search string>
    """

    def execute(self):
        if self.arg(1):
            search_string = self.rest(1)
        else:
            self.fm.notify("Usage: fzf_rga_search_documents <search string>", bad=True)
            return

        import subprocess
        import os.path
        from ranger.container.file import File

        command = (
            "rga '%s' . --rga-adapters=pandoc,poppler | fzf +m | awk -F':' '{print $1}'"
            % search_string
        )
        fzf = self.fm.execute_command(
            command, universal_newlines=True, stdout=subprocess.PIPE
        )
        stdout, stderr = fzf.communicate()
        if fzf.returncode == 0:
            fzf_file = os.path.abspath(stdout.rstrip("\n"))
            self.fm.execute_file(File(fzf_file))


# Search with fd
#
# fd is a great replacement for the venerable find. Put the following code in your ~/.config/ranger/commands.py, if you don't have one you can get one by running ranger --copy-config=commands. Note that fd returns its results according to your locale's collating order, this is somewhat annoying if your order in ranger differs (which it probably does because natural's the default).
#
# https://github.com/ranger/ranger/wiki/Custom-Commands#search-with-fd
#
from collections import deque

fd_deq = deque()


class fd_search(Command):
    """:fd_search [-d<depth>] <query>

    Executes "fd -d<depth> <query>" in the current directory and focuses the
    first match. <depth> defaults to 1, i.e. only the contents of the current
    directory.
    """

    def execute(self):
        import subprocess
        from ranger.ext.get_executables import get_executables

        if not "fd" in get_executables():
            self.fm.notify("Couldn't find fd on the PATH.", bad=True)
            return
        if self.arg(1):
            if self.arg(1)[:2] == "-d":
                depth = self.arg(1)
                target = self.rest(2)
            else:
                depth = "-d1"
                target = self.rest(1)
        else:
            self.fm.notify(":fd_search needs a query.", bad=True)
            return

        # For convenience, change which dict is used as result_sep to change
        # fd's behavior from splitting results by \0, which allows for newlines
        # in your filenames to splitting results by \n, which allows for \0 in
        # filenames.
        null_sep = {"arg": "-0", "split": "\0"}
        nl_sep = {"arg": "", "split": "\n"}
        result_sep = null_sep

        process = subprocess.Popen(
            ["fd", result_sep["arg"], depth, target],
            universal_newlines=True,
            stdout=subprocess.PIPE,
        )
        (search_results, _err) = process.communicate()
        global fd_deq
        fd_deq = deque(
            (
                self.fm.thisdir.path + os.sep + rel
                for rel in sorted(
                    search_results.split(result_sep["split"]), key=str.lower
                )
                if rel != ""
            )
        )
        if len(fd_deq) > 0:
            self.fm.select_file(fd_deq[0])


class fd_next(Command):
    """:fd_next

    Selects the next match from the last :fd_search.
    """

    def execute(self):
        if len(fd_deq) > 1:
            fd_deq.rotate(-1)  # rotate left
            self.fm.select_file(fd_deq[0])
        elif len(fd_deq) == 1:
            self.fm.select_file(fd_deq[0])


class fd_prev(Command):
    """:fd_prev

    Selects the next match from the last :fd_search.
    """

    def execute(self):
        if len(fd_deq) > 1:
            fd_deq.rotate(1)  # rotate right
            self.fm.select_file(fd_deq[0])
        elif len(fd_deq) == 1:
            self.fm.select_file(fd_deq[0])
