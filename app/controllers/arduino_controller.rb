class ArduinoController < ApplicationController

  def status

    sensors = []

    sensor1 = Sensor.new
    sensor1.arduino_id = params[:id]
    sensor1.sensor_id = params[:sensor_01_id]
    sensor1.target_temperature = params[:sensor_01_target_temperature]
    sensor1.current_temperature = params[:sensor_01_current_temperature]
    sensors << sensor1

    sensor2 = Sensor.new
    sensor2.arduino_id = params[:id]
    sensor2.sensor_id = params[:sensor_02_id]
    sensor2.target_temperature = params[:sensor_02_target_temperature]
    sensor2.current_temperature = params[:sensor_02_current_temperature]
    sensors << sensor2

    sensors.each do | sensor |
      payload = {
        :id => sensor.sensor_id,
        :arduino => sensor.arduino_id,
        :currentTemperature => sensor.current_temperature,
        :targetTemperature => sensor.target_temperature,
        :updatedAt => Firebase::ServerValue::TIMESTAMP
      }
      base_uri = Rails.application.secrets.FIREBASE_URL

      firebase = Firebase::Client.new(base_uri)
      response = firebase.set("sensors/#{sensor.sensor_id}", payload)
    end

    Sensor.transaction do
      sensors.each(&:save)
    end

    render status: :ok
  end
end