SubAtom = require 'sub-atom'

module.exports =

  activate: ->
    @subs = new SubAtom()
    @editorsWaitingForGrammar = []
    regex = /\ssyntax\=(\S+)\s*$/
    @subs.add atom.workspace.observeTextEditors (editor) =>
      editor.scan regex, (scanRes) =>
        @editorsWaitingForGrammar.push [editor, scanRes.match[1].toLowerCase()]
        @chkAndStartTimeout()
        scanRes.stop()

    @subs.add atom.grammars.onDidAddGrammar (=> @chkAndStartTimeout())

  chkAndStartTimeout: ->
      @chkGrammars()
      if @timeout then clearTimeout @timeout
      @timeout = setTimeout (=> @chkGrammars 'timedOut'), 1000

  chkGrammars: (timedOut) ->
    if @timeout then clearTimeout @timeout
    for editorAndExt, editorIdx in @editorsWaitingForGrammar
      [editor, ext] = editorAndExt
      regex = /source\./
      if ext.search(regex) == 0
        grammar = atom.grammars.grammarForScopeName(ext)
        console.log "Contains source"
        console.log ext
      else
        grammar = atom.grammars.selectGrammar 'x.' + ext
        console.log "Does not Contains source"
        console.log ext

      if grammar.name isnt 'Null Grammar'
        console.log 'setting mode', path: editor.getPath(), ext: ext, grammar: grammar.name
        setTimeout (-> editor.setGrammar grammar), 10
        @editorsWaitingForGrammar.splice editorIdx, 1
      else if timedOut
          # @editorsWaitingForGrammar.splice editorIdx, 1
          console.log 'Grammer not found for extension "' + ext + '" ' +
                      'in file ' + editor.getPath()
          @editorsWaitingForGrammar.splice editorIdx, 1

  deactivate: ->
    @subs.dispose()
