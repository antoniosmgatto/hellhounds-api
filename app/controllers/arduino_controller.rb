class ArduinoController < ApplicationController

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
        firebase = Firebase::Client.new(base_uri)
        response = firebase.set("sensors/#{sensor.arduino_id}-#{sensor.sensor_id}", payload)
    end
    end
end