# encoding: utf-8
#
# utilities for ruby hashes
#
# Copyright © 2021 Stephan Wenzel <stephan.wenzel@drwpatent.de>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#

class Hash

  ########################################################################################
  #
  # zip_out: puts elements into one zip file with keys as filenames
  #
  # -> hash
  #    zip ->
  #
  # depends on gem 'zip'
  #
  ########################################################################################
  def zip_out(&block)
  
    return nil unless defined?(Zip)
    
    zip_stream = Zip::OutputStream.write_buffer do |zip|
    
     each do |key, obj|
        zip.put_next_entry(key)
        if block_given?
          zip.write(yield obj)
        else
           zip.write(obj)
        end
      end
    end
    
    # important - rewind the steam
    zip_stream.rewind
    
    # read out zip contents
    zip_stream.read
    
  end #def
  
end
