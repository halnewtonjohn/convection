module Types
  SubmissionType = GraphQL::ObjectType.define do
    name 'Submission'
    description 'Consignment Submission'

    field :id, !types.ID, 'Uniq ID for this submission'
    field :additional_info, types.String
    field :user_id, !types.String
    field :artist_id, !types.String
    field :authenticity_certificate, types.Boolean
    field :category, types.String
    field :deadline_to_sell, Types::DateType
    field :depth, types.String
    field :dimensions_metric, types.String
    field :edition, types.String
    field :edition_number, types.String
    field :edition_size, types.Int
    field :height, types.String
    field :location_city, types.String
    field :location_country, types.String
    field :location_state, types.String
    field :medium, types.String
    field :provenance, types.String
    field :signature, types.Boolean
    field :state, types.String
    field :title, types.String
    field :width, types.String
    field :year, types.String

    field :assets, types[Types::AssetType]
  end
end
