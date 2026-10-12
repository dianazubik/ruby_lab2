# Лабораторна робота №2. Варіант 18. Блок 3

require 'csv'
require 'tempfile'
require 'fileutils'

# ===== Завдання 5: підсумок продажів з sales.csv у summary.csv =====
puts "=== Завдання 5: sales.csv -> summary.csv ==="

# Вхідний файл для демонстрації
File.write("sales.csv", <<~CSV_DATA)
  Product,Price,Quantity
  Apple,10.5,4
  Banana,7.0,10
  Apple,10.5,6
  Orange,12.0,3
  Banana,7.0,5
CSV_DATA

# Спосіб 1: CSV.foreach (потокове читання) + Hash з накопиченням
totals1 = Hash.new(0)
CSV.foreach("sales.csv", headers: true) do |row|
  totals1[row["Product"]] += row["Price"].to_f * row["Quantity"].to_i
end
totals1 = totals1.transform_values { |v| v.round(2) }
puts "Спосіб 1 (CSV.foreach + Hash):  #{totals1.inspect}"

CSV.open("summary.csv", "w") do |csv|
  csv << ["Product", "Total"]
  totals1.each { |product, total| csv << [product, total] }
end

# Спосіб 2: CSV.read + group_by + sum
rows = CSV.read("sales.csv", headers: true)
totals2 = rows.group_by { |r| r["Product"] }
              .transform_values { |rs| rs.sum { |r| r["Price"].to_f * r["Quantity"].to_i }.round(2) }
puts "Спосіб 2 (CSV.read + group_by): #{totals2.inspect}"

puts "Результати збігаються: #{totals1 == totals2}"
puts "Вміст summary.csv:"
puts File.read("summary.csv")

# ===== Завдання 6: безпечний запис safe_write =====
puts "\n=== Завдання 6: safe_write ==="

# Спосіб 1: Tempfile + File.rename
def safe_write(filepath, content)
  dir = File.dirname(filepath)
  tmp = Tempfile.new([File.basename(filepath), ".tmp"], dir)
  begin
    tmp.write(content)
    tmp.flush
    tmp.fsync
    tmp.close
    File.chmod(0644, tmp.path)
    File.rename(tmp.path, filepath)   # атомарна заміна
  rescue StandardError => e
    tmp.close! rescue nil             # прибираємо тимчасовий файл
    raise e
  end
end

# Спосіб 2: File.write у файл з тимчасовим розширенням + FileUtils.mv
def safe_write_v2(filepath, content)
  tmp_path = "#{filepath}.tmp"
  File.write(tmp_path, content)
  FileUtils.mv(tmp_path, filepath)    # заміна готовим файлом
rescue StandardError => e
  File.delete(tmp_path) if File.exist?(tmp_path)
  raise e
end

safe_write("important.txt", "Перша версія даних\n")
puts "Спосіб 1, перший запис: #{File.read('important.txt').inspect}"
safe_write("important.txt", "Друга версія даних\n")
puts "Спосіб 1, другий запис: #{File.read('important.txt').inspect}"

safe_write_v2("important2.txt", "Перша версія даних\n")
puts "Спосіб 2, перший запис: #{File.read('important2.txt').inspect}"
safe_write_v2("important2.txt", "Друга версія даних\n")
puts "Спосіб 2, другий запис: #{File.read('important2.txt').inspect}"

leftovers = Dir.glob("*.tmp*")
puts "Залишкових тимчасових файлів: #{leftovers.size}"