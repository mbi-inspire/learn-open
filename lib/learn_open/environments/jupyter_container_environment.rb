module LearnOpen
  module Environments
    class JupyterContainerEnvironment < BaseEnvironment
      def open_jupyter_lab(lesson, location, editor)
        download_lesson(lesson, location)
        open_editor(lesson, location, editor)
        start_file_backup(lesson, location)
        install_jupyter_dependencies(lesson, location)
        notify_of_completion
        open_shell
      end

      def open_editor(lesson, location, editor)
        io.puts "Opening lesson..."
        system_adapter.change_context_directory(lesson.to_path)
        system_adapter.open_editor(editor, path: ".")
      end

      def install_jupyter_dependencies(lesson, location)
        LearnOpen::DependencyInstallers::JupyterPipInstall.call(lesson, location, self, options)
      end

      def open_shell
        system_adapter.open_login_shell(environment_vars['SHELL'])
      end
    end
  end
end
