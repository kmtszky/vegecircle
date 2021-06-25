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
    password: Faker::Internet.password(min_length: 6)
  )
end

10.times do |n|
  Customer.create!(
    nickname: Faker::Name.name,
    email: Faker::Internet.email,
    password: Faker::Internet.password(min_length: 6)
  )
end

Farmer.all.each do |farmer|
  farmer.news.create!(
    news: 'テスト投稿'
  )
end