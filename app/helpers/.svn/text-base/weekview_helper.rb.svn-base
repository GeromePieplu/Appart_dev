require 'date'

module WeekviewHelper
  
  def week_view(reservations)
    #t = Time.now
    #weeknum = t.strftime("%U").to_i + 1
    weektable = "<table>"
    i=0
    for reservation in reservations
      while i < reservation.date_debut.strftime("%U").to_i
        if i%10 == 0
          if i != 0
            weektable<<"</tr>"
          end
          weektable<<"<tr>"
        end
        weektable<<"<td>"+(i+1).to_s+"</td>"
          i=i+1
        end
        for sem in reservation.date_debut.strftime("%U").to_i..reservation.date_fin.strftime("%U").to_i
          if sem%10 == 0
          if sem != 0
            weektable<<"</tr>"
          end
          weektable<<"<tr>"
        end
        weektable<<"<td>"+(sem+1).to_s+"*</td>"
          end
          i=reservation.date_fin.strftime("%U").to_i+1
        end
        for j in i..51
          if j%10 == 0
          if j != 0
            weektable<<"</tr>"
          end
          weektable<<"<tr>"
      end
          weektable<<"<td>"+(j+1).to_s+"</td>"
    end
     weektable<< "</table>"
    return weektable
  end
end
