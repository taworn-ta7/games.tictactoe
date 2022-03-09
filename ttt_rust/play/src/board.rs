/// Player 1 or 2.
pub const PLAYER_1: u8 = 1;
pub const PLAYER_2: u8 = 2;

/// State of current game.
#[derive(PartialEq)]
pub enum State {
	PLAYING = 0,
	WINNER = 1,
	DRAW = 2,
}

/// Other constants.
pub const BOARD_SIZE: u8 = 3;
pub const TOTAL_SIZE: u8 = BOARD_SIZE * BOARD_SIZE;

/// Board data.
pub struct Board {
	// move first
	pub move_first: u8,

	// current
	pub current: u8,

	// history moves
	pub history: String,

	// move list
	pub move_list: [u8; 9],

	// state
	pub state: State,
}

// ----------------------------------------------------------------------

/// Board implementation.
impl Board {
	/// Move current marker to board.
	pub fn move_to(&mut self, index: u8) -> bool {
		if !(index < TOTAL_SIZE) {
			return false;
		}

		// check with move_list to see it already move there
		if self.move_list[index as usize] > 0 {
			return false;
		}

		// add move
		self.history.push_str(&index.to_string());
		self.move_list[index as usize] = self.current as u8;

		// check move result
		if self.check_victory_state() {
			self.state = State::WINNER
		} else if self.check_draw_state() {
			self.state = State::DRAW
		} else {
			// next player
			if self.current == PLAYER_1 {
				self.current = PLAYER_2
			} else {
				self.current = PLAYER_1
			}
		}

		return true;
	}

	/// Finish move and can check result in State.
	pub fn is_finished(&self) -> bool {
		return self.state != State::PLAYING;
	}

	// ----------------------------------------------------------------------

	fn check_y_victory(&self, y: u8) -> bool {
		let mut x = 0;
		while x < BOARD_SIZE {
			let u = (y * BOARD_SIZE + x) as usize;
			if self.move_list[u] != self.current {
				return false;
			}
			x = x + 1;
		}
		println!("Player {} win with y={}", self.current, y);
		return true;
	}

	fn check_x_victory(&self, x: u8) -> bool {
		let mut y = 0;
		while y < BOARD_SIZE {
			let u = (y * BOARD_SIZE + x) as usize;
			if self.move_list[u] != self.current {
				return false;
			}
			y = y + 1;
		}
		println!("Player {} win with x={}", self.current, x);
		return true;
	}

	fn check_diagonal_victory(&self) -> bool {
		let mut i = 0;
		while i < BOARD_SIZE {
			let u = (i * BOARD_SIZE + i) as usize;
			if self.move_list[u] != self.current {
				return false;
			}
			i = i + 1;
		}
		println!("Player {} win with direct diagonal", self.current);
		return true;
	}

	fn check_diagonal_victory_reserse(&self) -> bool {
		let mut i = 0;
		while i < BOARD_SIZE {
			let u = (i * BOARD_SIZE + (BOARD_SIZE - i - 1)) as usize;
			if self.move_list[u] != self.current {
				return false;
			}
			i = i + 1;
		}
		println!("Player {} win with reverse diagonal", self.current);
		return true;
	}

	// ----------------------------------------------------------------------

	/// Check victory.
	pub fn check_victory_state(&self) -> bool {
		// check horizontal
		let mut y = 0;
		while y < BOARD_SIZE {
			if self.check_y_victory(y) {
				return true;
			}
			y = y + 1;
		}

		// check vertical
		let mut x = 0;
		while x < BOARD_SIZE {
			if self.check_x_victory(x) {
				return true;
			}
			x = x + 1;
		}

		// check diagonal
		if self.check_diagonal_victory() {
			return true;
		}
		if self.check_diagonal_victory_reserse() {
			return true;
		}

		return false;
	}

	/// Check draw.
	pub fn check_draw_state(&self) -> bool {
		for i in self.move_list {
			if i <= 0 {
				return false;
			}
		}
		return true;
	}
}

// ----------------------------------------------------------------------

pub fn new(move_first: u8) -> Board {
	if !(move_first >= PLAYER_1 && move_first <= PLAYER_2) {
		panic!("parameter moveFirst must be Player1 or Player2");
	}

	Board {
		move_first,
		current: move_first,
		history: String::from(""),
		move_list: [0, 0, 0, 0, 0, 0, 0, 0, 0],
		state: State::PLAYING,
	}
}
