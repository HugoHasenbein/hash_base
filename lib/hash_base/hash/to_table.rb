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
  # to_table: creates a rectangular table from a nested hash
  #
  # -> hash
  #    array ->
  #
  #  parameters
  #
  #  level:               (Integer) only used internally for recursive calls (do not use)
  #  indent:              (Integer) number of spaces for padding each table element
  #  precision            (Integer) number of precision digits for floats
  #  dosort;              (Boolean) should each level of keys be sorted ?
  #  content:             (String) "style" => creates a table of cell styles, else table
  #                                 of data
  #  format:              (String) "text" - text output, balanced with indent parameter 
  #                                "html" - html output
  #  total:               (Proc)   "-> x {x.flatten.inject(:+)}" proc to create totals of 
  #                                 arrays of deepest values
  #  total_caption        (String) caption for total line 
  #  grand_total          (Proc)   "-> x {x.depp_values.flatten.inject(:+)}" proc to 
  #                                create totals of arrays of deepest values
  #  grant_total_caption  (string) caption for grand total line
  #  
  ########################################################################################
  def to_table( level: 0, indent: 15, precision: 2, dosort: true, content: "data", format: nil, divisor: nil, total: nil, total_caption: "", grand_total: nil, grand_total_caption: "" )
    
    arry = []
    i    = 0
    
    h = dosort ? sort : self
    
    h.each do |k, v|
    
      first_line = Array.new( i > 0 ? level : 0) {""} + [k]                                    unless content == "style"
      first_line = Array.new( i > 0 ? level : 0) {|l| "empty level_#{l}"} + ["key level_#{level}"] if content == "style"
      
      if v.is_a?(Hash)
        lines = v.to_table(level: level + 1, content: content, indent: indent, dosort: dosort, divisor: divisor, total: total, total_caption: total_caption, grand_total: grand_total, grand_total_caption: grand_total_caption)
        first_line += lines[0] # complement current line with last key
        arry << first_line
        arry += lines.drop(1) if lines.drop(1).present?
      elsif v.is_a?(Array) #must be array
        lines = []
        v.each_with_index do |av, i|
          elem = (av.is_a?(Array) ? av : [av])
          lines << (Array.new( i > 0 ? level + 1 : 0) {""} + elem )                                                            unless content == "style"
          lines << (Array.new( i > 0 ? level + 1 : 0) {|l| "empty level_#{l}"} + Array.new(elem.length){"value level_#{level}"} )  if content == "style"
        end
        first_line += lines[0] # complement current line
        arry << first_line
        arry += lines.drop(1) if lines.drop(1).present?
        
        max_len = arry.map{|r| r.length}.max
        
        unless content == "style"
          arry << (Array.new( max_len + 1) {divisor.to_s * indent} )                        if total && divisor
          arry << (["#{total_caption}"] + Array.new( max_len - 1) {""} + [total.yield(v)] ) if total
          arry << (Array.new( max_len + 1) {""} )                                           if total && divisor
        else
          arry << (Array.new( max_len + 1) {|l| "divisor level_#{l}"} )                                                        if total && divisor
          arry << (["total_caption level_0"] + Array.new( max_len - 1) {|l| "empty level_#{l+1}"} + ["total level_#{level}"] ) if total
          arry << (Array.new( max_len + 1) {|l| "empty level_#{l}"} )                                                          if total && divisor
        end
      end
      i+=1
    end #each
    
    if level == 0
    
      max_len = arry.map{|r| r.length}.max
      
      unless content == "style"
        arry << (Array.new( max_len + 1 ) {divisor.to_s * indent} )                                             if grand_total && divisor
        arry << (["#{grand_total_caption}"]      + Array.new( max_len - 1 ) {""} + [grand_total.yield(self)] )  if grand_total
      else
        arry << (Array.new( max_len + 1) {"grand_total divisor"} )                                                                   if grand_total && divisor
        arry << (["grand_total_caption level_0"] + Array.new( max_len - 1) {|l| "empty grand_total level_#{l+1}"} + ["grand_total"]) if grand_total
      end
      
      
      max_len = arry.map{|r| r.length}.max
      
      arry.map!{|l| l += Array.new(max_len - l.length) {""} }          unless content == "style"
      arry.map!{|l| l += Array.new(max_len - l.length) {"empty padding"} } if content == "style"
      
      if format == "text"
        arry.to_text(indent: indent, precision: precision)
      elsif format == "html"
        arry.to_html( styles: self.to_table(content: "style", total: true, grand_total: true))
      else
        arry
      end
    else
      arry
    end
    
  end #def
  
end
