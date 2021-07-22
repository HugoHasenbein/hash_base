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
  # apply(&block): applies block to deepest element, which is not a Hash
  #
  # -> hash
  #    new hash ->
  #
  ########################################################################################
  def apply( &block )
    return to_enum(:each) unless block_given?
    hash = Hash.new
    each do |key, value|
      if  value.is_a?(Hash)
        hash[key] = value.apply( &block ) 
      else
        hash[key] = yield value
      end
    end
    hash
  end #def
  
  ########################################################################################
  #
  # apply!(&block): applies block to deepest element, which is not a Hash
  #
  # -> hash
  #    same hash ->
  #
  ########################################################################################
  def apply!( &block )
    return to_enum(:each) unless block_given?
    each do |key, value|
      if value.is_a?(Hash)
        self[key] = value.apply( &block ) 
      else
        self[key] = yield value
      end
    end
    self
  end #def
  
end
