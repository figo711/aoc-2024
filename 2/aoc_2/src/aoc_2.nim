import strutils

#[
let test_data = dedent """7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9"""
]#

proc parseInputData(inputData: string): seq[seq[int]] =
    var lines = splitLines(inputData)
    var data: seq[seq[int]]
    for line in lines:
        var stringList = split(line)
        if stringList.len <= 1:
            continue
        var intList: seq[int] = newSeq[int](stringList.len)
        for i, s in stringList.pairs:
            intList[i] = parseInt(s)
        data.add(intList)
    return data

proc allInOneCheck(row: seq[int]): bool =
    var direction = 0
    for i in 0..row.len - 1:
        if i == row.len - 1:
            if direction == 0:
                return false
            break
        var diff = abs(row[i + 1] - row[i])
        if diff > 3 or diff < 1:
            return false
        if row[i] < row[i + 1]:
            if direction == 0 or direction == -1:
                direction = -1
            else:
                return false
        elif row[i] > row[i + 1]:
            if direction == 0 or direction == 1:
                direction = 1
            else:
                return false
    return true

proc task_one() =
    var realData = parseInputData(readFile("input"))
    # var parsedData = parseInputData(test_data)
    # echo(parsedData)
    var safeCount = 0
    for row in realData:
        if allInOneCheck(row):
            echo($row & " Safe")
            safeCount += 1
        else:
            echo($row & " Unsafe")
    echo("Safe count: " & $safeCount)
    echo("Total count: " & $realData.len)

proc getProblemIndex(row: seq[int]): int =
    var direction = 0
    for i in 0..row.len - 1:
        if i == row.len - 1:
            return -1
        var diff = abs(row[i + 1] - row[i])
        if diff > 3 or diff < 1:
            return i
        if row[i] < row[i + 1]:
            if direction == 0 or direction == -1:
                direction = -1
            else:
                return i
        elif row[i] > row[i + 1]:
            if direction == 0 or direction == 1:
                direction = 1
            else:
                return i
    return -1

proc tryApplyProblemDampener(row: seq[int]): bool =
    var problemIndex = getProblemIndex(row)
    # stdout.write("Problem Index: " & $problemIndex & "\n")
    if problemIndex != -1:
        var newRow1 = row
        var newRow2 = row
        newRow1.delete(problemIndex)
        newRow2.delete(problemIndex + 1)
        if allInOneCheck(newRow1):
            return true
        if allInOneCheck(newRow2):
            return true
    return false

proc task_two() =
    var parsedData = parseInputData(readFile("input"))
    var safeCount = 0
    for row in parsedData:
        if allInOneCheck(row):
            echo($row & " Safe")
            safeCount += 1
        elif tryApplyProblemDampener(row):
            echo($row & " Safe")
            safeCount += 1
        else:
            echo($row & " Unsafe")
    echo("Safe count: " & $safeCount)
    echo("Total count: " & $parsedData.len)

when isMainModule:
  echo("--- TASK #1 ---")
  task_one()
  echo("--- TASK #2 ---")
  task_two()
