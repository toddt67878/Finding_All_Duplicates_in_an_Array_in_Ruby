require 'rspec'
require 'date'

class Array
  def find_duplicates
    select.with_index do |e, i|
      i
      self.index(e)
      i != self.index(e)
    end
  end

  def slow_find_duplicates
    group_by { |e| e }.
      each_with_object([]) do |i, arr|
        arr << i.last.drop(1)
      end.flatten
  end
end

ints = [1, 2, 1, 4, 2, 1]
ints.slow_find_duplicates
ints.find_duplicates

describe 'find_duplicates' do
  it 'returns duplicates from an integer based array' do
    ints = [1, 2, 1, 4]
    expect(ints.find_duplicates).to eq([1])
  end

  it 'returns all duplicates of an array of hashes, including when multiple duplicates are found' do
    invoices = [
      { company: 'Google', amount: 500, date: Date.new(2017, 01, 01).to_s, employee: 'Jon Snow' },
      { company: 'Yahoo',  amount: 500, date: Date.new(2017, 01, 01).to_s, employee: 'Jon Snow' },
      { company: 'Google', amount: 500, date: Date.new(2015, 07, 31).to_s, employee: 'Jon Snow' },
      { company: 'Google', amount: 500, date: Date.new(2017, 01, 01).to_s, employee: 'Jon Snow' },
      { company: 'Google', amount: 500, date: Date.new(2017, 01, 01).to_s, employee: 'Jon Snow' },
      { company: 'Google', amount: 500, date: Date.new(2017, 01, 01).to_s, employee: 'Jon Snow', notes: 'Some notes' },
      { company: 'Google', amount: 500, date: Date.new(2017, 01, 01).to_s, employee: 'Jon Snow', notes: 'Some notes' },
    ]

    expect(invoices.find_duplicates).to eq([
      {:company=>"Google", :amount=>500, :date=>'2017-01-01', :employee=>"Jon Snow"},
      {:company=>"Google", :amount=>500, :date=>'2017-01-01', :employee=>"Jon Snow"},
      {:company=>"Google", :amount=>500, :date=>'2017-01-01', :employee=>"Jon Snow", :notes=>"Some notes"}
    ])
  end
end
