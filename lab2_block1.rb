# Лабораторна робота №2. Варіант 18. Блок 1

numbers = [4, 7, 2, 9, 6, 2, 5, 8, 2, 10]
puts "Масив: #{numbers.inspect}"


puts "\n=== Завдання 8: добуток парних елементів ==="

# Спосіб 1: керуючі конструкції (while + if)
product1 = 1
found = false
i = 0
while i < numbers.length
  if numbers[i].even?
    product1 *= numbers[i]
    found = true
  end
  i += 1
end
if found
  puts "Спосіб 1 (while + if): #{product1}"
else
  puts "Спосіб 1: парних елементів немає"
end

# Спосіб 2: ітератори (select + reduce)
evens = numbers.select(&:even?)
if evens.empty?
  puts "Спосіб 2: парних елементів немає"
else
  puts "Спосіб 2 (select + reduce): #{evens.reduce(:*)}"
end


puts "\n=== Завдання 9: кількість мінімальних елементів ==="

# Спосіб 1: керуючі конструкції (while + if)
min_value = numbers[0]
i = 1
while i < numbers.length
  min_value = numbers[i] if numbers[i] < min_value
  i += 1
end

count1 = 0
i = 0
while i < numbers.length
  count1 += 1 if numbers[i] == min_value
  i += 1
end
puts "Спосіб 1 (while + if): мінімум = #{min_value}, кількість = #{count1}"

# Спосіб 2: ітератор (min + count з блоком)
min2 = numbers.min
count2 = numbers.count { |x| x == min2 }
puts "Спосіб 2 (min + count):  мінімум = #{min2}, кількість = #{count2}"