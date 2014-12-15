{View} = require 'atom'

module.exports =
class GulpControlView extends View
  @content: ->
    @div ''

  constructor: ->
    super

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  getTitle: ->
    'gulp-control'
    
  initialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element
