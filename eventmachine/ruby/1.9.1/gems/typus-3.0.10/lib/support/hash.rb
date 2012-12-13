class Hash

  def compact
    delete_if { |k, v| v.blank? }
  end

  def cleanup
    whitelist = %w(controller action id
                   input
                   layout
                   resource resource_id resource_action
                   selected
                   back_to)
    delete_if { |k, v| !whitelist.include?(k) }
  end

end
