#!/usr/bin/env python3

import dropbox
import os
import requests
import sys

from dropbox.exceptions import ApiError, AuthError

old = sys.argv[1]
new = sys.argv[2]

CHUNK_SIZE = 4 * 1024 * 1024

# Setup credentials
refresh_token = ''
client_id = ''
client_secret = ''

res = requests.post('https://api.dropbox.com/oauth2/token?grant_type=refresh_token&refresh_token=%s&client_id=%s&client_secret=%s' % (refresh_token, client_id, client_secret))
dbx = dropbox.Dropbox(res.json()['access_token'])

try:
    dbx.files_delete('/' + old)
except ApiError:
    pass

with open(new, 'rb') as f:
    file_size = os.path.getsize(new)
    if file_size <= CHUNK_SIZE:
        dbx.files_upload(f.read(), '/' + new)
    else:
        upload_session_start_result = dbx.files_upload_session_start(f.read(CHUNK_SIZE))
        cursor = dropbox.files.UploadSessionCursor(session_id=upload_session_start_result.session_id,
                                               offset=f.tell())
        commit = dropbox.files.CommitInfo(path='/' + new)

        while f.tell() < file_size:
            try:
                dbx.check_user()
            except AuthError:
                res = requests.post('https://api.dropbox.com/oauth2/token?grant_type=refresh_token&refresh_token=%s&client_id=%s&client_secret=%s' % (refresh_token, client_id, client_secret))
                dbx = dropbox.Dropbox(res.json()['access_token'])
            if ((file_size - f.tell()) <= CHUNK_SIZE):
                print(dbx.files_upload_session_finish(f.read(CHUNK_SIZE),
                                                cursor,
                                                commit))
            else:
                dbx.files_upload_session_append(f.read(CHUNK_SIZE),
                                                cursor.session_id,
                                                cursor.offset)
                cursor.offset = f.tell()
