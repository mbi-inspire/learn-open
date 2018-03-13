require 'spec_helper'

describe LearnOpen::Opener do
  LearnOpen::Opener::HOME_DIR = File.join(__dir__, "..", "home_dir")

  context "Verifying repo existance" do
    let(:opener) { LearnOpen::Opener.new("lab","","", FakeClient) }
    after do
      path = File.join(__dir__, "..", "home_dir", "code")
      FileUtils.rm_rf(path)
    end

    it "returns true if .git directory for lab exists" do
      expect(opener).to receive(:repo_dir).and_return("js-rubber-duck-wrangling")
      FileUtils.mkdir_p("#{opener.lessons_dir}/js-rubber-duck-wrangling/.git")

      expect(opener.repo_exists?).to be_truthy
    end

    it "returns false if directory for lab doesn't exists" do
      expect(opener).to receive(:repo_dir).and_return("js-rubber-duck-wrangling")
      expect(opener.repo_exists?).to be_falsy
    end
  end

  context "Lesson types" do
    it "sets type to readme" do
      opener = LearnOpen::Opener.new("readme", nil, nil, FakeClient)
      expect(opener.lesson).to be_a(LearnOpen::Lessons::Readme)
    end

    it "sets type to readme" do
      opener = LearnOpen::Opener.new("jupyter_lab", nil, nil, FakeClient)
      expect(opener.lesson).to be_a(LearnOpen::Lessons::JupyterLab)
    end
  end
end
