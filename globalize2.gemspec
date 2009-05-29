# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{globalize2}
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Josh Harvey"]
  s.date = %q{2009-05-28}
  s.description = %q{The second incarnation of Globalize for Rails}
  s.email = %q{joshmh@gmail.com}
  s.files = ["lib/globalize/backend/chain.rb", "lib/globalize/backend/pluralizing.rb", "lib/globalize/backend/static.rb", "lib/globalize/i18n/missing_translations_log_handler.rb", "lib/globalize/i18n/missing_translations_raise_handler.rb", "lib/globalize/load_path.rb", "lib/globalize/locale/fallbacks.rb", "lib/globalize/locale/language_tag.rb", "lib/globalize/model/active_record/adapter.rb", "lib/globalize/model/active_record/translated.rb", "lib/globalize/model/active_record.rb", "lib/globalize/translation.rb", "lib/globalize.rb", "lib/rails_edge_load_path_patch.rb", "rails/init.rb", "test/backends/chained_test.rb", "test/backends/pluralizing_test.rb", "test/backends/static_test.rb", "test/data/no_globalize_schema.rb", "test/data/post.rb", "test/data/schema.rb", "test/i18n/missing_translations_test.rb", "test/load_path_test.rb", "test/locale/fallbacks_test.rb", "test/locale/language_tag_test.rb", "test/model/active_record/migration_test.rb", "test/model/active_record/sti_translated_test.rb", "test/model/active_record/translated_test.rb", "test/test_helper.rb", "test/translation_test.rb", "generators/db_backend.rb", "generators/templates/db_backend_migration.rb", "LICENSE", "README.textile", "notes.textile", "init.rb", "lib/locale/root.yml", "test/data/locale/all.yml", "test/data/locale/de-DE.yml", "test/data/locale/en-US/module.yml", "test/data/locale/en-US.yml", "test/data/locale/fi-FI/module.yml", "test/data/locale/root.yml"]
  s.homepage = %q{http://github.com/joshmh/globalize2}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{The second incarnation of Globalize for Rails}
  s.test_files = ["test/backends/chained_test.rb", "test/backends/pluralizing_test.rb", "test/backends/static_test.rb", "test/data/no_globalize_schema.rb", "test/data/post.rb", "test/data/schema.rb", "test/i18n/missing_translations_test.rb", "test/load_path_test.rb", "test/locale/fallbacks_test.rb", "test/locale/language_tag_test.rb", "test/model/active_record/migration_test.rb", "test/model/active_record/sti_translated_test.rb", "test/model/active_record/translated_test.rb", "test/test_helper.rb", "test/translation_test.rb", "test/data/locale/all.yml", "test/data/locale/de-DE.yml", "test/data/locale/en-US/module.yml", "test/data/locale/en-US.yml", "test/data/locale/fi-FI/module.yml", "test/data/locale/root.yml"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
