task sample_data: :environment do
  p "Creating sample data"

  if Rails.env.development?
    FollowRequest.delete_all
    Comment.delete_all
    Like.delete_all
    Photo.delete_all
    User.delete_all
  end

  10.times do
    mail = Faker::TvShows::SiliconValley.unique.email
    User.create(
      email: "#{mail}",
      password: "notahotdog",
      username: mail.split("@").at(0),
      private: [true, false].sample
    )
  end
  p "#{User.count} users have been created"

  users = User.all

  users.each do |user_1|
    users.each do |user_2|
      if rand < 0.66
        user_1.sent_follow_requests.create(
          recipient: user_2,
          status: FollowRequest.statuses.values.sample
        )
      end

      if rand < 0.66
        user_2.sent_follow_requests.create(
          recipient: user_1,
          status: FollowRequest.statuses.values.sample
        )
      end
    end
  end
  p "#{FollowRequest.count} follow requests have been created"

  users.each do |user|
    rand(12).times do
      photo = user.own_photos.create(
        caption: Faker::TvShows::SiliconValley.quote,
        image: "https://robohash.org/#{rand(343343)}?bgset=bg1",
      )

      user.followers.each do |follower|
        if rand < 0.50
          photo.fans << follower
        end

        if rand < 0.50
          photo.comments.create(
            body: Faker::TvShows::SiliconValley.quote,
            author: follower
          )
        end
      end
    end
  end
  p "#{Photo.count} photos have been created"
  p "#{Like.count} likes have been created"
  p "#{Comment.count} comments have been created"
end
