namespace :cleanup do
  desc "task that prunes the shortened url database of old urls"
  task prune: :environment do
    ShortenedUrl.prune
  end

end
