require 'net/http'

require_relative '../../../../config/initializers/constants'

class Api::Calculator::CarbonCalculatorController < ApplicationController
  include Constants
  def calculate
    ip_address = request.remote_ip

    numerical_body_type = BODY_TYPE[calculate_params[:body_type].to_sym] if calculate_params[:body_type]
    numerical_sex = SEX[calculate_params[:sex].to_sym] if calculate_params[:sex]
    numerical_diet = DIET[calculate_params[:diet].to_sym] if calculate_params[:diet]
    numerical_how_often_shower = HOW_OFTEN_SHOWER[calculate_params[:how_often_shower].to_sym] if calculate_params[:how_often_shower]
    numerical_heating_energy_source = HEATING_ENERGY_SOURCE[calculate_params[:heating_energy_source].to_sym] if calculate_params[:heating_energy_source]
    numerical_transport = TRANSPORT[calculate_params[:transport].to_sym] if calculate_params[:transport]
    numerical_vehicle_type = VEHICLE_TYPE[calculate_params[:vehicle_type].to_sym] if calculate_params[:vehicle_type]
    numerical_social_activity = SOCIAL_ACTIVITY[calculate_params[:social_activity].to_sym] if calculate_params[:social_activity]
    numerical_frequency_of_travel_by_air = FREQUENCY_OF_TRAVEL_BY_AIR[calculate_params[:frequency_of_travel_by_air].to_sym] if calculate_params[:frequency_of_travel_by_air]
    numerical_waste_bag_size = WASTE_BAG_SIZE[calculate_params[:waste_bag_size].to_sym] if calculate_params[:waste_bag_size]
    numerical_energy_efficiency = ENERGY_EFFICIENCY[calculate_params[:energy_efficiency].to_sym] if calculate_params[:energy_efficiency]
    numerical_recycling = RECYCLING.find { |key, _| Set.new(eval(key)).eql?(Set.new(calculate_params[:recycling])) }&.last
    numerical_cooking_with = COOKING_WITH.find { |key, _| Set.new(eval(key)).eql?(Set.new(calculate_params[:cooking_with])) }&.last

    uri = URI('http://127.0.0.1:5000/predict')
    headers = { 'Content-Type': 'application/json' }

    data = {
      "Body Type": numerical_body_type,
      "Sex": numerical_sex,
      "Diet": numerical_diet,
      "How Often Shower": numerical_how_often_shower,
      "Heating Energy Source": numerical_heating_energy_source,
      "Transport": numerical_transport,
      "Vehicle Type": numerical_vehicle_type,
      "Social Activity": numerical_social_activity,
      "Monthly Grocery Bill": calculate_params[:monthly_grocery_bill],
      "Frequency of Traveling by Air": numerical_frequency_of_travel_by_air,
      "Vehicle Monthly Distance Km": calculate_params[:vehicle_monthly_distance],
      "Waste Bag Size": numerical_waste_bag_size,
      "Waste Bag Weekly Count": calculate_params[:waste_bag_count],
      "How Long TV PC Daily Hour": calculate_params[:tv_pc_daily_hour],
      "How Many New Clothes Monthly": calculate_params[:new_cloths_monthly],
      "How Long Internet Daily Hour": calculate_params[:internet_daily_hours],
      "Energy efficiency": numerical_energy_efficiency,
      "Recycling": numerical_recycling,
      "Cooking_With": numerical_cooking_with
    }

    json_data = data.to_json

    response = Net::HTTP.post(uri, json_data, headers)

    if response.is_a?(Net::HTTPSuccess)
      response_body = JSON.parse(response.body)
      carbon_footprint = response_body['prediction'] / 1000
      temporary_user = TemporaryUser.create(:ipAddress => ip_address, :carbonEmission => carbon_footprint)

      render json: {
        status: 'SUCCESS',
        message: 'Your carbon footprint is ' + carbon_footprint.to_s,
        data: {
          footprint: carbon_footprint,
          user_id: temporary_user.id
        }
      }
    else
      render json: {
        status: 'ERROR',
        message: 'Error on ds endpoint!'
      }
    end
  end

  private

  def calculate_params
    params.permit(:body_type, :sex, :diet, :how_often_shower, :heating_energy_source, :transport, :vehicle_type,
                  :social_activity, :monthly_grocery_bill, :frequency_of_travel_by_air, :vehicle_monthly_distance,
                  :waste_bag_size, :waste_bag_count, :tv_pc_daily_hour, :new_cloths_monthly, :internet_daily_hours,
                  :energy_efficiency, :recycling, :cooking_with)
  end
end
