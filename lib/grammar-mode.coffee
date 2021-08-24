SubAtom = require 'sub-atom'

module.exports =

  activate: ->
    @subs = new SubAtom()
    @editorsWaitingForGrammar = []
    regex = /\s*syntax\=(\S+)\s*$/
    @subs.add atom.workspace.observeTextEditors (editor) =>
      editor.scan regex, (scanRes) =>
        @editorsWaitingForGrammar.push [editor, scanRes.match[1].toLowerCase()]
        @chkAndStartTimeout()
        scanRes.stop()
    @subs.add atom.grammars.onDidAddGrammar (=> @chkAndStartTimeout())

    @subs.add atom.commands.add 'atom-workspace', 'grammar-mode:recheck': =>
      for editor in atom.workspace.getTextEditors()
        console.log 'Command recieved'
        editor.scan regex, (scanRes) =>
          @editorsWaitingForGrammar.push [editor, scanRes.match[1].toLowerCase()]
          scanRes.stop()
      @chkGrammars 'timedOut'



  chkAndStartTimeout: ->
      @chkGrammars()
      if @timeout then clearTimeout @timeout
      @timeout = setTimeout (=> @chkGrammars 'timedOut'), 1000

  chkGrammars: (timedOut) ->
    if @timeout then clearTimeout @timeout
    for editorAndExt, editorIdx in @editorsWaitingForGrammar
      [editor, ext] = editorAndExt
      regex = /source\./
      grammar = atom.grammars.grammarForScopeName(ext)
      if ext.search(regex) == 0
        console.log 'Contains source', grammar, 'in file', editor.getPath()
        editor.setGrammar(grammar)
      else
        grammar = atom.grammars.selectGrammar 'x.' + ext
        console.log "Does not Contains source, file extension is", ext, '\nSetting mode', grammar, '\ File Path is', editor.getPath()
        setTimeout (-> editor.setGrammar grammar), 10
        @editorsWaitingForGrammar.splice editorIdx, 1
        if timedOut
          console.log 'Grammer not found for extension ', ext, 'in file ', editor.getPath()
          @editorsWaitingForGrammar.splice editorIdx, 1

  deactivate: ->
    @subs.dispose()
