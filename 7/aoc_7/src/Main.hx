import haxe.Int64;
import sys.io.File;

class Main {
    static public function main():Void {
        var args = Sys.args();
        if (args.length < 1) {
            Sys.println("Please provide a file path as an argument.");
            return;
        }

        var totalCalibrationResult = Int64.ofInt(0);
        var content = File.getContent(args[0]);

        for (line in content.split('\n')) {
            var parts = line.split(": ");
            if (parts.length != 2)
                continue;
            var targetValue = Int64.parseString(parts[0]);
            var numbers = parts[1].split(' ').map(
                function(str) {
                    var result = Int64.parseString(str);
                    return result;
                });

            if (canProduceTargetValue(numbers, targetValue))
            {
                totalCalibrationResult += targetValue;
            }
        }

        Sys.println('Total Calibration Result: $totalCalibrationResult');
    }

    static function canProduceTargetValue(
        numbers:Array<Int64>,
        targetValue:Int64):Bool
    {
        return evaluateWithOperators(numbers, targetValue, 0, numbers[0]);
    }

    static function evaluateWithOperators(
        numbers: Array<Int64>,
        targetValue:Int64,
        index:Int,
        currentValue:Int64):Bool
    {
        if (index == numbers.length - 1)
            return currentValue == targetValue;

        var nextNumber = numbers[index + 1];

        var concatenatedNumber = Int64.parseString('$currentValue$nextNumber');
        if (evaluateWithOperators(numbers, targetValue, index + 1, concatenatedNumber))
            return true;

        if (evaluateWithOperators(numbers, targetValue, index + 1, currentValue + nextNumber))
            return true;

        if (evaluateWithOperators(numbers, targetValue, index + 1, currentValue * nextNumber))
            return true;

        return false;
    }
}
