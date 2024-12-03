import scala.io.Source
import scala.util.matching.Regex

def apply_regex(text: String): Int =
  var total = 0
  pattern.findAllIn(text).matchData foreach {
    m =>
      val mulOp = m.group(1).toInt * m.group(2).toInt
      println(mulOp)
      total += mulOp
  }
  return total

def task_1(): Unit =
  val stringText = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
  val fileText = Source.fromFile("input")
  var total = 0
  for line <- fileText.getLines() do
    total += apply_regex(line)
  println("Result: " + total)
  fileText.close()

def apply_regex_2(text: String): Int =
  var total = 0
  // var addToTotal = true
  pattern2.findAllIn(text).matchData foreach {
    m =>
      // println(m.toString + " " + m.subgroups)
      if m.subgroups(0) != null then
        val mulOp = m.group(1).toInt * m.group(2).toInt
        println(mulOp)
        if addToTotal then
          total += mulOp
      else
        if m.toString == "don't()" then
          println("DONT")
          addToTotal = false
        else if m.toString == "do()" then
          println("DO")
          addToTotal = true
  }
  return total

def task_2(): Unit =
  val stringText = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
  val fileText = Source.fromFile("input")
  var total = 0
  for line <- fileText.getLines() do
    total += apply_regex_2(line)
  // total += apply_regex_2(stringText)
  println("Result: " + total)

@main def hello(): Unit =
  println("--- TASK 1 ---")
  task_1()
  println("--- TASK 2 ---")
  task_2()

def pattern = """mul\((\d{1,3}),(\d{1,3})\)""".r
def pattern2 = """mul\((\d{1,3}),(\d{1,3})\)|do\(\)|don\'t\(\)""".r
var addToTotal = true
