# ftp.py - manage ftp uploads of snapshots with mercurial
#
# Copyright 2009 Andre Klitzing <andre@incubo.de>
#
# This software may be used and distributed according to the terms
# of the GNU General Public License, incorporated herein by reference.

"""upload and delete files on FTP server"""

from mercurial.i18n import gettext as _
from mercurial import commands, util, cmdutil, url as hg_url, node
import os, ftplib, urlparse
try:
    from cStringIO import StringIO
except ImportError:
    from StringIO import StringIO

class manageFTP:
    def __init__(self, ui, repo, opts, url):
        """Read options and load settings from hgrc"""
        self.ui = ui
        self.repo = repo
        self.opts = opts
        self.uploaded = None
        self.selected = None

        self.chmod_file = self.opts.get('file') or self.ui.config('ftp', 'chmod_file')
        self.chmod_dir = self.opts.get('dir') or self.ui.config('ftp', 'chmod_dir')

        path = self.ui.config('paths', url)
        if path:
            self.url = urlparse.urlsplit(path)
        else:
            self.url = urlparse.urlsplit(url)
        self.netloc = hg_url.netlocsplit(self.url[1])
        if self.url[0] != 'ftp' or not self.netloc[0]:
            self.ui.warn(_('No host in [paths] found\n'))

        self.useGlobal = self.opts.get('global') or self.ui.configbool('ftp', 'global_tags')

        self.tagname = self.opts.get('tag')
        if not self.tagname:
            prefix = self.ui.config('ftp', 'prefix_tags') or _('uploaded@')
            self.tagname = prefix + self.netloc[0]

    def _set_changesets(self):
        """Search the tag of that host and select revisions (root and child)"""
        if self.opts.get('rev'):
            self.selected = self.repo[self.opts.get('rev')]
        else:
            self.selected = self.repo[None].parents()[0]

        tags = self.repo.tags()
        if self.tagname in tags:
            self.uploaded = self.repo[tags[self.tagname]]

        if self.uploaded is None:
            self.ui.write(_('Tag %s not found\n') % self.tagname)
        else:
            self.ui.write(_('Tag %s on changeset %d:%s (branch: %s) found\n') %
                (self.tagname, self.uploaded, self.uploaded, self.uploaded.branch()) )

    def _check_changed(self):
        """Test if there is an uncommitted merge or .hgtags is changed if global tags are used"""
        if self.repo.dirstate.parents()[1] != node.nullid:
            raise util.Abort(_('outstanding uncommitted merge'))

        if self.opts.get('upload') and self.useGlobal and not self.opts.get('only'):
            status = self.repo.status('.', None, cmdutil.matchfiles(self.repo, ['.hgtags']))
            if max(status):
                raise util.Abort(_('outstanding uncommitted .hgtags'))

    def _get_files(self):
        """Return changed files of found revisions"""
        self._set_changesets()

        if self.uploaded is None or self.opts.get('all'):
            self.ui.write(_('Upload every file of changeset %d:%s\n') %
                    (self.selected, self.selected))

            return (self.selected.manifest(), [])
        else:
            if self.selected not in self.uploaded.descendants():
                raise util.Abort(_('Changeset %d:%s is not a descendant of changeset %d:%s' %
                    (self.selected, self.selected, self.uploaded, self.uploaded)))

            files = self.repo.status(self.uploaded, self.selected)
            files_up = files[0] + files[1]
            files_up.sort()
            return (files_up, files[2])

    def run(self):
        if not self.repo.local:
            raise util.Abort(_('Repository "%s" is not local') % self.repo.root)

        self._check_changed()
        upload, remove = self._get_files()

        if self.opts.get('show'):
            self.ui.write(_('Upload files:\n'))
            for f in upload:
                self.ui.write('\t%s\n' % f)
            self.ui.write(_('\nDelete files:\n'))
            for f in remove:
                self.ui.write('\t%s\n' % f)

        self.ui.write(_('Upload files: %s, delete files: %s\n') %
                (len(upload), len(remove)) )

        if self.opts.get('upload'):
            if upload or remove:
                self._ftp(upload, remove)

            if not self.opts.get('only'):
                commands.tag(self.ui, self.repo, self.tagname,
                        local=not self.useGlobal,
                        rev=str(self.selected),
                        force=True)

                self.ui.write(_('Added tag %s for changeset %d:%s\n') %
                        (self.tagname, self.selected, self.selected))

    def _ftp(self, files_up, files_rm):
        """Get login/password and connect to server to upload/remove files"""
        if self.url[0] != 'ftp':
            raise util.Abort(_('Only "ftp" scheme is supported'))
        if not self.netloc[0]:
            raise util.Abort(_('No host given'))

        if self.netloc[1]:
            ftp = ftplib.FTP(self.netloc[0], self.netloc[1])
        else:
            ftp = ftplib.FTP(self.netloc[0])

        user = self.netloc[2] or self.ui.prompt('login:')
        psw = self.netloc[3] or self.ui.getpass()

        try:
            ftp.login(user, psw)
        except ftplib.all_errors, error:
            raise util.Abort(_('Cannot login: %s') % error)

        base = self.url[2] or ftp.pwd()

        if files_up:
            self.ftp_store(ftp, files_up, base)
        if files_rm:
            self.ftp_rm(ftp, files_rm, base)

        self.ui.write(_('Upload of changeset %d:%s to %s finished\n') %
                (self.selected, self.selected, self.netloc[0]))

        ftp.close()

    def ftp_mkd(self, ftp, pathname, base):
        """Create non-existing directories on server"""
        ftp.cwd(base)
        for folder in pathname.split(os.sep):
            if folder != "":
                try:
                    ftp.cwd(folder)
                except ftplib.error_perm:
                    try:
                        ftp.mkd(folder)
                    except ftplib.all_errors, error:
                        raise util.Abort(_('Cannot create dir "%s": %s') %
                                (pathname, error))

                    if self.chmod_dir:
                        try:
                            ftp.voidcmd('SITE CHMOD %s %s' %
                                    (self.chmod_dir, folder))
                        except ftplib.all_errors, error:
                            self.ui.warn(_('Cannot CHMOD dir "%s": %s') %
                                    (pathname, error))
                    ftp.cwd(folder)

    def ftp_store(self, ftp, files, base):
        """Upload given files to server and create needed directories"""
        try:
            ftp.cwd(base)
        except ftplib.all_errors, error:
            raise util.Abort(_('Cannot change to basedir "%s": %s') %
                    (base, error))

        for f in files:
            file = self.selected[f]
            pathname, filename = os.path.split( os.path.normpath(file.path()) )

            try:
                ftp.cwd(base + '/' + pathname)
            except ftplib.error_perm, error:
                self.ftp_mkd(ftp, pathname, base)

            try:
                filedata = StringIO(file.data())

                if util.binary(file.data()):
                    ftp.storbinary('STOR %s' % filename, filedata)
                else:
                    ftp.storlines('STOR %s' % filename, filedata)

                if self.chmod_file:
                    try:
                        ftp.voidcmd('SITE CHMOD %s %s' %
                                (self.chmod_file, filename))
                    except ftplib.all_errors, error:
                        self.ui.warn(_('Cannot CHMOD file "%s": %s') %
                                (file, error))

                filedata.close()
            except ftplib.all_errors, error:
                raise util.Abort(_('Cannot upload file "%s": %s') %
                        (filename, error))

    def ftp_rm(self, ftp, files, base):
        """Remove given files from server"""
        try:
            ftp.cwd(base)
        except ftplib.all_errors, error:
            raise util.Abort(_('Cannot change to basedir "%s": %s') %
                    (base, error))

        for f in files:
            try:
                ftp.delete(base + '/' + f)
            except ftplib.all_errors, error:
                self.ui.warn(_('Cannot remove file "%s": %s\n') % (f, error))



