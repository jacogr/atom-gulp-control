## Development

## 0.4.2

- Allow for running tasks that have ':' in their name, fixes [#5](https://github.com/jacogr/atom-gulp-control/issues/5) and [#14](https://github.com/jacogr/atom-gulp-control/issues/14)

... where there is smoke, there is fire.

## 0.4.1

- Make test for gulpfile.[js|coffee] case insensitive, fixes [#13](https://github.com/jacogr/atom-gulp-control/issues/13)

... conform to gulp naming conventions

## 0.4.0

- Use atom.project.getPaths() instead of atom.project.getPath() (1.0 deprecation)
- View require now requires from atom-space-pen-views (1.0 deprecation)
- Move styles from stylesheet/ into styles. [Bruno Sabot](https://github.com/brunosabot) contributed [#11](https://github.com/jacogr/atom-gulp-control/pull/11)
- Add support for executing locally installed gulp. [Micah Zoltu](https://github.com/Zoltu) contributed [#9](https://github.com/jacogr/atom-gulp-control/pull/9)
- Fix deprecation. [Amit Choukroun](https://github.com/amitmtrn) contributed [#4](https://github.com/jacogr/atom-gulp-control/pull/4)

... ready for the Atom 1.0 release

## 0.3.3

- Updated description & README

... tidying up

## 0.3.2

- Export the full current environment to the gulp sub-process
- Explicitly adjust path on nix/OSX to include /usr/local/bin
- Only display exit code in red when there has been an actual error
- Use ui-variables colors everywhere to help with UI theme switching

... best practices for doing the UI, doesn't mean light works yet

## 0.3.1

- Gulpfile name should be case-insensitive

... ouch.

## 0.3.0

- Locate the Gulpfile.js/Gulpfile.coffee in your project automatically when not in the project root
- Above fixes https://github.com/jacogr/atom-gulp-control/issues/1

... allowing for files not in the root

## 0.2.1

- Output now in pre blocks, console outputs deserves console-look

... making things pretty

## 0.2.0

- Tested on Windows, NOTE removed
- Fixed Open not opening when selected again
- ability to run multiple control tabs

... bring it close to decent and stable

## 0.1.1

- Allow generic $PATH to be passed-in, should help Windows compatibility
- Rename menu "Toggle" to "Open" to reflect actual action
- Updated README to reflect where to get things

... going down the road of cleaning up

## 0.1.0

- Initial version
- Displays all gulp tasks as list, allowing for traversing
- Allows execution of any task via click, re-starting on subsequent clicks
- Captures gulp output, along with the original --color output

... the basics are there
