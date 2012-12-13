class FakeUser

  def id
    0
  end

  def can?(*args)
    true
  end

  def cannot?(*args)
    !can?(*args)
  end

  def is_root?
    true
  end

  def is_not_root?
    !is_root?
  end

  def locale
    ::I18n.locale
  end

  def applications
    Typus.applications
  end

  def application(name)
    Typus.application(name)
  end

  def role
    Typus.master_role
  end

  def status
    true
  end

  def owns?(resource)
    true
  end

end
