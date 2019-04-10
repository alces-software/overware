class ApplicationController < ActionController::Base
  include Clearance::Controller

  def authenticate(params)
    User.authenticate(
      params[:session][:username],
      params[:session][:password]
    )
  end

  # Deprecated and will be removed once run_global_script has been utilised
  def run_shell_command(command)
    system(command, out: File::NULL)
  end

  def run_global_script(command, *args)
    system(
      "bash #{ENV['ENTRYPOINT']} #{command} #{args.join(' ')}",
      out: File::NULL
    )
  end

  def bolt_on_enabled(name)
    BoltOn.find_by(name: name).enabled?
  end
  helper_method :bolt_on_enabled
end
