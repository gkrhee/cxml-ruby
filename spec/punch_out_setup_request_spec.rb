# frozen_string_literal: true

require 'spec_helper'

describe CXML::PunchOutSetupRequest do
  it { should respond_to :browser_form_post }
  it { should respond_to :supplier_setup }
  it { should respond_to :buyer_cookie }
  it { should respond_to :ship_to }
  it { should respond_to :extrinsics }
  it { should respond_to :contact }

  let(:data) { CXML::Parser.new(data: fixture('punch_out_setup_request_doc.xml')).parse }
  let(:data_coupa) { CXML::Parser.new(data: fixture('punch_out_setup_request_doc_coupa.xml')).parse }
  let(:doc) { CXML::Document.new(data) }
  let(:doc_coupa) { CXML::Document.new(data_coupa) }
  let(:request) { doc.request }
  let(:request_coupa) { doc_coupa.request }
  let(:punch_out_setup_request) { request.punch_out_setup_request }
  let(:punch_out_setup_request_coupa) { request_coupa.punch_out_setup_request }

  describe '#initialize' do
    it 'sets the mandatory attributes' do
      punch_out_setup_request.browser_form_post.url.should_not be_nil
      punch_out_setup_request.supplier_setup.url.should_not be_nil
    end
    it 'sets the mandatory coupa attributes' do
      punch_out_setup_request_coupa.browser_form_post.url.should_not be_nil
      punch_out_setup_request_coupa.buyer_cookie.should_not be_nil
      punch_out_setup_request_coupa.contact.email.should_not be_nil
      punch_out_setup_request_coupa.extrinsics.should be_a Array
      punch_out_setup_request_coupa.extrinsics.first.should be_a CXML::Extrinsic
      punch_out_setup_request_coupa.extrinsics.first.name.should_not be_nil
      doc_coupa.header.sender.credential.shared_secret.should eq('test')
    end
    it 'sets the shipping attributes when present' do
      data = CXML::Parser.new(data: fixture('punch_out_setup_request_doc_with_ship_to.xml')).parse
      doc = CXML::Document.new(data)
      doc.request.punch_out_setup_request.ship_to.should_not be_nil
      doc.request.punch_out_setup_request.ship_to.address.name.should_not be_nil
      doc.request.punch_out_setup_request.ship_to.address.phone.should_not be_nil
      doc.request.punch_out_setup_request.ship_to.address.phone.telephone_number.should_not be_nil
    end
  end

  describe '#render' do
    it 'contains the required nodes' do
      data = CXML::Parser.new(data: fixture('punch_out_setup_request_doc_with_ship_to.xml')).parse
      doc = CXML::Document.new(data)
      output_xml = doc.to_xml
      output_data = CXML::Parser.new(data: output_xml).parse
      output_data[:request][:punch_out_setup_request][:buyer_cookie]
        .should eq data[:request][:punch_out_setup_request][:buyer_cookie]
      output_data[:request][:punch_out_setup_request][:browser_form_post]
        .should eq data[:request][:punch_out_setup_request][:browser_form_post]
      output_data[:request][:punch_out_setup_request][:ship_to][:address]
        .keys.sort.should eq data[:request][:punch_out_setup_request][:ship_to][:address].keys.sort
    end
  end
end
