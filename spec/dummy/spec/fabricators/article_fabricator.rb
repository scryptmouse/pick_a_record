Fabricator(:article) do
  title { Faker::Lorem.sentence }
  body  { Faker::Lorem.paragraphs.join("\n\n") }
end
