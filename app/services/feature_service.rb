class FeatureService 
  include HTTParty
  base_uri 'https://earthquake.usgs.gov'
  
  def self.update_data_usgs
    url = "/earthquakes/feed/v1.0/summary/all_month.geojson"
    
    begin
      response = HTTParty.get(base_uri + url)

      if response.success?
        seismological_data = []

        last_record_date = Feature.maximum(:created_at)

        if last_record_date.nil?
          seismological_data = JSON.parse(response.body)["features"].reverse
        else
          last_record_date = last_record_date.to_i * 1000
          seismological_data = JSON.parse(response.body)["features"].select { |feature| feature["properties"]["time"] > last_record_date }
          seismological_data = seismological_data.reverse
        end

        seismological_data.each do |event|
          # Validaciones de la data
          next unless event["id"] && event["properties"]["title"] &&
                      event  ["properties"]["url"] &&
                      event["properties"]["place"] && 
                      event["properties"]["magType"] &&
                      event["geometry"]["coordinates"].length >= 2 &&
                      event["properties"]["mag"].between?(-1.0, 10.0) &&
                      event["geometry"]["coordinates"][1].between?(-90.0, 90.0) &&
                      event["geometry"]["coordinates"][0].between?(-180.0, 180.0)

          # Verificar existencia
          unless Feature.exists?(Feat_ExternalId: event["properties"]["url"]) && Feature.exists?(Feat_ExternalId: event["id"])
            # Persistencia
            Feature.create!(
              Feat_Title: event["properties"]["title"],
              Feat_ExternalId: event["id"],
              Feat_ExternalUrl: event["properties"]["url"],
              Feat_Place: event["properties"]["place"],
              Feat_MagType: event["properties"]["magType"],
              Feat_Mag: event["properties"]["mag"],
              Feat_Tsunami: event["properties"]["tsunami"],
              Feat_Longitude: event["geometry"]["coordinates"][0],
              Feat_Latitude: event["geometry"]["coordinates"][1],
              Feat_Time: Time.at(event["properties"]["time"] / 1000)
            )
          end
        end
      else
        Rails.logger.error "Error al obtener datos sismológicos: #{response.code}"
        return nil
      end
      
    rescue StandardError => e
      Rails.logger.error "Error de conexión: #{e.message}"
      return nil
    end
  end


  def self.format_seismic_data(seismic_data, page, elements_per_page, total)
    response = {
      data: [],
      pagination: {
        current_page: nil,
        total: nil,
        per_page: nil 
      }
    }

    formatted_data = seismic_data.map do |element|
      {
        id: element[:id],
        type: "feature",
        attributes: {
          external_id: element[:Feat_ExternalId],
          magnitude: element[:Feat_Mag],
          place: element[:Feat_Place],
          time: element[:Feat_Time],
          tsunami: element[:Feat_Tsunami],
          mag_type: element[:Feat_MagType],
          title: element[:Feat_Title],
          coordinates: {
            longitude: element[:Feat_Longitude],
            latitude: element[:Feat_Latitude],
          }
        },
        links: {
          external_url: element[:Feat_ExternalUrl]
        }
      }
    end

    response[:pagination][:current_page] = page
    response[:pagination][:per_page] = elements_per_page
    response[:pagination][:total] = (total.to_f / elements_per_page).ceil
    response[:data] = formatted_data

    return response
  end
end