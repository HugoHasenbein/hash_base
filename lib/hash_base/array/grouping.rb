# encoding: utf-8
#
# utilities for ruby hashes and ruby arrays
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

class Array

  ########################################################################################
  #
  # group_by_positions: creates a nested hash from an array, like group_by
  #                     but with many positions at a time
  # 
  # -> arbitray number of positions, example 'myarray.group_by_positions(0,1,2,3)'
  #  
  # -> array
  #    nested hash ->
  #
  #    {key0=>{key1=>{key2=>{key3=>[ array remaining array elemnts]}}},
  #     key0=>{key1=>{key2=>{key3=>[ array remaining array elemnts]}}},
  #     …
  #    } ->
  #
  ########################################################################################
  class ArrayNotRectangular < StandardError; end
  
  def group_by_positions( *positions )
  
    ohash = ActiveSupport::OrderedHash.new
    
    each do |subarray|
      
      case subarray
      when Array
        key = subarray.delete_at(positions[0])
      else
        raise ArrayNotRectangular
      end
      
      if ohash.has_key?(key)
        ohash[key] << subarray
      else
        ohash[key]  = [subarray]
      end
    end #each
    
    if positions.length > 1
      positions.map!{|p| p > positions[0] ? p - 1 : p }
      ohash.group_by_positions( *positions.drop(1) ) 
    else
      ohash
    end
    
  end #def
  
  ########################################################################################
  #
  # uses arrays first line with headings to group
  #
  # group_by_headings: creates a nested hash from an array, like group_by
  #                    but with many headings at a time
  #                    REMOVES: first line of array
  # 
  # -> arbitray number of headings, example 'myarray.group_by_headings("name", "place")'
  #  
  # -> array
  #    nested hash ->
  #
  #    {key0=>{key1=>{key2=>{key3=>[ array remaining array elemnts]}}},
  #     key0=>{key1=>{key2=>{key3=>[ array remaining array elemnts]}}},
  #     …
  #    } ->
  ########################################################################################
  
  def group_by_headings(*headings)
    copy       = dup
    header_row = copy.shift
    indices    = headings.map {|h| header_row.find_index(h) }
    copy.group_by_positions(*indices)
  end
  
end
