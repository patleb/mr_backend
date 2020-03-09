class EnableBtreeGist < ActiveRecord::Migration[6.0]
  def change
    # https://eprints.hsr.ch/672/1/Masterarbeit_pkoster_2018.pdf
    enable_extension 'btree_gist'
  end
end
