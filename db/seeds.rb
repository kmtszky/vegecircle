# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'
Faker::Config.locale = :ja

Admin.create!(
  email: "admin@111",
  password: "admin111"
)

farmer_name =   ["さくら農家", "すみれ農場", "たんぽんぽ農場", "葵ファーム", "ふくじゅ農園", "ひまわり農家", "あやめファーム", "カスミ農場", "つつじ農家", "ガジュファーム"]
farm_address =  ["兵庫県神崎郡市", "愛知県小牧市", "富山県富山市", "千葉県佐倉市", "石川県能美市", "三重県志摩市", "北海道広尾郡広尾町", "高知県幡多郡黒潮町", "香川県三豊市", "鹿児島県鹿児島市"]
store_address = ["兵庫県神崎郡市川町西田中8-3-8", "愛知県小牧市春日寺4-14-3", "富山県富山市山田湯2-6-8", "千葉県佐倉市井野9-13-1", "石川県能美市火釜町7-3-7", "三重県志摩市磯部町坂崎1-1-4", "北海道広尾郡広尾町公園通南3525", "高知県幡多郡黒潮町灘9-8-5", "香川県三豊市詫間町松崎8-6-7-1303", "鹿児島県鹿児島市冷水町5-11-7"]
10.times do |n|
  Farmer.create!(
    name: farmer_name[n],
    farm_address: farm_address[n],
    store_address: store_address[n],
    email: Faker::Internet.email,
    password: Faker::Internet.password(min_length: 6),
    farmer_image: File.open("./app/assets/images/farmer/icon_farmer#{n+1}.jpg")
  )
end

10.times do |n|
  Customer.create!(
    nickname: Faker::Name.name,
    email: Faker::Internet.email,
    password: Faker::Internet.password(min_length: 6)
  )
end

Farmer.where(id: [1, 2, 3, 4, 5]).each do |farmer|
  farmer.news.create!(
    news: 'テスト投稿'
  )
end

event_title = ["じゃがいも収穫", "だいこん収穫", "いちご狩り！", "ぶどう狩り", "とうもろこし収穫祭！茹でて食べよう！", "ブロッコリーの収穫！", "みかんの収穫", "夏野菜を食べよう", "人参の収穫"]
event_body = ["じゃがいもを収穫します！収穫後、じゃがバターも作る予定です＾＾",
              "大きくなった大根を収穫します。ぜひお立ち寄りください！",
              "イチゴがどんどん甘くなってきました。練乳も用意してお待ちおります！",
              "人房ずつ大切に育てました。今年は災害も少なく特に自信の出来栄えです。",
              "とうもろこしを収穫します！とれたては非常に甘く、茹でずとも食べることもできるほどです。ご参加お待ちしています！",
              "ブロッコリーの収穫前の姿をご存知でしょうか？ぜひ収穫を楽しんでいただきながら、花畑のような見た目も楽しんでいただけたらと思います。",
              "みかんを収穫します。ご家族あたり1kgまでお持ち帰りも可能です！",
              "夏野菜が大きく育ってきました。収穫のお手伝いをしていただけるとありがたいです！",
              "人参が今年も大きく育ちました。収穫をして、他の野菜と一緒に食事もしませんか？"]
9.times do |n|
  Farmer.where('id = ?', rand(Farmer.first.id..Farmer.last.id)).each do |farmer|
    event = farmer.events.create!(
      title: event_title[n],
      plan_image: File.open("./app/assets/images/event/event#{n+1}.jpg"),
      body: event_body[n],
      fee: Faker::Number.within(range: 100..1000),
      cancel_change: "前日までにキャンセル連絡をお願いいたします。",
      location: farmer.store_address,
      access: "車で来られるのが良いかと思います。",
      parking: Faker::Number.within(range: 0..2),
      etc: "動きやすい服装で、水分の持参を忘れずお願いいたします！",
      start_date: Faker::Date.between(from: Date.current + 2, to: Date.current + 4),
      end_date: Faker::Date.between(from: Date.current + 4, to: Date.current + 6),
      start_time: "09:00:00.000",
      end_time: "12:00:00.000",
      number_of_participants: Faker::Number.within(range: 10..20)
    )
    event.create_schedules(farmer)
    if event.has_schedules?
      number_of_days = event.end_date - event.start_date
      event.date_update unless event.schedules.size == number_of_days + 1
    else
      event.destroy
    end
  end
end