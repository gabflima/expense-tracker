migrate:
	bundle exec sequel -m ./db/migrations sqlite://db/development.db --echo

isolated-tests:
	(for f in `find spec -iname '*_spec.rb'`; do echo "$f:"; bundle exec rspec $f -fp || exit 1; done)
