# == Schema Information
#
# Table name: devices
#
#  id         :integer          not null, primary key
#  uuid       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Device < ApplicationRecord
  validates :uuid, presence: true
  validates :uuid, uniqueness: true

  def self.fetch_devices
    response = ttn_connection('devices')
    data = JSON.parse(response.body)
    data.each do |uuid|
      unless Device.exists?(uuid: uuid)
        Device.create(uuid: uuid)
      end
    end
  end

  def random_numbers(time = '1h')
    response = self.class.ttn_connection("query?last=#{time}")
    JSON.parse(response.body).collect{|t| [t['time'], t['value']]}
  end

  def self.ttn_connection(url)
    uri = URI.parse(ENV['BASE_URL'] + url)
    request = Net::HTTP::Get.new(uri)
    request['Accept'] = 'application/json'
    request['Authorization'] = "key #{ENV['TTN_KEY']}"
    options = {
      use_ssl: uri.scheme == 'https',
    }
    response = Net::HTTP.start(uri.hostname, uri.port, options) do |http|
      http.request(request)
    end
    response
  end

end
