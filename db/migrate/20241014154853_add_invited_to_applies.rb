class AddInvitedToApplies < ActiveRecord::Migration[7.2]
  def change
    change_column_default :applies, :invited, false
  end
end
