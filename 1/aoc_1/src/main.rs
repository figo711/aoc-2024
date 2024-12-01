use std::{
    fs::File,
    io::{self, BufRead},
    path::Path,
};

fn parse_input_file() -> io::Result<Vec<(i32, i32)>> {
    let path = Path::new("input");
    let file = File::open(&path)?;
    let reader = io::BufReader::new(file);

    let mut list_a: Vec<i32> = Vec::new();
    let mut list_b: Vec<i32> = Vec::new();

    for line in reader.lines() {
        let line = line?;
        let numbers: Vec<i32> = line
            .split_whitespace()
            .filter_map(|num| num.parse::<i32>().ok())
            .collect();

        if numbers.len() == 2 {
            list_a.push(numbers[0]);
            list_b.push(numbers[1]);
        }
    }

    list_a.sort();
    list_b.sort();

    let combined: Vec<(i32, i32)> = list_a
        .iter()
        .zip(list_b.iter())
        .map(|(&a, &b)| (a, b))
        .collect();

    Ok(combined)
}

fn do_task_one() {
    let combined = parse_input_file().unwrap();

    let mut sum: u32 = 0;
    for (a, b) in combined {
        let dist = a.abs_diff(b);

        // println!("{}", dist);

        sum += dist;
    }

    println!("Result: {} ", sum);
}

fn do_task_two() {
    let combined = parse_input_file().unwrap();

    let mut total_score = 0;
    for (a, _) in &combined {

        let mut score = 0;
        for (_, b) in &combined {
            if *a == *b {
                score += 1;
            }
        }

        total_score += score * (*a);
    }

    println!("Result: {}", total_score);
}

fn main() {
    println!("--- TASK #1 ---");
    do_task_one();

    println!("--- TASK #2 ---");
    do_task_two();
}
