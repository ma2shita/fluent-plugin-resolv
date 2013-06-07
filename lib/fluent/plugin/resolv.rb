require "fluent/plugin/resolv/version"
require 'resolv'

class Fluent::ResolvOutput < Fluent::Output
  Fluent::Plugin.register_output('resolv', self)

  config_param :key_name,          :string, :default => 'host'
  config_param :remove_prefix, :string, :default => nil
  config_param :add_prefix,    :string, :default => nil

  def configure(conf)
    super
    @remove_prefix = Regexp.new("^#{Regexp.escape(remove_prefix)}\.?") unless conf['remove_prefix'].nil?
  end

  def emit(tag, es, chain)
    tag = tag.sub(@remove_prefix, '') if @remove_prefix
    tag = (@add_prefix + '.' + tag) if @add_prefix
    es.each do |time,record|
      record[@key_name] = Resolv.getname(record[@key_name]) rescue record[@key_name].empty? ? 'n/a' : record[@key_name]
      Fluent::Engine.emit(tag, time, record)
    end
    chain.next
  end

end

