class ArduinoController < ApplicationController

  before_action :set_firebase

  def settings
    arduinoId = params[:arduino]
    if arduinoId.nil?
      render status: :not_found
    end
    response = @firebase.get("/sensors_config/#{arduinoId}")
    body_items = []
    response.body.each do |key, value|
      body_items << "#{key}=#{value}"
    end
    body = "&#{body_items.join(',')}&"
    render plain: body
  end

  def status
    sensors = []
    params[:sensors].each do | sensor_param |
      sensor = Sensor.new
      sensor.arduino_id = params[:id]
      sensor.sensor_id = sensor_param[:id]
      sensor.target_temperature = sensor_param[:target_temperature]
      sensor.current_temperature = sensor_param[:current_temperature]
      sensors << sensor
    end
    save_status(sensors)
    render status: :ok
  end

  private
    def save_status(sensors)
      sensors.each do |sensor|
        payload = {
          :id => sensor.sensor_id,
          :arduino => sensor.arduino_id,
          :currentTemperature => sensor.current_temperature,
          :targetTemperature => sensor.target_temperature,
          :updatedAt => Firebase::ServerValue::TIMESTAMP
        }
        base_uri = Rails.application.secrets.FIREBASE_URL

        Rails.logger.debug "url #{base_uri}"
        @firebase = Firebase::Client.new(base_uri)
        firebase_sensor_id = "#{sensor.arduino_id}-#{sensor.sensor_id}"
        @firebase.set("sensors/#{firebase_sensor_id}", payload)
        @firebase.push("sensors_history/#{firebase_sensor_id}", payload)
      end
    end

    def set_firebase
      @firebase = Firebase::Client.new(Rails.application.secrets.FIREBASE_URL)
    end
end