class MessagesController < ApplicationController
  def index
    redirect_unless_assets_and_messages
    @assets = get_assets
  end

  def single_asset
    redirect_unless_assets_and_messages
    @name = params[:name]
    @asset = get_asset(@name)
  end

  private
  def redirect_unless_assets_and_messages
    redirect_unless_bolt_on('Assets')
    redirect_unless_bolt_on('AssetsMessages')
    true
  end

  def get_assets
    #TODO change this
    cmd = '/tmp/flight-message/bin/message show'
    out = run_command_with_clean_env(cmd)
    assets = out.split(/^#/).delete_if { |a| a.empty? }
    assets.map! { |a| parse_asset(a) }
    assets
  end

  def get_asset(name)
    #TODO change this
    cmd = "/tmp/flight-message/bin/message show #{name}"
    parse_asset(run_command_with_clean_env(cmd))
  end

  def parse_asset(text)
    hash = {}
    lines = text.split(/\n/)
    first = lines.shift
    m = first.match(/(.*?)(:  STATUS - (.*))?$/)
    hash['name'] = m[1]
    hash['status'] = m[3] unless m[3].nil?
    hash['messages'] = []
    lines.each do |line|
      next if line.empty?
      received, id, text = line.split(/ - /)
      hash['messages'] << {
        'id' => id,
        'text' => text,
        'received' => received
      }
    end
    hash
  end
end