def main(ui, repo, *pats, **opts):
    """Manage snapshots on FTP server

    Upload snapshots of a revision to one or more FTP server.

    It will upload all files of a revision and set a (local) tag like
    "uploaded@host". If it will find an existing tag for that host it
    will remove vanished files and upload only the difference between
    that revision and the new one.

    Notes:
    If an error happens on server-side on deleting or CHMODing a file
    it will only print a warning about that but it will abort if it can't
    upload a file or create a directory.
    Since Mercurial doesn't track directories it won't delete existing
    directories on server even there is no file anymore.


    Possible settings in hgrc:

    [paths]
    ftp = ftp://[user[:pass]@]host[:port]/[path]
        ('ftp' will be used if DEST is not given)

    [ftp]
    chmod_file  = 644
    chmod_dir   = 755
    global_tags = False
    prefix_tags = uploaded@
    """

    if len(pats) > 1:
        commands.help_(ui, 'ftp')
        return
    elif len(pats) == 1:
        url = pats[0]
    else:
        url = 'ftp'

    obj = manageFTP(ui, repo, opts, url)
    obj.run()


cmdtable = {
    'ftp': (main,
    [
        ('a', 'all', None, _('upload all files of a changeset; do not use the difference')),
        ('d', 'dir', '', _('CHMOD new directories to given mode')),
        ('f', 'file', '', _('CHMOD new/changed files to given mode')),
        ('g', 'global', None, _('make the tag global')),
        ('o', 'only', None, _('only upload or remove files; do not set a tag')),
        ('r', 'rev', '', _('revision that will be uploaded')),
        ('s', 'show', None, _('show files that will be uploaded or deleted')),
        ('t', 'tag', '', _('use another tag name')),
        ('u', 'upload', None, _('start uploading or removing changed files'))
    ],
    _('hg ftp [OPTION] [DEST]')),
}

# vim:set ts=4 sw=4 et:
