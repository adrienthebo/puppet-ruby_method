doc = <<-EOD
Invoke Ruby methods from the Puppet DSL

Examples
--------

Join two arrays:

    ruby_method('Array', ['my', 'first', 'array'], 'join', ['and', 'my', 'second', 'array'])
    # => ['my', 'first', 'array', 'and', 'my', 'second', array']

Uppercase a string:

    ruby_method('String', ['my_string'], 'upcase', [])
    # => 'MY_STRING'

Gotta get down on Friday:

    ruby_method('Time', ['2013', '08', '16'], 'friday?', [])
    # => true

Caveats
-------

This directly interacts with the Ruby interpreter, which means that you can do
Extremely Bad Things (TM). You might want to avoid doing Extremely Bad Things (TM).

Argument parsing is subject to the Puppet DSL type parsing, so you probably want
to have an understanding of how the DSL parses strings, symbols, numbers, and so
forth.

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
