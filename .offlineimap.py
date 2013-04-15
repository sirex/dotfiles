import re
import keyring

NAMETRANSMAP = {
    '[Gmail]/I&AWE-si&AXM-sti lai&AWE-kai': 'outbox',
}

def nametrans(foldername):
    if foldername in NAMETRANSMAP:
        return NAMETRANSMAP[foldername]
    else:
        return foldername.lower()

def folderfilter(foldername):
    return foldername in (
        'INBOX',
        '[Gmail]/I&AWE-si&AXM-sti lai&AWE-kai',
    )
