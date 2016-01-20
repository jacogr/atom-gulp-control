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

  config:
    nodePath:
      title: 'Bin Path',
      description: 'This should be set to the folder in which the node executable is located. This can be found by typing \'which node\' from the command line, but you need to remove \'node\' from the end.'
      type: 'string'
      default: '/usr/local/bin'
