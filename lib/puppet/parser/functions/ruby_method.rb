doc = <<-EOD
Implement a trivial interface to ruby methods
EOD

Puppet::Parser::Functions.newfunction(:ruby_method,
                                      :type => :rvalue,
                                      :arity => -1,
                                      :doc => doc) do |args|
  k_name, k_args, m_name, m_args, *extra = *args

  klass = k_name.split('::').map(&:to_sym).inject(Object) do |const, str|
    const.const_get(str.intern)
  end

  obj = klass.new(*k_args)
  obj.send(m_name.to_sym, *m_args)
end
