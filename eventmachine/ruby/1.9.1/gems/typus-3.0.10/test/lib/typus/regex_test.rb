require "test_helper"

class RegexTest < ActiveSupport::TestCase

  context "email_regex" do

    should "match valid emails" do
      ["john@example.com",
       "john+locke@example.com",
       "john.locke@example.com",
       "john.locke@example.us"].each do |value|
        assert_match Typus::Regex::Email, value
      end
    end

    should "not match invalid emails" do
      [%Q(this_is_chelm@example.com\n<script>location.href="http://spammersite.com"</script>),
       "admin",
       "TEST@EXAMPLE.COM",
       "test@example",
       "test@example.c",
       "testexample.com"].each do |value|
        assert_no_match Typus::Regex::Email, value
      end
    end

  end

  context "uri_regex" do

    should "match valid urls" do
      ["http://example.com",
       "http://www.example.com",
       "http://www.example.es",
       "http://www.example.co.uk",
       "http://four.sentenc.es",
       "http://www.ex-ample.com"].each do |value|
        assert_match Typus::Regex::Url, value
      end
    end

    should "not match invalid urls" do
      [%Q(this_is_chelm@example.com\n<script>location.href="http://spammersite.com"</script>),
       "example.com",
       "http://examplecom",
       "http://ex+ample.com"].each do |value|
        assert_no_match Typus::Regex::Url, value
      end
    end

  end

end
