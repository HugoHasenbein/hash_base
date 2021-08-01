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
  # deep_values: gets an array of values of a nested hash as a flat array
  #
  # -> hash
  #    array ->
  #
  ########################################################################################
  def deep_values
    arr = Array.new
    each do |key, value|
      if  value.is_a?(Hash)
        arr += value.deep_values
      else
        arr << value
      end
    end #each
    arr
  end #def
  
  
  ########################################################################################
  #
  # max_depth: gets max depth of a hash
  #
  # -> hash
  #    int ->
  #
  ########################################################################################
  def max_depth(depth: 1)
    max_depth = depth
    each do |k,v|
      if v.is_a?(Hash)
        max_depth = [max_depth, v.max_depth( depth: depth + 1 )].max
      end
    end
    max_depth
  end #def
  
  ########################################################################################
  #
  # deep_diff: compares two hashes - counter part to Array.deep_diff
  #            source: stackoverflow
  #
  ########################################################################################
  def deep_diff(other, &block)
    (self.keys + other.keys).uniq.inject({}) do |memo, key|
      left = self[key]
      right = other[key] 
      
      if block_given?
        next memo if yield left, right 
      else
        next memo if left == right 
      end
      if left.respond_to?(:deep_diff) && right.respond_to?(:deep_diff)
        memo[key] = left.deep_diff(right)
      else
        memo[key] = [left, right]
      end
      
      memo
    end
  end  
  
end
