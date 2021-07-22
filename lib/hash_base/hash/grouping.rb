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

class Hash

  ########################################################################################
  #
  # group_by_positions: counter part to Array.group_by_positions
  # 
  # will only be invoked by Array.group_by_positions
  #
  ########################################################################################
  def group_by_positions( *positions )
    ohash = ActiveSupport::OrderedHash.new
    each do |key, val|
      case val
      when Hash, Array
        ohash[key] = val.group_by_positions( *positions )
      else
        ohash[key] = val
      end
    end #each
    ohash
  end #def
  
  ########################################################################################
  #
  # expand: reverse of group_by_positions
  # 
  # -> nested_hash 
  #          -> array
  #
  ########################################################################################
  def expand(path_to_here=[])
    arry     = []
    each do |k, v|
      if v.is_a?(Hash)
        arry += v.expand(path_to_here + [k])
      elsif v.is_a?(Array)
        v.each do |el|
          arry << (path_to_here + [k] +  el  ) if     el.is_a?(Array)
          arry << (path_to_here + [k] + [el] ) unless el.is_a?(Array)
        end
      else
        arry << (path_to_here + [k] + [v])
      end
    end
    arry
  end #def
  
end
