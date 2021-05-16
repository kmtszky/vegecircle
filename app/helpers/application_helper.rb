module ApplicationHelper
  def converting_to_jpy(price)
    "#{price.to_s(:delimited, delimiter: ',')}円"
  end

  def show_date(date)
    date.strftime("%Y/%m/%d")
  end

  def show_time(time)
    time.strftime("%H:%M")
  end

  def create_time(time)
    time.strftime("%Y/%m/%d %H:%M")
  end
end
