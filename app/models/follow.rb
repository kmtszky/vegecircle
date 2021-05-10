class Follow < ApplicationRecord
  belongs_to :customer
  belongs_to :farmer
end
