{BufferedProcess,View} = require 'atom'
Convert = require 'ansi-to-html'

convert = new Convert()

module.exports =
class GulpControlView extends View
  @content: ->
    @div class: 'gulp-control', =>
      @ul class: 'tasks', outlet: 'taskList'
      @div class: 'output', outlet: 'outputPane'

  serialize: ->

  initialize: ->
    console.log 'GulpControlView: initialize'

    @click '.tasks li.task', (event) =>
      task = event.target.textContent
      for t in @tasks when t is task
        return @runGulp(task)

    @getGulpTasks()
    return

  destroy: ->
    console.log 'GulpControlView: destroy'

    if @process
      @process.kill()
      @process = null
    @detach()
    return

  getTitle: ->
    return 'gulp.js:control'

  getGulpTasks: ->
    @tasks = []

    onOutput = (output) =>
      for task in output.split('\n') when task.length
        @tasks.push task

    onError = (output) =>
      @gulpErr(output)

    onExit = (code) =>
      if code is 0
        for task in @tasks.sort()
          @taskList.append "<li id='gulp-#{task}' class='task'>#{task}</li>"

      else
        console.error 'GulpControl: getGulpTasks, exit', code

    @writeOutput 'Retrieving list of gulp tasks'
    @runGulp '--tasks-simple', onOutput, onError, onExit
    return

  runGulp: (task, stdout, stderr, exit) ->
    return unless atom.project.getPath()

    if @process
      @process.kill()
      @process = null

    command = 'gulp'
    args = [task, '--color']

    options =
      cwd: atom.project.getPath()
      env:
        PATH: switch process.platform
          when 'win32' then process.env.PATH
          else "#{process.env.PATH}:/usr/local/bin"

    stdout or= (output) => @gulpOut(output)
    stderr or= (code) => @gulpErr(code)
    exit or= (code) => @gulpExit(code)

    if task.indexOf('-')
      @writeOutput '&nbsp;'
      @writeOutput "Running gulp #{task}"

    @find('.tasks li.task.active').removeClass 'active'
    @find(".tasks li.task#gulp-#{task}").addClass 'active running'

    @process = new BufferedProcess({command, args, options, stdout, stderr, exit})
    return

  writeOutput: (line, klass) ->
    if line and line.length
      @outputPane.append "<pre class='#{klass or ''}'>#{line}</pre>"
      @outputPane.scrollToBottom()
    return

  gulpOut: (output) ->
    for line in output.split('\n')
      @writeOutput convert.toHtml(line)
    return

  gulpErr: (output) ->
    for line in output.split('\n')
      @writeOutput convert.toHtml(line), 'error'
    return

  gulpExit: (code) ->
    @find('.tasks li.task.active.running').removeClass 'running'
    @writeOutput "Exited with code #{code}", 'error'
    @process = null
    return
