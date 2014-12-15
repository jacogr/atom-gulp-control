GulpControlView = require './gulp-control-view'
{CompositeDisposable} = require 'atom'

views = []

module.exports = GulpControl =
  activate: (state) ->
    console.log 'GulpControl: activate'
    @newView()

  deactivate: ->
    for view in views
      view.destroy()

  serialize: ->

  toggle: ->
    console.log 'GulpControl: toggle'

  newView: ->
    view = new GulpControlView()
    views.push view
    pane = atom.workspace.getActivePane()
    item = pane.addItem view
    pane.activateItem item
