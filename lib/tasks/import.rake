require 'csv'

def progress_bar(i)
  case
  when i % 1000 == 0
    print '.'
  when i % 5000 == 0
    puts 'x'
  end
end

namespace :import do
  desc "Import donors from CSV"
  task :donors => [:environment] do
    ApplicationRecord.connection_pool.with_connection do |conn|
      encoder = PG::TextEncoder::CopyRow.new
      raw = conn.raw_connection

      raw.copy_data "COPY donors(id, name, created_at, updated_at) FROM STDIN", encoder do
        CSV.foreach(Rails.root.join('tmp', 'data', 'donor_units.csv'), col_sep: "\t", liberal_parsing: true).with_index do |row, idx|
          if row[1].to_i == 1429
            raw.put_copy_data [
              row[0],
              row[6],
              Time.current,
              Time.current
            ]

            progress_bar(idx)
          end
        end
      end
    end
  end

  desc "Import donations from CSV"
  task :donations => [:environment] do
    ApplicationRecord.connection_pool.with_connection do |conn|
      encoder = PG::TextEncoder::CopyRow.new
      raw = conn.raw_connection

      raw.copy_data "COPY donations(donor_id, amount, entered_on, created_at, updated_at) FROM STDIN", encoder do
        CSV.foreach(Rails.root.join('tmp', 'data', 'donations.csv'), col_sep: "\t", liberal_parsing: true).with_index do |row, idx|
          if row[1].to_i == 1429
            raw.put_copy_data [
              row[3],
              row[9].to_f,
              row[4],
              Time.current,
              Time.current
            ]

            progress_bar(idx)
          end
        end
      end
    end
  end
end
