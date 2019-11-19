
require 'minitest/autorun'
require 'user_trackers'

class UserTrackersTest < Minitest::Test
  def test_basic
    assert_equal UserTrackers.trackers, ['mixpanel','intercom','slack']
  end
end