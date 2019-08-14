require 'yaml'

describe 'foo command' do
  change_set = YAML.load_file('main.yaml')
  context "Run command with main.yaml #{change_set}" do
    it do
      expect { system %(ruby foo.rb main.yaml) }
        .to output(match_regex(/^tf_level = main$/))
        .to_stdout_from_any_process
    end
    it do
      expect { system %(ruby foo.rb main.yaml) }
        .to output(match_regex(%r{^tf_path = terraform$}))
        .to_stdout_from_any_process
    end
  end

  change_set = YAML.load_file('l1.yaml')
  context "Run command with l1.yaml #{change_set}" do
    it do
      expect { system %(ruby foo.rb l1.yaml) }
        .to output(match_regex(/^tf_level = l1$/))
        .to_stdout_from_any_process
    end
    it do
      expect { system %(ruby foo.rb l1.yaml) }
        .to output(match_regex(%r{^tf_path = terraform/levels/1$}))
        .to_stdout_from_any_process
    end
  end

  change_set = YAML.load_file('l3.yaml')
  context "Run command with l3.yaml #{change_set}" do
    it do
      expect { system %(ruby foo.rb l3.yaml) }
        .to output(match_regex(/^tf_level = l3$/))
        .to_stdout_from_any_process
    end
    it do
      expect { system %(ruby foo.rb l3.yaml) }
        .to output(match_regex(%r{^tf_path = terraform/levels/1/2/3$}))
        .to_stdout_from_any_process
    end
  end

  change_set = YAML.load_file('error_no_match.yaml')
  context "Run command with error_no_match.yaml #{change_set}" do
    it do
      expect { system %(ruby foo.rb error_no_match.yaml) }
        .to output(match_regex(/^ERROR: no match$/))
        .to_stdout_from_any_process
    end
  end

  change_set = YAML.load_file('error_multi_match.yaml')
  context "Run command with error_multi_match.yaml #{change_set}" do
    it do
      expect { system %(ruby foo.rb error_multi_match.yaml) }
        .to output(match_regex(/^ERROR: multiple matches$/))
        .to_stdout_from_any_process
    end
  end
end
