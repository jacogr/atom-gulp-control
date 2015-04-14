GulpControlView = require './gulp-control-view'
{CompositeDisposable} = require 'atom'

views = []

module.exports = GulpControl =
  activate: (state) ->
    console.log 'GulpControl: activate'

    atom.commands.add 'atom-workspace', "gulp-control:toggle": => @newView()
    return

  deactivate: ->
    console.log 'GulpControl: deactivate'
    return

  newView: ->
    console.log 'GulpControl: toggle'

    view = new GulpControlView()
    views.push view

    pane = atom.workspace.getActivePane()
    item = pane.addItem view, 0
    pane.activateItem item
    return

  serialize: ->
