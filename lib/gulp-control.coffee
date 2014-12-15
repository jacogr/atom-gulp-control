GulpControlView = require './gulp-control-view'
{CompositeDisposable} = require 'atom'

module.exports = GulpControl =
  gulpControlView: null
  modalPanel: null
  subscriptions: null

  activate: (state) ->
    @gulpControlView = new GulpControlView(state.gulpControlViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @gulpControlView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'gulp-control:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @gulpControlView.destroy()

  serialize: ->
    gulpControlViewState: @gulpControlView.serialize()

  toggle: ->
    console.log 'GulpControl was toggled!'

    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()
