{BufferedProcess,View} = require 'atom'

module.exports =
class GulpControlView extends View
  @content: ->
    @div class: 'gulp-control', =>
      @ul class: 'tasks', outlet: 'taskList'
      @div class: 'output', outlet: 'outputPane'

  serialize: ->

  initialize: ->
    @click '.tasks li.task', (event) =>
      @runGulp event.target.textContent

    @getGulpTasks()

  getTitle: ->
    'gulp.js:control'

  getGulpTasks: ->
    tasks = []

    onOutput = (output) =>
      for task in output.split('\n') when task.length
        tasks.push task

    onExit = (code) =>
      if code is 0
        console.log 'GulpControl: getGulpTasks =', tasks
        for task in tasks.sort()
          @taskList.append "<li class='task'>#{task}</li>"

      else
        console.error 'GulpControl: getGulpTasks, exit', code

    @runGulp '--tasks-simple', onOutput, @stdErr, onExit

  runGulp: (task, stdout, stderr, exit) ->
    return unless atom.project.getPath()

    command = switch process.platform
      when 'win32' then 'gulp'
      else '/usr/local/bin/gulp'

    args = [task]

    options =
      cwd: atom.project.getPath()
      env:
        PATH: '/usr/local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin'

    stdout or= (output) => @gulpOut(output)
    stderr or= (code) => @gulpErr(code)
    exit or= (code) => @gulpExit(code)

    return new BufferedProcess({command, args, options, stdout, stderr, exit})

  setScroll: ->
    gulpHelper = atom.workspaceView.find('.gulp-control .output')
    gulpHelper.scrollTop(gulpHelper[0].scrollHeight)

  gulpOut: (output) ->
    for line in output.split("\n")
      @outputPane.append "<div>#{line}</div>"
    @setScroll()

  gulpErr: (code) ->
    console.error 'Error', code
    #atom.workspaceView.find('.gulp-helper .panel-body').append "<div class='text-error'>Error Code: #{code}</div>"
    #@setScroll()

  gulpExit: (code) ->
    console.error 'Exit', code
    #atom.workspaceView.find('.gulp-helper .panel-body').append "<div class='text-error'>Exited with error code: #{code}</div>"
    #@setScroll()
