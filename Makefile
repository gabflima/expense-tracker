migrate:
	bundle exec sequel -m ./db/migrations sqlite://db/development.db --echo
