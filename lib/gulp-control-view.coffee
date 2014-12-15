{View} = require 'atom'

module.exports =
class GulpControlView extends View
  @content: ->
    @div class: 'gulp-control', =>
      @div class: 'tasks'
      @div class: 'output'

  serialize: ->

  initialize: ->
    @find('.tasks').append '<h1>Tasks goes here</h1>'
    @find('.output').append '<h1>Output goes here</h1>'

  getTitle: ->
    'gulp.js:control'
