require 'helper'

class ResolvOutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  def create_driver(conf, tag = 'test')
    Fluent::Test::OutputTestDriver.new(Fluent::ResolvOutput, tag).configure(conf)
  end

  CONFIG0 = %[]
  def test_resolv
    time = Time.now.to_i
    d = create_driver(CONFIG0)
    d.run do
      d.emit({'host' => '124.39.181.36'})
      d.emit({'host' => '192.0.2.1'})
      d.emit({'host' => 'cannot.resolv'})
      d.emit({'host' => ''})
    end
    assert_equal 4,                    d.emits.length
    assert_equal 'www.plathome.co.jp', d.emits[0][2]['host']
    assert_equal '192.0.2.1',          d.emits[1][2]['host']
    assert_equal 'cannot.resolv',      d.emits[2][2]['host']
    assert_equal 'n/a',                d.emits[3][2]['host']
  end

  CONFIG1 = %[
    key_name any_key_name
  ]
  def test_key_name
    time = Time.now.to_i
    d = create_driver(CONFIG1)
    d.run do
      d.emit({'any_key_name' => '124.39.181.36'})
    end
    assert_equal 1,                    d.emits.length
    assert_equal 'www.plathome.co.jp', d.emits[0][2]['any_key_name']
  end

  CONFIG2 = %[
    add_prefix foo
  ]
  def test_add_prefix
    time = Time.now.to_i
    d = create_driver(CONFIG2)
    d.run do
      d.emit({'host' => '124.39.181.36'})
    end
    assert_equal 1,                    d.emits.length
    assert_equal 'www.plathome.co.jp', d.emits[0][2]['host']
    assert_equal 'foo.test',           d.emits[0][0]
  end

  CONFIG3 = %[
    remove_prefix tag
  ]
  def test_remove_prefix
    time = Time.now.to_i
    d = create_driver(CONFIG3, 'tag.tag1.tag2')
    d.run do
      d.emit({'host' => '124.39.181.36'})
    end
    assert_equal 1,                    d.emits.length
    assert_equal 'www.plathome.co.jp', d.emits[0][2]['host']
    assert_equal 'tag1.tag2',          d.emits[0][0]
  end

  CONFIG4 = %[
    remove_prefix tag
    add_prefix good
  ]
  def test_remove_and_add_prefix
    time = Time.now.to_i
    d = create_driver(CONFIG4, 'tag.tag1')
    d.run do
      d.emit({'host' => '124.39.181.36'})
    end
    assert_equal 1,                    d.emits.length
    assert_equal 'www.plathome.co.jp', d.emits[0][2]['host']
    assert_equal 'good.tag1',          d.emits[0][0]
  end

end

