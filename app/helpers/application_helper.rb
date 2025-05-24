module ApplicationHelper
  def calculate_age(birthdate)
    return 'No especificado' unless birthdate.present?

    now = Time.now.utc.to_date
    age = now.year - birthdate.year - (birthdate.to_date.change(year: now.year) > now ? 1 : 0)
    "#{age} años"
  end

  def format_date(date)
    return nil unless date.present?

    date.strftime("%d-%m-%Y")
  end

  def format_date_birthdate(date)
    return nil unless date.present?

    date.strftime("%d %B")
  end
end
