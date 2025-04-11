# frozen_string_literal: true

require 'spec_helper'

describe CXML::ItemDetail do
  it { should respond_to :description }
  it { should respond_to :unit_of_measure }
  it { should respond_to :unit_price }

  let(:data) { CXML::Parser.new(data: fixture('punch_out_order_message_doc.xml')).parse }
  let(:doc) { CXML::Document.new(data) }
  let(:punch_out_order_message) { doc.message.punch_out_order_message }

  describe '#initialize' do
    let(:item_in) { CXML::ItemIn.new(build_item_in) }
    let(:item_detail) { item_in.item_detail }

    it 'sets the mandatory attributes' do
      item_detail.unit_of_measure.should_not be_nil
      item_detail.description.should_not be_nil
      item_detail.unit_price.should_not be_nil
    end

    it 'can add extrinsics' do
      item_detail.set_extrinsic("test", "test value")
      item_detail.extrinsics.should_not be_nil
      item_detail.extrinsics.first.name.should eq("test")
    end

    it 'can change extrinsic value' do
      item_detail.set_extrinsic('test', 'test value')
      item_detail.set_extrinsic('test', 'test value 2')
      item_detail.extrinsics.size.should eq(1)
      item_detail.extrinsics.first.name.should eq("test")
      item_detail.extrinsics.first.content.should eq("test value 2")
    end
  end

  describe '#render' do
    before(:each) do
      punch_out_order_message.add_item(build_item_in)
    end

    let(:output_xml) { doc.to_xml }
    let(:output_data) { CXML::Parser.new(data: output_xml).parse }
    let(:punch_out_order_message_output_data) { output_data[:message][:punch_out_order_message] }
    let(:item_in_output_data) { punch_out_order_message_output_data[:item_in] }
    let(:item_detail_output_data) { item_in_output_data[:item_detail] }

    it 'contains the required nodes' do
      item_detail_output_data[:unit_of_measure].should_not be_empty
      item_detail_output_data[:unit_price].should_not be_empty
      item_detail_output_data[:description].should_not be_empty
    end
  end
end
