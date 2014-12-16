{BufferedProcess,View} = require 'atom'

module.exports =
class GulpControlView extends View
  @content: ->
    @div class: 'gulp-control', =>
      @ul class: 'tasks', outlet: 'taskList'
      @div class: 'output', outlet: 'outputPane'

  serialize: ->

  initialize: ->
    @taskList.append '<li class="active">default</li>'
    @outputPane.append '<h1>Output goes here</h1>'
    @getGulpTasks()

  getGulpTasks: ->
    if atom.project.getPath()
      console.log atom.project.getPath()
      command = switch process.platform
        when 'win32' then 'gulp'
        else '/usr/local/bin/gulp'
      args = ['--tasks-simple']
      options = {
        cwd: atom.project.getPath()
      }
      stdout = (o) -> console.log o
      stderr = (o) -> console.error o
      exit = (o) -> console.error o
      proc = new BufferedProcess({command, args, options, stdout, stderr, exit})

  getTitle: ->
    'gulp.js:control'
