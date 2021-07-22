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
  # converts array of hashes to one hash with elements in array
  #
  ########################################################################################
  class ArrayRowIsNotAHash  < StandardError; end
  
  def to_list
    # test, if each element is a hash
    each do |hash|
      raise ArrayRowIsNotAHash unless hash.is_a?(Hash)
    end
    # extract all keys from all hashes
    keys = map do |hash|
      hash.keys
    end.flatten.uniq
    # now extract value for each key in each hash
    map do |hash|
      keys.map do |key|
        hash[key]
      end
    end.unshift(keys)
  end #def
  
end
