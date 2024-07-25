#  Copyright (c) 2021-2022 iCtrl Developers
# 
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#   of this software and associated documentation files (the "Software"), to
#   deal in the Software without restriction, including without limitation the
#   rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
#   sell copies of the Software, and to permit persons to whom the Software is
#   furnished to do so, subject to the following conditions:
# 
#  The above copyright notice and this permission notice shall be included in
#   all copies or substantial portions of the Software.
# 
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#   IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#   FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#   AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#   LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
#   FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
#   IN THE SOFTWARE.

import json

from flask import request, abort, stream_with_context

from .common import create_connection
from .. import api, app
from ..codes import ICtrlStep, ConnectionType, ICtrlError
from ..features.Term import TERM_CONNECTIONS, TERMINAL_PORT
from ..utils import int_to_bytes
import application


# FIXME: store term_id is cookie-based Flask 'session'

@api.route('/terminal', methods=['POST'])
def start_terminal():
    session_id = request.json.get('sessionID')
    load_check = request.json.get('loadCheck', True)
    application.logger.debug(f"Term: Starting terminal session: {session_id}")
    def generate():
        yield int_to_bytes(ICtrlStep.Term.SSH_AUTH)

        term, reason = create_connection(session_id, ConnectionType.TERM)
        if reason != '':
            application.logger.error(f"Term: Terminal connection failed: {reason}")
            yield reason
            return

        yield int_to_bytes(ICtrlStep.Term.CHECK_LOAD)
        if term.is_uoft() and load_check and term.is_load_high():
            application.logger.warning(f"Term: Load too high to start terminal session: {session_id}")
            yield int_to_bytes(ICtrlError.SSH.OVER_LOADED)
            return

        yield int_to_bytes(ICtrlStep.Term.LAUNCH_SHELL)
        status, reason = term.launch_shell()
        if status is False:
            application.logger.error(f"Term: Failed to launch terminal shell: {reason}")
            abort(403, description=reason)

        yield int_to_bytes(ICtrlStep.Term.DONE)
        result = {
            'port': TERMINAL_PORT,
            'term_id': term.id
        }
        application.logger.info(f"Term: Terminal session started successfully: {term.id} on port {TERMINAL_PORT}")
        yield json.dumps(result)

    return app.response_class(stream_with_context(generate()), mimetype='application/octet-stream')


@api.route('/terminal_resize', methods=['PATCH'])
def resize_terminal():
    term_id = request.json.get('term_id')
    if term_id not in TERM_CONNECTIONS:
        application.logger.error(f"Term: Invalid terminal ID for resize: {term_id}")
        abort(403, description='invalid term_id')

    width = request.json.get('w')
    height = request.json.get('h')
    application.logger.debug(f"Term: Resizing terminal {term_id}: width {width}, height {height}")
    term = TERM_CONNECTIONS[term_id]
    status, reason = term.resize(width, height)
    if status is False:
        application.logger.error(f"Term: Failed to resize terminal {term_id}: {reason}")
        abort(403, description=reason)

    application.logger.info(f"Term: Terminal {term_id} resized successfully")
    return 'success'
