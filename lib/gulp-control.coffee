GulpControlView = require './gulp-control-view'
{CompositeDisposable} = require 'atom'

module.exports = GulpControl =
  gulpControlView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @gulpControlView = new GulpControlView()
    pane = atom.workspace.getActivePane()
    item = pane.addItem @gulpControlView
    pane.activateItem item

  deactivate: ->
    @gulpControlView.destroy()

  serialize: ->
    gulpControlViewState: @gulpControlView.serialize()

  toggle: ->
    console.log 'GulpControl was toggled!'
