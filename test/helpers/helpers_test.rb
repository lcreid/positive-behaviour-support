# frozen_string_literal: true

require "test_helper"

class HelpersTest < ActionView::TestCase
  include AwardsHelper

  test "number_field_tag" do
    expected = <<-EXPECTED.strip_heredoc.strip
      <label for="fred">Fred</label>
      <input type="number" name="fred" id="fred" value="2" class="form-control" />
    EXPECTED

    assert_dom_equal expected, number_field_tag(:fred, 2)
  end

  test "number_field_tag with text label" do
    expected = <<-EXPECTED.strip_heredoc.strip
      <label for="fred">Frederick</label>
      <input type="number" name="fred" id="fred" value="2" class="form-control" />
    EXPECTED

    assert_dom_equal expected, number_field_tag(:fred, 2, label: "Frederick")
  end

  test "number_field_tag with hash label" do
    expected = <<-EXPECTED.strip_heredoc.strip
      <label for="fred">Frederick</label>
      <input type="number" name="fred" id="fred" value="2" class="form-control" />
    EXPECTED

    assert_dom_equal expected, number_field_tag(:fred, 2, label: { text: "Frederick" })
  end

  test "number_field_tag with label class" do
    expected = <<-EXPECTED.strip_heredoc.strip
      <label class="text-danger" for="fred">Frederick</label>
      <input type="number" name="fred" id="fred" value="2" class="form-control" />
    EXPECTED

    assert_dom_equal expected, number_field_tag(:fred, 2, label: { text: "Frederick", class: "text-danger" })
  end

  test "number_field_tag with hidden label" do
    expected = <<-EXPECTED.strip_heredoc.strip
      <label class="sr-only" for="fred">Fred</label>
      <input type="number" name="fred" id="fred" value="2" class="form-control" />
    EXPECTED

    assert_dom_equal expected, number_field_tag(:fred, 2, hide_label: true)
  end

  test "number_field_tag with no label" do
    expected = <<-EXPECTED.strip_heredoc.strip
      <input type="number" name="fred" id="fred" value="2" class="form-control" />
    EXPECTED

    assert_dom_equal expected, number_field_tag(:fred, 2, skip_label: true)
  end

  test "number_field_tag with help" do
    expected = <<-EXPECTED.strip_heredoc.strip
      <label for="fred">Fred</label>
      <input type="number" name="fred" id="fred" value="2" class="form-control" />
      <small class="form-text text-muted">Help!</small>
    EXPECTED

    assert_dom_equal expected, number_field_tag(:fred, 2, help: "Help!")
  end

  test "number_field_tag with error" do
    expected = <<-EXPECTED.strip_heredoc.strip
      <label for="fred">Fred</label>
      <input type="number" name="fred" id="fred" value="2" class="form-control is-invalid" />
      <div class="invalid-feedback">Help!</div>
    EXPECTED

    assert_dom_equal expected, number_field_tag(:fred, 2, error: "Help!")
  end
end
