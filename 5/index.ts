import * as fs from 'fs';

type Rule = {
    before: number;
    after: number;
};

type Book = {
    rules: Rule[];
    updates: number[][];
};

type Result = {
    correctSum: number;
    incorrectSum: number;
};

function parseInput(input: string): Book {
    const lines = input.trim().split('\n');
    const rules: Rule[] = [];
    const updates: number[][] = [];

    let parsingRules = true;

    for (const line of lines) {
        if (line.includes('|') && parsingRules) {
            const [before, after] = line.split('|').map(Number);
            rules.push({ before, after });
        } else if (line.includes(',')) {
            parsingRules = false;
            updates.push(line.split(',').map(Number));
        }
    }

    return { rules, updates };
}

function isValidUpdate(update: number[], rules: Rule[]): boolean {
    const applicableRules = rules.filter(rule =>
        update.includes(rule.before) && update.includes(rule.after)
    );

    for (const rule of applicableRules) {
        const beforeIndex = update.indexOf(rule.before);
        const afterIndex = update.indexOf(rule.after);

        if (beforeIndex > afterIndex) return false;
    }

    return true;
}

function getMiddlePage(pages: number[]): number {
    const middleIndex = Math.floor(pages.length / 2);
    return pages[middleIndex];
}

function findMiddlePageSum(validUpdates: number[][]): number {
    return validUpdates.reduce((sum, update) => {
        return sum + getMiddlePage(update);
    }, 0);
}

function findCorrectOrder(pages: number[], rules: Rule[]): number[] {
    const graph: Map<number, Set<number>> = new Map();
    const inDegree: Map<number, number> = new Map();

    pages.forEach(page => {
        graph.set(page, new Set());
        inDegree.set(page, 0);
    });

    rules.forEach(rule => {
        if (pages.includes(rule.before) && pages.includes(rule.after)) {
            graph.get(rule.before)?.add(rule.after);
            inDegree.set(rule.after, (inDegree.get(rule.after) || 0) + 1);
        }
    });

    const result: number[] = [];
    const queue: number[] = [];

    pages.forEach(page => {
        if ((inDegree.get(page) || 0) === 0) {
            queue.push(page);
        }
    });

    while (queue.length > 0) {
        const page = queue.shift()!;
        result.push(page);

        graph.get(page)?.forEach(neighbor => {
            inDegree.set(neighbor, (inDegree.get(neighbor) || 0) - 1);
            if ((inDegree.get(neighbor) || 0) === 0) {
                queue.push(neighbor);
            }
        });
    }

    return result;
}

function processManualUpdates(input: string): Result {
    const { rules, updates } = parseInput(input);

    let correctSum = 0;
    let incorrectSum = 0;

    updates.forEach(update => {
        if (isValidUpdate(update, rules)) {
            correctSum += getMiddlePage(update);
        } else {
            const correctedOrder = findCorrectOrder(update, rules);
            incorrectSum += getMiddlePage(correctedOrder);
        }
    });

    return { correctSum, incorrectSum };
}

const filePath = process.argv[2];
console.log(filePath);
const data = fs.readFileSync(filePath, 'utf8');

const result = processManualUpdates(data);
console.log("Sum of middle pages for correct updates:", result.correctSum);
console.log("Sum of middle pages for corrected updates:", result.incorrectSum);

