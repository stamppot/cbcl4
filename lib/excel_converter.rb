require 'writeexcel'

class ExcelConverter

	def write_file(csv_table, filename)
		filename += ".xls" unless filename.include? ".xls"
		workbook  = WriteExcel.new(filename)
		worksheet = workbook.add_worksheet

		# all rows contain headers
		headings = csv_table.first.map &:first
		num_columns = headings.size
		num_rows = csv_table.size

		format = workbook.add_format
		format.set_bold

		headings.each_with_index { |header, i| worksheet.write(0, i, header, format) }
		
		worksheet.set_column(0, num_columns, 18)

	  csv_table.each_with_index do |rows, row_num|
	  	rows.each_with_index do |cell, col_num|
	  	  worksheet.write(row_num+1, col_num, cell.last)
			end
	  end
		workbook.close
	end

end