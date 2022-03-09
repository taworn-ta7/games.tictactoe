use getch;
use itertools::Itertools;
use reqwest;

mod board;

fn choose_player_first() -> u8 {
    println!("Who move first? Press:");
    println!("  - 1: Player 1");
    //println!("  - 2: Player 2 (Computer)");
    println!("  - 2: Player 2");

    let getch = getch::Getch::new();
    loop {
        let input = getch.getch();
        if input.is_ok() {
            let input = input.unwrap();
            if input == 49 {
                println!("You choose '1': Player 1.");
                return board::PLAYER_1;
            } else if input == 50 {
                println!("You choose '2': Player 2.");
                return board::PLAYER_2;
            }
        }
    }
}

fn print_current_status(board: &board::Board) {
    println!("");
    println!("Current Board:");
    println!(
        "  First and Current: {}, {}",
        format_who_move(board.move_first),
        format_who_move(board.current)
    );
    println!("  History: {}", board.history);
    let v: Vec<u8> = board.move_list.to_vec();
    let joined = Itertools::join(&mut v.iter(), "-");
    println!("  MoveList: {}", joined);

    let r = board.move_list;
    println!(
        "  {}|{}|{}",
        board_data_to_ox(r[0]),
        board_data_to_ox(r[1]),
        board_data_to_ox(r[2])
    );
    println!("  -+-+-");
    println!(
        "  {}|{}|{}",
        board_data_to_ox(r[3]),
        board_data_to_ox(r[4]),
        board_data_to_ox(r[5])
    );
    println!("  -+-+-");
    println!(
        "  {}|{}|{}",
        board_data_to_ox(r[6]),
        board_data_to_ox(r[7]),
        board_data_to_ox(r[8])
    );
    println!("");
}

fn board_data_to_ox(moving: u8) -> String {
    if moving == board::PLAYER_1 {
        return String::from("O");
    } else if moving == board::PLAYER_2 {
        return String::from("X");
    } else {
        return String::from(" ");
    }
}

fn format_who_move(moving: u8) -> String {
    if moving == board::PLAYER_1 {
        return String::from("Player 1");
    } else if moving == board::PLAYER_2 {
        return String::from("Player 2");
    } else {
        return String::from("unknown player, valid=1,2");
    }
}

fn move_on_board(board: &mut board::Board) {
    let getch = getch::Getch::new();
    loop {
        println!("Which move? 1..9 valid");

        // get '1'..'9'
        let input = getch.getch();
        if input.is_ok() {
            let input = input.unwrap();
            if input >= 49 && input < 59 {
                let index = input - 49;
                if !board.move_to(index) {
                    println!("This move already taken or out of range! Choose another one.");
                } else {
                    return;
                }
            }
        }
    }
}

async fn call_http(first: u8, history: &String) -> reqwest::Result<String> {
    let uri = format!(
        "http://localhost:8080/ttt?first={}&history={}",
        first, history
    );
    let body = reqwest::get(uri).await?.text().await?;
    println!("body: {:?}", body);
    return reqwest::Result::Ok(body);
}

async fn auto_move(board: &mut board::Board) {
    loop {
        let body = call_http(board.move_first, &board.history).await;
        if body.is_ok() {
            // move
            let body = body.unwrap();
            let index = body.parse::<u8>();
            if index.is_ok() {
                let index = index.unwrap();
                println!("move from HTTP: {}", index);
                if !board.move_to(index) {
                    println!("This move already taken or out of range! Choose another one.");
                } else {
                    break;
                }
            }
        } else {
            //println!("HTTP error: {}", body.is_error);
        }
    }
}

fn run() {
    let who_first = choose_player_first();
    println!("Who first: {}", who_first);

    // create Tic-Tac-Toe board
    let mut board = board::new(who_first);

    // for game is not finish
    while !board.is_finished() {
        print_current_status(&board);
        if board.current == board::PLAYER_1 {
            // if player 1, get keyboard input from user
            move_on_board(&mut board);
        } else {
            // if player 2, computer, get HTTP
            //auto_move(&mut board).await;
            // FIXME:
            move_on_board(&mut board);
        }
    }

    print_current_status(&board);
    if board.state == board::State::WINNER {
        if board.current == board::PLAYER_1 {
            println!("{} Win ^_^", board_data_to_ox(board.current));
        } else {
            println!("{} Win Y_Y", board_data_to_ox(board.current));
        }
    } else {
        println!("Draw -_-");
    }
}

fn main() {
    run();
}
