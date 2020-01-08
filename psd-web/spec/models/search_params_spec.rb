require "rails_helper"

RSpec.describe SearchParams do
  describe "#attributes" do
    describe "#status_open" do
      it { expect(subject.status_open).to eq("checked") }
    end

    describe "#sort_by" do
      it { expect(subject.sort_by).to eq("recent") }
    end

    describe "#assigned_to_me" do
      it { expect(subject.assigned_to_me).to eq("unchecked") }
    end

    describe "#assigned_to_someone_else" do
      it { expect(subject.assigned_to_someone_else).to eq("unchecked") }
    end

    describe "#created_by_me" do
      it { expect(subject.created_by_me).to eq("unchecked") }
    end

    describe "#created_by_someone_else" do
      it { expect(subject.created_by_someone_else).to eq("unchecked") }
    end

    describe "#enquiry" do
      it { expect(subject.enquiry).to eq("unchecked") }
    end

    describe "#allegation" do
      it { expect(subject.allegation).to eq("unchecked") }
    end

    describe "#project" do
      it { expect(subject.project).to eq("unchecked") }
    end

    describe "#status_closed" do
      it { expect(subject.status_closed).to be nil }
    end

    describe "#sort" do
      it { expect(subject.sort).to be nil }
    end

    describe "#direction" do
      it { expect(subject.direction).to be nil }
    end
  end
end
