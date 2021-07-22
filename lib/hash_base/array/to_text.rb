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
  # creates a table from a rectangular array, balanced with indent
  #
  #  indent:              (Integer) number of spaces for padding each table element
  #  precision            (Integer) number of precision digits to print for floats
  #  padding              (String)  string between adjacing colums
  ########################################################################################
  def to_text(indent: 15, precision: 2, padding: " | " )
    map do |line| 
      ln = line.is_a?(Array) : line : [line]
      ln.map do |e| 
        case e 
        when Integer
          e.to_s.rjust(indent)
        when Complex, Rational
          e.to_s.rjust(indent)
        when Numeric
          sprintf("%.#{precision}f",e).rjust(indent)
        else
          e.to_s.ljust(indent)
        end
      end.join(padding)
    end.join("\n")
  end #def 
  
end
