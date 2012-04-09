Copyright (c) 2012, Koding, Inc.
Author : Saleem Abdul Hamid <meelash@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

addRequireClientSide = ->
  bongo.api.Require::require = (path, callback)->
    if (exported = cache.modules[path])?
      callback? null, exported
      return exported
    else if (source = cache.fetched[path])?
      do ->
        module = exports : {}
        # exports = module.exports
        console.log "#{path} eval'ed"
        eval source
        exported = cache.modules[path] = module.exports
        callback? null, exported
        return exported
    else
      @serverRequire path, cache.cached, (err, sources)->
        for own subPath, source of sources
          console.log "#{subPath} fetched"
          cache.fetched[subPath] = source
          cache.cached[subPath] = yes
        callback null, require path

  cache =
    modules : {}
    fetched : {}
    cached  : {}

  requireObj = new bongo.api.Require
  window.require = requireObj.require.bind requireObj