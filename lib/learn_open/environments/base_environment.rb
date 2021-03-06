module LearnOpen
  module Environments
    class BaseEnvironment

      attr_reader :io, :environment_vars, :system_adapter, :options, :logger

      def initialize(options={})
        @io = options.fetch(:io) { LearnOpen.default_io }
        @environment_vars = options.fetch(:environment_vars) { LearnOpen.environment_vars }
        @system_adapter = options.fetch(:system_adapter) { LearnOpen.system_adapter }
        @logger = options.fetch(:logger) { LearnOpen.logger }
        @options = options
      end

      def open_jupyter_lab(lesson, location, editor)
        :noop
      end

      def open_lab(lesson, location, editor)
        case lesson
        when LearnOpen::Lessons::IosLesson
          io.puts "You need to be on a Mac to work on iOS lessons."
        else
          download_lesson(lesson, location)
          open_editor(lesson, location, editor)
          install_dependencies(lesson, location)
          notify_of_completion
          open_shell
        end
      end

      def install_dependencies(lesson, location)
        DependencyInstallers.run_installers(lesson, location, self, options)
      end

      def download_lesson(lesson, location)
        LessonDownloader.call(lesson, location, options)
      end

      def open_editor(lesson, location, editor)
        io.puts "Opening lesson..."
        system_adapter.change_context_directory(lesson.to_path)
        system_adapter.open_editor(editor, path: ".")
      end

      def start_file_backup(lesson, location)
        FileBackupStarter.call(lesson, location, options)
      end

      def open_shell
        system_adapter.open_login_shell(environment_vars['SHELL'])
      end

      def notify_of_completion
        logger.log("Done.")
        io.puts "Done."
      end

      def warn_if_necessary(lesson)
        return unless lesson.later_lesson

        io.puts 'WARNING: You are attempting to open a lesson that is beyond your current lesson.'
        io.print 'Are you sure you want to continue? [Y/n]: '

        warn_response = io.gets.chomp.downcase
        exit if !['yes', 'y'].include?(warn_response)
      end
    end
  end
end
