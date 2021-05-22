class Customers::ThanxMailer < ApplicationMailer

  def complete_reservation(reservation)
    @reservation = reservation
    @customer = Customer.find_by(id: @reservation.customer_id)
    mail(to: @customer.email, subject: "【vegecircle】農業体験ご予約完了のお知らせ" )
  end
end
