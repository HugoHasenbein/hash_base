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
  # to_html: creates a html table from a rectangular array
  #
  # options: headings: true/false, footer:  true/false
  #
  ########################################################################################
  def to_html(options={}, &block)
  
    options[:table] = options[:table].to_h.merge({:class => options[:table_class]}.compact) # support legacy
    
    t          = dup
          body = t
    head, body = [t.shift, t] if options[:headings]
    foot, body = [t.pop  , t] if options[:footer]
    
    html_tag(:table, options[:table].to_h.compact) do
      [head].compact.table_row_group(options.merge(:row_group => {:type => :thead}, :cell => {:type => :th}), &block) +
        body.compact.table_row_group(options.merge(:row_group => {:type => :tbody}, :cell => {:type => :td}), &block) +
      [foot].compact.table_row_group(options.merge(:row_group => {:type => :tfoot}, :cell => {:type => :td}), &block) 
    end
  end #def
  
  ########################################################################################
  private
  ########################################################################################
  
  def table_row_group(options={}, &block)
    rows =  collect.with_index do |row, row_index|
      row.table_row(row_index, options, &block)
    end.join("")
    rows.present? ? html_tag(options.dig(:row_group, :type) || :tbody, rows) : ""
  end #def
  
  def table_row(row_index, options={}, &block)
    html_tag(:tr, options[:row].to_h.compact) do
      row = collect.with_index do |value, column_index| 
        html_tag(options.dig(:cell, :type) || :td, options[:cell].to_h.except(:type).compact) do
          cell_value = if block_given?
            yield value, column_index, row_index
          else
            style_value(value, options)
          end
        end #html_tag #cell_type
      end.join("") #collect columns
      row
    end #html_tag #tr
  end #def
  
  def style_value(value, options={}, &block)
    case value.class
    when Integer
      value.to_s
    when Numeric
      p = options[:precision] || 2
      sprintf("%.#{p}f",value)
    else
      options[:html_safe] ? value.to_s : CGI::escapeHTML(value.to_s)
    end 
  end #def
  
  def html_tag(type, *content, &block)
    if block_given?
      opts = content.first.to_h.map{|k,v| " #{k}='#{v}'"}.join
      "<#{type}#{opts}>#{yield block}</#{type}>"
    else
      opts = content[1].to_h.map{|k,v| " #{k}='#{v}'"}.join
      "<#{type}#{opts}>#{content.first}</#{type}>"
    end
  end #def
  
end
