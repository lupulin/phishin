namespace :tags do

  desc "Find and destroy orphan TrackTags"
  task :destroy_orphan_track_tags => :environment do
    num_orphans = 0
    TrackTag.all.each do |track_tag|
      unless track = Track.where(id: track_tag.track_id).first
        num_orphans += 1
        track_tag.destroy
      end
    end
    puts "Total orphaned TrackTags destroyed: #{num_orphans}"
  end

  desc "Find and destroy orphan ShowTags"
  task :destroy_orphan_show_tags => :environment do
    num_orphans = 0
    ShowTag.all.each do |show_tag|
      unless track = Track.where(id: show_tag.show_id).first
        num_orphans += 1
        show_tag.destroy
      end
    end
    puts "Total orphaned ShowTags destroyed: #{num_orphans}"
  end

  desc "Sync SBD tags on shows and tracks"
  task :sync_sbd => :environment do
    dates = {
      '1983-12-02' => '',
      '1984-12-01' => '',
      '1985-03-04' => '',
      '1985-05-03' => '',
      '1985-10-17' => '',
      '1985-10-30' => '',
      # '1985-11-19' => '',
      '1985-11-23' => '',
      '1986-04-15' => '',
      '1986-10-15' => '',
      '1986-10-31' => '',
      '1986-12-06' => '',
      '1987-03-06' => '',
      '1987-03-23' => '',
      '1987-04-29' => '',
      '1987-08-29' => '',
      '1987-09-02' => '',
      '1987-10-14' => '',
      '1987-11-19' => '',

      '1988-01-27' => '',
      '1988-02-08' => { sets: ['1', '2'] },
      '1988-02-26' => '',
      '1988-03-12' => '',
      '1988-05-14' => '',
      '1988-05-15' => '',
      '1988-05-23' => '',
      '1988-05-24' => '',
      '1988-06-15' => '',
      '1988-06-19' => '',
      '1988-06-21' => '',
      '1988-07-11' => '',
      '1988-07-12' => '',
      '1988-07-23' => '',
      '1988-07-24' => '',
      '1988-07-25' => '',
      '1988-07-29' => '',
      '1988-07-30' => '',
      '1988-08-03' => '',
      '1988-08-13' => '',
      '1988-08-27' => '',
      '1988-09-08' => '',
      '1988-09-13' => '',
      '1988-09-24' => '',
      '1988-10-29' => '',
      '1988-11-03' => '',
      '1988-11-05' => '',
      '1988-11-11' => '',
      '1988-12-10' => '',
      '1988-12-17' => '',

      '1989-01-26' => '',
      '1989-02-06' => '',
      '1989-02-07' => '',
      '1989-02-24' => '',
      '1989-03-12' => '',
      '1989-03-14' => '',
      '1989-03-30' => '',
      '1989-04-14' => '',
      '1989-04-20' => '',
      '1989-05-05' => '',
      '1989-05-09' => '',
      '1989-05-09' => '',
      '1989-05-20' => '',
      '1989-05-21' => '',
      '1989-05-26' => '',
      '1989-05-27' => '',
      '1989-05-28' => '',
      '1989-06-10' => '',
      '1989-06-23' => '',
      '1989-06-29' => '',
      '1989-06-30' => '',
      '1989-08-17' => '',
      '1989-08-19' => '',
      '1989-08-26' => '',
      '1989-09-09' => '',
      '1989-09-21' => '',
      '1989-10-01' => '',
      '1989-10-07' => '',
      '1989-10-10' => '',
      '1989-10-13' => '',
      '1989-10-20' => '',
      '1989-10-21' => '',
      '1989-10-22' => '',
      '1989-10-26' => '',
      '1989-10-26' => '',
      '1989-10-31' => '',
      '1989-11-03' => '',
      '1989-11-03' => '',
      '1989-11-09' => '',
      '1989-11-10' => '',
      '1989-11-11' => '',
      '1989-11-16' => '',
      '1989-11-30' => '',
      '1989-12-01' => '',
      '1989-12-03' => '',
      '1989-12-08' => '',
      '1989-12-09' => '',
      '1989-12-15' => '',
      '1989-12-29' => '',
      '1989-12-30' => '',

      '1990-01-26' => '',  
      '1990-01-27' => '',  
      '1990-01-28' => '',  
      '1990-02-05' => '',
      '1990-02-09' => '',
      '1990-02-15' => '',
      '1990-02-16' => '',
      '1990-02-17' => '',
      '1990-02-22' => '',
      '1990-02-23' => '',
      '1990-02-24' => '',
      '1990-03-01' => '',
      '1990-03-03' => '',
      '1990-03-07' => '',
      '1990-03-08' => '',
      '1990-03-09' => '',
      '1990-03-10' => '',
      '1990-03-11' => '',
      '1990-03-17' => '',
      '1990-03-28' => '',
      '1990-04-04' => '',
      '1990-04-05' => '',
      '1990-04-06' => '',
      '1990-04-07' => '',
      '1990-04-09' => '',
      '1990-04-18' => '',
      '1990-04-20' => '',
      '1990-04-21' => '',
      '1990-04-22' => '',
      '1990-04-25' => '',
      '1990-04-26' => '',
      '1990-05-04' => '',
      '1990-05-06' => '',
      '1990-05-10' => '',
      '1990-05-13' => '',
      '1990-05-19' => '',
      '1990-05-23' => '',
      '1990-05-24' => '',
      '1990-06-05' => '',
      '1990-06-08' => '',
      '1990-06-09' => '',
      '1990-06-17' => '',
      '1990-09-13' => '',
      '1990-09-13' => '',
      '1990-09-29' => '',
      '1990-10-04' => '',
      '1990-10-06' => '',
      '1990-10-07' => '',
      '1990-10-07' => '',
      '1990-10-31' => '',
      '1990-11-02' => '',
      '1990-11-04' => '',
      '1990-11-08' => '',
      '1990-11-10' => '',
      '1990-11-16' => '',
      '1990-11-24' => '',
      '1990-12-28' => '',
      '1990-12-29' => { sets: ['1'] },

      '1991-02-01' => '',
      '1991-02-07' => '',
      '1991-02-08' => '',
      '1991-02-21' => '',
      '1991-03-01' => '',
      '1991-03-13' => '',
      '1991-03-16' => '',
      '1991-03-16' => '',
      '1991-03-17' => '',
      '1991-03-22' => '',
      '1991-03-23' => '',
      '1991-04-04' => '',
      '1991-04-05' => '',
      '1991-04-06' => '',
      '1991-04-11' => '',
      '1991-04-12' => '',
      '1991-04-15' => '',
      '1991-04-16' => '',
      '1991-04-21' => '',
      '1991-04-27' => '',
      '1991-05-03' => '',
      '1991-05-10' => { except_track_ids: [9379] },
      '1991-05-11' => { sets: ['2', 'E'] },
      '1991-07-11' => '',
      '1991-07-14' => '',
      '1991-07-15' => '',
      '1991-07-19' => { sets: ['1'] },
      '1991-07-21' => '',
      '1991-07-23' => '',
      '1991-07-25' => '',
      '1991-10-04' => '',
      '1991-10-06' => '',
      '1991-10-10' => '',
      '1991-10-11' => '',
      '1991-10-12' => '',
      '1991-10-13' => '',
      '1991-10-18' => '',
      '1991-10-19' => '',
      '1991-10-24' => '',
      '1991-10-28' => '',
      '1991-11-01' => '',
      '1991-11-02' => '',
      '1991-11-21' => { sets: ['1'] },
      '1991-11-30' => '',
      '1991-12-05' => '',
      '1991-12-06' => '',
      '1991-12-07' => '',
      '1991-12-31' => '',

      '1992-03-06' => '',
      '1992-03-07' => { sets: ['2', 'E'] },
      '1992-03-13' => '',
      '1992-03-14' => '',
      '1992-03-17' => '',
      '1992-03-20' => '',
      '1992-03-22' => '',
      '1992-03-25' => '',
      '1992-04-03' => '',
      '1992-04-06' => '',
      '1992-04-07' => { sets: ['1'] },
      '1992-04-12' => '',
      '1992-04-13' => '',
      '1992-04-15' => '',
      '1992-04-16' => '',
      '1992-04-17' => '',
      '1992-04-18' => '',
      '1992-04-21' => '',
      '1992-04-22' => '',
      '1992-04-24' => '',
      '1992-04-25' => '',
      '1992-04-29' => { sets: ['2', 'E'] },
      '1992-04-30' => { sets: ['1'] },
      '1992-05-01' => { sets: ['1'] },
      '1992-05-06' => { sets: ['1'] },
      '1992-05-09' => { sets: ['2', 'E'] },
      '1992-05-12' => { sets: ['2', 'E'] },
      '1992-05-14' => '',
      '1992-05-16' => '',
      '1992-05-18' => '',
      '1992-06-19' => '',
      '1992-06-20' => '',
      '1992-06-23' => '',
      '1992-06-24' => '',
      '1992-07-11' => '',
      '1992-07-21' => '',
      '1992-07-23' => '',
      '1992-07-24' => '',
      '1992-07-25' => '',
      '1992-08-13' => '',
      '1992-08-14' => '',
      '1992-08-15' => '',
      '1992-08-17' => '',
      '1992-08-29' => '',
      '1992-08-29' => '',
      '1992-11-19' => '',
      '1992-11-20' => '',
      '1992-12-05' => '',
      '1992-12-12' => '',
      '1992-12-29' => '',
      '1992-12-30' => '',

      '1993-02-18' => '',
      '1993-02-20' => '',
      '1993-02-27' => '',
      '1993-03-09' => '',
      '1993-03-12' => { except_track_ids: [5815] },
      '1993-03-14' => { sets: ['2', 'E'] },
      '1993-03-22' => '',
      '1993-03-28' => '',
      '1993-04-09' => '',
      '1993-04-10' => '',
      '1993-04-12' => '',
      '1993-04-17' => '',
      '1993-04-18' => '',
      '1993-04-23' => '',
      '1993-04-23' => '',
      '1993-05-01' => '',
      '1993-05-02' => '',
      '1993-05-03' => { sets: ['2', 'E'] },
      '1993-05-05' => '',
      '1993-05-06' => '',
      '1993-05-30' => '',
      '1993-07-16' => { sets: ['2', 'E'] },
      '1993-07-23' => '',
      '1993-07-25' => '',
      '1993-08-06' => { sets: ['2', 'E'] },
      '1993-08-20' => '',
      '1993-08-24' => '',
      '1993-08-28' => '',
      '1993-12-31' => '',

      '1994-04-04' => { sets: ['2', 'E'] },
      '1994-04-09' => { sets: ['2', 'E'] },
      '1994-04-13' => '',
      '1994-04-17' => '',
      '1994-04-25' => '',
      '1994-04-26' => '',
      '1994-04-30' => { sets: ['2', 'E'] },
      '1994-05-03' => { sets: ['2', 'E'] },
      '1994-05-07' => '',
      '1994-05-14' => '',
      '1994-05-22' => '',
      '1994-05-27' => { except_track_ids: [3498, 3499, 3483, 3484, 3485, 3486, 3487, 3488, 3489, 3490, 3491] },
      '1994-05-28' => { except_track_ids: [3522, 3523] },
      '1994-05-29' => { sets: ['2', 'E'] },
      '1994-06-09' => { sets: ['2', 'E'] },
      '1994-06-11' => '',
      '1994-06-14' => { sets: ['2', 'E'] },
      '1994-06-16' => '',
      '1994-06-17' => { sets: ['2', 'E'] },
      '1994-06-18' => '',
      '1994-06-22' => '',
      '1994-07-08' => { sets: ['2', 'E'] },
      '1994-07-08' => { sets: ['2', 'E'] },
      '1994-10-18' => '',
      '1994-10-29' => '',
      '1994-11-02' => { sets: ['2', 'E'] },
      '1994-11-13' => { sets: ['2', 'E'] },
      '1994-12-30' => '',

      '1995-06-25' => '',
      '1995-07-01' => '',

      '1996-06-06' => '',
      '1996-07-11' => '',
      '1996-08-16' => '',
      '1996-08-17' => '',
      '1996-12-04' => '',
      '1996-12-31' => '',

      '1997-02-16' => '',
      '1997-02-26' => '',
      '1997-03-01' => { except_track_ids: [16907, 16918] },
      '1997-03-05' => '',
      '1997-06-22' => '',
      '1997-08-16' => '',
      '1997-08-17' => '',
      '1997-11-28' => '',
      '1997-12-11' => '',

      '1998-07-05' => { sets: ['2', 'E'] },
      '1998-07-08' => { except_track_ids: [26353..26362] },
      '1998-07-24' => '',
      '1998-07-24' => '',
      '1998-08-08' => '',
      '1998-08-14' => '',
      '1998-08-16' => { except_track_ids: [18479, 18480] },
      '1998-10-20' => '',
      '1998-10-27' => '',
      '1998-11-03' => '',

      '1999-07-30' => '',
      '1999-07-31' => '',
      '1999-08-01' => '',

      '2000-05-15' => '',
      '2000-05-18' => '',
      '2000-05-19' => '',
      '2000-05-23' => '',
      '2000-07-17' => '',

      '2002-12-14' => '',
      '2002-12-19' => '',

      '2009-10-29' => '',

      '2010-03-15' => '',

      '2011-05-26' => '',
      '2011-06-30' => ''
    }
    ShowTag.all.map(&:destroy)
    TrackTag.all.map(&:destroy)

    sbd_tag = Tag.where(name: 'SBD').first

    dates.each do |date, data|
      unless show = Show.where(date: date).first
        raise "Show not found! #{date}"
      else
        tracks = Track.where(show_id: show.id)
        if data.kind_of? Hash
          data.each do |k,v|
            if k == :sets
              tracks = tracks.where(set: v).all
            elsif k == :except_track_ids
              tracks.all.reject! {|track| v.include?(track.id) }
            end
          end
        end
        unless tracks
          raise "Tracks not found for show! #{date}"
        else
          show.tags << sbd_tag
          tracks.each {|track| track.tags << sbd_tag }
          puts "SBD added to #{date}"
        end
      end
    end
  end


end