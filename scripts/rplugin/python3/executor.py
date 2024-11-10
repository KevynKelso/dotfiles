#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import pynvim
import threading
import time


@pynvim.plugin
class ExecutorPlugin(object):
    def __init__(self, nvim):
        self.nvim = nvim

    @pynvim.autocmd('BufWritePost', pattern='*.c', eval='expand("<afile>")', sync=True)
    def on_bufwritepost(self, filename):
        """Execute some functions after writing a C file."""
        # The idea is to execute bu --no-upload --no-erase
        threading.Thread(target=self._execute).start()

    def _execute(self):
        self.nvim.async_call(self.nvim.out_write, "start\n")
        # TODO: check build status and print output based on that
        time.sleep(3)
        self.nvim.async_call(self.nvim.out_write, "done :)\n")

