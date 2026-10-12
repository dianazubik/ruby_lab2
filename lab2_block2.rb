# Лабораторна робота №2. Варіант 18. Блок 2

matrix = [
  [1, 2, 3, 4],
  [5, 3, 8, 9],
  [2, 4, 6, 8],
  [9, 7, 5, 1],
  [3, 3, 4, 5]
]

puts "Матриця:"
matrix.each { |row| puts "  #{row.inspect}" }

# ===== Завдання 6: номери рядків, упорядкованих за збільшенням =====
puts "\n=== Завдання 6: рядки, впорядковані за збільшенням ==="

# Спосіб 1: цикл while
# Обґрунтування: кількість кроків заздалегідь невідома, перевірку рядка
# треба припинити, щойно знайдено порушення порядку. while дозволяє
# поєднати індекс і умову зупинки.
rows1 = []
i = 0
while i < matrix.length
  ordered = true
  j = 1
  while j < matrix[i].length && ordered
    ordered = false if matrix[i][j] <= matrix[i][j - 1]
    j += 1
  end
  rows1 << i + 1 if ordered
  i += 1
end
puts "Спосіб 1 (while):      #{rows1.inspect}"

# Спосіб 2: ітератори (each_index, select, each_cons, all?)
rows2 = matrix.each_index
              .select { |idx| matrix[idx].each_cons(2).all? { |a, b| a < b } }
              .map { |idx| idx + 1 }
puts "Спосіб 2 (ітератори):  #{rows2.inspect}"

# ===== Завдання 7: добуток максимальних елементів стовпців =====
puts "\n=== Завдання 7: добуток максимумів стовпців ==="

# Спосіб 1: цикл for
# Обґрунтування: кількість стовпців і рядків відома заздалегідь, перебір
# виконується по всьому діапазону без дострокового виходу, тому for
# з діапазоном 0...n найпростіший і найчитабельніший.
maxes1 = []
product1 = 1
for c in 0...matrix[0].length
  col_max = matrix[0][c]
  for r in 1...matrix.length
    col_max = matrix[r][c] if matrix[r][c] > col_max
  end
  maxes1 << col_max
  product1 *= col_max
end
puts "Спосіб 1 (for): максимуми = #{maxes1.inspect}, добуток = #{product1}"

# Спосіб 2: ітератори (transpose, map, reduce)
maxes2 = matrix.transpose.map(&:max)
product2 = maxes2.reduce(:*)
puts "Спосіб 2 (ітератори): максимуми = #{maxes2.inspect}, добуток = #{product2}"